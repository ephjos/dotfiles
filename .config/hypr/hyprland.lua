--
-- :optional
-- Optional machine specific config. Create an opt.lua file in this directory.
-- Override the below flags to change behavior.
--
pcall(require, "opt")

--
-- :variables
--
MONITOR_SCALE = MONITOR_SCALE or 1
FANCY         = FANCY or 1

MOD = "SUPER"
BAR = "qs -c bar ipc call bar "

TERMINAL = os.getenv("TERMINAL") or "ghostty"
BROWSER  = os.getenv("BROWSER") or "brave"

VOLUME_UP       = BAR .. "volume 5"
VOLUME_DOWN     = BAR .. "volume -5"
MUTE            = BAR .. "mute"     
MIC_VOLUME_UP   = BAR .. "micVolume 5"
MIC_VOLUME_DOWN = BAR .. "micVolume -5"
MIC_MUTE        = BAR .. "micMute"  
NOTIFICATIONS   = BAR .. "toggleCenter"  
DND             = BAR .. "toggleDnd"  

BRIGHTNESS_UP       = "brightnessctl -e4 -n2 set 5%+"
BRIGHTNESS_DOWN     = "brightnessctl -e4 -n2 set 5%-"
KBD_BRIGHTNESS_UP   = 'brightnessctl --device="smc::kbd_backlight" -e4 -n2 set 5%+'
KBD_BRIGHTNESS_DOWN = 'brightnessctl --device="smc::kbd_backlight" -e4 -n2 set 5%-'

MEDIA_NEXT      = "playerctl next"
MEDIA_PLAYPAUSE = "playerctl play-pause"
MEDIA_PREV      = "playerctl previous"

--
-- :config
--
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("qs -c bar")
  hl.exec_cmd("udiskie")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
end)
hl.exec_cmd(BAR .. "setAnimations " .. FANCY)

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = MONITOR_SCALE,
})

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
    col = {
      -- Hyprland border CM/FP16 shifts colors; compensate Gruvbox #fe8019 with #fe8112 (renders #fe8019). Track: github.com/hyprwm/Hyprland/discussions/11923
      active_border = "rgba(fe8112ff)", 
      -- active_border   = "rgba(fe8019ff)",
      inactive_border = "rgba(282828ff)",
    },
    resize_on_border = false,
    allow_tearing = false,
    layout = "master",
  },
  decoration = {
    rounding = 0,
    rounding_power = 0,
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = FANCY,
    },

    blur = {
      enabled = FANCY,
    },
  },
  animations = {
    enabled = FANCY,
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
  },
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

--
-- :animations
--
hl.animation({ leaf = "global",        enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1,  bezier = "default" })
hl.animation({ leaf = "workspaces",    enabled = false, speed = 1,  bezier = "default" })
hl.animation({ leaf = "workspacesIn",  enabled = false, speed = 1,  bezier = "default" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 1,  bezier = "default" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 1,  bezier = "default" })

--
-- :binds
--
hl.bind(MOD .. " + 1",      hl.dsp.focus({ workspace = 1 }))
hl.bind(MOD .. " + 2",      hl.dsp.focus({ workspace = 2 }))
hl.bind(MOD .. " + 3",      hl.dsp.focus({ workspace = 3 }))
hl.bind(MOD .. " + 4",      hl.dsp.focus({ workspace = 4 }))
hl.bind(MOD .. " + 5",      hl.dsp.focus({ workspace = 5 }))
hl.bind(MOD .. " + 6",      hl.dsp.focus({ workspace = 6 }))
hl.bind(MOD .. " + 7",      hl.dsp.focus({ workspace = 7 }))
hl.bind(MOD .. " + 8",      hl.dsp.focus({ workspace = 8 }))
hl.bind(MOD .. " + 9",      hl.dsp.focus({ workspace = 9 }))
hl.bind(MOD .. " + A",      function() hl.config({ general = { gaps_in = 0,  gaps_out = 0,  }, }) end)
hl.bind(MOD .. " + D",      hl.dsp.exec_cmd("rofi -show run"))
hl.bind(MOD .. " + EQUAL",  hl.dsp.exec_cmd(VOLUME_UP), { locked = true, repeating = true })
hl.bind(MOD .. " + F",      hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(MOD .. " + GRAVE",  hl.dsp.workspace.toggle_special("magic"))
hl.bind(MOD .. " + H",      hl.dsp.focus({ direction = "left" }))
hl.bind(MOD .. " + J",      hl.dsp.focus({ direction = "down" }))
hl.bind(MOD .. " + K",      hl.dsp.focus({ direction = "up" }))
hl.bind(MOD .. " + L",      hl.dsp.focus({ direction = "right" }))
hl.bind(MOD .. " + M",      hl.dsp.exec_cmd(MUTE), { locked = true })               
hl.bind(MOD .. " + MINUS",  hl.dsp.exec_cmd(VOLUME_DOWN), { locked = true, repeating = true })
hl.bind(MOD .. " + P",      hl.dsp.exec_cmd(MEDIA_PLAYPAUSE))
hl.bind(MOD .. " + Q",      hl.dsp.window.close())
hl.bind(MOD .. " + R",      hl.dsp.exec_cmd(TERMINAL .. " -e yazi"))
hl.bind(MOD .. " + RETURN", hl.dsp.exec_cmd(TERMINAL))
hl.bind(MOD .. " + W",      hl.dsp.exec_cmd(BROWSER))
hl.bind(MOD .. " + X",      hl.dsp.exec_cmd("hyprlock"))

hl.bind(MOD .. " + SHIFT + 1",     hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(MOD .. " + SHIFT + 2",     hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(MOD .. " + SHIFT + 3",     hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(MOD .. " + SHIFT + 4",     hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(MOD .. " + SHIFT + 5",     hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(MOD .. " + SHIFT + 6",     hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind(MOD .. " + SHIFT + 7",     hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind(MOD .. " + SHIFT + 8",     hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind(MOD .. " + SHIFT + 9",     hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind(MOD .. " + SHIFT + A",     function() hl.config({ general = { gaps_in = 10, gaps_out = 10, }, }) end)
hl.bind(MOD .. " + SHIFT + B",     hl.dsp.exec_cmd(BAR .. "toggle battery"))
hl.bind(MOD .. " + SHIFT + C",     hl.dsp.exec_cmd(BAR .. "toggle calendar"))
hl.bind(MOD .. " + SHIFT + D",     hl.dsp.exec_cmd("rofi -show ssh"))
hl.bind(MOD .. " + SHIFT + EQUAL", hl.dsp.exec_cmd(MIC_VOLUME_UP), { locked = true, repeating = true })
hl.bind(MOD .. " + SHIFT + GRAVE", hl.dsp.exec_cmd("e_rofi_emoji"))
hl.bind(MOD .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
hl.bind(MOD .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
hl.bind(MOD .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
hl.bind(MOD .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(MOD .. " + SHIFT + M",     hl.dsp.exec_cmd(MIC_MUTE), { locked = true })               
hl.bind(MOD .. " + SHIFT + N",     hl.dsp.exec_cmd(NOTIFICATIONS), { locked = true })               
hl.bind(MOD .. " + SHIFT + MINUS", hl.dsp.exec_cmd(MIC_VOLUME_DOWN), { locked = true, repeating = true })
hl.bind(MOD .. " + SHIFT + P",     hl.dsp.exec_cmd(BAR .. "toggle cpu"))
hl.bind(MOD .. " + SHIFT + R",     hl.dsp.exec_cmd(BAR .. "toggle memory"))
hl.bind(MOD .. " + SHIFT + S",     hl.dsp.exec_cmd("localsend"))
hl.bind(MOD .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + SHIFT + T",     hl.dsp.exec_cmd(BAR .. "toggle bluetooth"))
hl.bind(MOD .. " + SHIFT + U",     hl.dsp.exec_cmd(BAR .. "toggle updates"))
hl.bind(MOD .. " + SHIFT + V",     hl.dsp.exec_cmd(BAR .. "toggle volume"))
hl.bind(MOD .. " + SHIFT + W",     hl.dsp.exec_cmd(BAR .. "toggle network"))
hl.bind(MOD .. " + SHIFT + X",     hl.dsp.exec_cmd(BAR .. "toggle power"))
hl.bind(MOD .. " + SHIFT + Z",     hl.dsp.exec_cmd(DND), { locked = true })               

hl.bind(MOD .. " + CTRL + SHIFT + P",     hl.dsp.exec_cmd("e_hyprpicker"))

hl.bind(MOD .. " + CTRL + ALT + H", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + ALT + J", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + ALT + K", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
hl.bind(MOD .. " + CTRL + ALT + L", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })

hl.bind(MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(MOD .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

hl.bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd("hyprshot --output-folder $SCREENSHOTS --mode output --mode active"))
hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd("hyprshot --output-folder $SCREENSHOTS --mode region"))
hl.bind("CTRL + SHIFT + 5", hl.dsp.exec_cmd("e_rofi_screenshot"))

hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(VOLUME_DOWN),         { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(MIC_MUTE),            { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(MUTE),                { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(VOLUME_UP),           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(BRIGHTNESS_DOWN),     { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(BRIGHTNESS_UP),       { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(KBD_BRIGHTNESS_DOWN), { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd(KBD_BRIGHTNESS_UP),   { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(MEDIA_NEXT),      { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(MEDIA_PLAYPAUSE), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(MEDIA_PLAYPAUSE), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(MEDIA_PREV),      { locked = true })

--
-- :windows
--
hl.window_rule({ name = "brave-workspace",   match = { class = "brave-browser" }, workspace = "2", })
hl.window_rule({ name = "discord-workspace", match = { class = "discord"       }, workspace = "8", })
hl.window_rule({ name = "slack-workspace",   match = { class = "slack"         }, workspace = "8", })
hl.window_rule({ name = "zoom-workspace",    match = { class = "zoom"          }, workspace = "9", })

hl.window_rule({
  name = "special-workspace-windows",
  match = {
    workspace = "special:magic",
  },
  float = true,
  center = true,
  size = { "monitor_w * 0.5", "monitor_h * 0.5" },
})

hl.window_rule({
    match = {
        class = "^webcam$"
    },
    float = true,
    pin = true,
    size = { 360, 203 },
    -- bottom-right corner, 20px margin
    move = {
        "monitor_w-window_w-20",
        "monitor_h-window_h-20"
    },
    no_initial_focus = true
})

hl.window_rule({
    match = { title = ".*--center.*" },
    float = true,
    center = true,
    size = {
        "monitor_w * 0.5",
        "monitor_h * 0.5",
    },
})

