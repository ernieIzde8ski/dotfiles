local has = vim.fn["has"]
local set_keymap = require("helpers.set-keymap")

-- confirm before destructive actions
vim.opt.confirm = true

-- folds
vim.opt.foldcolumn = "0"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- display tabs & trailing whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- line display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- 4-space-width tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.smartindent = true

-- set vim.opt
if has("termguicolors") then
    vim.opt.termguicolors = true
end

-- make floating displays have borders
local float_border = { border = "single" }

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, float_border)

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, float_border)

vim.diagnostic.config({
    float = float_border,
})

-- ripgrep
if vim.fn.executable("rg") ~= 0 then
    vim.opt.grepprg = "rg --vimgrep"
end

-- smartcasing in search patterns
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- misc
vim.opt.scrolloff = 5
vim.opt.splitbelow = true
vim.g.editorconfig = true

vim.filetype.add({
    filename = {
        [".chezmoiignore"] = "gotmpl",
        [".chezmoiremove"] = "gotmpl",
        [".jsbeautifyrc"] = "json",
    },
    pattern = {
        [".*.tmpl"] = "gotmpl",
    },
})

-- close other buffers
set_keymap("n", "<Leader>bd", "mc<cmd>wall | %bd | e# | bd#<cr>`c")

-- FOOT PEDAL.
set_keymap({ "n", "v" }, "<F13>", vim.cmd.bprev)
set_keymap("n", "<F14>", "<Leader>")
set_keymap({ "n", "v" }, "<F15>", vim.cmd.bnext)

-- other keymaps
set_keymap("n", "<C-B>", "Bi")
set_keymap("i", "<C-B>", "<Esc>Bi")
set_keymap("n", "<C-W>d", vim.diagnostic.open_float)
set_keymap("n", "<Esc>", vim.cmd.nohlsearch)
set_keymap("n", "<F5>", vim.cmd.update)
set_keymap("n", "<F6>", "<cmd>!%:p<cr>") -- execute current file
