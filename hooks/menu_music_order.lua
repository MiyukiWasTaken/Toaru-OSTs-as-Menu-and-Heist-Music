local function get_track_id(entry)
    if type(entry) == "string" then
        return entry
    end

    if type(entry) == "table" then
        return entry.track or entry.id
    end

    return nil
end

local function is_beardlib_track(entry, music_mods)
    local track_id = get_track_id(entry)

    if not track_id or type(music_mods) ~= "table" then
        return false
    end

    if music_mods[track_id] ~= nil then
        return true
    end

    for key, music_mod in pairs(music_mods) do
        if key == track_id or music_mod == track_id then
            return true
        end

        if type(music_mod) == "table" and get_track_id(music_mod) == track_id then
            return true
        end
    end

    return false
end

local function reorder_menu_music_list(list)
    local vanilla_tracks = {}
    local beardlib_tracks = {}
    local music_mods = BeardLib and BeardLib.MusicMods

    for _, entry in ipairs(list) do
        if is_beardlib_track(entry, music_mods) then
            table.insert(beardlib_tracks, entry)
        else
            table.insert(vanilla_tracks, entry)
        end
    end

    for _, entry in ipairs(beardlib_tracks) do
        table.insert(vanilla_tracks, entry)
    end

    return vanilla_tracks
end

Hooks:PostHook(
    MusicManager,
    "init",
    "ToaruMenuMusicOrder",
    function(self)
        if not tweak_data.music then
            return
        end

        local track_menu_list = tweak_data.music.track_menu_list

        if type(track_menu_list) ~= "table" then
            return
        end

        tweak_data.music.track_menu_list =
            reorder_menu_music_list(track_menu_list)
    end
)