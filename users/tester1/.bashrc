# ~/.bashrc — Comedy Edition

# ----------------------------
# Greeting
# ----------------------------
echo "Welcome, mighty terminal wizard 🧙"
echo "Today's mission: pretend to know what you're doing."
echo ""

# Random motivational quote
quotes=(
"Remember: It's not a bug, it's an undocumented feature."
"Have you tried turning it off and on again?"
"There are only 10 types of people: those who understand binary and those who don't."
"sudo make me a sandwich"
"One does not simply exit vim."
)

echo "${quotes[$RANDOM % ${#quotes[@]}]}"
echo ""

# ----------------------------
# Aliases (questionable but useful)
# ----------------------------
alias pls='sudo'
alias la='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias update='echo "Updating system..." && sleep 2 && echo "Just kidding. Do it yourself."'

# Dangerous commands with dramatic warnings
alias rm='echo "🔥 WHOA THERE. rm is dangerous." && rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ----------------------------
# Fake hacking mode
# ----------------------------
hack() {
    echo "Initializing hack.exe..."
    sleep 1
    echo "Bypassing firewall..."
    sleep 1
    echo "Accessing mainframe..."
    sleep 1
    echo "ERROR: Hollywood hacking module not found."
}

# ----------------------------
# Coffee command
# ----------------------------
coffee() {
    echo "Brewing coffee..."
    sleep 2
    echo "☕ Coffee not found. Please insert beans."
}

# ----------------------------
# Git encouragement
# ----------------------------
git() {
    command git "$@"
    echo "👍 Good job committing code that will break tomorrow."
}

# ----------------------------
# Exit message
# ----------------------------
function exit {
    echo "Logging off..."
    echo "Remember: The bug was probably your fault."
    builtin exit
}

# ----------------------------
# Typo helper
# ----------------------------
alias sl='echo "Did you mean ls? 🤨" && ls'

# ----------------------------
# Fortune (if installed)
# ----------------------------
if command -v fortune >/dev/null; then
    echo ""
    fortune
fi
