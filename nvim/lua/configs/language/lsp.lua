return function()
  local lspconfig = require("lspconfig")
  local lang_servers = require("core.settings").lang_servers

  -- Define the configuration directly
  require("configs.language.mason")()

  -- Integrate all the configurations
  local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  for _, ls in ipairs(lang_servers) do
    lspconfig[ls].setup({ capabilities = capabilities })
  end

end
