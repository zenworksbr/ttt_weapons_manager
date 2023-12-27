TTTWeaponsManager = {}
TTTWeaponsManager.config = {}
TTTWeaponsManager.lang = {}
TTTWeaponsManager.net = {}

// this functionality is also far from complete. A lot of stuff is to be made yet.
TTTWeaponsManager.RootDir = "ttt_weapons_manager"

TTTWeaponsManager.Prefix = "Weapons Manager"

local RootDir = TTTWeaponsManager.RootDir
local MsgPrefix = TTTWeaponsManager.Prefix

local IgnoreDirs = {
    lang = false
}

local function IncludeSingleFile(DirName, FileName)

    local prefix = string.lower( string.Left( FileName, 3 ) )

    if prefix == "sv_" then
        if !SERVER then return end
        include(DirName .. FileName)
        print("[" .. MsgPrefix .. "] Including SERVER file " .. FileName )
    elseif prefix == "cl_" then
        if SERVER then 
            AddCSLuaFile(DirName .. FileName)
        else
            include(DirName .. FileName)
            print("[" .. MsgPrefix .. "] Including CLIENT file " .. FileName )
        end
    else
        AddCSLuaFile(DirName .. FileName)
        include(DirName .. FileName)
        print("[" .. MsgPrefix .. "] Including SHARED file " .. FileName )
    end
end


local function IncludeDir(directory)
    directory = directory .. "/"

    local files, dirs = file.Find(directory .. "*", "LUA")
    
    print("[" .. MsgPrefix .. "] On directory " .. directory .. "...")

    for _, f in ipairs(files) do
        if !string.EndsWith(f, ".lua") then continue end
        IncludeSingleFile(directory, f)
    end

    for _, dir in ipairs(dirs) do
        if IgnoreDirs[dir] then print("ignoring " .. dir) continue end
        print("[" .. MsgPrefix .. "] Including directory " .. dir)
        IncludeDir(directory .. dir)
    end
end

if SERVER then

    print("[" .. MsgPrefix .. "] Initializing network messages...")

    util.AddNetworkString("TTTWeaponsManager_WeaponsTable")
    util.AddNetworkString("TTTWeaponsManager_PlayerWeaponChoicesTbl")

    print("[" .. MsgPrefix .. "] Initializing server side files...")

elseif CLIENT then
    print("[" .. MsgPrefix .. "] Initializing client side files...")
end

IncludeDir(RootDir)