local jc_utils = require("jc.utils")
local windline = require('windline')
local gps = jc_utils.prequire("nvim-gps")
local helper = require('windline.helpers')
local sep = helper.separators
local b_components = require('windline.components.basic')
local state = _G.WindLine.state
local vim_components = require('windline.components.vim')
local HSL = require('wlanimation.utils')

local lsp_comps = require('windline.components.lsp')
local git_comps = require('windline.components.git')

local hl_list = {
    Black = { 'white', 'black' },
    White = { 'black', 'white' },
    Normal = { 'NormalFg', 'NormalBg' },
    Inactive = { 'InactiveFg', 'InactiveBg' },
    Active = { 'ActiveFg', 'ActiveBg' },
}
local basic = {}

local airline_colors = {}

airline_colors.inactive = {
    NormalSep = { 'InactiveFg', 'magenta_b' },
    InsertSep = { 'InactiveFg', 'InactiveBg' },
    VisualSep = { 'InactiveFg', 'InactiveBg' },
    ReplaceSep = { 'InactiveFg', 'InactiveBg' },
    CommandSep = { 'InactiveFg', 'InactiveBg' },
    Normal = { 'InactiveFg', 'InactiveBg' },
    Insert = { 'InactiveFg', 'InactiveBg' },
    Visual = { 'InactiveFg', 'InactiveBg' },
    Replace = { 'InactiveFg', 'InactiveBg' },
    Command = { 'InactiveFg', 'InactiveBg' },
}

airline_colors.a = {
    NormalSep = { 'magenta_a', 'magenta_b' },
    InsertSep = { 'green_a', 'green_b' },
    VisualSep = { 'yellow_a', 'yellow_b' },
    ReplaceSep = { 'blue_a', 'blue_b' },
    CommandSep = { 'red_a', 'red_b' },
    Normal = { 'black', 'magenta_a' },
    Insert = { 'black', 'green_a' },
    Visual = { 'black', 'yellow_a' },
    Replace = { 'black', 'blue_a' },
    Command = { 'black', 'red_a' },
}

airline_colors.b = {
    NormalSep = { 'magenta_b', 'NormalBg' },
    InsertSep = { 'green_b', 'NormalBg' },
    VisualSep = { 'yellow_b', 'NormalBg' },
    ReplaceSep = { 'blue_b', 'NormalBg' },
    CommandSep = { 'red_b', 'NormalBg' },
    Normal = { 'white', 'magenta_b' },
    Insert = { 'white', 'green_b' },
    Visual = { 'white', 'yellow_b' },
    Replace = { 'white', 'blue_b' },
    Command = { 'white', 'red_b' },
}

airline_colors.c = {
    NormalSep = { 'magenta_c', 'NormalBg' },
    InsertSep = { 'green_c', 'NormalBg' },
    VisualSep = { 'yellow_c', 'NormalBg' },
    ReplaceSep = { 'blue_c', 'NormalBg' },
    CommandSep = { 'red_c', 'NormalBg' },
    Normal = { 'white', 'magenta_c' },
    Insert = { 'white', 'green_c' },
    Visual = { 'white', 'yellow_c' },
    Replace = { 'white', 'blue_c' },
    Command = { 'white', 'red_c' },
}

basic.divider = { b_components.divider, hl_list.Normal }

local width_breakpoint = 100

basic.section_a = {
    hl_colors = airline_colors.a,
    text = function()
        return {
            -- ⽔ (water)
            { " ⽔ ", state.mode[2] },
            { sep.right_filled, state.mode[2] .. 'Sep' },
        }
    end,
}

basic.section_a_inactive = {
    hl_colors = airline_colors.inactive,
    text = function()
        return {
            -- ⽔ (water)
            { " ⽔ ", state.mode[2] },
            { " " },
        }
    end,
}

local section_b_body = function()
    if gps and gps.is_available() then
        local loc_or_fname = gps.get_location()
        if gps.get_location() == '' then
            loc_or_fname = b_components.cache_file_name('[No Name]', 'unique')
        else
            loc_or_fname = gps.get_location()
        end

        return {
            loc_or_fname
        }
    else
        return {
            b_components.cache_file_name('[No Name]', 'unique')
        }
    end
end

basic.section_b = {
    hl_colors = airline_colors.b,
    text = function()
        return {
            { ' ', state.mode[2] },
            { b_components.cache_file_icon("") },
            { ' ', state.mode[2] },
            section_b_body(),
            { sep.right_filled, state.mode[2] .. 'Sep' },
        }
    end,
}

basic.section_y = {
    hl_colors = airline_colors.b,
    text = function(_,_,width)
        -- this used to have the file_type icon/name in it, but I removed it
        -- keeping it for future use
        return {
            { sep.left_filled, state.mode[2] .. 'Sep' },
        }
    end,
}

basic.section_z = {
    hl_colors = airline_colors.a,
    text = function(_,_,width)
        if width > width_breakpoint then
            return {
                { sep.left_filled, state.mode[2] .. 'Sep' },
                { '', state.mode[2] },
                { b_components.progress_lua},
                { ' '},
                { b_components.line_col_lua},
            }
        end
        return {
            { sep.left_filled, state.mode[2] .. 'Sep' },
            { ' ', state.mode[2] },
            { b_components.line_col_lua, state.mode[2] },
        }
    end,

}

basic.lsp_diagnos = {
    name = 'diagnostic',
    hl_colors = {
        red = { 'red', 'NormalBg' },
        yellow = { 'yellow', 'NormalBg' },
        blue = { 'blue', 'NormalBg' },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_error({ format = '%s ', show_zero = true }), 'red' },
                { lsp_comps.lsp_warning({ format = '%s ', show_zero = true }), 'yellow' },
                { lsp_comps.lsp_hint({ format = '%s', show_zero = true }), 'blue' },
            }
        end
        return { ' ', 'red' }
    end,
}

basic.git = {
    name = 'git',
    width = width_breakpoint,
    hl_colors = {
        green = { 'green', 'NormalBg' },
        red = { 'red', 'NormalBg' },
        blue = { 'blue', 'NormalBg' },
    },
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added({ format = '  %s' }), 'green' },
                { git_comps.diff_removed({ format = '  %s' }), 'red' },
                { git_comps.diff_changed({ format = ' 柳%s' }), 'blue' },
            }
        end
        return ''
    end,
}
local quickfix = {
    filetypes = { 'qf', 'Trouble' },
    active = {
        { '🚦 Quickfix ', { 'white', 'black' } },
        { helper.separators.slant_right, { 'black', 'black_light' } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { 'cyan', 'black_light' },
        },
        { ' Total : %L ', { 'cyan', 'black_light' } },
        { helper.separators.slant_right, { 'black_light', 'InactiveBg' } },
        { ' ', { 'InactiveFg', 'InactiveBg' } },
        basic.divider,
        { helper.separators.slant_right, { 'InactiveBg', 'black' } },
        { '🧛 ', { 'white', 'black' } },
    },
    always_active = true,
    show_last_status = true
}

local explorer = {
    filetypes = { 'fern', 'NvimTree', 'lir' },
    active = {
        { '  ', { 'white', 'magenta_b' } },
        { helper.separators.slant_right, { 'magenta_b', 'NormalBg' } },
        { b_components.divider, '' },
        { b_components.file_name(''), { 'NormalFg', 'NormalBg' } },
    },
    always_active = true,
    show_last_status = true
}

local default = {
    filetypes = { 'default' },
    active = {
        basic.section_a,
        basic.section_b,
        { vim_components.search_count(), { 'cyan', 'NormalBg' } },
        basic.divider,
        basic.git,
        basic.section_y,
        basic.section_z,
        basic.lsp_diagnos,
    },
    inactive = {
        basic.section_a_inactive,
        { b_components.full_file_name, hl_list.Inactive },
        { b_components.divider, hl_list.Inactive },
        { b_components.line_col, hl_list.Inactive },
        { b_components.progress, hl_list.Inactive },
    },
}

windline.setup({
    colors_name = function(colors)
        local mod = function (c, value)
            if vim.o.background == 'light' then
                return HSL.rgb_to_hsl(c):tint(value):to_rgb()
            end
            return HSL.rgb_to_hsl(c):shade(value):to_rgb()
        end

        colors.magenta_a = colors.magenta
        colors.magenta_b = mod(colors.magenta,0.5)
        colors.magenta_c = mod(colors.magenta,0.7)

        colors.yellow_a = colors.yellow
        colors.yellow_b = mod(colors.yellow,0.5)
        colors.yellow_c = mod(colors.yellow,0.7)

        colors.blue_a = colors.blue
        colors.blue_b = mod(colors.blue,0.5)
        colors.blue_c = mod(colors.blue,0.7)

        colors.green_a = colors.green
        colors.green_b = mod(colors.green,0.5)
        colors.green_c = mod(colors.green,0.7)

        colors.red_a = colors.red
        colors.red_b = mod(colors.red,0.5)
        colors.red_c = mod(colors.red,0.7)

        return colors
    end,
    statuslines = {
        default,
        quickfix,
        explorer,
    },
})
