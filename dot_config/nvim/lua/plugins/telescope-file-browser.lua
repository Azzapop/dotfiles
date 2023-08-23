return {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    opts = {},
    config = function()
      require('telescope').load_extension('file_browser')

      vim.keymap.set('n', '<leader>ft', '<cmd>Telescope file_browser<cr>')
    end,
}
