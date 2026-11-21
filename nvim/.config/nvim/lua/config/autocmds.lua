local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user", { clear = true })

au("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 180 }) end,
})

-- reopen files at the last cursor position
au("BufReadPost", {
  group = group,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- equalise splits when the window (e.g. a Hyprland tile) is resized
au("VimResized", { group = group, command = "tabdo wincmd =" })

-- close helper windows with q
au("FileType", {
  group = group,
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo", "notify" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- prose
au("FileType", {
  group = group,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
