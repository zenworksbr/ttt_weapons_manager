ZenLoadout.config = ZenLoadout.config or {}

// this functionality is also not yet complete. A lot of stuff is to be made.
// set up some of the important values we will need along the way

ZenLoadout.config.FilePathOrigin = "DATA"
ZenLoadout.config.FilePath = "zen_loadout/"
ZenLoadout.config.FileName = "settings.json"

local FilePathOrigin = ZenLoadout.config.FilePathOrigin
local FilePath = ZenLoadout.config.FilePath
local FileName = ZenLoadout.config.FileName

ZenLoadout.config.DefaultSettings = {
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

function ZenLoadout.config:ConfigExists(backup)
    if backup then
        
        return file.Exists(FilePath .. FileName .. '_old', FilePathOrigin)
    end

    return file.Exists(FilePath .. FileName, FilePathOrigin)
end

function ZenLoadout.config:SaveSettings(data)

    -- should be noted that this function will have to be rewritten once we are starting to mess with inputs
    -- for new settings and preferences
    if !self:ConfigExists() then 
        file.CreateDir(FilePath)
    end

    -- we can't just completely overwrite the whole settings' file with the data received from this function
    file.Write(FilePath .. FileName, util.TableToJSON(data))
end

// -----------------------------------------------------------------
// overwrite a specific table on the addon settings. Won't overwrite everything, but also don't change very specific stuff, yet.
// -----------------------------------------------------------------
function ZenLoadout.config:SaveSingle(field, data)

    cur_config = self:FetchConfig()

    cur_config[field] = data

    self:SaveSettings(cur_config)

    return true
end

function ZenLoadout.config:ResetDefaults()
    
    local dir_backup = FilePath .. '_old' .. FileName 

    if !self:ConfigExists() then
        return false 
    end
    if self:ConfigExists(true) then


        file.Write(dir_backup, file.Read(dir_backup, FilePathOrigin))
    end

    -- yes, we're not actually resetting anything, we're just creating a backup
    -- and forcing the addon to rewrite the default settings
    file.Rename(FilePath .. FileName, dir_backup)

    return true
end

function ZenLoadout.config:UndoResetDefaults(enforce)
    if self:ConfigExists() and !enforce then
        return false 
    end

    if !self:ConfigExists(true) then return false end

    file.Rename(FilePath .. "old_" .. FileName, FilePath .. FileName)

    return true
end

function ZenLoadout.config:FetchConfig()

    if !self:ConfigExists() then return self.DefaultSettings end

    settings = file.Read(FilePath .. FileName, FileGameDir)

    settings = util.JSONToTable(settings)

    return settings
end


function ZenLoadout.config:FetchSingle(field)

    return self:FetchConfig()[field]
end

-- only allow these fields to players
-- we also avoid players from exploiting the configuration with custom scripts this way
function ZenLoadout.config:SendSettingsToPlayer(ply)
    local settings = self:FetchConfig()

    net.Start('ZenLoadout_SettingsResponse', false)

        response = {
            weapons = settings.weapons,
            choice_allowed_ranks = settings.choice_allowed_ranks,
            config_allowed_ranks = settings.config_allowed_ranks,
        }

        net.WriteTable(response)

    net.Broadcast()
end

local autodetect_options = ZenLoadout.config:FetchSingle('autodetect_options')
local weapon_table = ZenLoadout.config:FetchSingle('weapons')

local wepmeta = FindMetaTable('Weapon')

-- this function just returns our designated category for the weapon
function wepmeta:ZenCategory() 
    return autodetect_options.WeaponCategories[self.Kind] 
end

local fetched = false
local function AutoFetchServerWeapons()

    if fetched or !ZenLoadout.config:FetchSingle('config_autodetect_weapons') then return end

    print('[' .. ZenLoadout.Prefix .. '] Trying to autodetect server weapons...')    
    
    -- if we don't have a way to allow server admins to add custom weapons:
    local detected_weapons = weapon_table
    or {
        primary = {},
        secondary = {},
        equipment = {}
    }

    local weapon_cache = weapons.GetList()

    for _, v in ipairs(weapon_cache) do

        -- print(v.ClassName)

        local wep_category = v:ZenCategory()

        -- skip weapons that are already 
        if wep_category == nil
        or weapon_table[v:ZenCategory()][v.ClassName] 
        then continue end

        -- yeah, we have THAT MANY filters.
        if (v.Base != 'weapon_tttbase' and v.Base != 'weapon_tttbasegrenade')
        or autodetect_options.IgnoredWeaponClasses[v.ClassName]
        or autodetect_options.IgnoredWeaponTypes[v.Kind]
        or (v.CanBuy and autodetect_options.IgnoreCanBuy)
        or !v.AutoSpawnable
        then 
            
            continue
        end

        detected_weapons[wep_category][v.ClassName] = true
    end
    PrintTable(detected_weapons)

    ZenLoadout.config:SaveSingle('weapons', detected_weapons)

    if isDebug then
        print('[' .. ZenLoadout.Prefix .. '] Detected weapons:\n')
        -- this is our new weapon_table. We will not write these detections to the config, 
        -- we will only use it in the current game session, since this is always done anyways (when enabled)
        PrintTable(weapon_table)
        print('========================================================================')
    end

    fetched = true
end
AutoFetchServerWeapons()

if SERVER then
    -- also for debugging...
    print('[' .. ZenLoadout.Prefix .. '] Current configuration table:\n')
    PrintTable(ZenLoadout.config:FetchConfig())
    print('========================================================================')
end