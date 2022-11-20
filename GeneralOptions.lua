local _, addon = ...

function addon.CreateGeneralOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'GeneralOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('DIALOG')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    local enable = addon:CreateCheckBox(
        OptionsFrame,
        'Enable',
        function() return addon.db.profile.general.enabled end,
        function() return true end,
        false
    )
    enable:SetPoint('TOPLEFT', OptionsFrame, 'TOPLEFT', 10, -10)
    --enable:SetScript('OnClick', function(self)
    --    addon.db.profile.general.enabled = self:GetChecked()
    --end)

    return OptionsFrame
end

function addon.UpdateGeneralOptions()
    enable:SetChecked(addon.db.profile.general.enabled)
end