local ui = require("plugins.ui")
local tools = require("plugins.tools")

local plugins = {}


local function extend(target, source)
    for key, value in pairs(source) do
        target[key] = value
    end
end


extend(plugins, ui)
extend(plugins, tools)


return plugins
