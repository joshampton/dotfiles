init:
	xcode-select --install
	sudo softwareupdate --install-rosetta

setup: install-homebrew install-packages install-oh-my-zsh install-asdf

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

install-asdf:
	rm -rf ~/.asdf
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf

link:
	rm -rf $$HOME/.ssh
	ln -s $$HOME/.private/ssh $$HOME/.ssh
	chmod -h 700 $$HOME/.ssh
	rm -rf $$HOME/.gnupg
	ln -s $$HOME/.private/gnupg $$HOME/.gnupg
	chmod -h 700 $$HOME/.gnupg

os:
	# Close any open System Preferences panes, to prevent them from overriding
	# settings we're about to change
	osascript -e 'tell application "System Preferences" to quit'
	# Ask for the administrator password upfront
	sudo -v

	# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	###############################################################################
	# General UI/UX                                                               #
	###############################################################################

	# Set computer name (as done via System Preferences → Sharing)
	@read -p "Enter Computer Name:" computer_name; \
	sudo scutil --set ComputerName "$$computer_name"

	# Set host name
	@read -p "Enter Host Name:" host_name; \
	sudo scutil --set HostName "$$host_name.macbook.local"; \
	sudo scutil --set LocalHostName "$$host_name"; \
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$$host_name"

	# Save to disk (not to iCloud) by default
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

	# Disable automatic capitalization as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

	# Disable smart dashes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

	# Disable automatic period substitution as it’s annoying when typing code
	defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

	# Disable smart quotes as they’re annoying when typing code
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	# Disable auto-correct
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	###############################################################################
	# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
	###############################################################################

	# Increase sound quality for Bluetooth headphones/headsets
	defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

	# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled 0

	# Set a blazingly fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Disable “natural” (Lion-style) scrolling
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

	# Set the timezone; see `sudo systemsetup -listtimezones` for other values
	sudo systemsetup -settimezone "America/Denver" > /dev/null

	###############################################################################
	# Screen                                                                      #
	###############################################################################

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Disable shadow in screenshots
	defaults write com.apple.screencapture disable-shadow -bool true

	###############################################################################
	# Finder                                                                      #
	###############################################################################

	# Avoid creating .DS_Store files on network or USB volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
	defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

	# Use list view in all Finder windows by default
	defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

	# Show the ~/Library folder
	chflags nohidden ~/Library

	# Show the /Volumes folder
	sudo chflags nohidden /Volumes

	# Expand the following File Info panes:
	# “General”, “Open with”, and “Sharing & Permissions”
	defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

	###############################################################################
	# Dock, Dashboard, and hot corners                                            #
	###############################################################################

	# Move the dock to the right
	defaults write com.apple.dock 'orientation' -string 'bottom'

	# Wipe all (default) app icons from the Dock
	defaults write com.apple.dock persistent-apps -array

	# Don’t show Dashboard as a Space
	defaults write com.apple.dock dashboard-in-overlay -bool true

	# Don’t automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Displays have separate Spaces
	defaults write com.apple.spaces spans-displays -bool true

	# Don’t show recent applications in Dock
	defaults write com.apple.dock show-recents -bool false

	# Disable the Launchpad gesture (pinch with thumb and three fingers)
	defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

	# Reset Launchpad, but keep the desktop wallpaper intact
	find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

	###############################################################################
	# Spotlight                                                                   #
	###############################################################################

	defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
	'{"enabled" = 1;"name" = "MESSAGES";}' \
	'{"enabled" = 1;"name" = "CONTACT";}' \
	'{"enabled" = 1;"name" = "EVENT_TODO";}' \
	'{"enabled" = 1;"name" = "IMAGES";}' \
	'{"enabled" = 1;"name" = "BOOKMARKS";}' \
	'{"enabled" = 1;"name" = "MUSIC";}' \
	'{"enabled" = 1;"name" = "MOVIES";}' \
	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 1;"name" = "SOURCE";}' \
	'{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 1;"name" = "MENU_OTHER";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 1;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

	# Load new settings before rebuilding the index
	killall mds > /dev/null 2>&1 || true

	# Make sure indexing is enabled for the main volume
	sudo mdutil -i on / > /dev/null || true

	# Rebuild the index from scratch
	sudo mdutil -E / > /dev/null || true

	###############################################################################
	# Terminal & iTerm 2                                                          #
	###############################################################################

	# Don’t display the annoying prompt when quitting iTerm
	defaults write com.googlecode.iterm2 PromptOnQuit -bool false

	###############################################################################
	# Time Machine                                                                #
	###############################################################################

	# Prevent Time Machine from prompting to use new hard drives as backup volume
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	###############################################################################
	# Activity Monitor                                                            #
	###############################################################################

	# Show the main window when launching Activity Monitor
	defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

	# Visualize CPU usage in the Activity Monitor Dock icon
	defaults write com.apple.ActivityMonitor IconType -int 5

	# Show all processes in Activity Monitor
	defaults write com.apple.ActivityMonitor ShowCategory -int 0

	# Sort Activity Monitor results by CPU usage
	defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
	defaults write com.apple.ActivityMonitor SortDirection -int 0

	###############################################################################
	# Mac App Store                                                               #
	###############################################################################

	# Enable the WebKit Developer Tools in the Mac App Store
	defaults write com.apple.appstore WebKitDeveloperExtras -bool true

	# Enable Debug Menu in the Mac App Store
	defaults write com.apple.appstore ShowDebugMenu -bool true

	# Enable the automatic update check
	defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

	# Check for software updates daily, not just once per week
	defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

	# Download newly available updates in background
	defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

	# Install System data files & security updates
	defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

	# Automatically download apps purchased on other Macs
	defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

	# Turn on app auto-update
	defaults write com.apple.commerce AutoUpdate -bool true

	# Allow the App Store to reboot machine on macOS updates
	defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

	###############################################################################
	# Photos                                                                      #
	###############################################################################

	# Prevent Photos from opening automatically when devices are plugged in
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

	###############################################################################
	# Messages                                                                    #
	###############################################################################

	# Disable continuous spell checking
	defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

	@echo "restarting in 10 seconds"
	@sleep 10
	sudo reboot
