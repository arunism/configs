return function()
  local icons = { ui = require("utils.icons").get("ui") }

  -- Define the configuration directly
  local configs = {
    highlights = {},
    options = {
			number = nil,
			close_command = "BufDel! %d",
			right_mouse_command = "BufDel! %d",
			modified_icon = icons.ui.Modified,
			buffer_close_icon = icons.ui.Close,
			left_trunc_marker = icons.ui.Left,
			right_trunc_marker = icons.ui.Right,
			max_name_length = 20,
			max_prefix_length = 13,
			tab_size = 20,
			color_icons = true,
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			enforce_regular_tabs = false,
			persist_buffer_sort = true,
			always_show_bufferline = true,
			separator_style = "thin",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					padding = 0,
				},
				{
					filetype = "aerial",
					text = "Symbol Outline",
					text_align = "center",
					padding = 0,
				},
			},
		},
  }

  -- Integrate all the configurations
  require("bufferline").setup(configs)
end
