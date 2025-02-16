-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
-- vim.opt.autochdir = true
-- vim.api.nvim_set_keymap(
--   "n",
--   "<Leader><Space>",
--   "<cmd>lua require('telescope.builtin').find_files({cwd='~/.config/'})<CR>",
--   {}
-- )
--

vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {})
vim.api.nvim_set_option("clipboard", "unnamed")

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }
--
--

-- setup luarocks - requires nightly?
do
  -- Specifies where to install/use rocks.nvim
  local install_location = vim.fs.joinpath(vim.fn.stdpath "data", "rocks")

  -- Set up configuration options related to rocks.nvim (recommended to leave as default)
  local rocks_config = {
    rocks_path = vim.fs.normalize(install_location),
    luarocks_binary = vim.fs.joinpath(install_location, "bin", "luarocks"),
  }

  vim.g.rocks_nvim = rocks_config

  -- Configure the package path (so that plugin code can be found)
  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

  -- Configure the C path (so that e.g. tree-sitter parsers can be found)
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

  -- Load all installed plugins, including rocks.nvim itself
  vim.opt.runtimepath:append(
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*")
  )
end

-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
  local rocks_location = vim.fs.joinpath(vim.fn.stdpath "cache", "rocks.nvim")

  if not vim.uv.fs_stat(rocks_location) then
    -- Pull down rocks.nvim
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/nvim-neorocks/rocks.nvim",
      rocks_location,
    }
  end

  -- If the clone was successful then source the bootstrapping script
  assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")

  vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

  vim.fn.delete(rocks_location, "rf")
end
