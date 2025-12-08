# Dotfiles

Dotfiles for Mint System contributors and employees.

## Usage

Clone this repo.

```bash
cd "$HOME"
git clone https://github.com/Mint-System/Dotfiles.git mint-system-dotfiles
cd mint-system-dotfiles
```

Run `./task help` for details.

Clone the taskfile.build repo.

```bash
./task clone-taskfile
```

## Secrets

The Mint System Nextcloud share provides the secrets store.

The default paths to the database file are:

```bash
KEEPASS_DATABASE_FILE="$HOME/cloud.mint-system.ch/Mint System/Data/Infrastruktur.kdbx"
KEEPASS_DATABASE_KEY_FILE="$HOME/cloud.mint-system.ch/Mint System/Secrets/KeePass.key"
```

Create the `.env` to override the paths.

Install the `llm` cli. It will prompt for the database password.

```bash
./task install llm
```
