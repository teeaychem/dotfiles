vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.netrw_liststyle = 3

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local opt = vim.opt

opt.autoindent = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- use system clipboard if not in ssh
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true -- highlight the current cursor line
opt.expandtab = true
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- absolute line number on cursor line
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.swapfile = true -- turn on swapfile
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = true -- line wrap

vim.cmd("nnoremap <C-c> <cmd>WhichKey<cr>")
vim.cmd("vnoremap <C-c> <cmd>WhichKey '' v<cr>")
vim.cmd("inoremap <C-c> <cmd>WhichKey '' i<cr>")
vim.cmd("cnoremap <C-c> <cmd>WhichKey '' c<cr>")
