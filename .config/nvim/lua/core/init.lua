local settings = require("core.settings")


require("core.global")
require("core.options")
require("core.pmanager")
require("keymaps")
require("apis")


vim.cmd.colorscheme(settings.colorscheme)
