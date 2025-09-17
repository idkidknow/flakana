local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font_with_fallback {
    'JetBrains Mono',
    'LXGW Neo XiHei',
}
config.font_size = 12
config.color_scheme = 'Monokai Pro (Gogh)'

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.95
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.term = 'wezterm'

config.enable_scroll_bar = true

return config
