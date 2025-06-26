return {
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-completion",
  "kristijanhusak/vim-dadbod-ui",

  vim.keymap.set('n', '<leader>Do', function() vim.cmd [[DBUI]] end, { desc = 'Open Database Manage' }),
  vim.keymap.set('n', '<leader>Dt', function() vim.cmd [[DBUIToggle]] end, { desc = 'Toggle Database Manage' }),
  vim.keymap.set('n', '<leader>Db', function() vim.cmd [[DBUIFindBuffer]] end, { desc = 'Connect Buffer to DB' }),
  vim.keymap.set('n', '<leader>Dq', function() vim.cmd [[DBUIClose]] end, { desc = 'Close Database Manage' })
}
