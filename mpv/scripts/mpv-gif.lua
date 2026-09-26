-- Original by Ruin0x11
-- Ported to Windows by Scheliux, Dragoner7
-- Re-ported to Linux (paths, temp dir, auto-mkdir)

-- Create animated GIFs with mpv
-- Requires ffmpeg.
-- Adapted from http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html
-- Usage: "b" to set start frame, "B" to set end frame, "Ctrl+b" to create.

require 'mp.options'
local msg = require 'mp.msg'
local utils = require 'mp.utils'

local options = {
    dir = "~/Pictures/gifs",
    rez = 600,
    fps = 15,
    colors = 128,        -- fewer colors = smaller file, 256 max
    gifsicle = true,      -- run gifsicle -O3 --lossy after encoding, if installed
    gifsicle_lossy = 40,  -- higher = smaller file, more artifacts (0 disables lossy, keeps -O3 only)
}

read_options(options, "gif")

local fps

-- Check for invalid fps values
if options.fps ~= nil and options.fps >= 1 and options.fps < 30 then
    fps = options.fps
else
    fps = 15
end

-- Set this to the filters to pass into ffmpeg's -vf option.
filters = string.format("fps=%s,scale='trunc(ih*dar/2)*2:trunc(ih/2)*2',setsar=1/1,scale=%s:-1:flags=spline", fps, options.rez) --change spline to lanczos depending on preference

-- Expand a leading ~ to $HOME ourselves (mp.command_native expand-path
-- returned an empty string in some setups, so don't rely on it)
local function expand_home(path)
    local home = os.getenv("HOME") or ""
    if path:sub(1, 1) == "~" then
        return home .. path:sub(2)
    end
    return path
end

output_directory = expand_home(options.dir)
if output_directory == nil or output_directory == "" then
    output_directory = (os.getenv("HOME") or "/tmp") .. "/Pictures/gifs"
end

start_time = -1
end_time = -1
local is_busy = false

-- Use the actual OS temp dir instead of Windows' %TEMP%
local tmp_dir = os.getenv("TMPDIR") or "/tmp"
palette = tmp_dir .. "/mpv-gif-palette.png"

function make_gif_with_subtitles()
    make_gif_internal(true)
end

function make_gif()
    make_gif_internal(false)
end

function table_length(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

function ensure_output_dir()
    -- mkdir -p is a no-op if the directory already exists
    os.execute(string.format('mkdir -p "%s"', output_directory))
end

function make_gif_internal(burn_subtitles)
    if is_busy then
        mp.osd_message("Already creating a GIF, please wait...")
        return
    end

    local start_time_l = start_time
    local end_time_l = end_time
    if start_time_l == -1 or end_time_l == -1 or start_time_l >= end_time_l then
        mp.osd_message("Invalid start/end time.")
        return
    end

    local duration = end_time_l - start_time_l
    if duration > (options.max_duration or 20) then
        mp.osd_message(string.format(
            "Clip is %.1fs long (max %.0fs) - this will be a big file. Press again to force.",
            duration, options.max_duration or 20))
        -- allow forcing by re-pressing while start/end stay the same
        if not force_confirmed then
            force_confirmed = true
            return
        end
    end
    force_confirmed = false

    is_busy = true
    mp.osd_message("Creating GIF...")
    ensure_output_dir()

    -- shell escape (still needed for ffmpeg's own filter-string syntax, e.g. subtitles=path)
    function esc_for_sub(s)
        s = string.gsub(s, [[\]], [[/]])
        s = string.gsub(s, '"', '"\\""')
        s = string.gsub(s, ":", [[\\:]])
        s = string.gsub(s, "'", [[\\']])
        return s
    end

    local pathname = mp.get_property("path", "")
    local trim_filters = filters

    local position = start_time_l

    if burn_subtitles then
        -- Determine currently active sub track
        local i = 0
        local tracks_count = mp.get_property_number("track-list/count")
        local subs_array = {}

        while i < tracks_count do
            local type = mp.get_property(string.format("track-list/%d/type", i))
            local selected = mp.get_property(string.format("track-list/%d/selected", i))

            if type == "sub" then
                local length = table_length(subs_array)
                subs_array[length] = selected == "yes"
            end
            i = i + 1
        end

        if table_length(subs_array) > 0 then
            local correct_track = 0
            for index, is_selected in pairs(subs_array) do
                if (is_selected) then
                    correct_track = index
                end
            end
            trim_filters = trim_filters .. string.format(",subtitles=%s:si=%s", esc_for_sub(pathname), correct_track)
        end
    end

    local filename = mp.get_property("filename/no-ext")
    local file_path = output_directory .. "/" .. filename

    -- increment filename
    local gifname = nil
    for i = 0, 999 do
        local fn = string.format('%s_%03d.gif', file_path, i)
        if not file_exists(fn) then
            gifname = fn
            break
        end
    end
    if not gifname then
        mp.osd_message('No available filenames!')
        is_busy = false
        return
    end

    local copyts = ""
    if burn_subtitles then
        copyts = "-copyts"
    end

    -- Run the two ffmpeg passes as async subprocesses so mpv doesn't freeze
    -- -hwaccel auto lets ffmpeg use GPU decode instead of pure CPU decode
    local palette_args = {
        "ffmpeg", "-v", "warning", "-hwaccel", "auto", "-ss", tostring(position), "-t", tostring(duration),
        "-i", pathname, "-vf", filters .. string.format(",palettegen=max_colors=%d:stats_mode=diff", options.colors), "-update", "1", "-frames:v", "1", "-y", palette,
    }

    mp.osd_message("Creating GIF: building palette...")
    mp.command_native_async({
        name = "subprocess",
        args = palette_args,
        playback_only = false,
    }, function(success, result, error)
        if not success or (result and result.status ~= 0) then
            mp.osd_message("Error creating palette, check terminal for more info.")
            is_busy = false
            return
        end

        local gif_args = {
            "ffmpeg", "-v", "warning", "-hwaccel", "auto", "-ss", tostring(position),
        }
        if burn_subtitles then table.insert(gif_args, "-copyts") end
        table.insert(gif_args, "-t")
        table.insert(gif_args, tostring(duration))
        table.insert(gif_args, "-i")
        table.insert(gif_args, pathname)
        table.insert(gif_args, "-i")
        table.insert(gif_args, palette)
        table.insert(gif_args, "-lavfi")
        table.insert(gif_args, trim_filters .. " [x]; [x][1:v] paletteuse=dither=sierra2_4a:diff_mode=rectangle")
        table.insert(gif_args, "-y")
        table.insert(gif_args, gifname)

        mp.osd_message("Creating GIF: encoding...")
        mp.command_native_async({
            name = "subprocess",
            args = gif_args,
            playback_only = false,
        }, function(success2, result2, error2)
            if not (success2 and result2 and result2.status == 0 and file_exists(gifname)) then
                is_busy = false
                mp.osd_message("Error creating file, check terminal for more info.")
                return
            end

            if not options.gifsicle then
                is_busy = false
                msg.info("GIF created: " .. gifname)
                mp.osd_message("GIF created: " .. gifname)
                return
            end

            -- Optional lossy compression pass, skipped silently if gifsicle isn't installed
            mp.osd_message("Creating GIF: compressing...")
            local gifsicle_args = {"gifsicle", "-O3"}
            if (options.gifsicle_lossy or 0) > 0 then
                table.insert(gifsicle_args, "--lossy=" .. tostring(options.gifsicle_lossy))
            end
            table.insert(gifsicle_args, "-o")
            table.insert(gifsicle_args, gifname)
            table.insert(gifsicle_args, gifname)

            mp.command_native_async({
                name = "subprocess",
                args = gifsicle_args,
                playback_only = false,
            }, function(success3, result3, error3)
                is_busy = false
                msg.info("GIF created: " .. gifname)
                if success3 and result3 and result3.status == 0 then
                    mp.osd_message("GIF created & compressed: " .. gifname)
                else
                    -- gifsicle missing or failed - the uncompressed gif from the previous
                    -- step is still valid and already on disk, so this isn't fatal
                    msg.warn("gifsicle step skipped/failed (not installed?): " .. tostring(error3))
                    mp.osd_message("GIF created (gifsicle compression skipped): " .. gifname)
                end
            end)
        end)
    end)
end

function set_gif_start()
    start_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("GIF Start: " .. start_time)
end

function set_gif_end()
    end_time = mp.get_property_number("time-pos", -1)
    mp.osd_message("GIF End: " .. end_time)
end

-- all keybindings here are set to nil on purpose 'cause bindings are set in input.conf
mp.add_key_binding(nil, "set_gif_start", set_gif_start)
mp.add_key_binding(nil, "set_gif_end", set_gif_end)
mp.add_key_binding(nil, "make_gif", make_gif)
mp.add_key_binding(nil, "make_gif_with_subtitles", make_gif_with_subtitles)  -- making GIFs with subtitles doesn't seem to work