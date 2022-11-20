local _, addon = ...

function addon:CreateSectionHeader(parent, text, width, enabled)
    local SubHeader = CreateFrame('Frame', nil, parent)
    SubHeader:SetSize(width, 20)
    SubHeader.type = 'header'
    SubHeader.isEnabled = enabled

    SubHeader.text = SubHeader:CreateFontString(nil, 'OVERLAY', 'KufHeaderText')
    SubHeader.text:SetPoint('LEFT', 0, -1)
    SubHeader.text:SetText(text)
    SubHeader.text:SetTextColor(1, 1, 1, 1)

    SubHeader.stroke = SubHeader:CreateTexture(nil, 'ARTWORK', nil, 1)
    SubHeader.stroke:SetSize(width - SubHeader.text:GetStringWidth() + 5, 2)
    SubHeader.stroke:SetPoint('LEFT', SubHeader.text, 'RIGHT', 5, 0)
    SubHeader.stroke:SetColorTexture(1, 1, 1, 0.05)

    SubHeader.UpdateWidth = function(newWidth)
        SubHeader:SetWidth(newWidth)
        SubHeader.stroke:SetWidth(newWidth - SubHeader.text:GetStringWidth() + 5)
    end

    return SubHeader
end