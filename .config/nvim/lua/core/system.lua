local system = {}
local os_name = vim.uv.os_uname().sysname


function system:init()
  self.is_linux = (os_name == "Linux")
  self.is_mac = (os_name == "Darwin")
  self.is_windows = (os_name == "Windows_NT")
  self.is_wsl = (vim.fn.has("wsl") == 1)
  self.vim_path = vim.fn.stdpath("config")
  self.cache_dir = vim.fn.stdpath("cache")
  self.data_dir = vim.fn.stdpath("data")
  self.home = self.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")
end


system:init()

return system
