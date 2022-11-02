local _, addon = ...

local strlen, strjoin, gsub, next = strlen, strjoin, gsub, next
local tonumber, floor, strsub, wipe = tonumber, floor, strsub, wipe

local CreateFrame = CreateFrame
local IsControlKeyDown = IsControlKeyDown
local IsModifierKeyDown = IsModifierKeyDown
local CALENDAR_COPY_EVENT, CALENDAR_PASTE_EVENT = CALENDAR_COPY_EVENT, CALENDAR_PASTE_EVENT
local CLASS, DEFAULT = CLASS, DEFAULT

local colorBuffer = {}
local function alphaValue(num)
    return num and floor(((1 - num) * 100) + .05) or 0
end

local function UpdateAlphaText(alpha)
    if not alpha then alpha = alphaValue(OpacitySliderFrame:GetValue()) end

    ColorPPBoxA:SetText(alpha)
end

local function UpdateAlpha(tbox)
    local num = tbox:GetNumber()
    if num > 100 then
        tbox:SetText(100)
        num = 100
    end

    OpacitySliderFrame:SetValue(1 - (num * 0.01))
end

local function expandFromThree(r, g, b)
    return strjoin('',r,r,g,g,b,b)
end

local function extendToSix(str)
    for _=1, 6-strlen(str) do str=str..0 end
    return str
end

local function GetHexColor(box)
    local rgb, rgbSize = box:GetText(), box:GetNumLetters()
    if rgbSize == 3 then
        rgb = gsub(rgb, '(%x)(%x)(%x)$', expandFromThree)
    elseif rgbSize < 6 then
        rgb = gsub(rgb, '(.+)$', extendToSix)
    end

    local r, g, b = tonumber(strsub(rgb,0,2),16) or 0, tonumber(strsub(rgb,3,4),16) or 0, tonumber(strsub(rgb,5,6),16) or 0

    return r/255, g/255, b/255
end

local function UpdateColorTexts(r, g, b, box)
    if not (r and g and b) then
        r, g, b = ColorPickerFrame:GetColorRGB()

        if box then
            if box == ColorPPBoxH then
                r, g, b = GetHexColor(box)
            else
                local num = box:GetNumber()
                if num > 255 then num = 255 end
                local c = num/255
                if box == ColorPPBoxR then
                    r = c
                elseif box == ColorPPBoxG then
                    g = c
                elseif box == ColorPPBoxB then
                    b = c
                end
            end
        end
    end

    -- we want those /255 values
    r, g, b = r*255, g*255, b*255

    ColorPPBoxH:SetText(('%.2x%.2x%.2x'):format(r, g, b))
    ColorPPBoxR:SetText(r)
    ColorPPBoxG:SetText(g)
    ColorPPBoxB:SetText(b)
end

local function UpdateColor()
    local r, g, b = GetHexColor(ColorPPBoxH)
    ColorPickerFrame:SetColorRGB(r, g, b)
    ColorSwatch:SetColorTexture(r, g, b)
end

local function ColorPPBoxA_SetFocus()
    ColorPPBoxA:SetFocus()
end

local function ColorPPBoxR_SetFocus()
    ColorPPBoxR:SetFocus()
end

local delayWait, delayFunc = 0.15
local function delayCall()
    if delayFunc then
        delayFunc()
        delayFunc = nil
    end
end

local last = {r = 0, g = 0, b = 0, a = 0}
local function onColorSelect(frame, r, g, b)
    if frame.noColorCallback then
        return -- prevent error from E:GrabColorPickerValues, better note in that function
    elseif r ~= last.r or g ~= last.g or b ~= last.b then
        last.r, last.g, last.b = r, g, b
    else -- colors match so we don't need to update, most likely mouse is held down
        return
    end

    ColorSwatch:SetColorTexture(r, g, b)
    UpdateColorTexts(r, g, b)

    if not frame:IsVisible() then
        delayCall()
    elseif not delayFunc then
        delayFunc = ColorPickerFrame.func
        --Delay(delayWait, delayCall)
    end
end

local function onValueChanged(_, value)
    local alpha = alphaValue(value)
    if last.a ~= alpha then
        last.a = alpha
    else -- alpha matched so we don't need to update
        return
    end

    UpdateAlphaText(alpha)

    if not ColorPickerFrame:IsVisible() then
        delayCall()
    else
        local opacityFunc = ColorPickerFrame.opacityFunc
        if delayFunc and (delayFunc ~= opacityFunc) then
            delayFunc = opacityFunc
        elseif not delayFunc then
            delayFunc = opacityFunc
        end
    end
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

function addon:EnhanceColorPicker()
    local name, _ = UnitName('player')
    local elvuiState = GetAddOnEnableState(name, 'ElvUI')

    if (elvuiState == 2) then
        return
    end

    local Picker = ColorPickerFrame

    local Header = Picker.Header or ColorPickerFrameHeader
    Header:ClearAllPoints()
    Header:SetPoint('TOP', Picker, 0, 5)

    ColorPickerCancelButton:ClearAllPoints()
    ColorPickerOkayButton:ClearAllPoints()
    ColorPickerCancelButton:SetPoint('BOTTOMRIGHT', Picker, 'BOTTOMRIGHT', -6, 6)
    ColorPickerCancelButton:SetPoint('BOTTOMLEFT', Picker, 'BOTTOM', 0, 6)
    ColorPickerOkayButton:SetPoint('BOTTOMLEFT', Picker,'BOTTOMLEFT', 6,6)
    ColorPickerOkayButton:SetPoint('RIGHT', ColorPickerCancelButton,'LEFT', -4,0)

    Picker:HookScript('OnShow', function(frame)
        -- get color that will be replaced
        local r, g, b = frame:GetColorRGB()
        ColorPPOldColorSwatch:SetColorTexture(r,g,b)

        -- show/hide the alpha box
        if frame.hasOpacity then
            ColorPPBoxA:Show()
            ColorPPBoxLabelA:Show()
            ColorPPBoxH:SetScript('OnTabPressed', ColorPPBoxA_SetFocus)
            UpdateAlphaText()
            UpdateColorTexts()
            frame:SetWidth(405)
        else
            ColorPPBoxA:Hide()
            ColorPPBoxLabelA:Hide()
            ColorPPBoxH:SetScript('OnTabPressed', ColorPPBoxR_SetFocus)
            UpdateColorTexts()
            frame:SetWidth(345)
        end

        -- Memory Fix, Colorpicker will call the self.func() 100x per second, causing fps/memory issues,
        -- We overwrite these two scripts and set a limit on how often we allow a call their update functions
        OpacitySliderFrame:SetScript('OnValueChanged', onValueChanged)
        frame:SetScript('OnColorSelect', onColorSelect)
    end)

    -- move the Color Swatch
    ColorSwatch:ClearAllPoints()
    ColorSwatch:SetPoint('TOPLEFT', Picker, 'TOPLEFT', 215, -45)
    local swatchWidth, swatchHeight = ColorSwatch:GetSize()

    -- add Color Swatch for original color
    local originalColor = Picker:CreateTexture('ColorPPOldColorSwatch')
    originalColor:SetSize(swatchWidth*0.75, swatchHeight*0.75)
    originalColor:SetColorTexture(0,0,0)
    -- OldColorSwatch to appear beneath ColorSwatch
    originalColor:SetDrawLayer('BORDER')
    originalColor:SetPoint('BOTTOMLEFT', 'ColorSwatch', 'TOPRIGHT', -(swatchWidth*0.5), -(swatchHeight/3))

    -- add Color Swatch for the copied color
    local copiedColor = Picker:CreateTexture('ColorPPCopyColorSwatch')
    copiedColor:SetColorTexture(0,0,0)
    copiedColor:SetSize(swatchWidth, swatchHeight)
    copiedColor:Hide()

    -- add copy button to the ColorPickerFrame
    local copyButton = CreateFrame('Button', 'ColorPPCopy', Picker, 'UIPanelButtonTemplate')
    copyButton:SetText(CALENDAR_COPY_EVENT)
    copyButton:SetSize(60, 22)
    copyButton:SetPoint('TOPLEFT', 'ColorSwatch', 'BOTTOMLEFT', 0, -5)

    -- copy color into buffer on button click
    copyButton:SetScript('OnClick', function()
        -- copy current dialog colors into buffer
        colorBuffer.r, colorBuffer.g, colorBuffer.b = Picker:GetColorRGB()

        -- enable Paste button and display copied color into swatch
        ColorPPPaste:Enable()
        ColorPPCopyColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        ColorPPCopyColorSwatch:Show()

        colorBuffer.a = (Picker.hasOpacity and OpacitySliderFrame:GetValue()) or nil
    end)

    -- class color button
    local classButton = CreateFrame('Button', 'ColorPPClass', Picker, 'UIPanelButtonTemplate')
    classButton:SetText(CLASS)
    classButton:SetSize(80, 22)
    classButton:SetPoint('TOP', 'ColorPPCopy', 'BOTTOMRIGHT', 0, -7)

    classButton:SetScript('OnClick', function()
        _, myclass = UnitClass('player');
        local r, g, b, _ = GetClassColor(myclass)
        Picker:SetColorRGB(r, g, b)
        ColorSwatch:SetColorTexture(r, g, b)
        if Picker.hasOpacity then
            OpacitySliderFrame:SetValue(0)
        end
    end)

    -- add paste button to the ColorPickerFrame
    local pasteButton = CreateFrame('Button', 'ColorPPPaste', Picker, 'UIPanelButtonTemplate')
    pasteButton:SetText(CALENDAR_PASTE_EVENT)
    pasteButton:SetSize(60, 22)
    pasteButton:SetPoint('TOPLEFT', 'ColorPPCopy', 'TOPRIGHT', 2, 0)
    pasteButton:Disable() -- enable when something has been copied

    -- paste color on button click, updating frame components
    pasteButton:SetScript('OnClick', function()
        Picker:SetColorRGB(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        ColorSwatch:SetColorTexture(colorBuffer.r, colorBuffer.g, colorBuffer.b)
        if Picker.hasOpacity then
            if colorBuffer.a then --color copied had an alpha value
                OpacitySliderFrame:SetValue(colorBuffer.a)
            end
        end
    end)

    -- add defaults button to the ColorPickerFrame
    local defaultButton = CreateFrame('Button', 'ColorPPDefault', Picker, 'UIPanelButtonTemplate')
    defaultButton:SetText(DEFAULT)
    defaultButton:SetSize(80, 22)
    defaultButton:SetPoint('TOPLEFT', 'ColorPPClass', 'BOTTOMLEFT', 0, -7)
    defaultButton:Disable() -- enable when something has been copied
    defaultButton:SetScript('OnHide', function(btn) if btn.colors then wipe(btn.colors) end end)
    defaultButton:SetScript('OnShow', function(btn) btn:SetEnabled(btn.colors) end)

    -- paste color on button click, updating frame components
    defaultButton:SetScript('OnClick', function(btn)
        local colors = btn.colors
        Picker:SetColorRGB(colors.r, colors.g, colors.b)
        ColorSwatch:SetColorTexture(colors.r, colors.g, colors.b)
        if Picker.hasOpacity then
            if colors.a then
                OpacitySliderFrame:SetValue(colors.a)
            end
        end
    end)

    -- position Color Swatch for copy color
    ColorPPCopyColorSwatch:SetPoint('BOTTOM', 'ColorPPPaste', 'TOP', 0, 10)

    -- move the Opacity Slider to align with bottom of Copy ColorSwatch
    OpacitySliderFrame:ClearAllPoints()
    OpacitySliderFrame:SetPoint('BOTTOM', 'ColorPPDefault', 'BOTTOM', 0, 0)
    OpacitySliderFrame:SetPoint('RIGHT', 'ColorPickerFrame', 'RIGHT', -35, 18)

    -- set up edit box frames and interior label and text areas
    for i, rgb in next, { 'R', 'G', 'B', 'H', 'A' } do
        local box = CreateFrame('EditBox', 'ColorPPBox'..rgb, Picker, 'InputBoxTemplate')
        box:SetPoint('TOP', 'ColorPickerWheel', 'BOTTOM', 0, -15)
        box:SetFrameStrata('DIALOG')
        box:SetAutoFocus(false)
        box:SetTextInsets(0,7,0,0)
        box:SetJustifyH('RIGHT')
        box:SetHeight(24)
        box:SetID(i)

        -- hex entry box
        if i == 4 then
            box:SetMaxLetters(6)
            box:SetWidth(56)
            box:SetNumeric(false)
        else
            box:SetMaxLetters(3)
            box:SetWidth(40)
            box:SetNumeric(true)
        end

        -- label
        local label = box:CreateFontString('ColorPPBoxLabel'..rgb, 'ARTWORK', 'GameFontNormalSmall')
        label:SetPoint('RIGHT', 'ColorPPBox'..rgb, 'LEFT', -5, 0)
        label:SetText(i == 4 and '#' or rgb)
        label:SetTextColor(1, 1, 1)

        -- set up scripts to handle event appropriately
        if i == 5 then
            box:SetScript('OnKeyUp', function(eb, key)
                local copyPaste = IsControlKeyDown() and key == 'V'
                if key == 'BACKSPACE' or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
                    UpdateAlpha(eb)
                elseif key == 'ENTER' or key == 'ESCAPE' then
                    eb:ClearFocus()
                    UpdateAlpha(eb)
                end
            end)
        else
            box:SetScript('OnKeyUp', function(eb, key)
                local copyPaste = IsControlKeyDown() and key == 'V'
                if key == 'BACKSPACE' or copyPaste or (strlen(key) == 1 and not IsModifierKeyDown()) then
                    if i ~= 4 then UpdateColorTexts(nil, nil, nil, eb) end
                    if i == 4 and eb:GetNumLetters() ~= 6 then return end
                    UpdateColor()
                elseif key == 'ENTER' or key == 'ESCAPE' then
                    eb:ClearFocus()
                    UpdateColorTexts(nil, nil, nil, eb)
                    UpdateColor()
                end
            end)
        end

        box:SetScript('OnEditFocusGained', function(eb) eb:SetCursorPosition(0) eb:HighlightText() end)
        box:SetScript('OnEditFocusLost', function(eb) eb:HighlightText(0,0) end)
        box:Show()
    end

    -- finish up with placement
    ColorPPBoxA:SetPoint('RIGHT', 'OpacitySliderFrame', 'RIGHT', 10, 0)
    ColorPPBoxH:SetPoint('RIGHT', 'ColorPPDefault', 'RIGHT', -10, 0)
    ColorPPBoxB:SetPoint('RIGHT', 'ColorPPDefault', 'LEFT', -40, 0)
    ColorPPBoxG:SetPoint('RIGHT', 'ColorPPBoxB', 'LEFT', -25, 0)
    ColorPPBoxR:SetPoint('RIGHT', 'ColorPPBoxG', 'LEFT', -25, 0)

    -- define the order of tab cursor movement
    ColorPPBoxR:SetScript('OnTabPressed', function() ColorPPBoxG:SetFocus() end)
    ColorPPBoxG:SetScript('OnTabPressed', function() ColorPPBoxB:SetFocus() end)
    ColorPPBoxB:SetScript('OnTabPressed', function() ColorPPBoxH:SetFocus() end)
    ColorPPBoxA:SetScript('OnTabPressed', function() ColorPPBoxR:SetFocus() end)

    -- make the color picker movable.
    local mover = CreateFrame('Frame', nil, Picker)
    mover:SetPoint('TOPLEFT', Picker, 'TOP', -60, 0)
    mover:SetPoint('BOTTOMRIGHT', Picker, 'TOP', 60, -15)
    mover:SetScript('OnMouseDown', function() Picker:StartMoving() end)
    mover:SetScript('OnMouseUp', function() Picker:StopMovingOrSizing() end)
    mover:EnableMouse(true)

    -- make the frame a bit taller, to make room for edit boxes
    Picker:SetHeight(Picker:GetHeight() + 40)

    -- skin the frame
    MakeMovable()
    --Picker:SetTemplate('Transparent')
    --Picker:SetClampedToScreen(true)
    --Picker:SetUserPlaced(true)
    --Picker:EnableKeyboard(false)
end
