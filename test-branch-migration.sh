#!/bin/bash

# Branch Migration Verification Test
# This script verifies that the branch migration has been set up correctly

set -e

echo "======================================"
echo "Branch Migration Verification"
echo "======================================"
echo ""

# Test 1: Check if branches exist
echo "Test 1: Checking if branches exist..."
if git show-ref --verify --quiet refs/heads/main; then
    echo "  ✓ main branch exists"
else
    echo "  ✗ main branch does NOT exist"
    exit 1
fi

if git show-ref --verify --quiet refs/heads/master; then
    echo "  ✓ master branch exists"
else
    echo "  ✗ master branch does NOT exist"
    exit 1
fi
echo ""

# Test 2: Check branch commit SHAs
echo "Test 2: Verifying branch commit SHAs..."
MAIN_SHA=$(git rev-parse --short main)
MASTER_SHA=$(git rev-parse --short master)

if [ "$MAIN_SHA" = "dfe4f2c" ]; then
    echo "  ✓ main branch is at correct commit: $MAIN_SHA"
else
    echo "  ✗ main branch is at wrong commit: $MAIN_SHA (expected dfe4f2c)"
    exit 1
fi

if [ "$MASTER_SHA" = "31122e9" ]; then
    echo "  ✓ master branch is at correct commit: $MASTER_SHA"
else
    echo "  ✗ master branch is at wrong commit: $MASTER_SHA (expected 31122e9)"
    exit 1
fi
echo ""

# Test 3: Check commit messages
echo "Test 3: Verifying commit messages..."
MAIN_MSG=$(git log -1 --format=%s main)
MASTER_MSG=$(git log -1 --format=%s master)

if [[ "$MAIN_MSG" == *"Merge branch 'presslabs:master'"* ]]; then
    echo "  ✓ main branch has correct commit message"
else
    echo "  ✗ main branch has unexpected commit message: $MAIN_MSG"
    exit 1
fi

if [ "$MASTER_MSG" = "prevent deprecation warnings" ]; then
    echo "  ✓ master branch has correct commit message"
else
    echo "  ✗ master branch has unexpected commit message: $MASTER_MSG"
    exit 1
fi
echo ""

# Test 4: Check if master points to tag 1.0.6
echo "Test 4: Verifying master points to tag 1.0.6..."
TAG_SHA=$(git rev-parse --short 1.0.6)
if [ "$MASTER_SHA" = "$TAG_SHA" ]; then
    echo "  ✓ master branch points to tag 1.0.6"
else
    echo "  ✗ master branch does NOT point to tag 1.0.6"
    exit 1
fi
echo ""

# Test 5: Check if documentation exists
echo "Test 5: Verifying documentation exists..."
if [ -f "BRANCH_MIGRATION_NOTES.md" ]; then
    echo "  ✓ BRANCH_MIGRATION_NOTES.md exists"
else
    echo "  ✗ BRANCH_MIGRATION_NOTES.md does NOT exist"
    exit 1
fi

if [ -f "PR_SUMMARY.md" ]; then
    echo "  ✓ PR_SUMMARY.md exists"
else
    echo "  ✗ PR_SUMMARY.md does NOT exist"
    exit 1
fi
echo ""

# Test 6: Check if migration script exists and is executable
echo "Test 6: Verifying migration script..."
if [ -f "migrate-branches.sh" ]; then
    echo "  ✓ migrate-branches.sh exists"
else
    echo "  ✗ migrate-branches.sh does NOT exist"
    exit 1
fi

if [ -x "migrate-branches.sh" ]; then
    echo "  ✓ migrate-branches.sh is executable"
else
    echo "  ✗ migrate-branches.sh is NOT executable"
    exit 1
fi
echo ""

# Summary
echo "======================================"
echo "All tests passed! ✓"
echo "======================================"
echo ""
echo "Branch structure is correctly set up:"
echo "  - main:   $MAIN_SHA (contains all user work)"
echo "  - master: $MASTER_SHA (mirrors upstream at tag 1.0.6)"
echo ""
echo "To complete the migration, run:"
echo "  ./migrate-branches.sh"
