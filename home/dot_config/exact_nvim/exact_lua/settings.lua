local has = vim.fn["has"]

-- line display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- display tabs & trailing whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- 4-space-width tabs
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

-- set vim.opt
if has("termguicolors") then
    vim.opt.termguicolors = true
end

-- making floating displays have a border
local float_border = { border = "single" }

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, float_border)

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, float_border)

vim.diagnostic.config({
    float = float_border,
})

-- misc
vim.lsp.inlay_hint.enable()
vim.opt.scrolloff = 5
vim.opt.splitbelow = true

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

local set_keymap = vim.api.nvim_set_keymap

-- close other buffers
set_keymap("n", "<Leader>bd", "mc<cmd>wall | %bd | e# | bd#<cr>`c", {})

-- FOOT PEDAL.
set_keymap("n", "<F13>", "<cmd>bprev<cr>", {})
set_keymap("v", "<F13>", "<cmd>bprev<cr>", {})
set_keymap("n", "<F14>", "<Leader>", {})
set_keymap("n", "<F15>", "<cmd>bnext<cr>", {})
set_keymap("v", "<F13>", "<cmd>bprev<cr>", {})

-- other keymaps
set_keymap("n", "<C-B>", "Bi", {})
set_keymap("i", "<C-B>", "<Esc>Bi", {})
set_keymap("n", "<C-W>d", "", { callback = vim.diagnostic.open_float })
set_keymap("n", "<Esc>", "<cmd>nohlsearch<cr>", {})
set_keymap("n", "<F5>", "<cmd>update<cr>", {})
set_keymap("n", "<F6>", "<cmd>!%:p<cr>", {}) -- execute current file
