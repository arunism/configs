local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
vim.opt.rtp:prepend(lazypath)


local plugins = {
  -- Color-Scheme
  {
    "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {},
  },

  -- Fuzzy Finder
  {
     "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope.nvim", tag = "0.1.6",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- File System Manager
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },

  -- LSP and Corresponding Requirements
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  -- Auto Complete
  {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
  },

  -- Status-Line Manager
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },

  -- Auto Completion of the Shortcut Commandline Keys
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 3
    end,
    opts = {}
  },

  -- Parser for Different Languages
  {
    "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"
  },

  -- Git Controls
  {
    "lewis6991/gitsigns.nvim"
  }
}

local opts = {}


require("lazy").setup(plugins, opts)
