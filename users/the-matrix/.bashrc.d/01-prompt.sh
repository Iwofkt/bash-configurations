parse_git_branch() {
    # Only output branch if we're in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return
    git branch 2>/dev/null | grep "*" | sed 's/* //'
}
PS1="\[\033[1;32m\]┌─(\u@\h)─[\[\033[1;36m\]\w\[\033[1;35m\]\$(git_branch)\[\033[1;33m\] | \t\[\033[1;32m\]]\n└─$ \[\033[0m\]"
