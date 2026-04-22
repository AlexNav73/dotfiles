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
vim.o.winborder = 'rounded'
vim.o.termguicolors = true

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

vim.keymap.set('n', '<leader>cd', ':cd %:h<CR>', { silent = true, desc = 'Change directory to the current file folder' })

vim.keymap.set('n', 'gK', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.cmd.packadd('nvim.undotree')

vim.keymap.set('n', '<F5>', require('undotree').open)

vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',

    ------ cmp plugin (+ dependencies) --------
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-cmdline',
    'https://github.com/hrsh7th/nvim-cmp',
    ---------------------------------------------

    'https://github.com/ahmedkhalf/project.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/RRethy/base16-nvim',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/nvimdev/dashboard-nvim',
    'https://github.com/numToStr/Comment.nvim',

    ------ noice plugin (+ dependencies) --------
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/rcarriga/nvim-notify',
    'https://github.com/folke/noice.nvim',
    ---------------------------------------------

    'https://github.com/nvim-mini/mini.files'
}

local mini = require('mini.files')
mini.setup()
vim.keymap.set('n', '<F2>', mini.open)

require('base16-colorscheme').with_config({
    telescope = false,
    cmp = false,
})

vim.cmd('colorscheme base16-atelier-dune')

-- dotnet tool install --global roslyn-language-server --prerelease
vim.lsp.enable('roslyn_ls')
vim.lsp.enable('rust_analyzer')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufmap = function(mode, rhs, lhs)
      vim.keymap.set(mode, rhs, lhs, { buffer = event.buf })
    end

    -- These are custom keymaps
    bufmap({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')
  end,
})

local cmp = require('cmp')
cmp.setup({
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
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.dup = ({
                nvim_lsp = 0,
                buffer = 0,
            })[entry.source.name] or 0

            return vim_item
        end
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

vim.keymap.set('n', 'nd', require('notify').dismiss)

require('noice').setup()
require('project_nvim').setup()
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

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup()
telescope.load_extension('projects')

vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<Leader>fp', telescope.extensions.projects.projects, { desc = 'Telescope projects' })
vim.keymap.set('n', '<Leader>fn', telescope.extensions.notify.notify, { desc = 'Telescope notifications' })
vim.keymap.set('n', '<Leader>fv', function()
    builtin.find_files({
        cwd = vim.fn.stdpath('config')
    })
end)

require('Comment').setup()
require('dashboard').setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        shortcut = {
            { icon = '󰊳  ' , desc = 'Update', group = '@property', action = 'lua vim.pack.update(nil, {})', key = 'u' },
            { icon = '' , desc = 'New Buffer', group = 'Buffer', action = 'ene', key = 'e' },
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

