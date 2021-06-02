-- Load Lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key early
vim.g.mapleader = ' '
local opts = { noremap = true, silent = true }

-- Set termguicolors to enable true color support
vim.o.termguicolors = true

-- Lazy.nvim setup
require("lazy").setup({

    -- oxocarbon.nvim with transparency
    {
        'navarasu/onedark.nvim',
        lazy = false, -- Load immediately
        priority = 1000, -- Ensure it loads first
        config = function()
            require('onedark').setup  {
                -- Main options --
                style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                transparent = true,  -- Show/hide background
                term_colors = true, -- Change terminal color as per the selected theme style
                ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- toggle theme style ---
                toggle_style_key = "<leader>ts", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
                toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

                -- Change code style ---
                -- Options are italic, bold, underline, none
                -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },

                -- Lualine options --
                lualine = {
                    transparent = false, -- lualine center bar transparency
                },

                -- Custom Highlights --
                colors = {}, -- Override default colors
                highlights = {}, -- Override highlight groups

                -- Plugins Config --
                diagnostics = {
                    darker = true, -- darker colors for diagnostic
                    undercurl = true,   -- use undercurl instead of underline for diagnostics
                    background = true,    -- use background color for virtual text
                },
            }
            -- Set colorscheme
            vim.cmd [[colorscheme onedark]]
        end,
    },

    -- Lualine (Status Line Enhancement)
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy", -- Load during idle time
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({
                options = { theme = 'onedark' },
                sections = {
                    lualine_c = {
                        {
                            'filename',
                            file_status = true, -- displays file status (readonly status, modified status)
                            path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
                        }
                    }
                }   
            })
        end,
    },

    -- Telescope (Fuzzy Finder)
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-n>"] = require('telescope.actions').move_selection_next,
                            ["<C-p>"] = require('telescope.actions').move_selection_previous,
                        },
                    },
                },
            })

            -- Telescope keybindings
            vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
        end,
    },

    -- Git Integration
    { 'tpope/vim-fugitive', cmd = { 'Git', 'G' } },

    -- Gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup({})
        end
    },

    -- LSP Config
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            {
                'williamboman/mason.nvim',
                cmd = "Mason",
                config = function()
                    require("mason").setup()
                end,
            },
            {
                'williamboman/mason-lspconfig.nvim',
                dependencies = { 'mason.nvim' },
                config = function()
                    require("mason-lspconfig").setup({
                        ensure_installed = {
                            "gopls", "pyright", "yamlls", "jdtls", "terraformls",
                            "bashls", "jsonls", "helm_ls", "kotlin_language_server",
                            "azure_pipelines_ls", "rust_analyzer"
                        },
                        automatic_installation = true,
                    })
                end,
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require('cmp_nvim_lsp')

            -- Enhance LSP capabilities for auto-completion
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- Add rust-analyzer configuration
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,  -- Include enhanced capabilities
                on_attach = function(_, bufnr)
                    local opts = { noremap=true, silent=true }
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
                end,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                    }
                },
            })

            -- Generic LSP settings
            local on_attach = function(_, bufnr)
                local opts = { noremap=true, silent=true }
                -- Keybindings for LSP
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            end

            -- Configure each LSP server
            local servers = { 'gopls', 'pyright', 'yamlls', 'jdtls', 'terraformls', 'bashls', 'jsonls', 'helm_ls' }

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    capabilities = capabilities,  -- Include enhanced capabilities
                    on_attach = on_attach,
                    flags = {
                        debounce_text_changes = 150,
                    }
                })
            end
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',  -- LSP source for nvim-cmp
            'hrsh7th/cmp-buffer',     -- Buffer source
            'hrsh7th/cmp-path',       -- Path source
            {
                'L3MON4D3/LuaSnip',
                dependencies = {
                    'saadparwaiz1/cmp_luasnip',  -- Snippet source
                },
                config = function()
                    -- LuaSnip configuration
                    require('luasnip.loaders.from_vscode').lazy_load()
                end,
            },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            -- Set completeopt to have a better completion experience
            vim.o.completeopt = 'menu,menuone,noselect'

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    autocomplete = { cmp.TriggerEvent.TextChanged },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Accept currently selected item
                    ['<C-Space>'] = cmp.mapping.complete(),             -- Trigger completion manually
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },  -- LSP completion source
                    { name = 'luasnip' },   -- Snippet completion source
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
                experimental = {
                    ghost_text = true,  -- Show the selected completion in a ghost text
                },
            })
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPost", "BufNewFile" },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    "go", "python", "yaml", "json", "bash", "java",
                    "terraform", "hcl", "kotlin", "helm", "rust"
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },

    -- nvim-autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup({})

            -- Integrate with nvim-cmp for autopairing on completion
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    },

    -- Comment.nvim
    {
        'numToStr/Comment.nvim',
        keys = { 'gc', 'gcc', 'gbc' },
        config = function()
            require('Comment').setup()
        end,
    },

    -- indent-blankline.nvim (Updated for version 3)
    {
        'lukas-reineke/indent-blankline.nvim',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent = {
                    char = '│',
                },
                scope = {
                    enabled = true,
                },
            })
        end,
    },

    -- nvim-surround
    {
        'kylechui/nvim-surround',
        keys = { "ys", "ds", "cs", "S" },
        config = function()
            require('nvim-surround').setup({})
        end,
    },

    -- nvim-colorizer.lua
    {
        'norcalli/nvim-colorizer.lua',
        cmd = "ColorizerToggle",
        ft = { 'css', 'scss', 'html', 'javascript', 'lua', 'vim', 'markdown' },
        config = function()
            require('colorizer').setup({})
        end,
    },

    -- nvim-treehopper
    {
        'mfussenegger/nvim-treehopper',
        keys = { 'm', 'M' },
        config = function()
            vim.api.nvim_set_keymap('o', 'm', ":<C-U>lua require('tsht').nodes()<CR>", opts)
            vim.api.nvim_set_keymap('x', 'm', ":lua require('tsht').nodes()<CR>", opts)
        end,
    },

    -- leap.nvim
    {
        'ggandor/leap.nvim',
        keys = { 's', 'S' },
        config = function()
            require('leap').add_default_mappings()
        end,
    },

    -- Markdown Preview
    { 'ellisonleao/glow.nvim', cmd = "Glow" },

    -- Null-ls
    {
        'jose-elias-alvarez/null-ls.nvim',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local null_ls = require('null-ls')

            null_ls.setup({
                sources = {
                    -- Python
                    null_ls.builtins.formatting.black,

                    -- Go
                    null_ls.builtins.formatting.gofmt,

                    -- YAML
                    null_ls.builtins.formatting.prettier.with({ filetypes = { "yaml" } }),

                    -- Terraform
                    null_ls.builtins.formatting.terraform_fmt,

                    -- Shell scripting (bash)
                    null_ls.builtins.formatting.shfmt,
                }
            })
        end,
    },

    -- Neo-tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- For file icons
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                auto_expand_width = true,
                enable_git_status = true,
                enable_diagnostics = true,
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file_enabled = true,
                    use_libuv_file_watcher = true,
                },
                window = {
                    position = "left",
                    width = 30,
                    mappings = {
                        ["<CR>"] = "open",
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["t"] = "open_tabnew",
                        ["v"] = "open_vsplit",
                        ["s"] = "open_split",
                        ["i"] = "toggle_hidden",
                        ["R"] = "refresh",
                    }
                },
                default_component_configs = {
                    indent = {
                        indent_size = 2,
                        padding = 1,
                        with_markers = true,
                    },
                    git_status = {
                        symbols = {
                            added     = "+",
                            modified  = "M",
                            deleted   = "D",
                            renamed   = "R",
                            untracked = "U",
                            ignored   = "◌",
                            unstaged  = "✗",
                            staged    = "✓",
                            conflict  = "",
                        }
                    }
                },
            })
        end,
    },
})

-- Highlight the current line
vim.wo.cursorline = true
-- Enable syntax highlighting
vim.cmd('syntax on')

-- Enable line numbers (relative and absolute)
vim.wo.number = true
vim.wo.relativenumber = false

-- Set tab and indentation preferences
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Enable mouse support
vim.o.mouse = 'a'

-- Enable line wrapping
vim.o.wrap = true

-- Show matching brackets
vim.o.showmatch = true

-- Always show the status line
vim.o.laststatus = 2

-- Improve search behavior
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- Format the buffer
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)

-- Keybindings for LSP diagnostics navigation
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Git keybindings with leader key and 'g' as Git prefix
vim.api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add -A<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gu', ':Git add -u<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gA', ':Git add %<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gC', ':Git commit -m ""<Left>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gl', ':Git pull<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gf', ':Git fetch<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gh', ':Git log<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gD', ':Git diff<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gb', ':Git branch<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>gco', ':Git checkout ', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':G<CR>', opts)

-- File Explorer
vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree toggle<CR>', opts)
-- Markdown preview
vim.api.nvim_set_keymap('n', '<leader>md', ':Glow<CR>', opts)

