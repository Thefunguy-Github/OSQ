#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
# Check if XMonad is installed
if ! command_exists xmonad; then
    echo "XMonad is not installed on this system."
    echo "Would you like to install XMonad? (y/n)"
    read -r install_response
    if [[ "$install_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Installing XMonad..."
        sudo apt update
        sudo apt install xmonad libghc-xmonad-contrib-dev xmobar
    else
        echo "XMonad installation skipped. Exiting script."
        exit 1
    fi
fi

echo "This MIGHT DELETE your XMONAD DOTFILES."
echo "Do you wish to continue? (y/n)"

read -r response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "Proceeding with installation..."

    # Create necessary directories
    mkdir -p ~/.xmonad
    mkdir -p ~/.config/xmobar

    # Backup existing files
    if [ -f ~/.xmonad/xmonad.hs ]; then
        mv ~/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs.bak
    fi
    if [ -f ~/.config/xmobar/xmobarrc ]; then
        mv ~/.config/xmobar/xmobarrc ~/.config/xmobar/xmobarrc.bak
    fi

    # Download dotfiles from a git repository
    # Replace 'YOUR_REPO_URL' with the actual URL of your dotfiles repository
    git clone https://github.com/Thefunguy-Github/OSQ/blob/main/Dotfiles/xmonad.hs /tmp/xmonad-dotfiles

    # Copy files to appropriate locations
    cp /tmp/xmonad-dotfiles/xmonad.hs ~/.xmonad/
    cp /tmp/xmonad-dotfiles/xmobarrc ~/.config/xmobar/

    # Clean up
    rm -rf /tmp/xmonad-dotfiles

    # Compile XMonad
    xmonad --recompile

    echo "Installation complete!"
    echo "Please restart XMonad for changes to take effect."

else
    echo "Installation cancelled."
fi
