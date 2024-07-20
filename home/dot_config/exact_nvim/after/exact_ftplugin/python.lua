local set_keymap = require("helpers.set-keymap")
set_keymap("n", "<Leader>f", ":update | !black %:p", true)
