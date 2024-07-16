return {
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
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
        end,
    },

    -- netrw replacement
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

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
            vim.api.nvim_set_keymap(
                "n",
                "<F3>",
                "",
                { callback = nvim_tree_api.tree.toggle }
            )
            vim.api.nvim_set_keymap(
                "v",
                "<F3>",
                "",
                { callback = nvim_tree_api.tree.toggle }
            )
        end,
    },

    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        opts = {},
    },

    -- git stuff
    { "tpope/vim-fugitive" },
    { "tpope/vim-rhubarb" },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            attach_to_untracked = true,
            current_line_blame = true,
        },
    },

    -- other display stuff
    {
        "mrded/nvim-lsp-notify",
        dependencies = { "rcarriga/nvim-notify" },
        opts = {},
    },
}
