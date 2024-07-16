local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.opt.rtp:prepend(lazy_path)

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = { import = "plugins" },
    checker = { enabled = true },
})
