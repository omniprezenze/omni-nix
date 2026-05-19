-- hyprland_common.lua

-- ─── Variables ────────────────────────────────────────────────────────────────
local terminal     = "ghostty"
local fileManager  = "thunar"
local menu         = "dms ipc spotlight toggle"
local silent_steam = "steam -silent"
local mainMod      = "SUPER"

-- ─── Autostart ────────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
    hl.exec_cmd("xrandr --output DP-1 --primary")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("corectrl")
    hl.exec_cmd("Telegram -startintray")
    hl.exec_cmd("keepassxc")
    hl.exec_cmd("qbittorrent")
    hl.exec_cmd(silent_steam)
    hl.exec_cmd("wayvnc")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

-- ─── General ──────────────────────────────────────────────────────────────────
hl.config({
    general = {
        col = {
            active_border   = "rgb(f5a97f)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },
})

-- ─── Layer Rules ──────────────────────────────────────────────────────────────
-- Note: hl.layer_rule() is inferred from the pattern; verify against 0.55 docs.
hl.layer_rule({
    name    = "no_anim_for_selection",
    no_anim = true,
    match   = { namespace = "^(dms)$" },
})

-- ─── Decoration ───────────────────────────────────────────────────────────────
hl.config({
    decoration = {
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 30,
            render_power = 5,
            offset       = "0 5",
            color        = "rgba(00000070)",
        },
        blur = {
            enabled  = false,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },
})

-- ─── Animations ───────────────────────────────────────────────────────────────
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- ─── Dwindle ──────────────────────────────────────────────────────────────────
-- pseudotile removed in 0.55; it is now only a dispatcher: hl.dsp.window.pseudo()
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- ─── Master ───────────────────────────────────────────────────────────────────
hl.config({
    master = {
        new_status = "master",
    },
})

-- ─── Input ────────────────────────────────────────────────────────────────────
hl.config({
    input = {
        kb_layout      = "us,ru",
        kb_options     = "altwin:menu_win,grp:ctrl_space_toggle",
        follow_mouse   = 1,
        accel_profile  = "flat",
        force_no_accel = true,
        sensitivity    = 1,
    },
})

-- ─── Devices ──────────────────────────────────────────────────────────────────
hl.device({
    name    = "sony-interactive-entertainment-wireless-controller-touchpad",
    enabled = false,
})
hl.device({
    name    = "wireless-controller-touchpad",
    enabled = false,
})

-- ─── Misc ─────────────────────────────────────────────────────────────────────
-- misc.vfr removed in 0.55; VFR is now managed internally.
hl.config({
    misc = {
        force_default_wallpaper = 2,
        middle_click_paste      = false,
    },
})

-- ─── Render ───────────────────────────────────────────────────────────────────
hl.config({
    render = {
        direct_scanout = true,
    },
})

-- ─── Keybinds ─────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Q",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F4",          hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + F12", hl.dsp.exec_cmd("de-logout"))
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",           hl.dsp.window.pseudo())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch & move workspaces 1–10 (key 0 maps to workspace 10 via i % 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Apps / misc
hl.bind(mainMod .. " + SPACE",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + U",          hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + U",  hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/monitor_lock.sh"))
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.exec_cmd("wayvncctl output-cycle"))

-- Screenshots / system
hl.bind(mainMod .. " + Print",    hl.dsp.exec_cmd("screenshotter area"))
hl.bind("Print",                   hl.dsp.exec_cmd("screenshotter monitor"))
hl.bind(mainMod .. " + backspace", hl.dsp.exec_cmd("wlogout --protocol layer-shell -b 4 -T 500 -B 500 -L 275"))
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("dms ipc call lock lock"))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize windows with mouse (bindm → mouse = true)
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio controls
-- bindel → { locked = true, repeating = true }
-- bindl  → { locked = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("mute_focus"),                     { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),            { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),              { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                  { locked = true })

-- ─── Window Rules ─────────────────────────────────────────────────────────────
local selector_size = "25% 25%"

-- Float on title match
hl.window_rule({ name = "float-file_progress", float = true, match = { title = "file_progress" } })
hl.window_rule({ name = "float-confirm",        float = true, match = { title = "confirm" } })
hl.window_rule({ name = "float-dialog",         float = true, match = { title = "dialog" } })
hl.window_rule({ name = "float-download",       float = true, match = { title = "download" } })
hl.window_rule({ name = "float-error",          float = true, match = { title = "error" } })
hl.window_rule({ name = "float-splash",         float = true, match = { title = "splash" } })
hl.window_rule({ name = "float-confirmreset",   float = true, match = { title = "confirmreset" } })
hl.window_rule({ name = "float-add_game",       float = true, match = { title = "Pick game to add" } })
hl.window_rule({ name = "float-extract",        float = true, match = { title = "Extract" } })

-- Float + selector size
hl.window_rule({ name = "float-select",     float = true, size = selector_size, match = { title = "^(Select.+)" } })
hl.window_rule({ name = "float-open_file",  float = true, size = selector_size, match = { title = "Open File" } })
hl.window_rule({ name = "float-open_folder",float = true, size = selector_size, match = { title = "Open Folder" } })
hl.window_rule({ name = "size-file_upload", float = true, size = selector_size, match = { title = "File Upload" } })
hl.window_rule({ name = "size-save_as",     float = true, size = selector_size, match = { title = "Save As" } })

-- Other floats
hl.window_rule({ name = "float-rename",       float = true, match = { title = "^(Rename.+)$" } })
hl.window_rule({ name = "float-branchdialog", float = true, match = { title = "branchdialog" } })
hl.window_rule({ name = "float-Lxappearance", float = true, match = { class = "Lxappearance" } })
hl.window_rule({ name = "float-calcure",      float = true, match = { title = "^(calcure)$" } })
hl.window_rule({ name = "float-PiP",          float = true, match = { title = "^(Picture-in-Picture)$" } })
hl.window_rule({ name = "float-qalculate",    float = true, match = { class = "^(qalculate-gtk)$" } })
hl.window_rule({ name = "float-blueman",      float = true, match = { class = "^(.blueman-manager-wrapped)$" } })

hl.window_rule({
    name  = "size-overskride",
    float = true,
    size  = "1234 1043",
    match = { title = "^(overskride)$" },
})

hl.window_rule({ name = "float-keepass",     float = true, match = { title = "^(Unlock Database - KeePassXC)$" } })
hl.window_rule({ name = "float-file_roller", float = true, match = { class = "file-roller" } })
hl.window_rule({ name = "float-media_viewer",float = true, match = { title = "^(Media viewer)$" } })
hl.window_rule({ name = "float-iwgtk",       float = true, match = { title = "iwgtk" } })
hl.window_rule({ name = "float-mangoJuice",  float = true, match = { title = "MangoJuice" } })
hl.window_rule({ name = "float-imv",         float = true, match = { class = "imv" } })
hl.window_rule({ name = "float-WoW",         float = true, match = { title = "^(World of Warcraft)$" } })

hl.window_rule({ name = "fullscreen-wlogout", fullscreen = true, match = { title = "wlogout" } })

-- Note: (monitor_w*N) (monitor_h*N) dynamic expressions — verify this string
-- form is accepted by 0.55, or replace with static pixel values if not.
hl.window_rule({
    name  = "size-volume_control",
    float = true,
    size  = "(monitor_w*0.4) (monitor_h*0.7)",
    match = { title = "^(Volume Control)$" },
})

hl.window_rule({
    name   = "size-steam_friend_list",
    float  = true,
    size   = "(monitor_w*0.25) (monitor_h*0.55)",
    center = true,
    match  = { class = "steam", title = "Friends List" },
})

hl.window_rule({
    name  = "selector_size-add_game",
    float = true,
    size  = selector_size,
    match = { title = "^(Add Non-Steam Game)" },
})

-- Tile rules
hl.window_rule({ name = "pob-tile",       tile = true,        match = { initial_title = "^(Path of Building.*)$" } })
hl.window_rule({ name = "pob-linux-fix",  force_rgbx = true,  match = { initial_title = "^(.*Path of Building.*)$" } })
hl.window_rule({ name = "battlenet-tile", tile = true,        match = { title = "^(Battle.net)$" } })

hl.window_rule({
    name  = "tui-size",
    float = true,
    size  = "1500 940",
    match = { title = "^(.*-tui)$" },
})

-- Idle inhibit
hl.window_rule({ name = "mpv-inhibit",     idle_inhibit = "focus",  match = { class = "mpv" } })
hl.window_rule({ name = "firefox-inhibit", idle_inhibit = "always", match = { class = "^(firefox)", fullscreen = true } })

-- Fullscreen rules
-- Note: two rules shared the name "windowrule-41" in the original; renamed to avoid collision.
hl.window_rule({ name = "fullscreen-WoW",          fullscreen = true, match = { title = "^(World of Warcraft)$" } })
hl.window_rule({ name = "fullscreen-steam-elden",  fullscreen = true, match = { class = "steam_app_1422450" } })
hl.window_rule({ name = "genshinimpact-fullscreen", fullscreen = true, match = { class = "genshinimpact.exe" } })
hl.window_rule({ name = "Endfield-fullscreen",      fullscreen = true, match = { title = "Endfield" } })

-- Generic fixes
hl.window_rule({ name = "windowrule-maximize", suppress_event = "maximize", match = { class = ".*" } })

hl.window_rule({
    name     = "windowrule-XWayland-fix",
    no_focus = true,
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
})


hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2" })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
