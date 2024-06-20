local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")

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
local lsp_servers = {
    gopls = {},
    hls = {
        filetypes = { "haskell", "lhaskell", "cabal" },
    },
    jsonls = {},
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
    pyright = {},
    tsserver = {},
    typst_lsp = {
        settings = { exportPdf = "never" },
    },
}

-- setup for lspconfig
local capabilities = cmp_nvim_lsp.default_capabilities()

for server, settings in pairs(lsp_servers) do
    settings.capabilities = capabilities
    lspconfig[server].setup(settings)
end

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

-- attaching keymaps, floating displays alongside the lsp
vim.api.nvim_create_autocmd("LspAttach", { callback = on_lsp_attach })
