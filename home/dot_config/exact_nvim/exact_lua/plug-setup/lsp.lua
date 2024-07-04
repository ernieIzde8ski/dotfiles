local mason = require("mason")

-- setup for lspconfig
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

require("plug-setup/lsp-null")
require("plug-setup/lsp-lspconfig")
