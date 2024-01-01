if RayHUDTTT then return end

local weapon_table = TTTWeaponsManager.config:FetchSingle('weapons')

hook.Add("TTTSettingsTabs", "TTTWeaponsMenuSettingsTabInitialize", function(dtabs)

    if (!TTTWeaponsManager.config.Table.choice_allowed_ranks[LocalPlayer():GetUserGroup()] and !TTTWeaponsManager.config.Table.config_allowed_ranks[LocalPlayer():GetUserGroup()]) then return end

    local tab = vgui.Create( "DPanel", dtabs )
    tab:Dock(FILL)
    tab:SetBackgroundColor(Color(0, 0, 0, 0))

    local panel1scroll = vgui.Create("DScrollPanel", tab)
    panel1scroll:Dock(FILL)

    local primary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    primary_loadout.cvar = "ttt_weapons_manager_primary_choice"

    primary_loadout:SetCategory("Armas primárias")
    primary_loadout:SetWeapons(weapon_table.primary)
    primary_loadout:SetSize(540, 50)
    primary_loadout:SetPos(30, 0)

    local secondary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    secondary_loadout.cvar = "ttt_weapons_manager_secondary_choice"

    secondary_loadout:SetCategory("Armas secundárias")
    secondary_loadout:SetWeapons(weapon_table.secondary)
    secondary_loadout:SetSize(540, 50)
    secondary_loadout:SetPos(30, 125)
    
    local equipment_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    equipment_loadout.cvar = "ttt_weapons_manager_equipment_choice"

    equipment_loadout:SetCategory("Equipamentos")
    equipment_loadout:SetWeapons(weapon_table.equipment)
    equipment_loadout:SetSize(540, 50)
    equipment_loadout:SetPos(30, 250)

    equipment_loadout:DockPadding(0,0,0,10)

    dtabs:AddSheet("Armas Iniciais", tab , "icon16/gun.png")

end)