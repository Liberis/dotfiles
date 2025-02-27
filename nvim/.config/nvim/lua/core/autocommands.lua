-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    command = "mksession! ~/.config/nvim/session.vim"
})

-- vim.opt.cmdheight = 0  -- Hide command line when not in use
--
-- -- Automatically show the command line when entering command mode
-- vim.api.nvim_create_autocmd("CmdlineEnter", {
--     pattern = "[:/?]",
--     callback = function() vim.opt.cmdheight = 1 end,
-- })
--
--
-- -- Autohide command line bar
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--     pattern = "[:/?]",
--     callback = function() vim.opt.cmdheight = 0 end,
-- })

