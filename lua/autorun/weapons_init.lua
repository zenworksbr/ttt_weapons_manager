TTTWeaponsManager = {}

// this functionality is also far from complete. A lot of stuff is to be made yet.

local files, dirs = file.Find("ttt_weapons_manager/" .. "*", "LUA")

for _, f in ipairs(files) do
    print(f)
end

for _, dir in ipairs(dirs) do
    print(dir)
end

print(TTTWeaponsManager.lang.FetchSingleString("initialServerPrint"))

AddCSLuaFile("ttt_weapons_manager/lang.lua")
AddCSLuaFile("ttt_weapons_manager/sh_config.lua")
AddCSLuaFile("ttt_weapons_manager/util.lua")
include("ttt_weapons_manager/lang.lua")
include("ttt_weapons_manager/sh_config.lua")
include("ttt_weapons_manager/util.lua")

hook.Add("Initialize", "InitializeTTTWeaponsManager", TTTWeaponsManager.util.IncludeFiles(TTTWeaponsManager.config.rootDir))