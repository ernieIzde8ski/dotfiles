local M = {}
---@class Themes: string[]
---@field random fun(self): string

---Returns a random valid theme.
---@param theme_options Themes
---@return string | nil
local function colorscheme_choice(theme_options)
    local wezterm = require("wezterm")

    local valid_colorschemes = wezterm.get_builtin_color_schemes()

    local i_k = 0
    while i_k < 10 do
        local i = math.random(#theme_options + 1)
        local res = theme_options[i]
        if valid_colorschemes[res] ~= nil then
            return res
        end
        i_k = i_k + 1
    end

    return nil
end

---@type Themes
M.dark_schemes = {
    "Bamboo Multiplex",
    "Canvased Pastel (terminal.sexy)",
    "Count Von Count (terminal.sexy)",
    "Earthsong",
    "Ef-Autumn",
    "Ef-Cherie",
    "Ef-Cyprus",
    "Ef-Deuteranopia-Dark",
    "Ef-Duo-Dark",
    "Ef-Elea-Dark",
    "Ef-Maris-Dark",
    "Ef-Melissa-Dark",
    "Ef-Rosa",
    "Ef-Symbiosis",
    "Ef-Tritanopia-Dark",
    "Elemental",
    "Embers (dark) (terminal.sexy)",
    "Popping and Locking",
    "Pretty and Pastel (terminal.sexy)",
    "Solarized Dark (Gogh)",
    "Solarized Dark Higher Contrast (Gogh)",
    random = colorscheme_choice,
}

---@type Themes
M.light_schemes = {
    "Bamboo Light",
    "Blue Dolphin (Gogh)",
    "Bluloco Zsh Light (Gogh)",
    "BlueDolphin", -- disable when we enable Blue Dolphin (Gogh)
    "Ef-Arbutus",
    "Ef-Deuteranopia-Light",
    "Ef-Duo-Light",
    "Ef-Elea-Light",
    "Ef-Maris-Light",
    "Ef-Melissa-Light",
    "Ef-Spring",
    "Ef-Tritanopia-Light",
    "Embers (light) (terminal.sexy)",
    "Greenscreen (light) (terminal.sexy)",
    "Solarized Light (Gogh)",
    random = colorscheme_choice,
}

---Picks a random theme based off the current environment.
---@return string -- Theme name.
function M.random()
    if os.getenv("IS_WORK_MACHINE") == "true" then
        return M.light_schemes:random()
    else
        return M.dark_schemes:random()
    end
end

return M
