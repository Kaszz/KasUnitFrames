local _, addon = ...

local function OnMouseDown(self)
    self.text:SetPoint('CENTER', 0, -1)
end

local function OnMouseUp(self)
    self.text:SetPoint('CENTER')
end

local function OnEnter(self)
    self.content:SetColorTexture(54/255, 57/255, 63/255, 1)
    self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
end

local function OnLeave(self)
    self.content:SetColorTexture(41/255, 43/255, 47/255, 1)
    self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
end

function addon:CreateButton(parent, text, width, click)
    local Button = CreateFrame('Button', nil, parent)
    Button:SetSize(width, 21)

    Button.border = Button:CreateTexture(nil, 'ARTWORK', nil, 1)
    Button.border:SetSize(width, 21)
    Button.border:SetAllPoints(Button)
    Button.border:SetColorTexture(0, 0, 0, 1)

    Button.content = Button:CreateTexture(nil, 'ARTWORK', nil, 2)
    Button.content:SetSize(width - 2, 19)
    Button.content:SetPoint('CENTER')
    Button.content:SetColorTexture(41/255, 43/255, 47/255, 1)

    Button.text = Button:CreateFontString(nil, 'OVERLAY', 'KufButtonText')
    Button.text:SetPoint('CENTER')
    Button.text:SetText(text)
    Button.text:SetTextColor(255/255, 255/255, 255/255, 200/255)

    Button:SetScript('OnMouseDown', OnMouseDown)
    Button:SetScript('OnMouseUp', OnMouseUp)
    Button:SetScript('OnEnter', OnEnter)
    Button:SetScript('OnLeave', OnLeave)
    Button:SetScript('OnClick', function() click() end)

    return Button
end