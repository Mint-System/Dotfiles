# Sops completion for zsh
# Add 'sops' to the plugins array in ~/.zshrc

if (( $+commands[sops] )); then
    source <(sops completion zsh)
fi
