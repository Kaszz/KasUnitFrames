local _, addon = ...
local timeElapsed = 0
local width = 0
local rows = {}
local scrollChild
local columnCount = 3

local function RenderOptions(width)
    if width == nil then
        return
    end

    local rowWidth = 20
    local renderedRows = {}
    local i = 1
    local j = 1
    while scrollChild.first[i] do
        if rowWidth + scrollChild.first[i]:GetWidth() + 10 <= width then
            if renderedRows[j] == nil then
                renderedRows[j] = {}
            end
            tinsert(renderedRows[j], scrollChild.first[i])
            rowWidth = rowWidth + scrollChild.first[i]:GetWidth() + 10
        else
            j = j + 1
            if renderedRows[j] == nil then
                renderedRows[j] = {}
            end
            tinsert(renderedRows[j], scrollChild.first[i])
            rowWidth = 20 + scrollChild.first[i]:GetWidth()
        end

        i = i + 1
    end

    --print('count: ' .. #renderedRows)
    --local pos = 1
    --local row = 1

    print('---')
    for row, rowValue in pairs(renderedRows) do
        rowWidth = 10
        for item, itemValue in pairs(renderedRows[row]) do
            print(row .. ': ' .. item)

            renderedRows[row][item]:SetPoint('TOPLEFT', rowWidth, -50 + ((row - 1) * -50))
            rowWidth = rowWidth + 20 + renderedRows[row][item]:GetWidth()

            --scrollChild.first[i]:SetPoint('TOPLEFT', 50 + ((pos - 1) * 200), -50 + ((row - 1) * -50))
        end
    end


end

local function RefreshOnUpdate(self, elapsed)
    timeElapsed = timeElapsed + elapsed
    if timeElapsed > 0.05 then

        if width ~= self:GetParent():GetWidth()-18 then
            width = self:GetParent():GetWidth()-18

            if width < 800 then
                columnCount = 3
            else
                columnCount = 4
            end

            RenderOptions(width)
        end
        timeElapsed = 0
    end
end

local function CreateFirstRow(parent)
    local button1 = addon:CreateButton(
        parent,
        'button1',
        150,
        function()
            print('button1')
        end
    )

    local button2 = addon:CreateButton(
        parent,
        'button2',
        150,
        function()
            print('button2')
        end
    )

    local button3 = addon:CreateButton(
        parent,
        'button3',
        150,
        function()
            print('button3')
        end
    )

    local button4 = addon:CreateButton(
        parent,
        'button4',
        150,
        function()
            print('button4')
        end
    )

    local button5 = addon:CreateButton(
        parent,
        'button5',
        150,
        function()
            print('button5')
        end
    )

    rows.first = {
        button1,
        button2,
        button3,
        button4,
        button5
    }
end

function addon.CreateTargetOptionsFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 14)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(parent:GetWidth()-18)
    scrollChild:SetHeight(1)

    -- Add widgets to the scrolling child frame as desired
    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("MyAddOn")

    local footer = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal")
    footer:SetPoint("TOP", 0, -5000)
    footer:SetText("This is 5000 below the top, so the scrollChild automatically expanded.")


    CreateFirstRow(scrollChild)
    scrollChild:SetScript('OnUpdate', RefreshOnUpdate)


    scrollChild.first = rows.first
    RenderOptions()

    return scrollFrame
end