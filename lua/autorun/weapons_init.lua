TTTWeaponsManager = {}
TTTWeaponsManager.config = {}
TTTWeaponsManager.lang = {}

// this functionality is also far from complete. A lot of stuff is to be made yet.
TTTWeaponsManager.rootDir = "ttt_weapons_manager"

TTTWeaponsManager.prefix = "Weapons Manager"

local rootDir = TTTWeaponsManager.rootDir
local msg_prefix = TTTWeaponsManager.prefix

local ignore = {
    lang = true
}

local function IncludeSingleFile(dirName, fileName)

    local prefix = string.lower( string.Left( fileName, 3 ) )

    if prefix == "sv" then
        if !SERVER then return end
        AddCSLuaFile(dirName .. fileName)
        include(dirName .. fileName)
        print("[" .. msg_prefix .. "] Including SERVER file " .. fileName )
    elseif prefix == "cl" then
        if !CLIENT then return end
        include(dirName .. fileName)
        print("[" .. msg_prefix .. "] Including CLIENT file " .. fileName )
    else
        AddCSLuaFile(dirName .. fileName)
        include(dirName .. fileName)
        print("[" .. msg_prefix .. "] Including SHARED file " .. fileName )
    end
end


local function IncludeDir(directory)
    directory = directory .. "/"

    local files, dirs = file.Find(directory .. "*", "LUA")
    
    print("[" .. msg_prefix .. "] On directory " .. directory .. "...")

    for _, f in ipairs(files) do
        if !string.EndsWith(f, ".lua") then continue end
        IncludeSingleFile(directory, f)
    end

    for _, dir in ipairs(dirs) do
        if ignore[dir] then print("ignoring " .. dir) return end
        print("[" .. msg_prefix .. "] Including directory " .. dir)
        IncludeDir(directory .. dir)
    end
end

if SERVER then
    print("[" .. msg_prefix .. "] Initializing server side files...")

elseif CLIENT then
    print("[" .. msg_prefix .. "] Initializing client side files...")
end

IncludeDir(rootDir)