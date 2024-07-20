vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

vim.opt_local.colorcolumn = "40,75,80"

local set_keymap = require("helpers.set-keymap")
local bufnr = vim.api.nvim_get_current_buf()

-- jump to next line
set_keymap("n", "<Leader>n", [[/^\d\+$<CR>]], bufnr)
-- italicize with ctrl+i
set_keymap("v", "<C-I>", [[di<i></i><Esc>F<P]], bufnr)
