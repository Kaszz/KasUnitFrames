local _, addon = ...

local function selectButton(button)
    button:SetBackdropColor(254/255, 231/255, 92/255)
    button.text:SetTextColor(47/255, 49/255, 54/255)
end

local function deselectButton(button)
    button:SetBackdropColor(47/255, 49/255, 54/255)
    button.text:SetTextColor(170/255, 170/255, 170/255)
end

local function UpdateButtons(toggle, get)
    if (get()) then
        selectButton(toggle.rightButton)
        deselectButton(toggle.leftButton)
    else
        selectButton(toggle.leftButton)
        deselectButton(toggle.rightButton)
    end
end

local function buttonClicked(toggle, get, set)
    set(not get())
    UpdateButtons(toggle, get)
end

function addon:CreateToggleButton(parent, width, label, leftText, rightText, get, set)
    local toggle = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    toggle:SetSize(width, 22)
    toggle:SetBackdrop({
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    toggle:SetBackdropBorderColor(170/255, 170/255, 170/255)

    toggle.label =  toggle:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    toggle.label:SetPoint("CENTER", 0, 24)
    toggle.label:SetText(label)

    local leftButton = CreateFrame("Button", nil, parent, "BackdropTemplate")
    leftButton:SetSize(width / 2, 22)
    leftButton:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8",
    })
    leftButton:SetBackdropColor(1, 0, 0)
    leftButton:SetPoint('RIGHT', toggle, 'CENTER')

    leftButton.text = leftButton:CreateFontString(nil, 'OVERLAY', 'KufButtonText')
    leftButton.text:SetPoint("CENTER")
    leftButton.text:SetText(leftText)
    toggle.leftButton = leftButton

    local rightButton = CreateFrame("Button", nil, parent, "BackdropTemplate")
    rightButton:SetSize(width / 2, 22)
    rightButton:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8",
    })
    rightButton:SetBackdropColor(0, 1, 0)
    rightButton:SetPoint('LEFT', toggle, 'CENTER')

    rightButton.text = rightButton:CreateFontString(nil, 'OVERLAY', 'KufButtonText')
    rightButton.text:SetPoint("CENTER")
    rightButton.text:SetText(rightText)
    toggle.rightButton = rightButton

    UpdateButtons(toggle, get)

    leftButton:SetScript('OnClick', function()
        if (get()) then
            buttonClicked(toggle, get, set)
        end
    end)

    rightButton:SetScript('OnClick', function()
        if (not get()) then
            buttonClicked(toggle, get, set)
        end
    end)

    return toggle
end