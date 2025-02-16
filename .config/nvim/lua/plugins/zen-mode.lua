return {
  "folke/zen-mode.nvim",
  keys = { { "<leader>to", "<cmd>ZenMode<cr>", desc = "Zen mode"} },
  config = function()
    require("zen-mode").setup({
        window = {
            width = .45,
        },
        alacritty = {
          enabled = true,
          font = "+4", -- font size
        },
        tmux = {
            enabled = true
        },
    })
  end,
}
