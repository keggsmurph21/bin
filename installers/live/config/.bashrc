
## BEGIN CUSTOM ##

# system
alias la="ls -aF"
alias inet="ip address | grep inet"

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
  }
  gau && gc "$1" && gp
}

alias "git!"=git_add_commit_push
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gau="git add -u"
alias gc="git commit -m"
alias gco="git checkout"
alias gb="git checkout --branch"
alias gp="git push"
alias gpu="git push --set-upstream origin `git branch | grep \* | cut -d ' ' -f2`"

## END CUSTOM ##
