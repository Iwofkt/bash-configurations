echo -e "\033[1;32m----------------------------------------\033[0m"

# Home stats
files=$(ls -1A "$HOME" | wc -l)
echo -e "\033[1;36mFiles in home:\033[0m $files"

# Last login
last_login=$(last -n 1 $USER | head -n1)
echo -e "\033[1;36mLast login:\033[0m $last_login"

# Uptime
uptime_human=$(uptime -p)
echo -e "\033[1;36mSystem uptime:\033[0m $uptime_human"

# Display random quote
quote

echo -e "\033[1;32m----------------------------------------\033[0m"

# Wait 5 seconds but allow skipping
echo -e "\033[1;33mPress 'q' to skip...\033[0m"
read -t 5 -n 1 key
if [[ $key == "q" ]]; then
    echo "Skipped wait!"
fi

clear
