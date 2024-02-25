-------------------------
-- LSP
-------------------------
local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  --local bufopts = { noremap = true, silent = true, buffer = bufnr }
  --  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  --  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  --  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  --  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  --  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  --  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  --  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)

  --  vim.keymap.set("n", "<space>wl", function()
  --      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --      end, bufopts)

  --  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  --  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  --  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  --  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

  --  vim.keymap.set("n", "<space>f", function() 
  --      vim.lsp.buf.format { filter = function(client) 
  --          return client.name == "null-ls" end, timeout_ms = 20000 } end, bufopts)
end

-------------------------
-- LSP Servers 
-------------------------

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` 
    -- to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For LusSnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    -- You can specify the `git` source if [you were installed it]
    -- (https://github.com/petertriho/cmp-git).
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, 
-- this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, 
-- this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise 
--- it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configuring lspconfig
local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities 
-- offered by nvim-cmp
local servers = { 
    "bashls", 
    "clangd", 
    "cmake",  
    "dotls",
    "gopls",
    "html",
    "jsonls",
    "pyright",
    "rust_analyzer",
    "tsserver",
}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    }
end

-- Set signs
local signs = { Error = " ", Warn = " ", Hint = "󱩏 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
