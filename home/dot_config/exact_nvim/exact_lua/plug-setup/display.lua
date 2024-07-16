-- treesitter

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "diff",
        "gitignore",
        "gitcommit",
        "gotmpl",
        "haskell",
        "ini",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "python",
        "rust",
        "toml",
        "typescript",
        "typst",
        "vimdoc",
        "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
})

-- kanagawa color scheme
vim.cmd.syntax("enable")
vim.cmd.colorscheme("kanagawa")

if vim.opt.termguicolors then
    -- floating notifications
    vim.notify = require("notify")
    require("lsp-notify").setup({})

    -- replacing netrw with nvim-tree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-web-devicons").setup({})
    require("nvim-tree").setup({
        hijack_cursor = true,
        diagnostics = {
            enable = true,
        },
        actions = {
            open_file = {
                quit_on_open = not vim.g.keep_tree_open,
            },
        },
    })

    local nvim_tree_api = require("nvim-tree.api")
    vim.api.nvim_set_keymap("n", "<F3>", "", { callback = nvim_tree_api.tree.open })
    vim.api.nvim_set_keymap("v", "<F3>", "", { callback = nvim_tree_api.tree.open })
end
