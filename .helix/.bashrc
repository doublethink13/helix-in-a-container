# PYENV
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# GO
export PATH="${PATH}:/usr/local/go/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"

# ALIASES
alias ls="ls -la --color=auto"
alias lsr="ls -R"
alias z="zellij options --copy-command='xclip -selection clipboard'"
alias t="tree -I '__pycache__|.git|venv'"

# GIT
git config --global --add safe.directory /workspaces/*

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="\u \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch) \[\e[00m\]$ "

git config --global user.name "doublethink13"
git config --global user.email "eduardoaemunoz@gmail.com"

