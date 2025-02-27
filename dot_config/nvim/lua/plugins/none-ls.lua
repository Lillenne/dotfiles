-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    { "AstroNvim/astrolsp", opts = {} },
  },
  opts = function() return { on_attach = require("astrolsp").on_attach } end,
}
