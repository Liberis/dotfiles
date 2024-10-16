-- Initialize packer.nvim
require('packer').startup(function(use)
    -- Packer manages itself
    use 'wbthomason/packer.nvim'
    -- ColorScheme
    use 'aliqyan-21/darkvoid.nvim'
    -- Git integration plugin
    use 'tpope/vim-fugitive'

    -- Git signs in the gutter (e.g., added, modified, removed lines)
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup({
            })
        end
    }
    -- LSP Config for setting up language servers
    use 'neovim/nvim-lspconfig'

    -- Autocompletion framework
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'

    -- Snippet engine and snippets
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- Language-specific server install helpers (mason.nvim)
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Treesitter for better syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- Markdown Preview
    use { 'ellisonleao/glow.nvim' }
    -- Null-ls for integrating linters and formatters
    use 'jose-elias-alvarez/null-ls.nvim'
use {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",          -- Required dependency
    "nvim-tree/nvim-web-devicons",    -- For file icons
    "MunifTanjim/nui.nvim",           -- UI components for Neo-tree
  },
}
end)
-- Set ColorScheme
vim.cmd [[colorscheme darkvoid]]
vim.g.mapleader = ' '
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

-- Use the system clipboard
vim.o.clipboard = 'unnamedplus'

-- Improve search behavior
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
-- Mason setup to manage LSP installations
require("mason").setup()

-- Install LSPs with Mason and nvim-lspconfig
require("mason-lspconfig").setup({
    ensure_installed = {
        "gopls",        -- Go LSP
        "pyright",      -- Python LSP
        "yamlls",       -- YAML LSP
        "jdtls",        -- Java LSP
        "terraformls",  -- Terraform LSP
        "bashls",       -- Bash LSP
        "jsonls",       -- JSON LSP (for Azure Pipelines)
        "helm_ls",      -- Helm charts LSP
        "kotlin_language_server", -- Kubernetes
        "azure_pipelines_ls", -- Azure pipelines,
        "rust_analyzer"
    },
    automatic_installation = true,
})

-- Setup LSP servers with nvim-lspconfig
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

-- Setup nvim-cmp for autocompletion
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - You'll need a snippet engine for nvim-cmp
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


require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "go", "python", "yaml", "json", "bash", "java", "terraform", "hcl", "kotlin", "helm", "rust"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}


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
-- Neo-tree setup with NERDTree-like behavior
require("neo-tree").setup({
  close_if_last_window = true,  -- Close Neo-tree when it's the last window
  enable_git_status = true,     -- Show git status for files
  enable_diagnostics = true,    -- Show diagnostics in file explorer
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,    -- Show dotfiles by default (NERDTree-like)
      hide_gitignored = false,  -- Show Git ignored files
    },
    follow_current_file = true, -- Focus on current file when opening Neo-tree
    use_libuv_file_watcher = true, -- Asynchronous file updates
  },
  window = {
    position = "left",          -- Tree appears on the left (NERDTree style)
    width = 30,                 -- Set the width for the file tree
    mappings = {
      ["<CR>"] = "open",        -- Open file or folder
      ["l"] = "open",           -- Open file or expand folder (NERDTree style)
      ["h"] = "close_node",     -- Close folder node (NERDTree style)
      ["t"] = "open_tabnew",    -- Open file in a new tab
      ["v"] = "open_vsplit",    -- Open file in a vertical split
      ["s"] = "open_split",     -- Open file in a horizontal split
      ["i"] = "toggle_hidden",  -- Toggle visibility of dotfiles (like NERDTree)
      ["R"] = "refresh",        -- Refresh the tree
    }
  },
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
    },
    icon = {
      folder_closed = "",  -- Folder closed icon
      folder_open = "",    -- Folder open icon
      folder_empty = "",   -- Empty folder icon
      default = "",        -- Default file icon
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
-- Format the buffer
vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
-- Keybindings for LSP diagnostics navigation
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap=true, silent=true })



-- Git keybindings with leader key and 'g' as Git prefix
local opts = { noremap = true, silent = true }

-- Git Status (Interactive)
vim.api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', opts)

-- Git Add All (git add -A)
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add -A<CR>', opts)

-- Git Add Updated (git add -u)
vim.api.nvim_set_keymap('n', '<leader>gu', ':Git add -u<CR>', opts)

-- Git Add Current File
vim.api.nvim_set_keymap('n', '<leader>gA', ':Git add %<CR>', opts)

-- Git Commit (Opens editor for message)
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', opts)

-- Git Commit with Message Inline
vim.api.nvim_set_keymap('n', '<leader>gC', ':Git commit -m ""<Left>', { noremap = true })

-- Git Push
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', opts)

-- Git Pull
vim.api.nvim_set_keymap('n', '<leader>gl', ':Git pull<CR>', opts)

-- Git Fetch
vim.api.nvim_set_keymap('n', '<leader>gf', ':Git fetch<CR>', opts)

-- Git Log
vim.api.nvim_set_keymap('n', '<leader>gh', ':Git log<CR>', opts)

-- Git Diff
vim.api.nvim_set_keymap('n', '<leader>gD', ':Git diff<CR>', opts)

-- Git Branch
vim.api.nvim_set_keymap('n', '<leader>gb', ':Git branch<CR>', opts)

-- Git Checkout
vim.api.nvim_set_keymap('n', '<leader>gco', ':Git checkout ', { noremap = true })

-- Select Files to Add/Remove (Interactive)
vim.api.nvim_set_keymap('n', '<leader>gd', ':G<CR>', opts)
-- File Explorer
vim.api.nvim_set_keymap('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
-- Markdown preview
vim.api.nvim_set_keymap('n', '<leader>md', ':Glow<CR>', { noremap = true, silent = true })
