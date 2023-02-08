// this functionality is also far from complete. A lot of stuff is to be made yet.

print("Server side initialized")

hook.Add("TTTPrepareRound", "TTTWeaponManagerExploitBlocker", function() 
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsBot() then continue end 
        print("Armas do jogador " .. ply:Nick())
        PrintTable(ply:GetWeapons())
    end
    
    // do something...
    return
end)

hook.Add("TTTBeginRound", "TTTWeaponManagerOnRoundStart", function()
    
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsBot() then continue end 
        print("Armas do jogador " .. ply:Nick())
        PrintTable(ply:GetWeapons())
    end

    // do something else...
    return 
end)