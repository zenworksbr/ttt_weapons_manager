TTTWeaponsManager.config = TTTWeaponsManager.config or {}

// this functionality is also not yet complete. A lot of stuff is to be made.

// set up some of the important values we will need along the way

TTTWeaponsManager.config.filePathOrigin = "DATA"
TTTWeaponsManager.config.filePath = "ttt_weapons_manager/"
TTTWeaponsManager.config.fileName = "settings.json"

TTTWeaponsManager.config.LangDir = "ttt_weapons_manager/lang"

local filePathOrigin = TTTWeaponsManager.config.filePathOrigin
local filePath = TTTWeaponsManager.config.filePath
local fileName = TTTWeaponsManager.config.fileName

// -----------------------------------------------------------------
// just a shortcut for the file.Exists() function.
// it is only for practical and clean code purposes
// -----------------------------------------------------------------
function TTTWeaponsManager.config.ConfigExists()
    return file.Exists(filePath, filePathOrigin)
end
// abreviating all of the classes subclasses and all those names for the function to have a clearer identifier
local ConfigExists = TTTWeaponsManager.config.ConfigExists

// -----------------------------------------------------------------
// PURPOSE: will write the addon's settings to the config file, overwriting all current data, if it exists
// -----------------------------------------------------------------
function TTTWeaponsManager.config.SaveSettings(data)

    -- should be noted that this function will have to be rewritten once we are starting to mess with inputs
    -- for new settings and preferences
    if !ConfigExists() then 
        file.CreateDir(filePath)
    end


    -- we can't just completely overwrite the whole settings' file with the data received from this function
    file.Write(filePath .. fileName, util.TableToJSON(data))
end

function TTTWeaponsManager.config.SaveSettingsPart(data)
    if !ConfigExists() then return false end

    settings = TTTWeaponsManager.config.FetchConfig()

    for k, v in ipairs(data) do 
        settings[k] = v
    end

    TTTWeaponsManager.config.SaveSettings(settings)

    return true

end

// -----------------------------------------------------------------
// Pretty straight forward: it will just rename your current config file's name
// so that the FetchConfig() function doesn't find it, and will return the default ones.
// Maybe not the best or most efficient way to do that, but you can always send a PR and suggest something better :)
// it does work, it is not that ugly, neither problematic, so I don't see a big problem for this solution (FOR NOW)
// -----------------------------------------------------------------
function TTTWeaponsManager.config.ResetDefaults()
    if !ConfigExists() then
        return false 
    end

    file.Rename(filePath .. fileName, filePath .. "old_" .. fileName)
end

// -----------------------------------------------------------------
// Also straight forward: resetting to defaults doesn't really delete the old configs,
// it just renames them, so it should be safe and pretty easy to get them back.
// -----------------------------------------------------------------
function TTTWeaponsManager.config.UndoResetDefaults(enforce)
    if ConfigExists() and !enforce then
        return false 
    end

    if !file.Exists(filePath .. "old_" .. fileName, fileGameDir) then return false end

    file.Rename(filePath .. "old_" .. fileName, filePath .. fileName)
end

// -----------------------------------------------------------------
// PURPOSE: it will search for the config file in the set up directory 
// and try to return its content or will return default settings
// HOW: there's no further explaining it, it is pretty straightforward
// -----------------------------------------------------------------
function TTTWeaponsManager.config.FetchConfig()

    if !ConfigExists() then return TTTWeaponsManager.config.defaultSettings end

    settings = file.Read(filePath .. fileName, fileGameDir)

    settings = util.JSONToTable(settings)

    return settings
end

// do note that you should NOT leave more than ONE equipment for the same slot allowed

TTTWeaponsManager.defaultSettings = {
    // always add all of your server's weapon ents here, and if they shouldn't be allowed, blacklist them below
    // slot 3...
    primary = {
        weapon_zm_mac10 = true,
        weapon_zm_shotgun = true,
        weapon_ttt_m16 = true,
        weapon_zm_rifle = true,
        weapon_zm_sledge = true,
        weapon_ttt_mac10 = true
    },
    // slot 2...
    secondary = {
        weapon_zm_pistol = true,
        weapon_ttt_glock = true,
        weapon_zm_revolver = true
    },
    // slots 4, 7, 8, 9 and 10 (rarely used, but possible) 
    equipment = {
        weapon_ttt_knife = true, // traitor knife - slot 7
        weapon_ttt_confgrenade = true, // discombulator - slot 4
        weapon_zm_molotov = true, // incendiary grenade - slot 4
        weapon_ttt_smokegrenade = true, // smoke grenade - slot 4
        weapon_ttt_c4 = true, // c4 - slot 7
        weapon_ttt_phammer = true // poltergeist - slot 8
    },
    // blacklisted weapons/equipments that shouldn't be allowed in the addon's functionality
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

TTTWeaponsManager.config.forcedSettings = {
    primary = {
        weapon_ttt_ak47  = true,
        weapon_ttt_aug  = true,
        weapon_ttt_tmp = true,
        weapon_ttt_galil = true,
        weapon_ttt_famas = true,
        weapon_ttt_sg550 = true,
        weapon_ttt_sg552 = true,
        weapon_ttt_m3 = true,
        weapon_ttt_mp5 = true,
        weapon_ttt_g3sg1 = true,
        weapon_ttt_smg = true,
        weapon_ttt_mac10 = true,
        m9k_acr = true,
        m9k_an94 = true,
        m9k_ar15 = true,
        m9k_g36c = true,
        m9k_honeybadger = true,
        m9k_mk17 = true,
        m9k_spas12 = true,
        m9k_sten = true,
        m9k_vector = true,
        weapon_zm_mac10 = true,
        weapon_zm_shotgun = true,
        weapon_ttt_m16 = true,
        weapon_zm_rifle = true,
        weapon_zm_sledge = true
    },
    secondary = {
        weapon_zm_pistol = true,
        weapon_zm_revolver = true,
        weapon_ttt_dual_elites = true,
        weapon_ttt_revolver = true,
        weapon_ttt_glock = true,
        weapon_ttt_p228 = true,
        m9k_luger = true,
        m9k_m92beretta = true,
        m9k_tec9 = true,
        m9k_usp = true
    },
    equipment = {
        weapon_ttt_knife = true,
        weapon_ttt_awp = true,
        weapon_ttt_push = true,
        weapon_ttt_thriler = true
    },
    blacklisted_ents = {
        weapon_ttt_knife = true,
        weapon_ttt_awp = true,
        weapon_ttt_push = true,
        weapon_ttt_thriler = true,
        weapon_ttt_ak47 = true,
        weapon_ttt_aug = true,
        weapon_ttt_tmp = true,
        weapon_ttt_galil = true,
        weapon_ttt_famas = true,
        weapon_ttt_sg550 = true,
        weapon_ttt_sg552 = true,
        weapon_ttt_m3 = true,
        weapon_ttt_mp5 = true,
        weapon_ttt_g3sg1 = true,
        weapon_ttt_smg = true,
        weapon_ttt_mac10 = true,
        m9k_acr = true,
        m9k_an94 = true,
        m9k_ar15 = true,
        m9k_g36c = true,
        m9k_honeybadger = true,
        m9k_mk17 = true,
        m9k_spas12 = true,
        m9k_sten = true,
        m9k_vector = true,
        weapon_ttt_p228 = true,
        m9k_luger = true,
        m9k_m92beretta = true,
        m9k_tec9 = true,
        m9k_usp = true,
        weapon_ttt_dual_elites = true,
        weapon_ttt_revolver = true
    },
    choice_allowed_ranks = {
        donator = true
    },
    config_allowed_ranks = {
        superadmin = true
    }
}

TTTWeaponsManager.config.SaveSettings(TTTWeaponsManager.config.forcedSettings)

TTTWeaponsManager.config.Weapons = TTTWeaponsManager.config.FetchConfig()

if SERVER then
    PrintTable(TTTWeaponsManager.config.Weapons)
end