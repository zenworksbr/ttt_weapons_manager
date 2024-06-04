ZenLoadout = {}
ZenLoadout.config = {}
ZenLoadout.lang = {}

// this functionality is also far from complete. A lot of stuff is to be made yet.
ZenLoadout.RootDir = "zen_loadout"

ZenLoadout.Prefix = "Zen Loadout"

local RootDir = ZenLoadout.RootDir
local MsgPrefix = ZenLoadout.Prefix

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

-- had to change the loading of addon files for after the gamemode has initialized
-- else, it would break a lot of stuff we depend on TTT
hook.Add('OnGamemodeLoaded', 'ZenLoadout.GamemodeLoaded', function() 

    print('[' .. MsgPrefix .. '] Initializing addon files...')

    if engine.ActiveGamemode() != 'terrortown' then 

        print('[' .. MsgPrefix ..'] Can\'t initialize this addon on another gamemode other than TTT!!! Please change it in your server settings!!!')
        return
    end

    if SERVER then

        print("[" .. MsgPrefix .. "] Initializing network messages...")
    
        util.AddNetworkString("ZenLoadout_RequestSettings")
        util.AddNetworkString("ZenLoadout_SettingsResponse")
        util.AddNetworkString('ZenLoadout_RequestWeaponsToServer')
        util.AddNetworkString("ZenLoadout_WeaponSentToPlayer")
        util.AddNetworkString('ZenLoadout_ReceiveSettingsFromServer')
    
        print("[" .. MsgPrefix .. "] Initializing server side files...")
    
    elseif CLIENT then
        print("[" .. MsgPrefix .. "] Initializing client side files...")
    end

    IncludeDir(RootDir)
end)