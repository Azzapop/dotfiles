#!/usr/bin/zsh

### Display strings

GIT_STAGED_STRING="●"
GIT_UNSTAGED_STRING="●"
GIT_UNTRACKED_STRING="●"
GIT_AHEAD_STRING="▲"
# not currently used
GIT_BEHIND_STRING="▼"

### Helper functions
#
# Assorted functions used to determine when to display info

_git_working_tree() {
  return [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]
}

# not currently used
_git_commit_hash() {
  if [ -d .git ]; then
    git rev-parse HEAD | cut -c -8
  fi
}

# TODO bug here that still shows untracked after staged
# check if untracked files exist
_git_untracked() {
  return _git_working_tree && git status --porcelain | grep -m 1 '^??' &>/dev/null
}

# check if local is ahead on commits
_git_ahead() {
  return _git_working_tree && \
          git status --porcelain -b 2> /dev/null | grep '^## .*ahead' &> /dev/null
}

# use a neutral color, otherwise colors will vary according to time.
_git_time_since_commit() {
# Only proceed if there is actually a commit.
  if git log -1 > /dev/null 2>&1; then
    # Get the last commit.
    last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit/60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$(($seconds_since_last_commit/86400))
    sub_hours=$(($hours%24))
    sub_minutes=$(($minutes%60))

    if [ $hours -gt 24 ]; then
      commit_age="${days}d"
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${$sub_minutes}m"
    else
      commit_age="${minutes}m"
    fi
    echo ${commit_age}

    return $commit_age
  fi
}

### vcs_info functions
#
# These functions all modify the vcs_info vars in some way

_git_branch() {
  # wrap in white
  hook_com[branch]="%F{15}${hook_com[branch]}%f"
}

_git_unstaged() {
  # wrap in orange
  hook_com[unstaged]="%F{172}${hook_com[unstaged]}%f"

  # Untracked changes; wrap in red
  # Hack unstaged rather than misc so that untracked appears first in the list
  if _git_untracked; then;
	  hook_com[unstaged]="%F{9}${GIT_UNTRACKED_STRING}%f${hook_com[unstaged]}"
  fi
}

_git_staged() {
  # wrap in green
  hook_com[staged]="%F{10}${hook_com[staged]}%f"
}

_git_misc() {
  local _misc=""

  # wrap in cyan
  if _git_ahead; then; _misc="${_misc}%F{14}${GIT_AHEAD_STRING}%f"; fi

  # TODO get this working
  #_misc="${_misc} ${_git_time_since_commit}"

  hook_com[misc]=$_misc
}

_git_action() {
# format for action (%F{13}(%a)%f)
  if (( $hook_com[action] )); then;
          hook_com[action]=" / %F{13}(${hook_com[action]})%f"
  fi
}

# Put them all together for use in hook
+vi-git-hooks() {
  # wrap branch with styling
  _git_branch
  # wrap unstaged with styling
  _git_unstaged
  # wrap staged with styling
  _git_staged
  # load extra info in misc
  _git_misc
  # wrap action with styling
  _git_action
}

### vcs_info
#
# Configure and init vcs_info for use in prompt

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
# %b: branch name
# %u: unstaged changes
# %c: staged changes
# %m: miscellanous, used to set ahead/behind/untracked, see git-misc
# %a: action, rebase/merge etc
local git_prompt_format="[%b %u%c%m%a]"
# If an override is set, use that instead for the format
if (( ${+GIT_PROMPT_FORMAT} )); then
	git_prompt_format="$GIT_PROMPT_FORMAT"
fi
# set the same format for all types
zstyle ':vcs_info:git:*' formats $git_prompt_format
zstyle ':vcs_info:git:*' actionformats $git_prompt_format
zstyle ':vcs_info:git:*' branchformats $git_prompt_format
zstyle ':vcs_info:*' nvcsformats '' 
# this makes %u work, but also the prompt is clearly slower in git dirs when this is on
zstyle ':vcs_info:*' check-for-changes true
# what string to use for %u when there are unstaged changes
zstyle ':vcs_info:*' unstagedstr $GIT_UNSTAGED_STRING
# what string to use for %c when there are staged changes
zstyle ':vcs_info:*' stagedstr $GIT_STAGED_STRING
# vcs_info supports multiple version control systems, but I need just git
zstyle ':vcs_info:*' enable git
# formatting for all replacement strings
zstyle ':vcs_info:git*+set-message:*' hooks git-hooks
