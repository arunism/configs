local builtin = require("telescope.builtin")
local keymap = vim.keymap.set


keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
