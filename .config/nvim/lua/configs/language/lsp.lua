return function()
  local lspconfig = require("lspconfig")
  local settings = require("configs.language.settings")
  local lang_servers = require("core.settings").lang_servers

  -- Define the configuration directly
  require("configs.language.mason")()

  -- Integrate all the configurations
  local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )

  for _, ls in ipairs(lang_servers) do
    local ls_config = { capabilities = capabilities }

    -- Check if settings exist for the language server
    if settings[ls] then
      ls_config.settings = settings[ls]
    end

    lspconfig[ls].setup(ls_config)
  end

end
