-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

-- Spell check
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- Line wrap
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Break lines at word boundaries
vim.opt.breakindent = true -- Indent wrapped lines

vim.g.snacks_animate = false
