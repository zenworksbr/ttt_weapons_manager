TTTWeaponsManager.util = {}

local filePath = TTTWeaponsManager.config.filePath
local fileName = TTTWeaponsManager.config.fileName
local fileGameDir = TTTWeaponsManager.config.filePathOrigin

// -----------------------------------------------------------------
// PURPOSE: it will properly initialize a specific lua file
// It will also do all the filtering to add specific realms' files in the proper way
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.util.IncludeSingleFile(fileName, dirName)

    local prefix = string.lower( string.Left( fileName, 3 ) )

    if prefix == "sv" then
        if !SERVER then return end
        AddCSLuaFile(dirName .. fileName)
        include(dirName .. fileName)
        print("Inicializando " .. fileName )
    elseif prefix == "cl" then
        if !CLIENT then return end
        include(dirName .. fileName)
    else
        AddCSLuaFile(dirName .. fileName)
        include(dirName .. fileName)
    end
end
local IncludeFile = TTTWeaponsManager.util.IncludeSingleFile

// -----------------------------------------------------------------
// PURPOSE: it will run when the addon is initialized, and will loop through all
// the subdirectories in the addon, find the files, and let the IncludeSingleFile() function handle them
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.util.IncludeFiles()

    directory = TTTWeaponsManager.config.rootDir .. "/"

    local files, dirs = file.Find(directory .. "*", "LUA")
    
    for k, dir in ipairs(dirs) do
        for _, f in ipairs(dir) do
            local prefix = string.lower( string.Left( f, 3 ) )
            //print(f)
            //PrintTable(f)
            IncludeFile(f)
        end
    end
end

// -----------------------------------------------------------------
// just a shortcut for the file.Exists() function.
// it is only for practical and clean code purposes
// -----------------------------------------------------------------
function TTTWeaponsManager.util.ConfigExists()
    return file.Exists(filePath, fileGameDir)
end
// abreviating all of the classes subclasses and all those names for the function to have a clearer identifier
local ConfigExists = TTTWeaponsManager.util.ConfigExists

// -----------------------------------------------------------------
// PURPOSE: will write the addon's settings to the config file, overwriting all current data, if it exists
// -----------------------------------------------------------------
function TTTWeaponsManager.util.SaveSettings(data)

    if !ConfigExists() then 
        file.CreateDir(filePath)
    end

    file.Write(filePath .. fileName, data)
end

// -----------------------------------------------------------------
// Pretty straight forward: it will just rename your current config file's name
// so that the FetchConfig() function doesn't find it, and will return the default ones.
// Maybe not the best or most efficient way to do that, but you can always send a PR and suggest something better :)
// it does work, it is not that ugly, neither problematic, so I don't see a big problem for this solution (FOR NOW)
// -----------------------------------------------------------------
function TTTWeaponsManager.util.ResetDefaults()
    if !ConfigExists() then
        return false 
    end

    file.Rename(filePath .. fileName, filePath .. "old_" .. fileName)
end

// -----------------------------------------------------------------
// Also straight forward: resetting to defaults doesn't really delete the old configs,
// it just renames them, so it should be safe and pretty easy to get them back.
// -----------------------------------------------------------------
function TTTWeaponsManager.util.UndoResetDefaults(enforce)
    if ConfigExists() and !enforce then
        return false 
    end

    if !file.Exists(filePath .. "old_" .. fileName, fileGameDir) then return false end

    file.Rename(filePath .. "old_" .. fileName, filePath .. fileName)
end

// -----------------------------------------------------------------
// PURPOSE: it will search for the config file in the set up directory 
// and try to return its content or will return default settings
// HOW: there's no further explaining it, it is pretty straightforward
// -----------------------------------------------------------------
function TTTWeaponsManager.util.FetchConfig()

    if !ConfigExists() then return TTTWeaponsManager.config.defaultSettings end

    settings = file.Read(filePath .. fileName, fileGameDir)

    return settings
end