---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- { import = "astrocommunity.motion.mini-move" },
  -- { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  -- { import = "astrocommunity.colorscheme.github-nvim-theme" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.proto" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.quickfix.nvim-bqf" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.code-runner.molten-nvim" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.code-runner.sniprun" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.vim-doge" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  { import = "astrocommunity.file-explorer.telescope-file-browser-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.octo-nvim" },
  { import = "astrocommunity.programming-language-support.csv-vim" },
  -- { import = "astrocommunity.keybinding.hydra-nvim" },
  { import = "astrocommunity.markdown-and-latex.vimtex" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.lsp.inc-rename-nvim" }, -- not playing nice without noice
  { import = "astrocommunity.lsp.lsp-signature-nvim" }, -- supposedly can use recipe below
  -- { import = "astrocommunity.recipes.astrolsp-auto-signature-help" }, -- change astrolsp features signature_help = true instead. Just use lsp-signature plugin
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
  { import = "astrocommunity.recipes.heirline-clock-statusline" },
  { import = "astrocommunity.recipes.heirline-mode-text-statusline" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  -- { import = "astrocommunity.media.image-nvim" },
  -- {
  --   "3rd/image.nvim",
  --   opts = {
  --     backend = "ueberzug",
  --   },
  -- },
  -- ImageMagick - mandatory
  -- magick LuaRock - mandatory (luarocks --local --lua-version=5.1 install magick)
  -- Magick LuaRock requires Lua 5.1
  -- Kitty >= 28.0 - for the kitty backend
  -- ueberzugpp - for the ueberzug backend
  -- curl - for remote images
  -- { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.marks-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.vim-matchup" },
  -- { import = "astrocommunity.motion.tabout-nvim" },
  -- { import = "astrocommunity.note-taking.neorg" },

  { import = "astrocommunity.search.nvim-spectre" },
  { import = "astrocommunity.project.project-nvim" }, -- supposedly this is default astronvim as of v4.0
  {
    "ahmedkhalf/project.nvim",
    opts = {
      lazy = false,
      exclude_dirs = { "~/cargo/*" },
      -- detection_methods = { "pattern" }, -- not "lsp" to hopefully correctly change when changing projects
      patterns = { ".git" },
      manual_mode = true, -- don't auto chdir

      -- Show hidden files in telescope
      -- show_hidden = true,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = false,
    },
  },
  -- { import = "astrocommunity.workflow.bad-practices-nvim" },
  -- { import = "astrocommunity.search.nvim-hlslens" },
  -- { import = "astrocommunity.syntax.vim-cool" },
  { import = "astrocommunity.syntax.vim-easy-align" },
  -- { import = "astrocommunity.terminal-integration.flatten-nvim" },
  { import = "astrocommunity.terminal-integration.vim-tmux-yank" },
  { import = "astrocommunity.terminal-integration.vim-tpipeline" },
  { import = "astrocommunity.utility.telescope-fzy-native-nvim" },
  -- try these later
  { import = "astrocommunity.test.neotest" }, -- conflicting bindings with roam
  --https://github.com/jvgrootveld/telescope-zoxide
  --https://github.com/wakatime/vim-wakatime
  -- { import = "astrocommunity.split-and-window.edgy-nvim" },
  -- { import = "astrocommunity.motion.flash-nvim" },
  -- { import = "astrocommunity.syntax.vim-sandwich" },
  -- { import = "astrocommunity.motion.harpoon" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  -- { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
  -- { import = "astrocommunity.completion.codeium-vim" },
}
