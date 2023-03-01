local SCROLL_SPEED = 50

include("horizontal_scroller.lua")
// include("config.lua")

hook.Add("TTTSettingsTabs", "InitialWeaponsConfigTab", function(dtabs)

    local tab = vgui.Create( "DPanel", dtabs )
    tab:Dock(FILL)
    tab:SetBackgroundColor(Color(0, 0, 0, 0))
    
    local submenu = vgui.Create("DPropertySheet", tab)
    submenu:Dock(FILL)
    local area = vgui.Create( "DPanel", submenu )
    area:Dock(FILL)
    area:SetBackgroundColor(Color(0, 0, 0, 0))
    

    local panel1 = vgui.Create( "DPanel", area )
    submenu:AddSheet( "Armas", panel1, "icon16/gun.png" )
    local panel1scroll = vgui.Create("DScrollPanel",panel1)
    panel1scroll:Dock(FILL)


    local panel2 = vgui.Create( "DPanel", area )
    local panel2scroll = vgui.Create("DScrollPanel",panel2)
    panel2scroll:Dock(FILL)
    submenu:AddSheet( "Configurar", panel2, "icon16/wrench.png" )
    
    local primary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    primary_loadout.cvar = "ttt_primaryweapon"

    primary_loadout:SetCategory("Primary weapons")
    primary_loadout:SetWeapons({
        weapon_zm_mac10 = true,
        weapon_zm_shotgun = true,
        weapon_ttt_m16 = true,
        weapon_zm_rifle = true,
        weapon_zm_sledge = true,
        weapon_ttt_mac10 = true
    })
    primary_loadout:SetSize(540, 50)
    primary_loadout:SetPos(15, 10)

    local secondary_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    secondary_loadout.cvar = "ttt_secondaryweapon"

    secondary_loadout:SetCategory("Secondary weapons")
    secondary_loadout:SetWeapons({
        weapon_zm_pistol = true,
        weapon_ttt_glock = true,
        weapon_zm_revolver = true
    })
    secondary_loadout:SetSize(540, 50)
    secondary_loadout:SetPos(15, 140)
    
    local equipment_loadout = vgui.Create("HorizontalSelect", panel1scroll)

    equipment_loadout.cvar = "ttt_equipmentweapon"

    equipment_loadout:SetCategory("Equipments")
    equipment_loadout:SetWeapons({
        weapon_ttt_knife = true, // traitor knife - slot 7
        weapon_ttt_confgrenade = true, // discombulator - slot 4
        weapon_zm_molotov = true, // incendiary grenade - slot 4
        weapon_ttt_smokegrenade = true, // smoke grenade - slot 4
        weapon_ttt_c4 = true, // c4 - slot 7
        weapon_ttt_phammer = true // poltergeist - slot 8
    })
    equipment_loadout:SetSize(540, 50)
    equipment_loadout:SetPos(15, 270)

    equipment_loadout:DockPadding(0,0,0,10)

        if(LocalPlayer():GetUserGroup() == "superadmin") then

            local checkbox = vgui.Create("DCheckBox", panel2)
            checkbox:SetValue( false )
            checkbox:SetPos(10, 10)

            local checkbox_label = vgui.Create("DLabel", panel2)
            checkbox_label:SetPos(30, 7)
            checkbox_label:SetText( "Hello, world!" )
            checkbox_label:SetColor(Color(255, 0, 0))
        
        end
    

    dtabs:AddSheet("Armas Iniciais",tab , "icon16/gun.png")
end
)
