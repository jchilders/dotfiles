return {
  "weizheheng/ror.nvim",
  enabled = true,
  config = function()
    require("ror").setup({
      disable_filetype = { "TelescopePrompt" },
      enable_check_bracket_line = false,
    })
  end,
  keys = {
    -- { "<leader>rc", "<cmd>lua require('ror.commands').list_commands()<CR>" },
    { "<leader>fsl", "<cmd>lua require('ror.frozen_string_literal').add()<CR>" },

    -- Edit test associated with file in current buffer
    -- { "<leader>et", "<cmd>lua require('ror.navigators.test').visit('normal')<CR>" },
    -- Run current test 
    -- { "<leader>rt", "<cmd>lua require('ror.test').run()<CR>" },
    -- Run current test, line under cursor
    -- { "<leader>rt", "<cmd>lua require('ror.test').run('Line')<CR>" },

    { "<C-o>rc", "<cmd>lua require('ror.finders.controller').find()<CR>" },
    -- { "<C-o>rct", "<cmd>lua require('ror.finders.controller_test').find()<CR>" },
    { "<C-o>rm", "<cmd>lua require('ror.finders.model').find()<CR>" },
    -- { "<C-o>rmt", "<cmd>lua require('ror.finders.model_test').find()<CR>" },
    { "<C-o>rv", "<cmd>lua require('ror.finders.view').find()<CR>" },

    { "<leader>dbms", "<cmd>lua require('ror.runners.db_migrate_status').run()<CR>" },
    { "<leader>dbm", "<cmd>lua require('ror.runners.db_migrate').run()<CR>" },
    { "<leader>dbmr", "<cmd>lua require('ror.runners.db_rollback').run()<CR>" },
  },
}
