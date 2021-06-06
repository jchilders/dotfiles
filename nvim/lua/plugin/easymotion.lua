local api = vim.api

api.nvim_set_keymap('n', '/', '<Plug>(easymotion-sn)', {})
api.nvim_set_keymap('o', '/', '<Plug>(easymotion-tn)', {})

api.nvim_set_keymap('n', 'n', '<Plug>(easymotion-next)', {})
api.nvim_set_keymap('n', 'N', '<Plug>(easymotion-prev)', {})
