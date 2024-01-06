local weapon_table = TTTWeaponsManager.config:FetchSingle('weapons')
local autodetect_options = TTTWeaponsManager.config:FetchSingle('autodetect_options')

local debug_convar = CreateConVar('ttt_weapons_manager_debug', 0, {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_UNLOGGED, FCVAR_SERVER_CAN_EXECUTE}, 1, 0)

local isDebug = debug_convar:GetBool()

print('[' .. TTTWeaponsManager.Prefix .. '] Debug mode is enabled. Expect bunches of printed texts with addon information.')

-- we create this method for weapons to just return our designated category for it
local function FetchCategory(kind) return autodetect_options.WeaponCategories[kind] end

local function ResetPlayersStatus() 

    for _, ply in ipairs(player.GetAll()) do

        ply:SetNWBool('WMHasReceivedWeapons', false)
    end
end 
-- hook.Add('TTTBeginRound', '', ResetPlayersStatus)
-- hook.Add('TTTEndRound', '', ResetPlayersStatus)
hook.Add('TTTPrepareRound', 'TTTWeaponsManager_ResetPlayersStatus', ResetPlayersStatus)

local fetched = false
local function AutoFetchServerWeapons()

    if fetched or !TTTWeaponsManager.config:FetchSingle('config_autodetect_weapons') then return end

    print('[' .. TTTWeaponsManager.Prefix .. '] Trying to autodetect server weapons...')    
    
    -- if we don't have a way to allow server admins to add custom weapons:
    local detected_weapons = weapon_table
    or {
        primary = {},
        secondary = {},
        equipment = {}
    }

    local weapon_cache = weapons.GetList()

    for _, v in ipairs(weapon_cache) do

        local wep_category = FetchCategory(v.Kind)

        -- skip weapons that are already 
        if wep_category == nil
        or weapon_table[FetchCategory(v.Kind)][v.ClassName] 
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

    weapon_table = detected_weapons

    if isDebug then
        print('[' .. TTTWeaponsManager.Prefix .. '] Detected weapons:\n')
        -- this is our new weapon_table. We will not write these detections to the config, 
        -- we will only use it in the current game session, since this is always done anyways (when enabled)
        PrintTable(weapon_table)
        print('========================================================================')
    end

    fetched = true
end
AutoFetchServerWeapons()

local plymeta = FindMetaTable("Player")

-- this function will return if the player is actually allowed to have a custom value set as their client-side cvar
-- else, it will just return false when called, and they will be given a random weapon instead
-- WARNING: this WILL OVERRIDE permissions in case default choice weapons is set to anything other than random.
function plymeta:ValidatePlayerLoadout(cat, wep)

    if wep == 'random' then return true end

    local allowed_ranks = TTTWeaponsManager.config:FetchSingle('choice_allowed_ranks')
    local default_options = TTTWeaponsManager.config:FetchSingle('default_player_choices')

    return allowed_ranks[self:GetUserGroup()] and weapon_table[cat][wep] or default_options[cat][wep]
end

local givable_weps = {}
givable_weps['primary'] = table.GetKeys(weapon_table['primary'])
givable_weps['secondary'] = table.GetKeys(weapon_table['secondary'])
givable_weps['equipment'] = table.GetKeys(weapon_table['equipment'])

-- this is the main addon function. Will do most of the job
function plymeta:GiveLoadout(ply_prefs, inv_weps)

    if self:GetNWBool('WMHasReceivedWeapons', false) then return end

    local res = {
        primary = '',
        secondary = '',
        equipment = ''
    }

    local cur_weapons = {
        primary = false,
        secondary = false,
        equipment = false
    }

    for k, v in pairs(inv_weps) do

        local cat = FetchCategory(v.Kind)

        if !cat then continue end

        cur_weapons[cat] = true
    end

    for k, v in pairs(cur_weapons) do

        -- skip this item if its type has already been given
        if v then continue end

        local wep_class = ""

        if ply_prefs[k] == "random" or !self:ValidatePlayerLoadout(k, ply_prefs[k]) then 
            wep_class = givable_weps[k][math.random(#givable_weps[k])]
        else
            wep_class = ply_prefs[k]
        end
        
        local wep_obj = weapons.Get(wep_class)

        self:Give(wep_class)

        -- some weapons don't have extra ammo or ammo entities...
        if wep_obj.AmmoEnt then
            self:GiveAmmo(wep_obj.Primary.ClipSize, wep_obj.Primary.Ammo)
        end

        res[k] = wep_class
    end

    self:SetNWBool('WMHasReceivedWeapons', true)

    -- will leave this here for now, as it is not 100% done yet
    -- if you're using the addon, disable it.
    if isDebug then
        print('[' .. TTTWeaponsManager.Prefix .. '] Detected weapons for player ' .. self:Nick() .. ':\n')
        print(res)
        PrintTable(res)
        print('========================================================================')
    end

    return res
end

net.Receive('TTTWeaponsManager_RequestWeaponsToServer', function(len, ply)

    if ply:GetNWBool('WMHasReceivedWeapons', false) then return end

    local ply_weps = net.ReadTable()
    local ply_prefs = {
        primary = net.ReadString(),
        secondary = net.ReadString(),
        equipment = net.ReadString(),
    }

    local res = ply:GiveLoadout(ply_prefs, ply_weps)

    net.Start('TTTWeaponsManager_WeaponSentToPlayer')

        net.WriteTable(res)
    net.Send(ply)
end)

print("[" .. TTTWeaponsManager.Prefix .. "] Core module loaded")