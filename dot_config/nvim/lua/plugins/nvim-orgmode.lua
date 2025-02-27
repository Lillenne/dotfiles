return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    config = function()
      require("orgmode").setup {
        org_agenda_files = { "~/org/*" },
        org_default_notes_file = "~/org/notes.org",
        org_startup_folded = "showeverything",
      }
    end,
  },
  {
    "chipsenkbeil/org-roam.nvim",
    tag = "0.1.0",
    dependencies = {
      {
        "nvim-orgmode/orgmode",
        tag = "0.3.4",
      },
    },
    config = function()
      require("org-roam").setup {
        directory = "~/org/roam",
      }
    end,
  },
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-orgmode/orgmode",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension "orgmode"

      vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
      vim.keymap.set("n", "<leader>fH", require("telescope").extensions.orgmode.search_headings)
      vim.keymap.set("n", "<leader>nil", require("telescope").extensions.orgmode.insert_link)
    end,
  },
}
