-- ysw( - surround word with parens (`w` here is a text object)
-- ds" - delete surrounding quotes
-- cs"' - change surrounding double quotes with single quotes
-- dsq - delete closest surrounding quote
-- dss - delete closest surrounding whatever
-- :h nvim-surround
return {
  "kylechui/nvim-surround",
  enabled = true,
  config = function()
    require("nvim-surround").setup()
  end
}
