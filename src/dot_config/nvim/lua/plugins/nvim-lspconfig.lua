return {
  'neovim/nvim-lspconfig',
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    local lspconfig = require('lspconfig')

    lspconfig.pyright.setup({})

    lspconfig.crystalline.setup({})
    lspconfig.terraformls.setup({})
    --
    -- lspconfig.tsserver.setup({})
  end
}
