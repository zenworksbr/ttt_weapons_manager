// this functionality is also far from complete. A lot of stuff is to be made yet.

print("Core module loaded")

-- this function just exists to reduce the amount of nesting in the actual code below (running on the hook)
local function VerifyWeaponCategory(wep, cat_table)

    for k, v in pairs(cat_table) do
        if TTTWeaponsManager.config.Table["weapons"][k][wep] then 
            cat_table[k] = true

            break
        end
    end

    return cat_table
end

-- this function will return if the player is actually allowed to have a custom value set as their client-side cvar
-- else, it will just return false when called, and they will be given a random weapon instead
local function ValidatePlyChoices(ply, cat, wep)
  
    -- pretty simple here, just check if the player's usergroup exists in the allowed_ranks table
    -- it will be stored with the value of true if it should be allowed, and that's what we will return here
    return TTTWeaponsManager.config.Table.choice_allowed_ranks[ply:GetUserGroup()] and TTTWeaponsManager.config.Table["weapons"][cat][wep]
end

-- this right here is the star on the show
-- this bad boy will deal with this addon's main functionality;
-- giving players their weapons when the round starts
local function GiveWeapons(ply, inv_weps)

    local res = {}

    local choice_cvars = TTTWeaponsManager.net.PlayerPreferences[ply:SteamID()]
    
    for k, v in pairs(inv_weps) do
        if v then continue end

        local wep_class = ""

        if choice_cvars[k] == "random" or !ValidatePlyChoices(ply, k, choice_cvars[k]) then 
            wep_class = table.GetKeys(TTTWeaponsManager.config.Table["weapons"][k])[math.random(#TTTWeaponsManager.config.Table["weapons"][k])]
        else
            wep_class = choice_cvars[k]
        end
        
        local wep_obj = weapons.Get(wep_class)

        ply:Give(wep_class)

        -- I was going to just access the value from the weapon object directly, 
        -- but they already have a stupid shitty function for that
        -- but they don't have other functions to get more important stuff from the weapon... 
        -- Like its printname (it is broken when used server-side) or its Icon path, its ammo entity
        if wep_obj.AmmoEnt then
            ply:GiveAmmo(wep_obj.Primary.ClipSize, wep_obj.Primary.Ammo)
        end

        -- had to add an if above because there are some weapons in TTT that aren't supposed to have extra ammo (reserve ammo),
        -- so we shouldn't give ammo for those weapons, since it may break them

        res[k] = choice_cvars[k].PrintName
    end

    return res

end

hook.Add("TTTBeginRound", "TTTWeaponManagerOnRoundStart", function()

    local ply_weps = {
        primary = false,
        secondary = false,
        equipment = false
    }

    for _, jog in ipairs(player.GetHumans()) do

        -- skip the dead or disconnected players so we don't get some annoying errors
        if !jog:Alive() or !IsValid(jog) then continue end
        
        for k, wep in ipairs(jog:GetWeapons()) do
            if TTTWeaponsManager.IgnoredWeapons[wep] then continue end

            ply_weps = VerifyWeaponCategory(wep:GetClass(), ply_weps)
        end

        local res = GiveWeapons(jog, ply_weps)

        print("Armas recebidas por " .. jog:Nick())
        PrintTable(res)

        local text = ""

        for k, item in pairs(res) do
            text = text .. ", " .. item 
        end

        if !table.IsEmpty(res) then
            jog:ChatPrint("Você recebeu " .. text .. "!")
        end

    end

    return

end)