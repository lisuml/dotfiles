#!/bin/bash
# Pre-Ansible bootstrap for a fresh headless Arch Linux install.
# Run this once, then follow the printed instructions.
set -e

TARGET="$HOME/infra/ansible"

# 1. Network (wired via systemd-networkd — for Wi-Fi use `iwctl` manually first)
echo "==> Checking network..."
if ! ping -c 1 -W 3 archlinux.org &>/dev/null; then
    echo "    No connectivity — starting wired DHCP via systemd-networkd..."
    sudo mkdir -p /etc/systemd/network
    printf '[Match]\nName=en*\n\n[Network]\nDHCP=yes\n' | sudo tee /etc/systemd/network/99-wired.network > /dev/null
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
    sudo systemctl start systemd-resolved systemd-networkd
    sleep 5
    ping -c 1 -W 5 archlinux.org > /dev/null || { echo "    Still no network. For Wi-Fi: iwctl, then retry."; exit 1; }
fi
echo "    OK"

# 2. Bootstrap packages
echo "==> Installing bootstrap packages..."
sudo pacman -S --needed --noconfirm ansible-core git openssh base-devel vim qrencode

# 3. SSH key (ed25519)
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "==> Generating SSH key..."
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -a 100 -f "$HOME/.ssh/id_ed25519" -C "$(whoami)@$(hostname)"
fi

echo ""
echo "==> Scan the QR code with your phone, copy the key text,"
echo "    then add it at https://github.com/settings/keys"
echo ""
qrencode -t ANSIUTF8 "$(cat "$HOME/.ssh/id_ed25519.pub")"
echo ""
echo "    Public key:"
cat "$HOME/.ssh/id_ed25519.pub"
echo ""
read -rp "Press Enter once the key is added to GitHub..."
ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" \
    && echo "    GitHub SSH: OK" \
    || echo "    Warning: SSH test inconclusive — verify the key was added correctly."

# 4. Install yay (AUR helper)
if ! command -v yay &>/dev/null; then
    echo "==> Building yay..."
    mkdir -p "$HOME/Documents/repos/aur"
    git clone https://aur.archlinux.org/yay.git "$HOME/Documents/repos/aur/yay"
    ( cd "$HOME/Documents/repos/aur/yay" && makepkg -si --noconfirm )
fi

# 5. Clone this repo
if [ ! -d "$TARGET/.git" ]; then
    echo "==> Cloning infra-ansible..."
    mkdir -p "$(dirname "$TARGET")"
    git clone -b arch-support git@github.com:lisuml/infra-ansible "$TARGET"
fi

# 6. Ansible Vault password
VAULT_FILE="$TARGET/.vault_pass"
if [ ! -f "$VAULT_FILE" ]; then
    echo ""
    read -rsp "==> Enter Ansible Vault password: " vpass && echo
    read -rsp "    Confirm: " vpass2 && echo
    [ "$vpass" = "$vpass2" ] || { echo "Passwords don't match."; exit 1; }
    ( umask 077; printf "%s\n" "$vpass" > "$VAULT_FILE" )
    echo "    Vault password saved to $VAULT_FILE"
fi

echo ""
echo "========================================"
echo " Bootstrap complete — next steps:"
echo "========================================"
echo ""
echo " 1. Run ansible (skips insync which needs a browser):"
echo "    cd $TARGET"
echo "    ./run.sh -e first_run=true --skip-tags insync"
echo ""
echo " 2. Apply dotfiles (before rebooting, so Hyprland config is ready):"
echo "    chezmoi init --apply --branch arch-support git@github.com:lisuml/dotfiles"
echo ""
echo " 3. Reboot — SDDM will appear, select 'Hyprland (uwsm)'."
echo ""
echo " 4. From Hyprland, complete the setup:"
echo "    cd $TARGET && ./run.sh --tags insync   # Insync OAuth (needs browser)"
echo ""
