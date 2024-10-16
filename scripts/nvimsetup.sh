#!/bin/bash

# ================================================
# Neovim DevOps Setup Script for Arch Linux with YAML and Java Support
# ================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print() {
  echo -e "\n[Neovim Setup] $1\n"
}

# Update package list and upgrade system
print "Updating package list..."
sudo pacman -Syu --noconfirm

# Install prerequisites
print "Installing prerequisites..."
sudo pacman -S --noconfirm git curl unzip wget base-devel

# Install Neovim if not installed
if ! command -v nvim &> /dev/null; then
  print "Installing Neovim..."
  sudo pacman -S --noconfirm neovim
else
  print "Neovim is already installed."
fi

# Install Node.js and npm (required for some LSP servers)
if ! command -v node &> /dev/null; then
  print "Installing Node.js and npm..."
  sudo pacman -S --noconfirm nodejs npm
else
  print "Node.js is already installed."
fi

# Install Python3 and pip (required for some LSP servers)
if ! command -v python3 &> /dev/null; then
  print "Installing Python3 and pip..."
  sudo pacman -S --noconfirm python python-pip
else
  print "Python3 is already installed."
fi

# Install Java (OpenJDK 17)
if ! command -v java &> /dev/null; then
  print "Installing OpenJDK 17..."
  sudo pacman -S --noconfirm jdk-openjdk
else
  print "Java is already installed."
fi

# Install Go
if ! command -v go &> /dev/null; then
  print "Installing Go..."
  sudo pacman -S --noconfirm go
else
  print "Go is already installed."
fi

# Create Neovim config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/nvim"
if [ ! -d "$CONFIG_DIR" ]; then
  print "Creating Neovim config directory..."
  mkdir -p "$CONFIG_DIR"
fi

# Install packer.nvim
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
  print "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
else
  print "packer.nvim is already installed."
fi

# Write init.lua configuration
print "Writing init.lua configuration..."
cat > "$CONFIG_DIR/init.lua" << 'EOF'
-- ===========================
-- Neovim Configuration for DevOps with YAML and Java Support
-- ===========================

-- Auto-install packer.nvim if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') ..
    '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    print("Installing packer.nvim...")
    fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    print("Installed packer.nvim")
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

ensure_packer()

-- Autocommand to reload Neovim whenever you save this init.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]]

-- Initialize packer
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP and Mason (LSP Installer)
  use {'neovim/nvim-lspconfig'}
  use {'williamboman/mason.nvim'}
  use {'williamboman/mason-lspconfig.nvim'}

  -- Autocompletion
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-path'}
  use {'L3MON4D3/LuaSnip'}
  use {'saadparwaiz1/cmp_luasnip'}
  use {'rafamadriz/friendly-snippets'}

  -- Treesitter (Improved Syntax Highlighting)
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Fuzzy Finder (Telescope)
  use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- Git Integration
  use {'tpope/vim-fugitive'}
  use {'lewis6991/gitsigns.nvim'}

  -- Status Line
  use {'nvim-lualine/lualine.nvim'}

  -- Autopairs
  use {'windwp/nvim-autopairs'}

  -- Commenting
  use {'numToStr/Comment.nvim'}

  -- Which-Key (Keybinding Helper)
  use {'folke/which-key.nvim'}

  -- Color Scheme
  use {'gruvbox-community/gruvbox'}

  -- CSV Support
  use {'chrisbra/csv.vim'}

  -- DevOps Specific Plugins
  use {'hashivim/vim-terraform'}
  use {'fatih/vim-go'}
  use {'pearofducks/ansible-vim'}
  use {'towolf/vim-helm'}

  -- YAML and JSON Support
  use {'stephpy/vim-yaml'}
  use {'elzr/vim-json'}

  -- Java Support
  use {'mfussenegger/nvim-jdtls'}  -- Java LSP client configuration

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- General Neovim Settings
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.g.mapleader = ' '  -- Set leader key to space

-- Set Color Scheme
vim.cmd [[colorscheme gruvbox]]

-- Lualine Configuration
require('lualine').setup {
  options = { theme = 'gruvbox' }
}

-- Gitsigns Configuration
require('gitsigns').setup()

-- Treesitter Configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash", "go", "python", "yaml", "json", "lua", "terraform", "java"
  },
  highlight = { enable = true },
}

-- Mason and LSP Configuration
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    'pyright', 'gopls', 'bashls', 'terraformls',
    'yamlls', 'jsonls', 'lua_ls', 'jdtls'
  },
}

-- LSP Settings
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force',
      {noremap = true, silent = true},
      opts or {}
    )
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
  -- Keybindings for LSP
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

  -- Format on save (optional)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd [[
      augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
      augroup END
    ]]
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure LSP Servers
local servers = {
  'pyright', 'gopls', 'bashls', 'terraformls',
  'yamlls', 'jsonls', 'lua_ls'
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- YAML LSP Extra Configuration for Kubernetes
lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml",
      },
      schemaStore = {
        enable = true,
      },
      validate = true,
      hover = true,
      completion = true,
    },
  },
}

-- Java LSP Configuration
local home = os.getenv('HOME')
local jdtls = require('jdtls')

local function jdtls_on_attach(client, bufnr)
  on_attach(client, bufnr)
  -- Additional Java-specific keybindings can be added here
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local root_markers = {'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    if root_dir == nil then
      return
    end
    local workspace_dir = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

    local config = {
      flags = {
        debounce_text_changes = 80,
      },
      capabilities = capabilities,
      on_attach = jdtls_on_attach,
      root_dir = root_dir,
      settings = {
        java = {},
      },
      init_options = {
        bundles = {},
      },
    }

    config.cmd = {
      'java', '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4', '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true', '-Dlog.level=ALL', '-Xmx1g',
      '--add-modules=ALL-SYSTEM', '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
      '-configuration', home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
      '-data', workspace_dir,
    }

    jdtls.start_or_attach(config)
  end,
})

-- nvim-cmp Configuration
local cmp = require'cmp'
local luasnip = require'luasnip'
require'luasnip.loaders.from_vscode'.lazy_load()

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<Tab>']     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, {'i', 's'}),
    ['<S-Tab>']   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
}

-- Autopairs Configuration
require('nvim-autopairs').setup{}

-- Comment.nvim Configuration
require('Comment').setup{}

-- Which-Key Configuration
require('which-key').setup{}

-- Telescope Keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = 'Find Files'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Live Grep'})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = 'List Buffers'})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = 'Help Tags'})

-- Additional Keybindings (Optional)
vim.keymap.set('n', '<leader>gs', ':Git<CR>', {desc = 'Git Status'})

-- CSV Plugin Command to Toggle Table Mode
vim.cmd [[
  autocmd FileType csv nmap <buffer> <leader>tt :ToggleCSV<CR>
]]

-- Terraform Plugin Settings
vim.g.terraform_align = 1
vim.g.terraform_fmt_on_save = 1

-- Go Plugin Settings
vim.g.go_fmt_command = "goimports"
vim.g.go_def_mapping_enabled = 0

-- Ansible Plugin Settings
vim.g.ansible_unindent_after_newline = 1

-- Vim-YAML Settings
vim.g.yaml_indent = 2
EOF

# Install Neovim plugins
print "Installing Neovim plugins..."
nvim --headless +PackerSync +qa

# Install LSP servers using Mason
print "Installing LSP servers via Mason..."
nvim --headless -c "MasonInstall pyright gopls bash-language-server terraform-ls yaml-language-server vscode-json-languageserver lua-language-server jdtls" -c "qa"

# Install additional npm-based LSP servers
print "Installing additional npm-based LSP servers..."
sudo npm install -g bash-language-server yaml-language-server vscode-json-languageserver

# Install Go tools
print "Installing Go tools..."
export GOBIN=$HOME/go/bin
mkdir -p $GOBIN
export PATH=$PATH:$GOBIN
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

# Add Go binaries to PATH in .bashrc or .zshrc
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
else
  SHELL_RC="$HOME/.bashrc"
fi

if ! grep -q 'export PATH=$PATH:$HOME/go/bin' "$SHELL_RC"; then
  echo 'export PATH=$PATH:$HOME/go/bin' >> "$SHELL_RC"
fi

# Install Java LSP server (jdtls) via Mason
print "Installing Java LSP server (jdtls) via Mason..."
nvim --headless -c "MasonInstall jdtls" -c "qa"

print "Neovim setup is complete!"

