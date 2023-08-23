return {
  'XadillaX/json-formatter.vim',
  config = function()
    vim.keymap.set('n', '<leader>json', '<cmd>JSONFormatter<CR>')
  end
}
