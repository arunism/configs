-- Neo-Tree
vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})


-- Treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "python", "markdown", "bash", "dockerfile", "json", "yaml", "toml"},
  highlight = { enable = true },
  indent = {enable = true },
  auto_install = true
})
