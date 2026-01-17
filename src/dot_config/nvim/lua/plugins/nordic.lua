return {
  'AlexvZyl/nordic.nvim',
  config = function()
    local C = require('nordic.colors')

    require('nordic').setup({
      -- This callback can be used to override the colors used in the palette.
      on_palette = function(palette) return palette end,
      -- Override the styling of any highlight group.
      on_highlight = function(highlights, palette)
        highlights.Comment = { fg = '#8d9cb0' }
        highlights.Visual = { bg = C.gray2 }

        highlights.StatusLine = { fg = C.white0 }
        highlights.StatusLineNC = { fg = C.white0 }

        highlights.String = { fg = C.magenta.bright }

        -- Fix syntax highlighting from tsserver
        -- ['@lsp.type.parameter.typescript'] = { fg = C.red.base }
        -- ['@lsp.typemod.property.declaration.typescript'] = { fg = C.cyan.base }
        -- ['@lsp.mod.declaration.typescript'] = { fg = C.red.base }
        highlights.typescriptVariable = { fg = C.orange.base }
        highlights.typescriptBraces = { fg = C.white0 }
      end,
      -- Enable bold keywords.
      bold_keywords = false,
      -- Enable italic comments.
      italic_comments = false,
      -- Enable general editor background transparency.
      transparent = {
        -- Enable transparent background.
        bg = false,
        -- Enable transparent background for floating windows.
        float = false,
      },
      -- Enable brighter float border.
      bright_border = false,
      -- Reduce the overall amount of blue in the theme (diverges from base Nord).
      reduced_blue = true,
      -- Swap the dark background with the normal one.
      swap_backgrounds = true,
      -- Cursorline options.  Also includes visual/selection.
      cursorline = {
        -- Bold font in cursorline.
        bold = false,
        -- Bold cursorline number.
        bold_number = true,
        -- Avialable styles: 'dark', 'light'.
        theme = 'dark',
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.7,
      },
      noice = {
        -- Available styles: `classic`, `flat`.
        style = 'flat',
      },
      telescope = {
        -- Available styles: `classic`, `flat`.
        style = 'flat',
      },
      leap = {
        -- Dims the backdrop when using leap.
        dim_backdrop = false,
      },
      ts_context = {
        -- Enables dark background for treesitter-context window
        dark_background = true,
      }
    })
  end,
}
