return function ()
   local configs = {
     offline_mode = {
     enabled = true,
     no_github = false,
    },
  }

  -- Integrate all the configurations
  require("remote-nvim").setup(configs)
end
