return {
  {
    "AstroNvim/astrotheme",
    lazy = false,
    priority = 1000,
    opts = {
      -- you can customize palettes, styles, etc. here
      -- see https://github.com/AstroNvim/astrotheme for options
    },
  },

  -- Tell LazyVim to use it as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "astrodark", -- or "astrolight", "astromars", "astrojupiter"
    },
  },
}
