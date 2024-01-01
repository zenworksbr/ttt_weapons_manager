if !RayHUDTTT then return end

local PANEL = {}

local allowed_ranks = TTTWeaponsManager.config:FetchSingle('choice_allowed_ranks')
local weapon_table = TTTWeaponsManager.config:FetchSingle('weapons')

function PANEL:SetWeapons(tbl)
	self.Weapons = {}

	for _, v in pairs(tbl) do
		if v then 
			self.Weapons[_] = weapons.Get(_)
		end
	end

	self:AddWeapons()
end

function PANEL:GetNewValue()
	
	if self.CheckBox:GetChecked() or !allowed_ranks[LocalPlayer():GetUserGroup()] then
		return "random"
	elseif self.Loadout.SelectedPanel then
		return self.Loadout.SelectedPanel.Value
	else
		return GetConVar(self.cvar):GetString()
	end
end

function PANEL:AddWeapons()
	for k, v in pairs(self.Weapons) do
		local icon = vgui.Create("SimpleIcon", self.Loadout)
		icon.Value = k

		icon:SetIconSize(64 * RayUI.Scale)

		icon:SetIcon(v.Icon or "vgui/ttt/icon_nades")

		local wep_name = v.PrintName

		if LANG.GetTranslation(wep_name) != "[ERROR: Translation of " .. wep_name .. " not found]" then
			wep_name = LANG.GetTranslation(wep_name)
		end

		icon:SetTooltip(wep_name)

		local old_func = icon.OnCursorEntered

		icon.OnCursorEntered = function(panel)
			if self.Moving then return end
			old_func(panel)
		end

		self.Loadout:Add(icon)

		icon.DoClick = function()
			self.Loadout:SelectPanel(icon)
		end

		if GetConVar(self.cvar):GetString() == k then
			self.Loadout:SelectPanel(icon)
		end
	end

	self.WeaponsCount = table.Count(self.Weapons)
	self.CheckBox:SetChecked(GetConVar(self.cvar):GetString() == "random")
end

function PANEL:Init()
	self.CheckBox = RayUI:MakeCheckbox(self, nil, "Aleatório")

	self.Panel = vgui.Create("DScrollPanel", self)
	self.Panel:Dock(TOP)
	self.Panel:SetTall(150 * RayUI.Scale)
	self.Panel:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Panel.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, RayUI.Colors.DarkGray6 )
	end
    self.Panel:CustomScrollBar()

	self.Loadout = vgui.Create("EquipSelect", self.Panel)
	self.Loadout:Dock(FILL)
	self.Loadout:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Loadout:SetSpaceX(4 * RayUI.Scale)
	self.Loadout:SetSpaceY(4 * RayUI.Scale)

	self.Save = vgui.Create("DButton", self)
	self.Save:Dock(TOP)
	self.Save:DockMargin(10 * RayUI.Scale, 10 * RayUI.Scale, 10 * RayUI.Scale, 0)
	self.Save:SetTall(30 * RayUI.Scale)
	self.Save.DoClick = function()

		RunConsoleCommand(self.cvar, self:GetNewValue())
	end

	self.Save:FormatRayButton("Salvar", RayUI.Colors.DarkGray6, RayUI.Colors.Green)
end
vgui.Register("RayHUDTTT:TTTWeaponsManager_LoadoutPanel", PANEL, "Panel")

RayHUDTTT.Help.CreateSettings("Armas Iniciais", RayUI.Icons.Vest, function(parent)

    if !allowed_ranks[LocalPlayer():GetUserGroup()] then return end

    RayHUDTTT.Help.CreateCategory(parent, "Armas primárias", 260 * RayUI.Scale, function(parent)
    
        local PrimaryLoadout = vgui.Create("RayHUDTTT:TTTWeaponsManager_LoadoutPanel", parent)
        PrimaryLoadout.cvar = "ttt_weapons_manager_primary_choice"
        PrimaryLoadout:SetWeapons(weapon_table.primary)
        PrimaryLoadout:Dock(TOP)
        PrimaryLoadout:SetTall(360 * RayUI.Scale)

    end)

    RayHUDTTT.Help.CreateCategory(parent, "Armas secundárias", 260 * RayUI.Scale, function(parent)

        local SecondaryLoadout = vgui.Create("RayHUDTTT:TTTWeaponsManager_LoadoutPanel", parent)
        SecondaryLoadout.cvar = "ttt_weapons_manager_secondary_choice"
        SecondaryLoadout:SetWeapons(weapon_table.secondary)
        SecondaryLoadout:Dock(TOP)
        SecondaryLoadout:SetTall(260 * RayUI.Scale)

    end)
    
    RayHUDTTT.Help.CreateCategory(parent, "Equipamentos", 260 * RayUI.Scale, function(parent)

        local EquipmentLoadout = vgui.Create("RayHUDTTT:TTTWeaponsManager_LoadoutPanel", parent)
        EquipmentLoadout.cvar = "ttt_weapons_manager_equipment_choice"
        EquipmentLoadout:SetWeapons(weapon_table.equipment)
        EquipmentLoadout:Dock(TOP)
        EquipmentLoadout:SetTall(260 * RayUI.Scale)
    
    end)

end)