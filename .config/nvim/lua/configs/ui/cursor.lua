return function()
  -- Define the configuration directly
  local configs = {
    stiffness = 0.3,
    trailing_stiffness = 0.1,
    trailing_exponent = 5,
    hide_target_hack = true,
    gamma = 1,

    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    }
  }

  -- Integrate all the configurations
  require("smear_cursor").setup(configs)
end
