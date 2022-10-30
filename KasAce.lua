local _, addon = ...
local AceGUI = LibStub("AceGUI-3.0")

function addon.CreateRealAceButton(text, width)
    local button = AceGUI:Create("Button")
    button:SetText(text)
    button:SetWidth(width)

    local newButton = CreateFrame("Button", nil, button.parent, "BackdropTemplate")

    for k, v in pairs(button.frame) do
         newButton[k] = v
    end

    newButton:SetBackdropColor(1, 0, 0)
    newButton:SetBackdrop({
        bgFile = 'Interface/ChatFrame/ChatFrameBackground',
        edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
        --edgeSize = 2
    })
    newButton:ClearBackdrop()
    newButton:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8",
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 5,
    })
    newButton:ApplyBackdrop()
    newButton:SetBackdropColor(255/255, 43/255, 47/255, 1)
    newButton:SetBackdropBorderColor(0, 0, 1, 1)

    local normalTexture = newButton:CreateTexture(nil, 'ARTWORK')
    normalTexture:SetSize(newButton.width - 2, newButton.height - 2)
    normalTexture:SetPoint('CENTER')
    normalTexture:SetColorTexture(1, 0, 0)

    local pushedTexture = newButton:CreateTexture(nil, 'ARTWORK')
    pushedTexture:SetSize(newButton.width - 2, newButton.height - 2)
    pushedTexture:SetPoint('CENTER')
    pushedTexture:SetColorTexture(0, 1, 0)

    newButton:SetNormalTexture(normalTexture)
    newButton:SetPushedTexture(pushedTexture)

    button.frame = newButton

    return button
end