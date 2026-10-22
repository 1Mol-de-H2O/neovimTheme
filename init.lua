vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = false

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = '#D68C45' })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = '#D68C45' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = '#D68C45' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = '#D68C45' })
    vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = '#B8C99A', bold = true })
    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = '#B8C99A', bold = true })
    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = '#B8C99A', bold = true })
    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = '#B8C99A', bold = true })
    vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = '#3A4A32', fg = '#FFFFFF' })
    vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = '#D68C45', bold = true })
  end,
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

if vim.g.neovide then
  vim.o.guifont = 'JetBrainsMono Nerd Font:h13'
 
  vim.g.neovide_padding_top = 12
  vim.g.neovide_padding_bottom = 12
  vim.g.neovide_padding_left = 12
  vim.g.neovide_padding_right = 12

  vim.g.neovide_opacity = 0.97
  vim.g.neovide_normal_opacity = 0.97

  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  vim.g.neovide_cursor_trail_size = 0.5

  vim.g.neovide_hide_mouse_when_typing = true
end
