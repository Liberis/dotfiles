-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    command = "mksession! ~/.config/nvim/session.vim"
})

