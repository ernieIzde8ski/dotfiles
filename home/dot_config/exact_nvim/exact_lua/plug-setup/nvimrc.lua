-- Global settings configurable by nvimrc
-- Expand as necessary

-- Usage:
-- 1. Create a file named `.nvim.lua` in the root directory of your workspace
-- 2. Apply workspace-specific configurations like such:
--
--     vim.g.keep_tree_open = true

-- Whether to keep nvim_tree (netrw replacement) open when navigating between files
vim.g.keep_tree_open = false

-- Load nvimrc
require("config-local").setup({ lookup_parents = true })
