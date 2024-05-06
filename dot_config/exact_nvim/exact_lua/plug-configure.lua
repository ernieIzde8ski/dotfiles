local has = vim.fn["has"]
function setup(opts)
    if opts.is_terminal then
        require("gitsigns").setup({
            attach_to_untracked = true,
            current_line_blame = true,
        })

        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "gotmpl",
                "javascript",
                "lua",
                "markdown",
                "python",
                "rust",
                "toml",
                "typescript",
                "yaml",
            },
            highlight = { enable = true },
            indent = { enable = true },
        })

        if has("termguicolors") then
            vim.o.termguicolors = true
        end

        vim.cmd([[
            syntax enable
            colorscheme OceanicNext
        ]])
    end

    if opts.discord_available then
        require("neocord").setup({
            logo_tooltip = "You pissant little gnome.",
            show_time = true,
            global_timer = true,
        })
    end

    -- lspconfig setup
    local lspconfig = require("lspconfig")

    lspconfig.gopls.setup({})
    lspconfig.hls.setup({ filetypes = { "haskell", "lhaskell", "cabal" } })
    lspconfig.pyright.setup({})
    lspconfig.tsserver.setup({})

    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "require" },
                },
                runtime = { version = "LuaJIT" },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    })

    -- making floating displays have a border
    local float_border = { border = "single" }

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, float_border)

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, float_border)

    vim.diagnostic.config({
        float = float_border,
    })

    -- attaching keymaps, floating displays alongside the lsp
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local keymaps = {
                ["<Leader>f"] = "format",
                ["<F2>"] = "rename",
                ["K"] = "hover",
                ["g<C-d>"] = "type_definition",
                ["gD"] = "declaration",
                ["gd"] = "definition",
                ["gr"] = "references",
            }

            local bufnr = args.buf
            local keymap_opts = { noremap = true, silent = true }

            for lhs, rhs in pairs(keymaps) do
                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    lhs,
                    "<cmd>lua vim.lsp.buf." .. rhs .. "()<CR>",
                    keymap_opts
                )
            end
        end,
    })
end

return { setup = setup }
