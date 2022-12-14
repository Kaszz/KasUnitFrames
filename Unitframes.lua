local _, addon = ...
local oUF = addon.oUF
local units = {}
local TEXTURE = [[Interface\AddOns\SharedMedia\statusbar\Melli.tga]]

local function AddBorder(frame, level)
	local Border = CreateFrame("Frame", nil, frame, "BackdropTemplate");
	Border:SetFrameLevel(level)
	Border:SetPoint('CENTER')
	Border:SetBackdrop({
		edgeFile="Interface\\Buttons\\WHITE8x8",
		edgeSize = 1,
	})
	Border:SetBackdropBorderColor(0, 0, 0)

	return Border
end

local function SetFrameColor(frame, fg, bg, fadeBg)
	frame.Health:SetStatusBarColor(
		fg.r / 255,
		fg.g / 255,
		fg.b / 255,
		fg.a / 100
	)

	frame.HealthBG:SetVertexColor(
		bg.r / 255,
		bg.g / 255,
		bg.b / 255,
		bg.a / 100
	)

	if (fadeBg) then
		frame.HealthBGOverlay:SetVertexColor(0, 0, 0, 0.6)
	else
		frame.HealthBGOverlay:SetVertexColor(0, 0, 0, 0)
	end
end

local function UpdateUnitFrameColor(object, unit)
	if (UnitExists(unit)) then

		local _, class = UnitClass(unit);
		local isPlayer = UnitIsPlayer(unit)
		local reaction = UnitReaction('player', unit);

		local fg, bg
		local fadeBg = false

		if (isPlayer) then
			class = string.lower(class)

			if addon.db.profile.colors.classes.useSharedFG then
				fg = addon.db.profile.colors.classes.solid.shared.fg
			else
				fg = addon.db.profile.colors.classes.solid[class]
			end

			if addon.db.profile.colors.classes.useSharedBG then
				bg = addon.db.profile.colors.classes.solid.shared.bg
			else
				bg = addon.db.profile.colors.classes.solid[class]
			end
			if (not addon.db.profile.colors.classes.useSharedBG and not addon.db.profile.colors.classes.useSharedFG) then
				fadeBg = true
			end
		elseif (reaction > 4) then -- friendly
			if addon.db.profile.colors.classes.useSharedFG then
				fg = addon.db.profile.colors.classes.solid.shared.fg
			else
				fg = addon.db.profile.colors.npc.friendly
			end

			if addon.db.profile.colors.classes.useSharedBG then
				bg = addon.db.profile.colors.classes.solid.shared.bg
			else
				bg = addon.db.profile.colors.npc.friendly
			end
			if (not addon.db.profile.colors.classes.useSharedBG and not addon.db.profile.colors.classes.useSharedFG) then
				fadeBg = true
			end
		elseif (reaction == 4) then -- neutral
			if addon.db.profile.colors.classes.useSharedFG then
				fg = addon.db.profile.colors.classes.solid.shared.fg
			else
				fg = addon.db.profile.colors.npc.neutral
			end

			if addon.db.profile.colors.classes.useSharedBG then
				bg = addon.db.profile.colors.classes.solid.shared.bg
			else
				bg = addon.db.profile.colors.npc.neutral
			end
			if (not addon.db.profile.colors.classes.useSharedBG and not addon.db.profile.colors.classes.useSharedFG) then
				fadeBg = true
			end
		elseif (reaction < 4) then -- hostile
			if addon.db.profile.colors.classes.useSharedFG then
				fg = addon.db.profile.colors.classes.solid.shared.fg
			else
				fg = addon.db.profile.colors.npc.hostile
			end

			if addon.db.profile.colors.classes.useSharedBG then
				bg = addon.db.profile.colors.classes.solid.shared.bg
			else
				bg = addon.db.profile.colors.npc.hostile
			end
			if (not addon.db.profile.colors.classes.useSharedBG and not addon.db.profile.colors.classes.useSharedFG) then
				fadeBg = true
			end
		end
		SetFrameColor(object, fg, bg, fadeBg)
	end
end

function addon:UpdateUnitFrame(unit)
	for k, v in pairs(units) do
		if k == unit then
			v.Health.Border:GetBackdrop().edgeSize = addon.db.profile[unit].power.height
			if not addon.db.profile[unit].enabled then
				v.Health:SetShown(false)
				v.Power:SetShown(false)
				v.Power:SetHeight(0)
			else
				v.Health:SetShown(true)
				v:SetWidth(addon.db.profile[unit].size.width)
				v:SetHeight(addon.db.profile[unit].size.height)
				v.Health:SetHeight(addon.db.profile[unit].size.height)
				v:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', addon.db.profile[unit].size.x, addon.db.profile[unit].size.y)
				v.Health.Border:SetSize(addon.db.profile[unit].size.width + 2, addon.db.profile[unit].size.height + 2)
				if not addon.db.profile[unit].power.enabled then
					v.Power:SetShown(false)
					v.Power:SetHeight(0)
					v.Power.Border:Hide()
				else
					v.Power:SetShown(true)
					v.Power:SetHeight(addon.db.profile[unit].power.height)
					v.Power.Border:Show()
					v.Power.Border:SetSize(addon.db.profile[unit].size.width + 2, addon.db.profile[unit].power.height + 2)
				end

				if addon.db.profile[unit].size.height < addon.db.profile[unit].power.height then
					addon.db.profile[unit].power.height = addon.db.profile[unit].size.height
				end

				UpdateUnitFrameColor(v, unit)
			end
		end
	end
end

function addon:UpdateAllUnitFrame()
	for k, _ in pairs(units) do
		addon:UpdateUnitFrame(k)
	end
end

local function UpdateHealth(self, event, unit)
	if(not unit or self.unit ~= unit) then
		return
	end

	local element = self.Health
	element:SetShown(UnitIsConnected(unit))

	if(element:IsShown()) then
		local cur = UnitHealth(unit)
		local max = UnitHealthMax(unit)
		element:SetMinMaxValues(0, max)
		element:SetValue(cur)
	end

	if (unit ~= 'player') then
		UpdateUnitFrameColor(units[unit], unit)
	end
end

local function Shared(self, unit)
	unit = unit:match('^(.-)%d+') or unit

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetStatusBarTexture(TEXTURE)
	Health:SetReverseFill(false)
	Health:SetFrameLevel(2)
	Health.Override = UpdateHealth
	Health.frequentUpdates = true
	Health:SetPoint('TOPRIGHT')
	Health:SetPoint('TOPLEFT')
	self.Health = Health

	local HealthBG = Health:CreateTexture(nil, 'BORDER', nil, 2)
	HealthBG:SetTexture(TEXTURE)
	HealthBG:SetAllPoints(Health)
	self.HealthBG = HealthBG

	local HealthBGOverlay = Health:CreateTexture(nil, 'BORDER', nil, 3)
	HealthBGOverlay:SetTexture(TEXTURE)
	HealthBGOverlay:SetAllPoints(Health)
	self.HealthBGOverlay = HealthBGOverlay

	local HealthBorder = AddBorder(self.Health, 2)
	self.Health.Border = HealthBorder

	local Power = CreateFrame('StatusBar', nil, self)
	Power:SetPoint('BOTTOMRIGHT')
	Power:SetPoint('BOTTOMLEFT')
	Power:SetHeight(0)
	Power:SetStatusBarTexture(TEXTURE)
	Power:SetStatusBarColor(0.1, 0.1, 1)
	Power.frequentUpdates = true
	self.Power = Power

	Power.colorPower = true
	Power.colorTapping = true
	Power.colorDisconnected = true
	Power.colorReaction = true

	local PowerBG = Power:CreateTexture(nil, 'BORDER')
	PowerBG:SetAllPoints()
	PowerBG:SetTexture(TEXTURE)
	PowerBG.multiplier = 1/3
	Power.bg = PowerBG

	local PowerBorder = AddBorder(self.Power, 3)
	self.Power.Border = PowerBorder

	local RaidTarget = Health:CreateTexture(nil, 'OVERLAY')
	RaidTarget:SetPoint('TOP', self, 0, 8)
	RaidTarget:SetSize(16, 16)
	self.RaidTargetIndicator = RaidTarget

	--tinsert(units, {unit = unit, object = self})
	units[unit] = self

	addon:UpdateUnitFrame(unit)
end

oUF:RegisterStyle('KUF', Shared)
oUF:Factory(function(self)
	self:SetActiveStyle('KUF')
	--self:Spawn('player')
	self:Spawn('target')
end)
