# Neovim Configuration

This repository contains scripts and configuration files for setting up Neovim on a Linux system.

## Features

- **LSP:** Includes plugins for python and lua.
- **Autocompletion:** Customized settings for a productive editing experience with auto-completion service based on current buffer and lsp.
- **Status Line:** Informative statusline.
- **File System:** File system management via the sidebar.
- **Key Bindings:** Personalized key mappings for efficient workflow.

## Installation

1. Clone the repository to your local machine.
2. Navigate to the `.config/nvim` directory.
3. Copy the content inside the `nvim` directory from the cloned repository inside the `.config/nvim` directory
4. Execute the configuration by running the command `nvim init.lua`.

## Usage


Here’s a comprehensive list of Neovim (nvim) shortcuts to help you navigate, edit, and manage files more efficiently. These are mostly the same as Vim, unless you're using custom plugins or mappings.

---

### 🧭 Navigation

| Shortcut            | Description                    |
| ------------------- | ------------------------------ |
| `h` / `l`           | Move left / right              |
| `j` / `k`           | Move down / up                 |
| `w` / `W`           | Next word / next WORD          |
| `b` / `B`           | Previous word / WORD           |
| `0`                 | Move to beginning of line      |
| `^`                 | Move to first non-whitespace   |
| `$`                 | Move to end of line            |
| `gg`                | Go to beginning of file        |
| `G`                 | Go to end of file              |
| `:n`                | Go to line n                   |
| `%`                 | Jump to matching bracket/brace |
| `Ctrl-d` / `Ctrl-u` | Half-page down / up            |
| `Ctrl-f` / `Ctrl-b` | Full-page forward / back       |

---

### ✍️ Editing

| Shortcut    | Description                       |
| ----------- | --------------------------------- |
| `i`         | Insert before cursor              |
| `I`         | Insert at start of line           |
| `a`         | Append after cursor               |
| `A`         | Append at end of line             |
| `o` / `O`   | Open line below / above           |
| `x` / `X`   | Delete character (under / before) |
| `r<char>`   | Replace character                 |
| `cw`, `ciw` | Change word / inner word          |
| `dd`        | Delete line                       |
| `yy`        | Yank (copy) line                  |
| `p` / `P`   | Paste after / before cursor       |
| `u`         | Undo                              |
| `Ctrl-r`    | Redo                              |
| `.`         | Repeat last command               |

---

### 📑 Visual Mode

| Shortcut      | Description                      |
| ------------- | -------------------------------- |
| `v`           | Start visual (character) mode    |
| `V`           | Start visual line mode           |
| `Ctrl-v`      | Start visual block mode          |
| `y`, `d`, `c` | Yank, delete, change (in visual) |
| `>` / `<`     | Indent / unindent                |

---

### 🔍 Search and Replace

| Shortcut        | Description                         |
| --------------- | ----------------------------------- |
| `/pattern`      | Search forward                      |
| `?pattern`      | Search backward                     |
| `n` / `N`       | Next / previous search result       |
| `*` / `#`       | Search word under cursor (fwd/back) |
| `:%s/old/new/g` | Replace all in file                 |
| `:s/old/new/g`  | Replace in current line             |

---

### 🗂️ Buffers, Tabs, Windows

| Shortcut            | Description                 |
| ------------------- | --------------------------- |
| `:e filename`       | Open file                   |
| `:w` / `:q` / `:wq` | Save / quit / save and quit |
| `:bd`               | Close buffer                |
| `:ls` or `:buffers` | List buffers                |
| `:bN`               | Switch to buffer N          |
| `gt` / `gT`         | Next / previous tab         |
| `:tabnew filename`  | Open file in new tab        |
| `:vsp file` / `:sp` | Vertical / horizontal split |
| `Ctrl-w + h/j/k/l`  | Move between windows        |
| `Ctrl-w + =`        | Make splits equal size      |
| `Ctrl-w + q`        | Quit split                  |

---

### 🔧 Plugins / LSP *(if using built-ins or plugins like Telescope, LSP, etc.)*

If you're using plugins like Telescope, NvimTree, or LSP, key mappings are often customized.

**Examples:**

| Shortcut          | Description                     |
| ----------------- | ------------------------------- |
| `<leader>ff`      | Telescope file search           |
| `<leader>fg`      | Telescope live grep             |
| `gd`              | Go to definition (LSP)          |
| `K`               | Hover documentation (LSP)       |
| `:NvimTreeToggle` | Toggle file explorer (NvimTree) |

---
