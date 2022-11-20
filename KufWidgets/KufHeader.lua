local _, addon = ...

function addon:CreateHeader(parent, text)
    local SubHeader = CreateFrame('Frame', nil, parent)
    SubHeader:SetSize(570, 24)

    SubHeader.text = SubHeader:CreateFontString(nil, 'OVERLAY', 'KufHeaderText')
    SubHeader.text:SetPoint('LEFT', 0, -1)
    SubHeader.text:SetText(text)
    SubHeader.text:SetTextColor(255/255, 255/255, 255/255, 255/255)

    SubHeader.stroke = SubHeader:CreateTexture(nil, 'ARTWORK', nil, 1)
    SubHeader.stroke:SetSize(570 - SubHeader.text:GetStringWidth() + 5, 1)
    SubHeader.stroke:SetColorTexture(1, 1, 1, 1)
    SubHeader.stroke:SetPoint('LEFT', SubHeader.text, 'RIGHT', 5, 0)

    return SubHeader
end