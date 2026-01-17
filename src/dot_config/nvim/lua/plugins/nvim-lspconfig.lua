return {
  'neovim/nvim-lspconfig',
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    vim.lsp.enable('pyright')
    vim.lsp.enable('terraformls')
  end
}
