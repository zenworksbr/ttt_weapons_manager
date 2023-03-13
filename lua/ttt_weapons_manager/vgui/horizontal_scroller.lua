local PANEL = {
	Start = 1,
	End = 5
}

function PANEL:MoveLoadout(direction)
	if self.Moving or (direction ~= LEFT and direction ~= RIGHT) then return end

	if direction == LEFT and self.Start > 1 then
		self.Start = self.Start-1
		self.End = self.End-1
	elseif direction == RIGHT and self.End < self.WeaponsCount then
		self.Start = self.Start+1
		self.End = self.End+1
	else 
        return 
    end

	if not GAMEMODE.LoadoutMoveID then
		GAMEMODE.LoadoutMoveID = 1
	else
		GAMEMODE.LoadoutMoveID = GAMEMODE.LoadoutMoveID + 1
	end

	self.Moving = true
	local i = 0

	local name = "TimerLoadoutMove_" .. tostring(GAMEMODE.LoadoutMoveID)

	hook.Add("Think", name, function()
		i = i + 1

		if IsValid(self.Loadout) then
			local x, y = self.Loadout:GetPos()

			if direction == LEFT then
				self.Loadout:SetPos(x+6, y)
			else
				self.Loadout:SetPos(x-6, y)
			end
		end

		if i == 16 then
			self.Moving = false

			if self.End >= self.WeaponsCount then
				self.Right:SetEnabled(false)
			else
				self.Right:SetEnabled(true)
			end

			if self.Start <= 1 then
				self.Left:SetEnabled(false)
			else
				self.Left:SetEnabled(true)
			end

			hook.Remove("Think", name)
		end
	end)
end

function PANEL:SetCategory(name)
	self.CategoryName = name

	self:SetName(name)
end

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
	if self.CheckBox:GetChecked() or !TTTWeaponsManager.config.Table.choice_allowed_ranks[LocalPlayer():GetUserGroup()] then
		return "random"
	elseif self.Loadout.SelectedPanel then
		return self.Loadout.SelectedPanel.Value
	else
		return GetConVar(self.cvar):GetString()
	end
end

function PANEL:Toggle()
	-- nope
end

function PANEL:AddWeapons()
	for k, v in pairs(self.Weapons) do
		local icon = vgui.Create("SimpleIcon", self.Loadout)
		icon.Value = k

		icon:SetIconSize(90)

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

		self.Loadout:AddPanel(icon)

		if GetConVar(self.cvar):GetString() == k then
			self.Loadout:SelectPanel(icon)
		end

	end

	self.WeaponsCount = table.Count(self.Weapons)

	if self.WeaponsCount <= 5 then
		self.Right:SetEnabled(false)
	end

	self.Loadout:SetSize(self.WeaponsCount*96, 100)
	self.CheckBox:SetChecked(GetConVar(self.cvar):GetString() == "random")
end

function PANEL:Init()

	self.CheckBox = vgui.Create("DCheckBoxLabel", self)
	self.CheckBox:SetPos(320, 3)
	self.CheckBox:SetText("Aleatório")
	self.CheckBox:SizeToContents()
	if self.cvar == "random" then 
		self.CheckBox:SetChecked(true)
	end

	self.Save = vgui.Create("DButton", self)
	self.Save:SetSize(50, 17)
	self.Save:SetPos(438, 1)
	self.Save:SetText("Salvar")
	self.Save.DoClick = function()
		RunConsoleCommand(self.cvar, self:GetNewValue())
		TTTWeaponsManager.net.SendPreferencesToServer()
	end

	self.Panel = vgui.Create("DPanel", self)
	self.Panel:SetPos(0, 20)
	self.Panel:SetSize(540, 100)
	self.Panel.Paint = function(panel, w, h)
		surface.SetDrawColor(Color(200, 200, 200))
		surface.DrawRect(30, 1, w-60, h-2)
	end

	self.Loadout = vgui.Create("DPanelSelect", self.Panel)
	self.Loadout:SetSpacing(3)
	self.Loadout:EnableHorizontal(true)

	local old_selectpanel = self.Loadout.SelectPanel

	self.Loadout.SelectPanel = function(panel, selected)
		old_selectpanel(panel, selected)
		print(old_selectpanel(panel, selected))
		print(self.Loadout.SelectedPanel.Value)

		if selected then
			selected.PaintOver = function(_, w,h)
				surface.SetDrawColor(Color(255, 50, 0))

				for i = 0, 2 do
					surface.DrawOutlinedRect(i, i, w - i * 2, h - i * 2)
				end
			end
		end
	end

	self.Loadout:SetPos(35, 5)

	self.Right = vgui.Create("DButton", self.Panel)
	self.Right:SetPos(505, 0)
	self.Right:SetSize(35, 100)
	self.Right:SetText(">")
	self.Right.DoClick = function()
		self:MoveLoadout(RIGHT)
	end

	self.Left = vgui.Create("DButton", self.Panel)
	self.Left:SetSize(35, 100)
	self.Left:SetText("<")
	self.Left.DoClick = function()
		self:MoveLoadout(LEFT)
	end
	self.Left:SetEnabled(false)

end

vgui.Register("HorizontalSelect", PANEL, "DForm")
