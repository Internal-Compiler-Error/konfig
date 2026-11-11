-- Jump/navigation history behaviour, loaded from init.lua via require 'custom.jump'
local M = {}

-- [[ JetBrains-style navigation history ]]
-- <C-o>/<C-i> (or Ctrl+Alt+Left/Right, mouse back/forward) walk the jumplist like IDE Back/Forward.
--  stack: jumping somewhere new after going back drops the "forward" entries, like a browser
--  view:  going back also restores the scroll position, not just the cursor line
--  (no 'clean': files closed with :bd stay in history and reopen when you go back to them)
vim.opt.jumpoptions = { 'stack', 'view' }

-- Moves at least this many lines away count as navigation and are recorded in the jumplist
local jump_threshold = 5

-- Record `view` (where the cursor was before a move) as a jumplist entry in `win`
local function record_jump(win, view)
  vim.api.nvim_win_call(win, function()
    local now = vim.fn.winsaveview()
    vim.fn.winrestview(view)
    vim.cmd "normal! m'"
    vim.fn.winrestview(now)
  end)
end

-- `12j` / `12k` with a big count (relative line numbers) is navigation too
for _, key in ipairs { 'j', 'k' } do
  vim.keymap.set('n', key, function()
    return (vim.v.count >= jump_threshold and "m'" .. vim.v.count or '') .. key
  end, { expr = true, desc = 'Move ' .. key .. ' (large counts go in the jumplist)' })
end

-- Clicking far away from the cursor is navigation as well
vim.keymap.set('n', '<LeftMouse>', function()
  local win, buf, view = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), vim.fn.winsaveview()
  vim.schedule(function()
    if
      vim.api.nvim_get_current_win() == win
      and vim.api.nvim_get_current_buf() == buf
      and math.abs(vim.api.nvim_win_get_cursor(win)[1] - view.lnum) >= jump_threshold
    then
      record_jump(win, view)
    end
  end)
  return '<LeftMouse>'
end, { expr = true, desc = 'Click (far clicks go in the jumplist)' })

vim.keymap.set('n', '<X1Mouse>', '<C-o>', { desc = 'Navigate back' })
vim.keymap.set('n', '<X2Mouse>', '<C-i>', { desc = 'Navigate forward' })
vim.keymap.set('n', '<C-M-Left>', '<C-o>', { desc = 'Navigate back' })
vim.keymap.set('n', '<C-M-Right>', '<C-i>', { desc = 'Navigate forward' })

-- Wrap a picker so the position it was opened from is recorded, even when the
-- chosen result is in the same file (fff only adds a jump when it switches files)
function M.from_here(fn)
  return function(...)
    vim.cmd "normal! m'"
    return fn(...)
  end
end

-- Like <C-o>, but jumps back to the last location in a *different* buffer and closes the one we left
-- (unless it has unsaved changes or is shown in another window)
vim.keymap.set('n', '<C-M-o>', function()
  local buf = vim.api.nvim_get_current_buf()
  local jumps, idx = unpack(vim.fn.getjumplist())
  local count
  for i = idx, 1, -1 do
    if jumps[i].bufnr ~= buf then
      count = idx - i + 1
      break
    end
  end
  if not count then
    vim.notify('No earlier jump in another buffer', vim.log.levels.WARN)
    return
  end

  vim.cmd('execute "normal! ' .. count .. '\\<C-o>"')
  if vim.api.nvim_get_current_buf() == buf or vim.bo[buf].modified or #vim.fn.win_findbuf(buf) > 0 then
    return
  end
  -- Wipe (not just delete) so its entries also leave the jumplist
  pcall(vim.api.nvim_buf_delete, buf, {})
end, { desc = 'Jump back to previous buffer and close this one' })

return M
