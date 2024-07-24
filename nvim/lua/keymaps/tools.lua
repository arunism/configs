local keymap = vim.keymap.set


-- TELESCOPE
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})


-- NVIM-TREE
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", {})
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", {})
keymap("n", "<leader>nr", ":NvimTreeRefresh<CR>", {})
