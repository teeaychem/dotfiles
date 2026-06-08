local lazy_core = {}


local fzf = {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons", },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
}
table.insert(lazy_core, fzf)

-- local lazydev = {
--   "folke/lazydev.nvim",
--   ft = "lua", -- only load on lua files
--   opts = {
--     library = {
--       -- See the configuration section for more details
--       -- Load luvit types when the `vim.uv` word is found
--       {
--         path = "${3rd}/luv/library",
--         words = { "vim%.uv", },
--       },
--       {
--         path = "lazy.nvim",
--         words = { "LazyVim", },
--       },
--     },
--   },
-- }
-- table.insert(lazy_core, lazydev)


local nvim_cmp = { -- optional cmp completion source for require statements and module annotations
  "elePre",
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
  },
}
table.insert(lazy_core, persistence)


return lazy_core
