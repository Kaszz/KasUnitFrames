local _, addon = ...

function addon:CreateCheckBox(parent, label, vertical, enabled, get, set, update)
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetSize(70, 16)
    frame.type = 'checkbox'
    frame.isEnabled = enabled

    frame.text = frame:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    frame.text:SetText(label)
    frame.text:SetTextColor(1, 1, 1, 1)
    frame.textBackdrop = CreateFrame('Button', nil, frame)
    frame.textBackdrop:SetSize(frame.text:GetStringWidth(), 14)

    if (vertical) then
        frame:SetWidth(16)
        frame.text:SetPoint('LEFT', 18, 0)
        frame.textBackdrop:SetPoint('LEFT', 18, 0)
    else
        frame.text:SetPoint('TOP', 0, 14)
        frame.textBackdrop:SetPoint('TOP', 0, 15)
    end

    if (frame.text:GetStringWidth() > 70) then
        frame:SetWidth(frame.text:GetStringWidth())
    end

    frame.checkBox = CreateFrame('CheckButton', nil, frame, "BackdropTemplate")
    frame.checkBox:SetSize(16, 16)
    frame.checkBox:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1
    })
    frame.checkBox:SetBackdropColor(41/255, 43/255, 47/255, 1)
    frame.checkBox:SetBackdropBorderColor(0, 0, 0, 1)
    frame.checkBox:SetPoint('CENTER')
    frame.checkBox:SetChecked(get())

    frame.checkBox.check = frame.checkBox:CreateTexture('PUSHED_TEXTURE_BOX', 'BACKGROUND')
    frame.checkBox.check:SetSize(14, 14)
    frame.checkBox.check:SetPoint('CENTER', frame.checkBox, 0, 0)
    frame.checkBox.check:SetTexture('Interface\\Buttons\\WHITE8x8')
    frame.checkBox.check:SetVertexColor(254/255, 231/255, 92/255, 255/255)
    frame.checkBox:SetCheckedTexture(frame.checkBox.check)

    frame.textBackdrop:SetScript('OnMouseDown', function()
        if (enabled()) then
            frame.checkBox:SetChecked(not frame.checkBox:GetChecked())
            set(frame.checkBox:GetChecked())
            update()
        end
    end)

    frame.checkBox:SetScript('OnClick', function()
        if (enabled()) then
            set(frame.checkBox:GetChecked())
            update()
        else
            frame.checkBox:SetChecked(not frame.checkBox:GetChecked())
        end
    end)

    return frame
end


local function UpdateAnimation(index, label, colors, parent)
    local CheckBoxText = ''

    for i = 1, #label do
        local c = label:sub(i, i)
        CheckBoxText = CheckBoxText ..  WrapTextInColorCode(c, colors[((i + index) % #colors) + 1])
    end

    parent.text:SetText(CheckBoxText)
end

function addon:CreateCheckBoxGradient(parent, label, colors, enabled)
    local CheckBox = CreateFrame('CheckButton', nil, parent, "BackdropTemplate")
    CheckBox:SetSize(20, 20)
    CheckBox:SetNormalFontObject(KufCheckboxText)
    CheckBox:SetPushedTextOffset(1, -1)
    CheckBox:SetChecked(enabled)
    CheckBox.index = 1

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

    local CheckBoxText = ''

    for i = 1, #label do
        local c = label:sub(i, i)
        if enabled then
            CheckBoxText = CheckBoxText ..  WrapTextInColorCode(c, colors[i + 11])
        else
            CheckBoxText = CheckBoxText ..  WrapTextInColorCode(c, colors[((i + 43) % #colors) + 1])
        end
    end

    CheckBox.text = CheckBox:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    CheckBox.text:SetText(CheckBoxText)
    CheckBox.text:SetTextColor(1, 1, 1, 1)
    CheckBox.text:SetPoint('LEFT', CheckBox.box, 'RIGHT', 5, 0)

    CheckBox:SetScript('OnEnter', function(self)
        local initialValue = CheckBox:GetChecked()
        if CheckBox:GetChecked() then
            self.box:SetVertexColor(1, 1, 1, 1)
            self.check:SetVertexColor(1, 1, 1, 1)
        end

        local timeElapsed = 0
        CheckBox:SetScript('OnUpdate', function(_, elapsed)
            timeElapsed = timeElapsed + elapsed
            if timeElapsed > 0.05 then
                timeElapsed = 0
                CheckBox.index = CheckBox.index + 1

                if CheckBox.index > #colors then
                    CheckBox.index = 1
                end

                if initialValue ~= CheckBox:GetChecked() then
                    if CheckBox:GetChecked() then
                        if CheckBox.index == 11 then
                            CheckBox:SetScript('OnUpdate', nil)
                        end
                    else
                        if CheckBox.index == 43 then
                            CheckBox:SetScript('OnUpdate', nil)
                        end
                    end
                end

                UpdateAnimation(CheckBox.index, label, colors, CheckBox)
            end
        end)

        CheckBox:SetScript('OnMouseDown', function()
            initialValue = CheckBox:GetChecked()
            CheckBox:SetScript('OnUpdate', function(_, elapsed)
                timeElapsed = timeElapsed + elapsed
                if timeElapsed > 0.05 then
                    timeElapsed = 0
                    CheckBox.index = CheckBox.index + 1

                    if CheckBox.index > #colors then
                        CheckBox.index = 1
                    end

                    if initialValue ~= CheckBox:GetChecked() then
                        if CheckBox:GetChecked() then
                            if CheckBox.index == 11 then
                                CheckBox:SetScript('OnUpdate', nil)
                            end
                        else
                            if CheckBox.index == 43 then
                                CheckBox:SetScript('OnUpdate', nil)
                            end
                        end
                    end

                    UpdateAnimation(CheckBox.index, label, colors, CheckBox)
                end
            end)
        end)
    end)

    CheckBox:SetScript('OnLeave', function(self)
        self.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)
        self.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)

        local timeElapsed = 0
        CheckBox:SetScript('OnUpdate', function(_, elapsed)
            timeElapsed = timeElapsed + elapsed
            if timeElapsed > 0.05 then
                timeElapsed = 0
                CheckBox.index = CheckBox.index + 1

                if CheckBox.index > #colors then
                    CheckBox.index = 1
                end

                if initialValue ~= CheckBox:GetChecked() then
                    if CheckBox:GetChecked() then
                        if CheckBox.index == 11 then
                            CheckBox:SetScript('OnUpdate', nil)
                        end
                    else
                        if CheckBox.index == 43 then
                            CheckBox:SetScript('OnUpdate', nil)
                        end
                    end
                end

                UpdateAnimation(CheckBox.index, label, colors, CheckBox)
            end
        end)
    end)

    return CheckBox
end