---@type { [string]: string }
local _lsp_keymaps = {
    ["<Leader>a"] = "code_action",
    ["<Leader>f"] = "format",
    ["<F2>"] = "rename",
    ["K"] = "hover",
    ["g<C-d>"] = "type_definition",
    ["gD"] = "declaration",
    ["gd"] = "definition",
    ["gr"] = "references",
}

---@type fun(name: string): { noremap: boolean, silent: boolean, callback: function }
local function _keymap_opts(name)
    return { noremap = true, silent = true, callback = vim.lsp.buf[name] }
end

---@param args { buf: number }
---@return nil
local function on_lsp_attach(args)
    local bufnr = args.buf
    for key, map in pairs(_lsp_keymaps) do
        local opts = _keymap_opts(map)
        vim.api.nvim_buf_set_keymap(bufnr, "n", key, "", opts)
    end
end

-- all servers that use default capabilities
---@type { [string]: { filetypes?: string[], capabilities: any, settings: any } }
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

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mrded/nvim-lsp-notify" },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", { callback = on_lsp_attach })
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.code_actions.gitrebase,
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.black,
                },
            })
        end,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            automatic_installation = true,
            ensure_installed = { "prettierd", "black" },
            methods = {
                code_actions = true,
                formatting = true,
                completion = false,
                diagnostics = false,
                hover = false,
            },
        },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup({
                ensure_installed = {
                    "gopls",
                    "jsonls",
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "tsserver",
                },
            })

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
        end,
    },
}
