vim.g.start_time = vim.loop.hrtime()  -- Capture startup time at the beginning

return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII Header
        dashboard.section.header.val = {
            "⠀⠀⠀⠀⣠⣶⣶⣶⣶⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣶⣶⣶⣄⠀⠀⠀⠀",
            "⠀⠀⠀⢰⣿⠋⠀⠀⠉⢻⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠋⠀⠀⠈⣿⣇⣀⠀⠀",
            "⢀⣴⣿⠿⠿⠀⠀⠀⠀⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣇⠀⠀⠀⠀⠛⠛⢿⣷⡄",
            "⢸⣿⠁⠀⠀⠀⠀⠀⠀⢻⣿⣆⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⣶⣿⣿⣿⣿⣿⡿⠿⠿⠿⣿⣿⣿⣿⣿⣷⣶⣤⣄⡀⠀⠀⠀⠀⠀⢀⣴⣿⠟⠀⠀⠀⠀⠀⠀⠀⣻⣷",
            "⠘⣿⣧⡀⠀⢀⣀⠀⠀⠀⠙⢿⣷⣄⠀⢀⣴⣾⣿⣿⡿⠟⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠿⣿⣿⣷⣦⣀⠀⣠⣿⡟⠁⠀⠀⠀⣠⣀⠀⠀⣠⣿⡏",
            "⠀⠈⠻⢿⡿⠿⢿⣷⣄⠀⠀⠀⠙⣿⣷⣿⣿⠟⠋⠀⠀⣀⣠⣤⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣤⣀⠀⠀⠉⠻⢿⣿⣿⣿⠋⠀⠀⠀⣠⣾⡿⠿⢿⣿⠿⠋⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣄⣠⣾⣿⡿⠋⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠙⠿⣿⣿⣦⣠⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡿⠋⠀⢀⣴⣿⣿⣿⣿⣿⡿⠟⠛⠉⠉⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠿⣿⣿⣿⣿⣿⣦⡀⠀⠘⢿⣿⣿⣏⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⠟⠀⠀⣴⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣦⡀⠀⠙⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠋⠀⢠⣾⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣄⠀⠈⢿⣿⣷⡀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⣼⣿⣿⠃⠀⣠⣿⣿⣿⣿⣿⣃⣀⣀⣤⣤⣤⣤⣤⠤⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠤⣤⣤⣤⣤⣤⣈⣿⣿⣿⣿⣿⣆⠀⠈⢿⣿⣷⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⢸⣿⣿⠇⠀⢠⣿⣿⣿⣿⡿⠛⠉⠉⠉⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠉⠉⢻⣿⣿⣿⣿⣆⠀⠈⢿⣿⣧⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⣿⣿⡏⠀⢠⣿⣿⣿⣿⣿⠷⠶⠞⠛⠛⠛⠋⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠙⠛⠛⠛⠾⠿⠿⣿⣿⣿⣆⡀⠘⣿⣿⡄⠀⠀⠀⠀",
            "⠀⠀⠀⠀⢸⣿⣿⡷⠾⠛⠋⠉⠁⠀⢀⣠⣤⣶⡶⠶⠾⠟⠛⠛⠛⠛⠛⠛⠉⠉⠙⠛⠛⠛⠛⠛⠛⠛⠛⠛⠻⠿⠷⠶⢶⣤⠀⠀⠀⠉⠉⠛⠻⠿⣿⣧⠀⠀⠀⠀",
            "⠀⠀⠀⠀⢸⣿⣥⣤⣤⣀⣀⣀⣀⣰⣿⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣧⣀⣤⣤⣤⣤⠴⢶⣾⣿⠀⠀⠀⠀",
            "⠀⠀⠀⠀⣼⣿⡇⠀⢹⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⣸⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⠀⠀⠀⠀",
            "⠀⠀⠀⠀⣿⣿⡇⠀⢸⣿⣿⣿⣿⣿⣿⡄⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⠀⠀⠀⠀",
            "⠀⠀⠀⠀⢸⣿⣿⠀⠈⣿⣿⣿⣿⣿⣿⣧⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⢰⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⠀⠀⠀⠀",
            "⠀⠀⠀⠀⢸⣿⣿⡀⠀⢿⣿⣿⣿⣿⣿⣿⣆⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⢠⣿⣿⣿⣿⣿⣿⣿⠁⠀⣾⣿⡿⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠈⣿⣿⡇⠀⠘⣿⣿⣿⣿⣿⣿⣿⣦⠀⠙⢿⣿⣿⣿⣿⣿⠟⠁⠀⣀⣀⡀⠀⠙⠿⣿⣿⣿⣿⡿⠟⠁⣠⣿⣿⣿⣿⣿⣿⣿⡏⠀⢠⣿⣿⠇⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⢹⣿⣿⡀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠉⠉⠁⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⠀⠈⠉⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⣾⣿⡟⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠈⣿⣿⣷⡀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠈⠻⠿⠋⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⣸⣿⡿⠁⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠘⢿⣿⣷⡀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣤⣀⣀⣀⣀⣀⣀⣤⣤⡶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⣼⣿⡿⠁⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣄⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣸⡏⠉⢻⡟⠛⢻⡋⠉⣿⣀⣸⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⢀⣾⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣷⡀⠀⠈⠻⣿⣿⣿⣿⣿⣿⡇⠈⣿⠛⠓⣿⠷⠶⢾⡷⠚⢻⡏⠁⣿⣿⣿⣿⣿⣿⠟⠋⠀⢀⣴⣿⣿⠿⣿⣦⡀⠀⠀⠀⠀⠀⠀",
            "⠀⣠⣶⣿⣷⣶⣴⣿⠟⠁⠈⠻⣿⣿⣶⣄⠀⠀⠙⠻⢿⣿⣿⡷⣴⣯⣀⣀⣿⠀⠀⢘⣇⣀⣀⣿⡴⣿⣿⣿⠿⠋⠁⠀⣀⣴⣿⣿⡿⠁⠀⠈⠻⣿⣶⡿⢿⣶⣄⠀",
            "⢰⣿⠋⠁⠀⠈⠛⠁⠀⠀⢀⣴⣿⠟⢿⣿⣿⣶⣄⡀⠀⠈⠛⢿⡀⠀⠉⠉⠉⠛⠛⠋⠉⠉⠁⠀⢠⡿⠉⠀⠀⣀⣴⣾⣿⣿⠟⠻⣿⣦⡀⠀⠀⠈⠁⠀⠀⠙⣿⡆",
            "⢸⣿⠀⠀⠀⠀⠀⠀⠀⣴⣿⠟⠁⠀⠀⠈⠛⢿⣿⣿⣷⣦⣤⣀⣻⣦⣄⡀⠀⠀⠀⠀⠀⢀⣠⣴⣏⣠⣴⣶⣿⣿⡿⠟⠋⠀⠀⠀⠈⢻⣿⠆⠀⠀⠀⠀⠀⠀⣽⡿",
            "⠈⢿⣷⣦⣤⡆⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣿⣿⣿⣿⣿⣿⠿⠟⠋⠁⠀⠀⠀⠀⠀⠀⢠⣿⡏⠀⠀⠀⠀⣶⣶⣾⠿⠃",
            "⠀⠀⠈⠙⣿⣇⠀⠀⣀⣾⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠛⠛⠛⠛⠛⠛⠛⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣄⠀⠀⣠⣿⡏⠀⠀⠀",
            "⠀⠀⠀⠀⠈⠻⠿⠿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠿⠋⠀⠀⠀⠀", 
            "                      Welcome to Neovim                     ",
        }

        -- Menu
        dashboard.section.buttons.val = {
            dashboard.button("r", "Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("f", "Find File", ":Telescope find_files<CR>"),
            dashboard.button("s", "Load Session", ":source ~/.config/nvim/session.vim<CR>"),
            dashboard.button("c", "Nvim Config", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("q", "Quit Neovim", ":qa<CR>"),
        }
        -- Calculate Startup Time
        local startup_time = (vim.loop.hrtime() - vim.g.start_time) / 1e6  -- Convert to milliseconds

        -- Get Number of Loaded Plugins (for lazy.nvim)
        local plugin_count = 0
        if pcall(require, "lazy") then
            plugin_count = require("lazy").stats().loaded
        end

        -- Footer with Startup Time and Plugin Count
        dashboard.section.footer.val = { 
            "Loaded in " .. string.format("%.2f", startup_time) .. " ms " .. plugin_count .. " plugins"}
        -- Footer

        -- Set up Alpha dashboard
        alpha.setup(dashboard.opts)
    end,
}

