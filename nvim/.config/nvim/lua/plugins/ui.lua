return {
  -- statusline: pill-shaped, sky in normal mode
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin" },
    opts = function()
      local c = require("catppuccin.palettes").get_palette("mocha")
      local function mode(color)
        return {
          a = { fg = c.crust, bg = color, gui = "bold" },
          b = { fg = color, bg = c.surface0 },
          c = { fg = c.subtext0, bg = "NONE" },
        }
      end
      local theme = {
        normal = mode(c.sky),
        insert = mode(c.green),
        visual = mode(c.mauve),
        replace = mode(c.red),
        command = mode(c.peach),
        terminal = mode(c.teal),
        inactive = {
          a = { fg = c.overlay0, bg = "NONE" },
          b = { fg = c.overlay0, bg = "NONE" },
          c = { fg = c.overlay0, bg = "NONE" },
        },
      }
      local function lsp_names()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          names[#names + 1] = client.name
        end
        return #names > 0 and ("\u{f085} " .. table.concat(names, " ")) or ""
      end
      return {
        options = {
          theme = theme,
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", icon = "\u{e7c5}", separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, padding = { left = 0, right = 1 } } },
          lualine_b = { { "branch", icon = "\u{e725}" }, "diff" },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 2, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}", unnamed = "[No Name]" } },
            { "diagnostics", symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "󰌵 " } },
          },
          lualine_x = {
            { lsp_names, color = { fg = c.overlay1 } },
          },
          lualine_y = { { "progress" } },
          lualine_z = { { "location", separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, padding = { left = 1, right = 0 } } },
        },
        extensions = { "lazy", "mason", "quickfix" },
      }
    end,
  },

  -- buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = function()
      local highlights
      local ok, integ = pcall(require, "catppuccin.groups.integrations.bufferline")
      if ok then
        local get = integ.get_theme or integ.get
        if get then highlights = get() end
      end
      return {
        highlights = highlights,
        options = {
          mode = "buffers",
          separator_style = "thin",
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          close_command = function(n) Snacks.bufdelete(n) end,
          diagnostics = "nvim_lsp",
          indicator = { style = "underline" },
          offsets = {
            { filetype = "snacks_layout_box", text = "\u{f07c}  Explorer", highlight = "Directory", separator = true },
          },
        },
      }
    end,
  },

  -- prettier cmdline / messages; notifications go to snacks.notifier
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      notify = { enabled = false },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
      },
      cmdline = {
        format = {
          cmdline = { icon = "\u{f054}" },
          search_down = { icon = "\u{f002} \u{f063}" },
          search_up = { icon = "\u{f002} \u{f062}" },
          lua = { icon = "\u{e620}" },
          help = { icon = "󰋖" },
        },
      },
      routes = {
        { filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = { border = "rounded", title = true },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "g", group = "goto" },
        { "[", group = "prev" },
        { "]", group = "next" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  { "echasnovski/mini.icons", lazy = true, opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = { completions = { blink = { enabled = true } } },
  },
}
