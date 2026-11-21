local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.showmode = false -- lualine shows it
o.laststatus = 3 -- one global statusline
o.cmdheight = 0
o.pumheight = 12
o.pumblend = 0
o.winborder = "rounded"
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.fillchars = { eob = " ", fold = " ", foldopen = "\u{f47c}", foldclose = "\u{f460}", foldsep = " " }
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.shiftround = true

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

o.mouse = "a"
o.clipboard = "unnamedplus" -- wl-clipboard
o.undofile = true
o.swapfile = false
o.updatetime = 200
o.timeoutlen = 300
o.confirm = true
o.virtualedit = "block"
o.completeopt = { "menu", "menuone", "noselect" }
o.shortmess:append({ I = true, c = true, W = true })

o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded", source = "if_many" },
  underline = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f057} ",
      [vim.diagnostic.severity.WARN] = "\u{f071} ",
      [vim.diagnostic.severity.INFO] = "\u{f05a} ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})
