-- Hyprland configuration, Lua format (Hyprland >= 0.55).
--
-- hyprlang (hyprland.conf) is deprecated upstream and gets dropped in a
-- release soon after 0.56 -- see https://hypr.land/news/26_lua/
--
-- Docs: https://wiki.hypr.land/Configuring/Start/
-- API stubs for LSP autocompletion: /usr/share/hypr/stubs/

---------------------
---- MY PROGRAMS ----
---------------------

local mainMod  = "SUPER"
local terminal = "footclient"
local browser  = "firefox"
local drawer   = "nwg-drawer -mb 10 -mr 10 -ml 10 -mt 10"
local launcher = "pkill wofi || wofi --normal-window --show drun --allow-images"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_SIZE", "24")

-------------------
---- AUTOSTART ----
-------------------

-- Runs on session start only, not on config reload (the old `exec-once`).
hl.on("hyprland.start", function()
    -- Status bar and notifications
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("nm-applet --indicator")

    -- Terminal server backing footclient
    hl.exec_cmd("foot --server")

    -- Polkit agent and keyring
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")

    -- GTK settings and X resources for XWayland clients
    hl.exec_cmd("apply-gsettings")
    hl.exec_cmd("xrdb -load ~/.Xresources")

    -- Idle handling / lock
    hl.exec_cmd("hypridle")

    -- Colour temperature based on location
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
    hl.exec_cmd("gammastep")

    -- Semi-automated monitor layout detection
    hl.exec_cmd("kanshi")
end)

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout          = "gb,pl",
        kb_options         = "grp:alt_shift_toggle",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0, -- -1.0 - 1.0, 0 means no modification

        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
        },
    },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(8f00ffee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size    = 5,
            passes  = 1,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    misc = {
        disable_hyprland_logo = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

-----------------
---- LAYOUTS ----
-----------------

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },
})

----------------
---- GROUPS ----
----------------

hl.config({
    group = {
        col = {
            border_active          = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            border_inactive        = "rgba(595959aa)",
            border_locked_active   = "rgba(f8bd96ee)",
            border_locked_inactive = "rgba(424242aa)",
        },

        -- Groupbar = the "tab strip" for grouped windows
        groupbar = {
            enabled = false,
        },
    },
})

------------------
---- GESTURES ----
------------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({
    fingers   = 3,
    direction = "down",
    action    = function() hl.exec_cmd(drawer) end,
})

----------------------
---- WINDOW RULES ----
----------------------

-- Rules are evaluated top to bottom and the last match wins, so keep the
-- floating rule below the per-class ones.
hl.window_rule({ match = { class = "^(thunar)$" },  opacity = "0.85 override 0.85 override" })
hl.window_rule({ match = { class = "^(gedit)$" },   opacity = "0.85 override 0.85 override" })
hl.window_rule({ match = { class = "^(catfish)$" }, opacity = "0.85 override 0.85 override" })
hl.window_rule({ match = { class = "^(wofi)$" },    stay_focused = true })

hl.window_rule({ match = { float = true }, opacity = "0.85 0.85" })

-- Assign certain applications to specific workspaces
hl.window_rule({ match = { class = "^(firefox)$" },                        workspace = "1 silent" })
hl.window_rule({ match = { class = "^(Spotify)$" },                        workspace = "8 silent" })
hl.window_rule({ match = { class = "^(org.mozilla.Thunderbird)$" },        workspace = "9 silent" })
hl.window_rule({ match = { class = "^(org\\.telegram\\.desktop)$" },       workspace = "10 silent" })
hl.window_rule({ match = { class = "^([Mm]attermost([.-][Dd]esktop)?)$" }, workspace = "10 silent" })

---------------------
---- LAYER RULES ----
---------------------

-- ignore_alpha 0 makes blur skip fully transparent pixels
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "wofi" }, blur = true })
hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, blur = true }) -- nwg-drawer

---------------------
---- KEYBINDINGS ----
---------------------

-- Session / window management
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("nwgbar"))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
-- Fullscreen internally, but tell the client it is not: stops Chromium-based
-- apps from entering presentation mode.
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))

-- Launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("foot -e ranger"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("emote"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(drawer))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd(launcher), { release = true })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("killall -9 wpaperd"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.local/bin/hypr-monitor-chooser"))

-- mainMod + function keys
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("thunderbird"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("geany"))
hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("github-desktop"))
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("gparted"))
hl.bind(mainMod .. " + F7", hl.dsp.exec_cmd("inkscape"))
hl.bind(mainMod .. " + F8", hl.dsp.exec_cmd("blender"))
hl.bind(mainMod .. " + F9", hl.dsp.exec_cmd("meld"))
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("joplin-desktop"))
hl.bind(mainMod .. " + F11", hl.dsp.exec_cmd("snapper-tools"))
hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("galculator"))

-- Move focus and windows with arrow keys or vim keys
local directions = {
    { keys = { "left", "H" },  dir = "left" },
    { keys = { "right", "L" }, dir = "right" },
    { keys = { "up", "K" },    dir = "up" },
    { keys = { "down", "J" },  dir = "down" },
}

for _, d in ipairs(directions) do
    for _, key in ipairs(d.keys) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = d.dir }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = d.dir }))
    end
end

-- Workspaces:
--   mainMod + [0-9]          -> switch
--   ALT + SHIFT + [0-9]      -> move active window there and follow
--   mainMod + SHIFT + [0-9]  -> move active window there silently
for i = 1, 10 do
    local key = i % 10 -- workspace 10 sits on the "0" key
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Switch workspaces back and forth
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Special workspace (scratchpad): send the active window there and show it
hl.bind(mainMod .. " + SHIFT + S", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

-- Window groups (tabbed containers)
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.group.lock())

-- Volume (laptops mostly)
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd([[pamixer --decrease 5; notify-send " Volume: "$(pamixer --get-volume) -t 500]]))
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd([[pamixer --increase 5; notify-send " Volume: "$(pamixer --get-volume) -t 500]]))
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd([[pamixer --toggle-mute; notify-send " Volume: Toggle-mute" -t 500]]))
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd([[pactl set-source-mute @DEFAULT_SOURCE@ toggle; notify-send "System Mic: Toggle-mute" -t 500]]))

-- Backlight
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -c backlight set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -c backlight set +5%"))

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("playerctl next"))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.exec_cmd("playerctl previous"))

-- Screenshots, all piped into swappy
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_window.sh"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_display.sh"))

-----------------------
---- RESIZE SUBMAP ----
-----------------------

hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    local steps = {
        { keys = { "right", "L" }, x = 50,  y = 0 },
        { keys = { "left", "H" },  x = -50, y = 0 },
        { keys = { "up", "K" },    x = 0,   y = -50 },
        { keys = { "down", "J" },  x = 0,   y = 50 },
    }

    for _, step in ipairs(steps) do
        for _, key in ipairs(step.keys) do
            hl.bind(key, hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
        end
    end

    -- Back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)
