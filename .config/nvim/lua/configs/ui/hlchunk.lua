return function()
  -- Define the configuration directly
  local configs = {
    chunk = {
      enable = true,
        style = {
          { fg = "#806d9c" },
          { fg = "#f35336" },
        },
    },
  }

  require("hlchunk").setup(configs)
end
