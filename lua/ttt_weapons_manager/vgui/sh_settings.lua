
include("horizontal_scroller.lua")
hook.Add("TTTSettingsTabs", "TTTWeaponsMenuSettingsTabInitialize", function(dtabs)

    local tab = vgui.Create( "DPanel", dtabs )
    tab:Dock(FILL)
    tab:SetBackgroundColor(Color(0, 0, 0, 0))
    
    local submenu = vgui.Create("DPropertySheet", tab)
    submenu:Dock(FILL)
    local area = vgui.Create( "DPanel", submenu )
    area:Dock(FILL)
    area:SetBackgroundColor(Color(0, 0, 0, 0))


    local panel1 = vgui.Create( "DPanel", area )
    submenu:AddSheet( "Preferências", panel1, "icon16/gun.png" )
    local panel1scroll = vgui.Create("DScrollPanel",panel1)
    panel1scroll:Dock(FILL)


    local panel2 = vgui.Create( "DPanel", area )
    local panel2scroll = vgui.Create("DScrollPanel", panel2)
    panel2scroll:Dock(FILL)
    submenu:AddSheet( "Gerenciar", panel2, "icon16/wrench.png" )
    
    local primary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    primary_loadout.cvar = "ttt_weapons_manager_primary_choice"

    primary_loadout:SetCategory("Armas primárias")
    primary_loadout:SetWeapons(TTTWeaponsManager.config.Table["weapons"].primary)
    primary_loadout:SetSize(540, 50)
    primary_loadout:SetPos(15, 10)

    local secondary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    secondary_loadout.cvar = "ttt_weapons_manager_secondary_choice"

    secondary_loadout:SetCategory("Armas secundárias")
    secondary_loadout:SetWeapons(TTTWeaponsManager.config.Table["weapons"].secondary)
    secondary_loadout:SetSize(540, 50)
    secondary_loadout:SetPos(15, 140)
    
    local equipment_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    equipment_loadout.cvar = "ttt_weapons_manager_equipment_choice"

    equipment_loadout:SetCategory("Equipamentos")
    equipment_loadout:SetWeapons(TTTWeaponsManager.config.Table["weapons"].equipment)
    equipment_loadout:SetSize(540, 50)
    equipment_loadout:SetPos(15, 270)

    equipment_loadout:DockPadding(0,0,0,10)

    if (TTTWeaponsManager.config.Table.config_allowed_ranks[LocalPlayer():GetUserGroup()]) then

        local checkbox = vgui.Create("DCheckBox", panel2)
        checkbox:SetValue( false )
        checkbox:SetPos(10, 10)

        local checkbox_label = vgui.Create("DLabel", panel2)
        checkbox_label:SetPos(30, 7)
        checkbox_label:SetText( "Hello, world!" )
        checkbox_label:SetColor(Color(255, 0, 0))
    
    end

    dtabs:AddSheet("Armas Iniciais", tab , "icon16/gun.png")
end)