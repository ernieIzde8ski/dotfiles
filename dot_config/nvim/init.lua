------- vim-plug

local vim = vim
local Plug = vim.fn["plug#"]

-- automatic installation of missing plugins
-- don't ask me how it works, it's on the wiki
vim.cmd [[
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
    \| endif
]]

vim.call('plug#begin')

if not vim.g.vscode then
    Plug("IogaMaster/neocord")
end

Plug('neovim/nvim-lspconfig')
Plug('tpope/vim-eunuch')

vim.call('plug#end')


------- plugin config
if not vim.g.vscode then
    require("neocord").setup({
        logo_tooltip    = "You pissant little gnome.",
        show_time       = true,
        global_timer    = true,
    })
end

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}

------- general
vim.opt.number = true

vim.api.nvim_create_user_command('Black', "w | !black %", {})

-- 4-space-width tabs
vim.opt.expandtab   = true
vim.opt.softtabstop = 4
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 0
