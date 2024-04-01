---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.debugging.nvim-bqf" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.code-runner.sniprun" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.markdown-and-latex.vimtex" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.lsp.inc-rename-nvim" }, -- not playing nice without noice
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.media.image-nvim" },
  {
    "3rd/image.nvim",
    opts = {
      backend = "ueberzug",
    },
  },
  -- ImageMagick - mandatory
  -- magick LuaRock - mandatory (luarocks --local --lua-version=5.1 install magick)
  -- Magick LuaRock requires Lua 5.1
  -- Kitty >= 28.0 - for the kitty backend
  -- ueberzugpp - for the ueberzug backend
  -- curl - for remote images
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.nvim-spider" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.motion.vim-matchup" },
  { import = "astrocommunity.motion.tabout-nvim" },
  { import = "astrocommunity.note-taking.neorg" },

  { import = "astrocommunity.project.nvim-spectre" },
  { import = "astrocommunity.project.project-nvim" },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      lazy = false,
    },
  },
  { import = "astrocommunity.workflow.hardtime-nvim" },
  { import = "astrocommunity.search.nvim-hlslens" },
  { import = "astrocommunity.syntax.vim-cool" },
  { import = "astrocommunity.syntax.vim-easy-align" },
  { import = "astrocommunity.terminal-integration.flatten-nvim" },
  { import = "astrocommunity.terminal-integration.vim-tmux-yank" },
  { import = "astrocommunity.terminal-integration.vim-tpipeline" },
  -- { import = "astrocommunity.utility.noice-nvim" },
  -- try these later
  -- { import = "astrocommunity.test.neotest" },
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
