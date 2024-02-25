---------------------------------
-- Init and setup plugin manager
---------------------------------
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

require("lazy").setup({
    {"max397574/better-escape.nvim", event = "InsertCharPre", opts = { timeout = 300 } },
    {'akinsho/bufferline.nvim', 
        version = "*", 
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {"nmac427/guess-indent.nvim"},
    {"neovim/nvim-lspconfig", commit = "cf3dd4a290084a868fac0e2e876039321d57111c"},
    {"folke/neodev.nvim", commit = "da1562e1e3df0e994ddc52cb4ba22376a5d7f2fc"},
    {"nvim-treesitter/nvim-treesitter", 
        commit = "f197a15b0d1e8d555263af20add51450e5aaa1f0", 
        build = ":TSUpdate" 
    },
    {"hrsh7th/cmp-nvim-lsp", commit = "5af77f54de1b16c34b23cba810150689a3a90312"},
    {"hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"},
    {"hrsh7th/cmp-path", commit = "91ff86cd9c29299a64f968ebb45846c485725f23"},
    {"hrsh7th/cmp-cmdline", commit = "8ee981b4a91f536f52add291594e89fb6645e451"},
    {"hrsh7th/nvim-cmp", commit = "04e0ca376d6abdbfc8b52180f8ea236cbfddf782"},
    {"L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.*", 
        -- install jsregexp (optional!).
        build = "gmake install_jsregexp" 
    },
    {"saadparwaiz1/cmp_luasnip"},
    {"rafamadriz/friendly-snippets"},
    {"nvim-telescope/telescope.nvim", 
        commit = "d90956833d7c27e73c621a61f20b29fdb7122709",
        branch = "0.1.x"
    },
    {"nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
            cmake --build build --config Release && \
            cmake --install build --prefix build" 
    },
    {"nvimtools/none-ls.nvim"},
    {"kdheepak/lazygit.nvim",
        -- optional for floating window border decoration
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {"windwp/nvim-autopairs"},
    {'akinsho/toggleterm.nvim', version = "*", config = true},
    {"ibhagwan/fzf-lua"},
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {"folke/trouble.nvim"},
    {"nvim-lualine/lualine.nvim"},
    { "catppuccin/nvim", 
        name = "catppuccin", 
        priority = 1000 
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "MunifTanjim/nui.nvim"
        }
    },
    {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	 end,
    },
    {"folke/noice.nvim", event = "VeryLazy", 
        opts = {
        -- add any options here
        },
        dependencies = {
            {"MunifTanjim/nui.nvim", version = "^0.2"}, 
            {"rcarriga/nvim-notify", version = "^3"},
        },
    },
    {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
	    vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
    },
    {"NvChad/nvim-colorizer.lua"},
    {"goolord/alpha-nvim",
    	dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {"lewis6991/gitsigns.nvim"},
    {"echasnovski/mini.nvim", version = '*' },
})
