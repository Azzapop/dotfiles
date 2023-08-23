#!/usr/bin/zsh

### Display strings

GIT_STAGED_STRING="●"
GIT_UNSTAGED_STRING="●"
GIT_UNTRACKED_STRING="●"
GIT_AHEAD_STRING="▲"
GIT_BEHIND_STRING="▼"
GIT_DIVERGED_STRING="Ð"
GIT_STASHED_STRING="š"

### Helper functions
#
# Assorted functions used to determine when to display info

# not currently used
_git_commit_hash() {
  if [ -d .git ]; then
    git rev-parse HEAD | cut -c -8
  fi
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

# Hook into vcs info and add styling + additional info
# Some settings adapted with the help of bureau.zsh_theme
# https://github.com/ohmyzsh/ohmyzsh/blob/0dc40e88a3f5bbe2607d958b5f0bf79e9df0c118/themes/bureau.zsh-theme#L27
+vi-git-hooks() {
  local result gitstatus
  gitstatus="$(command git status --porcelain -b 2>/dev/null)"

  # check status of files
  local gitfiles="$(tail -n +2 <<< "$gitstatus")"


  # wrap branch name in white
  hook_com[branch]="%F{15}${hook_com[branch]}%f"


  # wrap unstaged changes in yellow
  hook_com[unstaged]="%F{11}${hook_com[unstaged]}%f"

  # Untracked changes; wrap in red
  # Hack unstaged rather than misc so that untracked appears first in the list
  if [[ -n "$gitfiles" ]]; then
    if [[ "$gitfiles" =~ $'(^|\n)\\?\\? ' ]]; then
      hook_com[unstaged]="%F{9}${GIT_UNTRACKED_STRING}%f${hook_com[unstaged]}"
    fi
  fi

  # wrap staged changes in green
  hook_com[staged]="%F{10}${hook_com[staged]}%f"

  # load extra info in misc
  local _misc=""
  if [[ "$gitbranch" =~ '^## .*ahead' ]]; then
    # wrap ahead status in cyan
    _misc="${_misc}%F{14}${GIT_AHEAD_STRING}%f"
  fi
  if [[ "$gitbranch" =~ '^## .*behind' ]]; then
    # wrap behind in pink
    _misc="${_misc}%F{219}$GIT_BEHIND_STRING%f"
  fi
  if [[ "$gitbranch" =~ '^## .*diverged' ]]; then
    # wrap diverged in magenta
    _misc="${misc}%F{165}$GIT_DIVERGED_STRING%f"
  fi
  if command git rev-parse --verify refs/stash &> /dev/null; then
    # wrap stashed in orange
    _misc="${misc}%F{172}$GIT_STASHED_STRING%f"
  fi

  hook_com[misc]=$_misc

  # wrap action with styling
  if (( $hook_com[action] )); then;
    hook_com[action]=" / %F{13}(${hook_com[action]})%f"
  fi
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
