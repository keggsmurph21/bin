
## BEGIN CUSTOM ##

# system
alias la="ls -aF"
alias inet="ip address | grep inet"
alias bashrc="vi ~/.bashrc && . ~/.bashrc"

# volume control
alias vu="amixer sset Master 5%+ > /dev/null"
alias vd="amixer sset Master 5%- > /dev/null"
alias vm="amixer sset Master 0% > /dev/null"

# programming langs
alias node=nodejs
alias python=python3

# git
git_add_commit_push() {
  if [ -z "$1" ]; then
    echo "git commit: Please enter a commit message" >&2
    return 1
  fi
  gau && gc "$1" && gp
}

export alias "git!"=git_add_commit_push
export alias gs="git status"
export alias ga="git add"
export alias gaa="git add -A"
export alias gau="git add -u"
export alias gc="git commit -m"
export alias gco="git checkout"
export alias gb="git checkout -b"
export alias gp="git push"
export alias gpu="git push --set-upstream origin `git branch | grep \* | cut -d ' ' -f2`"

## END CUSTOM ##
