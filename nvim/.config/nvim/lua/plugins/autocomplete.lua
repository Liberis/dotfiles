return
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",         -- Completion from buffer
    "hrsh7th/cmp-path",           -- Path completion
    "hrsh7th/cmp-nvim-lsp",       -- LSP completion
    "hrsh7th/cmp-nvim-lua",       -- Lua API completion
    "saadparwaiz1/cmp_luasnip",   -- Snippet completions
    "L3MON4D3/LuaSnip",           -- Snippet engine
    "rafamadriz/friendly-snippets" -- Predefined snippets
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load() -- Load friendly-snippets

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),   -- Trigger completion
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
        ["<Tab>"] = cmp.mapping.select_next_item(), -- Next item
        ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Previous item
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end
}

