local Plug = vim.fn["plug#"]

function setup(opts)
    -- automatic installation of missing plugins
    -- don't ask me how it works, it's on the wiki
    vim.cmd([[
       autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \| PlugInstall --sync | source $MYVIMRC
        \| endif
    ]])

    vim.call("plug#begin")

    if opts.is_terminal then
        Plug("tpope/vim-fugitive")
        Plug("tpope/vim-rhubarb")
        Plug("lewis6991/gitsigns.nvim")
        Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
        Plug("mhartington/oceanic-next")
    end

    if opts.discord_available then
        Plug("IogaMaster/neocord")
    end

    Plug("neovim/nvim-lspconfig")
    Plug("tpope/vim-eunuch")

    vim.call("plug#end")
end

return { setup = setup }
