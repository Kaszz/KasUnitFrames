local _, addon = ...
local oUF = addon.oUF
local _, playerClass = UnitClass('player')
local units = {}
local TEXTURE = [[Interface\AddOns\SharedMedia\statusbar\Melli.tga]]

function addon.UpdateUnitFrame(unit)
	for _, v in pairs(units) do
		if v.unit == unit then
			if not addon.db.profile[unit].enabled then
				v.object.Health:SetShown(false)
				v.object.Power:SetShown(false)
				v.object.Power:SetHeight(0)
			else
				v.object.Health:SetShown(true)
				v.object:SetWidth(addon.db.profile[unit].size.width)
				v.object:SetHeight(addon.db.profile[unit].size.height)
				v.object.Health:SetHeight(addon.db.profile[unit].size.height)
				v.object:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', addon.db.profile[unit].size.x, addon.db.profile[unit].size.y)
				if not addon.db.profile[unit].power.enabled then
					v.object.Power:SetShown(false)
					v.object.Power:SetHeight(0)
				else
					v.object.Power:SetShown(true)
					v.object.Power:SetHeight(addon.db.profile[unit].power.height)
				end

				if addon.db.profile[unit].size.height < addon.db.profile[unit].power.height then
					addon.db.profile[unit].power.height = addon.db.profile[unit].size.height

					if unit == 'player' then
						addon.UpdatePlayerOptions()

					end
				end
			end
		end
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
		element:SetValue(max - cur)
	end
end

local UnitSpecific = {
	player = function(self)
		addon.UpdateUnitFrame('player')
	end
}

local function Shared(self, unit)
	unit = unit:match('^(.-)%d+') or unit
	r, g, b = GetClassColor(playerClass)

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	local Health = CreateFrame('StatusBar', nil, self)
	Health:SetStatusBarTexture(TEXTURE)
	Health:SetStatusBarColor(0.2, 0.2, 0.2)
	Health:SetReverseFill(true)
	Health:SetFrameLevel(2)
	Health.Override = UpdateHealth
	Health.frequentUpdates = true
	Health:SetPoint('TOPRIGHT')
	Health:SetPoint('TOPLEFT')
	self.Health = Health

	local HealthBG = Health:CreateTexture(nil, 'BORDER')
	HealthBG:SetTexture(TEXTURE)
	HealthBG:SetAllPoints(Health)
	HealthBG:SetVertexColor(r, g, b)

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

	local RaidTarget = Health:CreateTexture(nil, 'OVERLAY')
	RaidTarget:SetPoint('TOP', self, 0, 8)
	RaidTarget:SetSize(16, 16)
	self.RaidTargetIndicator = RaidTarget

	tinsert(units, {unit = unit, object = self})

	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle('KUF', Shared)
oUF:Factory(function(self)
	self:SetActiveStyle('KUF')
	self:Spawn('player')
end)
