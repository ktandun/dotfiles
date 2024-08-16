export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

alias tunnel='ssh -D 8001 -q -C -N ubuntu@140.238.207.231'
alias ddd='dbmate drop && dbmate up'
alias sss='PGUSER=kenzietandun PGDATABASE=kenzietandun gleam run -m squirrel'
alias bbb='gleam run -m birdie'
alias fff='gleam format src test'
