---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader><leader>"] = { "<C-^>", "swap to last buffer"},

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },

    ["[b"] = {
      "<cmd> bprevious <CR>", "previous buffer"
    },

    ["]b"] = {
      "<cmd> bnext <CR>", "next buffer"
    },
  },
  v = {
    [">"] = { ">gv", "indent"},
  },
}

-- more keybinds!

return M
