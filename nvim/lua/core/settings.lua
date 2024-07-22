local settings = {}


-- Set it to false if you want to use https to update plugins and treesitter parsers.
---@type boolean
settings["use_ssh"] = true


-- Set Colorscheme
---@type string
settings["colorscheme"] = "catppuccin"

---@type boolean
settings["transparent_background"] = true

---@type "dark"|"light"
settings["background"] = "dark"


return settings
