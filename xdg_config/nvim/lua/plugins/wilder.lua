-- A more adventurous wildmenu
return {
  "gelguy/wilder.nvim",
  enabled = true,
  dependencies = "romgrk/fzy-lua-native",
  build = ":UpdateRemotePlugins",
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    -- Disable Python remote plugin
    wilder.set_option("use_python_remote_plugin", 0)

    wilder.set_option("pipeline", {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        }),
        wilder.vim_search_pipeline()
      )
    })

    wilder.set_option("renderer", wilder.renderer_mux({
      [":"] = wilder.popupmenu_renderer(
	wilder.popupmenu_border_theme({
	  highlights = {
	    border = 'Normal', -- highlight to use for the border
	  },
	  -- 'single', 'double', 'rounded' or 'solid'
	  -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
	  border = 'rounded',
	  highlighter = wilder.lua_fzy_highlighter(),
	  pumblend = 20,
	  left = { " ", wilder.popupmenu_devicons() },
	  right = { " ", wilder.popupmenu_scrollbar() },
	})
      ),
      ["/"] = wilder.popupmenu_renderer(
	wilder.popupmenu_border_theme({
	  highlighter = wilder.lua_fzy_highlighter(),
	  pumblend = 20,
	  right = { " ", wilder.popupmenu_scrollbar() },
	})
      ),
    }))

    wilder.setup({
      modes = { ":", "/", "?" },
      next_key = "<C-n>",
      previous_key = "<C-p>",
    })
  end
}

