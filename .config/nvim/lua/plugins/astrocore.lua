-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure project root detection, check status with `:AstroRootInfo`
    -- rooter = {
    --   -- list of detectors in order of prevalence, elements can be:
    --   --   "lsp" : lsp detection
    --   --   string[] : a list of directory patterns to look for
    --   --   fun(bufnr: integer): string|string[] : a function that takes a buffer number and outputs detected roots
    --   detector = {
    --     "lsp", -- highest priority is getting workspace from running language servers
    --     { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
    --     { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
    --   },
    --   -- ignore things from root detection
    --   ignore = {
    --     servers = {}, -- list of language server names to ignore (Ex. { "efm" })
    --     dirs = {}, -- list of directory patterns (Ex. { "~/.cargo/*" })
    --   },
    --   -- automatically update working directory (update manually with `:AstroRoot`)
    --   autochdir = false,
    --   -- scope of working directory to change ("global"|"tab"|"win")
    --   scope = "global",
    --   -- show notification on every working directory change
    --   notify = false,
    -- },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        -- L = {
        --   function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        --   desc = "Next buffer",
        -- },
        -- H = {
        --   function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        --   desc = "Previous buffer",
        -- },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>bN"] = { "<Cmd>enew<CR>", desc = "new buffer" },
        ["<Leader>n"] = false,
        ["<C-/>"] = { "gcc", remap = true, desc = "Toggle comment line" },
        -- ["<Leader>n"] = { desc = "Org-roam" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command

        -- ["<Leader>o"] = false,
        ["<Leader>."] = { ":Telescope file_browser<CR>", desc = "Find Dirs" },
        ["<Leader>,"] = { ":Telescope buffers<CR>", desc = "Find Buffers" },
        ["<Leader>pp"] = { ":Telescope projects<CR>", desc = "Find Projects" },
        ["<Leader>le"] = { ":Telescope diagnostics<CR>", desc = "Find Diagnostics" },
        ["<Leader>lx"] = { ":Telescope diagnostics<CR>", desc = "Find Diagnostics" },
        ["<Leader>fe"] = { ":Telescope diagnostics<CR>", desc = "Find Diagnostics" },
        ["<Leader>f."] = { ":Telescope current_buffer_fuzzy_find<CR>", desc = "Find in Buffer" },
        ["<Leader><Space>"] = { ":Telescope find_files<CR>", desc = "Find files" },
        ["<C-x>"] = { ":x<CR>", desc = "Save & Exit" },
        ["<Leader>gg"] = { ":Neogit<CR>", desc = "Git" },
        ["<Leader>ot"] = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" },
        ["<Leader>rd"] = { "<cmd>DogeGenerate<CR>", desc = "Generate comments" },
        ["<Leader>tz"] = { "<cmd>ZenMode<CR>", desc = "Zen mode" },
        -- ["<Leader>jt"] = { "<cmd>:Neorg journal today<cr>", desc = "Neorg journal today" },
        -- ["<Leader>jy"] = { "<cmd>:Neorg journal yesterday<cr>", desc = "Neorg journal today" },
        -- ["<Leader>jT"] = { "<cmd>:Neorg journal tomorrow<cr>", desc = "Neorg journal today" },
        -- ["<Leader>jm"] = {
        --   "<cmd>:Neorg keybind all core.looking-glass.magnify-code-block<cr>",
        --   desc = "Neorg magnify code block",
        -- },

        ["<Leader>yp"] = { ":let @+ = expand('%:p')<cr>" },
        ["<Leader>yr"] = { ":let @+ = expand('%')<cr>" },
        ["<Leader>yn"] = { ":let @+ = expand('%:t')<cr>" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
      i = {
        -- ["<C-x>"] = { "<ESC>:x<CR>", desc = "Save & Exit" },
        -- ["<C-S-Space>"] = { "" },
      },
      x = {
        ["<C-/>"] = { "gc", remap = true, desc = "Toggle comment" },
      },
    },
  },
}
