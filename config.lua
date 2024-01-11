reload "user.emmet-ls"
reload "user.dap-js"

lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  t = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=30 direction=horizontal<cr>", "Split horizontal" },
}

require("toggleterm").setup {
  direction = "horizontal",
  size = 26,
  open_mapping = [[<c-\>]],
  -- 打开新终端后自动进入插入模式
  start_in_insert = true,
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  {
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespace, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    args = { "--print-width", "100" },
  },
})
local code_actions = require("lvim.lsp.null-ls.code_actions")
code_actions.setup({
  {
    command = "proselint",
    args = { "--json" },
  },
})

lvim.builtin.terminal.active = true
lvim.builtin.terminal.size = 10
lvim.builtin.terminal.direction = "horizontal"
-- vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})

lvim.plugins = {
  {
    "terryma/vim-multiple-cursors",
    event = "VeryLazy",
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "aca/emmet-ls",
  },
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
  {
    "rcarriga/nvim-dap-ui",
  },
  {
    "tomasky/bookmarks.nvim",
    event = "VimEnter",
    config = function()
      require('bookmarks').setup {
        -- sign_priority = 8,  --set bookmark sign priority to cover other sign
        save_file = vim.fn.expand "$HOME/.bookmarks", -- bookmarks save file path
        keywords = {
          ["@t"] = "☑️ ",                         -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️ ",                         -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏ ",                            -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = " ",                            -- mark annotation startswith @n ,signs this icon as `Note`
        },
        on_attach = function()
          local bm = require "bookmarks"
          local map = vim.keymap.set
          map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "mi", bm.bookmark_ann)    -- add or edit mark annotation at current line
          map("n", "mc", bm.bookmark_clean)  -- clean all marks in local buffer
          map("n", "mn", bm.bookmark_next)   -- jump to next mark in local buffer
          map("n", "mp", bm.bookmark_prev)   -- jump to previous mark in local buffer
          map("n", "ml", bm.bookmark_list)   -- show marked file list in quickfix window
        end
      }
    end
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        default_mappings = true,
      }
    end
  },
  {
    "adelarsq/image_preview.nvim",
    event = 'VeryLazy',
    config = function()
      require("image_preview").setup {
        default = {
          width = 120,
          height = 120,
        },
        filetype = {
          markdown = {
            width = 120,
            height = 120,
          },
          jpeg = {
            width = 120,
            height = 120,
          },
          png = {
            width = 120,
            height = 120,
          },
          gif = {
            width = 120,
            height = 120,
          },
          svg = {
            width = 120,
            height = 120,
          },
        },
      }
    end,
  },
}

vim.g.copilot_assume_mapped = true
vim.g.copilot_no_tab_map = true
vim.g.copilot_tab_fallback = ""
local cmp = require "cmp"
lvim.builtin.cmp.mapping["<Tab>"] = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    local copilot_keys = vim.fn["copilot#Accept"]()
    if copilot_keys ~= "" then
      vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
      fallback()
    end
  end
end

-- vim.wo.foldmethod = "indent"
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.wo.foldenable = false
-- vim.wo.fillchars = "fold: "
-- vim.wo.foldnestmax = 3
-- vim.wo.foldminlines = 1
-- vim.wo.foldlevel = 1
-- vim.wo.foldtext =
-- [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

lvim.redrawtime = 10000
lvim.maxmempattern = 10000

-- lvim.builtin.nvimtree.setup.view.adaptive_size = 0;
-- lvim.builtin.nvimtree.setup.view.width = 30;
-- 自动切换到当前文件的目录
lvim.builtin.project.manual_mode = true
lvim.builtin.project.active = false
lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode['gu'] = ":lua vim.lsp.buf.references()<CR>"

require('telescope').load_extension('bookmarks')
