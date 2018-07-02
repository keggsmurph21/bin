export PS1="\u \w$ "

alias ls="ls -aFG"
alias inet="ifconfig | grep inet"
alias bashrc="vi ~/.bash_profile && . ~/.bash_profile"

alias python=python3

alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gau="git add -u"
alias gc="git commit -m"
alias gco="git checkout"
alias gb="git checkout -b"
alias gp="git pull && git push"
alias gpu="git push --set-upstream origin `git branch | grep \* | cut -d ' ' -f2`"
