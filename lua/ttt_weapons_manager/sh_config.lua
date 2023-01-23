TTTWeaponsManager.config = {}

// this functionality is also not yet complete. A lot of stuff is to be made.

TTTWeaponsManager.config.rootDir = "ttt_weapons_manager"

TTTWeaponsManager.config.filePathOrigin = "DATA"
TTTWeaponsManager.config.filePath = "ttt_weapons_manager/"
TTTWeaponsManager.config.fileName = "settings.txt"

TTTWeaponsManager.config.LangDir = "ttt_weapons_manager/lang/"

// do note that you should NOT leave more than ONE equipment for the same slot allowed
TTTWeaponsManager.config.defaultSettings = {
    // always add all of your server's weapon ents here, and if they shouldn't be allowed, blacklist them below
    // slot 3...
    ["primary"] = {
        "weapon_zm_mac10",
        "weapon_zm_shotgun",
        "weapon_ttt_m16",
        "weapon_zm_rifle",
        "weapon_zm_sledge",
        "weapon_ttt_mac10"
    },
    // slot 2...
    ["secondary"] = {
        "weapon_zm_pistol",
        "weapon_ttt_glock",
        "weapon_zm_revolver"
    },
    // slots 4, 7, 8, 9 and 10 (rarely used, but possible) 
    ["equipment"] = {
        "weapon_ttt_knife", // traitor knife - slot 7
        "weapon_ttt_confgrenade", // discombulator - slot 4
        "weapon_zm_molotov", // incendiary grenade - slot 4
        "weapon_ttt_smokegrenade", // smoke grenade - slot 4
        "weapon_ttt_c4", // c4 - slot 7
        "weapon_ttt_phammer", // poltergeist - slot 8
    },
    // blacklisted weapons/equipments that shouldn't be allowed in the addon's functionality
    ["blacklisted_ents"] = {
        weapon_ttt_knife = true
    },
    // add ULX/CAMI ranks that should have access for the weapons' menu
    ["choice_allowed_ranks"] = {
        user = true
    },
    // by default, only superadmins should have access to the addon's global settings and management
    ["config_allowed_ranks"] = {
        superadmin = true
    }
}

TTTWeaponsManager.config.Weapons = TTTWeaponsManager.util.FetchConfig()

print(TTTWeaponsManager.config.Weapons)