setup: install-homebrew install-packages install-oh-my-zsh

install-homebrew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' > "$$HOME/.zprofile"
	eval "$$(/opt/homebrew/bin/brew shellenv)"

install-packages:
	rm -f ~/.Brewfile
	curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/.Brewfile > ~/.Brewfile
	brew bundle --verbose --global

install-oh-my-zsh:
	rm -rf ~/.oh-my-zsh
	curl -sSL https://raw.githubusercontent.com/joshampton/dotfiles/main/.zshrc > ~/.zshrc
	sh -c "$$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	cd ~
