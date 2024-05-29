local Plug = vim.fn["plug#"]

-- automatic installation of missing plugins
-- don't ask me how it works, it's on the wiki
vim.cmd([[
   autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
    \| endif
]])

vim.call("plug#begin")
Plug("nvim-lua/plenary.nvim")

-- lsp
Plug("neovim/nvim-lspconfig")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/cmp-cmdline")
Plug("petertriho/cmp-git")
Plug("dcampos/nvim-snippy") -- todo: see if "native neovim snippets" are a good idea
Plug("dcampos/cmp-snippy") -- when I get the update (Neovim v0.10+)
Plug("hrsh7th/nvim-cmp")

-- git
Plug("tpope/vim-fugitive")
Plug("tpope/vim-rhubarb")
Plug("lewis6991/gitsigns.nvim")

-- rendering
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("rebelot/kanagawa.nvim")

-- misc
Plug("tpope/vim-eunuch")

if vim.g.discord_available then
    Plug("IogaMaster/neocord")
end

vim.call("plug#end")
