local _, addon = ...

local function ColorCallback(self, r, g, b, a, saveChanges)
    self.color:SetColorTexture(r, g, b, a)
    addon:UpdateColorPickerSliders(r, g, b, a)

    if not ColorPickerFrame:IsVisible() then
        if saveChanges then
            local result = {
                r = r*255,
                g = g*255,
                b = b*255,
                a = a*100
            }
            print('set: 15')
            self.set(result)
        end
    end
end

local function ColorSwatch_OnClick(frame)
    ColorPickerFrame:Hide()

    local r, g, b, a = frame.get().r/255, frame.get().g/255, frame.get().b/255, frame.get().a/100
    ColorPickerFrame:SetColorRGB(r, g, b)
    OpacitySliderFrame:SetValue(1 - a)

    if not frame.disabled then
        ColorPickerFrame:SetFrameStrata("FULLSCREEN_DIALOG")
        ColorPickerFrame:SetFrameLevel(frame:GetFrameLevel() + 10)
        ColorPickerFrame:SetClampedToScreen(true)

        ColorPickerFrame.func = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = 1 - OpacitySliderFrame:GetValue()
            print('func')
            ColorCallback(frame, r, g, b, a, true)
        end

        ColorPickerFrame.hasOpacity = true
        ColorPickerFrame.opacityFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            local a = 1 - OpacitySliderFrame:GetValue()
            print('opacityFunc')
            ColorCallback(frame, r, g, b, a, true)
        end

        local r, g, b, a = frame.get().r/255, frame.get().g/255, frame.get().b/255, frame.get().a/100
        ColorPickerFrame.opacity = 1 - (a or 0)
        ColorPickerFrame:SetColorRGB(r, g, b)
        ColorPickerFrame.cancelFunc = function()
            print('cancelFunc')
            ColorCallback(frame, r, g, b, a, false)
        end

        ColorPickerFrame:Show()
    end
end

local function CreateColorPicker(parent, get, set, enabled, default)
    local frame = CreateFrame('Button', nil, parent, 'BackdropTemplate')
    frame:SetSize(29, 22)
    frame:SetBackdrop({
        bgFile="Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\checkers",
        edgeFile="Interface\\Buttons\\WHITE8x8",
        tile = true,
        tileSize = 16,
        edgeSize = 1,
    })
    frame:SetBackdropBorderColor(0, 0, 0)
    frame:EnableMouse(true)
    frame.disabled = false
    frame.get = get
    frame.set = set
    ColorPickerFrame.default = default

    frame.color = frame:CreateTexture(nil, "BORDER", nil, 1)
    frame.color:SetSize(27, 20)
    frame.color:SetPoint("CENTER")
    frame.color:SetColorTexture(get().r/255, get().g/255, get().b/255, get().a/100)

    frame.hider = frame:CreateTexture(nil, "BORDER", nil, 2)
    frame.hider:SetSize(29, 22)
    frame.hider:SetPoint("CENTER")
    frame.hider:SetColorTexture(47/255, 49/255, 54/255, 0.7)
    frame.hider:Hide()

    frame:SetScript("OnClick", function(self)
        if (enabled()) then
            ColorSwatch_OnClick(self)
        end
    end)

    return frame
end

function addon:CreateSingleColorPicker(parent, text, get, set, enabled, default)
    local colorPickerFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    colorPickerFrame:SetSize(48,16)

    colorPickerFrame.text = colorPickerFrame:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    colorPickerFrame.text:SetText(text)
    colorPickerFrame.text:SetPoint('TOP', 0, 5)

    colorPickerFrame.picker = CreateColorPicker(parent, get, set, enabled, default)
    colorPickerFrame.picker:SetPoint('BOTTOM', colorPickerFrame, 0, -18)

    colorPickerFrame.Update = function()
        if (enabled()) then
            colorPickerFrame:SetAlpha(1)
            colorPickerFrame.picker.hider:Hide()
        else
            colorPickerFrame:SetAlpha(0.3)
            colorPickerFrame.picker.hider:Show()
        end
    end
    colorPickerFrame.Update()



    return colorPickerFrame
end