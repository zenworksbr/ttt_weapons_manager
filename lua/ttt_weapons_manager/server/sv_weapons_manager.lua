// this functionality is also far from complete. A lot of stuff is to be made yet.

print("Core module loaded")

-- this function just exists to reduce the amount of nesting in the actual code below (running on the hook)
local function VerifyWeaponCategory(wep, cat_table)

    for k, v in pairs(cat_table) do
        print("cat_table _ = " .. k)
        if TTTWeaponsManager.config.Table["weapons"][k][wep] then 
            print("tem " .. k .. " = " .. wep)
            cat_table[k] = true

            print("Tabela de armas no inventário:")
            PrintTable(cat_table)

            break
        end
    end

    return cat_table
end

-- this function will return if the player is actually allowed to have a custom value set as their client-side cvar
-- else, it will just return false when called, and they will be given a random weapon instead
local function ValidatePlyChoices(ply)

    -- pretty simple here, just check if the player's usergroup exists in the allowed_ranks table
    -- it will be stored with the value of true if it should be allowed, and that's what we will return here
    print("Validação de permissões:")
    print(TTTWeaponsManager.config.Table.choice_allowed_ranks[ply:GetUserGroup()])

    return TTTWeaponsManager.config.Table.choice_allowed_ranks[ply:GetUserGroup()]
end

-- this function will be used along the one above, checking, besides the player being allowed to choose
-- if their choice is actually valid for our current addon settings
local function ValidateWeaponClass(ply, wep_class)
    if !ValidatePlyChoices(ply) then return false end

    -- return the opposite of the value stored as blacklisted entity
    -- since they will be stored in the table with true (if blocked, we want to return false from this function)
    -- and vice-versa
    print("Validação de permissões:")

    return !TTTWeaponsManager.config.Table["weapons"].blacklisted_ents[wep_class]

end

-- this right here is the star on the show
-- this bad boy will deal with this addon's main functionality;
-- giving players their weapons when the round starts
local function GiveWeapons(ply, inv_weps)

    local res = {}

    local choice_cvars = TTTWeaponsManager.net.PlayerPreferences[ply:SteamID()]


    print("Choice_cvars: ")
    PrintTable(choice_cvars)

    print("inv_weps:")
    PrintTable(inv_weps)
    
    for k, v in pairs(inv_weps) do
        print("inv_weps " .. k)
        if v then continue end

        local wep_class = ""

        if choice_cvars[k] == "random" or !ValidateWeaponClass(ply, choice_cvars[k]) then 
            wep_class = table.GetKeys(TTTWeaponsManager.config.Table["weapons"][k])[math.random(#TTTWeaponsManager.config.Table["weapons"][k])]
        else
            wep_class = choice_cvars[k]
        end
        
        print("wep_class: ")
        print(wep_class)
        local wep_obj = weapons.Get(wep_class)

        ply:Give(wep_class)

        -- I was going to just access the value from the weapon object directly, 
        -- but they already have a stupid shitty function for that
        -- but they don't have other functions to get more important stuff from the weapon... 
        -- Like its printname (it is broken when used server-side) or its Icon path, its ammo entity
        ply:GiveAmmo(wep_obj.Primary.ClipSize, wep_obj.Primary.Ammo)

        res[k] = wep_class
    end

    return res

end

hook.Add("TTTBeginRound", "TTTWeaponManagerOnRoundStart", function()

    local ply_weps = {
        primary = false,
        secondary = false,
        equipment = false
    }

    print(ply_weps[1])

    for _, jog in ipairs(player.GetHumans()) do

        -- skip the dead or disconnected players so we don't get some annoying errors
        if !jog:Alive() or !IsValid(jog) then continue end

        
        
        for k, wep in ipairs(jog:GetWeapons()) do
            if TTTWeaponsManager.IgnoredWeapons[wep] then continue end

            ply_weps = VerifyWeaponCategory(wep:GetClass(), ply_weps)
        end

        local res = GiveWeapons(jog, ply_weps)

        PrintTable(res)


        ply_weps = {
            primary = false,
            secondary = false,
            equipment = false
        }

    end

    return

end)