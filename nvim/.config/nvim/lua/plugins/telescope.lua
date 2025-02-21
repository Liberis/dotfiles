return {
    'nvim-telescope/telescope.nvim',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup({})
    end
}
