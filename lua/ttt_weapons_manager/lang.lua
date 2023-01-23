TTTWeaponsManager.lang = {}

// -----------------------------------------------------------------
// PURPOSE: It adds a language file to the localizations table
// HOW: it will receive a parameter (language file's name) and it will search 
// for it in the languages' directory and try to read its content and turn it
// into that language's table key in the table.
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.AddLocalization(langName)
    if TTTWeaponsManager.lang.Strings[langName] then return end

    local langFile, dirs = file.Find(TTTWeaponsManager.lang.LangDir, langName, "LUA")

    local langContent = file.Read("addons/ttt_weapons_manager/lua/" .. TTTWeaponsManager.lang.LangDir .. langName, "GAME")
    
    table.Add(TTTWeaponsManager.lang.Strings[langName], langContent)
end

// -----------------------------------------------------------------
// PURPOSE: It will try to initialize the localization tables so it will be easier to fetch and add
// new tables of strings to the main table.
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.BuildCachedLocalizations(directory)
    local langs, dirs = file.Find(directory, "*", "LUA")

    for _, f in ipairs(langs) do
        
    end
end

// -----------------------------------------------------------------
// PURPOSE: return a specific language string from the requested language localization
// HOW: it will just return a json-like queried string from that specific language table
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.FetchSingleString(langName, stringName)
    if !TTTWeaponsManager.lang.Strings[langName][stringName] then return end

    return TTTWeaponsManager.lang.Strings[langName][stringName]
end