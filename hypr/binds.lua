-- ░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓███████▓▒░ 
-- ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▓█▓▒░        
-- ░▒▓█▓▒░▒▓█▓▒░ ▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▓█▓▒░        
-- ░▒▓████▓▒░░   ▒▓██████▓▒░  ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░  
-- ░▒▓█▓▒░▒▓█▓▒░ ▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░ 
-- ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░ 
-- ░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░  ░▒▓█▓▒░   ░▒▓███████▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▓███████▓▒░  

--local hl
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi --show drun --sort-order alphabetical"


local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- +-------------------------+
-- |  BIND DISABLING EXAMPLE |
-- +-------------------------+
-- local bindName = hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(commandName))
-- bindName:set_enabled(false)

-- https://wiki.hypr.land/Configuring/Basics/Binds/
--
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(       "ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

hl.bind(mainMod .. " + L",  hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("hyprlock & sleep 0.5; systemctl suspend"))
hl.bind(mainMod .. " + F7", hl.dsp.dpms({action = "toggle"}))



-- Clipboard manager (cliphist)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu --pre-display-cmd \"echo '%s' | cut -f 2\" | cliphist decode | wl-copy"))
-- Active window opacity toggle
-- v1
hl.bind(mainMod .. " + O", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))
-- v2
--hl.bind(mainMod .. " + O", function()
--    hl.dispatch(hl.dsp.window.tag({ tag = "opaque" }))
--end)


-- POWER PLANS
--hl.bind(mainMod, " + 1", hl.dsp.exec_cmd("~/.config/waybar/scripts/power-plan-change.sh eco"))
--hl.bind(mainMod, " + 2", hl.dsp.exec_cmd("~/.config/waybar/scripts/power-plan-change.sh balanced"))
--hl.bind(mainMod, " + 3", hl.dsp.exec_cmd("~/.config/waybar/scripts/power-plan-change.sh performance"))
--hl.bind(mainMod, " + H", hl.dsp.exec_cmd("~/config/waybar/scripts/hypridle-toogle.sh"))


-- Move focus (Example)
-- hl.bind(mainMod .. " + KEY",  hl.dsp.focus({ direction = "left" }))
-- // direction = { "left", "right", "up", "down" }


-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down",         hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + mouse_up",           hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("ALT + TAB",                        hl.dsp.focus({ workspace = "previous" }))


-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + D",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic" }))


-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                 { locked = true, repeating = true })

hl.bind(mainMod .. " + up",    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + down",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + left",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind(mainMod .. " + right", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })


-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-- Audacious
hl.bind("CTRL + F1",    hl.dsp.exec_cmd("playerctl -p audacious previous"),   { locked = true })
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd("playerctl -p audacious play-pause"), { locked = true })
hl.bind("CTRL + F2",    hl.dsp.exec_cmd("playerctl -p audacious next"),       { locked = true })


-- Restarters
hl.bind(mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd(
        "killall waybar; waybar -c ~/.config/waybar/topbar/config.jsonc -s ~/.config/waybar/topbar/style.css & disown; waybar -c ~/.config/waybar/bottombar/config.jsonc -s ~/.config/waybar/bottombar/style.css & disown"
    )
)
hl.bind(mainMod .. " + SHIFT + P",
    hl.dsp.exec_cmd(
        "~/OWN/PyDesktop/main.py & disown"
    )
)

-- Btop quick launch
hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("kitty -e --class \"btop-primary\" btop -p 1"))


-- Screenshots / Video capture
hl.bind("F12", hl.dsp.exec_cmd("~/Env/Scripts/f12screenshot.sh"))                                                                       -- Screen and save in file
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))                                                              -- Copy area to clipboard
hl.bind(mainMod .. " + CTRL + S",  hl.dsp.exec_cmd("grimblast --freeze save output - | satty --disable-notifications --filename -"))    -- Fullscreen freeze and overlay markup
hl.bind(           "PRINT",        hl.dsp.exec_cmd("grim - | wl-copy"), { locked= true })                                               -- Fullscreen copy to clipboard
hl.bind(mainMod .. " + F10",       hl.dsp.exec_cmd("~/Env/Scripts/toogle-video-record.sh"))                                             -- Video record toogle

