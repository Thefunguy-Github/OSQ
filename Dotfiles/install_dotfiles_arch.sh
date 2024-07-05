1  #!/bin/bash
2
3  # Function to check if a command exists
4  command_exists() {
5      command -v "$1" >/dev/null 2>&1
6  }
7
8  # Check if XMonad is installed
9  if ! command_exists xmonad; then
10     echo "XMonad is not installed on this system."
11     echo "Would you like to install XMonad? (y/n)"
12     read -r install_response
13     if [[ "$install_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
14         echo "Installing XMonad..."
15         sudo pacman -Syu
16         sudo pacman -S xmonad libghc-xmonad-contrib-dev xmobar
17     else
18         echo "XMonad installation skipped. Exiting script."
19         exit 1
20     fi
21 fi
22
23 echo "This MIGHT DELETE your XMONAD DOTFILES."
24 echo "Do you wish to continue? (y/n)"
25
26 read -r response
27
28 if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
29 then
30     echo "Proceeding with installation..."
31
32     # Create necessary directories
33     mkdir -p ~/.xmonad
34     mkdir -p ~/.config/xmobar
35
36     # Backup existing files
37     if [ -f ~/.xmonad/xmonad.hs ]; then
38         mv ~/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs.bak
39     fi
40     if [ -f ~/.config/xmobar/xmobarrc ]; then
41         mv ~/.config/xmobar/xmobarrc ~/.config/xmobar/xmobarrc.bak
42     fi
43
44     # Download dotfiles from a git repository
45     # Replace 'YOUR_REPO_URL' with the actual URL of your dotfiles repository
46     git clone https://github.com/Thefunguy-Github/OSQ/blob/main/Dotfiles/xmonad.hs /tmp/xmonad-dotfiles
47
48     # Copy files to appropriate locations
49     cp /tmp/xmonad-dotfiles/xmonad.hs ~/.xmonad/
50     cp /tmp/xmonad-dotfiles/xmobarrc ~/.config/xmobar/
51
52     # Clean up
53     rm -rf /tmp/xmonad-dotfiles
54
55     # Compile XMonad
56     xmonad --recompile
57
58     echo "Installation complete!"
59     echo "Please restart XMonad for changes to take effect."
60
61 else
62     echo "Installation cancelled."
63 fi
