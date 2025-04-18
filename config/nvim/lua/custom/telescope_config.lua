return {
    setup = function()
        vim.keymap.set('n', '<leader>p', function()
            require('telescope').extensions.project.project({})
        end, { desc = 'Telescope project picker' })
    end,
}
