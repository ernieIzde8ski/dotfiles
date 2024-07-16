local mason_null_ls = require("mason-null-ls")
local null_ls = require("null-ls")
local null_ls_helpers = require("null-ls.helpers")

null_ls.setup({

    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.black,
    },
})

mason_null_ls.setup({
    automatic_installation = true,
    ensure_installed = { "prettierd", "blackd_client" },

    methods = {
        diagnostics = false,
        formatting = true,
        code_actions = true,
        completion = false,
        hover = false,
    },
})
