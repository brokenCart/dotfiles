-- snacks.nvim: dashboard, picker, explorer, notifications, indent guides,
-- smooth scroll, terminal, zen and a bunch of small QoL bits.
local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true, style = "fancy", timeout = 3000 },
    indent = {
      enabled = true,
      indent = { char = "│" },
      scope = { char = "│" },
      animate = { duration = { step = 15, total = 250 } },
    },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    explorer = { enabled = true, replace_netrw = true },
    picker = {
      enabled = true,
      prompt = " \u{f054} ",
      layout = { preset = "telescope" },
      sources = {
        explorer = { layout = { layout = { position = "left" } } },
      },
    },
    styles = {
      notification = { border = "rounded", wo = { wrap = true } },
    },
    dashboard = {
      enabled = true,
      width = 56,
      preset = {
        header = header,
        keys = {
          { icon = "\u{f002} ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "\u{f15b} ", key = "n", desc = "New file", action = ":ene | startinsert" },
          { icon = "\u{f0b0} ", key = "g", desc = "Live grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "\u{f1da} ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "\u{e5fc} ", key = "d", desc = "Dotfiles", action = ":lua Snacks.dashboard.pick('files', {cwd = '~/dotfiles', hidden = true})" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "\u{f0ad} ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 2 },
        { section = "keys", gap = 1, padding = 2 },
        { section = "startup" },
      },
    },
  },
  keys = {
    -- find
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- search
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word under cursor", mode = { "n", "x" } },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo comments" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last picker" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Log" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Status" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Diff hunks" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
    -- lsp (overrides the plain defaults with picker versions)
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto type definition" },
    -- misc
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
    { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
