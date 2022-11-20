local _, addon = ...

--function addon:CreateCheckBox(parent, label, value, enabled, vertical)
--    local CheckBox = CreateFrame('CheckButton', nil, parent, "BackdropTemplate")
--    CheckBox:SetSize(20, 20)
--    CheckBox:SetNormalFontObject(KufCheckboxText)
--    CheckBox:SetPushedTextOffset(1, -1)
--    CheckBox:SetChecked(value)
--    CheckBox.type = 'checkbox'
--    CheckBox.isEnabled = enabled
--
--    CheckBox.box = CheckBox:CreateTexture('PUSHED_TEXTURE_BOX', 'BACKGROUND')
--    CheckBox.box:SetSize(14, 14)
--    CheckBox.box:SetPoint('LEFT', CheckBox, 'LEFT', -2, 3)
--    CheckBox.box:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\box2.tga')
--    CheckBox.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)
--
--    CheckBox.check = CheckBox:CreateTexture('PUSHEDTEXTURE', 'BACKGROUND')
--    CheckBox.check:SetSize(14, 14)
--    CheckBox.check:SetPoint('CENTER', CheckBox, -5, 3)
--    CheckBox.check:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\baseline-done-small@2x.tga')
--    CheckBox.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
--    CheckBox:SetCheckedTexture(CheckBox.check)
--
--    CheckBox.text = CheckBox:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
--    CheckBox.text:SetText(label)
--    CheckBox.text:SetTextColor(1, 1, 1, 1)
--
--    if (vertical) then
--        CheckBox.text:SetPoint('TOP', CheckBox.box, 0, 12)
--    else
--        CheckBox.text:SetPoint('LEFT', CheckBox.box, 'RIGHT', 5, 3)
--    end
--
--    CheckBox:SetScript('OnEnter', function(self)
--        if CheckBox:GetChecked() then
--            self.box:SetVertexColor(1, 1, 1, 1)
--            self.check:SetVertexColor(1, 1, 1, 1)
--        end
--    end)
--
--    CheckBox:SetScript('OnLeave', function(self)
--        self.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)
--        self.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
--    end)
--
--    return CheckBox
--end

function addon:CreateCheckBox(parent, label, value, enabled, vertical)
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetSize(70, 16)
    frame.type = 'checkbox'
    frame.isEnabled = enabled

    frame.text = frame:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    frame.text:SetText(label)
    frame.text:SetTextColor(1, 1, 1, 1)
    frame.text:SetPoint('CENTER')

    frame.CheckBox = CreateFrame('CheckButton', nil, frame, "BackdropTemplate")
    frame.CheckBox:SetSize(20, 20)
    frame.CheckBox:SetNormalFontObject(KufCheckboxText)
    frame.CheckBox:SetPushedTextOffset(1, -1)
    frame.CheckBox:SetChecked(value)

    frame.CheckBox.box = frame.CheckBox:CreateTexture('PUSHED_TEXTURE_BOX', 'BACKGROUND')
    frame.CheckBox.box:SetSize(14, 14)
    frame.CheckBox.box:SetPoint('LEFT', frame.CheckBox, 'LEFT', -2, 3)
    frame.CheckBox.box:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\box2.tga')
    frame.CheckBox.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)

    frame.CheckBox.check = frame.CheckBox:CreateTexture('PUSHEDTEXTURE', 'BACKGROUND')
    frame.CheckBox.check:SetSize(14, 14)
    frame.CheckBox.check:SetPoint('CENTER', frame.CheckBox, -5, 3)
    frame.CheckBox.check:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\baseline-done-small@2x.tga')
    frame.CheckBox.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
    frame.CheckBox:SetCheckedTexture(frame.CheckBox.check)

    frame.CheckBox:SetScript('OnEnter', function(self)
        if frame.CheckBox:GetChecked() then
            self.box:SetVertexColor(1, 1, 1, 1)
            self.check:SetVertexColor(1, 1, 1, 1)
        end
    end)

    frame.CheckBox:SetScript('OnLeave', function(self)
        self.box:SetVertexColor(190/255, 190/255, 190/255, 255/255)
        self.check:SetVertexColor(190/255, 190/255, 190/255, 255/255)
    end)

    frame.GetChecked = function(self)
        return self.CheckBox:GetChecked()
    end

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