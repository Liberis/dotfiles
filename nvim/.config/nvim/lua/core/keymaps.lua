local wk = require("which-key")
vim.g.mapleader = " "  -- Set space as the leader key

wk.add({
    -- Γëí╞Æ├╢├¼ Search (Telescope)
    { "<leader>f", group = "Find" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find Help Tags" },

    -- Γëí╞Æ├┤├» Tree-sitter
    { "<leader>t", group = "Tree-sitter" },

    -- Γëí╞Æ├┤├» Highlighting
    { "<leader>th", "<cmd>TSBufToggle highlight<CR>", desc = "Toggle Highlighting" },

    -- Γëí╞Æ├┤├» Incremental Selection
    { "<leader>ti", group = "Incremental Selection" },
    { "<leader>tin", "gnn", desc = "Start Selection" },
    { "<leader>tii", "grn", desc = "Expand Selection" },
    { "<leader>tiz", "grc", desc = "Scope Increment" },
    { "<leader>tid", "grm", desc = "Shrink Selection" },

    -- Γëí╞Æ├┤├» Folding
    { "<leader>tf", "<cmd>set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()<CR>", desc = "Enable Folding" },
    { "<leader>tF", "<cmd>set foldmethod=manual<CR>", desc = "Disable Folding" },

    -- Γëí╞Æ├┤├» Debugging
    { "<leader>td", group = "Debugging" },
    { "<leader>tds", "<cmd>TSPlaygroundToggle<CR>", desc = "Toggle Playground" },
    { "<leader>tdh", "<cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Highlight Captures" },

    -- Γëí╞Æ├┤├» Parser Management
    { "<leader>tp", "<cmd>TSUpdate<CR>", desc = "Update Parsers" },
    { "<leader>tP", "<cmd>TSInstallInfo<CR>", desc = "Show Installed Parsers" },

    -- Γëí╞Æ┬ó├í Git (LazyGit + Gitsigns)
    { "<leader>g", group = "Git" },
    { "<leader>gg", "<cmd>LazyGit<CR>", desc = "Open LazyGit" },
    { "<leader>gl", "<cmd>ToggleTerm cmd=lazygit<CR>", desc = "LazyGit Terminal" },
    { "<leader>gp", "<cmd>!git push<CR>", desc = "Git Push" },
    { "<leader>gd", "<cmd>!git diff<CR>", desc = "Git Diff" },
    { "<leader>gb", "<cmd>!git branch<CR>", desc = "Git Branch" },
    { "<leader>gs", "<cmd>!git status<CR>", desc = "Git Status" },

    -- Γëí╞Æ├«╞Æ LSP Actions
    { "<leader>l", group = "LSP" },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to Definition" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format Code" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover Documentation" },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to Implementation" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename Symbol" },
    { "<leader>nd", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show Diagnostics (Null-LS)" },

    -- Γëí╞Æ├┤├» Diagnostics Navigation
    { "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous Diagnostic" },
    { "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },

    -- Γëí╞Æ├┤├⌐ File Explorer (NeoTree)
    { "<leader>e",  "<cmd>Neotree toggle<cr>", desc = "toggle file explorer" },
    { "<leader>yf", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
    { "<leader>yp", "<cmd>YaziPicker<CR>", desc = "Toggle Yazi Picker" },

    -- Γëí╞Æ├à├í Window Management
    { "<leader>w", group = "Window" },
    { "<leader>wv", "<cmd>vsplit<CR>", desc = "Vertical Split" },
    { "<leader>wh", "<cmd>split<CR>", desc = "Horizontal Split" },
    { "<leader>wc", "<cmd>close<CR>", desc = "Close Split" },
    { "<leader>w=", "<cmd>wincmd =<CR>", desc = "Equalize Splits" },

    -- Γëí╞Æ├┤├» UI Toggles
    { "<leader>u", group = "UI" },  -- Changed from "<leader>t" to avoid conflicts
    { "<leader>ui", "<cmd>IndentBlanklineToggle<CR>", desc = "Toggle Indent Guides" },
    { "<leader>uc", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" },
    { "<leader>un", "<cmd>set relativenumber!<CR>", desc = "Toggle Relative Numbers" },
    { "<leader>uw", "<cmd>set wrap!<CR>", desc = "Toggle Word Wrap" },
    { "<leader>uh", "<cmd>nohlsearch<CR>", desc = "Clear Search Highlight" },

    -- Γëí╞Æ├┤┬Ñ Snippet Actions
    { "<leader>s", group = "Snippets" },
    { "<leader>ss", "<cmd>lua toggle_snippet_source()<CR>", desc = "Toggle Snippet Completion" },
    { "<leader>sr", "<cmd>lua require('luasnip').cleanup(); require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim/lua/snippets' })<CR>", desc = "Reload All Snippets" },

    -- Γëí╞Æ├┤├» Aerial (Symbols Outline)
    { "<leader>a", group = "Aerial" },
    { "<leader>aa", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial" },
    { "<leader>an", "<cmd>AerialNext<CR>", desc = "Next Symbol" },
    { "<leader>ap", "<cmd>AerialPrev<CR>", desc = "Previous Symbol" },
    { "<leader>aj", "<cmd>AerialNext<CR>", desc = "Jump to Next Symbol" },
    { "<leader>ak", "<cmd>AerialPrev<CR>", desc = "Jump to Previous Symbol" },
    { "<leader>af", "<cmd>AerialOpen Float<CR>", desc = "Toggle Floating Aerial" },
    { "<leader>al", "<cmd>AerialNavToggle<CR>", desc = "Toggle Navigation" },
})

