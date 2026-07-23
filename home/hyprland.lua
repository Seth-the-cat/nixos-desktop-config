---@module 'hl'

local terminal = "kitty"
local fileManager = "yazi"
local ipc = "noctalia msg"
local mainMod = "SUPER"

--###############
--## MONITORS ###
--###############

-- Single monitor fallback — update output name once you know it (e.g. "DP-1")
hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "120x-1200",
    scale    = 1,
})
hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "2560x70",
    transform= 1,
    scale    = 1,
})

--############################
--## ENVIRONMENT VARIABLES ###
--############################

hl.env("XCURSOR_THEME", "Win11Cursors")
hl.env("XCURSOR_SIZE", 28)
hl.env("HYPRCURSOR_THEME", "Win11Cursors")
hl.env("HYPRCURSOR_SIZE", 28)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", 1)
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("NIXOS_OZONE_WL", "1")  -- electron apps use wayland

--####################
--## LOOK AND FEEL ###
--####################

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
    },
    decoration = {
        rounding       = 20,
        rounding_power = 2,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },
    misc = {
        force_default_wallpaper  = 0,
        disable_splash_rendering = true,
        disable_hyprland_logo    = true,
    },
})

--############
--## INPUT ###
--############

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "dvorak",
        follow_mouse = 1,
        sensitivity  = 0,
    },
})

--##################
--## KEYBINDINGS ###
--##################

-- Noctalia
hl.bind(mainMod .. "+Space",  hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
hl.bind(mainMod .. "+S",      hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
hl.bind(mainMod .. "+comma",  hl.dsp.exec_cmd(ipc .. " settings-toggle"))
hl.bind(mainMod .. "+P",      hl.dsp.exec_cmd(ipc .. " bar-toggle"))
hl.bind(mainMod .. "+X",      hl.dsp.exec_cmd(ipc .. " panel-toggle session"))
hl.bind(mainMod .. "+V",      hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
hl.bind(mainMod .. "+L",      hl.dsp.exec_cmd(ipc .. " session lock"))
hl.bind(mainMod .. "+SHIFT+L", hl.dsp.exec_cmd(ipc .. " session lock-and-suspend"))
hl.bind("ALT+Tab",            hl.dsp.exec_cmd(ipc .. " window-switcher"))

-- Apps
hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+E",      hl.dsp.exec_cmd(fileManager))

-- Window management
hl.bind(mainMod .. "+Q",     hl.dsp.window.close())
hl.bind(mainMod .. "+M",     hl.dsp.exit())
hl.bind(mainMod .. "+F",     hl.dsp.window.float())

-- Focus
hl.bind(mainMod .. "+left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. "+right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. "+up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "+down",  hl.dsp.focus({ direction = "down" }))

-- Mouse window drag/resize
hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspaces
for i = 1, 9 do
    hl.bind(mainMod .. "+" .. i,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. "+SHIFT+" .. i,    hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. "+0",       hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. "+SHIFT+0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspaces
hl.bind(mainMod .. "+D",       hl.dsp.workspace.toggle_special("discord"))
hl.bind(mainMod .. "+grave",   hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. "+SHIFT+grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Volume (using Noctalia IPC where possible)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("SHIFT+XF86AudioMute",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),  { locked = true })

-- Media (via Noctalia)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(ipc .. " media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. " media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(ipc .. " media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(ipc .. " media previous"), { locked = true })

-- Screenshots (via Noctalia)
hl.bind("Print",       hl.dsp.exec_cmd(ipc .. " screenshot-region"))
hl.bind("SHIFT+Print", hl.dsp.exec_cmd(ipc .. " screenshot-fullscreen"))
hl.bind(mainMod .. "+Print", hl.dsp.exec_cmd(ipc .. " screenshot-fullscreen all"))

-- Replay buffer
hl.bind("Control_L" .. " + " .. "R", function()
    local obs_class = "com.obsproject.Studio"
    local obs_is_open = false

    -- 1. Grab all open client windows across your session
    local clients = hl.get_windows()
    -- 2. Loop through open windows to check if OBS exists
    for _, client in ipairs(clients) do
        if client.class == obs_class then
            obs_is_open = true
            break
        end
    end

    -- 3. Execute conditional logic
    if obs_is_open then
        -- If OBS is open anywhere, pass the hardware keys directly to it
        hl.dispatch(hl.dsp.pass({ window = "class:^" .. obs_class .. "$" }))
    else
        -- Fallback: Trigger your screen recorder plugin command if OBS is closed
        hl.dispatch(hl.dsp.exec_cmd(ipc .. " plugin noctalia/screen_recorder:service all replay-save"))
    end
end, { description = "Global OBS check for replay-save or passthrough" })

hl.bind("ALT" .. " + " .. "Control_L" .. " + " .. "R", function()
    local obs_class = "com.obsproject.Studio"
    local obs_is_open = false

    -- 1. Grab all open client windows across your session
    local clients = hl.get_windows()
    -- 2. Loop through open windows to check if OBS exists
    for _, client in ipairs(clients) do
        if client.class == obs_class then
            obs_is_open = true
            break
        end
    end

    -- 3. Execute conditional logic
    if obs_is_open then
        -- If OBS is open anywhere, pass the hardware keys directly to it
        hl.dispatch(hl.dsp.pass({ window = "class:^" .. obs_class .. "$" }))
    else
        -- Fallback: Trigger your screen recorder plugin command if OBS is closed
        hl.dispatch(hl.dsp.exec_cmd(ipc .. " plugin noctalia/screen_recorder:service all replay-toggle"))
    end
end, { description = "Global OBS check for replay-toggle or passthrough" })

--#############################
--## WINDOWS AND WORKSPACES ###
--#############################

-- Noctalia layer rules
hl.layer_rule({
    name  = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    no_anim      = true,
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

-- Discord special workspace
hl.window_rule({
    name  = "discord_special",
    match = { class = "discord|vesktop" },
    workspace = "special:discord",
})

-- General fixes
hl.window_rule({
    name  = "global_suppress_maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "xwayland_ghost_fix",
    match = { class = "^$", title = "^$", xwayland = 1, float = 1 },
    no_focus = true,
})

-- Picture in Picture
hl.window_rule({
    name  = "pip_tagging",
    match = { title = "^(Picture-in-Picture|Picture in picture)$" },
    tag   = "+pip",
})
hl.window_rule({
    tag              = "pip",
    float            = true,
    pin              = true,
    focus_on_activate  = false,
    no_initial_focus = true,
    size             = { "25%", "25%" },
    move             = { "72%", "7%" },
})

-- Float rules for common dialogs
hl.window_rule({
    name  = "float_dialogs",
    match = { title = "^(Open File|Save As|Open Folder)$" },
    float = true,
})

--################
--## AUTOSTART ###
--################

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("keepassxc")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nextcloud --background")
    hl.exec_cmd(fileManager .. " --daemon")
end)
-- Noctalia color templates
require("noctalia").apply_theme()
