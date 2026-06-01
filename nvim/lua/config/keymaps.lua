-- open file explorer with leader key
vim.keymap.set("n", "<Leader>e", "<cmd>Ex<CR>", { desc = "File explorer" })

-- fuzzy-search available commands
vim.keymap.set("n", "<Leader>x", "<cmd>Telescope commands<CR>", { desc = "Command palette" })
