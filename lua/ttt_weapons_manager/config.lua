TTTWeaponsManager.config = TTTWeaponsManager.config or {}

// this functionality is also not yet complete. A lot of stuff is to be made.

// set up some of the important values we will need along the way

TTTWeaponsManager.config.FilePathOrigin = "DATA"
TTTWeaponsManager.config.FilePath = "ttt_weapons_manager/"
TTTWeaponsManager.config.FileName = "settings.json"

local FilePathOrigin = TTTWeaponsManager.config.FilePathOrigin
local FilePath = TTTWeaponsManager.config.FilePath
local FileName = TTTWeaponsManager.config.FileName

// -----------------------------------------------------------------
// just a shortcut for the file.Exists() function.
// it is only for practical and clean code purposes
// -----------------------------------------------------------------
function TTTWeaponsManager.config:ConfigExists()

    return file.Exists(FilePath, FilePathOrigin)
end

// -----------------------------------------------------------------
// PURPOSE: will write the addon's settings to the config file, overwriting all current data, if it exists
// -----------------------------------------------------------------
function TTTWeaponsManager.config:SaveSettings(data)

    -- should be noted that this function will have to be rewritten once we are starting to mess with inputs
    -- for new settings and preferences
    if !self:ConfigExists() then 
        file.CreateDir(FilePath)
    end

    -- we can't just completely overwrite the whole settings' file with the data received from this function
    file.Write(FilePath .. FileName, util.TableToJSON(data))
end

// -----------------------------------------------------------------
// Pretty straight forward: it will just rename your current config file's name
// so that the FetchConfig() function doesn't find it, and will return the default ones.
// Maybe not the best or most efficient way to do that, but you can always send a PR and suggest something better :)
// it does work, it is not that ugly, neither problematic, so I don't see a big problem for this solution (FOR NOW)
// -----------------------------------------------------------------
function TTTWeaponsManager.config:ResetDefaults()
    
    if !self:ConfigExists() then
        return false 
    end

    file.Rename(FilePath .. FileName, FilePath .. "old_" .. FileName)

    return true
end

// -----------------------------------------------------------------
// Also straight forward: resetting to defaults doesn't really delete the old configs,
// it just renames them, so it should be safe and pretty easy to get them back.
// -----------------------------------------------------------------
function TTTWeaponsManager.config:UndoResetDefaults(enforce)
    
    if self:ConfigExists() and !enforce then
        return false 
    end

    if !file.Exists(FilePath .. "old_" .. FileName, FileGameDir) then return false end

    file.Rename(FilePath .. "old_" .. FileName, FilePath .. FileName)

    return true
end

// -----------------------------------------------------------------
// PURPOSE: it will search for the config file in the set up directory 
// and try to return its content or will return default settings
// HOW: there's no further explaining it, it is pretty straightforward
// -----------------------------------------------------------------
function TTTWeaponsManager.config:FetchConfig()

    if !self:ConfigExists() then return self.DefaultSettings end

    settings = file.Read(FilePath .. FileName, FileGameDir)

    settings = util.JSONToTable(settings)

    return settings
end

function TTTWeaponsManager.config:FetchSingle(field)

    return self.Table[field] or self:FetchConfig()[field] or self:FetchConfig()
end

TTTWeaponsManager.config.DefaultSettings = {
    // always add all of your server's weapon ents here, and if they shouldn't be allowed, blacklist them below
    // slot 3...
    weapons = {
        // slot 3
        primary = {
            weapon_zm_mac10 = true,
            weapon_zm_shotgun = true,
            weapon_ttt_m16 = true,
            weapon_zm_rifle = true,
            weapon_zm_sledge = true,
        },
        // slot 2...
        secondary = {
            weapon_zm_pistol = true,
            weapon_ttt_glock = true,
            weapon_zm_revolver = true,
        },
        // slots 4, 7, 8, 9 and 10 (rarely used, but possible) 
        equipment = {
            weapon_ttt_confgrenade = true, // discombulator - slot 4
            weapon_zm_molotov = true, // incendiary grenade - slot 4
            weapon_ttt_smokegrenade = true, // smoke grenade - slot 4
        }
    },
    -- WARNING: this WILL OVERRIDE default player permissions for obtaining custom weapons. 
    -- If you change, players WILL get exactly what's set up below.
    default_player_choices = {
        primary = 'random',
        secondary = 'random',
        equipment = 'random',
    },
    autodetect_options = {
        -- just change below if you KNOW what you're doing. Seriously.
        WeaponCategories = {
            [WEAPON_HEAVY] = 'primary',
            [WEAPON_PISTOL] = 'secondary',
            [WEAPON_NADE] = 'equipment',
            [WEAPON_EQUIP] = 'equipment',
            [WEAPON_EQUIP1] = 'equipment',
            [WEAPON_EQUIP2] = 'equipment'
        },
        IgnoredWeaponClasses = {},
        IgnoredWeaponTypes = {
            [WEAPON_MELEE] = true,
            [WEAPON_CARRY] = true,
            [WEAPON_UNARMED] = true,
        },
        IgnoreCanBuy = true,
    },
    -- weapons that should just be ignored (by class) | ttt_weapon_x = true
    blacklisted_ents = {},
    // add ULX/CAMI ranks that should have the ability to select their own loadout
    choice_allowed_ranks = {
        superadmin = true,
        user = false,
    },
    // by default, only superadmins should have access to the addon's global settings and management
    config_allowed_ranks = {
        superadmin = true,
    },
    config_autodetect_weapons = true,
}
TTTWeaponsManager.config:SaveSettings(TTTWeaponsManager.config.DefaultSettings)

TTTWeaponsManager.config.Table = TTTWeaponsManager.config:FetchConfig()

if SERVER then
    -- also for debugging...
    print('[' .. TTTWeaponsManager.Prefix .. '] Current configuration table:\n')
    PrintTable(TTTWeaponsManager.config.Table)
    print('========================================================================')
end