return function()
  local cache_dir = require("core.system").cache_dir

  -- Define the configuration directly
  local configs = {
    background = { light = "latte", dark = "mocha" },
    dim_inactive = {
      enabled = false,
      shade = "dark",
      percentage = 0.15,
    },
    transparent_background = require("core.settings").transparent_background,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
		term_colors = true,
		compile_path = cache_dir .. "/catppuccin",
		styles = {
			comments = { "italic" },
			functions = { "bold" },
			keywords = { "italic" },
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold", "italic" },
			numbers = {},
			types = {},
			strings = {},
			variables = {},
			properties = {},
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			aerial = true,
			alpha = false,
			barbar = false,
			beacon = false,
			cmp = true,
			coc_nvim = false,
			dap = true,
			dap_ui = true,
			dashboard = false,
			dropbar = { enabled = true, color_mode = true },
			fern = false,
			fidget = true,
			flash = true,
			gitgutter = false,
			gitsigns = true,
			harpoon = false,
			headlines = false,
			hop = true,
			illuminate = true,
			indent_blankline = { enabled = true, colored_indent_levels = false },
			leap = false,
			lightspeed = false,
			lsp_saga = true,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			mini = false,
			navic = { enabled = false },
			neogit = false,
			neotest = false,
			neotree = { enabled = false, show_root = true, transparent_panel = false },
			noice = false,
			notify = true,
			nvimtree = true,
			overseer = false,
			pounce = false,
			rainbow_delimiters = true,
			sandwich = false,
			semantic_tokens = true,
			symbols_outline = false,
			telekasten = false,
			telescope = { enabled = true, style = "nvchad" },
			treesitter_context = true,
			ts_rainbow = false,
			vim_sneak = false,
			vimwiki = false,
			which_key = true,
		},
		color_overrides = {},
		highlight_overrides = {
			---@param cp palette
			all = function(cp)
				return {
					-- For base configs
					NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
					FloatBorder = {
						fg = transparent_background and cp.blue or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},
					CursorLineNr = { fg = cp.green },

					-- For native lsp configs
					DiagnosticVirtualTextError = { bg = cp.none },
					DiagnosticVirtualTextWarn = { bg = cp.none },
					DiagnosticVirtualTextInfo = { bg = cp.none },
					DiagnosticVirtualTextHint = { bg = cp.none },
					LspInfoBorder = { link = "FloatBorder" },

					-- For mason.nvim
					MasonNormal = { link = "NormalFloat" },

					-- For nvim-cmp and wilder.nvim
					Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
					PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
					PmenuSel = { bg = cp.green, fg = cp.base },
					CmpItemAbbr = { fg = cp.overlay2 },
					CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
					CmpDoc = { link = "NormalFloat" },
					CmpDocBorder = {
						fg = transparent_background and cp.surface1 or cp.mantle,
						bg = transparent_background and cp.none or cp.mantle,
					},

					-- For nvim-notify
					NotifyBackground = { bg = cp.base },

					-- For nvim-tree
					NvimTreeRootFolder = { fg = cp.pink },
					NvimTreeIndentMarker = { fg = cp.surface2 },

					-- For telescope.nvim
					TelescopeMatching = { fg = cp.lavender },
					TelescopeResultsDiffAdd = { fg = cp.green },
					TelescopeResultsDiffChange = { fg = cp.yellow },
					TelescopeResultsDiffDelete = { fg = cp.red },

					-- For treesitter
					["@keyword.return"] = { fg = cp.pink, style = clear },
					["@error.c"] = { fg = cp.none, style = clear },
					["@error.cpp"] = { fg = cp.none, style = clear },
				}
			end,
		},
  }

  -- Integrate all the configurations
  require("catppuccin").setup(configs)
end
