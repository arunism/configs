local system = require("core.system")
local settings = require("core.settings")
local plugins = require("plugins")


local lazy = {}


function lazy:load_plugins()
  self.plugins = {}
  for name, config in pairs(plugins) do
    self.plugins[#self.plugins + 1] = vim.tbl_extend("force", { name }, config)
  end
end


function lazy:load_lazy()
  local lazypath = system.data_dir .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  self:load_plugins()

  local git_prefix = system.use_ssh and "git@github.com:%s.git" or "https://github.com/%s.git"
  local lazy_settings = {
    root = system.data_dir .. "/lazy",  -- dir to install plugins
    git = {
      log = { "-10" },  -- display last 10 commits
      timeout = 300,
      url_format = git_prefix,
    },
    install = {  -- install missing plugins on startup, this won't increase startup time
      missing = true,
      colorscheme = { settings.colorscheme },
    },
    change_detection = {  -- automatically check for config file changes and reload the ui
      enabled = true,
      notify = false,  -- get a notification when changes are found
    },
    ui = {
      size = { width = 0.88, height = 0.8 },
      wrap = true,
      border = vim.g.border_enabled and "rounded" or "none",
      icons = {
        -- TODO
      },
    },
    performance = {
      cache = {
	enabled = true,
	path = system.cache_dir .. "/lazy/cache",
	disable_events = { "UIEnter", "BufReadPre" },  -- To cache all plugins, set this to `{}`, but NOT recommended
	ttl = 3600 * 24 * 2,  -- Keep cached items for 2 days of inactivity
      },
      reset_packpath = true,  -- reset the package path to improve startup time
      rtp = {
	reset = true,  -- reset the runtime path to $VIMRUNTIME and the config directory
	---@type string[]
	paths = {}, -- add any custom paths here that you want to include in the rtp
	disabled_plugins = {},
      },
    },
  }

  if system.is_mac then
    lazy_settings.concurrency = 20
  end

  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup(self.plugins, lazy_settings)
end


lazy:load_lazy()
