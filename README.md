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

The KeePass database and key file paths are selected interactively when needed. Run `./task install llm` and it will prompt you to select the KeePassXC database.
