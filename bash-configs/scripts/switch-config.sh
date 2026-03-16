#!/bin/bash
# switch-config.sh - Switch between, show, list, remove, or restore shared bash configurations
# Usage:
#   ./switch-config.sh help                     - Show this help message
#   ./switch-config.sh list                      - List all available user configs
#   ./switch-config.sh show                       - Show current active user config
#   ./switch-config.sh switch <username>          - Switch to <username>'s config
#   ./switch-config.sh <username>                 - Same as switch (shortcut)
#   ./switch-config.sh remove|reset               - Remove all repo symlinks (leaves backups)
#   ./switch-config.sh restore                    - Restore original files from latest backups

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
USERS_DIR="$REPO_ROOT/users"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}$1${NC}"
}

warn() {
    echo -e "${YELLOW}Warning: $1${NC}"
}

info() {
    echo -e "${BLUE}$1${NC}"
}

safe_remove_symlink() {
    local link="$1"
    if [ -L "$link" ]; then
        local target
        target="$(readlink "$link")"
        if [[ "$target" == "$USERS_DIR"* ]] || [[ "$target" == *"$USERS_DIR"* ]]; then
            rm -f "$link"
            echo "  Removed symlink $link -> $target"
            return 0
        else
            warn "Skipping $link – it points outside the repo ($target)"
            return 1
        fi
    elif [ -e "$link" ]; then
        warn "Skipping $link – it's a real file/directory (not a symlink)"
        return 1
    else
        return 1
    fi
}

safe_create_symlink() {
    local target="$1"
    local link="$2"
    
    if [ -L "$link" ]; then
        rm -f "$link"
    elif [ -e "$link" ]; then
        local backup="${link}.backup.$(date +%Y%m%d-%H%M%S)"
        warn "Real file $link exists – moving it to $backup"
        mv "$link" "$backup"
    fi
    
    ln -s "$target" "$link"
    echo "  Linked $link -> $target"
}

show_current() {
    local current_user=""
    local found=0
    local files=(".bashrc" ".bash_profile" ".profile" ".bashrc.d" "bin")
    
    for f in "${files[@]}"; do
        local path="$HOME/$f"
        if [ -L "$path" ]; then
            local target
            target="$(readlink "$path")"
            if [[ "$target" == "$USERS_DIR"* ]]; then
                local user_part="${target#$USERS_DIR/}"
                local username="${user_part%%/*}"
                if [ -n "$username" ]; then
                    if [ -z "$current_user" ]; then
                        current_user="$username"
                        found=1
                    elif [ "$current_user" != "$username" ]; then
                        warn "Inconsistent symlinks: $f points to user '$username', but previous files pointed to '$current_user'"
                    fi
                fi
            else
                echo "  $f is a symlink to something outside the repo: $target"
            fi
        elif [ -e "$path" ]; then
            echo "  $f exists as a real file/directory (not a symlink)"
        else
            echo "  $f does not exist"
        fi
    done
    
    if [ $found -eq 1 ]; then
        success "Currently using configuration from user: $current_user"
    else
        echo "No active bash-configs symlink found (or using a custom setup)."
    fi
}

switch_to_user() {
    local username="$1"
    local user_dir="$USERS_DIR/$username"
    
    if [ ! -d "$user_dir" ]; then
        error_exit "User '$username' not found in $USERS_DIR"
    fi
    
    echo "Switching to $username's configuration..."
    
    safe_remove_symlink "$HOME/.bashrc"
    safe_remove_symlink "$HOME/.bash_profile"
    safe_remove_symlink "$HOME/.profile"
    safe_remove_symlink "$HOME/.bashrc.d"
    safe_remove_symlink "$HOME/bin"
    
    local linked=0
    if [ -f "$user_dir/.bashrc" ]; then
        safe_create_symlink "$user_dir/.bashrc" "$HOME/.bashrc"
        linked=1
    fi
    if [ -f "$user_dir/.bash_profile" ]; then
        safe_create_symlink "$user_dir/.bash_profile" "$HOME/.bash_profile"
    fi
    if [ -f "$user_dir/.profile" ]; then
        safe_create_symlink "$user_dir/.profile" "$HOME/.profile"
    fi
    if [ -d "$user_dir/.bashrc.d" ]; then
        safe_create_symlink "$user_dir/.bashrc.d" "$HOME/.bashrc.d"
    fi
    if [ -d "$user_dir/bin" ]; then
        safe_create_symlink "$user_dir/bin" "$HOME/bin"
    fi
    
    if [ $linked -eq 0 ]; then
        warn "No common bash files found in $user_dir (at least .bashrc is missing)"
    else
        success "Done. Reload your shell or run 'source ~/.bashrc'."
    fi
}

remove_symlinks() {
    echo "Removing all symlinks pointing to the repository..."
    local removed=0
    safe_remove_symlink "$HOME/.bashrc" && removed=1
    safe_remove_symlink "$HOME/.bash_profile" && removed=1
    safe_remove_symlink "$HOME/.profile" && removed=1
    safe_remove_symlink "$HOME/.bashrc.d" && removed=1
    safe_remove_symlink "$HOME/bin" && removed=1
    
    if [ $removed -eq 1 ]; then
        success "Symlinks removed. Your original files were backed up as .backup.* files."
        echo "To restore the most recent backups, run: $0 restore"
    else
        echo "No repository symlinks found."
    fi
}

restore_backups() {
    echo "Restoring original files from backups..."
    local restored=0
    local files=(".bashrc" ".bash_profile" ".profile" ".bashrc.d" "bin")
    
    for f in "${files[@]}"; do
        local path="$HOME/$f"
        # Remove any existing repo symlink first
        if [ -L "$path" ]; then
            local target
            target="$(readlink "$path")"
            if [[ "$target" == "$USERS_DIR"* ]]; then
                rm -f "$path"
                echo "  Removed symlink $path"
            fi
        fi
        
        # Find the most recent backup for this file/dir
        local latest_backup
        latest_backup="$(ls -d "$HOME/$f".backup.* 2>/dev/null | sort -V | tail -n1 || true)"
        if [ -n "$latest_backup" ] && [ -e "$latest_backup" ]; then
            if [ -e "$path" ] && [ ! -L "$path" ]; then
                warn "Real file $path already exists – moving it to ${path}.conflict.$(date +%Y%m%d-%H%M%S)"
                mv "$path" "${path}.conflict.$(date +%Y%m%d-%H%M%S)"
            fi
            mv "$latest_backup" "$path"
            echo "  Restored $path from $latest_backup"
            restored=1
        else
            echo "  No backup found for $f"
        fi
    done
    
    if [ $restored -eq 1 ]; then
        success "Original files restored. Reload your shell."
    else
        echo "No backups found to restore."
    fi
}

list_users() {
    if [ ! -d "$USERS_DIR" ]; then
        error_exit "Users directory not found: $USERS_DIR"
    fi
    
    echo "Available user configurations:"
    local current=""
    # Try to detect current active user
    if [ -L "$HOME/.bashrc" ]; then
        local target
        target="$(readlink "$HOME/.bashrc")"
        if [[ "$target" == "$USERS_DIR"* ]]; then
            local user_part="${target#$USERS_DIR/}"
            current="${user_part%%/*}"
        fi
    fi
    
    local users=()
    while IFS= read -r user; do
        users+=("$user")
    done < <(find "$USERS_DIR" -maxdepth 1 -type d ! -path "$USERS_DIR" -printf "%f\n" | sort)
    
    if [ ${#users[@]} -eq 0 ]; then
        echo "  No users found in $USERS_DIR"
        return
    fi
    
    for user in "${users[@]}"; do
        if [ "$user" = "$current" ]; then
            echo -e "  ${GREEN}* $user (active)${NC}"
        else
            echo "    $user"
        fi
    done
}

show_help() {
    cat << EOF
Usage: $0 <command>

Commands:
  help                         Show this help message
  list                         List all available user configs
  show                         Show current active user config
  switch <username>            Switch to a specific user's config
  <username>                   Shortcut for switch (e.g., $0 alice)
  remove|reset                 Remove all repo symlinks (leaves backups)
  restore                      Restore original files from latest backups

Examples:
  $0 list
  $0 show
  $0 switch bob
  $0 alice
  $0 remove
  $0 restore
EOF
}

# Main command parsing
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    help|--help|-h)
        show_help
        ;;
    list)
        list_users
        ;;
    show)
        show_current
        ;;
    switch)
        if [ $# -ne 2 ]; then error_exit "switch requires a username"; fi
        switch_to_user "$2"
        ;;
    remove|reset)
        remove_symlinks
        ;;
    restore)
        restore_backups
        ;;
    *)
        # Assume it's a username
        switch_to_user "$1"
        ;;
esac
