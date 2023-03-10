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

            tbl.primary = GetConVar("ttt_weapons_manager_primary_choice"):GetString() or "random"
            tbl.secondary = GetConVar("ttt_weapons_manager_secondary_choice"):GetString() or "random"
            tbl.equipment = GetConVar("ttt_weapons_manager_equipment_choice"):GetString() or "random"

            net.WriteTable(tbl)

        net.SendToServer()
    end 
end

print("Initialized networking")