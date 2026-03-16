# bash-configurations

Welcome to our shared bash configuration repository! This is a place where friends can contribute their personal `.bashrc`, aliases, functions, scripts, and other bash customizations. Anyone can then use any of these configurations by simply symlinking the desired user's files into their home directory.

## Repository Structure

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
│   └── switch-config.sh    (helper script to change which config you're using)
└── README.md
```

Each user’s directory contains the files exactly as they would appear in a home directory. This makes it easy to symlink (or copy) the whole set.

## Getting Started

1. **Clone the repository** to a convenient location, e.g.:
   ```bash
   git clone https://github.com/your-org/bash-configs.git ~/bash-configs
   ```

2. **Choose a user’s configuration** you want to use (e.g., `alice`).

3. **Symlink the files** into your home directory (see below).

## How to Use a Configuration (with Symlinks)

A **symlink** (symbolic link) is like a shortcut that points to the real file. When you create a symlink in your home directory that points to a file inside this repo, your shell will see it as if the file were actually there – but the content stays in the repo. This way you can easily switch between different configs just by changing the symlinks.

### Manual Symlinking

To use `alice`’s config:

```bash
# First, back up or remove any existing dotfiles you may have
mv ~/.bashrc ~/.bashrc.backup
mv ~/.bashrc.d ~/.bashrc.d.backup   # if it exists
# ... do the same for .bash_profile, .profile, bin, etc.

# Create symlinks
ln -s ~/bash-configs/users/alice/.bashrc ~/.bashrc
ln -s ~/bash-configs/users/alice/.bashrc.d ~/.bashrc.d
[ -f ~/bash-configs/users/alice/.bash_profile ] && ln -s ~/bash-configs/users/alice/.bash_profile ~/.bash_profile
[ -f ~/bash-configs/users/alice/.profile ] && ln -s ~/bash-configs/users/alice/.profile ~/.profile
[ -d ~/bash-configs/users/alice/bin ] && ln -s ~/bash-configs/users/alice/bin ~/bin
```

After symlinking, restart your shell or run `source ~/.bashrc` to apply the changes.

### Switching to Another User

To switch, simply remove the old symlinks and create new ones pointing to the desired user’s folder.

```bash
rm ~/.bashrc ~/.bashrc.d
ln -s ~/bash-configs/users/bob/.bashrc ~/.bashrc
ln -s ~/bash-configs/users/bob/.bashrc.d ~/.bashrc.d
# ... and so on
```

## Easier Switching with the Helper Script

We’ve provided a script to automate the switching process. After cloning the repo, you can run:

```bash
~/bash-configs/scripts/switch-config.sh alice
```

This script will:
- Remove existing symlinks (it does **not** delete your actual files – only symlinks are removed).
- Create new symlinks pointing to the specified user’s files.
- Tell you when it’s done.

To make the script available system‑wide, you can add it to your `PATH` or create an alias.

## Adding Your Own Configuration

1. Fork this repository (if you’re not a direct collaborator) or create a new branch.
2. Inside the `users/` folder, create a new directory with your username (e.g., `users/charlie/`).
3. Place your `.bashrc`, `.bashrc.d/`, `bin/`, etc., inside it.
4. Commit your changes and open a pull request.

**Please keep your personal secrets out of the repo** – use environment variables or private files (e.g., `.bashrc.local`) that are ignored.

## Notes & Tips

- **Absolute paths**: The symlinks created by the helper script use absolute paths, so they work from anywhere.
- **Backups**: The script does not back up your existing dotfiles. If you have real files in your home directory (not symlinks), move them aside manually first.
- **Conflicts**: If two users have the same filename, the last symlink wins – that’s how you switch.
- **Updating**: When you pull new changes from the repo, your symlinks will automatically point to the updated files – no need to relink.

## Why Symlinks? A Quick Explanation

Symlinks are a powerful tool for managing dotfiles:
- **No duplication**: You edit one copy (in the repo) and the change is instantly visible in your home directory.
- **Easy version control**: All your configs live in Git, so you can track changes, roll back, and collaborate.
- **Quick switching**: Changing which config you use is as simple as pointing a symlink to a different folder.

If you’re new to symlinks, just think of them as shortcuts – they’re safe and easy to manage.

---

Enjoy sharing and exploring different bash setups! If you have questions or ideas, open an issue or start a discussion.
```

This README should cover everything the user asked for: naming, description, instructions on usage, explanation of symlinks, and easy switching via a script.
