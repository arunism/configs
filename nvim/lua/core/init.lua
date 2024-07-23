local settings = require("core.settings")


require("core.global")
require("core.options")
require("core.pmanager")
require("keymaps")


vim.cmd.colorscheme(settings.colorscheme)
