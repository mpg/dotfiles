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

-- Language settings
-- -----------------

-- Rust: see :help rust
vim.g.rustfmt_autosave = 1
--vim.g.rustfmt_fail_silently = 1

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
        --[[
        'sainnhe/gruvbox-material',
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            -- see :help gruvbox-material
            vim.g.gruvbox_material_transparent_background = true
            vim.g.gruvbox_material_foreground = 'original' -- mix, material
            vim.cmd.colorscheme('gruvbox-material')
        end
        --]]
        --[[
        "rebelot/kanagawa.nvim",
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            require('kanagawa').setup({
                transparent = true,
            })
            vim.cmd.colorscheme('kanagawa-wave') -- -dragon (low contrast)
        end
        --]]
        -- [[
        "savq/melange-nvim",
        lazy = false, -- load at start
        priority = 1000, -- load first
        config = function()
            vim.opt.termguicolors = true
            vim.cmd.colorscheme('melange')
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
        end
        --]]
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
                }
            }

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)

                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- I don't like the signs column (E, W, H)
                    vim.diagnostic.config({signs = false})

                    -- None of this semantics tokens business.
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })
        end
    },
    -- LSP-based code-completion
    --[[
    {
        "hrsh7th/nvim-cmp",
        -- load cmp on InsertEnter
        event = "InsertEnter",
        -- these dependencies will only be loaded when cmp loads
        -- dependencies are always lazy-loaded unless specified otherwise
        dependencies = {
            'neovim/nvim-lspconfig',
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                snippet = {
                    -- REQUIRED by nvim-cmp. get rid of it once we can
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- Accept currently selected item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'path' },
                }),
                experimental = {
                    ghost_text = true,
                },
            })

            -- Enable completing paths in :
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                })
            })
        end
    },
    --]]
    -- inline function signatures
    --[[
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            -- Get signatures (and _only_ signatures) when in argument lists.
            require "lsp_signature".setup({
                doc_lines = 0,
                handler_opts = {
                    border = "none"
                },
            })
        end
    },
    --]]
})
