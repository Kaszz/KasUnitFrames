local _, addon = ...

function addon.CreateCheckBox(parent, label, width)
    local checkbox = CreateFrame('CheckButton', nil, parent, "BackdropTemplate")
    checkbox:SetSize(width or 200, 20)
    checkbox:SetNormalFontObject(InterUIRegular_Normal2)
    checkbox:SetText(label)
    checkbox:SetPushedTextOffset(1, -1)

    local tex = checkbox:CreateTexture('PUSHED_TEXTURE_BOX', 'BACKGROUND')
    tex:SetSize(14, 14)
    tex:SetPoint('LEFT', checkbox, 'LEFT', -2, 0)
    tex:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\box2.tga')
    tex:SetVertexColor(0.3, 0.3, 0.3)

    checkbox.t = checkbox:CreateTexture('PUSHEDTEXTURE', 'BACKGROUND')
    checkbox.t:SetSize(14, 14)
    checkbox.t:SetPoint('CENTER', tex, 'CENTER')
    checkbox.t:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\baseline-done-small@2x.tga')
    checkbox:SetCheckedTexture(checkbox.t)

    if label then
        checkbox:GetFontString():SetPoint('LEFT', tex, 'RIGHT', 5, 0)
    end

    return checkbox
end

function addon.CreateButton(parent, text, width)
    local button = CreateFrame('Button', nil, parent)
    button:SetSize(width, 21)

    button.border = button:CreateTexture(nil, 'ARTWORK', nil, 1)
    button.border:SetSize(width, 21)
    button.border:SetAllPoints(button)
    button.border:SetColorTexture(0, 0, 0, 1)

    button.content = button:CreateTexture(nil, 'ARTWORK', nil, 2)
    button.content:SetSize(width - 2, 19)
    button.content:SetPoint('CENTER')
    button.content:SetColorTexture(41/255, 43/255, 47/255, 1)

    button.text = button:CreateFontString(nil, 'OVERLAY', 'InterUIRegular_Normal2')
    button.text:SetPoint('CENTER')
    button.text:SetText(text)
    button.text:SetTextColor(255/255, 255/255, 255/255, 200/255)

    button:SetScript('OnEnter', function(self)
        self.content:SetColorTexture(54/255, 57/255, 63/255, 1)
        self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
    end)
    button:SetScript('OnLeave', function(self)
        self.content:SetColorTexture(41/255, 43/255, 47/255, 1)
        self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
    end)
    button:SetScript('OnMouseDown', function(self)
        self.text:SetPoint('CENTER', 0, -1)
    end)
    button:SetScript('OnMouseUp', function(self)
        self.text:SetPoint('CENTER')
    end)

    return button
end

function addon.CreateSubHeader(parent, text, width)
    local SubHeader = CreateFrame('Frame', nil, parent)
    SubHeader:SetSize(570, 24)

    SubHeader.stroke = SubHeader:CreateTexture(nil, 'ARTWORK', nil, 1)
    SubHeader.stroke:SetSize(570, 1)
    SubHeader.stroke:SetColorTexture(1, 1, 1, 1)
    SubHeader.stroke:SetPoint('CENTER')

    SubHeader.backdrop = SubHeader:CreateTexture(nil, 'ARTWORK', nil, 2)
    SubHeader.backdrop:SetSize(width, 24)
    SubHeader.backdrop:SetPoint('LEFT')
    SubHeader.backdrop:SetColorTexture(47/255, 49/255, 54/255, 255/255)

    SubHeader.text = SubHeader:CreateFontString(nil, 'OVERLAY', 'InterUIRegular_Header')
    SubHeader.text:SetPoint('LEFT', 0, -1)
    SubHeader.text:SetText(text)
    SubHeader.text:SetTextColor(255/255, 255/255, 255/255, 255/255)

    return SubHeader
end

function addon.CreateSlider(parent)
    local Slider = CreateFrame('Slider', nil, parent, 'OptionsSliderTemplate')
    Slider:SetWidth(140)
    Slider:SetHeight(20)
    Slider:SetOrientation('HORIZONTAL')
    Slider:SetMinMaxValues(20, 1000)
    Slider.Low:SetText(tostring(20))
    Slider.High:SetText(tostring(1000))
    Slider.Text:SetText('yep slider')

    Slider.border = Slider:CreateTexture(nil, 'ARTWORK', nil, 1)
    Slider.border:SetSize(140, 12)
    Slider.border:SetPoint('CENTER')
    Slider.border:SetColorTexture(255/255, 255/255, 255/255, 255/255)

    Slider.background = Slider:CreateTexture(nil, 'ARTWORK', nil, 2)
    Slider.background:SetSize(138, 10)
    Slider.background:SetPoint('CENTER')
    Slider.background:SetColorTexture(41/255, 43/255, 47/255, 1)

    Slider.customThumb = Slider:CreateTexture(nil, 'ARTWORK', nil, 3)
    Slider.customThumb:SetSize(3, 10)
    Slider.customThumb:SetTexture('Interface\\Buttons\\WHITE8X8')

    Slider:SetThumbTexture(Slider.customThumb)

    Slider:SetScript("OnValueChanged", function(self)
        for k, v in pairs(self) do
            print(k)
        end
    end)

    return Slider
end