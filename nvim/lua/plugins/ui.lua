local ui = {}


ui["catppuccin/nvim"] = {
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = require("configs.ui.catppuccin"),
}


return ui
