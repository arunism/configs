return function()
	local icons = {
		diagnostics = require("utils.icons").get("diagnostics"),
		ui = require("utils.icons").get("ui"),
	}

  -- Define the configuration directly
  local configs = {
    ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
		stages = "fade",
		---@usage Function called when a new window is opened, use for changing win settings/config
		on_open = function(win)
			vim.api.nvim_set_option_value("winblend", 0, { scope = "local", win = win })
			vim.api.nvim_win_set_config(win, { zindex = 90 })
		end,
		---@usage Function called when a window is closed
		on_close = nil,
		---@usage timeout for notifications in ms, default 5000
		timeout = 4000,
		-- @usage User render fps value
		fps = 20,
		-- Render function for notifications. See notify-render()
		render = "default",
		---@usage highlight behind the window for stages that change opacity
		background_colour = "NotifyBackground",
		---@usage minimum width for notification windows
		minimum_width = 50,
		---@usage notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
		level = "INFO",
		---@usage Icons for the different levels
		icons = {
			ERROR = icons.diagnostics.Error,
			WARN = icons.diagnostics.Warning,
			INFO = icons.diagnostics.Information,
			DEBUG = icons.ui.Bug,
			TRACE = icons.ui.Pencil,
		},
  }

  -- Integrate all the configurations
  local notify = require("notify")
  notify.setup(configs)
  vim.notify = notify
end
