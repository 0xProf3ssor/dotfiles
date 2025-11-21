# 0xProf3ssor's Dotfiles

A terminal-focused development environment featuring the beautiful Catppuccin Mocha theme across all applications. This configuration provides a cohesive, productive workspace optimized for both Arch Linux and macOS.

## Features

- **Neovim**: Full IDE experience with NvChad v2.5, LSP support (Lua, TypeScript, Python, HTML, CSS), code formatting via Conform
- **Tmux**: Session management with Catppuccin theming, vi-mode keybindings, and intuitive navigation
- **Zsh**: Enhanced shell experience with Powerlevel10k prompt and Yazi file manager integration  
- **Unified Theme**: Catppuccin Mocha color scheme across nvim, tmux, btop, and window managers
- **Platform Support**: Optimized configurations for both Arch Linux (Sway ecosystem) and macOS
- **Terminal Applications**: btop system monitor, foot/alacritty terminal emulators, Yazi file manager

## Project Structure

```
dotfiles/
├── common/          # Shared configurations for all platforms
│   ├── nvim/        # Neovim config with NvChad, LSP, and custom plugins
│   ├── tmux/        # Tmux config with Catppuccin theme and vi-mode
│   ├── zsh/         # Zsh config with Oh My Zsh and Powerlevel10k
│   ├── alacritty/   # Cross-platform terminal emulator config
│   ├── btop/        # System monitor with Catppuccin theme
│   └── foot/        # Wayland terminal config
├── arch/            # Arch Linux specific configurations
│   ├── sway/        # Sway window manager with Catppuccin
│   ├── waybar/      # Status bar configuration
│   ├── wofi/        # Application launcher
│   ├── swaylock/    # Screen locker
│   ├── swaync/      # Notification daemon
│   └── zsh/         # Arch-specific zsh paths and settings
└── mac/             # macOS specific configurations
    └── zsh/         # macOS-specific zsh paths and settings
```

## Installation

### Prerequisites

**Common Dependencies:**
- Git
- GNU Stow (for symlink management)
- Neovim (>= 0.9.0)
- Tmux
- Zsh
- Node.js and npm (for LSP servers)

**Arch Linux:**
```bash
sudo pacman -S git stow neovim tmux zsh nodejs npm sway waybar wofi foot btop
```

**macOS:**
```bash
brew install git stow neovim tmux zsh node
```

### Setup Steps

1. **Clone the repository:**
```bash
git clone https://github.com/0xProf3ssor/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **Install Oh My Zsh and Powerlevel10k:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

3. **Install configuration packages using GNU Stow:**

**For Arch Linux:**
```bash
# Change to dotfiles directory
cd ~/dotfiles

# Install common packages (shared across platforms)
stow -t ~ common/nvim
stow -t ~ common/tmux  
stow -t ~ common/alacritty
stow -t ~ common/btop
stow -t ~ common/foot

# Install Arch-specific packages
stow -t ~ arch/sway
stow -t ~ arch/waybar
stow -t ~ arch/wofi
stow -t ~ arch/swaylock
stow -t ~ arch/swaync
stow -t ~ arch/zsh
```

**For macOS:**
```bash
# Change to dotfiles directory
cd ~/dotfiles

# Install common packages (shared across platforms)
stow -t ~ common/nvim
stow -t ~ common/tmux
stow -t ~ common/alacritty
stow -t ~ common/btop

# Install macOS-specific packages
stow -t ~ mac/zsh
```

**Alternative: Install all common packages at once:**
```bash
cd ~/dotfiles
# For Arch Linux
stow -t ~ common/* arch/*

# For macOS  
stow -t ~ common/nvim common/tmux common/alacritty common/btop mac/*
```

4. **Install Yazi file manager:**
```bash
# Arch Linux
sudo pacman -S yazi

# macOS
brew install yazi
```

5. **Source the new zsh config:**
```bash
source ~/.zshrc
# Run p10k configure to set up Powerlevel10k prompt
```

6. **Launch Neovim to install plugins:**
```bash
nvim
# NvChad and plugins will auto-install on first run
```

## Key Bindings

### Tmux (Prefix: Ctrl-b)
- `Ctrl-b + r` - Reload tmux config
- `Ctrl-b + h/j/k/l` - Navigate between panes (vi-style)
- `Ctrl-b + H/J/K/L` - Resize panes
- `Ctrl-b + Ctrl-k/j` - Swap panes up/down

### Neovim
- `Space` - Leader key
- `;` - Enter command mode
- Standard NvChad keybindings apply

### Zsh
- `y` - Launch Yazi file manager with directory changing

## Dependencies

### Core Tools
- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager for dotfiles
- [NvChad](https://nvchad.com/) - Neovim configuration framework
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color scheme

### LSP Servers (auto-installed)
- lua_ls (Lua)
- ts_ls (TypeScript/JavaScript) 
- pyright (Python)
- html (HTML)
- cssls (CSS)

### Optional Tools
- [Yazi](https://github.com/sxyazi/yazi) - Terminal file manager
- [Sway](https://swaywm.org/) - Wayland window manager (Arch)
- [Waybar](https://github.com/Alexays/Waybar) - Status bar (Arch)

## Customization

### Changing Themes
The setup uses Catppuccin Mocha by default. To change themes:

1. **Neovim**: Edit `common/nvim/.config/nvim/lua/chadrc.lua` and change the `theme` value
2. **Tmux**: Update `@catppuccin_flavor` in `common/tmux/.tmux.conf`
3. **btop**: Change `color_theme` in `common/btop/.config/btop/btop.conf`

### Adding Neovim Plugins
Add plugins to `common/nvim/.config/nvim/lua/plugins/init.lua` or create new files in the `plugins/` directory.

### Configuring LSP Servers
Edit `common/nvim/.config/nvim/lua/configs/lspconfig.lua` to add or configure language servers.

## Troubleshooting

### Common Issues

**Tmux colors not displaying correctly:**
```bash
# Ensure your terminal supports 256 colors
echo $TERM
# Should output something with "256color"
```

**NeoVim plugins not loading:**
```bash
# Clean and reinstall plugins
rm -rf ~/.local/share/nvim
nvim  # Plugins will reinstall automatically
```

**Path conflicts between platforms:**
The repository separates platform-specific zsh configs to avoid NVM and PATH conflicts between Arch Linux and macOS.

**GNU Stow conflicts:**
```bash
# If stow reports conflicts with existing files, remove them first
rm ~/.zshrc ~/.tmux.conf
rm -rf ~/.config/nvim ~/.config/tmux

# Then re-run stow commands
cd ~/dotfiles
stow -t ~ common/nvim common/tmux arch/zsh  # or mac/zsh for macOS
```

**Unstowing packages:**
```bash
# To remove symlinks created by stow
cd ~/dotfiles
stow -D -t ~ common/nvim  # Remove nvim package
stow -D -t ~ arch/zsh     # Remove zsh package

# To restow (useful after config changes)
stow -R -t ~ common/nvim  # Remove and reinstall nvim package
```

**Permission issues:**
```bash
# Ensure proper permissions on config files
chmod 644 ~/.zshrc ~/.tmux.conf
chmod -R 755 ~/.config/
```

## Contributing

This is a personal dotfiles repository, but feel free to fork it and adapt it to your needs. If you find bugs or have suggestions, please open an issue.

## License

This configuration is provided as-is for personal use. Individual tools and themes retain their respective licenses.
