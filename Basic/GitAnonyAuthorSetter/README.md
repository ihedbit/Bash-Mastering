# Rewrite Author Script

This script automates the process of rewriting the author and committer information for all commits in a Git repository. It clones an existing repository, rewrites the commit history with new author information, and pushes the rewritten history to a new repository. The script ensures cleanliness by using a temporary directory (`/tmp`) to store the cloned repository, which is automatically removed after the process is complete.

## Features

- Rewrites the author and committer information for all commits in a Git repository.
- Pushes the rewritten commit history to a new Git repository.
- Uses a temporary directory (`/tmp`) for the cloned repository to keep your system clean.
- Automatically cleans up after execution.

## Requirements

- Bash (Linux/macOS)
- Git installed and available in your `$PATH`

## Usage

```bash
./rewrite_author.sh <OLD_REPO_URL> <NEW_REPO_URL>
```

### Example

```bash
./rewrite_author.sh https://github.com/user/old-repo.git git@github.com:user/new-repo.git
```

This command will:
1. Clone the repository from `https://github.com/user/old-repo.git` into a temporary directory.
2. Rewrite the commit history to replace the author and committer information with:
   - **Name**: `anonymous`
   - **Email**: `anonymous@example.com`
3. Push the rewritten commit history to the new repository `git@github.com:user/new-repo.git`.
4. Clean up the temporary directory.

## Script Details

### Steps Performed by the Script:
1. Clone the old repository into a temporary directory:
   - A unique directory is created under `/tmp`.
2. Rewrite the commit history:
   - Uses `git filter-branch` to update the `GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_NAME`, and `GIT_COMMITTER_EMAIL` for all commits.
3. Add the new repository as the remote:
   - Removes the old `origin` remote and adds the new remote URL.
4. Push the rewritten history:
   - Force-pushes all branches and tags to the new repository.
5. Clean up:
   - Deletes the temporary directory to keep your system tidy.

## Notes

- **Force Push**: The script uses `git push -f` to push the rewritten history. Be cautious as this will overwrite the history in the new repository.
- **Preserves Commit Messages and Dates**: Only the author and committer information is updated. Commit messages and dates remain unchanged.
- **Rewriting History**: This process changes commit SHAs, so it’s not compatible with repositories that have already been shared without rewriting.

## License

This script is open-source and free to use. Modify it as needed for your personal or organizational needs.

## Contributing

If you find a bug or have suggestions for improvement, feel free to submit an issue or pull request.

