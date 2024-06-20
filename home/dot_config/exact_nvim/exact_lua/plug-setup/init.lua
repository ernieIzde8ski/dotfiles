local files = {
    "display",
    "completions",
    "lsp",
    "misc",
}

local success = true

for _, value in ipairs(files) do
    value = "plug-setup." .. value
    local ok, mod_or_error = pcall(require, value)
    if not ok then
        vim.notify('[plug-setup] module "' .. value .. '" failed\n\n' .. mod_or_error)
    end
end

if success then
    vim.notify("[plug-setup] plugin setup successful!")
end
