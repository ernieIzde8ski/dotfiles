local color_schemes = require("color_schemes")

local config = {
    clean_exit_codes = { 0, 130 },
    exit_behavior = "CloseOnCleanExit",

    color_scheme = color_schemes.random(),

    enable_scroll_bar = true,

    font = require("fallback_fonts").setup(),
    font_size = 13.0,

    prefer_to_spawn_tabs = true,
    show_new_tab_button_in_tab_bar = false,
}

config.set_environment_variables = {
    WEZTERM_DEBUG_COLOR_SCHEME = config.color_scheme,
}

return config
