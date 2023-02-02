TTTWeaponsManager.config = {}

// this functionality is also not yet complete. A lot of stuff is to be made.

TTTWeaponsManager.config.filePathOrigin = "DATA"
TTTWeaponsManager.config.filePath = "ttt_weapons_manager/"
TTTWeaponsManager.config.fileName = "settings.json"

TTTWeaponsManager.config.LangDir = "ttt_weapons_manager/lang/"

// do note that you should NOT leave more than ONE equipment for the same slot allowed
TTTWeaponsManager.config.defaultSettings = {
    // always add all of your server's weapon ents here, and if they shouldn't be allowed, blacklist them below
    // slot 3...
    primary = {
        weapon_zm_mac10 = true,
        weapon_zm_shotgun = true,
        weapon_ttt_m16 = true,
        weapon_zm_rifle = true,
        weapon_zm_sledge = true,
        weapon_ttt_mac10 = true
    },
    // slot 2...
    secondary = {
        weapon_zm_pistol = true,
        weapon_ttt_glock = true,
        weapon_zm_revolver = true
    },
    // slots 4, 7, 8, 9 and 10 (rarely used, but possible) 
    equipment = {
        weapon_ttt_knife = true, // traitor knife - slot 7
        weapon_ttt_confgrenade = true, // discombulator - slot 4
        weapon_zm_molotov = true, // incendiary grenade - slot 4
        weapon_ttt_smokegrenade = true, // smoke grenade - slot 4
        weapon_ttt_c4 = true, // c4 - slot 7
        weapon_ttt_phammer = true // poltergeist - slot 8
    },
    // blacklisted weapons/equipments that shouldn't be allowed in the addon's functionality
    blacklisted_ents = {
        weapon_ttt_knife = true
    },
    // add ULX/CAMI ranks that should have access for the weapons' menu
    choice_allowed_ranks = {
        user = true
    },
    // by default, only superadmins should have access to the addon's global settings and management
    config_allowed_ranks = {
        superadmin = true
    }
}

TTTWeaponsManager.config.forcedSettings = {
    primary = {
        weapon_ttt_ak47  = true,
        weapon_ttt_aug  = true,
        weapon_ttt_tmp = true,
        weapon_ttt_galil = true,
        weapon_ttt_famas = true,
        weapon_ttt_sg550 = true,
        weapon_ttt_sg552 = true,
        weapon_ttt_m3 = true,
        weapon_ttt_mp5 = true,
        weapon_ttt_g3sg1 = true,
        weapon_ttt_smg = true,
        weapon_ttt_mac10 = true,
        m9k_acr = true,
        m9k_an94 = true,
        m9k_ar15 = true,
        m9k_g36c = true,
        m9k_honeybadger = true,
        m9k_mk17 = true,
        m9k_spas12 = true,
        m9k_sten = true,
        m9k_vector = true,
        weapon_zm_mac10 = true,
        weapon_zm_shotgun = true,
        weapon_ttt_m16 = true,
        weapon_zm_rifle = true,
        weapon_zm_sledge = true
    },
    secondary = {
        weapon_zm_pistol = true,
        weapon_zm_revolver = true,
        weapon_ttt_dual_elites = true,
        weapon_ttt_revolver = true,
        weapon_ttt_glock = true,
        weapon_ttt_p228 = true,
        m9k_luger = true,
        m9k_m92beretta = true,
        m9k_tec9 = true,
        m9k_usp = true
    },
    equipment = {
        weapon_ttt_knife = true,
        weapon_ttt_awp = true,
        weapon_ttt_push = true,
        weapon_ttt_thriler = true
    },
    blacklisted_ents = {
        weapon_ttt_knife = true,
        weapon_ttt_awp = true,
        weapon_ttt_push = true,
        weapon_ttt_thriler = true,
        weapon_ttt_ak47 = true,
        weapon_ttt_aug = true,
        weapon_ttt_tmp = true,
        weapon_ttt_galil = true,
        weapon_ttt_famas = true,
        weapon_ttt_sg550 = true,
        weapon_ttt_sg552 = true,
        weapon_ttt_m3 = true,
        weapon_ttt_mp5 = true,
        weapon_ttt_g3sg1 = true,
        weapon_ttt_smg = true,
        weapon_ttt_mac10 = true,
        m9k_acr = true,
        m9k_an94 = true,
        m9k_ar15 = true,
        m9k_g36c = true,
        m9k_honeybadger = true,
        m9k_mk17 = true,
        m9k_spas12 = true,
        m9k_sten = true,
        m9k_vector = true,
        weapon_ttt_p228 = true,
        m9k_luger = true,
        m9k_m92beretta = true,
        m9k_tec9 = true,
        m9k_usp = true,
        weapon_ttt_dual_elites = true,
        weapon_ttt_revolver = true
    },
    choice_allowed_ranks = {
        donator = true
    },
    config_allowed_ranks = {
        superadmin = true
    }
}

TTTWeaponsManager.util.SaveSettings(TTTWeaponsManager.config.forcedSettings)

TTTWeaponsManager.config.Weapons = TTTWeaponsManager.util.FetchConfig()

if SERVER then
    print(TTTWeaponsManager.config.Weapons)

    PrintTable(TTTWeaponsManager.config.Weapons)
end