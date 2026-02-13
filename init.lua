-- Modern Neovim config (Lua-first), updated from an older init.vim.
-- LARGELY AI-GENERATED

-- ============================================================
-- Rough guideline of packages to install...
-- ============================================================
-- sudo apt update
-- sudo apt install -y \
--   git curl unzip ca-certificates \
--   ripgrep fd-find \
--   python3 python3-venv python3-pip \
--   clangd clang-tidy \
--   shfmt
--
-- # Install node and go: ...
--
-- npm i @fsouza/prettierd
-- npm i -D vscode-langservers-extracted
-- go install github.com/sqls-server/sqls@latest
--
-- python3 -m venv ~/.virtualenvs/nvim
-- ~/.virtualenvs/nvim/bin/python -m pip install --upgrade pip
-- ~/.virtualenvs/nvim/bin/python -m pip install --upgrade black isort
-- ~/.virtualenvs/nvim/bin/python -m pip install --upgrade pynvim

----------------------------------------------------------------------
-- Neovim configuration (Lua)
--
-- Design goals:
--  • Replace old Vimscript init.vim with modern Neovim APIs
--  • Use built-in LSP instead of external linters/completion engines
--  • Automatically use project-local tooling (node_modules, venvs)
--  • Provide a "polyglot workstation":
--      SvelteKit + TypeScript + Docker + SQL + Python + C++
--
-- Major subsystems in this file:
-- 1. Plugin manager bootstrap (lazy.nvim)
-- 2. Editor behavior (options)
-- 3. Keybindings and QoL behavior (ported from original Vim config)
-- 4. Completion (nvim-cmp)
-- 5. LSP configuration (mason + vim.lsp)
-- 6. Formatter integration (conform.nvim)
-- 7. Automatic project environment detection
--
-- IMPORTANT:
-- This config assumes Neovim ≥ 0.11.
-- Older versions will fail because vim.lsp.config() is used.
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Pre-plugin globals (must be set before plugin loads)
----------------------------------------------------------------------
-- Yoink + Cutlass coexistence: include delete/cut ops in Yoink history
vim.g.yoinkIncludeDeleteOperations = 1

-- We use BOTH:
--   vim-cutlass  → changes delete/cut behavior (doesn't clobber default yank)
--   vim-yoink    → yank history browser
--
-- Without this setting, "cut" operations (d/x) would NOT appear in
-- yank history. That makes undoing deletes painful.
-- So we explicitly include delete operations in yoink history.

-- === Neovim Python provider auto-detection ===
-- Put this near the top of your init.lua (before plugins load)

local uv = vim.loop
local fn = vim.fn

-- Order matters: first valid venv wins
local candidate_envs = {
  "dev",
  "nvim",
  "neovim",
  "py3",
  "main",
  "default",
}

local function is_executable(path)
  return fn.executable(path) == 1
end

local function file_exists(path)
  local stat = uv.fs_stat(path)
  return stat and stat.type or false
end

local function is_valid_venv(venv_path)
  local python = venv_path .. "/bin/python"
  local cfg = venv_path .. "/pyvenv.cfg"

  -- must look like a venv
  if not (file_exists(cfg) and is_executable(python)) then
    return false
  end

  -- must have pynvim installed
  local cmd = string.format("%s -c 'import pynvim'", python)
  local result = os.execute(cmd)

  return result == 0
end

for _, name in ipairs(candidate_envs) do
  local path = fn.expand("~/.virtualenvs/" .. name)

  if file_exists(path) and is_valid_venv(path) then
    vim.g.python3_host_prog = path .. "/bin/python"
    vim.notify("Neovim Python provider: " .. name, vim.log.levels.INFO)
    break
  end
end

----------------------------------------------------------------------
-- Plugin manager bootstrap
--
-- lazy.nvim automatically installs itself the first time Neovim runs.
-- This eliminates the old "install vim-plug manually" step.
--
-- Plugins are then declared declaratively below.
----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

----------------------------------------------------------------------
-- Plugins
----------------------------------------------------------------------
require("lazy").setup({
  -- Colorschemes (kept from your old set)
  -- We keep several available so we can quickly switch during long coding
  -- sessions. Catppuccin is default because it has excellent Treesitter
  -- and LSP semantic token support.
  { "catppuccin/nvim",                   name = "catppuccin", priority = 1000 },
  { "dracula/vim",                       name = "dracula" },
  { "bluz71/vim-moonfly-colors" },
  { "bluz71/vim-nightfly-guicolors" },
  { "jaredgorski/spacecamp" },
  { "tomasr/molokai" },
  { "rhysd/vim-color-spring-night" },
  { "flrnprz/plastic.vim" },
  { "larsbs/vimterial_dark" },
  { "erichdongubler/vim-sublime-monokai" },
  { "euclio/vim-nocturne" },

  -- QoL
  { "tpope/vim-eunuch" },
  { "tpope/vim-repeat" },
  { "tpope/vim-unimpaired" },

  -- Telescope: modern fuzzy finder and search UI
  -- Replaces:
  --   :grep
  --   fzf.vim
  --   file browser plugins
  --
  -- Uses ripgrep and fd under the hood (external tools installed via apt)
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
      },
    },
  },

  -- Text manipulation helpers
  -- sideways.vim → swap function arguments
  -- cutlass      → safe delete (doesn't overwrite default register)
  -- yoink        → yank history
  -- subversive   → powerful substitute operator
  { "drzel/vim-split-line" },
  { "AndrewRadev/sideways.vim" },
  { "svermeulen/vim-cutlass" },
  { "svermeulen/vim-yoink" },
  { "svermeulen/vim-subversive" },

  -- Statusline
  { "nvim-lualine/lualine.nvim" },

  -- UI
  { "mbbill/undotree" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = { width = 28, side = "left" },
      filters = { dotfiles = false },
      git = { enable = true },
    },
  },
  { "nvim-tree/nvim-web-devicons" },

  -- Git
  { "lewis6991/gitsigns.nvim",          opts = {} },

  -- Commenting
  { "numToStr/Comment.nvim",            opts = {} },

  -- Built-in LSP stack
  -- We do NOT use ALE, coc.nvim, or deoplete.
  -- Modern Neovim provides:
  --   LSP diagnostics
  --   code actions
  --   rename
  --   goto definition
  --   completion
  -- natively.
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim",          opts = {} },
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Formatting
  { "stevearc/conform.nvim" },
}, {
  ui = { border = "rounded" },
})

----------------------------------------------------------------------
-- Editor behavior (equivalent to old :set options in Vimscript)
--
-- These control:
--  • editing behavior
--  • search behavior
--  • UI behavior
--  • file handling
--
-- We intentionally keep this conservative: predictable > clever.
----------------------------------------------------------------------

local opt = vim.opt

opt.timeoutlen = 1000
opt.ttimeoutlen = 10
opt.updatetime = 500
-- Time before CursorHold triggers.
-- Affects LSP diagnostics refresh speed.
opt.history = 500
opt.autoread = true

opt.encoding = "utf-8"
opt.fileformats = { "unix", "dos", "mac" }

-- Use modern state dirs instead of ~/.vim/*
do
  local state = vim.fn.stdpath("state")
  local backup = state .. "/backup"
  local swp = state .. "/swap"
  local undo = state .. "/undo"
  vim.fn.mkdir(backup, "p")
  vim.fn.mkdir(swp, "p")
  vim.fn.mkdir(undo, "p")
  opt.backupdir = { backup, "." }
  opt.directory = { swp, "." }
  opt.undodir = undo
  opt.undofile = true
end

opt.swapfile = true
opt.backup = false
opt.writebackup = false

opt.linebreak = true
opt.list = false
opt.listchars = { tab = ">-", trail = "~", extends = ">", precedes = "<" }
opt.emoji = false

-- Indentation
opt.tabstop = 8
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smarttab = true
opt.expandtab = true
opt.autoindent = true
opt.joinspaces = false

-- Searching
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.magic = true
opt.infercase = true
opt.inccommand = "nosplit"
-- Shows live preview of :substitute.

-- UI
opt.backspace = { "eol", "start", "indent" }
opt.laststatus = 2
opt.scrolloff = 0
opt.hidden = true
-- Allows switching buffers without saving (essential for LSP workflows).
opt.showcmd = true
opt.ruler = true
opt.wrap = false
opt.wildmode = { "list:longest" }
opt.pumblend = 20
-- Makes completion popup slightly transparent.
opt.lazyredraw = true
opt.showmatch = true
opt.matchtime = 2
opt.splitbelow = true
opt.splitright = true
opt.synmaxcol = 300

opt.foldenable = true
opt.foldmethod = "indent"
opt.foldlevelstart = 99

opt.number = true
opt.relativenumber = true
opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"

-- netrw: kept minimal; we use nvim-tree instead
vim.g.netrw_liststyle = 3
vim.g.loaded_matchparen = 1

-- ============================================================
-- Colorscheme
-- ============================================================
vim.cmd.colorscheme("catppuccin")

-- ============================================================
-- Autocommands + Filetype local options
-- ============================================================
local aug = vim.api.nvim_create_augroup("MichaelAutocmds", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = aug,
  callback = function()
    vim.cmd("wincmd =")
  end,
})

local function ft(ftname, settings)
  vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    pattern = ftname,
    callback = function()
      for k, v in pairs(settings) do
        vim.opt_local[k] = v
      end
    end,
  })
end

----------------------------------------------------------------------
-- Filetype-specific indentation rules
--
-- These intentionally override the global indentation settings.
-- Example:
--   Python uses 4 spaces
--   JSON uses 2 spaces
--   C++ kept narrow to avoid wide diffs
----------------------------------------------------------------------
ft("python", { softtabstop = 4, shiftwidth = 4, expandtab = true, colorcolumn = "88" })
ft("c", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("cpp", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("cmake", { softtabstop = 4, shiftwidth = 4, expandtab = true, colorcolumn = "100" })
ft("json", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "80" })
ft("sh", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "80" })
ft("bash", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("vim", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100", textwidth = 100 })
ft("lua", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("zsh", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("yaml", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("dockerfile", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })

ft("svelte", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("typescript", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("javascript", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("typescriptreact", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("javascriptreact", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })

ft("html", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("css", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("scss", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })

ft("jsonc", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "80" })
ft("sql", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("markdown", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })
ft("toml", { softtabstop = 2, shiftwidth = 2, expandtab = true, colorcolumn = "100" })

-- ============================================================
-- Helpers (ported Vimscript behaviors)
-- ============================================================
-- Smart Home key:
-- First press → first non-whitespace
-- Second press → true column 0
-- (matches behavior of many IDEs)
local function line_home()
  local x = vim.fn.col(".")
  vim.cmd.normal({ args = { "^" }, bang = true })
  if x == vim.fn.col(".") then
    vim.cmd.normal({ args = { "0" }, bang = true })
  end
end

-- Toggle preferred text wrapping widths
-- Useful when editing:
--  80 → commit messages
--  88 → Python (Black)
-- 120 → code
--  0 → disabled
local function cycle_textwidth()
  local tw = vim.o.textwidth
  local next_tw
  if tw == 0 then
    next_tw = 80
  elseif tw == 80 then
    next_tw = 88
  elseif tw == 88 then
    next_tw = 120
  elseif tw == 120 then
    next_tw = 0
  else
    next_tw = 0
  end
  vim.o.textwidth = next_tw
  vim.o.colorcolumn = (next_tw == 0) and "" or tostring(next_tw)
  vim.notify(("Set textwidth and colorcolumn to %d"):format(next_tw))
end

local function cycle_numbering()
  local n, r = vim.wo.number, vim.wo.relativenumber
  if not n and not r then
    vim.wo.number = true
  elseif n and not r then
    vim.wo.relativenumber = true
  elseif n and r then
    vim.wo.number = false
  elseif (not n) and r then
    vim.wo.relativenumber = false
  end
  vim.notify(("Set number=%s, relativenumber=%s"):format(tostring(vim.wo.number), tostring(vim.wo.relativenumber)))
end

-- Clears every register.
-- Useful after large pastes or macros.
-- Command: :DeleteRegisters
local function delete_all_registers()
  local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"'
  for r in regs:gmatch(".") do
    vim.fn.setreg(r, {})
  end
end
vim.api.nvim_create_user_command("DeleteRegisters", delete_all_registers, {})

local function visual_star_search(cmdtype)
  local temp = vim.fn.getreg('"')
  vim.cmd.normal({ args = { "gvy" }, bang = true })
  local text = vim.fn.getreg('"')
  text = vim.fn.escape(text, cmdtype .. "\\*")
  text = text:gsub("\n", "\\n"):gsub("%[", "\\["):gsub("~", "\\~")
  vim.fn.setreg("/", text)
  vim.fn.setreg('"', temp)
end

----------------------------------------------------------------------
-- Keybindings
--
-- Philosophy:
--  • Keep core Vim motions intact
--  • Fix historically annoying defaults
--  • Add IDE-like navigation where helpful
----------------------------------------------------------------------
vim.g.mapleader = "\\"
local map = vim.keymap.set
local nore_silent = { noremap = true, silent = true }

map("i", "§", "<Esc>", nore_silent)

map({ "n", "v" }, "K", "<Nop>", nore_silent) -- LSP rebinds hover
map("n", "Q", "<Nop>", nore_silent)
map("n", "ZZ", "<Nop>", nore_silent)
map("n", "ZQ", "<Nop>", nore_silent)

map("v", ".", ":normal .<CR>", nore_silent)
map("n", "c*", "*Ncgn", nore_silent)

map("x", "*", function()
  visual_star_search("/")
end, nore_silent)
map("x", "#", function()
  visual_star_search("?")
end, nore_silent)

map({ "n", "x" }, "j", "gj", { noremap = true })
map({ "n", "x" }, "k", "gk", { noremap = true })

map({ "n", "x" }, "<Up>", "5k", nore_silent)
map({ "n", "x" }, "<Down>", "5j", nore_silent)

map("n", "}", function()
  local c = vim.v.count1
  vim.cmd(("keepjumps normal! %d}"):format(c))
end, nore_silent)
map("n", "{", function()
  local c = vim.v.count1
  vim.cmd(("keepjumps normal! %d{"):format(c))
end, nore_silent)

map({ "n", "v" }, "0", line_home, nore_silent)
map("i", "<Home>", function()
  line_home()
end, nore_silent)

-- -------------------------------------------------------------------
-- Cutlass "move" operator mappings
-- Restores your old init.vim behavior:
--   m  = cut/move (delete into the "black hole", then be ready to paste)
--   mm = move current line
--   M  = move to end of line (cut to EOL)
--
-- These are the standard cutlass mappings (per project instructions).
-- -------------------------------------------------------------------
map("n", "m", "d", { noremap = true })
map("x", "m", "d", { noremap = true })

map("n", "mm", "dd", { noremap = true })
map("n", "M", "D", { noremap = true })

-- Cutlass: keep access to Vim's native mark command
map("n", "gm", "m", { noremap = true })

-- -------------------------------------------------------------------
-- Yoink: restore old init.vim behavior (yank history + paste variants)
-- -------------------------------------------------------------------
vim.g.yoinkMoveCursorToEndOfPaste = 1

-- history swap
map("n", "[y", "<Plug>(YoinkPostPasteSwapBack)", {})
map("n", "]y", "<Plug>(YoinkPostPasteSwapForward)", {})

-- replace default paste with yoink paste
map("n", "p", "<Plug>(YoinkPaste_p)", {})
map("n", "P", "<Plug>(YoinkPaste_P)", {})
map("n", "gp", "<Plug>(YoinkPaste_gp)", {})
map("n", "gP", "<Plug>(YoinkPaste_gP)", {})

-- preserve cursor position when yanking (matches old config)
map("n", "y", "<Plug>(YoinkYankPreserveCursorPosition)", {})
map("x", "y", "<Plug>(YoinkYankPreserveCursorPosition)", {})

-- toggle paste formatting (this mapping existed in your old file;
-- the exact key on the left is hard to see in the raw dump, so I’m using a sane one)
map("n", "<Leader>yp", "<Plug>(YoinkPostPasteToggleFormat)", { silent = true })

-- Sideways (argument swapping)
map("n", "g<", ":SidewaysLeft<CR>", { noremap = true, silent = true })
map("n", "g>", ":SidewaysRight<CR>", { noremap = true, silent = true })

-- -------------------------------------------------------------------
-- Subversive: restore old init.vim substitute workflow
-- -------------------------------------------------------------------
map("n", "s", "<Plug>(SubversiveSubstitute)", {})
map("n", "ss", "<Plug>(SubversiveSubstituteLine)", {})
map("n", "S", "<Plug>(SubversiveSubstituteToEndOfLine)", {})

-- SplitLine: pick a stable mapping that doesn't fight Subversive
map("n", "<Leader>S", ":SplitLine<CR>", { noremap = true, silent = true })

-- Enter clears search highlighting (instead of :nohlsearch)
-- but preserves ability to search again.
map("n", "<CR>", function()
  if vim.o.hlsearch and vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
  else
    vim.o.hlsearch = true
  end
end, nore_silent)

map("i", "<C-w>", "<C-g>u<C-w>", nore_silent)
map("i", "<C-u>", "<C-g>u<C-u>", nore_silent)

map("x", "<", "<gv", nore_silent)
map("x", ">", ">gv", nore_silent)

map("n", "<S-h>", ":bprevious<CR>", nore_silent)
map("n", "<S-l>", ":bnext<CR>", nore_silent)
map("n", "<Leader>\\", ":b#<CR>", nore_silent)

map("n", "<Leader>wc", ":close<CR>", nore_silent)

map("n", "|", function()
  if vim.v.count == 0 then
    return "v"
  end
  return (":normal! 0" .. vim.v.count .. "|<CR>")
end, { expr = true, noremap = true, silent = true })

map("n", "_", function()
  if vim.v.count == 0 then
    return "s"
  end
  return (":normal! " .. vim.v.count .. "_<CR>")
end, { expr = true, noremap = true, silent = true })

map("n", "<Leader>qk", ":cprevious<CR>", nore_silent)
map("n", "<Leader>qj", ":cnext<CR>", nore_silent)
map("n", "<Leader>qh", ":cpfile<CR>", nore_silent)
map("n", "<Leader>ql", ":cnfile<CR>", nore_silent)

map("n", "<F1>", cycle_numbering, nore_silent)
map("n", "<F2>", cycle_textwidth, nore_silent)
map("n", "<F3>", ":set list!<CR>:set list?<CR>", nore_silent)
map("n", "<F4>", ":set wrap!<CR>:set wrap?<CR>", nore_silent)
map("n", "<F5>", ":setlocal paste!<CR>:setlocal paste?<CR>", nore_silent)
map("n", "<F12>", ":source $MYVIMRC<CR>", nore_silent)

map("n", "vc", ":edit $MYVIMRC<CR>", nore_silent)
-- map("n", "vv", ":source $MYVIMRC<CR>", nore_silent)

map("n", "<Leader>di", ":DevInfo<CR>", nore_silent)

map("c", "%%", function()
  if vim.fn.getcmdtype() == ":" then
    return vim.fn.expand("%:h") .. "/"
  end
  return "%%"
end, { expr = true, noremap = true })

-- ============================================================
-- Plugin keymaps/config
-- ============================================================
do
  local builtin = require("telescope.builtin")

  -- Fuzzy search shortcuts
  -- ff → files
  -- fg → full text search (ripgrep)
  -- fb → buffers
  -- fh → recent files
  map("n", "<Leader>ff", builtin.find_files, nore_silent)
  map("n", "<Leader>fg", builtin.live_grep, nore_silent)
  map("n", "<Leader>fb", builtin.buffers, nore_silent)
  map("n", "<Leader>fh", builtin.oldfiles, nore_silent)
  map("n", "<Leader>fl", builtin.current_buffer_fuzzy_find, nore_silent)
  map("n", "<Leader>fm", builtin.marks, nore_silent)
  map("n", "<Leader>fo", builtin.commands, nore_silent)
  map("n", "<Leader>f:", builtin.command_history, nore_silent)
  map("n", "<Leader>f/", builtin.search_history, nore_silent)
  map("n", "<Leader>fc", builtin.git_commits, nore_silent)
  map("n", "<Leader>fG", builtin.git_files, nore_silent)
  -- sibling files (directory of current file)
  map("n", "<Leader>fs", function()
    builtin.find_files({ cwd = vim.fn.expand("%:p:h") })
  end, nore_silent)

  -- Window picker
  -- Telescope does not provide a window selector.
  -- This creates an IDE-like "jump to split" chooser.
  local function pick_window()
    local wins = vim.api.nvim_list_wins()
    local items = {}
    for _, w in ipairs(wins) do
      local b = vim.api.nvim_win_get_buf(w)
      local name = vim.api.nvim_buf_get_name(b)
      if name == "" then
        name = "[No Name]"
      end
      local ft = vim.bo[b].filetype
      local line = vim.api.nvim_win_get_cursor(w)[1]
      table.insert(items, {
        win = w,
        label = string.format("win %d  buf %d  %s  (%s:%d)", w, b, name, ft, line),
      })
    end

    vim.ui.select(items, {
      prompt = "Go to window:",
      format_item = function(item)
        return item.label
      end,
    }, function(choice)
      if choice then
        vim.api.nvim_set_current_win(choice.win)
      end
    end)
  end

  map("n", "<Leader>fw", pick_window, nore_silent)
end

map("n", "<C-n>", ":NvimTreeToggle<CR>", nore_silent)
map("n", "<Leader>n", ":NvimTreeFindFile<CR>", nore_silent)

map("n", "<Leader>u", ":UndotreeToggle<CR>", nore_silent)

vim.g._indent_guides = true
map("n", "<Leader>i", function()
  vim.g._indent_guides = not vim.g._indent_guides
  if vim.g._indent_guides then
    require("ibl").setup({})
  else
    require("ibl").setup({ enabled = false })
  end
end, nore_silent)

----------------------------------------------------------------------
-- Autocompletion engine
--
-- nvim-cmp is ONLY a UI.
-- Actual intelligence comes from LSP servers.
--
-- Sources:
--  LSP     → language server suggestions
--  path    → filesystem paths
--  buffer  → words in current file
--  luasnip → snippets
----------------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" },
  }),
})

-- ============================================================
-- LSP helpers: roots, PATH injection, venv detection
-- ============================================================
local function path_exists(p)
  return p and (vim.uv.fs_stat(p) ~= nil)
end

local function is_win()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
end

local sep = is_win() and ";" or ":"

local function find_root_from_fname(fname)
  local root = vim.fs.root(fname, {
    "package.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    "package-lock.json",
    "pyproject.toml",
    "requirements.txt",
    "Pipfile",
    ".python-version",
    ".git",
  })
  return root or vim.fn.getcwd()
end

local function detect_python(root)
  -- Priority:
  --  1) $VIRTUAL_ENV (if nvim was launched from an activated venv)
  --  2) common venv dirs in project root: .venv, venv, env, .env
  local venv = vim.env.VIRTUAL_ENV
  if venv and venv ~= "" then
    local p = is_win() and vim.fs.joinpath(venv, "Scripts", "python.exe")
        or vim.fs.joinpath(venv, "bin", "python")
    if path_exists(p) then
      return p
    end
  end

  for _, d in ipairs({ ".venv", "venv", "env", ".env" }) do
    local p = is_win() and vim.fs.joinpath(root, d, "Scripts", "python.exe")
        or vim.fs.joinpath(root, d, "bin", "python")
    if path_exists(p) then
      return p
    end
  end

  return nil
end

local function prepend_path(dir)
  if not dir or dir == "" or not path_exists(dir) then
    return
  end
  local cur = vim.env.PATH or ""
  -- avoid duplicate-prepending
  if cur:find(dir, 1, true) then
    return
  end
  vim.env.PATH = dir .. sep .. cur
end

----------------------------------------------------------------------
-- Project environment detection
--
-- This is one of the most important parts of the config.
--
-- It makes Neovim behave like VSCode:
--
-- When you open a project:
--  • node_modules/.bin tools are preferred
--  • Python virtualenv tools are preferred
--
-- That means:
--   eslint, prettier, tsserver, black, isort
-- come from the PROJECT — not global system versions.
--
-- Without this, LSP and formatting frequently break.
----------------------------------------------------------------------
local function apply_project_paths(root)
  -- Prefer project-local Node tools (typescript-language-server, eslint, prettier, etc.)
  prepend_path(vim.fs.joinpath(root, "node_modules", ".bin"))

  -- Prefer project-local Python venv tools (python, black, isort, etc.)
  local py = detect_python(root)
  if py then
    prepend_path(vim.fs.dirname(py))
  end
end

----------------------------------------------------------------------
-- Language Server configurations
--
-- mason installs servers
-- vim.lsp.config configures them
--
-- Servers used:
--  ts_ls      → TypeScript / Node backend
--  svelte     → SvelteKit frontend
--  eslint     → linting
--  pyright    → Python analysis
--  clangd     → C/C++
--  sqls       → SQL validation
--  dockerls   → Dockerfiles
----------------------------------------------------------------------
require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    -- Frontend / SvelteKit
    "svelte",
    "ts_ls",
    "eslint",
    "tailwindcss",
    "html",
    "cssls",

    -- Config / docs
    "jsonls",
    "yamlls",
    "marksman",

    -- Backend / DB
    "sqls",

    -- Infra
    "dockerls",
    "docker_compose_language_service",
    "bashls",

    -- General programming languages (restored)
    "pyright",
    "clangd",

    -- Neovim config
    "lua_ls",
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(_, bufnr)
  local function bmap(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true })
  end
  vim.keymap.set({ "n", "v" }, "K", vim.lsp.buf.hover, { buffer = bufnr, silent = true, noremap = true })
  bmap("n", "<F6>", vim.lsp.buf.rename)
  bmap("n", "<F7>", vim.lsp.buf.type_definition)
  bmap("n", "<F8>", vim.lsp.buf.definition)
  bmap("n", "<F9>", vim.lsp.buf.references)
  bmap("n", "<F10>", vim.lsp.buf.implementation)
end

-- Keep PATH in sync with current project so "cmd" can remain static
local lsp_aug = vim.api.nvim_create_augroup("ProjectPaths", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group = lsp_aug,
  callback = function(args)
    local fname = (args.buf and vim.api.nvim_buf_get_name(args.buf)) or ""
    if fname == "" then
      fname = vim.api.nvim_buf_get_name(0)
    end
    if fname == "" then
      apply_project_paths(vim.fn.getcwd())
      return
    end
    local root = find_root_from_fname(fname)
    apply_project_paths(root)
  end,
})

-- Server configs via vim.lsp.config()
vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = find_root_from_fname,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

vim.lsp.config("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = find_root_from_fname,
  settings = {
    workingDirectory = { mode = "location" },
  },
})

vim.lsp.config("svelte", {
  cmd = { "svelteserver", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = find_root_from_fname,
})

-- Keep TS/JS changes in sync for Svelte
vim.api.nvim_create_autocmd("BufWritePost", {
  group = lsp_aug,
  pattern = { "*.js", "*.ts" },
  callback = function(ctx)
    for _, client in ipairs(vim.lsp.get_clients({ name = "svelte" })) do
      client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
    end
  end,
})

vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = find_root_from_fname,
  -- Automatically detects project Python virtualenv and tells
  -- Pyright which interpreter to use.
  --
  -- Without this:
  --   imports fail
  --   types break
  --   packages appear missing
  before_init = function(_, config)
    local root = config.root_dir or find_root_from_fname(vim.api.nvim_buf_get_name(0))
    local py = detect_python(root)
    if py then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = py
    end
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = find_root_from_fname,
})

-- The remaining servers (tailwindcss, html, cssls, jsonls, yamlls, marksman, sqls, dockerls,
-- docker_compose_language_service, bashls, lua_ls) are fine with defaults from nvim-lspconfig.

----------------------------------------------------------------------
-- Formatting (separate from LSP)
--
-- LSP handles:
--   navigation, rename, diagnostics
--
-- Conform handles:
--   code formatting
--
-- Why separate?
-- Because formatters are language-specific and often better than
-- what LSP servers provide.
--
-- Examples:
--  prettier → web
--  black    → python
--  shfmt    → shell
----------------------------------------------------------------------
require("conform").setup({
  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    -- Web stack
    javascript = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    svelte = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    yaml = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    html = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },

    -- Python (restored)
    python = { "isort", "black" },

    -- Shell
    sh = { "shfmt" },

    -- Lua
    lua = { "stylua" },
  },
})

map("n", "<Leader>f", function()
  require("conform").format({ lsp_fallback = true })
end, nore_silent)

----------------------------------------------------------------------
-- :DevInfo — development environment diagnostics
--
-- Shows:
--   • detected project root
--   • python interpreter
--   • PATH resolution (node_modules + venv)
--   • active LSP servers
--   • formatter availability
--
-- This is extremely useful when debugging LSP problems.
----------------------------------------------------------------------

local function devinfo()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  -- Detect root
  local root = find_root_from_fname(file)

  print("")
  print("========== Neovim DevInfo ==========")

  -- File + root
  print("Current file:")
  print("  " .. (file ~= "" and file or "[No Name]"))
  print("")
  print("Project root:")
  print("  " .. root)

  -- PATH preview
  print("")
  print("PATH (first 6 entries):")
  local i = 0
  for path in string.gmatch(vim.env.PATH or "", "[^:]+") do
    print("  " .. path)
    i = i + 1
    if i >= 6 then break end
  end

  -- Python interpreter
  print("")
  print("Python interpreter:")
  local py = detect_python(root)
  if py then
    print("  " .. py)
  else
    print("  [not detected]")
  end

  -- LSP clients
  print("")
  print("Active LSP clients:")
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if #clients == 0 then
    print("  (none attached)")
  else
    for _, client in ipairs(clients) do
      print("  " .. client.name)
    end
  end

  -- Formatter detection
  local function has(cmd)
    return vim.fn.executable(cmd) == 1
  end

  print("")
  print("Formatters available:")
  local formatters = { "prettierd", "prettier", "black", "isort", "shfmt", "stylua" }
  for _, f in ipairs(formatters) do
    print(string.format("  %-10s %s", f .. ":", has(f) and "OK" or "missing"))
  end

  print("===================================")
  print("")
end

vim.api.nvim_create_user_command("DevInfo", devinfo, {})

----------------------------------------------------------------------
-- Statusline
----------------------------------------------------------------------
require("lualine").setup({
  options = { icons_enabled = true, theme = "auto" },
})
