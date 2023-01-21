local defaultSettings = {
    // always add all of your server's weapon ents here, and if they shouldn't be allowed, blacklist them below
    server_weapon_ents = {
        primary = {
            "weapon_zm_mac10",
            "weapon_zm_shotgun",
            "weapon_ttt_m16",
            "weapon_zm_rifle",
            "weapon_zm_sledge",
            "weapon_ttt_mac10"
        },
        secondary = {
            "weapon_zm_pistol",
            "weapon_zm_revolver"
        },
        equipment = {
            "weapon_ttt_knife"
        }
    },
    // blacklisted weapons that shouldn't be allowed in the addon's functionality
    blacklisted_ents = {
        weapon_ttt_knife = true
    },
    // add ULX/CAMI ranks that should have access for the weapons' menu
    choice_allowed_ranks = {
        user = true
    },
    // by default, only superadmins should have access to the addon's global settings and management
    config_allowed_ranks = {
        superadmin = true
    }
}

local filePathOrigin = "DATA"
local filePath = "ttt_weapon_manager"
local fileName = "settings.txt"

local function = SaveSettings(fileGameDir, filePath, fileName, data)
    if !(file.Exists(filePath, fileGameDir)) then 
        file.CreateDir(filePath)
    end

    file.Write(filePath + "/" + fileName, data)
end

local function = FetchConfig(fileGameDir, filePath, fileName, data)
    settings = {}

    if !(file.Exists(filePath, fileGameDir)) then return defaultSettings end



    return settings
end

local function = FetchSetting(config, setting)
    return config.setting || ""
end

local config = {}

config.weapons = {
    primary_weapons = {
    "weapon_zm_mac10",
    "weapon_zm_shotgun",
    "weapon_ttt_m16",
    "weapon_zm_rifle",
    "weapon_zm_sledge",
    "weapon_ttt_ak47",
    "weapon_ttt_aug",
    "weapon_ttt_tmp",
    "weapon_ttt_galil",
    "weapon_ttt_famas",
    "weapon_ttt_sg550",
    "weapon_ttt_sg552",
    "weapon_ttt_m3",
    "weapon_ttt_mp5",
    "weapon_ttt_g3sg1",
    "weapon_ttt_smg",
    "weapon_ttt_mac10",
    "m9k_acr",
    "m9k_an94",
    "m9k_ar15",
    "m9k_g36c",
    "m9k_honeybadger",
    "m9k_mk17",
    "m9k_spas12",
    "m9k_sten",
    "m9k_vector",
    },
    secondary_weapons = {
    "weapon_zm_pistol",
    "weapon_zm_revolver",
    "weapon_ttt_dual_elites",
    "weapon_ttt_revolver",
    "weapon_ttt_glock",
    "weapon_ttt_p228",
    "m9k_luger",
    "m9k_m92beretta",
    "m9k_tec9",
    "m9k_usp",
    }
}

config.blacklisted_weapons = FetchSettings(fileGameDir, filePath, fileName, setting)