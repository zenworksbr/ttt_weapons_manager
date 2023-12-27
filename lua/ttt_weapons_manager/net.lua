TTTWeaponsManager.net = TTTWeaponsManager.net or {}

TTTWeaponsManager.net.PlayerPreferences = {}

net.Receive("TTTWeaponsManager_PlayerWeaponChoicesTbl", function(len, ply)

    if !TTTWeaponsManager.net.PlayerPreferences[ply:SteamID()] then
        TTTWeaponsManager.net.PlayerPreferences[ply:SteamID()] = {}
    end
    
    local res = net.ReadTable()

    table.Merge(TTTWeaponsManager.net.PlayerPreferences[ply:SteamID()], res)

end)

if CLIENT then
    function TTTWeaponsManager.net.SendPreferencesToServer()

        if !LocalPlayer() then return end

        net.Start("TTTWeaponsManager_PlayerWeaponChoicesTbl", false)
            local tbl = {}

            local primary = GetConVar("ttt_weapons_manager_primary_choice"):GetString() or "random"
            local secondary = GetConVar("ttt_weapons_manager_secondary_choice"):GetString() or "random"
            local equipment = GetConVar("ttt_weapons_manager_equipment_choice"):GetString() or "random"

            local primary_name = (primary != "random" and weapons.Get(primary).PrintName) or "Primária Aleatória"
            local secondary_name = (secondary != "random" and weapons.Get(secondary).PrintName) or "Primária Aleatória"
            local equipment_name = (equipment != "random" and weapons.Get(equipment).PrintName) or "Primária Aleatória"

            print(primary)
            print(primary_name)

            tbl.primary = primary
            tbl.primary.PrintName = primary_name
            tbl.secondary = secondary
            tbl.secondary.PrintName = secondary_name
            tbl.equipment = equipment
            tbl.equipment.PrintName = equipment_name

            PrintTable(tbl)

            net.WriteTable(tbl)

        net.SendToServer()
    end 
end

print("Initialized networking")