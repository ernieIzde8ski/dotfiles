local vim = vim
local has = vim.fn["has"]

------- general
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = "\\(node_modules\\|venv\\|.git\\|__pycache__\\)/"

vim.opt.number = true

vim.api.nvim_create_user_command("Black", "w | !black %", {})

vim.keymap.set("n", "<F5>", "<cmd>up<cr>")

-- 4-space-width tabs
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0

------- vim-plug
local Plug = vim.fn["plug#"]

-- automatic installation of missing plugins
-- don't ask me how it works, it's on the wiki
vim.cmd([[
   autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
    \| endif
]])

vim.call("plug#begin")

if not vim.g.vscode then
	Plug("IogaMaster/neocord")
	Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
	Plug("mhartington/oceanic-next")
end

Plug("neovim/nvim-lspconfig")
Plug("tpope/vim-eunuch")

vim.call("plug#end")

------- plugin config
if not vim.g.vscode then
	require("neocord").setup({
		logo_tooltip = "You pissant little gnome.",
		show_time = true,
		global_timer = true,
	})

	require("nvim-treesitter.configs").setup({
		-- the languages that I tend to work with
		ensure_installed = { "python", "rust", "markdown", "lua", "typescript", "javascript" },
	})

	if has("termguicolors") then
		vim.o.termguicolors = true
	end

	vim.cmd([[
    	syntax enable
        colorscheme OceanicNext
    ]])
end

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
lspconfig.tsserver.setup({})
