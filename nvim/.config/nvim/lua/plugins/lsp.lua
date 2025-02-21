return
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
    }

}
