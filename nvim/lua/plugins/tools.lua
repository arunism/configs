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


return tools
