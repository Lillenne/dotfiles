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
vim.opt.clipboard = "unnamed"
-- vim.cmd "set cmdheight=2"
vim.cmd "set shortmess+=FaT"
-- vim.cmd "set foldlevelstart=99"
-- vim.cmd "set foldlevel=99"
-- vim.cmd "set nofoldenable"
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {})

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

-- Copilot autosuggestions
vim.g.copilot_no_tab_map = true
vim.g.copilot_hide_during_completion = 0

local chat = require "CopilotChat"
local actions = require "CopilotChat.actions"
local integration = require "CopilotChat.integrations.telescope"

local function pick(pick_actions)
  return function() integration.pick(pick_actions(), {}) end
end

chat.setup {
  question_header = "",
  answer_header = "",
  error_header = "",
  allow_insecure = true,
  mappings = {
    reset = {
      normal = "",
      insert = "",
    },
  },
  prompts = {
    Explain = {
      mapping = "<leader>Ae",
      description = "AI Explain",
    },
    Review = {
      mapping = "<leader>Ar",
      description = "AI Review",
    },
    Tests = {
      mapping = "<leader>At",
      description = "AI Tests",
    },
    Fix = {
      mapping = "<leader>Af",
      description = "AI Fix",
    },
    Optimize = {
      mapping = "<leader>Ao",
      description = "AI Optimize",
    },
    Docs = {
      mapping = "<leader>Ad",
      description = "AI Documentation",
    },
    CommitStaged = {
      mapping = "<leader>Ac",
      description = "AI Generate Commit",
    },
  },
}

vim.keymap.set({ "n", "v" }, "<leader>Aa", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "n", "v" }, "<leader>Ax", chat.reset, { desc = "AI Reset" })
vim.keymap.set({ "n", "v" }, "<leader>Ah", pick(actions.help_actions), { desc = "AI Help Actions" })
vim.keymap.set({ "n", "v" }, "<leader>AA", pick(actions.prompt_actions), { desc = "AI Prompt Actions" })
----------------------------------------------------------------
local install_dir = vim.fs.joinpath(vim.fn.stdpath "data", "mason")
local dap = require "dap"
dap.adapters.netcoredbg = {
  type = "executable",
  command = install_dir .. "/packages/netcoredbg/netcoredbg",
  args = { "--interpreter=vscode" },
}
require("neotest").setup {
  adapters = {
    require "neotest-dotnet" {
      dap = {
        -- Extra arguments for nvim-dap configuration
        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
        args = { justMyCode = true },
        -- Enter the name of your dap adapter, the default value is netcoredbg
        adapter_name = "netcoredbg",
      },
      -- Let the test-discovery know about your custom attributes (otherwise tests will not be picked up)
      -- Note: Only custom attributes for non-parameterized tests should be added here. See the support note about parameterized tests
      -- custom_attributes = {
      --   xunit = { "MyCustomFactAttribute" },
      --   nunit = { "MyCustomTestAttribute" },
      --   mstest = { "MyCustomTestMethodAttribute" }
      -- },
      -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
      dotnet_additional_args = {
        "--verbosity detailed",
      },
      -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
      -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
      --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
      discovery_root = "project", -- Default
    },
  },
}

---------------------------------------------------------------
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
