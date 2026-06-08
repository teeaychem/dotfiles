local M = {
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                    themes = { "catppuccin" }, -- Your list of installed colorschemes.
                    livePreview = true, -- Apply theme while picking. Default to true.-- add the config here
                                    })
        end
    },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}

return { M }
