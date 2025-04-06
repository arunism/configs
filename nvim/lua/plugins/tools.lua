local tools = {}

-- TELESCOPE
tools["nvim-telescope/telescope.nvim"] = {
	lazy = true,
	cmd = "Telescope",
	config = require("configs.tools.telescope"),
  tag = '0.1.8',
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
	},
}

-- WHICH-KEY
tools["folke/which-key.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.tools.which-key"),
}

-- NOTIFY
tools["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	config = require("configs.tools.notify"),
}

-- NVIM-TREE
tools["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = require("configs.tools.tree"),
}

-- DROPBAR
tools["Bekaboo/dropbar.nvim"] = {
	lazy = false,
	config = require("configs.tools.dropbar"),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
}

--- REMOTE-NVIM
tools["amitds1997/remote-nvim.nvim"] = {
   version = "*", -- Pin to GitHub releases
   dependencies = {
       "nvim-lua/plenary.nvim", -- For standard functions
       "MunifTanjim/nui.nvim", -- To build the plugin UI
       "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
   },
   config = require("configs.tools.remote"),
}

-- Git Fugitive
tools["tpope/vim-fugitive"] = {
	lazy = true,
	cmd = { "Git", "G" },
}

-- Copy Paste
tools["ibhagwan/smartyank.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = require("configs.tools.smartyank"),
}

-- Run Snippets independent of the entire code block
tools["michaelb/sniprun"] = {
	lazy = true,
	-- You need to cd to `~/.local/share/nvim/site/lazy/sniprun/` and execute `bash ./install.sh`,
	-- if you encountered error about no executable sniprun found.
	build = "bash ./install.sh",
	cmd = { "SnipRun", "SnipReset", "SnipInfo" },
	config = require("configs.tools.sniprun"),
}

-- Trouble
tools["folke/trouble.nvim"] = {
	lazy = true,
	cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	config = require("configs.tools.trouble"),
}

-- Debugger
-- tools["mfussenegger/nvim-dap"] = {
-- 	lazy = true,
-- 	cmd = {
-- 		"DapSetLogLevel",
-- 		"DapShowLog",
-- 		"DapContinue",
-- 		"DapToggleBreakpoint",
-- 		"DapToggleRepl",
-- 		"DapStepOver",
-- 		"DapStepInto",
-- 		"DapStepOut",
-- 		"DapTerminate",
-- 	},
-- 	config = require("configs.tools.dap"),
-- 	dependencies = {
-- 		"rcarriga/nvim-dap-ui",
-- 		"jay-babu/mason-nvim-dap.nvim",
-- 	},
-- }

return tools
