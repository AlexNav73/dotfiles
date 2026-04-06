vim.o.number = true
vim.o.relativenumber = true
vim.o.confirm = true
vim.o.cursorline = true
vim.o.fdc = '1'
vim.o.colorcolumn = '80'
vim.o.wrap = false

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

vim.o.backup = false
vim.o.swapfile = false

vim.g.mapleader = ','

vim.keymap.set('n', '<leader>v', ':tabnew $MYVIMRC<CR>', { silent = true, desc = 'Opens init.lua in new tab' })
vim.keymap.set('n', 'gV', '`[v`]', { desc = 'Reselects last selected text' })
vim.keymap.set('n', 'H', '^', { noremap = true, desc = '' })
vim.keymap.set('n', 'L', '$', { noremap = true, desc = '' })

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = '' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = '' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = '' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = '' })

vim.keymap.set('n', '<Left>',  '<C-w>>', { desc = '' })
vim.keymap.set('n', '<Right>', '<C-w><', { desc = '' })
vim.keymap.set('n', '<Down>',  '<C-w>+', { desc = '' })
vim.keymap.set('n', '<Up>',    '<C-w>-', { desc = '' })

vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-cmdline',
    'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/RRethy/base16-nvim',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/nvimdev/dashboard-nvim',
    'https://github.com/numToStr/Comment.nvim',
    'https://github.com/nvim-tree/nvim-tree.lua',
}

vim.cmd('colorscheme base16-atelier-dune')

require('mason').setup()

vim.lsp.enable('rust_analyzer')

vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
vim.keymap.set('n', '<C-w>d', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '<C-w><C-d>', '<cmd>lua vim.diagnostic.open_float()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufmap = function(mode, rhs, lhs)
      vim.keymap.set(mode, rhs, lhs, {buffer = event.buf})
    end

    -- These keymaps are the defaults in Neovim v0.11
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
    bufmap({'i', 's'}, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- These are custom keymaps
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    bufmap({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
  end,
})

local cmp = require('cmp')
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'nvim-lsp-signature-help' },
    },
    sorting = {
        comparators = {
            cmp.config.compare.order
        }
    }
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'path' },
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    }
})

require("nvim-tree").setup({
    live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = false, -- Turn into false from true by default
    }
})
vim.keymap.set("n", "<F2>", ":NvimTreeToggle<CR>", { silent = true, noremap = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('oil').setup()
require('lualine').setup({
    sections = {
        lualine_x = {
            {
                'lsp_status',
                icon = '', -- f013
                symbols = {
                    -- Standard unicode symbols to cycle through for LSP progress:
                    spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                    -- Standard unicode symbol for when LSP is done:
                    done = '✓',
                    -- Delimiter inserted between LSP names:
                    separator = ' ',
                },
                -- List of LSP names to ignore (e.g., `null-ls`):
                ignore_lsp = {},
                -- Display the LSP name
                show_name = true,
            },
            'encoding',
            'fileformat',
            'filetype'
        }
    }
})
require('telescope').setup()
require('Comment').setup()
require('dashboard').setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        shortcut = {
            { icon = '󰊳  ' , desc = 'Update', group = '@property', action = 'lua vim.pack.update(nil, {})', key = 'u' },
            {
                icon = ' ',
                icon_hl = '@variable',
                desc = 'Files',
                group = 'Label',
                action = 'Telescope find_files',
                key = 'f',
            },
            {
                desc = ' init.lua',
                group = 'Neovim',
                action = 'e $MYVIMRC',
                key = 'd',
            },
        },
    },
})

