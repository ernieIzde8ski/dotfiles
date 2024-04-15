local vim = vim
local has = vim.fn["has"]

------- general
---- netrw - list as a tree by default
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = "\\(node_modules\\|venv\\|.git\\|__pycache__\\)/"

---- line display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
-- no `signcolumn=number`: conflicts with gitsigns plugin

---- display tabs & trailing whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

---- 4-space-width tabs
vim.opt.expandtab   = true
vim.opt.softtabstop = 4
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 0

---- misc
vim.opt.clipboard  = "unnamedplus"
vim.opt.scrolloff  = 5
vim.opt.splitbelow = true

vim.keymap.set("n", "<F5>", "<cmd>up<cr>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

------- vim-plug
local Plug = vim.fn["plug#"]

-- automatic installation of missing plugins
-- don't ask me how it works, it's on the wiki
vim.cmd([[
   autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
    \| endif
]])


vim.call("plug#begin")

if not vim.g.vscode then
    Plug("IogaMaster/neocord")
    Plug("lewis6991/gitsigns.nvim")
    Plug("mhartington/oceanic-next")
    Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
    Plug("tpope/vim-fugitive")
    Plug("tpope/vim-rhubarb")
end

Plug("neovim/nvim-lspconfig")
Plug("tpope/vim-eunuch")

vim.call("plug#end")

------- plugin config
if not vim.g.vscode then
    pcall(require("neocord").setup, {
        logo_tooltip = "You pissant little gnome.",
        show_time = true,
        global_timer = true,
    })

    require("gitsigns").setup({
        attach_to_untracked = true,
        current_line_blame  = true,
    })

    if has("termguicolors") then
        vim.o.termguicolors = true
    end

    vim.cmd([[
        syntax enable
        colorscheme OceanicNext
    ]])

    require("nvim-treesitter.configs").setup({
        -- the languages that I tend to work with
        ensure_installed = {
            "javascript",
            "lua",
            "markdown",
            "python",
            "rust",
            "toml",
            "typescript",
            "yaml",
        },
    })
end

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
