local _, addon = ...
local DeleteText = function()  end

local function CreateOptionsElements(unit, parent)
    local textEnable = addon:CreateCheckBox(
            parent,
            'ENABLE',
            false,
            function() return addon.db.profile[unit].enabled end,
            function() return true end,
            function(value) end,
            function() end
    )
    tinsert(parent.elements, textEnable)

    local text = addon:CreateEditBox(
            parent,
            150,
            'TEXT',
            22,
            function() return addon.db.profile[unit].enabled end,
            function() return true end,
            function()
                -- save to db
                -- update the fontstring on frame
            end
    )
    tinsert(parent.elements, text)

    local deleteButton = addon:CreateButton(
            parent,
            'DELETE',
            150,
            function() DeleteText(unit, parent:GetParent().tabs) end
    )
    tinsert(parent.elements, deleteButton)
end

local function UpdateTabs(tabs)
    for k, v in pairs(tabs.elements) do
        if (k == tabs.selected) then
            v:SetBackdropColor(66/255, 70/255, 77/255, 1)
            v.text:SetTextColor(1, 1, 1, 1)
        else
            v:SetBackdropColor(41/255, 43/255, 47/255, 1)
            v.text:SetTextColor(190/255, 190/255, 190/255, 1)
        end
    end
end

local function RenderTabs(unit, tabs)
    local i = 0

    -- remove frames
    for _, v in pairs(tabs.elements) do
        v:Hide()
    end
    tabs.elements = {}
    tabs:SetHeight(2)

    -- add new frames
    for k, _ in pairs(addon.db.profile[unit].texts) do
        tabs.elements[k] = CreateFrame('Button', nil, tabs, 'BackdropTemplate')
        tabs.elements[k]:SetSize(148, 22)
        tabs.elements[k]:SetBackdrop({
            bgFile="Interface\\Buttons\\WHITE8x8",
            edgeFile="Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        tabs.elements[k]:SetBackdropColor(41/255, 43/255, 47/255, 1)
        tabs.elements[k]:SetBackdropBorderColor(0, 0, 0, 0)
        tabs.elements[k]:EnableMouse(true)
        tabs.elements[k]:SetPoint('TOP', 0, (i * -22) - 1)
        tabs.elements[k]:Show()
        tabs:SetHeight(tabs:GetHeight() + 22)
        tabs:GetParent():SetHeight(tabs:GetHeight() + 20)

        tabs.elements[k].text = tabs.elements[k]:CreateFontString(nil, 'OVERLAY', 'KufButtonText')
        tabs.elements[k].text:SetPoint('LEFT', 5, 0)
        tabs.elements[k].text:SetText(k)
        tabs.elements[k].text:SetJustifyH('LEFT')
        tabs.elements[k].text:SetTextColor(190/255, 190/255, 190/255, 1)

        tabs.elements[k]:SetScript('OnEnter', function(self)
            if tabs.selected ~= self.text:GetText() then
                self:SetBackdropColor(60/255, 63/255, 69/255, 1)
                self.text:SetTextColor(1, 1, 1, 1)
            end
        end)

        tabs.elements[k]:SetScript('OnLeave', function(self)
            if tabs.selected ~= self.text:GetText() then
                self:SetBackdropColor(41/255, 43/255, 47/255, 1)
                self.text:SetTextColor(190/255, 190/255, 190/255, 1)
            end
        end)

        tabs.elements[k]:SetScript('OnClick', function(self)
            tabs.selected = self.text:GetText()
            UpdateTabs(tabs)
        end)

        i = i + 1
    end

    if (next(addon.db.profile[unit].texts) ~= nil) then
        local first, _ = next(addon.db.profile[unit].texts)
        tabs.selected = first
        UpdateTabs(tabs)
    end
end

local function IsTextNameAvailable(text, unit)
    if (addon.db.profile[unit].texts[text] == nil) then
        return true
    end
    return false
end

local function AddCustomText(text, unit, tabs)
    addon.db.profile[unit].texts[text] = {
        value = '',
        fontSize = 12
    }

    RenderTabs(unit, tabs)
end

DeleteText = function(unit, tabs)
    addon.db.profile[unit].texts[tabs.selected] = nil
    RenderTabs(unit, tabs)
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

    parent:SetHeight(j * 38)
end

function addon:CreateCustomTextElement(parent, enabled, unit)
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetSize(150, 250)
    frame.type = 'customtext'
    frame.isEnabled = enabled

    frame.editbox = addon:CreateEditBox(
            frame,
            150,
            'CREATE CUSTOM TEXT',
            22,
            enabled(),
            function(text) return IsTextNameAvailable(text, unit) end,
            function(text) AddCustomText(text, unit, frame.tabs) end
    )
    frame.editbox:SetPoint('TOPLEFT')


    frame.tabs = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.tabs:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1
    })
    frame.tabs:SetBackdropColor(41/255, 43/255, 47/255, 1)
    frame.tabs:SetBackdropBorderColor(0, 0, 0, 1)
    frame.tabs:SetSize(150, 6)
    frame.tabs:SetPoint('TOPLEFT', 0, -24)
    frame.tabs.elements = {}
    RenderTabs(unit, frame.tabs)
    UpdateTabs(frame.tabs)

    frame.options = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.options:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1
    })
    frame.options:SetBackdropColor(1, 43/255, 47/255, 0)
    frame.options:SetBackdropBorderColor(0, 0, 0, 0)
    frame.options:SetSize(100, 100)
    frame.options:SetPoint('TOPLEFT', 160, 0)
    frame.options.elements = {}
    CreateOptionsElements(unit, frame.options)


    frame.UpdateWidth = function(newWidth)
        frame:SetWidth(newWidth -10)
        frame.options:SetWidth(newWidth - 170)
        RenderOptions(frame.options:GetWidth(), frame.options)
        frame:SetHeight((max(unpack({frame.tabs:GetHeight() + 22, frame.options:GetHeight() - 8}))))
    end

    return frame
end