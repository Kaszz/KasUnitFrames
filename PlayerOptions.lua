local _, addon = ...

local enable
local subheader = {}
local sliders = {}
local checkboxes = {}

local function ToggleOptions()
    if not addon.db.profile.player.enabled then
        for _, value in pairs(subheader) do
            value:SetAlpha(0.3)
        end

        for _, value in pairs(sliders) do
            value.slider:SetAlpha(0.3)
            value.slider.enabled = addon.db.profile.player.enabled
        end

        for _, value in pairs(checkboxes) do
            value:SetAlpha(0.3)
            value.enabled = addon.db.profile.player.power.enabled
            value:Disable()
        end
    else
        for _, value in pairs(subheader) do
            value:SetAlpha(1.0)
        end

        for _, value in pairs(sliders) do
            value.slider:SetAlpha(1.0)
            value.slider.enabled = addon.db.profile.player.enabled
        end

        for _, value in pairs(checkboxes) do
            value:SetAlpha(1.0)
            value.enabled = addon.db.profile.player.power.enabled
            value:Enable()
        end
    end

    addon.UpdateUnitFrame('player')
end

local function CreateSizeAndPositioning(parent)
    local sizeAndPositioning = addon.CreateSubHeader(parent, 'SIZE & POSITIONING')
    sizeAndPositioning:SetPoint('TOP', parent, -5, -40)
    table.insert(subheader, sizeAndPositioning)

    local widthSlider = addon.CreateBoxSlider(parent, 'WIDTH', 'player', 'size', 'width', 5, 1000)
    widthSlider:SetPoint('BOTTOM', sizeAndPositioning, -225, -45)
    sliders['width'] = {
        section = 'size',
        slider = widthSlider
    }

    local heightSlider = addon.CreateBoxSlider(parent, 'HEIGHT', 'player', 'size', 'height', 5, 1000)
    heightSlider:SetPoint('BOTTOM', sizeAndPositioning, -75, -45)
    sliders['height'] = {
       section = 'size',
       slider = heightSlider
    }

    local xSlider = addon.CreateBoxSlider(parent, 'X', 'player', 'size', 'x', (math.floor(GetScreenWidth()/2 * -1)), math.floor(GetScreenWidth()/2))
    xSlider:SetPoint('BOTTOM', sizeAndPositioning, 75, -45)
    sliders['x'] = {
        section = 'size',
        slider = xSlider
    }

    local ySlider = addon.CreateBoxSlider(parent, 'Y', 'player', 'size', 'y', (math.floor(GetScreenHeight()/2 * -1)), math.floor(GetScreenHeight()/2))
    ySlider:SetPoint('BOTTOM', sizeAndPositioning, 225, -45)
    sliders['y'] = {
        section = 'size',
        slider = ySlider
    }
end

local function CreatePower(parent)
    local power = addon.CreateSubHeader(parent, 'POWER')
    power:SetPoint('TOP', parent, -5, -125)
    table.insert(subheader, power)

    local powerEnable = addon.CreateCheckBox(parent, 'ENABLE', addon.db.profile.player.power.enabled)
    powerEnable:SetPoint('TOPLEFT', parent, 'TOPLEFT', 46, -160)
    table.insert(checkboxes, powerEnable)
    powerEnable:SetScript('OnClick', function(self)
        addon.db.profile.player.power.enabled = self:GetChecked()
        addon.UpdateUnitFrame('player')
    end)

    local powerHeight = addon.CreateBoxSlider(parent, 'HEIGHT', 'player', 'power', 'height', 1, addon.db.profile.player.size.height - 1)
    powerHeight:SetPoint('BOTTOM', power, -75, -45)
    sliders['height'] = {
        section = 'power',
        slider = powerHeight
    }
end

function addon.CreatePlayerOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'GeneralOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('LOW')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    enable = addon.CreateCheckBox(OptionsFrame, 'ENABLE', addon.db.profile.player.enabled)
    enable:SetPoint('TOPLEFT', OptionsFrame, 'TOPLEFT', 10, -10)
    enable:SetScript('OnClick', function(self)
        addon.db.profile.player.enabled = self:GetChecked()
        ToggleOptions()
    end)

    CreateSizeAndPositioning(OptionsFrame)
    CreatePower(OptionsFrame)

    return OptionsFrame
end

function addon.UpdatePlayerOptions()
    enable:SetChecked(addon.db.profile.player.enabled)

    for key, value in pairs(sliders) do
        value.slider:SetNumber(addon.db.profile.player[value.section][key])

        if section == 'power' and key == height then
            value.slider.upper = addon.db.profile.player.size.height
        end
    end

    ToggleOptions()
end