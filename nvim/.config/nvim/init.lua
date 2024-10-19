-- Load Lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key early
vim.g.mapleader = ' '
local opts = { noremap = true, silent = true }

-- Lazy.nvim setup
require("lazy").setup({

    -- ColorSchemes
    { 'aliqyan-21/darkvoid.nvim' },
    { 'EdenEast/nightfox.nvim' },

    -- Lualine (Status Line Enhancement) - Plugin 1
    {
        'nvim-lualine/lualine.nvim',
        event = "VimEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({
                options = { theme = 'carbonfox' }, -- Or any theme you prefer
            })
        end,
    },

    -- Telescope (Fuzzy Finder) - Plugin 2
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
        end,
    },

    -- Git Integration
    { 'tpope/vim-fugitive', cmd = { 'Git', 'G' } },

    -- Gitsigns
    {
        'lewis6991/gitsigns.nvim',
        event = "BufRead",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup({})
        end
    },

    -- LSP Config
    {
        'neovim/nvim-lspconfig',
        event = "BufReadPre",
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
            -- Add rust-analyzer configuration
            lspconfig.rust_analyzer.setup({
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
                            command = "clippy", -- Use Clippy for linting on save
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
            'hrsh7th/cmp-nvim-lsp',
            {
                'L3MON4D3/LuaSnip',
                dependencies = {
                    'saadparwaiz1/cmp_luasnip',
                },
                config = function()
                    -- LuaSnip configuration if needed
                end,
            },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Accept completion
                    ['<C-Space>'] = cmp.mapping.complete(),             -- Trigger completion
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },  -- Snippets source
                    { name = 'buffer' },   -- Buffers source
                },
            })
        end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        event = "BufRead",
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

    -- nvim-autopairs - Plugin 4
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup({})
        end,
    },

    -- Comment.nvim - Plugin 5
    {
        'numToStr/Comment.nvim',
        keys = { 'gc', 'gcc', 'gbc' },
        config = function()
            require('Comment').setup()
        end,
    },

    -- indent-blankline.nvim - Plugin 6
    {
        'lukas-reineke/indent-blankline.nvim',
        event = "BufReadPre",
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
    -- nvim-surround - Plugin 8
    {
        'kylechui/nvim-surround',
        event = "BufReadPre",
        config = function()
            require('nvim-surround').setup({})
        end,
    },

    -- which-key.nvim - Plugin 9
    {
        'folke/which-key.nvim',
        event = "VimEnter",
        config = function()
            require('which-key').setup({})
        end,
    },

    -- nvim-notify - Plugin 10
    {
        'rcarriga/nvim-notify',
        event = "VimEnter",
        config = function()
            vim.notify = require("notify")
        end,
    },

    -- project.nvim - Plugin 16
    {
        'ahmedkhalf/project.nvim',
        event = "VimEnter",
        config = function()
            require('project_nvim').setup({})
            require('telescope').load_extension('projects')
        end,
    },

    -- nvim-colorizer.lua - Plugin 17
    {
        'norcalli/nvim-colorizer.lua',
        event = "BufReadPre",
        config = function()
            require('colorizer').setup({})
        end,
    },

    -- nvim-treehopper - Plugin 20
    {
        'mfussenegger/nvim-treehopper',
        keys = { 'm', 'M' },
        config = function()
            vim.api.nvim_set_keymap('o', 'm', ":<C-U>lua require('tsht').nodes()<CR>", opts)
            vim.api.nvim_set_keymap('x', 'm', ":lua require('tsht').nodes()<CR>", opts)
        end,
    },

    -- leap.nvim - Plugin 24
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
        event = "BufReadPre",
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
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "",
                        default = "",
                    },
                    git_status = {
                        symbols = {
                            added     = "✚",
                            modified  = "",
                            deleted   = "✖",
                            renamed   = "",
                            untracked = "",
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

-- Set ColorScheme
vim.cmd [[colorscheme carbonfox]]
vim.o.termguicolors = true
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

-- Use the system clipboard (delayed to avoid startup delay)
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.o.clipboard = 'unnamedplus'
    end
})

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

-- Git commands
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

-- Telescope keybindings (added for Plugin 2)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fp', ':Telescope projects<CR>', opts) -- For project.nvim

-- Nvim-treehopper keybindings are set in its config
-- Leap.nvim default mappings are set in its config


