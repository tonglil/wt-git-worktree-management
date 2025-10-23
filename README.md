# wt - Git Worktree Management Helper

A Bash-based command-line tool that simplifies Git worktree management with convenient shortcuts and additional functionality.

## Overview

`wt` is a wrapper around Git's worktree commands that provides:

- Simple aliases for common worktree operations
- Smart branch creation with customizable prefixes
- Automatic cleanup of worktrees with deleted upstream branches
- Directory switching with shell reload
- Bash completion support

## Features

- **Simplified Commands**: Short aliases for common Git worktree operations (`ls`, `rm`, `mv`, etc.)
- **Smart Branch Management**: Automatic branch prefixing and base branch selection
- **Cleanup Tools**: Identify and remove worktrees whose upstream branches have been deleted
- **Quick Navigation**: Switch between worktrees with automatic shell reloading
- **Enhanced Workflow**: `new` command creates worktrees with standardized naming conventions
- **Bash Completion**: Tab completion for commands, paths, and branches

## Installation

1. Clone or download the repository:
   ```bash
   git clone https://github.com/yourusername/wt-management.git
   cd wt-management
   ```

2. Make the script executable:
   ```bash
   chmod +x wt
   ```

3. Add to your PATH (choose one method):

   **Option A: Symlink to a directory in your PATH**
   ```bash
   ln -s $(pwd)/wt /usr/local/bin/wt
   ```

   **Option B: Add to PATH in your shell profile**
   ```bash
   echo 'export PATH="$PATH:'"$(pwd)"'"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

4. (Optional) Enable bash completion:
   ```bash
   echo 'source '"$(pwd)/wt-completion.bash" >> ~/.bash_profile
   source ~/.bash_profile
   ```

## Usage

### Basic Commands

All standard Git worktree commands are supported with shorter aliases:

```bash
wt list                    # List all worktrees
wt ls                      # Alias for list
wt add <path> [branch]     # Add a new worktree
wt remove <path>           # Remove a worktree
wt rm <path>               # Alias for remove
wt prune                   # Prune worktree information
wt move <source> <dest>    # Move a worktree
wt mv <source> <dest>      # Alias for move
wt lock <path>             # Lock a worktree
wt unlock <path>           # Unlock a worktree
wt repair                  # Repair worktree administrative files
```

### Enhanced Commands

#### `wt add` - Advanced Worktree Creation

Create worktrees with optional base branch specification:

```bash
# Create worktree with existing branch
wt add _w/feature-x feature-x

# Create new branch from origin/main
wt add _w/feature-y feature-y origin/main

# Create new branch from custom base
wt add _w/hotfix hotfix-123 origin/develop
```

**Syntax:** `wt add <path> [<branch>] [<base-branch>]`

When a base branch is specified and the target branch doesn't exist, it will be created from the base branch.

#### `wt new` - Quick Worktree Creation

Create a new worktree with automatic branch prefixing:

```bash
wt new my-feature
# Creates: _w/my-feature with branch tl/my-feature from origin/main
```

This command:
- Creates a worktree in `_w/<branch-name>`
- Automatically prefixes the branch with `tl/`
- Bases the new branch on `origin/main`
- Switches to the new worktree directory
- Reloads your shell environment

#### `wt use` - Switch Worktrees

Navigate to an existing worktree and reload your shell:

```bash
wt use _w/my-feature
```

This command changes directory and executes a new login shell, ensuring all environment variables and configurations are properly loaded.

#### `wt del` - Delete Worktree and Branch

Remove a worktree and delete its associated branch:

```bash
wt del _w/my-feature
```

This is more thorough than `wt rm` as it also removes the Git branch.

#### `wt gone` - List Stale Worktrees

Show worktrees whose upstream branches have been deleted:

```bash
wt gone
```

Output format:
```
/path/to/worktree    abc12345 [branch-name]
```

#### `wt cleanup` - Remove Stale Worktrees

Remove worktrees whose upstream branches no longer exist:

```bash
# Dry run (preview what would be removed)
wt cleanup --dry-run
wt cleanup -n

# Actually remove worktrees (prompts for confirmation)
wt cleanup
```

This is useful for cleaning up after branches have been merged and deleted on the remote.

## Workflow Examples

### Starting a New Feature

```bash
# Create a new feature worktree
wt new user-authentication

# You're now in _w/user-authentication with branch tl/user-authentication
# Do your work...
git add .
git commit -m "Add user authentication"
git push -u origin tl/user-authentication
```

### Working with Multiple Features

```bash
# List all worktrees
wt ls

# Switch between worktrees
wt use _w/feature-a
wt use _w/feature-b
```

### Cleaning Up After Merge

```bash
# After your PR is merged and branch deleted on remote
wt gone              # See which worktrees can be cleaned up
wt cleanup           # Remove them after confirmation
```

### Custom Base Branch

```bash
# Create a hotfix from production branch
wt add _w/hotfix-123 hotfix-123 origin/production
```

## Bash Completion

The included `wt-completion.bash` provides intelligent tab completion for:

- Command names
- Worktree paths (context-aware based on command)
- Branch names (for `add` command)
- Remote branches (for base branch parameter)
- Command flags and options

## Configuration

The tool uses these conventions by default:

- **Worktree directory**: `_w/` (relative to repository root)
- **Branch prefix**: `tl/` (customizable by editing the `new` function)
- **Default base branch**: `origin/main`

To customize, edit the `wt` script:
- Branch prefix: Modify line 224 (`prefixed_branch="tl/${branch_name}"`)
- Worktree directory: Modify line 228 (`worktree_path="${repo_root}/_w/${branch_name}"`)
- Default base branch: Modify line 231 (`origin/main`)

## Requirements

- Bash 4.0 or later
- Git 2.5 or later (for worktree support)
- Standard Unix utilities (sed, grep, etc.)

## Troubleshooting

**Problem**: `wt: command not found`
**Solution**: Ensure the `wt` script is in your PATH and is executable.

**Problem**: Bash completion not working
**Solution**: Verify `wt-completion.bash` is sourced in your shell profile and restart your shell.

## See Also

- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [CHANGELOG.md](CHANGELOG.md) - Recent updates and changes

## License

This project is provided as-is for personal use and modification.
