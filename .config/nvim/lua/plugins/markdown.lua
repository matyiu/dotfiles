return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { 'n', 'c', 't', 'i' },
      checkbox = {
        enabled = true,
        position = 'inline',
        -- Esto asegura que el plugin respete el espacio original
        custom = {
          todo = { raw = '[-]', rendered = '󰄱 ', highlight = 'RenderMarkdownTodo' },
        },
      },
      -- -- Muy importante: el anti_conceal evita que la línea se corte al editar
      anti_conceal = {
        enabled = true,
      },
      -- -- Si usas Treesitter (que deberías por tu perfil ENTJ/Ingeniero),
      -- -- asegúrate de que no haya conflictos de indentación
      -- indent = {
      --   enabled = true,
      -- },
    },
  }
}
