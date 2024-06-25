local plug = vim.fn["plug#"]

vim.call("plug#begin")

plug("nvim-lua/plenary.nvim")

-- lsp
plug("williamboman/mason.nvim")
plug("nvimtools/none-ls.nvim")
plug("jay-babu/mason-null-ls.nvim")
plug("williamboman/mason-lspconfig.nvim")
plug("neovim/nvim-lspconfig")

-- completions
plug("hrsh7th/cmp-nvim-lsp")
plug("hrsh7th/cmp-buffer")
plug("hrsh7th/cmp-path")
plug("hrsh7th/cmp-cmdline")
plug("petertriho/cmp-git")
plug("hrsh7th/nvim-cmp")

-- git
plug("tpope/vim-fugitive")
plug("tpope/vim-rhubarb")
plug("lewis6991/gitsigns.nvim")

-- rendering
plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
plug("rebelot/kanagawa.nvim")

if vim.opt.termguicolors then
    plug("rcarriga/nvim-notify")
    plug("mrded/nvim-lsp-notify")
end

-- misc
plug("klen/nvim-config-local")
plug("m4xshen/autoclose.nvim")
plug("tpope/vim-eunuch")

if vim.g.discord_available then
    plug("IogaMaster/neocord")
end

vim.call("plug#end")
