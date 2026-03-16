# Always load quotes first
[ -r ~/.bashrc.d/quotes.sh ] && source ~/.bashrc.d/quotes.sh

# Then source everything else
for file in ~/.bashrc.d/*.sh; do
    [ -r "$file" ] && source "$file"
done
export PATH=/home/simjo878/development/flutter/bin:$PATH
export PATH="$PATH:$HOME/bin"
