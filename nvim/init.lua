vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 100,
        })
    end,
})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		--vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		--vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		--vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		--vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		--vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		--vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		--vim.keymap.set("n", "<C-!>", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "<Leader>!", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		--vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		--vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

		local hlock = false
		vim.keymap.set("n", "<Leader><Leader>", function() hlock = not hlock end, opts)

		local client = vim.lsp.get_client_by_id(e.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, e.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = e.buf, group = highlight_augroup,
				callback = function() if not hlock then vim.lsp.buf.document_highlight() end end,
			})

			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = e.buf, group = highlight_augroup,
				callback = function() if not hlock then vim.lsp.buf.clear_references() end end,
			})

			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
				callback = function(e2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e2.buf }
				end,
			})
		end
	end
})

vim.api.nvim_create_autocmd('FocusLost', {
    pattern = '*',
    callback = function() vim.opt.mouse = "" end
})

vim.api.nvim_create_autocmd('FocusGained', {
    pattern = '*',
    callback = function() vim.opt.mouse = "nv" end
})

if vim.loop.os_uname().release:lower():find 'microsoft' then
	vim.g.clipboard = {
	    name = 'WslClipboard',
	    copy = {
		["+"] = 'clip.exe',
		["*"] = 'clip.exe',
	    },
	    paste = {
		["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	    },
	    cache_enabled = 0,
	}
end

vim.g.have_nerd_font = true

vim.opt.mouse = "nv"

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.guicursor = "a:blinkon500-blinkoff500"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.list = true
vim.opt.listchars = "eol:¬,tab:… ,space:·"
--vim.opt.listchars = "eol:¬,tab:⇢ ,space:·"
--vim.opt.listchars = "tab:⇢ ,space:·"

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 1000

vim.opt.hidden = false

vim.g.mapleader = "ù"
vim.keymap.set("n", "<C-e>", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
--vim.keymap.set("n", "n", "nzzzv")
--vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>P", [["+P]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>ca", function()
    require("cellular-automaton").start_animation("make_it_rain")
end)
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

--vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>cd", ":exec 'cd' . expand('%:p:h')<CR>", { silent = true })

--vim.keymap.set({"", "!"}, "<LeftMouse>", "<nop>")
vim.keymap.set("n", "<RightMouse>", "<nop>")
vim.keymap.set("v", "<RightMouse>", [["+y]])
--vim.keymap.set("i", "<RightMouse>", [[<C-o>"+P]])
--vim.keymap.set("c", "<RightMouse>", "aaa")

vim.keymap.set({"n", "v"}, "<C-l>", "zL")
vim.keymap.set({"n", "v"}, "<C-h>", "zH")
vim.keymap.set("i", "<C-l>", "<C-o>zL")
vim.keymap.set("i", "<C-h>", "<C-o>zH")

vim.keymap.set("n", "*", "*N:set hls<CR>", { silent = true })
vim.keymap.set("n", "<Leader>j", ":set hls!<CR>", { silent = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = "plugins",
    change_detection = { notify = false }
})

vim.cmd.colorscheme('tokyonight')
