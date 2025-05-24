-- While wezterm nicely provides us with a fallback font system,
-- if the first font in the list is not available, it throws an error.
-- `wezterm` does depend on `fontconfig` though, so we can use `fc-list`
-- to check what fonts we can use by ourselves.


local wezterm = require("wezterm")

local defaults = {
    "CommitMonoErnie Nerd Font",
    "CommitMonoErnie_v1",
    "Comic Shanns Mono",
    "ComicShannsMono Nerd Font",
}

local function available_fallback_fonts()
    ---@type string[]
    local res

    local args = wezterm.shell_split("fc-list : family | sort | uniq")
    local success, stdout = wezterm.run_child_process(args)

    if success == false then
        res = defaults
    else
        ---@type { [string]: boolean }
        local map = {}

        for line in stdout:gmatch("[^\r\n]+") do
            map[line] = true
        end

        res = {}
        for _, s in ipairs(defaults) do
            if map[s] == true then
                table.insert(res, s)
            end
        end
    end

    return wezterm.font_with_fallback(res)
end

return {
    setup = available_fallback_fonts,
}
