local terminal = "kitty"
local file_manager = "nautilus"
local browser = "firefox"
local main_mod = "SUPER"

-- Monitors
hl.monitor({
	output = "DP-3",
	mode = "3840x2160@60",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "DP-2",
	mode = "highres",
	position = "0x0",
	scale = "auto",
})

-- Environment
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")

-- Main config
hl.config({
	input = {
		kb_layout = "us,us",
		kb_variant = ",intl",
		kb_model = "",
		kb_options = "grp:alt_shift_toggle",
		kb_rules = "",

		repeat_rate = 30,
		repeat_delay = 140,
		follow_mouse = 1,
	},

	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 3,
		col = {
			active_border = "rgba(33ccffee)",
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",
		allow_tearing = false,
	},

	decoration = {
		rounding = 0,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_splash_rendering = true,
		enable_swallow = true,
		swallow_regex = "^(" .. terminal .. ")$",
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	group = {
		col = {
			border_active = "rgba(33ccffee)",
		},
		groupbar = {
			font_size = 14,
			height = 20,
			indicator_height = 5,
			col = {
				-- active = "rgba(ff0000aa)",
			},
			gaps_out = 15,
		},
	},

	ecosystem = {
		no_donation_nag = true,
	},
})


-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("dunst")
	hl.exec_cmd("easyeffects --service-mode")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("waybar")
	hl.exec_cmd("hypridle")
	-- hl.exec_cmd("openrgb --startminimized --profile /home/liangw/.config/OpenRGB/everything-off.orp") -- maybe we should do this in a systemd unit?
end)

-- Window rules
hl.window_rule({
	name = "float-1password",
	match = {
		class = "1Password",
	},
	float = true,
})

-- Keybinds
--- launch commonly used programs
hl.bind(main_mod .. " + space", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + Y", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd("rofi -show combi -modes combi -combi-modes 'window,drun' -show-icons"))
hl.bind(main_mod .. " + p", hl.dsp.exec_cmd("1password"))

hl.bind(main_mod .. " + delete", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + SHIFT + delete", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "disable" }))
	end, { timeout = 200, type = "oneshot" })
end)

hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + SHIFT + Q", hl.dsp.window.kill())

hl.bind(main_mod .. " + V", hl.dsp.window.float())
hl.bind(main_mod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(main_mod .. " + SHIFT + p", hl.dsp.window.pseudo())

hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:#1" }))
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("#1"))
hl.workspace_rule({ workspace = "special:#1", gaps_out = 48 })

-- Group
hl.bind(main_mod .. " + G", hl.dsp.group.toggle())
hl.bind(main_mod .. " + L", hl.dsp.group.lock())
hl.bind(main_mod .. " + bracketleft", hl.dsp.group.prev())
hl.bind(main_mod .. " + bracketright", hl.dsp.group.next())

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp -d)" - | wl-copy]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim - | wl-copy]]))

-- Move focus
--- across windows
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "d" }))

--- across workspaces
hl.bind(main_mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(main_mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(main_mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(main_mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(main_mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(main_mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(main_mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(main_mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(main_mod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(main_mod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(main_mod .. " + tab", hl.dsp.focus({ workspace = "previous" }))

-- Move active window to workspace
hl.bind(main_mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(main_mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(main_mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(main_mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(main_mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(main_mod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(main_mod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(main_mod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(main_mod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(main_mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Workspace cycling
hl.bind(main_mod .. " + SHIFT + l", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(main_mod .. " + SHIFT + h", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move / resize
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace rules
local monitor_workspaces = {
	["DP-2"] = { "1", "2", "3", "4", "5" },
	["DP-3"] = { "6", "7", "8", "9", "10" },
}

for monitor, workspaces in pairs(monitor_workspaces) do
	for _, workspace in ipairs(workspaces) do
		hl.workspace_rule({
			workspace = workspace,
			monitor = monitor,
			persistent = true,
		})
	end
end
