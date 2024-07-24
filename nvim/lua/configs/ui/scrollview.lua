return function()
  local icons = { diagnostics = require("utils.icons").get("diagnostics", true) }

  -- Define the configuration directly
  local configs = {
    mode = "virtual",
		winblend = 0,
		signs_on_startup = { "diagnostics", "folds", "marks", "search", "spell" },
		diagnostics_error_symbol = icons.diagnostics.Error,
		diagnostics_warn_symbol = icons.diagnostics.Warning,
		diagnostics_info_symbol = icons.diagnostics.Information,
		diagnostics_hint_symbol = icons.diagnostics.Hint,
		excluded_filetypes = {
			"alpha",
			"fugitive",
			"git",
			"notify",
			"NvimTree",
			"Outline",
			"TelescopePrompt",
			"toggleterm",
			"undotree",
		},
  }

  -- Integrate all the configurations
  require("scrollview").setup(configs)
end
