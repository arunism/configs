local ui = {}


ui["catppuccin/nvim"] = {
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = require("configs.ui.catppuccin"),
}

ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("configs.ui.lualine"),
}

ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.ui.gitsigns"),
}


return ui
