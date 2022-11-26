local _, addon = ...

function addon.CreateGeneralOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'GeneralOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('DIALOG')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    return OptionsFrame
end

function addon.UpdateGeneralOptions()
    --enable:SetChecked(addon.db.profile.general.enabled)
end