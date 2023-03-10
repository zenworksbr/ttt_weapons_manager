// coming soon.

print("Client side initialized")

local primary = CreateClientConVar("ttt_weapons_manager_primary_choice", "random", true)
local secondary = CreateClientConVar("ttt_weapons_manager_secondary_choice", "random", true)
local equipment = CreateClientConVar("ttt_weapons_manager_equipment_choice", "random", true)

hook.Add("PlayerConnect", "TTTWeaponsManagerClientSidePlayerConnectHookRun", TTTWeaponsManager.net.SendPreferencesToServer)
hook.Add("TTTBeginRound", "TTTWeaponsManagerClientSidedBeginRoundHookRun", TTTWeaponsManager.net.SendPreferencesToServer)