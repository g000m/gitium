#!/bin/bash

# Branch Migration Script
# This script completes the branch migration by pushing the new branches to origin

set -e

echo "=================================="
echo "Branch Migration Script"
echo "=================================="
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "ERROR: Not in a git repository"
    exit 1
fi

# Display current branch structure
echo "Current local branch structure:"
git branch -vv
echo ""

# Confirm the branches exist
if ! git show-ref --verify --quiet refs/heads/main; then
    echo "ERROR: main branch does not exist"
    exit 1
fi

if ! git show-ref --verify --quiet refs/heads/master; then
    echo "ERROR: master branch does not exist"
    exit 1
fi

echo "Branches found:"
echo "  - main:   $(git rev-parse --short main) - $(git log -1 --format=%s main)"
echo "  - master: $(git rev-parse --short master) - $(git log -1 --format=%s master)"
echo ""

# Warn about force push
echo "⚠️  WARNING: This script will:"
echo "  1. Push the new 'main' branch to origin"
echo "  2. Force push 'master' branch to origin (rewriting history)"
echo ""
read -p "Do you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Pushing branches to origin..."

# Push main branch
echo "Pushing main branch..."
if git push origin main; then
    echo "✓ main branch pushed successfully"
else
    echo "✗ Failed to push main branch"
    exit 1
fi

# Force push master branch
echo "Force pushing master branch..."
if git push --force origin master; then
    echo "✓ master branch force pushed successfully"
else
    echo "✗ Failed to push master branch"
    exit 1
fi

echo ""
echo "=================================="
echo "Branch migration completed!"
echo "=================================="
echo ""
echo "Branch structure on origin:"
git ls-remote --heads origin | grep -E '(main|master)$'
