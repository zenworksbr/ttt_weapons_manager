local debug_convar = CreateConVar('zen_loadout_debug', '0', {FCVAR_ARCHIVE, FCVAR_PROTECTED, FCVAR_UNLOGGED, FCVAR_SERVER_CAN_EXECUTE}, 'Debug mode for weapons manager', 1, 0)
local weapon_table = ZenLoadout.config:FetchSingle('weapons')

local isDebug = debug_convar:GetBool()

print('[' .. ZenLoadout.Prefix .. '] Debug mode is enabled. Expect bunches of printed texts with addon information.')

local function ResetPlayersStatus() 

    for _, ply in ipairs(player.GetAll()) do

        ply:SetNWBool('WMHasReceivedWeapons', false)
    end
end 
hook.Add('TTTPrepareRound', 'ZenLoadout_ResetPlayersStatus', ResetPlayersStatus)

local plymeta = FindMetaTable("Player")

-- this function will return if the player is actually allowed to have a custom value set as their client-side cvar
-- else, it will just return false when called, and they will be given a random weapon instead
-- WARNING: this WILL OVERRIDE permissions in case default choice weapons is set to anything other than random.
function plymeta:ValidatePlayerLoadout(cat, wep)

    -- removed this check since it's useless and we should check for this
    -- in the outer scope, so we are actually able to just give a random one
    -- if that's the player preference
    -- if wep == 'random' then return true end

    local allowed_ranks = ZenLoadout.config:FetchSingle('choice_allowed_ranks')
    local default_options = ZenLoadout.config:FetchSingle('default_player_choices')

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

        local cat = v:ZenCategory()

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
        print('[' .. ZenLoadout.Prefix .. '] Detected weapons for player ' .. self:Nick() .. ':\n')
        print(res)
        PrintTable(res)
        print('========================================================================')
    end

    return res, random
end

net.Receive('ZenLoadout_RequestWeaponsToServer', function(len, ply)

    if ply:GetNWBool('WMHasReceivedWeapons', false) then return end

    local ply_weps = net.ReadTable()
    local ply_prefs = {
        primary = ply:GetInfo("ttt_zen_loadout_primary_choice"),
        secondary = ply:GetInfo("ttt_zen_loadout_secondary_choice"),
        equipment = ply:GetInfo("ttt_zen_loadout_equipment_choice"),
    }

    local res, random = ply:GiveLoadout(ply_prefs, ply_weps)

    net.Start('ZenLoadout_WeaponSentToPlayer')

        net.WriteTable(res)
    net.Send(ply)
end)

print("[" .. ZenLoadout.Prefix .. "] Core module loaded")