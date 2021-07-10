-- During visual select, hit `.` to expand selection to the surrounding
-- treesitter object 
require'nvim-treesitter.configs'.setup {
    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
        }
    },
}
