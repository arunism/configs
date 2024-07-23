local keymap = vim.keymap.set


-- TELESCOPE KEYMAPS
keymap(
  "n",
  "<C-p>",
  function()
    require("telescope.builtin").keymaps({
      lhs_filter = function(lhs) return not string.find(lhs, "Þ") end,
      layout_config = { width = 0.6, height = 0.6, prompt_position = "top" },
    })
  end,
  { silent = true, noremap = true, desc = "TOOL: Toggle command panel" }
)

keymap(
  "n",
  "<leader>ff",
  function() require("search").open({ collection = "file" }) end,
  { silent = true, noremap = true, desc = "TOOL: Find files" }
)
