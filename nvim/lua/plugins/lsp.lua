require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "pylsp" },
  automatic_installation = true,
})


local keymap = vim.keymap.set
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup({ capabilities = capabilities, })
lspconfig.pylsp.setup({ capabilities = capabilities, })

keymap("n", "<leader>hd", vim.lsp.buf.hover, {})
keymap({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>gd", vim.lsp.buf.definition, {})
