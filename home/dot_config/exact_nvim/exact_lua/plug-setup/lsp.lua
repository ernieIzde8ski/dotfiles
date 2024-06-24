local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local lsp_keymaps = {
    ["<Leader>a"] = "code_action",
    ["<Leader>f"] = "format",
    ["<F2>"] = "rename",
    ["K"] = "hover",
    ["g<C-d>"] = "type_definition",
    ["gD"] = "declaration",
    ["gd"] = "definition",
    ["gr"] = "references",
}

local function on_lsp_attach(args)
    local bufnr = args.buf
    local keymap_opts = { noremap = true, silent = true }

    for lhs, rhs in pairs(lsp_keymaps) do
        vim.api.nvim_buf_set_keymap(
            bufnr,
            "n",
            lhs,
            "<cmd>lua vim.lsp.buf." .. rhs .. "()<CR>",
            keymap_opts
        )
    end
end

-- all servers that use the default capabilities

local lspconfig_server_configs = {
    hls = {
        filetypes = { "haskell", "lhaskell", "cabal" },
    },
    lua_ls = {
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
    },
    typst_lsp = {
        settings = { exportPdf = "never" },
    },
}

-- setup for lspconfig
mason.setup()
mason_lspconfig.setup({
    ensure_installed = {
        "gopls",
        "jsonls",
        "pyright",
        "rust_analyzer",
        "tsserver",
        "tinymist",
    },
})

local capabilities = cmp_nvim_lsp.default_capabilities()

mason_lspconfig.setup_handlers({
    function(server_name)
        local config = lspconfig_server_configs[server_name]
        if config == nil then
            lspconfig[server_name].setup({ capabilities = capabilities })
        else
            config.capabilities = capabilities
            lspconfig[server_name].setup(config)
        end
    end,

    ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup({
            settings = {
                ["rust-analyzer"] = {
                    imports = {
                        granularity = { group = "module" },
                        prefix = "self",
                    },
                    cargo = {
                        buildScripts = { enable = true },
                    },
                    procMacro = { enable = true },
                },
            },
        })
    end,
})

-- attaching keymaps, floating displays alongside the lsp
vim.api.nvim_create_autocmd("LspAttach", { callback = on_lsp_attach })
