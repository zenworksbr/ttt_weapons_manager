// this functionality is also far from complete. A lot of stuff is to be made yet.

print("Server side initialized")

hook.Add("TTTPrepareRound", "TTTWeaponManagerExploitBlocker", function() 
    for _, ply in ipairs(player.GetAll()) do
        print(player:GetWeapons())
    end
    
    // do something...
    return
end)

hook.Add("TTTBeginRound", "TTTWeaponManagerOnRoundStart", function()
    // do something else...
    for _, ply in ipairs(player.GetAll()) do
        print(player:GetWeapons())
    end


    return 
end)