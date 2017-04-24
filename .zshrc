
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git npm)
source $ZSH/oh-my-zsh.sh
export LANG=en_US
export NVM_DIR="$HOME/.nvm"
. $NVM_DIR/nvm.sh
export PATH=$PATH:$HOME/.composer/vendor/bin:/usr/local/sbin
fpath=($HOME/.oh-my-zsh/completion $fpath)
. $HOME/.oh-my-zsh/plugins/z/z.sh
. $HOME/.aliases
