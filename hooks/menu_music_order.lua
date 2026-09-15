local menu_music_order = {
    "index-1_psi-missing",
    "index-1_masterpiece",
    "index-1_academy-city",
    "index-1_anger",
    "index-1_daily-life",
    "index-1_despair",
    "index-1_destiny-begins",
    "index-1_funny-days",
    "index-1_hurry-up",
    "index-1_impatience",
    "index-1_omen",
    "index-1_road-to-school",
    "index-1_summer-sunshine",
    "index-1_the-thing-you-cant-get-back",
    "index-1_vampire-killer",
    "index-1_with-the-usual-friend",
    "railgun_only-my-railgun",
    "railgun_level5-judelight",
    "railgun_future-gazer",
    "railgun_determination",
    "railgun_hopeless-feeling",
    "railgun_place-to-return",
    "railgun_plot",
    "railgun_reality-to-confront",
    "railgun_searcher",
    "railgun_tea-time",
    "railgun_that-day-continued",
    "railgun_that-which-is-rumored",
    "railgun_this",
    "railgun_unstoppable-reason",
    "index-2_no-buts",
    "index-2_see-visions",
    "index-2_amakusa-style-remix-of-church",
    "index-2_introducing-the-strongest",
    "index-2_misakas-sister",
    "index-2_quiet-stratagem",
    "index-2_study",
    "railgun-s_sisters-noise",
    "railgun-s_eternal-reality",
    "railgun-s_accelerator",
    "railgun-s_cruel-reality",
    "railgun-s_determination-and-resolution",
    "railgun-s_feeling-for-the-first-time",
    "railgun-s_level-6-shift-project",
    "accelerator_shadow-is-the-light",
    "accelerator_atmospheric-continuum-mechanics-research-facility",
    "accelerator_thoughts-of-esther",
    "accelerator_you-arent-a-waste",
    "railgun-t_final-phase",
    "railgun-t_dual-existence",
    "railgun-t_balloon-hunter",
    "railgun-t_my-genius-ability",
    "railgun-t_strawberry-yakisoba",
    "index-3_gravitation",
    "index-3_roar",
    "index-3_dark-side-conflict"
}

local function get_track_id(entry)
    if type(entry) == "string" then
        return entry
    end

    if type(entry) == "table" then
        return entry.track or entry.id
    end

    return nil
end

local function reorder_menu_music_list(list)
    local ordered = {}
    local used = {}

    for _, wanted_id in ipairs(menu_music_order) do
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