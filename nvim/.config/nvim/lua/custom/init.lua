-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.opt.relativenumber = true

-- hightlight yanked
vim.api.nvim_create_autocmd({"TextYankPost"}, {
  pattern = "*",
  callback = function ()
    require("vim.highlight").on_yank({
      timeout = 300
    })
  end
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})
