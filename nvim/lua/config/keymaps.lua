-- open file explorer with leader key
vim.keymap.set("n", "<Leader>e", "<cmd>Ex<CR>", { desc = "File explorer" })

-- fuzzy-search available commands
vim.keymap.set("n", "<Leader>x", "<cmd>Telescope commands<CR>", { desc = "Command palette" })

-- find files, text, and diagnostics
vim.keymap.set("n", "<Leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Current buffer" })
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<Leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })
vim.keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Files" })
vim.keymap.set("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep text" })
vim.keymap.set("n", "<Leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<Leader>fr", "<cmd>Telescope resume<CR>", { desc = "Resume picker" })

-- discover editor features
vim.keymap.set("n", "<Leader>ha", "<cmd>Telescope autocommands<CR>", { desc = "Autocommands" })
vim.keymap.set("n", "<Leader>hb", "<cmd>Telescope builtin<CR>", { desc = "Telescope pickers" })
vim.keymap.set("n", "<Leader>hc", "<cmd>Telescope command_history<CR>", { desc = "Command history" })
vim.keymap.set("n", "<Leader>hf", "<cmd>Telescope filetypes<CR>", { desc = "Filetypes" })
vim.keymap.set("n", "<Leader>hh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<Leader>hH", "<cmd>Telescope highlights<CR>", { desc = "Highlights" })
vim.keymap.set("n", "<Leader>hj", "<cmd>Telescope jumplist<CR>", { desc = "Jumplist" })
vim.keymap.set("n", "<Leader>hk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<Leader>hM", "<cmd>Telescope marks<CR>", { desc = "Marks" })
vim.keymap.set("n", "<Leader>hm", "<cmd>Telescope man_pages<CR>", { desc = "Man pages" })
vim.keymap.set("n", "<Leader>ho", "<cmd>Telescope vim_options<CR>", { desc = "Options" })
vim.keymap.set("n", "<Leader>hr", "<cmd>Telescope registers<CR>", { desc = "Registers" })
vim.keymap.set("n", "<Leader>hs", "<cmd>Telescope search_history<CR>", { desc = "Search history" })
