# Changelog

## Updated Features

### `wt add` Command Enhancement
The `wt add` command now supports an optional third parameter to specify the remote branch to base the new branch on.

**Usage:**
```bash
wt add <path> [<branch>] [<base-branch>]
```

**Examples:**
```bash
# Create a new worktree with an existing branch
wt add _w/feature-x feature-x

# Create a new worktree with a new branch based on origin/main
wt add _w/feature-y feature-y origin/main

# Create a new worktree with a new branch based on origin/develop
wt add _w/hotfix hotfix-123 origin/develop
```

When the base branch parameter is provided and the branch doesn't exist, it will be created from the specified base branch.

### `wt new` Command Enhancement
The `wt new` command now defaults to creating new branches from `origin/main` instead of the current branch.

**Behavior:**
- Creates a new worktree in the `_w/` directory
- Automatically prefixes the branch name with `tl/`
- **Now defaults to branching from `origin/main`**

**Example:**
```bash
wt new my-feature
# Creates: _w/my-feature with branch tl/my-feature based on origin/main
```

## Technical Details

### Implementation Changes

1. **`wt add` command** (`wt:227-249`):
   - Added logic to detect when three arguments are provided
   - Checks if the specified branch already exists
   - If branch doesn't exist, creates it from the specified base branch
   - Falls back to standard `git worktree add` behavior for other usage patterns

2. **`wt new` command** (`wt:205-206`):
   - Modified to explicitly specify `origin/main` as the base branch
   - Updated console output to indicate the base branch being used

3. **Bash completion** (`wt-completion.bash:43-61`):
   - Enhanced to provide intelligent suggestions for the new parameters
   - Suggests existing branches for the second parameter
   - Suggests remote branches for the third parameter (base branch)

## Compatibility
These changes are backward compatible. Existing usage patterns continue to work as before:
- `wt add` with standard git worktree parameters still works
- `wt new` continues to create branches with the `tl/` prefix

## Benefits
- More explicit control over branch creation origins
- Consistent branching from `origin/main` for new features
- Flexibility to base branches on different remote branches when needed
- Better alignment with typical Git workflow practices