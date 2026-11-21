-- nvim-treesitter `main` branch: it only installs parsers; highlighting and
-- indent are switched on per buffer below.
local parsers = {
  "bash", "c", "cpp", "css", "diff", "go", "gomod", "gitcommit", "git_rebase",
  "html", "hyprlang", "ini", "javascript", "json", "lua", "luadoc", "make",
  "markdown", "markdown_inline", "python", "query", "rasi", "regex", "rust",
  "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup({})
    ts.install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
