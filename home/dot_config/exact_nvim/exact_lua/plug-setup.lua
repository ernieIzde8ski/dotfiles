local plug_install = vim.cmd.PlugInstall

---@type string[]
local setup_scripts = {
    -- "nvimrc",
    "completions",
    "display",
    "lsp",
    "misc",
}

-- Try to load display first, if possible

pcall(require, "plug-setup.display")

-- ensure missing plugins are installed

for _, v in pairs(vim.g.plugs) do
    -- check if corresponding directory to a plugin exists
    if vim.fn.isdirectory(v.dir) == 0 then
        plug_install("--sync")
        break
    end
end

-- load setup configurations

local success = true

for _, value in ipairs(setup_scripts) do
    value = "plug-setup." .. value
    local ok, mod_or_error = pcall(require, value)
    if not ok then
        vim.notify('[plug-setup] module "' .. value .. '" failed\n\n' .. mod_or_error)
    end
end

if success then
    vim.notify("[plug-setup] plugin setup successful!")
end
