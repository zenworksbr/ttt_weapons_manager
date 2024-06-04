CreateClientConVar("ttt_zen_loadout_primary_choice", FCVAR_USERINFO, "random", true)
CreateClientConVar("ttt_zen_loadout_secondary_choice", FCVAR_USERINFO, "random", true)
CreateClientConVar("ttt_zen_loadout_equipment_choice", FCVAR_USERINFO, "random", true)

local function RequestWeapons()

        local ply = LocalPlayer()

        if !ply:IsActive()
        or !ply:Alive()
        or !IsValid(ply) 
        or ply:IsBot() 
        then return end

        -- this is WAY easier. We just fetch our own weapons, our own preferences and ask the server to give us the weapons.
        -- that's all we do here. We just ASK. The server receives the requests, validates and give the weapons accordingly.
        net.Start('ZenLoadout_RequestWeaponsToServer')
                
                net.WriteTable(ply:GetWeapons())
        net.SendToServer()
end

hook.Add('TTTBeginRound', 'ZenLoadout_RequestWeaponsToServerAtRoundStart', RequestWeapons)

ZenLoadout.ConfigTable = {}

net.Receive('ZenLoadout_ReceiveSettingsFromServer', function(len, ply)
                
        ZenLoadout.ConfigTable = net.ReadTable()
end)


net.Receive('ZenLoadout_WeaponSentToPlayer', function(len, ply) 

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

        if not LocalPlayer() then return end
        if text == "" then

                -- we're using LocalPlayer here because ply parameter from net message is nil for some reason
                chat.AddText(Color(255, 0, 0), "[Zen Loadout]", Color(255, 255, 255), " Parece que você já tinha armas nesta rodada! Você não recebeu nenhuma.")
        else

                -- still showing weapons' classes instead of names
                chat.AddText(Color(255, 0, 0), "[Zen Loadout]", Color(255, 255, 255), " Você recebeu: " .. text .. "!")
        end
end)

print("[" .. ZenLoadout.Prefix .. "] Client side initialized")