return function()
  local lang_servers = require("core.settings").lang_servers
  local system = require("core.system")

  -- Define the configuration directly for MASON
  local mason_configs = {
    install_root_dir = system.data_dir .. "/mason/",
    PATH = "prepend",
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
    registries = { "github:mason-org/mason-registry", },
    providers = {
      "mason.providers.registry-api",
      "mason.providers.client",
    },
    github = {
      download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
    pip = { upgrade_pip = false, install_args = {}, },
    ui = {
      check_outdated_packages_on_open = true,
      border = "none",
      width = 0.8,
      height = 0.9,
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      },
      keymaps = {
        toggle_package_expand = "<CR>",
        install_package = "i",
        update_package = "u",
        check_package_version = "c",
        update_all_packages = "U",
        check_outdated_packages = "C",
        uninstall_package = "X",
        cancel_installation = "<C-c>",
        apply_language_filter = "<C-f>",
        toggle_package_install_log = "<CR>",
        toggle_help = "g?",
      },
    },
  }

  -- Define the configuration directly for MASON-LSPCONFIG
  local mason_lspconfig_configs = {
    ensure_installed = lang_servers,
    automatic_installation = false,
  }

  -- Integrate all the configurations
  require("mason").setup(mason_configs)
  require("mason-lspconfig").setup(mason_lspconfig_configs)
end
