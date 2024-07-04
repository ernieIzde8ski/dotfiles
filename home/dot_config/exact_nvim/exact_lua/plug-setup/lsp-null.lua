local mason_null_ls = require("mason-null-ls")
local null_ls = require("null-ls")
local null_ls_helpers = require("null-ls.helpers")

mason_null_ls.setup({
    automatic_installation = true,
    ensure_installed = { "prettierd", "blackd_client" },
})

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitrebase,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.formatting.prettierd,
        {
            name = "blackd",
            method = null_ls.methods.FORMATTING,
            filetypes = { "python" },
            generator = null_ls_helpers.formatter_factory({
                command = "blackd-client",
                to_stdin = true,
            }),
        },
    },
})
