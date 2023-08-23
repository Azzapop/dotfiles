return {
  'stevearc/aerial.nvim',
  -- Optional dependencies
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require('aerial').setup({
      backends = { 'treesitter' },

      layout = {
        max_with = 0.2,
        min_width = 0.2,
      },

      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    })

    vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
  end
}
