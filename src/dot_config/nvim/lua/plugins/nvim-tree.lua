return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  version = "*",
  lazy = false,
  config = function()
    -- require here over passing opts, see https://github.com/nvim-tree/nvim-tree.lua/issues/2378
    require("nvim-tree").setup()

    vim.keymap.set('n', '<leader>tr', '<cmd>NvimTreeToggle<cr>')
    vim.keymap.set('n', '<leader>ctr', '<cmd>NvimTreeCollapse<cr>')
  end,
}
