function getRuntimeOptions()
    local is_terminal = not vim.g.vscode
    local discord_available = is_terminal
        and os.execute("test -S $XDG_RUNTIME_DIR/discord-ipc-0") == 0
    return {
        is_terminal = is_terminal,
        discord_available = discord_available,
    }
end

local opts = getRuntimeOptions()

require("settings")
require("plug-install").setup(opts)
require("plug-configure").setup(opts)
