-------------------------
-- LSP
-------------------------
local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-------------------------
-- LSP Server 
-------------------------

-- Bash
require'lspconfig'.bashls.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- Clangd
require'lspconfig'.clangd.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

-- Cmake
require'lspconfig'.cmake.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- CSSLS
require'lspconfig'.cssls.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

-- Docker
require 'lspconfig'.dockerls.setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

-- Dotls
require'lspconfig'.dotls.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- Gopls
require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- HTML
require'lspconfig'.html.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

-- Json
require'lspconfig'.jsonls.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

-- Pyright
require'lspconfig'.pyright.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- Rust
require'lspconfig'.rust_analyzer.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- Solidity
require'lspconfig'.solc.setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

-- TssServer
require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}


-- Set signs
local signs = { Error = " ", Warn = " ", Hint = "󱩏 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
