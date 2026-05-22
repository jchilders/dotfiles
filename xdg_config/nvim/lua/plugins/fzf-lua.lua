return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons", { "junegunn/fzf", build = "./install --bin" } },
  config = function()
    require("fzf-lua").setup({
      winopts = {
        height = 0.5,
        width = 0.8,
        winblend = 10,
        preview = { hidden = "hidden" },
      },
      fzf_opts = {
        ["--layout"] = "reverse",
      },
    })
  end,
}
