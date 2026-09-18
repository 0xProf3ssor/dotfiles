# AGENTS.md

## Repository Purpose
Dotfiles for personal development environment. Uses GNU Stow to create symlinks from `$HOME` into this repo.

## Structure
- `common/` - Cross-platform configs (nvim, tmux, zsh, alacritty, btop, foot)
- `arch/` - Arch Linux + Sway configs (waybar, swaylock, swaync, wofi)
- `mac/` - macOS configs (sketchybar, aerospace)

## Symlink Management
```bash
stow -t ~ common/nvim common/tmux common/zsh  # install
stow -D -t ~ common/nvim                       # uninstall
stow -R -t ~ common/nvim                       # reinstall (after changes)
```

Target `-t ~` places files in home directory. Configs live in subdirs like `common/nvim/.config/nvim/`.

## Neovim
- NvChad v2.5 framework
- Custom config: `lua/custom/` dir, user plugins: `lua/custom/plugins/`
- Theme: Gruvbox Dark (configured in `lua/chadrc.lua`)
- Do not modify `lua/plugins/init.lua` - custom plugins only

## Tmux
- Prefix: `Ctrl-b`
- Config: `~/.tmux.conf` -> `dotfiles/common/tmux/.tmux.conf`
- Gruvbox dark flavor
- Vi-mode keys (h/j/k/l navigation)

## Key Files
| Tool | Config Location |
|-----|---------------|
| nvim | `common/nvim/.config/nvim/` |
| tmux | `common/tmux/.tmux.conf` |
| zsh | `common/zsh/.zshrc` |
| sway | `arch/sway/.config/sway/` |
| waybar | `arch/waybar/.config/waybar/` |