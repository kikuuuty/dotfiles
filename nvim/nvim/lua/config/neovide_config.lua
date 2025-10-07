--
-- Display
--


-- Font
--vim.o.guifont = "Consolas:h10"
vim.o.guifont = "FiraMono Nerd Font Mono:h10"
--vim.o.guifont = "JetBrainsMonoNL NFM:h10"

-- Line spacing
--vim.opt.linespace = 0

-- Scale
--vim.g.neovide_scale_factor = 1.0

-- Text Gamma and Contrast
--vim.g.neovide_text_gamma = 0.0
--vim.g.neovide_text_contrast = 0.5

-- Padding
--vim.g.neovide_padding_top = 0
--vim.g.neovide_padding_bottom = 0
--vim.g.neovide_padding_right = 0
--vim.g.neovide_padding_left = 0

-- Title Bar Color
local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
if hl and hl.bg then
    vim.g.neovide_title_background_color = string.format("#%06x", hl.bg)
end
if hl and hl.fg then
    vim.g.neovide_title_text_color = string.format("#%06x", hl.fg)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local h = vim.api.nvim_get_hl(0, { name = "Normal" })
    if h then
      if h.bg then vim.g.neovide_title_background_color = string.format("#%06x", h.bg) end
      if h.fg then vim.g.neovide_title_text_color       = string.format("#%06x", h.fg) end
    end
  end,
})


-- Floating Blur Amount
--vim.g.neovide_floating_blur_amount_x = 2.0
--vim.g.neovide_floating_blur_amount_y = 2.0

-- Floating Shadow
--vim.g.neovide_floating_shadow = true
--vim.g.neovide_floating_z_height = 10
--vim.g.neovide_light_angle_degrees = 45
--vim.g.neovide_light_radius = 5

-- Transparency
--vim.g.neovide_opacity = 1.0
--vim.g.neovide_normal_opacity = 1.0                      -- ウィンドウの半透明度

-- Position Animation Length
--vim.g.neovide_position_animation_length = 0.15

-- Scroll Animation Length
vim.g.neovide_scroll_animation_length = 0.233

-- Far scroll lines
--vim.g.neovide_scroll_animation_far_lines = 1

-- Hiding the mouse when typing
--vim.g.neovide_hide_mouse_when_typing = false

-- Underline automatic scaling
--vim.g.neovide_underline_stroke_scale = 1.0

-- Theme
--vim.g.neovide_theme = 'auto'

-- Lyaer grouping
--vim.g.experimental_layer_grouping = false


--
-- Functionality
--


-- Refresh Rate
-- This settings is only effective when not using vsync, for example by
-- passing --no-vsync on the commandline
--vim.g.neovide_refresh_rate = 60 

-- Idle Refresh Rate
--vim.g.neovide_refresh_rate_idle = 5

-- No Idle
vim.g_neovide_no_idle = false

-- Confirm Quit
--vim.g.neovide_confirm_quit = true

-- Detach On Quit
-- This option changes the closing behavior of Neovide when it's used to connect to a remote Neovim instance. 
--vim.g.neovide_detach_on_quit = 'always_quit'

-- Fullscreen
--vim.g.neovide_fullscreen = false

-- Remember Previous Window Size
--vim.g.neovide_remember_window_size = true

-- Profiler
--vim.g.neovide_profiler = false

-- Cursor hack
--vim.g.neovide_cursor_hack = true


--
-- Input Settings
--


-- IME
-- insertモードの切り替えやコマンドラインの入力切替でIMEをオンオフする
-- im-select.nvimで設定するのでオフ
--local function set_ime(args)
--    if args.event:match("Enter$") then
--        vim.g.neovide_input_ime = true
--    else
--        vim.g.neovide_input_ime = false
--    end
--end
--
--local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })
--
--vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
--    group = ime_input,
--    pattern = "*",
--    callback = set_ime
--})
--
--vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
--    group = ime_input,
--    pattern = "[/\\?]",
--    callback = set_ime
--})

-- Touch Deadzone
--vim.g.neovide_touch_deadzone = 6.0

-- Touch Drag Timeout
--vim.g.neovide_touch_drag_timeout = 0.17



-- 
-- Cursor Settings
--


-- Animation Length
--vim.g.neovide_cursor_animation_length = 0.150

-- Short Animation Length
--vim.g.neovide_cursor_short_animation_length = 0.04

-- Animation Trail Size
--vim.g.neovide_cursor_trail_size = 1.0 -- Range 0.0 to 1.0

-- Antialiasing
--vim.g.neovide_cursor_antialiasing = true

-- Animate in insert mode
--vim.g.neovide_cursor_animate_in_insert_mode = true

-- Unfocused Outline Width
--vim.g.neovide_cursor_unfocused_outline_width = 0.125

-- Animate cursor blink
--vim.g.neovide_cursor_smooth_blink = false


-- 
-- Cursor Particles
--


--vim.g.neovide_cursor_vfx_mode = "railgun"
--vim.g.neovide_cursor_vfx_mode = "torpedo"
--vim.g.neovide_cursor_vfx_mode = "pixiedust"
--vim.g.neovide_cursor_vfx_mode = "sonicboom"
--vim.g.neovide_cursor_vfx_mode = "ripple"
--vim.g.neovide_cursor_vfx_mode = "wireframe"


-- 
-- Particle Settings
--


-- Particle Opacity
--vim.g.neovide_cursor_vfx_opacity = 200.0

-- Particle Linetime
--vim.g.neovide_cursor_vfx_particle_lifetime = 0.5
--vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.2

-- Particle Density
--vim.g.neovide_cursor_vfx_particle_density = 0.7

-- Particle Speed
--vim.g.neovide_cursor_vfx_particle_speed = 10.0

-- Particle Phase
-- Only for the vfx mode.railgun
--vim.g.neovide_cursor_vfx_particle_phase = 1.5

-- Particle Curl
-- Only for the vfx mode.railgun
--vim.g.neovide_cursor_vfx_particle_curl = 1.0


