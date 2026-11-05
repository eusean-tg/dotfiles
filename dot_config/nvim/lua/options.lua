require "nvchad.options"

local o = vim.o

-- ── Clipboard without a display (SSH, detached multiplexers) ───
-- With no X11/Wayland display Nvim finds no clipboard tool, and NvChad's
-- clipboard=unnamedplus disables the automatic OSC 52 fallback. Yanks go
-- through OSC 52 so the outer terminal sets its local clipboard. Pastes read
-- Nvim's own register, since most terminals block or prompt on OSC 52 reads;
-- paste from the system clipboard with the terminal's paste key.
-- macOS uses pbcopy, so it is left alone.
if vim.fn.has "mac" == 0 and (vim.env.DISPLAY or "") == "" and (vim.env.WAYLAND_DISPLAY or "") == "" then
  local osc52 = require "vim.ui.clipboard.osc52"
  local function paste()
    return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy "+", ["*"] = osc52.copy "*" },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

-- ── Line numbers & cursor ──────────────────────────────────────
o.relativenumber = true -- relative numbers make 5j / 12k natural
o.cursorlineopt = "both" -- highlight the line AND the number

-- ── Scrolling / view ───────────────────────────────────────────
o.scrolloff = 8 -- keep 8 lines of context above/below
o.sidescrolloff = 8
o.wrap = true
o.linebreak = true

-- ── Indentation (NvChad sets 2-space default; these round it out) ─
o.smartindent = true
o.breakindent = true

-- ── Search ─────────────────────────────────────────────────────
o.ignorecase = true
o.smartcase = true -- a capital letter in the pattern makes it case-sensitive
o.inccommand = "split" -- live preview of :%s///

-- ── Persistent undo: undo history survives closing the file ────
o.undofile = true
o.undolevels = 10000

-- ── Splits open where you expect ───────────────────────────────
o.splitright = true
o.splitbelow = true

-- ── Misc ───────────────────────────────────────────────────────
o.confirm = true -- confirm before discarding unsaved changes
o.updatetime = 250 -- faster CursorHold (gitsigns, diagnostics)
o.timeoutlen = 400
o.termguicolors = true

-- Show whitespace that matters
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Treesitter supplies folds until an LSP with folding support attaches.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = ""
o.foldlevel = 99
o.foldlevelstart = 99
vim.opt.fillchars:append { fold = " " }
