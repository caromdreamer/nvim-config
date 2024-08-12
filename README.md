# INSTALL

```bash
git clone https://github.com/hsnks100/nvim-config.git ~/.config/nvim
```

# Neovim Configuration

This README provides an overview of the Neovim configuration, including the key mappings, functionalities, and the structure of the configuration files.

## Leader Key

The leader key is set to `,`.

## Key Mappings

### Normal Mode

| Keymap           | Function                                        |
|------------------|-------------------------------------------------|
| `<leader>w`      | Open BufExplorer                                |
| `<leader>n`      | Open NERDTree                                   |
| `<c-h>`          | Move to the left window                         |
| `<c-l>`          | Move to the right window                        |
| `<c-k>`          | Move to the window above                        |
| `<c-j>`          | Move to the window below                        |
| `<leader>e`      | Find files using Telescope                      |
| `<leader>fs`     | Live grep using Telescope                       |
| `<leader>fc`     | Grep string using Telescope                     |
| `8`              | Scroll half a page up and center the cursor     |
| `9`              | Scroll half a page down and center the cursor   |
| `<leader>feR`    | Reload Neovim configuration                     |
| `<leader>fed`    | Open Neovim configuration file                  |
| `<leader>r`      | Change to the file's directory                  |
| `<left>`         | Resize window to the left                       |
| `<right>`        | Resize window to the right                      |
| `<down>`         | Resize window down                              |
| `<up>`           | Resize window up                                |
| `\\\\`           | Open a new terminal in a split window           |

### Visual Mode

| Keymap           | Function                                        |
|------------------|-------------------------------------------------|
| `8`              | Scroll half a page up and center the cursor     |
| `9`              | Scroll half a page down and center the cursor   |

### Terminal Mode

| Keymap           | Function                                        |
|------------------|-------------------------------------------------|
| `<esc>`          | Exit terminal mode                              |
| `<c-k>`          | Move to the window above from terminal mode     |
| `<c-j>`          | Move to the window below from terminal mode     |

## Configuration Files

### init.lua

The `init.lua` file is the main configuration file for Neovim. It sets up the necessary plugins, key mappings, and other settings.

### lua Directory

The `lua` directory contains additional Lua scripts used by the Neovim configuration. These scripts define custom functions, plugin configurations, and other advanced settings.

#### core Subdirectory

- **keymaps.lua**: Contains the key mappings for Neovim.
- **colorscheme.lua**: Sets the colorscheme for Neovim.
- **options.lua**: Defines various Neovim options and settings.

#### plugins Subdirectory

- **lspconfig.lua**: Configures the Language Server Protocol (LSP) for Neovim.
- **plugin-setup.lua**: Manages the setup and configuration of Neovim plugins.

Feel free to customize this README further based on your specific setup and preferences.
