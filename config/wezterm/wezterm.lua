-- Pull in the wezterm API
local wezterm = require('wezterm')
local appearance = require('appearance')
local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')

-- This will hold the configuration.
local config = wezterm.config_builder()

if appearance.is_dark() then
    config.color_scheme = 'Material Darker'
else
    config.color_scheme = 'iTerm2 Light Background'
end

config.window_decorations = 'TITLE'
config.window_background_opacity = 0.7
config.macos_window_background_blur = 15
config.window_close_confirmation = 'NeverPrompt'

-- Table mapping keypresses to actions
config.keys = {
    {
        key = 'LeftArrow',
        mods = 'CMD',
        action = wezterm.action.SendString('\x1bOH'),
    },
    {
        key = 'RightArrow',
        mods = 'CMD',
        action = wezterm.action.SendString('\x1bOF'),
    },
    -- ... add these new entries to your config.keys table
    {
        key = ',',
        mods = 'SUPER',
        action = wezterm.action.SpawnCommandInNewTab({
            cwd = wezterm.home_dir,
            args = { 'nvim', wezterm.config_file },
        }),
    },
    -- disable alt-enter (maximize window)
    {
        key = 'Enter',
        mods = 'ALT',
        action = wezterm.action.DisableDefaultAssignment,
    },
}

config.font_size = 14.0
config.font = wezterm.font({
    family = 'Monaspace Neon NF',
    weight = 'Medium',
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.font_shaper = 'Harfbuzz'

tabline.setup({
    options = {
        icons_enabled = true,
        theme = 'Catppuccin Mocha',
        tabs_enabled = true,
        theme_overrides = {},
        section_separators = {
            left = wezterm.nerdfonts.pl_left_hard_divider,
            right = wezterm.nerdfonts.pl_right_hard_divider,
        },
        component_separators = {
            left = wezterm.nerdfonts.pl_left_soft_divider,
            right = wezterm.nerdfonts.pl_right_soft_divider,
        },
        tab_separators = {
            right = wezterm.nerdfonts.ple_left_half_circle_thick,
            left = wezterm.nerdfonts.ple_right_half_circle_thick,
        },
    },
    sections = {
        tabline_a = { 'hostname' },
        tabline_b = '',
        tabline_c = '',
        tab_active = {
            'index',
            { 'parent', padding = 0 },
            '/',
            { 'cwd', padding = { left = 0, right = 1 } },
            { 'process', padding = { left = 0, right = 1 } },
            { 'zoomed', padding = 0 },
        },
        tab_inactive = {
            'index',
            { 'parent', padding = 0 },
            '/',
            { 'cwd', padding = { left = 0, right = 1 } },
            { 'process', padding = { left = 0, right = 1 } },
            { 'zoomed', padding = 0 },
        },
        tabline_x = '',
        tabline_y = '',
        tabline_z = { 'ram', 'cpu' },
    },
    extensions = {},
})

tabline.apply_to_config(config)

return config
