-- TODO update this plugin once https://github.com/pmizio/typescript-tools.nvim/pull/139 merged
return {
  "pmizio/typescript-tools.nvim",
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require("typescript-tools").setup({
      capabilities = capabilities,

      settings = {
        tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true
        },
      }
    })

    -- local actions = {
    --   ["Organize Imports"] = "TSToolsOrganizeImports",
    --   ["Sort Imports"] = "TSToolsSortImports",
    --   ["Remove Unused Imports"] = "TSToolsRemoveUnused",
    --   ["Go to Source Definition"] = "TSToolsGoToSourceDefinition",
    --   ["Add Missing Imports"] = "TSToolsAddMissingImports",
    --   ["Fix All"] = "TSToolsFixAll",
    -- }
    -- local function code_action()
    --   vim.ui.select(vim.tbl_keys(actions), {
    --     prompt = "Select Action",
    --   }, function(selection)
    --     vim.cmd(actions[selection])
    --   end)
    -- end

    -- vim.keymap.set("n", "<leader>ca", code_action, { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>tsi', '<cmd>TSToolsAddMissingImports<cr>')
  end,
}
