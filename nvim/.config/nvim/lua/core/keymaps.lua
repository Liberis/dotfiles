local wk = require("which-key")

wk.add({
    -- 🔍 Search (Telescope)
    { "<leader>f", group = "Find" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find Help Tags" },

    -- 🛠 Git (LazyGit + Gitsigns)
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
    { "<leader>gl", "<cmd>ToggleTerm cmd=lazygit<CR>", desc = "LazyGit Terminal" },
    { "<leader>gp", "<cmd>!git push<CR>", desc = "Git Push" },
    { "<leader>gd", "<cmd>!git diff<CR>", desc = "Git Diff" },
    { "<leader>gb", "<cmd>!git branch<CR>", desc = "Git Branch" },
    { "<leader>gs", "<cmd>!git status<CR>", desc = "Git Status" },

    -- 🌟 LSP Actions
    { "<leader>l", group = "LSP" },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format Code" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Documentation" },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to Implementation" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" },

    -- 📂 File Explorer (NeoTree)
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle File Explorer" },

    -- 🏠 Window Management (Using Proxy for `<C-w>`)
    { "<leader>w", proxy = "<C-w>", group = "Window" },  -- Changed to `<leader>W>` to avoid conflict with save
    { "<leader>wv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
    { "<leader>wh", "<cmd>split<CR>", desc = "Horizontal Split" },
    { "<leader>wc", "<cmd>close<CR>", desc = "Close Split" },
    { "<leader>w=", "<cmd>wincmd =<CR>", desc = "Equalize Splits" },

    -- ✨ UI Toggles
    { "<leader>t", group = "Toggle" },
    { "<leader>ti", "<cmd>IndentBlanklineToggle<CR>", desc = "Toggle Indent Guides" },
    { "<leader>tc", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" },
    { "<leader>tn", "<cmd>set relativenumber!<CR>", desc = "Toggle Relative Numbers" },
    { "<leader>tw", "<cmd>set wrap!<CR>", desc = "Toggle Word Wrap" },
    { "<leader>th", "<cmd>nohlsearch<CR>", desc = "Clear Search Highlight" },
 })

