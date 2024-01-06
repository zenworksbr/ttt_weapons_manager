local primary = CreateClientConVar("ttt_weapons_manager_primary_choice", "random", true)
local secondary = CreateClientConVar("ttt_weapons_manager_secondary_choice", "random", true)
local equipment = CreateClientConVar("ttt_weapons_manager_equipment_choice", "random", true)

hook.Add('TTTBeginRound', 'TTTWeaponsManager_RequestWeaponsToServerAtRoundStart', function() 

        local ply = LocalPlayer()

        if !ply:IsActive()
        or !ply:Alive()
        or !IsValid(ply) 
        or ply:IsBot() 
        then return end

        -- this is WAY easier. We just fetch our own weapons, our own preferences and ask the server to give us the weapons.
        -- that's all we do here. We just ASK. The server receives the requests, validates and give the weapons accordingly.
        net.Start('TTTWeaponsManager_RequestWeaponsToServer')
                
                net.WriteTable(ply:GetWeapons())
                net.WriteString(primary:GetString())
                net.WriteString(secondary:GetString())
                net.WriteString(equipment:GetString()) 
        net.SendToServer()
end)

net.Receive('TTTWeaponsManager_WeaponSentToPlayer', function(len, ply) 

        local res = net.ReadTable()

        local text = ""

        for k, item in pairs(res) do

                if item == '' then continue end

                local wep = weapons.Get(item)

                local wep_name = LANG.TryTranslation(wep.PrintName) or wep.PrintName
                
                if text != "" then

                        text = text .. ", " .. wep_name   
                else 

                        -- have to avoid adding "," to the start...
                        text = wep_name
                end    
        end

        if text == "" then

                -- we're using LocalPlayer here because ply parameter from net message is nil for some reason
                LocalPlayer():ChatPrint("Parece que você já tinha armas nesta rodada! Você não recebeu nenhuma.")
        else

                -- still showing weapons' classes instead of names
                LocalPlayer():ChatPrint("Você recebeu " .. text .. "!")
        end
end)

print("[" .. TTTWeaponsManager.Prefix .. "] Client side initialized")