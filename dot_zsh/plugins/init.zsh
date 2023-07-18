# Install plugins using antidote, see https://getantidote.github.io/install for custom installation

# Set antidote to use easier to read names for plugin directories
zstyle ':antidote:bundle' use-friendly-names 'yes'

# Set the name of the static .zsh plugins file antidote will generate.
ZSH_PLUGINS="$ZSH_DIR/plugins/zsh_plugins.zsh"

# Ensure you have a .zsh_plugins.txt file where you can add plugins.
# If one doesn't exist, create it
[[ -f ${ZSH_PLUGINS:r}.txt ]] || touch ${ZSH_PLUGINS:r}.txt

# Lazy-load antidote.
fpath+=("$ZSH_DIR/plugins/antidote")
autoload -Uz $fpath[-1]/antidote

# Generate static file in a subshell when .zsh_plugins.txt is updated.
if [[ ! $ZSH_PLUGINS -nt ${ZSH_PLUGINS:r}.txt ]]; then
  (antidote bundle <${ZSH_PLUGINS:r}.txt >|$ZSH_PLUGINS)
fi

# Source your static plugins file.
. $ZSH_PLUGINS
