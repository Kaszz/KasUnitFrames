local _, addon = ...
local colorPickers = {}

local function CreateClassColors(parent)
    local classFrame = addon:CreateHeader(parent, 'CLASS')
    classFrame:SetPoint('TOP', parent, -5, -40)

    local toggleFG = addon:CreateToggleButton(
            classFrame,
            170,
            'FOREGROUND COLOR',
            'CLASS',
            'SHARED',
            function()       return addon.db.profile.colors.classes.useSharedFG end,
            function(value)
                addon.db.profile.colors.classes.useSharedFG = value
                for _, v in pairs(colorPickers) do
                    v.Update()
                end
                addon:UpdateAllUnitFrame()
            end
    )
    toggleFG:SetPoint('CENTER', -190, -50)

    local sharedFG = addon:CreateSingleColorPicker(
            classFrame,
            'SHARED FG',
            function()      return addon.db.profile.colors.classes.solid.shared.fg end,
            function(value)
                addon.db.profile.colors.classes.solid.shared.fg = value
                addon:UpdateAllUnitFrame()
            end,
            function() return addon.db.profile.colors.classes.useSharedFG end,
            addon.defaults.profile.colors.classes.solid.shared.fg
    )
    sharedFG:SetPoint('CENTER', -50, -35)
    tinsert(colorPickers, sharedFG)

    local toggleBG = addon:CreateToggleButton(
            classFrame,
            170,
            'BACKGROUND COLOR',
            'CLASS',
            'SHARED',
            function()       return addon.db.profile.colors.classes.useSharedBG end,
            function(value)
                addon.db.profile.colors.classes.useSharedBG = value
                for _, v in pairs(colorPickers) do
                    v.Update()
                end
                addon:UpdateAllUnitFrame()
            end
    )
    toggleBG:SetPoint('CENTER', classFrame, 'CENTER', 90, -50)

    local sharedBG = addon:CreateSingleColorPicker(
            classFrame,
            'SHARED BG',
            function()      return addon.db.profile.colors.classes.solid.shared.bg end,
            function(value)
                addon.db.profile.colors.classes.solid.shared.bg = value
                addon:UpdateAllUnitFrame()
            end,
            function() return addon.db.profile.colors.classes.useSharedBG end,
            addon.defaults.profile.colors.classes.solid.shared.bg
    )
    sharedBG:SetPoint('CENTER', 230, -35)
    tinsert(colorPickers, sharedBG)

    local singleMage = addon:CreateSingleColorPicker(
            classFrame,
            'MAGE',
            function()      return addon.db.profile.colors.classes.solid.mage end,
            function(value)
                addon.db.profile.colors.classes.solid.mage = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.mage
    )
    singleMage:SetPoint('CENTER', -230, -100)
    tinsert(colorPickers, singleMage)

    local singlePriest = addon:CreateSingleColorPicker(
            classFrame,
            'PRIEST',
            function()      return addon.db.profile.colors.classes.solid.priest end,
            function(value)
                addon.db.profile.colors.classes.solid.priest = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.priest
    )
    singlePriest:SetPoint('CENTER', -154, -100)
    tinsert(colorPickers, singlePriest)

    local singleMonk = addon:CreateSingleColorPicker(
            classFrame,
            'MONK',
            function()      return addon.db.profile.colors.classes.solid.monk end,
            function(value)
                addon.db.profile.colors.classes.solid.monk = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.monk
    )
    singleMonk:SetPoint('CENTER', -77, -100)
    tinsert(colorPickers, singleMonk)

    local singleDeathKnight = addon:CreateSingleColorPicker(
            classFrame,
            'DK',
            function()      return addon.db.profile.colors.classes.solid.deathknight end,
            function(value)
                addon.db.profile.colors.classes.solid.deathknight = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.deathknight
    )
    singleDeathKnight:SetPoint('CENTER', 0, -100)
    tinsert(colorPickers, singleDeathKnight)

    local singleRogue = addon:CreateSingleColorPicker(
            classFrame,
            'ROGUE',
            function()      return addon.db.profile.colors.classes.solid.rogue end,
            function(value)
                addon.db.profile.colors.classes.solid.rogue = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.rogue
    )
    singleRogue:SetPoint('CENTER', 77, -100)
    tinsert(colorPickers, singleRogue)

    local singleDruid = addon:CreateSingleColorPicker(
            classFrame,
            'DRUID',
            function()      return addon.db.profile.colors.classes.solid.druid end,
            function(value)
                addon.db.profile.colors.classes.solid.druid = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.druid
    )
    singleDruid:SetPoint('CENTER', 154, -100)
    tinsert(colorPickers, singleDruid)

    local singleHunter = addon:CreateSingleColorPicker(
            classFrame,
            'HUNTER',
            function()      return addon.db.profile.colors.classes.solid.hunter end,
            function(value)
                addon.db.profile.colors.classes.solid.hunter = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.hunter
    )
    singleHunter:SetPoint('CENTER', 230, -100)
    tinsert(colorPickers, singleHunter)

    local singleDemonHunter = addon:CreateSingleColorPicker(
            classFrame,
            'DH',
            function()      return addon.db.profile.colors.classes.solid.demonhunter end,
            function(value)
                addon.db.profile.colors.classes.solid.demonhunter = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.demonhunter
    )
    singleDemonHunter:SetPoint('CENTER', -230, -165)
    tinsert(colorPickers, singleDemonHunter)

    local singleEvoker = addon:CreateSingleColorPicker(
            classFrame,
            'EVOKER',
            function()      return addon.db.profile.colors.classes.solid.evoker end,
            function(value)
                addon.db.profile.colors.classes.solid.evoker = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.evoker
    )
    singleEvoker:SetPoint('CENTER', -138, -165)
    tinsert(colorPickers, singleEvoker)

    local singleWarlock = addon:CreateSingleColorPicker(
            classFrame,
            'WARLOCK',
            function()      return addon.db.profile.colors.classes.solid.warlock end,
            function(value)
                addon.db.profile.colors.classes.solid.warlock = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.warlock
    )
    singleWarlock:SetPoint('CENTER', -46, -165)
    tinsert(colorPickers, singleWarlock)

    local singlePaladin = addon:CreateSingleColorPicker(
            classFrame,
            'PALADIN',
            function()      return addon.db.profile.colors.classes.solid.paladin end,
            function(value)
                addon.db.profile.colors.classes.solid.paladin = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.paladin
    )
    singlePaladin:SetPoint('CENTER', 46, -165)
    tinsert(colorPickers, singlePaladin)

    local singleWarrior = addon:CreateSingleColorPicker(
            classFrame,
            'WARRIOR',
            function()      return addon.db.profile.colors.classes.solid.warrior end,
            function(value)
                addon.db.profile.colors.classes.solid.warrior = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.warrior
    )
    singleWarrior:SetPoint('CENTER', 138, -165)
    tinsert(colorPickers, singleWarrior)

    local singleShaman = addon:CreateSingleColorPicker(
            classFrame,
            'SHAMAN',
            function()      return addon.db.profile.colors.classes.solid.shaman end,
            function(value)
                addon.db.profile.colors.classes.solid.shaman = value
                addon:UpdateAllUnitFrame()
            end,
            function() return not addon.db.profile.colors.classes.useSharedFG  end,
            addon.defaults.profile.colors.classes.solid.shaman
    )
    singleShaman:SetPoint('CENTER', 230, -165)
    tinsert(colorPickers, singleShaman)


end

function addon.CreateColorOptionsFrame(parent)
    local OptionsFrame = CreateFrame('Frame', 'ColorOptions', parent)
    OptionsFrame:SetFrameLevel(30)
    OptionsFrame:SetFrameStrata('DIALOG')
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

    local gradientEnabled = addon:CreateCheckBoxGradient(OptionsFrame, grad, colors, addon.db.profile.colors.gradient)
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