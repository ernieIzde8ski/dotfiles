local wezterm = require("wezterm")

local color_schemes = require("color_schemes")

local config = {
    color_scheme = color_schemes.random(),
    font = wezterm.font_with_fallback({
        "CommitMonoErnie",
        "Comic Shanns Mono",
        "ComicShannsMonoNerdFont",
    }),
    font_size = 13.0,
}

config.set_environment_variables = {
    WEZTERM_DEBUG_COLOR_SCHEME = config.color_scheme,
}

return config
