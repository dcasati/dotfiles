#!/usr/bin/env bash
set -euo pipefail

echo "[*] Installing base packages..."
sudo apt update
sudo apt install -y \
  curl gnupg lsb-release software-properties-common unzip git \
  jq ripgrep direnv

echo "[*] Installing kubectl..."
sudo curl -fsSL -o /usr/local/bin/kubectl \
  https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl

echo "[*] Installing kubectx and kubens..."
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx || true
sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

echo "[*] Installing k9s..."
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | jq -r '.tag_name')
curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
tar -xzf k9s.tar.gz k9s
sudo install k9s /usr/local/bin
rm -f k9s k9s.tar.gz

echo "[*] Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform

echo "[*] Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "[*] Installing i3 window manager and py3status..."
sudo apt install -y i3 i3status i3lock suckless-tools feh lxappearance rofi py3status

echo "[*] Cloning dotfiles into ~/.dotfiles..."
if [ -d ~/.dotfiles ]; then
  echo "[*] Updating existing dotfiles..."
  git -C ~/.dotfiles pull
else
  git clone https://github.com/dcasati/dotfiles ~/.dotfiles
fi

echo "[✓] All tools installed successfully."

