# This file is managed by Puppet; All changes will be undone

fpath+=$HOME/.oh-my-zsh/custom/pure

autoload -U promptinit; promptinit

# optionally define some options
PURE_CMD_MAX_EXEC_TIME=10

# change the color for both `prompt:success` and `prompt:error`
zstyle ':prompt:pure:prompt:*' color cyan

# turn on git stash status
zstyle :prompt:pure:git:stash show yes

prompt pure
