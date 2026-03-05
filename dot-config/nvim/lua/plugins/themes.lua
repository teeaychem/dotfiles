local M = {
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
        require("themery").setup({
            themes = {"catppuccin", "nightfox", "evergarden"}, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.-- add the config here
        })
        end
    },

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    { 
        "EdenEast/nightfox.nvim", 
        options = {
            styles = {
                comments = "italic",
                keywords = "bold",
                types = "italic,bold",
            }
        }
    },
{
  'everviolet/nvim', name = 'evergarden',
  priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
  opts = {
    theme = {
      variant = 'fall', -- 'winter'|'fall'|'spring'|'summer'
      accent = 'green',
    },
    editor = {
      transparent_background = false,
      sign = { color = 'none' },
      float = {
        color = 'mantle',
        invert_border = false,
      },
      completion = {
        color = 'surface0',
      },
    },
  }
}


}
return { M }
