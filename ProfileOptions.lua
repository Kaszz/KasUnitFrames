local _, addon = ...

function addon.CreateProfileOptionsFrame(parent, profilesFrame)
    local OptionsFrame = CreateFrame('Frame', 'GeneralOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('LOW')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    local button = addon.CreateButton(OptionsFrame, 'Open Profile Settings', 150)
    button:SetPoint('TOPLEFT', OptionsFrame, 'TOPLEFT', 10, -10)
    button:SetScript('OnClick', function()
        parent:Hide()
        InterfaceOptionsFrame_OpenToCategory(profilesFrame)
        InterfaceOptionsFrame_OpenToCategory(profilesFrame)
    end)

    return OptionsFrame
end