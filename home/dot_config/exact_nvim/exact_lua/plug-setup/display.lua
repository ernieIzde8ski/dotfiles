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

-- floating notifications
if vim.opt.termguicolors then
    vim.notify = require("notify")
    require("lsp-notify").setup({})
end
