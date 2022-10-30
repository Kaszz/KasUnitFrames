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

    CheckBox.text = CheckBox:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
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

local function UpdateAnimation(index, label, colors, parent)
    local CheckBoxText = ''

    for i = 1, #label do
        local c = label:sub(i, i)
        CheckBoxText = CheckBoxText ..  WrapTextInColorCode(c, colors[((i + index) % #colors) + 1])
    end

    parent.text:SetText(CheckBoxText)
end

function addon.CreateCheckBoxGradient(parent, label, colors, enabled)
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