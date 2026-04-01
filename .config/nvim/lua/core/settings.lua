local settings = {}


settings["background"] = "dark"
settings["colorscheme"] = "catppuccin"
settings["lang_servers"] = {
  "lua_ls",
  "pyright",
  "clangd",
  -- "biome",
  "marksman",
  "yamlls",
  "dockerls",
  "jsonls",
  "harper_ls"
}
settings["transparent_background"] = true
settings["use_ssh"] = true


return settings
