local set_local_keymap = vim.api.nvim_buf_set_keymap
local set_global_keymap = vim.api.nvim_set_keymap

---Sets a keymap, optionally with respect to a buffer.
---@param mode string | string[]
---@param key string
---@param map string | function
---@param bufnr integer | boolean?
local function set_keymap(mode, key, map, bufnr)
    if type(mode) == "table" then
        for _, m in ipairs(mode) do
            set_keymap(m, key, map, bufnr)
        end

        return
    end

    ---@type { noremap: boolean, silent: boolean, callback?: function }
    local opts = { noremap = true, silent = true }
    if type(map) == "function" then
        opts.callback = map
        map = ""
    end

    if bufnr == false or bufnr == nil then
        set_global_keymap(mode, key, map, opts)
    else
        if type(bufnr) == "boolean" then
            -- `bufnr == true` here
            bufnr = vim.api.nvim_get_current_buf()
        end
        set_local_keymap(bufnr, mode, key, map, opts)
    end
end

return set_keymap
