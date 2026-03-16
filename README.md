# bash-configurations

Welcome to our shared bash configuration repository! This is a place where friends can contribute their personal `.bashrc`, aliases, functions, scripts, and other bash customizations. Using the provided helper script, you can easily browse, switch between, and manage different configurations.

## Repository Structure

```
bash-configs/
├── users/
│   ├── alice/
│   │   ├── .bashrc
│   │   ├── .bashrc.d/
│   │   │   ├── aliases.sh
│   │   │   └── prompt.sh
│   │   ├── .bash_profile   (optional)
│   │   ├── .profile        (optional)
│   │   └── bin/             (personal scripts)
│   │       └── alice-tool
│   ├── bob/
│   │   ├── .bashrc
│   │   ├── .bashrc.d/
│   │   │   └── bob-stuff.sh
│   │   └── bin/
│   │       └── bob-helper
│   └── ... (more users)
├── scripts/
│   └── switch-config.sh    (helper script to manage configurations)
└── README.md
```

Each user’s directory contains the files exactly as they would appear in a home directory. The `switch-config.sh` script creates **symlinks** from your home directory to the chosen user’s files, allowing you to switch configurations instantly.

## Getting Started

1. **Clone the repository** to a convenient location:
   ```bash
   git clone https://github.com/your-org/bash-configs.git ~/bash-configs
   ```

2. **Make the script executable** (if not already):
   ```bash
   chmod +x ~/bash-configs/scripts/switch-config.sh
   ```

3. (Optional) Add the script to your `PATH` or create an alias for easier access:
   ```bash
   echo 'alias bashcfg=~/bash-configs/scripts/switch-config.sh' >> ~/.bashrc
   source ~/.bashrc
   ```

## Using the Helper Script

The `switch-config.sh` script provides several commands to manage your bash configuration. Run it without arguments to see the help:

```bash
~/bash-configs/scripts/switch-config.sh help
```

### Commands

| Command | Description |
|---------|-------------|
| `help`  | Show the full usage guide. |
| `list`  | List all available user configurations. The active one (if any) is marked with a `*`. |
| `show`  | Display which user’s config is currently active and the status of each dotfile. |
| `switch <username>` or `<username>` | Switch to another user’s configuration. Your original files (if they exist) are automatically backed up. |
| `remove` or `reset` | Remove all repository‑created symlinks. Your original files remain safely in backup folders. |
| `restore` | Restore your original files from the most recent backups. |

### Examples

- **List all available configs**:
  ```bash
  ~/bash-configs/scripts/switch-config.sh list
  ```

- **See what’s active**:
  ```bash
  ~/bash-configs/scripts/switch-config.sh show
  ```

- **Switch to Alice’s configuration** (two equivalent ways):
  ```bash
  ~/bash-configs/scripts/switch-config.sh switch alice
  # or simply
  ~/bash-configs/scripts/switch-config.sh alice
  ```

  The script will:
  - Remove any existing repo‑symlinks.
  - If a real file (e.g., `~/.bashrc`) exists, it will be moved to a timestamped backup like `~/.bashrc.backup.20250316-143022`.
  - Create new symlinks pointing to `alice`’s files.

- **Remove all repo symlinks and go back to your original setup**:
  ```bash
  ~/bash-configs/scripts/switch-config.sh remove
  ```
  Your original files are still in backup folders. To restore them, run:
  ```bash
  ~/bash-configs/scripts/switch-config.sh restore
  ```

## How It Works (Briefly)

The script uses **symbolic links (symlinks)** to connect your home directory to files inside this repository. Symlinks are like shortcuts – they make the repo files appear in your home directory without copying them. This means:

- You can edit files in the repo and changes take effect immediately.
- Switching users just changes which set of files the symlinks point to.
- Your original files are never deleted; they are backed up automatically when you switch.

## Adding Your Own Configuration

1. Fork this repository (if you’re not a collaborator) or create a new branch.
2. Inside the `users/` folder, create a new directory with your username (e.g., `users/charlie/`).
3. Place your `.bashrc`, `.bashrc.d/`, `bin/`, etc., inside it.
4. Commit your changes and open a pull request.

**Please keep personal secrets out of the repo** – use environment variables or private files (e.g., `.bashrc.local`) that are ignored by Git.

## Notes

- The script always uses **absolute paths**, so symlinks work regardless of your current working directory.
- Backups are created with timestamps (e.g., `.bashrc.backup.20250316-143022`). The `restore` command picks the most recent one.
- When you pull updates from the repository, your symlinked files automatically reflect the latest changes – no need to relink.
- If you ever want to manually manage symlinks (without the script), you can, but the script handles backups and safety for you.

---

Enjoy exploring different bash setups! For questions or ideas, open an issue or start a discussion.
