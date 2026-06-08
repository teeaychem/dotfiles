vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.enable({
    "ty",
    "clangd"
})
vim.lsp.inline_completion.enable()
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
