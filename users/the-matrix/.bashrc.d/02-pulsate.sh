pulsate() {
    stop_file="/tmp/pulsate_stop"
    rm -f "$stop_file"

    min=150   # minimum green brightness (hex 64)
    max=255   # maximum green brightness (hex ff)
    steps=16  # number of steps in fade

    while [ ! -f "$stop_file" ]; do
        # Fade green up (subtle)
        for i in $(seq 0 $((steps-1))); do
            shade=$(( min + (i * (max - min) / (steps - 1)) ))
            hex=$(printf "%02x" $shade)
            echo -ne "\033]10;#00${hex}00\007"
            sleep 0.03
            [ -f "$stop_file" ] && break
        done

        # Fade green down
        for i in $(seq $((steps-1)) -1 0); do
            shade=$(( min + (i * (max - min) / (steps - 1)) ))
            hex=$(printf "%02x" $shade)
            echo -ne "\033]10;#00${hex}00\007"
            sleep 0.03
            [ -f "$stop_file" ] && break
        done
    done

    # Reset to bright green after stopping
    echo -ne "\033]10;#00ff00\007"
}
normal() {
    # Stop pulsating
    touch /tmp/pulsate_stop
    sleep 1

    # Reset cursor to white
    echo -e "\033]10;#FFFFFF\007"
}

# Start pulsating in background
normal
pulsate &
