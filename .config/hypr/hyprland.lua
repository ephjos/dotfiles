-- Converted from hyprland.conf to Hyprland Lua configuration.

----------------
--- MONITORS ---
----------------

local use_retina = os.getenv("HYPRLAND_RETINA") == "1"

if use_retina then
  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.6,
  })
else
  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
  })
end

---------------------
--- SET VARIABLES ---
---------------------

local fancy = os.getenv("HYPRLAND_FANCY") == "1"

-- Gruvbox Dark
local bg0_h = "rgba(1d2021ff)"
local bg0   = "rgba(282828ff)"
local bg0_s = "rgba(32302fff)"
local bg1   = "rgba(3c3836ff)"
local bg2   = "rgba(504945ff)"
local bg3   = "rgba(665c54ff)"
local bg4   = "rgba(7c6f64ff)"

local fg0 = "rgba(fbf1c7ff)"
local fg1 = "rgba(ebdbb2ff)"
local fg2 = "rgba(d5c4a1ff)"
local fg3 = "rgba(bdae93ff)"
local fg4 = "rgba(a89984ff)"

local red    = "rgba(cc241dff)"
local green  = "rgba(98971aff)"
local yellow = "rgba(d79921ff)"
local blue   = "rgba(458588ff)"
local purple = "rgba(b16286ff)"
local aqua   = "rgba(689d6aff)"
local orange = "rgba(d65d0eff)"
local gray   = "rgba(928374ff)"

local bright_red    = "rgba(fb4934ff)"
local bright_green  = "rgba(b8bb26ff)"
local bright_yellow = "rgba(fabd2fff)"
local bright_blue   = "rgba(83a598ff)"
local bright_purple = "rgba(d3869bff)"
local bright_aqua   = "rgba(8ec07cff)"
local bright_orange = "rgba(fe8019ff)"
local bright_gray   = "rgba(a89984ff)"

local dim_red    = "rgba(9d0006ff)"
local dim_green  = "rgba(79740eff)"
local dim_yellow = "rgba(b57614ff)"
local dim_blue   = "rgba(076678ff)"
local dim_purple = "rgba(8f3f71ff)"
local dim_aqua   = "rgba(427b58ff)"
local dim_orange = "rgba(af3a03ff)"

local border = 2
local gaps = 20
local mod = "SUPER"

-- Programs
local terminal = os.getenv("TERMINAL") or "ghostty"
local browser = os.getenv("BROWSER") or "firefox"
local wifi = terminal .. " -e nmtui"
local top = terminal .. " -e btop -p 0"
local fileManager = terminal .. " -e lf"
local lock = "hyprlock"

-- Scripts
local volume_up = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
local volume_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
local mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
local mic_mute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

local brightness_up = "brightnessctl -e4 -n2 set 5%+"
local brightness_down = "brightnessctl -e4 -n2 set 5%-"
local kbd_brightness_up = 'brightnessctl --device="smc::kbd_backlight" -e4 -n2 set 5%+'
local kbd_brightness_down = 'brightnessctl --device="smc::kbd_backlight" -e4 -n2 set 5%-'

local media_next = "playerctl next"
local media_playpause = "playerctl play-pause"
local media_prev = "playerctl previous"

local menu = "rofi -show run"
local ssh_menu = "rofi -show ssh"
local emoji_menu = "e_rofi_emoji"
local power_menu = "e_rofi_power"
local mount = "e_rofi_mount"
local unmount = "e_rofi_unmount"
local screenshot = "e_rofi_screenshot"
local colorpicker = "e_hyprpicker"

local no_gaps = 'hyprctl --batch "keyword general:gaps_in 0 ; keyword general:gaps_out 0"'
local set_gaps = string.format(
    'hyprctl --batch "keyword general:gaps_in %d ; keyword general:gaps_out %d"',
    gaps,
    gaps
)

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)

-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = border,

        col = {
            active_border = orange,
            inactive_border = bg0,
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        rounding_power = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = fancy,
        },

        blur = {
            enabled = fancy,
        },
    },

    animations = {
        enabled = fancy,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo = true,
    },
})

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})
hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})
hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})
hl.curve("almostLinear", {
    type = "bezier",
    points = { { 0.5, 0.5 }, { 0.75, 1 } },
})
hl.curve("quick", {
    type = "bezier",
    points = { { 0.15, 0 }, { 0.1, 1 } },
})

hl.animation({ leaf = "global",        enabled = true,  speed = 10, bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 2,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 2,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 2,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2,  bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 2,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 2,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 2,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 2,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 2,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 2,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 2,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 2,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = false, speed = 2,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = false, speed = 2,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 2,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 2,  bezier = "quick" })

-------------
--- INPUT ---
-------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:escape",
        kb_rules = "",
        repeat_delay = 300,
        repeat_rate = 50,
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-------------------
--- KEYBINDINGS ---
-------------------

hl.bind(mod .. " + A", hl.dsp.exec_cmd(no_gaps))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + R", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + EQUAL", hl.dsp.exec_cmd(volume_up), { locked = true, repeating = true })
hl.bind(mod .. " + MINUS", hl.dsp.exec_cmd(volume_down), { locked = true, repeating = true })
hl.bind(mod .. " + X", hl.dsp.exec_cmd(lock))
hl.bind(mod .. " + P", hl.dsp.exec_cmd(media_playpause))

hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd(set_gaps))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd(ssh_menu))
hl.bind(mod .. " + SHIFT + GRAVE", hl.dsp.exec_cmd(emoji_menu))
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd(top))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd(wifi))
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd(power_menu))
hl.bind(mod .. " + SHIFT + EQUAL", hl.dsp.exec_cmd(brightness_up), { locked = true, repeating = true })
hl.bind(mod .. " + SHIFT + MINUS", hl.dsp.exec_cmd(brightness_down), { locked = true, repeating = true })
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd(mute), { locked = true })
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd(mic_mute), { locked = true })
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd(colorpicker))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind(mod .. " + CTRL + ALT + H", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + ALT + J", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + ALT + K", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + ALT + L", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })

for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(
        mod .. " + SHIFT + " .. i,
        hl.dsp.window.move({ workspace = i, follow = false })
    )
end

hl.bind(mod .. " + F9", hl.dsp.exec_cmd(mount))
hl.bind(mod .. " + F10", hl.dsp.exec_cmd(unmount))

hl.bind(mod .. " + GRAVE", hl.dsp.workspace.toggle_special("magic"))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("CTRL + SHIFT + 5", hl.dsp.exec_cmd(screenshot))

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume_down), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(mic_mute), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(mute), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume_up), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightness_down), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightness_up), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(kbd_brightness_down), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd(kbd_brightness_up), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd(media_next), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(media_playpause), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(media_playpause), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(media_prev), { locked = true })

------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

hl.window_rule({
    name = "firefox-workspace",
    match = { class = "firefox" },
    workspace = "2",
})

hl.window_rule({
    name = "discord-workspace",
    match = { class = "discord" },
    workspace = "8",
})

hl.window_rule({
    name = "slack-workspace",
    match = { class = "slack" },
    workspace = "8",
})

hl.window_rule({
    name = "zoom-workspace",
    match = { class = "zoom" },
    workspace = "9",
})

hl.window_rule({
    name = "special-workspace-windows",
    match = {
        float = true,
        workspace = "s[true]",
    },
    center = true,
    size = "50% 50%",
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
