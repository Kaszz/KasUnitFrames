local _, addon = ...
local timeElapsed = 0

local function ToggleOptions(unit, parent)
    for _, v in pairs(parent.elements) do
        if (v.type == 'header') then
            if (v.isEnabled()) then
                v:SetAlpha(1)
            else
                v:SetAlpha(0.3)
            end
        end

        if (v.type == 'slider') then
            if (v.isEnabled()) then
                v:SetAlpha(1)
            else
                v:SetAlpha(0.3)
            end
            v.enabled = v.isEnabled()
        end

        if (v.type == 'checkbox') then
            if (v.isEnabled()) then
                v:SetAlpha(1)
            else
                v:SetAlpha(0.3)
            end
        end

        if (v.type == 'customtext') then
            if (v.isEnabled()) then
                v:SetAlpha(1)
            else
                v:SetAlpha(0.3)
            end
        end
    end

    addon:UpdateUnitFrame(unit)
end

local function RenderOptions(width, parent)
    if width == nil then
        return
    end

    local rowWidth = 20
    local renderedRows = {}
    local i = 1
    local j = 1
    while parent.elements[i] do
        if rowWidth + parent.elements[i]:GetWidth() + 10 <= width - 11 then
            if renderedRows[j] == nil then
                renderedRows[j] = {}
            end
            tinsert(renderedRows[j], parent.elements[i])
            rowWidth = rowWidth + parent.elements[i]:GetWidth() + 10
        else
            j = j + 1
            if renderedRows[j] == nil then
                renderedRows[j] = {}
            end
            tinsert(renderedRows[j], parent.elements[i])
            rowWidth = 20 + parent.elements[i]:GetWidth()
        end

        i = i + 1
    end

    for row, _ in pairs(renderedRows) do
        rowWidth = 20
        for item, _ in pairs(renderedRows[row]) do
            renderedRows[row][item]:SetPoint('TOPLEFT', parent, rowWidth, ((row - 1) * -40))
            rowWidth = rowWidth + 20 + renderedRows[row][item]:GetWidth()
        end
    end
end

local function RefreshOnUpdate(self, elapsed)
    timeElapsed = timeElapsed + elapsed
    if timeElapsed > 0.01 then

        local width = self:GetParent():GetWidth() -18

        for _, v in pairs(self.elements) do
            if (v.type == 'header' or v.type == 'customtext') then
                v.UpdateWidth(width)
            end
        end

        RenderOptions(width, self)

        timeElapsed = 0
    end
end

local function CreateEnable(unit, parent)
    local enable = addon:CreateCheckBox(
        parent,
        'ENABLE',
        true,
        function() return true end,
        function() return addon.db.profile[unit].enabled end,
        function(value) addon.db.profile[unit].enabled = value end,
        function()
            ToggleOptions(unit, parent)
        end
    )
    tinsert(parent.elements, enable)
end

local function CreateSizeAndPositioning(unit, parent)
    local sizeAndPosHeader = addon:CreateSectionHeader(
            parent,
        'SIZE & POSITIONING',
            parent:GetParent():GetWidth(),
        function() return addon.db.profile[unit].enabled end
    )
    tinsert(parent.elements, sizeAndPosHeader)

    local widthSlider = addon:CreateSlider(
        parent,
        'WIDTH',
        5,
        1000,
        function()      return addon.db.profile[unit].size.width end,
        function(value) addon.db.profile[unit].size.width = value end,
        function()      addon:UpdateUnitFrame(unit) end,
        function()      return addon.db.profile[unit].enabled end
    )
    widthSlider:SetPoint('TOPLEFT', parent, 0, 0)
    tinsert(parent.elements, widthSlider)

    local heightSlider = addon:CreateSlider(
        parent,
        'HEIGHT',
        5,
        1000,
        function()      return addon.db.profile[unit].size.height end,
        function(value) addon.db.profile[unit].size.height = value end,
        function()      addon:UpdateUnitFrame(unit) end,
        function()      return addon.db.profile[unit].enabled end
    )
    heightSlider:SetPoint('TOPLEFT', parent, 0, 0)
    tinsert(parent.elements, heightSlider)

    local xSlider = addon:CreateSlider(
        parent,
        'X',
        (math.floor(GetScreenWidth()/2 * -1)),
        math.floor(GetScreenWidth()/2),
        function()      return addon.db.profile[unit].size.x end,
        function(value) addon.db.profile[unit].size.x = value end,
        function()      addon:UpdateUnitFrame(unit) end,
        function()      return addon.db.profile[unit].enabled end
    )
    xSlider:SetPoint('TOPLEFT', parent, 0, 0)
    tinsert(parent.elements, xSlider)

    local ySlider = addon:CreateSlider(
        parent,
        'Y',
        (math.floor(GetScreenHeight()/2 * -1)),
        math.floor(GetScreenHeight()/2),
        function()      return addon.db.profile[unit].size.y end,
        function(value) addon.db.profile[unit].size.y = value end,
        function()      addon:UpdateUnitFrame(unit) end,
        function()      return addon.db.profile[unit].enabled end
    )
    ySlider:SetPoint('TOPLEFT', parent, 0, 0)
    tinsert(parent.elements, ySlider)
end

local function CreatePower(unit, parent)
    local powerHeader = addon:CreateSectionHeader(
        parent,
        'POWER',
        parent:GetParent():GetWidth(),
        function() return addon.db.profile[unit].enabled end
    )
    tinsert(parent.elements, powerHeader)

    local powerEnable = addon:CreateCheckBox(
            parent,
            'ENABLE',
            false,
            function() return addon.db.profile[unit].enabled end,
            function() return addon.db.profile[unit].power.enabled end,
            function(value) addon.db.profile[unit].power.enabled = value end,
            function()
                ToggleOptions(unit, parent)
            end
    )
    tinsert(parent.elements, powerEnable)

    local powerSlider = addon:CreateSlider(
        parent,
        'HEIGHT',
        0,
        addon.db.profile[unit].size.height,
        function()      return addon.db.profile[unit].power.height end,
        function(value) addon.db.profile[unit].power.height = value end,
        function()      addon:UpdateUnitFrame(unit) end,
        function()
            if (addon.db.profile[unit].enabled and addon.db.profile[unit].power.enabled) then
                return true
            else
                return false
            end
        end
    )
    powerSlider:SetPoint('TOPLEFT', parent, 0, 0)
    tinsert(parent.elements, powerSlider)
end

local function CreateTexts(unit, parent)
    local textsHeader = addon:CreateSectionHeader(
            parent,
            'TEXTS',
            parent:GetParent():GetWidth(),
            function() return addon.db.profile[unit].enabled end
    )
    tinsert(parent.elements, textsHeader)

    local customTextElement = addon:CreateCustomTextElement(
            parent,
            function() return addon.db.profile[unit].enabled end,
            unit
    )
    tinsert(parent.elements, customTextElement)

    --local textEnable = addon:CreateCheckBox(
    --        parent,
    --        'ENABLE',
    --        false,
    --        function() return addon.db.profile[unit].enabled end,
    --        function() return true end,
    --        function(value) end,
    --        function()
    --            ToggleOptions(unit, parent)
    --        end
    --)
    --tinsert(parent.elements, textEnable)
    --
    --local text = addon:CreateEditBox(
    --        parent,
    --        150,
    --        'TEXT',
    --        22,
    --        function() return addon.db.profile[unit].enabled end,
    --        function() return true end,
    --        function()
    --            -- save to db
    --            -- update the fontstring on frame
    --        end
    --)
    --tinsert(parent.elements, text)
    --
    --local deleteButton = addon:CreateButton(
    --        parent,
    --        'DELETE',
    --        150,
    --        function()
    --            print(customTextElement.tabs.selected)
    --            customTextElement.delete(unit, customTextElement.tabs)
    --        end
    --)
    --tinsert(parent.elements, deleteButton)
end

local function CreateScrollFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 0, -23)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 0)

    scrollFrame.ScrollBarBackground = scrollFrame:CreateTexture(nil, 'ARTWORK', nil, 1)
    scrollFrame.ScrollBarBackground:SetPoint("TOPLEFT", parent, "TOPRIGHT", -21, -1)
    scrollFrame.ScrollBarBackground:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -1, 1)
    scrollFrame.ScrollBarBackground:SetColorTexture(41/255, 43/255, 47/255, 1)

    scrollFrame.DividerLeft = scrollFrame:CreateTexture(nil, 'ARTWORK', nil, 2)
    scrollFrame.DividerLeft:SetPoint("TOPLEFT", parent, "TOPRIGHT", -22, -1)
    scrollFrame.DividerLeft:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -21, 1)
    scrollFrame.DividerLeft:SetColorTexture(0, 0, 0, 1)

    scrollFrame.DividerTop = scrollFrame:CreateTexture(nil, 'ARTWORK', nil, 3)
    scrollFrame.DividerTop:SetSize(21, 1)
    scrollFrame.DividerTop:SetPoint("TOPRIGHT", scrollFrame.ScrollBar, "TOPRIGHT", 3, 18)
    scrollFrame.DividerTop:SetColorTexture(0, 0, 0, 1)

    scrollFrame.ScrollBar.ThumbTexture:SetTexture('Interface\\Buttons\\WHITE8x8')
    scrollFrame.ScrollBar.ThumbTexture:SetColorTexture(1, 1, 1, 0.7)
    scrollFrame.ScrollBar.ThumbTexture:SetSize(12, 22)

    scrollFrame.ScrollBar.ScrollUpButton:SetNormalTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_up.tga')
    scrollFrame.ScrollBar.ScrollUpButton:SetDisabledTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_up.tga')
    scrollFrame.ScrollBar.ScrollUpButton:SetPushedTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_up.tga')
    scrollFrame.ScrollBar.ScrollUpButton:SetHighlightTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_up.tga')

    scrollFrame.ScrollBar.ScrollDownButton:SetNormalTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_down.tga')
    scrollFrame.ScrollBar.ScrollDownButton:SetDisabledTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_down.tga')
    scrollFrame.ScrollBar.ScrollDownButton:SetPushedTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_down.tga')
    scrollFrame.ScrollBar.ScrollDownButton:SetHighlightTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\caret_down.tga')

    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(parent:GetWidth()-18)
    scrollChild:SetHeight(1)

    scrollChild.elements = {}
    scrollChild:SetScript('OnUpdate', RefreshOnUpdate)

    return scrollFrame
end

function addon.CreateIndividualUnitOptionsFrame(parent, unit)
    local frame = CreateScrollFrame(parent)

    CreateEnable(unit, frame:GetScrollChild())
    CreateSizeAndPositioning(unit, frame:GetScrollChild())
    CreatePower(unit, frame:GetScrollChild())
    CreateTexts(unit, frame:GetScrollChild())

    ToggleOptions(unit, frame:GetScrollChild())

    return frame
end

