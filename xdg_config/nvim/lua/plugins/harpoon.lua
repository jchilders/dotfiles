-- harpoon lets you mark a small number of key files on a per-project basis,
-- and quickly nav to them
-- <leader>hl - list harpoons
-- <leader>ha - add harpoon
-- C-h/j/k/l - go to first/second/third/fourth harpoon
return {
  "ThePrimeagen/harpoon",
  config = function()
    require("harpoon").setup({
      global_settings = {
	enter_on_sendcmd = true,
      },
      projects = {
	-- Yes $HOME works
	--[[ ["$HOME/work/carerev/api_app"] = {
	  term = {
	    cmds = {
	      "rails console"
	    },
	  },
	}, ]]
      },
    })
  end
}
