.PHONY: install clean

install:
	bash install-tools.sh

clean:
	sudo rm -f /usr/local/bin/kubectl /usr/local/bin/kubectx /usr/local/bin/kubens /usr/local/bin/k9s
	sudo rm -rf /opt/kubectx ~/.dotfiles
	sudo apt remove -y terraform azure-cli direnv jq ripgrep i3 i3status i3lock suckless-tools feh lxappearance rofi py3status
	sudo rm -f /etc/apt/sources.list.d/hashicorp.list
	sudo rm -f /usr/share/keyrings/hashicorp-archive-keyring.gpg

