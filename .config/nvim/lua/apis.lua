local fn = vim.fn
local vcmd = vim.cmd
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup


autogroup("bufcheck", { clear = true })


-- reload config file on change
autocmd("BufWritePost", {
  group = "bufcheck",
  pattern = vim.env.MYVIMRC,
  command = "silent source %"
})


-- highlight yanks
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = "bufcheck",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank{ timeout = 500 }
  end,
})


-- sync clipboards because I'm easily confused
autocmd("TextYankPost", {
  group = "bufcheck",
  pattern = "*",
  callback = function()
    fn.setreg("+", fn.getreg("*"))
  end
})


-- start terminal in insert mode
autocmd("TermOpen", {
  group = "bufcheck",
  pattern = "*",
  command = "startinsert | set winfixheight"
})


-- start git messages in insert mode
autocmd("FileType", {
  group = "bufcheck",
  pattern = { "gitcommit", "gitrebase", },
  command = "startinsert | 1"
})


-- pager mappings for Manual
autocmd("FileType", {
  group = "bufcheck",
  pattern = "man",
  callback = function()
    keymap("n", "<enter>", "K" , { buffer = true })
    keymap("n", "<backspace>", "<c-o>", { buffer = true })
  end
})


-- Return to last edit position when opening files
autocmd("BufReadPost",  {
  group = "bufcheck",
  pattern = "*",
  callback = function()
    if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
      fn.setpos(".", fn.getpos("'\""))
      -- vcmd("normal zz") -- how do I center the buffer in a sane way??
      vcmd("silent! foldopen")
    end
  end
})
