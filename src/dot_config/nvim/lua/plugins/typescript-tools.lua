-- TODO update this plugin once https://github.com/pmizio/typescript-tools.nvim/pull/139 merged
return {
  "pmizio/typescript-tools.nvim",
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local function rename_file()
      local source_file, target_file

      vim.ui.input({
        prompt = "Source : ",
        completion = "file",
        default = vim.api.nvim_buf_get_name(0)
      },
      function(input)
        source_file = input
      end
      )
      vim.ui.input({
        prompt = "Target : ",
        completion = "file",
        default = source_file
      },
      function(input)
        target_file = input
      end
      )

      local params = {
        command = "_typescript.applyRenameFile",
        arguments = {
          {
            sourceUri = source_file,
            targetUri = target_file,
          },
        },
        title = ""
      }

      vim.lsp.util.rename(source_file, target_file)
      vim.lsp.buf.execute_command(params)
    end

    require("typescript-tools").setup({
      capabilities = capabilities,

      commands = {
        RenameFile = {
          rename_file,
          description = "Rename File"
        },
      },

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
