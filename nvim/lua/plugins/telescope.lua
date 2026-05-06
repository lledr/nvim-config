return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<C-f>', builtin.find_files)
        vim.keymap.set('n', '<C-g>', builtin.live_grep)

        vim.keymap.set('n', '<leader>en', function()
            builtin.find_files { cwd = vim.fn.stdpath("config") }
        end)

        vim.keymap.set('n', '<leader>g', builtin.grep_string)

        vim.keymap.set('n', 'grd',   builtin.lsp_definitions)
        vim.keymap.set('n', 'grr',   builtin.lsp_references)
        vim.keymap.set('n', 'gri',   builtin.lsp_implementations)
        vim.keymap.set('n', 'grt',   builtin.lsp_type_definitions)

        vim.keymap.set('n', 'gO',    builtin.lsp_document_symbols)
        vim.keymap.set('n', 'gW',    builtin.lsp_workspace_symbols)
        vim.keymap.set('n', 'gJ',    builtin.jumplist)

        vim.keymap.set('n', '<Leader>e', function() builtin.diagnostics{severity='error'} end)
        vim.keymap.set('n', '<Leader>w', function() builtin.diagnostics{severity='warn' } end)

        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ['<tab>'] = require('telescope.actions').toggle_selection,
                        ['<c-q>'] = require('telescope.actions').send_to_qflist,
                        ['<m-q>'] = require('telescope.actions').send_selected_to_qflist,
                    },
                    n = {
                        ['"'] = require('telescope.actions').select_vertical,
                        ['='] = require('telescope.actions').select_horizontal,
                    }
                }
            }
        }
    end
}
