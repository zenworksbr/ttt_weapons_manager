-- Settings Hook

hook.Add("TTTSettingsTabs", "SpecDM_TTTSettingsTab", function(dtabs)
	local dsettings = vgui.Create("DScrollPanel", dtabs)
	local ply = LocalPlayer()

	if SpecDM.LoadoutEnabled then
		local primary_loadout = vgui.Create("SpecDM_LoadoutPanel")

		primary_loadout.cvar = "ttt_specdm_primaryweapon"

		primary_loadout:SetCategory("Primary weapons")
		primary_loadout:SetWeapons(SpecDM.Ghost_weapons.primary)
		primary_loadout:SetSize(550, 50)
		primary_loadout:SetPos(10, 10)

		dsettings:AddItem(primary_loadout)

		local secondary_loadout = vgui.Create("SpecDM_LoadoutPanel")
		secondary_loadout.cvar = "ttt_specdm_secondaryweapon"

		secondary_loadout:SetCategory("Secondary weapons")
		secondary_loadout:SetWeapons(SpecDM.Ghost_weapons.secondary)
		secondary_loadout:SetSize(550, 50)
		secondary_loadout:SetPos(10, 140)

		dsettings:AddItem(secondary_loadout)

		local equipment_loadout = vgui.Create("SpecDM_LoadoutPanel")
		equipment_loadout.cvar = "ttt_specdm_secondaryweapon"

		equipment_loadout:SetCategory("Secondary weapons")
		equipment_loadout:SetWeapons(SpecDM.Ghost_weapons.secondary)
		equipment_loadout:SetSize(550, 50)
		equipment_loadout:SetPos(10, 140)

		dsettings:AddItem(equipment_loadout)
	end

	
	-- Admin COnfigs
	if ply:GetUserGroup() == 'superadmin' then


		local dgui = vgui.Create("DForm", dsettings)
		dgui:SetName("General settings")

		
	dgui:SetSize(555, 50)
	dgui:SetPos(10, 270)

	dsettings:AddItem(dgui)

	end

	dtabs:AddSheet("Armas Iniciais", dsettings, "icon16/gun.png", false, false, "Armas Iniciais")

end)
