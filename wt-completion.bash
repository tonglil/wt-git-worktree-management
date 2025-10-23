#!/bin/bash

# Bash completion for wt command

_wt_completion() {
    local cur prev commands
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Available wt commands
    commands="list ls add remove rm prune move mv lock unlock repair gone cleanup use new help"

    # If we're completing the first argument (the command)
    if [ $COMP_CWORD -eq 1 ]; then
        COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
        return 0
    fi

    # Get the command (first argument)
    local command="${COMP_WORDS[1]}"

    case "$command" in
        remove|rm)
            # Complete with worktree paths (excluding the main worktree)
            local worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | sed 's/^worktree //' | tail -n +2)
            COMPREPLY=( $(compgen -W "$worktrees" -- "$cur") )
            ;;
        use)
            # Complete with all worktree paths
            local worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | sed 's/^worktree //')
            COMPREPLY=( $(compgen -W "$worktrees" -- "$cur") )
            ;;
        move|mv)
            # For move, complete with worktree paths for the first arg, then directories for second
            if [ $COMP_CWORD -eq 2 ]; then
                local worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | sed 's/^worktree //' | tail -n +2)
                COMPREPLY=( $(compgen -W "$worktrees" -- "$cur") )
            else
                COMPREPLY=( $(compgen -d -- "$cur") )
            fi
            ;;
        lock|unlock)
            # Complete with worktree paths
            local worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree " | sed 's/^worktree //')
            COMPREPLY=( $(compgen -W "$worktrees" -- "$cur") )
            ;;
        add)
            # Complete with directories for path, then branches for optional parameters
            if [ $COMP_CWORD -eq 2 ]; then
                # First argument: directory for worktree path
                COMPREPLY=( $(compgen -d -- "$cur") )
            elif [ $COMP_CWORD -eq 3 ]; then
                # Second argument: branch name (suggest existing branches)
                local branches=$(git branch -a 2>/dev/null | sed 's/^[* ]*//' | sed 's/^remotes\///')
                COMPREPLY=( $(compgen -W "$branches" -- "$cur") )
            elif [ $COMP_CWORD -eq 4 ]; then
                # Third argument: base branch (suggest remote branches)
                local remote_branches=$(git branch -r 2>/dev/null | sed 's/^[* ]*//')
                COMPREPLY=( $(compgen -W "$remote_branches" -- "$cur") )
            elif [[ "$cur" == -* ]]; then
                COMPREPLY=( $(compgen -W "-b --detach -B --force --lock --reason" -- "$cur") )
            else
                COMPREPLY=( $(compgen -d -- "$cur") )
            fi
            ;;
        new)
            # No completion needed for new branch names
            COMPREPLY=()
            ;;
        *)
            # Default to directory completion
            COMPREPLY=( $(compgen -d -- "$cur") )
            ;;
    esac

    return 0
}

# Register the completion function
complete -F _wt_completion wt
