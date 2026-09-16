local heist_music_order = {
    "new-fight"
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

    for _, wanted_id in ipairs(heist_music_order) do
        for _, entry in ipairs(list) do
            local track_id = get_track_id(entry)

            if track_id == wanted_id and not used[track_id] then
                table.insert(ordered, entry)
                used[track_id] = true
                break
            end
        end
    end

    for _, entry in ipairs(list) do
        local track_id = get_track_id(entry)

        if not track_id or not used[track_id] then
            table.insert(ordered, entry)

            if track_id then
                used[track_id] = true
            end
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

        local track_heist_list = tweak_data.music.track_heist_list

        if type(track_heist_list) ~= "table" then
            track_heist_list = tweak_data.music.heist_track_list
        end

        if type(track_heist_list) ~= "table" then
            return
        end

        tweak_data.music.track_heist_list = reorder_heist_music_list(track_heist_list)
    end
)
