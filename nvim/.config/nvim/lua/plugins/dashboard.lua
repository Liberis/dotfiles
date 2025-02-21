return
{
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup {
      theme = "hyper",  -- Options: doom, hyper, hyper-alt, default
      config = {
        header = {
"██╗███╗   ██╗██╗████████╗██████╗",
" ██║████╗  ██║██║╚══██╔══╝██╔══██╗",
" ██║██╔██╗ ██║██║   ██║   ██║  ██║",
" ██║██║╚██╗██║██║   ██║   ██║  ██║",
" ██║██║ ╚████║██║   ██║   ██████╔╝",
"╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═════╝ ",                                
        },
        center = {
          { icon = " ", desc = " Recent Files", action = "Telescope oldfiles", key = "r" },
          { icon = " ", desc = " Find File", action = "Telescope find_files", key = "f" },
          { icon = " ", desc = " Load Session", action = "SessionLoad", key = "s" },
          { icon = " ", desc = " Neovim Config", action = "edit ~/.config/nvim/init.lua", key = "c" },
          { icon = " ", desc = " Quit Neovim", action = "qa", key = "q" },
        },
        footer = { "Keep Calm and Stay Lucky" },
      }
    }
  end,
}

