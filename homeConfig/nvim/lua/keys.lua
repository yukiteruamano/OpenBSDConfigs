--------------------------------
-- Keymaps
--------------------------------

-- Which-key
require("which-key").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
})

local wk = require("which-key")
wk.register({

  b = {
	  name = "Buffers",
	  n = { "<cmd>bnext<cr>", "Buffer next", noremap=true },
	  p = { "<cmd>bprevious<cr>", "Buffer prev", noremap=true },
	  d = { "<cmd>bdelete<cr>", "Buffer delete", noremap=true },
	  c = { "<cmd>new<cr>", "New buffer", noremap=true },
  },

  -- Trouble keybindings
  t = {
    name = "Trouble", -- optional group name
    t = { "<cmd>TroubleToggle<cr>", "Trouble view", noremap=true },
    r = { "<cmd>TroubleRefresh<cr>", "Trouble refresh", noremap=true },
    c = { "<cmd>TroubleClose<cr>", "Trouble close", noremap=true },
    q = { function() require("trouble").open("quickfix") end, "Trouble QuickFix", noremap=true},
    l = { function() require("trouble").open("lsp_references") end, "Trouble LSP References", noremap=true},
    L = { function() require("trouble").open("loclist") end, "Trouble LocList", noremap=true},
    d = { function() require("trouble").open("document_diagnostics") end, "Trouble Doc Diagnostics", noremap=true},
    w = { function() require("trouble").open("workspace_diagnostics") end, "Trouble Workspace Diagnostics", noremap=true},
  },

  -- Git keybindings
  G = {
    name = "Git", -- optional group name
    V = { "LazyGit"},
    Vg = { "<cmd>LazyGit<cr>", "LazyGit", noremap=true },
    Vc = { "<cmd>LazyGitConfig<cr>", "LazyGit Config", noremap=true },
    S = { "GitSigns"},
    Ss = { "<cmd>Gitsigns show<cr>", "GitSigns show"},
    Sr = { "<cmd>Gitsigns refresh<cr>", "GitSigns refresh"},
    SR = { "<cmd>Gitsigns reset_hunk<cr>", "GitSigns Reset Hunk"},
    Sb = { "<cmd>Gitsigns stage_buffer<cr>", "GitSigns Stage Buffer"},
    Su = { "<cmd>Gitsigns undo_stage_hunk<cr>", "GitSigns Undo Stage Hunk"},
    Sl = { "<cmd>Gitsigns blame_line<cr>", "GitSigns Blame"},
    Sd = { "<cmd>Gitsigns diffthis<cr>", "GitSigns Diff This"},
    SD = { "<cmd>Gitsigns toggle_deleted<cr>", "GitSigns Toggle Deleted"},
  },

  -- Neotree
  n = {
    name = "Neotree",
    t = {"<cmd>Neotree<cr>", "Neotree Open", noremap=true },
    c = {"<cmd>Neotree close<cr>", "Neotree Close", noremap=true },
    b = {"<cmd>Neotree buffers<cr>", "Neotree Buffers", noremap=true },
  },

  -- Tree-sitter
  T = {
    name = "Tree-Sitter",
    e = {"<cmd>TSEnable<cr>", "Enable Tree-Sitter", noremap=true },
    d = {"<cmd>TSDisable<cr>", "Disable Tree-Sitter", noremap=true },
  },

  -- LSP
  L = {
    name = "LSP",
    i = {"<cmd>LspInfo<cr>", "LSP Info", noremap=true },
    l = {"<cmd>LspLog<cr>", "LSP Log", noremap=true },
    S = {"<cmd>LspStop<cr>", "LSP Stop", noremap=true },
    s = {"<cmd>LspLog<cr>", "LSP Start", noremap=true },
    r = {"<cmd>LspRestart<cr>", "LSP Restart", noremap=true },
    l = {"<cmd>LspLog<cr>", "LSP Log", noremap=true },
    f = {"<cmd>:lua vim.lsp.buf.format({timeout = 5000})<cr>", "Format (null-ls)", noremap=true },
    h = {"<cmd>:lua vim.lsp.buf.hover()<cr>", "Hover", noremap=true},
    I = {"<cmd>:lua vim.lsp.buf.implementation()<cr>", "implementation", noremap=true},
    R = {"<cmd>:lua vim.lsp.buf.rename()<cr>", "Rename", noremap=true},
    a = {"<cmd>:lua vim.lsp.buf.code_action()<cr>", "Rename", noremap=true},
    G = {"Goto"},
    GD = {"<cmd>:lua vim.lsp.buf.declaration()<cr>", "Goto declaration", noremap=true},
    Gd = {"<cmd>:lua vim.lsp.buf.definition()<cr>", "Goto definition", noremap=true},
    Gr = {"<cmd>:lua vim.lsp.buf.references()<cr>", "Goto References", noremap=true},
  },
}, { prefix = "<leader>" })
