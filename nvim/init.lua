-- General settings
-- ----------------

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

-- don't highlight matches from previous searches
vim.opt.hlsearch = false

-- keep more context on screen while scrolling
vim.opt.scrolloff = 2

-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 999

-- mapleader - must be defined before loading lazy.nvim
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- for ins-completion: show the menu (even for one match) but not the preview window
vim.opt.completeopt = "menuone,noinsert"

-- autowrite before ^Z (:suspend) and similar events
vim.opt.autowrite = true

-- Per-language settings
-- ---------------------


-- Shortcuts
-- ---------

-- quick-save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- always center search results
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')

-- shortcuts for spell checking
vim.api.nvim_create_user_command('Fr', 'setl spell spelllang=fr', {})
vim.api.nvim_create_user_command('En', 'setl spell spelllang=en', {})

-- transliterate to ascii using GNU iconv (assumes utf8 input)
vim.cmd('com -range Ascii silent <line1>,<line2>!iconv -f utf8 -t ascii//translit')

-- convenience mappings for inserting }, fi, etc then a line above
vim.keymap.set('i', '<C-k>', '<Esc>O')
vim.keymap.set('i', '<C-]>', '<CR>}<Esc>O')

-- Auto commands
-- -------------

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd( 'BufReadPost', {
    pattern = '*',
    callback = function(ev)
        if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
            -- except for in git commit messages
            if not vim.fn.expand('%:p'):find('.git', 1, true) then
                vim.cmd('exe "normal! g\'\\""')
            end
        end
    end
})

-- Configuration for buffers with an LSP attached
function on_lsp_attach(ev)
    local opts = { buffer = ev.buf }

    -- Information
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- Actions
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format { async = true }
    end, opts)

    -- Omnicomplete with ^P (keep ^N for keyword complete)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.keymap.set('i', '<C-p>', '<C-x><C-o>', opts)

    -- I don't like the signs column (E, W, H)
    vim.diagnostic.config({signs = false})

    -- Add a border around the LSP hover window
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = "rounded" } -- "single", "double", "shadow"
    )

    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

    -- Refresh diagnostics more frequently (not really working)
    vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {
        callback = function()
            vim.diagnostic.setloclist({ open = false }) -- Refresh diagnostics
        end,
        buffer = ev.buf,
    })

    -- Enable format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
        buffer = ev.buf,
    })

    -- Disable semantics tokens
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
end

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
        "EdenEast/nightfox.nvim",
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            require('nightfox').setup({
                options = {
                    transparent = true,
                },
            })
            vim.cmd.colorscheme('carbonfox')
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
                -- https://rust-analyzer.github.io/book/configuration.html
                settings = {
                    ['rust-analyzer'] = {},
                },
            }

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = on_lsp_attach,
            })
        end
    },
})
