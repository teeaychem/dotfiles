-- Theme (load on startup)
vim.pack.add({
  "https://github.com/catppuccin/nvim",
})
vim.cmd.colorscheme('catppuccin')
require("catppuccin").setup({
  integrations = {
    aerial = true,
    alpha = true,
    cmp = true,
    dashboard = true,
    flash = true,
    fzf = true,
    grug_far = true,
    gitsigns = true,
    headlines = true,
    illuminate = true,
    indent_blankline = { enabled = true },
    leap = true,
    lsp_trouble = true,
    mason = true,
    mini = true,
    navic = { enabled = true, custom_bg = "lualine" },
    neotest = true,
    neotree = true,
    noice = true,
    notify = true,
    snacks = true,
    telescope = true,
    treesitter_context = true,
    which_key = true,
  },
})


vim.pack.add({
  "https://github.com/echasnovski/mini.nvim"
})
require("mini.statusline").setup({
    use_icons = false,
})

vim.pack.add({
  "https://github.com/folke/which-key.nvim",
})
require('which-key').setup({
  mappings = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false, }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  }
})
vim.cmd("nnoremap <C-c> <cmd>WhichKey<cr>")
vim.cmd("vnoremap <C-c> <cmd>WhichKey '' v<cr>")
vim.cmd("inoremap <C-c> <cmd>WhichKey '' i<cr>")
vim.cmd("cnoremap <C-c> <cmd>WhichKey '' c<cr>")


vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {},
  extensions = {}
}


vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
      require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    })
  end
})
