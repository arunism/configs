return function()
	local icons = { ui = require("utils.icons").get("ui") }

  -- Define the configuration directly
  local configs = {
    auto_open = false,
		auto_close = false,
		auto_jump = false,
		auto_preview = true,
		auto_refresh = true,
		focus = false, -- do not focus the window when opened
		follow = true,
		restore = true,
		icons = {
			indent = {
				fold_open = icons.ui.ArrowOpen,
				fold_closed = icons.ui.ArrowClosed,
			},
			folder_closed = icons.ui.Folder,
			folder_open = icons.ui.FolderOpen,
		},
		modes = {
			project_diagnostics = {
				mode = "diagnostics",
				filter = {
					any = {
						{
							function(item)
								return item.filename:find(vim.fn.getcwd(), 1, true)
							end,
						},
					},
				},
			},
		},
  }

  -- Integrate all the configurations
  require("trouble").setup(configs)
end
