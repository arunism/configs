local keymap = vim.keymap.set
local builtin = require("telescope.builtin")


keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
