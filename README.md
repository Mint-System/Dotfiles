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

Create a `.env` file add these paths:

```bash
KEEPASS_DATABASE_FILE="$HOME/cloud.mint-system.ch/Mint System/Data/Infrastruktur.kdbx"
KEEPASS_DATABASE_KEY_FILE="$HOME/cloud.mint-system.ch/Mint System/Secrets/KeePass.key"
```

You can also run `cp .env.template .env`.

Run `./task install llm` and it will prompt for the database password.
