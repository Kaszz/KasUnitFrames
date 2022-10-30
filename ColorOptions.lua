local _, addon = ...

local function CreateClassColors(parent)
    local classFrame = addon.CreateSubHeader(parent, 'CLASS')
    classFrame:SetPoint('TOP', parent, -5, -40)

    local sharedFG = addon:CreateSingleColorPicker(
            classFrame,
            'SHARED FG',
            function()      return addon.db.profile.colors.classes.solid.mage end,
            function(value)
                addon.db.profile.colors.classes.solid.mage = value
                addon.UpdateUnitFrame('player')
            end,
            function() return addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.mage
    )
    sharedFG:SetPoint('CENTER', -50, -35)

    local toggleFG = addon:CreateToggleButton(
            classFrame,
            170,
            'FOREGROUND COLOR',
            'CLASS',
            'SHARED',
            function()       return addon.db.profile.colors.classes.useSharedFG end,
            function(value)
                addon.db.profile.colors.classes.useSharedFG = value
                sharedFG.Update()
            end
    )
    toggleFG:SetPoint('CENTER', -190, -50)

    local sharedBG = addon:CreateSingleColorPicker(
            classFrame,
            'SHARED BG',
            function()      return addon.db.profile.colors.classes.solid.mage end,
            function(value)
                addon.db.profile.colors.classes.solid.mage = value
                addon.UpdateUnitFrame('player')
            end,
            function() return addon.db.profile.colors.classes.useSharedBG  end,
            addon.defaults.profile.colors.classes.solid.mage
    )
    sharedBG:SetPoint('CENTER', 230, -36)

    local toggleBG = addon:CreateToggleButton(
            classFrame,
            170,
            'BACKGROUND COLOR',
            'CLASS',
            'SHARED',
            function()       return addon.db.profile.colors.classes.useSharedBG end,
            function(value)
                addon.db.profile.colors.classes.useSharedBG = value
                sharedBG.Update()
            end
    )
    toggleBG:SetPoint('CENTER', 90, -50)


end

function addon.CreateColorOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'ColorOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('LOW')
    OptionsFrame:SetHeight(460)
    OptionsFrame:SetWidth(599)
    OptionsFrame:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
    OptionsFrame:Hide()

    local colors = {
        'FFFF0000',
        'FFFF2000',
        'FFFF4000',
        'FFFF6000',
        'FFFF8000',
        'FFFFA000',
        'FFFFC000',
        'FFFFE000',
        'FFFFFF00',
        'FFE0FF00',
        'FFC0FF00',
        'FFA0FF00',
        'FF80FF00',
        'FF60FF00',
        'FF40FF00',
        'FF20FF00',
        'FF00FF00',
        'FF00FF20',
        'FF00FF40',
        'FF00FF60',
        'FF00FF80',
        'FF00FFA0',
        'FF00FFC0',
        'FF00FFE0',
        'FF00FFFF',
        'FF00E0FF',
        'FF00C0FF',
        'FF00A0FF',
        'FF0080FF',
        'FF0060FF',
        'FF0040FF',
        'FF0020FF',
        'FF0000FF',
        'FF2000FF',
        'FF4000FF',
        'FF6000FF',
        'FF8000FF',
        'FFA000FF',
        'FFC000FF',
        'FFE000FF',
        'FFFF00E0',
        'FFFF00C0',
        'FFFF00A0',
        'FFFF0080',
        'FFFF0070',
        'FFFF0060',
        'FFFF0050',
        'FFFF0040',
        'FFFF0020'
    }

    local grad = 'GRADIENT'

    local gradientEnabled = addon.CreateCheckBoxGradient(OptionsFrame, grad, colors, addon.db.profile.colors.gradient)
    gradientEnabled:SetPoint('TOPLEFT', OptionsFrame, 'TOPLEFT', 10, -10)
    gradientEnabled:SetScript('OnClick', function(self)
        addon.db.profile.colors.gradient = self:GetChecked()
    end)

    CreateClassColors(OptionsFrame)

    return OptionsFrame
end

function addon.UpdateColorOptions()
    print('do nothing')
end