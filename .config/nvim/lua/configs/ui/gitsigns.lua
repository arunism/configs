return function()
  -- Define the configuration directly
  local configs = {
    auto_attach = true,
    -- on_attach = "",
    signcolumn = true,
    sign_priority = 6,
    update_debounce = 100,
    word_diff = false,
    current_line_blame = true,
    diff_opts = { internal = true },
    watch_gitdir = { follow_files = true },
    current_line_blame_opts = { delay = 1000, virt_text = true, virtual_text_pos = "eol" },
    signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
  }

  -- Integrate all the configurations
  require("gitsigns").setup(configs)
end
