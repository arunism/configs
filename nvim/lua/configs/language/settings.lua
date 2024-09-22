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


return settings
