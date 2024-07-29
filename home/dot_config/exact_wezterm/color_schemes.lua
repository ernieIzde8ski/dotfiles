local M = {}
-- commented themes are only in nightly builds

---@type string[]
M.dark_themes = {
    "Bamboo Multiplex",
    "Canvased Pastel (terminal.sexy)",
    "Count Von Count (terminal.sexy)",
    "Crayon Pony Fish (Gogh)",
    "Earthsong",
    "Ef-Autumn",
    "Ef-Cherie",
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
}

---@type string[]
M.light_themes = {
    "Bamboo Light",
    -- "Blue Dolphin (Gogh)",
    "Bluloco Zsh Light (Gogh)",
    "BlueDolphin", -- disable when we enable Blue Dolphin (Gogh)
    "Crayon Pony Fish (Gogh)",
    "Ef-Arbutus",
    "Ef-Cyprus",
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
}

---Returns a random element from an array.
---@generic T
---@param arr T[]
---@return T
local function choice(arr)
    local n = math.random(#arr + 1)
    return arr[n]
end

---Picks a random theme based off the current environment.
---@return string -- Theme name.
function M.random()
    if os.getenv("IS_WORK_MACHINE") == "true" then
        return choice(M.light_themes)
    else
        return choice(M.dark_themes)
    end
end

return M
