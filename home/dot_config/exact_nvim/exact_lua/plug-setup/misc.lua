require("gitsigns").setup({
    attach_to_untracked = true,
    current_line_blame = true,
})

require("autoclose").setup({
    keys = {
        ["'"] = {
            close = false,
            escape = true,
            pair = "''",
            disable_command_mode = true,
        },
    },
})

if vim.g.discord_available then
    require("neocord").setup({
        logo_tooltip = "You pissant little gnome.",
        show_time = true,
        global_timer = true,
    })
end
