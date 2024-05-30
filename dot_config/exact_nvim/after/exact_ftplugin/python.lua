local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true }

vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>f", ":update | !black %:p", opts)
