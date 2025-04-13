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

ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("configs.ui.bufferline"),
}

ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = require("configs.ui.scrollview"),
}

ui["folke/todo-comments.nvim"] = {
	lazy = true,
	event = { "CursorHold", "CursorHoldI" },
	config = require("configs.ui.todo"),
	dependencies = { "nvim-lua/plenary.nvim" },
}

ui["shellRaining/hlchunk.nvim"] = {
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = require("configs.ui.hlchunk"),
}

-- ui["folke/edgy.nvim"] = {
-- 	lazy = true,
-- 	event = { "BufReadPre", "BufAdd", "BufNewFile" },
-- 	config = require("configs.ui.edgy"),
-- }

ui["j-hui/fidget.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("configs.ui.fidget"),
}


return ui
