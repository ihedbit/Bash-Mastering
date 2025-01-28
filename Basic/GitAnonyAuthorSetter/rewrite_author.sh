#!/usr/bin/env bash

# -----------------------------------------------------
# Usage:
#    ./rewrite_author.sh <OLD_REPO_URL> <NEW_REPO_URL>
#
# Example:
#    ./rewrite_author.sh https://github.com/user/old-repo.git git@github.com:user/new-repo.git
#
# This script:
#   1. Clones the old repo in /tmp (temporary directory)
#   2. Rewrites all commits to use an "anonymous" author
#   3. Sets up the new remote
#   4. Force-pushes the rewritten history to the new remote
#   5. Cleans up the temporary repo automatically
# -----------------------------------------------------

OLD_REPO_URL="$1"
NEW_REPO_URL="$2"

# Check for correct usage
if [ -z "$OLD_REPO_URL" ] || [ -z "$NEW_REPO_URL" ]; then
  echo "Usage: $0 <OLD_REPO_URL> <NEW_REPO_URL>"
  exit 1
fi

# Clone the old repository into /tmp
TEMP_DIR=$(mktemp -d -t git-repo-XXXXXX)
echo "Cloning the repository into temporary directory: $TEMP_DIR"
git clone "$OLD_REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR" || { echo "Cloning failed or directory not found."; exit 1; }

# Rewrite author/committer for all commits
git filter-branch --env-filter '
  export GIT_AUTHOR_NAME="anonymous"
  export GIT_AUTHOR_EMAIL="anonymous@example.com"
  export GIT_COMMITTER_NAME="anonymous"
  export GIT_COMMITTER_EMAIL="anonymous@example.com"
' --tag-name-filter cat -- --all

# Remove the old remote and add the new one
git remote remove origin
git remote add origin "$NEW_REPO_URL"

# Force push the entire rewritten history
git push -f origin --all
git push -f origin --tags

# Clean up: Remove the temporary repository directory
echo "Cleaning up the temporary repository."
cd /tmp || exit
rm -rf "$TEMP_DIR"

echo "Done! The repository history has been rewritten with anonymous author info and pushed to $NEW_REPO_URL"
