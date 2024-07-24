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


return tools
