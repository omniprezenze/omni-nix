-- hyprland.lua — main entry point

local function getHostname()
    local bin = (io.open("/run/current-system/sw/bin/hostname", "r")
        and "/run/current-system/sw/bin/hostname")
        or "/bin/hostname"
    local f = io.popen(bin)
    local hostname = f:read("*a") or ""
    f:close()
    return string.gsub(hostname, "\n$", "")
end

local host = getHostname()

-- ─── Shared config ────────────────────────────────────────────────────────────
require("hyprland_common")
-- require("dms.layout")
-- require("dms.cursor")

-- ─── Host-specific monitors ───────────────────────────────────────────────────
if host == "omnipc" then
    -- Note: vrr, bitdepth, sdrbrightness, sdrsaturation are extra fields;
    -- verify they are accepted by your 0.55 build.
    hl.monitor({
        output        = "DP-1",
        mode          = "2560x1440@180",
        position      = "0x0",
        scale         = 1,
        vrr           = 1,
        bitdepth      = 10,
        sdrbrightness = 1.3,
        sdrsaturation = 1.3,
    })
    hl.monitor({
        output        = "DP-2",
        mode          = "1920x1080@120",
        position      = "-1920x0",
        scale         = 1,
        bitdepth      = 10,
        sdrbrightness = 1.3,
        sdrsaturation = 1.3,
    })

elseif host == "omnilaptop" then
    hl.monitor({
        output   = "eDP-1",
        mode     = "1920x1080@120",
        position = "0x0",
        scale    = 1,
    })

else
    -- Fallback: let Hyprland pick sensible defaults for any unknown host
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "auto",
    })
end