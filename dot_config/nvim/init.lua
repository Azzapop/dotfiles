vim.g.mapleader=','
vim.g.maplocalleader=','

-- undo settings
vim.opt.undofile=true
vim.opt.undodir=vim.fn.expand('~')..'/.cache/nvim/undo'
vim.opt.undolevels=1000
vim.opt.undoreload=10000

-- general settings
vim.opt.autoindent=true
-- reload files when changed on disk, i.e. via `git checkout`
vim.opt.autoread=true
-- see :help crontab
vim.opt.backupcopy='yes'
-- yank and paste with the system clipboard
vim.opt.clipboard='unnamed'
-- don't store swapfiles in the current directory
vim.cmd('set directory-=.')
-- expand tabs to spaces
vim.opt.expandtab=true
-- case-insensitive search
vim.opt.ignorecase=true
-- case-sensitive search if any caps
vim.opt.smartcase=true
-- always show statusline
vim.opt.laststatus=2
-- show trailing whitespace
vim.opt.list=true
-- set chars for various whitespace
vim.opt.listchars={
  tab = "▸ ",
  trail = "▫",
}
-- set line numbers
vim.opt.number=true
-- show current line and column in status bar
vim.opt.ruler=true
-- show content above/below cursorline
vim.opt.scrolloff=7
-- normal mode indentation uses 2 spaces
vim.opt.shiftwidth=2
-- show info about current command
vim.opt.showcmd=true
-- insert mode tab and backspace use 2 spaces
vim.opt.softtabstop=2
-- actual tabs occupy 8 characters
vim.opt.tabstop=8

-- show a navigable menu for tab completion
vim.opt.wildmenu=true
-- ignore paths for tab completion
vim.opt.wildignore={'log/**','node_modules/**','target/**','tmp/**','*.rbc'}
-- completion mode options
vim.opt.wildmode={'longest','list','full'}

-- time until swapfile write
vim.opt.updatetime=250
-- enable mouse support
vim.opt.mouse='a'
-- enable gui colors
vim.opt.termguicolors=true

-- open a window on hover of symbol if lsp has any diagnostics/hints
vim.cmd([[autocmd! CursorHold,CursorHoldI * :lua vim.lsp.buf.hover()]])
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { focusable = false }
)

-- require the lazy.nvim plugin manager, this will install and manage all plugins
require('core.lazy')

-- colorscheme at the end as it is dependant on plugins
vim.cmd.colorscheme 'nordic'
