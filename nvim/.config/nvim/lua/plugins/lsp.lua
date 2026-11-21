local servers = { "lua_ls", "bashls", "clangd", "basedpyright", "gopls", "jsonls", "ts_ls" }

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "\u{f00c}", package_pending = "\u{f110}", package_uninstalled = "\u{f00d}" },
      },
    },
  },

  { "folke/lazydev.nvim", ft = "lua", opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      vim.lsp.config("lua_ls", {
        settings = { Lua = { workspace = { checkThirdParty = false }, hint = { enable = true } } },
      })

      require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(ev)
          local function map(l, r, desc, mode)
            vim.keymap.set(mode or "n", l, r, { buffer = ev.buf, desc = desc })
          end
          map("K", function() vim.lsp.buf.hover() end, "Hover")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format", { "n", "x" })
          map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
        end,
      })
    end,
  },
}
