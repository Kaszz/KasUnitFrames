local _, addon = ...

function addon.CreateCheckBox(parent, label, enabled)
    local CheckBox = CreateFrame('CheckButton', nil, parent, "BackdropTemplate")
    CheckBox:SetSize(20, 20)
    CheckBox:SetNormalFontObject(KufCheckboxText)
    CheckBox:SetPushedTextOffset(1, -1)
    CheckBox:SetChecked(enabled)

    CheckBox.box = CheckBox:CreateTexture('PUSHED_TEXTURE_BOX', 'BACKGROUND')
    CheckBox.box:SetSize(14, 14)
    CheckBox.box:SetPoint('LEFT', CheckBox, 'LEFT', -2, 0)
    CheckBox.box:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\box2.tga')
    CheckBox.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)

    CheckBox.check = CheckBox:CreateTexture('PUSHEDTEXTURE', 'BACKGROUND')
    CheckBox.check:SetSize(14, 14)
    CheckBox.check:SetPoint('CENTER', CheckBox, -5, 0)
    CheckBox.check:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\baseline-done-small@2x.tga')
    CheckBox.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
    CheckBox:SetCheckedTexture(CheckBox.check)

    CheckBox.text = CheckBox:CreateFontString(CheckBox, 'OVERLAY', 'KufOptionTitleText')
    CheckBox.text:SetText(label)
    CheckBox.text:SetTextColor(1, 1, 1, 1)
    CheckBox.text:SetPoint('LEFT', CheckBox.box, 'RIGHT', 5, 0)

    CheckBox:SetScript('OnEnter', function(self)
        if CheckBox:GetChecked() then
            self.box:SetVertexColor(1, 1, 1, 1)
            self.check:SetVertexColor(1, 1, 1, 1)
        end
    end)

    CheckBox:SetScript('OnLeave', function(self)
        self.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)
        self.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
    end)

    return CheckBox
end

function addon.CreateButton(parent, text, width)
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

    Button:SetScript('OnEnter', function(self)
        self.content:SetColorTexture(54/255, 57/255, 63/255, 1)
        self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
    end)
    Button:SetScript('OnLeave', function(self)
        self.content:SetColorTexture(41/255, 43/255, 47/255, 1)
        self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
    end)
    Button:SetScript('OnMouseDown', function(self)
        self.text:SetPoint('CENTER', 0, -1)
    end)
    Button:SetScript('OnMouseUp', function(self)
        self.text:SetPoint('CENTER')
    end)

    return Button
end

function addon.CreateSubHeader(parent, text)
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

function addon.CreateBoxSlider(parent, text, unit, section, param, lower, upper)
    local isDragging = false
    local BoxSlider = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
    BoxSlider.enabled = addon.db.profile[unit].enabled
    BoxSlider:SetSize(50,16)
    BoxSlider:SetAutoFocus(false)
    BoxSlider:SetNumber(addon.db.profile[unit][section][param])
    BoxSlider:SetFontObject(KufOptionTitleValue)
    BoxSlider:SetTextColor(190/255, 190/255, 190/255, 255/255)
    BoxSlider:SetJustifyH('CENTER')
    BoxSlider:Disable()
    BoxSlider.lower = lower
    BoxSlider.upper = upper

    BoxSlider:SetBackdrop({
        bgFile = 'Interface/ChatFrame/ChatFrameBackground',
        edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
        tile = true, edgeSize = 1, tileSize = 5,
    })
    BoxSlider:SetBackdropColor(41/255, 43/255, 47/255, 0)
    BoxSlider:SetBackdropBorderColor(255/255, 255/255, 255/255, 0)

    BoxSlider.header = BoxSlider:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    BoxSlider.header:SetPoint('TOPLEFT', 0, 12)
    BoxSlider.header:SetText(text)
    BoxSlider.header:SetTextColor(255/255, 255/255, 255/255, 255/255)

    BoxSlider:SetScript("OnMouseDown", function(_, button)
        if BoxSlider.enabled then
            if button == 'LeftButton' then
                local _, y = GetCursorPosition()
                local timeElapsed = 0
                isDragging = true
                BoxSlider:SetTextColor(1, 1, 1, 1)

                BoxSlider:SetScript('OnUpdate', function(_, elapsed)
                    timeElapsed = timeElapsed + elapsed
                    if timeElapsed > 0.01 then
                        local lowPrecision = 0.5
                        local highPrecision = 20
                        local _, newY = GetCursorPosition()
                        local dif = newY - y
                        local newValue;

                        if IsShiftKeyDown() then
                            if dif > 0 then
                                newValue = BoxSlider:GetNumber() + math.floor((dif / highPrecision))
                                if dif > highPrecision then y = newY end
                            else
                                newValue = BoxSlider:GetNumber() - math.floor(math.abs((dif / highPrecision)))
                                if dif < (highPrecision * -1) then y = newY end
                            end
                        else
                            if dif > 0 then
                                newValue = BoxSlider:GetNumber() + math.floor((dif / lowPrecision))
                                if dif > lowPrecision then y = newY end
                            else
                                newValue = BoxSlider:GetNumber() - math.floor(math.abs((dif / lowPrecision)))
                                if dif < (lowPrecision * -1) then y = newY end
                            end
                        end

                        if newValue < BoxSlider.lower then newValue = BoxSlider.lower end
                        if newValue > BoxSlider.upper then newValue = BoxSlider.upper end
                        BoxSlider:SetNumber(newValue)
                        addon.db.profile[unit][section][param] = BoxSlider:GetNumber()
                        addon.UpdateUnitFrame(unit)

                        timeElapsed = 0
                    end
                end)

            elseif button == 'RightButton' then
                BoxSlider:SetBackdropColor(41/255, 43/255, 47/255, 1)
                BoxSlider:SetBackdropBorderColor(255/255, 255/255, 255/255, 1)
                BoxSlider:Enable()
            end
        end
    end)

    BoxSlider:SetScript('OnMouseUp', function(_, button)
        if button == 'LeftButton' then
            BoxSlider:SetScript('OnUpdate', nil)
            BoxSlider:SetTextColor(190/255, 190/255, 190/255, 255/255)
            isDragging = false
        end
    end)

    BoxSlider:SetScript('OnEnterPressed', function()
        BoxSlider:Disable()
        BoxSlider:SetBackdropColor(41/255, 43/255, 47/255, 0)
        BoxSlider:SetBackdropBorderColor(255/255, 255/255, 255/255, 0)
        local value = BoxSlider:GetNumber()
        if value < lower then value = lower end
        if value > upper then value = upper end
        BoxSlider:SetNumber(value)
        addon.db.profile[unit][section][param] = value
        addon.UpdateUnitFrame(unit)
    end)

    BoxSlider:SetScript('OnEnter', function()
        if BoxSlider.enabled then
            BoxSlider:SetTextColor(1, 1, 1, 1)
        end
    end)

    BoxSlider:SetScript('OnLeave', function()
        if not isDragging then
            BoxSlider:SetTextColor(190/255, 190/255, 190/255, 255/255)
        end
    end)

    return BoxSlider
end