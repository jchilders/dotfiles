return {
  "danielfalk/smart-open.nvim",
  enabled = true,
  dependencies = { "tami5/sqlite.lua" },
  config = function()
    require("telescope").load_extension("smart_open")
  end
}
