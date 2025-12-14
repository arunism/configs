local settings = {}


settings["pylsp"] = {
  pylsp = {
    plugins = {
      pycodestype = {
        ignore = {'W391'},
        maxLineLength = 100
      }
    }
  }
}


settings["pyright"] = {
  python = {
    analysis = {
      autoSearchPaths = true,
      diagnosticMode = "openFilesOnly",
      useLibraryCodeForTypes = true
    }
  }
}


return settings
