require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" }
})


local keymap = vim.keymap.set
local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({})
lspconfig.pyright.setup({})

keymap("n", "<leader>hd", vim.lsp.buf.hover, {})
keymap({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>gd", vim.lsp.buf.definition, {})
