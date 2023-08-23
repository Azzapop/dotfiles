#!/usr/bin/zsh

# some great resources:
# zsh docs (multiple chapters): https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# epic blog post: https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
# color cheat sheet: https://jonasjacek.github.io/colors/
# git stuff: https://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html

# Contains useful helpers for the git prompt
. "$ZSH_DIR/prompt/git-helpers.zsh"

# Explaining prompt:
#
# %F{n}: begin color
# %f: end color
# %n~: display n latest directories of current directory
# %#: display a '%' (or '#' when root)
# %n@%m: user@host
PROMPT='%F{12}%3~%f %n %# '

# right side of shell, display git info
RPROMPT='${vcs_info_msg_0_}'
