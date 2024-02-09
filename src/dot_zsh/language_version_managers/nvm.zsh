export NVM_DIR="$HOME/.nvm"
# Load nvm without using it, the first time you need node, npm etc it will load it
# This improves shell start up time, but will make it slower the first time you need to use it
# # Remove `--no-use` if you want slower shell load times, but quicker first time use
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
