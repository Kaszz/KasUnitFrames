local _, addon = ...
local isElv = false

local function UpdateRed(value)
    local _, g, b = ColorPickerFrame:GetColorRGB()
    ColorPickerFrame:SetColorRGB(value/255, g, b)
end

local function UpdateGreen(value)
    local r, _, b = ColorPickerFrame:GetColorRGB()
    ColorPickerFrame:SetColorRGB(r, value/255, b)
end

local function UpdateBlue(value)
    local r, g, _ = ColorPickerFrame:GetColorRGB()
    ColorPickerFrame:SetColorRGB(r, g, value/255)
end

local function UpdateAlpha(value)
    OpacitySliderFrame:SetValue(1 - (value/100))
end

function addon:UpdateColorPickerSliders(r, g, b, a)
    if not isElv then
        ColorPickerFrame.red:SetNumber(math.floor(r * 255))
        ColorPickerFrame.green:SetNumber(math.floor(g * 255))
        ColorPickerFrame.blue:SetNumber(math.floor(b * 255))
        ColorPickerFrame.alpha:SetNumber(math.floor(a * 100))
    end
end

local function AddSliders()
    local redSlider = addon:CreateSlider(
            ColorPickerFrame,
            'RED',
            0,
            255,
            function()      return 0 end,
            function(value) UpdateRed(value) end,
            function()      end,
            function()      return true end
    )
    redSlider:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', -120, 50)

    local greenSlider = addon:CreateSlider(
            ColorPickerFrame,
            'GREEN',
            0,
            255,
            function()      return 0 end,
            function(value) UpdateGreen(value) end,
            function()      end,
            function()      return true end
    )
    greenSlider:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', -55, 50)

    local blueSlider = addon:CreateSlider(
            ColorPickerFrame,
            'BLUE',
            0,
            255,
            function()      return 0 end,
            function(value) UpdateBlue(value) end,
            function()      end,
            function()      return true end
    )
    blueSlider:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', 10, 50)

    local alphaSlider = addon:CreateSlider(
            ColorPickerFrame,
            'ALPHA',
            0,
            100,
            function()      return 0 end,
            function(value) UpdateAlpha(value) end,
            function()      end,
            function()      return true end
    )
    alphaSlider:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', 120, 50)

    ColorPickerFrame.red = redSlider
    ColorPickerFrame.green = greenSlider
    ColorPickerFrame.blue = blueSlider
    ColorPickerFrame.alpha = alphaSlider
end

local function SetClassColor()
    _, class = UnitClass('player');
    print(class)

    local r, g, b = GetClassColor(class)

    ColorPickerFrame:SetColorRGB(r, g, b)
    OpacitySliderFrame:SetValue(0)
    addon:UpdateColorPickerSliders(r, g, b, 1)
end

local function SetDefaultColor()
    local r  = ColorPickerFrame.default.r / 255
    local g  = ColorPickerFrame.default.g / 255
    local b  = ColorPickerFrame.default.b / 255
    local a  = ColorPickerFrame.default.a / 100

    ColorPickerFrame:SetColorRGB(r, g, b)
    OpacitySliderFrame:SetValue(1 - a)
    addon:UpdateColorPickerSliders(r, g, b, a)
end

local function AddButtons()
    local classButton = addon:CreateButton(
            ColorPickerFrame,
            'Class color',
            80,
            function() SetClassColor() end
    )
    classButton:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', 62, 150)

    local defaultButton = addon:CreateButton(
            ColorPickerFrame,
            'Default',
            80,
            function() SetDefaultColor() end
    )
    defaultButton:SetPoint('CENTER', ColorPickerFrame, 'BOTTOM', 62, 125)
end

local function MakeMovable()
    local header = CreateFrame('Frame', nil, ColorPickerFrame, "BackdropTemplate")
    header:SetSize(350, 25)
    header:SetBackdrop({
        bgFile = 'Interface\\Buttons\\WHITE8x8',
    })
    header:SetBackdropColor(0, 0, 0, 0.3)
    header:SetPoint('TOP', ColorPickerFrame, 'TOP', 0, 5)

    ColorPickerFrame:RegisterForDrag('LeftButton')
    header:RegisterForDrag('LeftButton')
    header:SetScript('OnDragStart', function()
        ColorPickerFrame:StartMoving()
    end)

    header:SetScript('OnDragStop', function()
        ColorPickerFrame:StopMovingOrSizing()
    end)

    header:SetScript('OnEnter', function() end)
end

function addon:UpdateColorPickerFrame()
    if ColorPickerFrame.backdropInfo ~= nil then
        isElv = true
    end

    if not isElv then
        ColorPickerFrame:SetHeight(250)
        MakeMovable()
        AddSliders()
        AddButtons()
    end
end
