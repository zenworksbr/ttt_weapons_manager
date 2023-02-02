TTTWeaponsManager.util = {}

local filePath = TTTWeaponsManager.config.filePath
local fileName = TTTWeaponsManager.config.fileName
local fileGameDir = TTTWeaponsManager.config.filePathOrigin

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

    -- should be noted that this function will have to be rewritten once we are starting to mess with inputs
    -- for new settings and preferences
    if !ConfigExists() then 
        file.CreateDir(filePath)
    end


    -- we can't just completely overwrite the whole settings' file with the data received from this function
    file.Write(filePath .. fileName, util.TableToJSON(data))
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

    settings = util.JSONToTable(settings)

    return settings
end