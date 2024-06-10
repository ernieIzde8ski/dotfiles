vim.opt_local.colorcolumn = "40,75,80"

local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true }

vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>n", [[/^\d\+$<CR>]], opts)
-- italicize with ctrl+i
vim.api.nvim_buf_set_keymap(bufnr, "v", "<C-I>", [[di<i></i><Esc>F<P]], opts)
