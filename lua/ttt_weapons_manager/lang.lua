TTTWeaponsManager.lang = TTTWeaponsManager.lang or {}

local LangDir = TTTWeaponsManager.config.LangDir .. "/"
local MsgPrefix = TTTWeaponsManager.Prefix

if !SERVER then return end

// -----------------------------------------------------------------
// PURPOSE: It adds a language file to the localizations table
// HOW: it will receive a parameter (language file's name) and it will search 
// for it in the languages' directory and try to read its content and turn it
// into that language's table key in the table.
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.AddLocalization(LangName)
    if TTTWeaponsManager.lang.Strings[LangName] then return end

    TTTWeaponsManager.lang.Strings[LangName] = {}

    local LangFile, dirs = file.Find(LangDir .. LangName, "LUA")

    local LangContent = file.Read(LangDir .. LangName, "LUA")
    
    table.Add(TTTWeaponsManager.lang.Strings[LangName], LangContent)
end
local AddLocalization = TTTWeaponsManager.lang.AddLocalization

// -----------------------------------------------------------------
// PURPOSE: It will try to initialize the localization tables so it will be easier to fetch and add
// new tables of strings to the main table.
// DO NOTE that this function is not yet done.
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.BuildCachedLocalizations()
    TTTWeaponsManager.lang.Strings = {}

    local langs, dir = file.Find(LangDir .. "*", "LUA")

    for _, f in ipairs(langs) do
        print("[" .. MsgPrefix .. "] Including LANG file " .. f )
        AddLocalization(f)
    end

end
local BuildCachedLocalizations = TTTWeaponsManager.lang.BuildCachedLocalizations

// -----------------------------------------------------------------
// PURPOSE: return a specific language string from the requested language localization
// HOW: it will just return a json-like queried string from that specific language table
// -----------------------------------------------------------------
function TTTWeaponsManager.lang.FetchSingleString(LangName, StringName)
    if !TTTWeaponsManager.lang.Strings[LangName][StringName] then return end

    return TTTWeaponsManager.lang.Strings[LangName][StringName]
end

BuildCachedLocalizations()

if SERVER then
    PrintTable(TTTWeaponsManager.lang.Strings, 0)
end