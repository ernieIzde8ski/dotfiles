local has = vim.fn["has"]

local function setup_completions()
    local cmp = require("cmp")
    local cmp_git = require("cmp_git")
    local snippy = require("snippy")

    -- setup for nvim-cmp
    local source_buffer = { { name = "buffer" } }

    cmp.setup({
        snippet = {
            expand = function(args)
                snippy.expand_snippet(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources(
            { { name = "nvim_lsp" }, { name = "snippy" } },
            source_buffer
        ),
    })

    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({ { name = "git" } }, source_buffer),
    })

    cmp_git.setup()

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = source_buffer,
    })
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
    })
end

local function setup_lspconfig()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")

    -- setup for lspconfig
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local default_opts = { capabilities = capabilities }

    lspconfig.gopls.setup(default_opts)
    lspconfig.hls.setup({
        capabilities = capabilities,
        filetypes = { "haskell", "lhaskell", "cabal" },
    })
    lspconfig.rust_analyzer.setup({})
    lspconfig.pyright.setup(default_opts)
    lspconfig.tsserver.setup(default_opts)

    lspconfig.lua_ls.setup({
        capabilities = capabilities,
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

local function setup_display()
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

    vim.cmd("syntax enable")
    vim.cmd("colorscheme kanagawa")

    -- making floating displays have a border
    local float_border = { border = "single" }

    vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, float_border)

    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, float_border)

    vim.diagnostic.config({
        float = float_border,
    })
end

local function setup()
    setup_completions()
    setup_lspconfig()

    require("gitsigns").setup({
        attach_to_untracked = true,
        current_line_blame = true,
    })

    require("config-local").setup({ lookup_parents = true })

    setup_display()

    if vim.g.discord_available then
        require("neocord").setup({
            logo_tooltip = "You pissant little gnome.",
            show_time = true,
            global_timer = true,
        })
    end
end

setup()
