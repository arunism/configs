local keymap = vim.keymap.set


-- TELESCOPE
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})


-- NVIM-TREE
keymap("n", "<C-s>", ":NvimTreeToggle<CR>", {})
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", {})
keymap("n", "<leader>nr", ":NvimTreeRefresh<CR>", {})


-- LSPCONFIG
keymap("n", "<C-l>", vim.lsp.buf.hover, {})


-- LAZYGIT
-- keymap("n", "<leader>lg", "<cmd>LazyGit<cr>", {})


-- Debugger
local dap = require("dap")
keymap("n", "<leader>dt", dap.toggle_breakpoint, {})
keymap("n", "<leader>dc", dap.continue, {})
