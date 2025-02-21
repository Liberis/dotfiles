return {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
        require('onedark').setup {
            style = 'darker',
            transparent = true,
            term_colors = true,
        }
        vim.cmd("colorscheme onedark")
    end,

    "echasnovski/mini.icons",
    version = "*", -- Always get the latest stable version
    config = function()
        require("mini.icons").setup({})
    end
}

