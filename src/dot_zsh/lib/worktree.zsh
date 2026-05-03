__wt_repo_name() {
  git worktree list --porcelain | head -1 | awk '{print $2}' | xargs basename
}

__wt_safe_branch() {
  echo "${1//\//-}"
}

__wt_path_for_branch() {
  git worktree list --porcelain | awk -v branch="$1" '
    /^worktree / { path = substr($0, 10) }
    /^branch /   { if (substr($0, 8) == "refs/heads/" branch) print path }
  '
}

wt() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "error: not a git repository" >&2
    return 1
  fi

  local base_dir="$HOME/.local/share/worktrees"
  local repo="$(__wt_repo_name)"
  local cmd="$1"
  shift 2>/dev/null

  case "$cmd" in
    add)
      local new_branch=0
      if [[ "$1" == "-b" ]]; then
        new_branch=1
        shift
      fi
      local branch="$1"
      if [[ -z "$branch" ]]; then
        echo "usage: wt add [-b] <branch>" >&2
        return 1
      fi
      local safe="$(__wt_safe_branch "$branch")"
      local wt_path="$base_dir/$repo/$safe"

      if [[ -d "$wt_path" ]]; then
        echo "worktree already exists, cd-ing into it"
        cd "$wt_path"
        return 0
      fi

      mkdir -p "$base_dir/$repo"
      if [[ "$new_branch" -eq 1 ]]; then
        git worktree add -b "$branch" "$wt_path" || return 1
      else
        git worktree add "$wt_path" "$branch" || return 1
      fi
      cd "$wt_path"
      ;;

    ls)
      git worktree list
      ;;

    rm)
      local branch="$1"
      if [[ -z "$branch" ]]; then
        if command -v fzf &>/dev/null; then
          branch=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||' | fzf --prompt="remove worktree: ")
          [[ -z "$branch" ]] && return 0
        else
          echo "usage: wt rm <branch>" >&2
          return 1
        fi
      fi
      local wt_path="$(__wt_path_for_branch "$branch")"
      if [[ -z "$wt_path" ]]; then
        echo "error: no worktree found for branch '$branch'" >&2
        return 1
      fi

      # cd out if we're inside the worktree being removed
      if [[ "$PWD" == "$wt_path"* ]]; then
        cd "$(git worktree list --porcelain | head -1 | awk '{print $2}')"
      fi

      git worktree remove "$wt_path"
      ;;

    cd)
      local branch="$1"
      if [[ -z "$branch" ]]; then
        if command -v fzf &>/dev/null; then
          branch=$(git worktree list --porcelain | grep '^branch' | sed 's|branch refs/heads/||' | fzf --prompt="worktree: ")
          [[ -z "$branch" ]] && return 0
        else
          echo "usage: wt cd <branch>" >&2
          return 1
        fi
      fi
      local wt_path="$(__wt_path_for_branch "$branch")"
      if [[ -z "$wt_path" ]]; then
        echo "error: no worktree found for branch '$branch'" >&2
        return 1
      fi

      cd "$wt_path"
      ;;

    root)
      cd "$(git worktree list --porcelain | head -1 | awk '{print $2}')"
      ;;

    *)
      echo "usage: wt <add|ls|rm|cd|root>"
      echo "  add [-b] <branch>  create worktree (cd into it)"
      echo "  ls                  list worktrees"
      echo "  rm [branch]         remove worktree (fzf if no arg)"
      echo "  cd [branch]         cd into worktree (fzf if no arg)"
      echo "  root                cd to main repo root"
      ;;
  esac
}
