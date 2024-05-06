-- netrw - list as a tree by default
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = "\\(node_modules\\|venv\\|.git\\|__pycache__\\)/"

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

-- misc
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 5
vim.opt.splitbelow = true

vim.filetype.add({
    filename = {
        [".chezmoiignore"] = "gotmpl",
        [".chezmoiremove"] = "gotmpl",
    },
    pattern = {
        [".*.tmpl"] = "gotmpl",
    },
})

vim.keymap.set("n", "<C-B>", "Bi")
vim.keymap.set("n", "<C-W>d", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "<F5>", "<cmd>up<cr>")
vim.keymap.set("n", "<F6>", "<cmd>!%:p<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
