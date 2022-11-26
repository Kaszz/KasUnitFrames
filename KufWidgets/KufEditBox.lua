local _, addon = ...

function addon:CreateEditBox(parent, width, label, maxLetters, enabled, validator, update)
    local frame = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
    frame:SetSize(width, 22)
    frame:SetFontObject(KufOptionTitleValue)
    frame:SetTextColor(190/255, 190/255, 190/255, 255/255)
    frame:SetAutoFocus(false)
    frame:EnableMouse(true)
    frame:SetTextInsets(5, 5, 0, 0)
    frame:SetMaxLetters(maxLetters)
    frame.isEnabled = enabled
    frame.type = 'editbox'

    frame:SetBackdrop({
        bgFile = 'Interface/ChatFrame/ChatFrameBackground',
        edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
        tile = true, edgeSize = 1, tileSize = 5,
    })
    frame:SetBackdropColor(41/255, 43/255, 47/255, 1)
    frame:SetBackdropBorderColor(0, 0, 0, 1)

    frame.label = frame:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    frame.label:SetPoint('TOP', 0, 14)
    frame.label:SetText(label)
    frame.label:SetTextColor(255/255, 255/255, 255/255, 255/255)

    frame.UpdateWidth = function(newWidth)
        frame:SetWidth(newWidth - 10)
    end

    frame:SetScript('OnEnterPressed', function()
        if (validator(frame:GetText())) then
            update(frame:GetText())
            frame:SetText('')
        end
    end)

    frame:SetScript('OnEscapePressed', function(self)
        self:ClearFocus()
    end)

    return frame
end