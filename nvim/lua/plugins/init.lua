local ui = require("plugins.ui")

local plugins = {}


local function extend(target, source)
    for key, value in pairs(source) do
        target[key] = value
    end
end


extend(plugins, ui)


return plugins
