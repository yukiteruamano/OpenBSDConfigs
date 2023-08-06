--------------------------------
-- Keymaps
--------------------------------
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', opts)

vim.keymap.set('n', '<leader>fo', ':FzfLua oldfiles<CR>', opts)
vim.keymap.set('n', '<leader>ff', ':FzfLua files<CR>', opts)
vim.keymap.set('n', '<leader>f', ':FzfLua<CR>', opts)

vim.keymap.set('n', '<Leader>tt', ':!kitty getcwd() <CR>', opts)
vim.keymap.set('t', '<Leader>tt', ':!kitty getcwd() <CR>', opts)

vim.keymap.set('n', '<Leader>bn', ':bnext <CR>', opts)
vim.keymap.set('n', '<Leader>bp', ':bprevious <CR>', opts)
vim.keymap.set('n', '<Leader>bd', ':bdelete <CR>', opts)

vim.keymap.set('n', '<Leader>er', ':TroubleToggle <CR>', opts)

vim.keymap.set('n', '<Leader>du', ':DBUIToggle <CR>', opts)
vim.keymap.set('n', '<Leader>df', ':DBUIFindBuffer <CR>', opts)
vim.keymap.set('n', '<Leader>dr', ':DBUIRenameBuffer <CR>', opts)
vim.keymap.set('n', '<Leader>dl', ':DBUILastQueryInfo <CR>', opts)

vim.keymap.set('n', '<Leader>bf', ':lua vim.lsp.buf.format() <CR>:echo "Formatting done."<CR>', opts)

vim.keymap.set('n', '<Leader>eps', ':w <CR>:!python %<CR>', opts)
vim.keymap.set('n', '<Leader>epm', ':w <CR>:cd %:p:h <CR>:cd.. <CR>:!python -m %:p:h:t<CR>', opts)
vim.keymap.set('n', '<Leader>ets', ':w <CR>:!npx ts-node %<CR>', opts)

vim.keymap.set('n', '<Leader>l', ':!leo <C-r><C-w><CR>', opts)

-- Trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end)