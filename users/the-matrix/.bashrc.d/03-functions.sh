typewrite() {
    text="$1"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep 0.03
    done
    echo
}

loading_bar() {
    text="$1"
    echo -ne "$text ["
    for i in {1..20}; do
        echo -ne "#"
        sleep 0.05
    done
    echo "] DONE"
}

hack() {
    target=${1:-"target"}

    echo -e "\033[1;32m"

    typewrite "Initializing cyber attack..."
    sleep 0.7

    typewrite "Target acquired: $target"
    sleep 0.7

    typewrite "Scanning network nodes..."
    loading_bar "Scanning"
    sleep 0.5

    typewrite "Tracing IP address..."
    fake_ip="$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"
    typewrite "IP FOUND: $fake_ip"
    sleep 0.6

    typewrite "Bypassing firewall..."
    loading_bar "Firewall bypass"
    sleep 0.6

    typewrite "Injecting payload..."
    loading_bar "Payload upload"
    sleep 0.6

    typewrite "Cracking password hashes..."
    for i in {1..5}; do
        echo "Attempt $i: $(tr -dc A-F0-9 </dev/urandom | head -c 16)"
        sleep 0.4
    done

    sleep 0.5
    typewrite "Password cracked."
    sleep 0.5

    typewrite "Access granted."
    sleep 0.5

    typewrite "Welcome to $target's system."

    echo -e "\033[0m"
}
quote() {
    # pick a random quote safely
    if [[ -n "${quotes[*]}" && ${#quotes[@]} -gt 0 ]]; then
        quote="${quotes[$RANDOM % ${#quotes[@]}]}"
    else
        echo "No quotes available!"
        return
    fi

    # determine width of the box
    width=60
    padding=4
    # wrap the quote if it's longer than width
    lines=()
    while [[ -n "$quote" ]]; do
        lines+=("${quote:0:$width}")
        quote="${quote:$width}"
    done

    # print top border
    echo -e "\033[1;33m┌$(printf '─%.0s' $(seq 1 $((width + padding*2))))┐\033[0m"

    # print each line centered
    for line in "${lines[@]}"; do
        line_length=${#line}
        left_pad=$(( (width - line_length) / 2 + padding ))
        right_pad=$(( width - line_length - (left_pad - padding) + padding ))
        printf "\033[1;33m│%*s%s%*s│\033[0m\n" $left_pad "" "$line" $right_pad ""
    done

    # print bottom border
    echo -e "\033[1;33m└$(printf '─%.0s' $(seq 1 $((width + padding*2))))┘\033[0m"
}


git_branch() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        dirty=$(git diff --quiet --ignore-submodules HEAD 2>/dev/null || echo "*")
        if [[ "$branch" == "HEAD" ]]; then
            echo " (\[\033[1;31m\]DETACHED\[\033[1;35m\]$dirty)"  # red detached
        else
            echo " ($branch$dirty)"
        fi
    fi
}

# Show dirty marker if repo has changes
git_dirty() {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null || echo "*"
}
