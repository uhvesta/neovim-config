-- ~/.config/nvim/lua/plugins/lspsaga.lua
return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "gpd", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "gpt", "<cmd>Lspsaga peek_type_definition<cr>", desc = "Peek Type Definition" },
    },
  },
}
