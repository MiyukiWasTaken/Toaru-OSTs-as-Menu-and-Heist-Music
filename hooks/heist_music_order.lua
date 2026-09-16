local heist_music_order = {
    "new-fight",
    "rabbit-naru-punch"
}

local function get_track_id(entry)
    if type(entry) == "string" then
        return entry
    end

    if type(entry) == "table" then
        return entry.track or entry.id or entry.name
    end

    return nil
end

local function reorder_heist_music_list(list)
    local ordered = {}
    local used = {}

    -- Put the custom music first, in the exact order defined above
    for _, wanted_id in ipairs(heist_music_order) do
        for index, entry in ipairs(list) do
            local track_id = get_track_id(entry)

            if track_id == wanted_id and not used[index] then
                table.insert(ordered, entry)
                used[index] = true
                break
            end
        end
    end

    -- Keep every other music afterwards, in its original order
    for index, entry in ipairs(list) do
        if not used[index] then
            table.insert(ordered, entry)
        end
    end

    return ordered
end

Hooks:PostHook(
    MusicManager,
    "init",
    "ToaruHeistMusicOrder",
    function(self)
        if not tweak_data.music then
            return
        end

        local track_list = tweak_data.music.track_list

        if type(track_list) ~= "table" then
            return
        end

        tweak_data.music.track_list =
            reorder_heist_music_list(track_list)
    end
)
