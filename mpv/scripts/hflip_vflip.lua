-- State tracking
local flips = { h = false, v = false }

-- Apply filters based on state
--local function update_filters()
--    local filters = {}
--    if flips.h then table.insert(filters, { name = "hflip" }) end
--    if flips.v then table.insert(filters, { name = "vflip" }) end
--    mp.set_property_native("vf", filters)
--end
-- Apply filters based on state (String format)
local function update_filters()
    local filters = {}
    if flips.h then table.insert(filters, "hflip") end
    if flips.v then table.insert(filters, "vflip") end
    
    -- Join with comma or set empty string
    local vf_string = #filters > 0 and table.concat(filters, ",") or ""
    mp.set_property("vf", vf_string)
end


-- Toggle Horizontal
mp.add_key_binding("h", "flip_h", function()
    flips.h = not flips.h
    update_filters()
    mp.osd_message(flips.h and "H-Flip: ON" or "H-Flip: OFF")
end)

-- Toggle Vertical
mp.add_key_binding("v", "flip_v", function()
    flips.v = not flips.v
    update_filters()
    mp.osd_message(flips.v and "V-Flip: ON" or "V-Flip: OFF")
end)