local _, addon = ...

local enable;

function addon.CreatePlayerOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'GeneralOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('LOW')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    enable = addon.CreateCheckBox(OptionsFrame, 'Enable', 200)
    enable:SetPoint('TOPLEFT', OptionsFrame, 'TOPLEFT', 10, -10)
    enable:SetScript('OnClick', function(self)
        addon.db.profile.player.enabled = self:GetChecked()
    end)

    local sizeAndPositioning = addon.CreateSubHeader(OptionsFrame, 'SIZE & POSITIONING', 150)
    sizeAndPositioning:SetPoint('TOP', OptionsFrame, -5, -40)

    local widthSlider = addon.CreateSlider(OptionsFrame)
    widthSlider:SetPoint('LEFT', sizeAndPositioning, 5, -40)

    return OptionsFrame
end

function addon.UpdatePlayerOptions()
    enable:SetChecked(addon.db.profile.player.enabled)
end