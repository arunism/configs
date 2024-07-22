return function()
  -- Simulate loading transparent_background from core.settings module
  local transparent_background = require("core.settings").transparent_background

  -- Define the configuration directly
  local configs = {
    background = { light = "latte", dark = "mocha" },
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    transparent_background = transparent_background,
    styles = {
      comments = { "italic" },
      functions = { "bold" },
    },
    integrations = {
      treesitter = true,
      which_key = true,
    },
    color_overrides = {},
    highlight_overrides = {
      all = function(cp)
        return {
          -- For base configs
          NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
	  FloatBorder = {
	    fg = transparent_background and cp.blue or cp.mantle,
	    bg = transparent_background and cp.none or cp.mantle,
	  },
	  CursorLineNr = { fg = cp.green },
        }
      end,
    },
  }

  -- Integrate all the configurations
  require("catppuccin").setup(configs)
end
