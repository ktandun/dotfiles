export DOTNET_CLI_TELEMETRY_OPTOUT=1

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

alias anime='bash ~/dev/nyaa-up/run.sh'
alias animeedit='nvim ~/dev/nyaa-up/run.sh'
alias bbb='gleam run -m birdie'
alias ddd='dbmate drop && dbmate up'
alias dev='cd ~/dev && cd $(fd -d 1 | fzf)'
alias fff='gleam format src test'
alias g='git'
alias ll='ls -alh --color'
alias ls='ls --color'
alias n='nvim'
alias s='source venv/bin/activate'
alias sing='streamlink https://twitch.tv/singsing best'
alias sss='PGUSER=kenzietandun PGDATABASE=kenzietandun gleam run -m squirrel'
alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
alias tunnel='ssh -D 8001 -q -C -N ubuntu@140.238.207.231'
alias v0='osascript -e "set volume 0"'
alias v1='osascript -e "set volume 1"'
alias v2='osascript -e "set volume 2"'
alias v3='osascript -e "set volume 3"'
alias v4='osascript -e "set volume 4"'
alias v5='osascript -e "set volume 5"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ignore case when autocompleting
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# bun completions
[ -s "/Users/kenzietandun/.bun/_bun" ] && source "/Users/kenzietandun/.bun/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
