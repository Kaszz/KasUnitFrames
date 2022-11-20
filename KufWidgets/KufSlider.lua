local _, addon = ...
local timeElapsed = 0
local lowPrecision = 0.5
local highPrecision = 20
local _, y = GetCursorPosition()

local function OnUpdate(self, elapsed)
    timeElapsed = timeElapsed + elapsed
    if timeElapsed > 0.01 then

        local _, newY = GetCursorPosition()
        local dif = newY - y
        local newValue;

        if IsShiftKeyDown() then
            if dif > 0 then
                newValue = self:GetNumber() + math.floor((dif / highPrecision))
                if dif > highPrecision then y = newY end
            else
                newValue = self:GetNumber() - math.floor(math.abs((dif / highPrecision)))
                if dif < (highPrecision * -1) then y = newY end
            end
        else
            if dif > 0 then
                newValue = self:GetNumber() + math.floor((dif / lowPrecision))
                if dif > lowPrecision then y = newY end
            else
                newValue = self:GetNumber() - math.floor(math.abs((dif / lowPrecision)))
                if dif < (lowPrecision * -1) then y = newY end
            end
        end

        if newValue < self.lower then newValue = self.lower end
        if newValue > self.upper then newValue = self.upper end
        timeElapsed = 0

        self:SetNumber(newValue)
        self.set(self:GetNumber())
        self.update()
    end
end

local function OnMouseDown(self, button)
    if self.isEnabled() then
        if button == 'LeftButton' and not self:IsEnabled() then
            _, y = GetCursorPosition()
            self.dragging = true
            self:SetTextColor(1, 1, 1, 1)
            self:SetScript('OnUpdate', OnUpdate)

        elseif button == 'RightButton' then
            self:SetBackdropColor(41/255, 43/255, 47/255, 1)
            self:SetBackdropBorderColor(255/255, 255/255, 255/255, 1)
            self:Enable()
        end
    end
end

local function OnEnter(self)
    if self.isEnabled() then
        self:SetTextColor(1, 1, 1, 1)
    end
end

local function OnLeave(self)
    if not self.dragging then
        self:SetTextColor(190/255, 190/255, 190/255, 255/255)
    end
end

local function OnMouseUp(self, button)
    if button == 'LeftButton' then
        self:SetScript('OnUpdate', nil)
        self:SetTextColor(190/255, 190/255, 190/255, 255/255)
        self.dragging = false
    end
end

local function OnEnterPressed(self)
    self:Disable()
    self:SetBackdropColor(41/255, 43/255, 47/255, 0)
    self:SetBackdropBorderColor(255/255, 255/255, 255/255, 0)
    local value = self:GetNumber()
    if value < self.lower then value = self.lower end
    if value > self.upper then value = self.upper end

    self:SetNumber(value)
    self.set(value)
    self.update()
end

function addon:CreateSlider(parent, text, lower, upper, get, set, update, enabled)
    local BoxSlider = CreateFrame("EditBox", nil, parent, "BackdropTemplate")
    BoxSlider:SetSize(70, 16)
    BoxSlider:SetAutoFocus(false)
    BoxSlider:SetNumber(get())
    BoxSlider:SetFontObject(KufOptionTitleValue)
    BoxSlider:SetTextColor(190/255, 190/255, 190/255, 255/255)
    BoxSlider:SetJustifyH('CENTER')
    BoxSlider:Disable()
    BoxSlider.lower = lower
    BoxSlider.upper = upper
    BoxSlider.dragging = false
    BoxSlider.get = get
    BoxSlider.set = set
    BoxSlider.update = update
    BoxSlider.isEnabled = enabled
    BoxSlider.type = 'slider'

    BoxSlider:SetBackdrop({
        bgFile = 'Interface/ChatFrame/ChatFrameBackground',
        edgeFile = 'Interface/ChatFrame/ChatFrameBackground',
        tile = true, edgeSize = 1, tileSize = 5,
    })
    BoxSlider:SetBackdropColor(41/255, 43/255, 47/255, 0)
    BoxSlider:SetBackdropBorderColor(255/255, 255/255, 255/255, 0)

    BoxSlider.header = BoxSlider:CreateFontString(nil, 'OVERLAY', 'KufOptionTitleText')
    BoxSlider.header:SetPoint('TOP', 0, 12)
    BoxSlider.header:SetText(text)
    BoxSlider.header:SetTextColor(255/255, 255/255, 255/255, 255/255)

    BoxSlider:SetScript('OnEnterPressed', OnEnterPressed)
    BoxSlider:SetScript('OnMouseDown', OnMouseDown)
    BoxSlider:SetScript('OnMouseUp', OnMouseUp)
    BoxSlider:SetScript('OnEnter', OnEnter)
    BoxSlider:SetScript('OnLeave', OnLeave)

    return BoxSlider
end