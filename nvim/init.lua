-- Basic settings
-- --------------

-- persistent undo - ~/.local/state/nvim/undo/
vim.opt.undofile = true

-- display special chars in a special way
vim.opt.listchars = { tab = '¬·', trail = '␣', nbsp = '~' }

-- statusline: very similar to the default, add:
-- preview window flag       %w
-- filetype,fileformat       %{&ft},%{&ff}
-- total number of lines     %L
-- code point under cursor   U+%04B
vim.opt.statusline = [[%<%f %h%m%r%w  %{&ft},%{&ff}  %LL%=U+%04B %-14.(%l,%c%V%) %P]]

-- general defaults, can be overridden by filetypes
vim.opt.textwidth = 80
vim.opt.shiftwidth = 4      -- Number of spaces to use for each step of (auto)indent.
vim.opt.softtabstop = 4     -- Number of spaces that a <Tab> counts for while editing.
vim.opt.expandtab = true    -- Insert spaces rather than actual <Tab>s.

-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 999

-- mapleader - must be defined before loading lazy.nvim
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- Shortcuts
-- ---------

-- shortcuts for spell checking
vim.api.nvim_create_user_command('Fr', 'setl spell spelllang=fr', {})
vim.api.nvim_create_user_command('En', 'setl spell spelllang=en', {})

-- transliterate to ascii using GNU iconv (assumes utf8 input)
vim.cmd('com -range Ascii silent <line1>,<line2>!iconv -f utf8 -t ascii//translit')


-- Auto commands
-- -------------

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd(
'BufReadPost',
{
    pattern = '*',
    callback = function(ev)
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            -- except for in git commit messages
            -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
            if not vim.fn.expand('%:p'):find('.git', 1, true) then
                vim.cmd('exe "normal! g\'\\""')
            end
        end
    end
}
)

-- Plugins
-- -------

-- https://lazy.folke.io/installation
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    -- main color scheme
    {
        "wincent/base16-nvim",
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            vim.cmd.colorscheme('gruvbox-dark-hard')
            vim.o.background = 'dark'
            vim.cmd('hi Normal ctermbg=none guibg=none')
            -- Make comments more prominent -- they are important.
            local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
            vim.api.nvim_set_hl(0, 'Comment', bools)
            -- Make it clearly visible which argument we're at.
            local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
            vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
        end
    },
    -- Git
    { 'tpope/vim-fugitive' },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        config = function()
            -- Setup language servers.
            local lspconfig = require('lspconfig')

            -- Rust
            lspconfig.rust_analyzer.setup {
                -- Server-specific settings. See `:help lspconfig-setup`
                settings = {
                    ['rust-analyzer'] = {},
                }
            }
        end
    },
})
