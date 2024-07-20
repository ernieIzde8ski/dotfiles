local set_keymap = require("helpers.set-keymap")

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

            local api = require("nvim-tree.api")
            set_keymap({ "n", "v" }, "<F3>", api.tree.toggle)
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
    {
        "tpope/vim-fugitive",
        config = function()
            set_keymap("n", "<Leader>gcc", ":Git commit")
            set_keymap("n", "<Leader>gcc", ":Git commit --patch")
        end,
    },

    {
        "tpope/vim-rhubarb",
        dependencies = "tpope/vim-fugitive",
        config = function()
            set_keymap({ "n", "v" }, "<Leader>gb", ":GBrowse")
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local gitsigns = require("gitsigns")

            gitsigns.setup({
                attach_to_untracked = false,
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 0,
                    virt_text_pos = "right_align",
                },
                numhl = true,
            })

            set_keymap("n", "<Leader>gs", gitsigns.stage_hunk)
            set_keymap("n", "<Leader>gS", gitsigns.stage_buffer)
            set_keymap("n", "<Leader>gP", gitsigns.preview_hunk_inline)
            set_keymap({ "n", "v" }, "<Leader>gp", gitsigns.preview_hunk)
            set_keymap({ "n", "v" }, "<Leader>gw", gitsigns.toggle_word_diff)
            set_keymap({ "n", "v" }, "[g", function()
                gitsigns.nav_hunk("prev")
            end)
            set_keymap({ "n", "v" }, "]g", function()
                gitsigns.nav_hunk("next")
            end)
        end,
    },

    -- LSP display
    {
        "mrded/nvim-lsp-notify",
        dependencies = { "rcarriga/nvim-notify" },
        config = true,
    },

    {
        "felpafel/inlay-hint.nvim",
        config = true,
    },
}
