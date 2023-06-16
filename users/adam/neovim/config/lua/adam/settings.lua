function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

local opt = vim.opt
local g = vim.g
local HOME = os.getenv("HOME")

opt.number = true
opt.relativenumber = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.hidden = true

opt.undodir = HOME .. "/.nvim/undodir";
opt.undofile = true

opt.swapfile = false

opt.showmode = false
opt.signcolumn = "auto"

opt.scrolloff = 8
opt.wrap = true
opt.cursorline = true

opt.updatetime = 1000

opt.splitbelow = true
opt.splitright = true

-----------------------------------------------------------------------------
-- Text, tab and indent related
-----------------------------------------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

opt.expandtab = true
opt.smartindent = true

-- Map, Remap and Leader
-- set <leader> to Spacebar
map("","<Space>","<Nop>")
g.mapleader = " "

-- copy & paste - C stands for CTRL
vmap("<C-c>","\"+y")
nmap("<C-v>","\"+p")

-- disable arrow navigation
map("","<Up>","<Nop>")
map("","<Down>","<Nop>")
map("","<Left>","<Nop>")
map("","<Right>","<Nop>")

-- splits navigation
nmap("<C-h>","<C-w>h")
nmap("<C-j>","<C-w>j")
nmap("<C-k>","<C-w>k")
nmap("<C-l>","<C-w>l")

-- resizing splits
map("","<C-Left>",":vertical resize -3<CR>")
map("","<C-Right>",":vertical resize +3<CR>")
map("","<C-Up>",":resize +3<CR>")
map("","<C-Down>",":resize -3<CR>")

-- stay in indent mode
vmap("<","<gv")
vmap(">",">gv")

-- move text up and down - A stands for ALT
nmap("<A-j>",":m .+1<CR>==")
nmap("<A-k>",":m .-2<CR>==")
imap("<A-j>","<Esc>:m .+1<CR>==gi")
imap("<A-k>","<Esc>:m .-2<CR>==gi")
vmap("<A-j>",":m '>+1<CR>gv==gv")
vmap("<A-k>",":m '<-2<CR>gv==gv")

-- keep the yanked value in register after it was copied on top of another work
vmap("p","\"_dp")

-- Plugins maps

-- Nvim Tree Lua
nmap("<leader>e",":NvimTreeToggle <CR>")
-- Buffer Line
map("","<S-l>",":bnext <CR>")
map("","<S-h>",":bprevious <CR>")
nmap("<S-w>",":Bdelete! <CR>")

-- theme
vim.cmd[[colorscheme gruvbox]]
