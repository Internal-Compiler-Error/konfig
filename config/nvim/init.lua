-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.opt.relativenumber = true
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

if vim.env.SSH_TTY then
  -- Over SSH there's no local X11/Wayland display for xclip/wl-copy to
  -- reach, so route yanks through the terminal via OSC 52 instead. Requires
  -- an OSC 52-aware terminal (kitty, wezterm, iTerm2, etc.).
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste '+',
      ['*'] = require('vim.ui.clipboard.osc52').paste '*',
    },
  }
end
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.linebreak = true

-- Run per directory configs
vim.opt.exrc = true

vim.diagnostic.config { underline = true, virtual_text = true }
vim.keymap.set('n', '<leader>td', function()
  local visible = vim.diagnostic.config().virtual_text
  vim.diagnostic.config { underline = not visible, virtual_text = not visible }
end, { desc = '[D]ianostic' })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Previous [D]iagnostic' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Next [D]iagnostic' })

vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Previous [E]rror' })

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Next [E]rror' })

vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = '[E]rror messages' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = '[Q]uickfixes' })

vim.keymap.set('v', 'y', 'y`>', { desc = 'Yank and go to last line of the select' })
vim.keymap.set('n', '<C-L>', '`>', { desc = 'go to register >' })

vim.api.nvim_create_user_command('Cab', 'bufdo bd', { desc = 'Close all buffers' })
vim.api.nvim_create_user_command('TrimEnds', [[%s/\s\+$//g]], { desc = 'Trim all whitespaces at the end' })

-- neovide specific
if vim.g.neovide then
  local fontsize = 20

  -- hardcoded to Berkeley Mono for now
  vim.keymap.set('n', '<C-=>', function()
    fontsize = fontsize + 1
    vim.opt.guifont = 'Berkeley Mono:h' .. fontsize
  end, { silent = true, desc = 'Increase font size' })

  vim.keymap.set('n', '<C-->', function()
    fontsize = fontsize - 1
    vim.opt.guifont = 'Berkeley Mono:h' .. fontsize
  end, { silent = true, desc = 'Decrease font size' })

  -- vim.api.nvim_set_hl(0, "@comment", {
  -- 	font = "Noto Sans:h12", -- Replace with your desired font and size
  -- })
end

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zv', {})
  end,
})

-- treat .ormdb and .tap file as javascript
vim.filetype.add {
  extension = {
    ormdb = 'javascript',
    tap = 'javascript',
    simple = 'javascript',
  },
}

-- syntax highlight for tiltfile
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { 'Tiltfile' },
  callback = function()
    vim.opt.filetype = 'starlark'
  end,
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Alt+[HJKL] to move literally
vim.keymap.set('n', '<A-h>', 'gh', { desc = 'Move left literally' })
vim.keymap.set('n', '<A-l>', 'gl', { desc = 'Move right literally' })
vim.keymap.set('n', '<A-j>', 'gj', { desc = 'Move down literally' })
vim.keymap.set('n', '<A-k>', 'gk', { desc = 'Move up literally' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Toggle buffer' })

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

-- paste from yank buffer instead of the default buffer
vim.keymap.set('n', 'gp', '"0p', { noremap = true, silent = true })
vim.keymap.set('n', 'gP', '"0P', { noremap = true, silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Run the current file with `node` on save (off by default); toggle with
-- <leader>tn, or run once on demand with <leader>cn.
vim.g.node_run_on_save = false

local node_run_buf = nil
local node_source_buf = nil
local function run_node_file()
  local file = vim.fn.expand '%:p'
  node_source_buf = vim.api.nvim_get_current_buf()
  local win

  if node_run_buf and vim.api.nvim_buf_is_valid(node_run_buf) then
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(w) == node_run_buf then
        win = w
        break
      end
    end
  end

  local prev_win = vim.api.nvim_get_current_win()
  if win then
    -- Reuse the existing output window.
    vim.api.nvim_set_current_win(win)
  else
    -- Open a new window at the bottom for the output.
    vim.cmd 'botright 15split'
  end
  -- `:split`/reusing the window still shows whatever buffer was already
  -- there (the file we just saved, on first run). `enew` swaps in a fresh
  -- empty buffer so jobstart below turns *that* into the terminal instead
  -- of hijacking the file's buffer (which would also show up in the file's
  -- own window, since a buffer can be displayed in more than one window).
  vim.cmd 'enew'

  node_run_buf = vim.api.nvim_get_current_buf()
  -- jobstart(..., { term = true }) is termopen()'s replacement (deprecated
  -- since 0.10): it attaches the job to the current buffer as a terminal.
  vim.fn.jobstart({ 'node', file }, { term = true })
  vim.api.nvim_set_current_win(prev_win)
end

vim.keymap.set('n', '<leader>cn', run_node_file, { desc = 'Ru[n] file in node' })
vim.keymap.set('n', '<leader>tn', function()
  vim.g.node_run_on_save = not vim.g.node_run_on_save
  vim.notify('Run node on save ' .. (vim.g.node_run_on_save and 'enabled' or 'disabled'))
end, { desc = '[N]ode on save' })

-- Close the node-run terminal once the file that spawned it is closed.
vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
  callback = function(ev)
    if ev.buf == node_source_buf and node_run_buf and vim.api.nvim_buf_is_valid(node_run_buf) then
      vim.api.nvim_buf_delete(node_run_buf, { force = true })
      node_run_buf = nil
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.js', '*.mjs', '*.cjs' },
  callback = function()
    if vim.g.node_run_on_save then
      run_node_file()
    end
  end,
})

-- https://github.com/lewis6991/impatient.nvim
-- suupposedly this makes loading plugins faster
vim.loader.enable()

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive', -- Git commands, incl. `:Git blame` scroll-bound blame column

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },

  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 100,
      },
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
      local gitsigns = require 'gitsigns'

      vim.keymap.set('n', ']h', function()
        gitsigns.nav_hunk 'next'
      end, { desc = 'next git [H]unk' })

      vim.keymap.set('n', '[h', function()
        gitsigns.nav_hunk 'next'
      end, { desc = 'prev git [H]unk' })

      vim.keymap.set('n', '<leader>gb', function()
        gitsigns.blame_line {
          full = true,
          ignore_whitespace = true,
        }
      end, { desc = '[B]lame full' })

      vim.keymap.set('n', '<leader>gp', function()
        gitsigns.preview_hunk()
      end, { desc = '[P]review hunk' })

      vim.keymap.set('n', '<leader>tg', function()
        gitsigns.toggle_current_line_blame()
      end, { desc = 'toggle [G]it blame line' })

      -- Not a toggle: opens a scroll-bound blame column; press `gq` inside it to close.
      vim.keymap.set('n', '<leader>tG', '<cmd>Git blame<CR>', { desc = 'open [G]it blame column (fugitive)' })

      -- vim.keymap.set("n", "<leader>gb", function()
      -- 	gitsigns.blame_line({
      -- 		ignore_whitespace = true,
      -- 	})
      -- end, { desc = "[B]lame" })
    end,
  },

  -- NOTE: Plugins can also be configured to run lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>g', group = '[G]it' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>l', group = '[L]ist' },
      }
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    tag = 'v0.2.2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'debugloop/telescope-undo.nvim' },
      { 'nvim-telescope/telescope-dap.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          -- mappings = {
          --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          -- },
          -- vimgrep_arguments = {
          -- 	"rg",
          -- 	"--follow",
          -- 	"--hidden",
          -- 	"--smart-case",
          -- },
          -- Keep more than the default 1 picker cached so each searcher
          -- below can resume its own state independently.
          cache_picker = { num_pickers = 20 },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<C-y>'] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          undo = {
            side_by_side = true,
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'undo')
      pcall(require('telescope').load_extension, 'dap')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      local telescope_state = require 'telescope.state'

      -- Each searcher below is tagged with a fixed `prompt_title`. Telescope
      -- caches up to `cache_picker.num_pickers` past pickers (see setup()
      -- above), so on the next invocation we look through that cache for a
      -- picker with the same title and resume it (same as <leader>sr) instead
      -- of starting fresh. Every searcher therefore keeps its own state,
      -- rather than only the single most recent one.
      local function resumable(fn, opts)
        opts = opts or {}
        return function()
          local cached_pickers = telescope_state.get_global_key 'cached_pickers' or {}
          for i, picker in ipairs(cached_pickers) do
            if picker.prompt_title == opts.prompt_title then
              builtin.resume { cache_index = i }
              return
            end
          end
          fn(opts)
        end
      end

      vim.keymap.set('n', '<leader>sh', resumable(builtin.help_tags, { prompt_title = 'Help' }), { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', resumable(builtin.keymaps, { prompt_title = 'Key Maps' }), { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>st', resumable(builtin.builtin, { prompt_title = 'Builtin Pickers' }), { desc = '[S]earch [T]elescope pickers' })
      vim.keymap.set('n', '<leader>sD', resumable(builtin.diagnostics, { prompt_title = 'Workspace Diagnostics' }), { desc = '[S]earch [D]iagnostics' })
      -- <leader>sr resumes whichever picker (telescope or fff) was opened last,
      -- detected via the filetype each one sets on its prompt buffer.
      local last_picker = 'telescope'
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('last-picker', { clear = true }),
        pattern = { 'TelescopePrompt', 'fff_input' },
        callback = function(ev)
          last_picker = ev.match == 'fff_input' and 'fff' or 'telescope'
        end,
      })
      vim.keymap.set('n', '<leader>sr', function()
        if last_picker == 'fff' and require('fff').resume() then
          return
        end
        builtin.resume()
      end, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', resumable(builtin.oldfiles, { prompt_title = 'Oldfiles' }), { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sb', resumable(builtin.buffers, { prompt_title = 'Buffers' }), { desc = '[S]earch existing buffers' })
      vim.keymap.set('n', '<leader>su', '<cmd>Telescope undo<CR>', { desc = '[S]earch [U]ndo history' })

      -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set(
      --   'n',
      --   '<leader>/',
      --   resumable(function(opts)
      --     -- You can pass additional configuration to telescope to change theme, layout, etc.
      --     builtin.current_buffer_fuzzy_find(vim.tbl_extend(
      --       'force',
      --       require('telescope.themes').get_dropdown {
      --         winblend = 10,
      --         previewer = false,
      --       },
      --       opts
      --     ))
      --   end, { prompt_title = 'Current Buffer Fuzzy' }),
      --   { desc = '[/] Fuzzily search in current buffer' }
      -- )
      vim.keymap.set( 'n', '<leader>/', builtin.current_buffer_fuzzy_find , {
        desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        resumable(function(opts)
          builtin.live_grep(vim.tbl_extend('force', { grep_open_files = true }, opts))
        end, { prompt_title = 'Live Grep in Open Files' }),
        { desc = '[S]earch [/] in Open Files' }
      )

    end,
  },

  { -- Fast file finder (replaces telescope find_files / rg --files)
    'dmtrKovalenko/fff',
    dependencies = {
      { -- Image rendering (kitty graphics protocol); used by fff's image preview
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
          image = { enabled = true },
        },
      },
    },
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require('fff.download').download_or_build_binary()
    end,
    lazy = false, -- the plugin lazy-initialises itself
    keys = {
      -- `resume = true` reopens the last picker of that kind with its query, or a fresh one
      { '<leader>sf', function() require('fff').find_files { resume = true } end, desc = '[S]earch [F]iles' },
      { '<leader>sg', function() require('fff').live_grep { resume = true } end, desc = '[S]earch by [G]rep' },
      { '<leader>sw', function() require('fff').live_grep_under_cursor() end, mode = { 'n', 'x' }, desc = '[S]earch current [W]ord' },
      { '<leader>sn', function() require('fff').find_files_in_dir(vim.fn.stdpath 'config') end, desc = '[S]earch [N]eovim files' },
    },
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      {
        'folke/lazydev.nvim',
        opts = {
          library = {
            plugins = { 'nvim-dap-ui' },
          },
        },
      },
    },
    config = function()
      local enable_inlay = false
      vim.lsp.inlay_hint.enable(enable_inlay)
      vim.keymap.set('n', '<leader>th', function()
        enable_inlay = not enable_inlay
        vim.lsp.inlay_hint.enable(enable_inlay)
      end, { desc = 'inlay [H]ints' })

      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc. The difference between this and workspace symbol is
          --  workspace symbol won't include stuff like private functions
          map('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- map('<leader>sf', require('telescope.builtin').lsp_definitions, '[D]ocument [F]unctions')
          --

          map('<leader>sl', require('telescope.builtin').treesitter, '[D]ocument [L]exical Symbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch [W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- use ufo as the folding provider
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- See `:help lspconfig-all` for a list of all the pre-configured LSPs

        rust_analyzer = {
          settings = {
            highlight = { disable = true, enable = false },
          },
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- linters
    'mfussenegger/nvim-lint',
    lazy = false,
    opts = {},
    config = function(_self, _opts)
      local lint = require 'lint'
      lint.linter_by_ft = {
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
        callback = function()
          lint.try_lint 'eslint_d'
        end,
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.opt.formatprg = "v:lua.require'conform'.formatprg()"

      -- Format on save is off by default; toggle with <leader>tf, or format
      -- on demand with <leader>cf.
      vim.g.disable_autoformat = true
      vim.keymap.set('n', '<leader>tf', function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Format on save ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
      end, { desc = '[F]ormat on save' })
      vim.keymap.set('n', '<leader>cf', function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end, { desc = '[F]ormat buffer' })

      return {
        notify_on_error = true,
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat then
            return
          end

          if disable_filetypes[vim.bo[bufnr].filetype] then
            return false
          end

          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          rust = { 'rustfmt', lsp_format = 'fallback' },
          -- Conform can also run multiple formatters sequentially
          -- python = { "isort", "black" },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          typescript = { 'prettierd', 'prettier', stop_after_first = true },
          typescriptreact = { 'prettier', stop_after_first = true },
          c = { 'clang-format' },
          cpp = { 'clang-format' },
        },
      }
    end,
  },

  { -- restore sessions
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
    },
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>wr', '<cmd>AutoSession search<CR>', desc = 'Session search' },
      { '<leader>ws', '<cmd>AutoSession save<CR>', desc = 'Save session' },
      { '<leader>wa', '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    },
    config = function()
      vim.opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
      require('auto-session').setup {
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        session_lens = {
          -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
          load_on_setup = true,
          picker_opts = { border = true },
          previewer = 'summary',
        },
      }

      vim.api.nvim_create_user_command('FixSession', function()
        vim.api.nvim_exec2(
          [[
            SessionDelete
            SessionSave
          ]],
          {}
        )
      end, {})
    end,
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'rcarriga/cmp-dap',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        -- Same as the default, but also allow the dap REPL (a prompt buffer)
        enabled = function()
          if vim.fn.reg_recording() ~= '' or vim.fn.reg_executing() ~= '' then
            return false
          end
          return vim.api.nvim_get_option_value('buftype', { buf = 0 }) ~= 'prompt' or require('cmp_dap').is_dap_buffer()
        end,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
            -- vim.snippet.expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
          --
          -- an expansion basically means the site of a function argument
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'cmp_nvim_lsp_document_symbol' },
          -- { name = "copilot" },
        }, {
          { name = 'buffer' },
        }),
      }

      -- insert a stupid ( after the function completion
      local pair_cmp = require 'nvim-autopairs.completion.cmp'
      cmp.event:on('conform_done', function()
        pair_cmp.on_confirm_done()
      end)

      -- Completions from the debug adapter (evaluated in the current frame) in the dap REPL and dap-ui
      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = {
          { name = 'dap' },
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = true,
      merge_keywords = true,
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
  },

  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.autopairs',

  -- make resolving diff conflicts less painful
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = '[G]it [D]iff view (also shows merge conflicts)' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = '[G]it branch [H]istory' },
      { '<leader>gq', '<cmd>DiffviewClose<CR>', desc = '[G]it diff view [Q]uit' },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = {
          -- OURS | BASE | THEIRS on top, MERGED result below
          layout = 'diff4_mixed',
          disable_diagnostics = true,
        },
      },
    },
  },

  -- { "danilamihailov/beacon.nvim" },

  -- { 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git' },
  {
    'stevearc/oil.nvim',
    opts = {},
  },

  {
    'folke/zen-mode.nvim',
    opts = {},
  },

  -- sticky scroll
  { 'nvim-treesitter/nvim-treesitter-context' },

  { -- source tree
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      window = {
        position = 'bottom',
        enable_git_status = true,
        enable_diagnostics = true,
        source_selector = {
          winbar = true,
          statusline = true,
        },
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)

      vim.keymap.set('n', '<leader>tt', function()
        vim.cmd 'Neotree toggle source=last reveal_force_cwd=true'
      end, { desc = 'neo-[t]ree' })

      -- vim.keymap.set('n', '<leader>ot', function()
      --   vim.cmd 'Neotree toggle reveal_force_cwd=true'
      -- end, { desc = '[O]pen neo-tree' })
    end,
  },

  -- for better code folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('ufo').setup(opts)
      vim.opt.foldcolumn = '1' -- '0' is not bad
      vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
  -- {
  -- 	"zbirenbaum/copilot-cmp",
  -- 	dependencies = {
  -- 		"zbirenbaum/copilot.lua",
  -- 		opts = {},
  -- 	},
  -- 	opts = {},
  -- },
  --
  'stevearc/dressing.nvim',
  { import = 'custom.themes' },
  -- avante, AI integration
  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   lazy = false,
  --   version = false, -- set this if you want to always pull the latest change
  --   opts = {
  --     -- add any opts here
  --   },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- build = 'make',
  -- -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter',
  --   'stevearc/dressing.nvim',
  --   'nvim-lua/plenary.nvim',
  --   'MunifTanjim/nui.nvim',
  --   --- The below dependencies are optional,
  --   -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --   'zbirenbaum/copilot.lua', -- for providers='copilot'
  --   {
  --     -- support for image pasting
  --     'HakonHarnes/img-clip.nvim',
  --     event = 'VeryLazy',
  --     opts = {
  --       -- recommended settings
  --       default = {
  --         embed_image_as_base64 = false,
  --         prompt_for_file_name = false,
  --         drag_and_drop = {
  --           insert_mode = true,
  --         },
  --         -- required for Windows users
  --         use_absolute_path = true,
  --       },
  --     },
  --   },
  -- {
  --   -- Make sure to set this up properly if you have lazy=true
  --   'MeanderingProgrammer/render-markdown.nvim',
  --   opts = {
  --     file_types = { 'markdown', 'Avante' },
  --   },
  --   ft = { 'markdown', 'Avante' },
  -- },
  --   },
  -- },
}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- pick a theme at random
math.randomseed(os.time())
local themes = {
  -- "gruvbox",
  -- 'gruvbox-material',
  'gruvbox-baby',
  -- "rose-pine",
  -- "everforest",
  -- "tokyonight",
  -- "kanagawa",
  -- "catppuccin",
}
local pick = themes[math.random(#themes)]
vim.cmd.colorscheme(pick)

-- Prefer the terminal's own light/dark setting. Nvim already queries this via
-- an OSC 11 request on startup and listens for the terminal's answer (see
-- `TermResponse` in $VIMRUNTIME/lua/vim/_defaults.lua) — kitty answers it, and
-- since it's a terminal escape sequence this works transparently over SSH too.
-- IMPORTANT: we must never assign `vim.opt.background`/`vim.o.background`
-- ourselves before that response can arrive, since Nvim treats any explicit
-- set as "the user decided" and permanently deletes its own auto-detect
-- listener at VimEnter. So the fallback below only ever fires if the OSC 11
-- query goes unanswered (e.g. a terminal that doesn't support it).
vim.g.day_start_hour = vim.g.day_start_hour or 7
vim.g.night_start_hour = vim.g.night_start_hour or 19
local osc11_available = false

local function refresh_colorscheme()
  vim.cmd.colorscheme(pick)
  require('fidget').notify('Color theme: ' .. pick .. ' (' .. vim.o.background .. ')', vim.log.levels.INFO)
end

local function apply_time_based_background()
  if osc11_available then
    return
  end
  local hour = tonumber(os.date '%H')
  local is_day = hour >= vim.g.day_start_hour and hour < vim.g.night_start_hour
  vim.opt.background = 'dark'
end

vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = refresh_colorscheme,
})

vim.api.nvim_create_autocmd('TermResponse', {
  callback = function(args)
    if args.data.sequence:match '^\027%]11;rgba?:' then
      osc11_available = true
    end
  end,
})

-- Give the OSC 11 round-trip a moment to resolve before deciding it's not
-- coming; only then does the time-of-day fallback take over.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.defer_fn(apply_time_based_background, 500)
  end,
})

-- Nvim's native OSC 11 query only fires once at startup, so a long-running
-- session wouldn't otherwise notice the terminal's background changing later
-- (e.g. the OS flips appearance at sunset) unless the terminal proactively
-- re-announces it, which isn't guaranteed. So periodically re-send the query
-- ourselves too: a real answer updates 'background' via Nvim's own listener
-- (a genuine response always takes priority, see `force` above); the
-- time-of-day guess only runs if the terminal still hasn't answered at all.
local background_timer = assert(vim.uv.new_timer())
background_timer:start(
  15 * 60 * 1000,
  15 * 60 * 1000,
  vim.schedule_wrap(function()
    io.stdout:write '\027]11;?\007'
    vim.defer_fn(apply_time_based_background, 500)
  end)
)

-- vim: ts=2 sts=2 sw=2 et
