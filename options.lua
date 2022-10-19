local _, addon = ...
KasUnitFrames = LibStub("AceAddon-3.0"):NewAddon("KasUnitFrames", "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
    profile = {
        message = "Welcome Home!",
        showOnScreen = true,
    },
}

local Tabs = {
    {title = 'General', type = 'header', frame = nil},
    {title = 'General', type = 'button', frame = nil},
    {title = 'Colors', type = 'button', frame = nil},
    {title = 'Individual', type = 'header', frame = nil},
    {title = 'Player', type = 'button', frame = nil},
    {title = 'Target', type = 'button', frame = nil},
    {title = 'Focus', type = 'button', frame = nil},
    {title = 'Pet', type = 'button', frame = nil},
    {title = 'TargetTarget', type = 'button', frame = nil},
    {title = 'Group', type = 'header', frame = nil},
    {title = 'Party', type = 'button', frame = nil},
    {title = 'Raid Small', type = 'button', frame = nil},
    {title = 'Raid Large', type = 'button', frame = nil},
    {title = 'Boss', type = 'button', frame = nil},
}

local SelectedTab = 'General'

local function AddBorder(frame, level)
    local border = CreateFrame('FRAME', 'border', frame)
    border:SetFrameLevel(level)
    border:SetFrameStrata('LOW')
    border:SetWidth(frame:GetWidth() + 2)
    border:SetHeight(frame:GetHeight() + 2)
    border:SetPoint('CENTER', frame, 'CENTER')
    border.texture = border:CreateTexture(nil, LOW)
    border.texture:SetAllPoints(border)
    border.texture:SetColorTexture(0/255, 0/255, 0/255, 255/255)
end

local function CreateTabMenu(parent)
    local TabMenu = CreateFrame('FRAME', 'TabMenu', parent)
    TabMenu:SetFrameLevel(20)
    TabMenu:SetFrameStrata('LOW')
    TabMenu:SetWidth(120)
    TabMenu:SetHeight(460)
    TabMenu:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0)
    TabMenu.texture = TabMenu:CreateTexture(nil, 'LOW')
    TabMenu.texture:SetAllPoints(TabMenu)
    TabMenu.texture:SetColorTexture(32/255, 34/255, 37/255, 255/255)
    AddBorder(TabMenu, 15)

    TabMenu.logo = TabMenu:CreateTexture(nil, 'ARTWORK')
    TabMenu.logo:SetSize(64, 32)
    TabMenu.logo:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\logo')
    TabMenu.logo:SetPoint('TOPLEFT', TabMenu, 'TOPLEFT', 28, -5)

    TabMenu.divider = TabMenu:CreateTexture(nil, 'ARTWORK')
    TabMenu.divider:SetSize(120, 1)
    TabMenu.divider:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\BLACK8X8')
    TabMenu.divider:SetPoint('TOP', TabMenu.logo, 'BOTTOM', 0, -5)

    TabMenu.version = TabMenu:CreateFontString(TabMenu, 'OVERLAY', 'GameTooltipText')
    TabMenu.version:SetPoint('BOTTOM', 0, 2)
    TabMenu.version:SetText('Version: 0.1')
    TabMenu.version:SetTextColor(255/255, 255/255, 255/255, 30/255)

    return TabMenu
end

local function UpdateTabs()
    for tab in ipairs(Tabs) do
        if Tabs[tab].type == 'button' then
            if Tabs[tab].title == SelectedTab then
                Tabs[tab].frame.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
                Tabs[tab].frame.background:SetColorTexture(66/255, 70/255, 77/255, 255/255)
            else
                Tabs[tab].frame.text:SetTextColor(190/255, 190/255, 190/255, 255/255)
                Tabs[tab].frame.background:SetColorTexture(0/255, 0/255, 0/255, 0/255)
            end
        end
    end
end

local function CreateTabButton(parent, text, offset)
    local TabItem = CreateFrame('BUTTON', 'TabItem', parent)
    TabItem:SetFrameLevel(25)
    TabItem:SetFrameStrata('LOW')
    TabItem:SetWidth(120)
    TabItem:SetHeight(24)
    TabItem:SetPoint('TOP', parent, 'TOP', 0, offset)

    TabItem.background = TabItem:CreateTexture(nil, 'LOW')
    TabItem.background:SetWidth(110)
    TabItem.background:SetHeight(20)
    TabItem.background:SetAllPoints(TabItem)
    TabItem.background:SetColorTexture(0/255, 0/255, 0/255, 0/255)

    TabItem.text = TabItem:CreateFontString(TabItem, 'OVERLAY', 'GameTooltipText')
    TabItem.text:SetFont('Interface\\AddOns\\KasUnitFrames\\Media\\Font\\Inter-UI-Bold.ttf', 11, '')
    TabItem.text:SetPoint('LEFT', 10, 0)
    TabItem.text:SetText(text)
    TabItem.text:SetJustifyH('LEFT')
    TabItem.text:SetTextColor(190/255, 190/255, 190/255, 255/255)

    TabItem:SetScript('OnClick', function(self)
        SelectedTab = self.text:GetText()
        UpdateTabs()
    end)
    TabItem:SetScript('OnEnter', function(self)
        if SelectedTab ~= text then
            self.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
            self.background:SetColorTexture(60/255, 63/255, 69/255, 255/255)
        end
    end)
    TabItem:SetScript('OnLeave', function(self)
        if SelectedTab ~= text then
            self.text:SetTextColor(190/255, 190/255, 190/255, 255/255)
            self.background:SetColorTexture(0/255, 0/255, 0/255, 0/255)
        end
    end)

    return TabItem
end

local function CreateTabHeader(parent, text, offset)
    local TabHeader = CreateFrame('BUTTON', 'TabItem', parent)
    TabHeader:SetFrameLevel(25)
    TabHeader:SetFrameStrata('LOW')
    TabHeader:SetWidth(120)
    TabHeader:SetHeight(24)
    TabHeader:SetPoint('TOP', parent, 'TOP', 0, offset)

    TabHeader.text = TabHeader:CreateFontString(TabHeader, 'OVERLAY', 'GameTooltipText')
    TabHeader.text:SetFont('Interface\\AddOns\\KasUnitFrames\\Media\\Font\\Inter-UI-Bold.ttf', 14, '')
    TabHeader.text:SetPoint('LEFT', 5, 0)
    TabHeader.text:SetText(text)
    TabHeader.text:SetJustifyH('LEFT')
    TabHeader.text:SetTextColor(1, 1, 1, 1)

end

local function CreateMenu()
    local KufOptionsFrame = CreateFrame('FRAME', 'KufOptionsFrame', UIParent)
    KufOptionsFrame:SetFrameLevel(10)
    KufOptionsFrame:SetFrameStrata('LOW')
    KufOptionsFrame:SetHeight(460)
    KufOptionsFrame:SetWidth(650)
    KufOptionsFrame:SetPoint('CENTER', UIParent, 'CENTER')
    KufOptionsFrame:SetMovable(true)
    KufOptionsFrame:EnableMouse(true)
    KufOptionsFrame:RegisterForDrag('LeftButton')
    KufOptionsFrame:EnableKeyboard(true)
    KufOptionsFrame:SetPropagateKeyboardInput(true)
    KufOptionsFrame:SetClampedToScreen(true)
    KufOptionsFrame:Hide()

    KufOptionsFrame.background = KufOptionsFrame:CreateTexture(nil, 'LOW')
    KufOptionsFrame.background:SetAllPoints(KufOptionsFrame)
    KufOptionsFrame.background:SetColorTexture(47/255, 49/255, 54/255, 255/255)
    AddBorder(KufOptionsFrame, 5)

    KufOptionsFrame:SetScript('OnDragStart', function(self)
        self:StartMoving()
    end)

    KufOptionsFrame:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
    end)

    local TabMenu = CreateTabMenu(KufOptionsFrame)

    local offset = -43
    for tab in ipairs(Tabs) do
        local title = Tabs[tab].title
        --local offset = tab == 1 and -43 or (-19 + (tab * 24) * -1)

        if (Tabs[tab].type == 'button') then
            Tabs[tab].frame = CreateTabButton(TabMenu, title, offset)
            offset = offset - 24
        else
            CreateTabHeader(TabMenu, title, offset)
            offset = offset - 24
        end
    end
    UpdateTabs()

    local closeButton = CreateFrame('BUTTON', 'CloseButton', KufOptionsFrame)
    closeButton:SetNormalTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\baseline-close-24px@2x.tga')
    closeButton:SetSize(12, 12)
    closeButton:GetNormalTexture():SetVertexColor(255/255, 255/255, 255/255, 255/255)
    closeButton:SetScript('OnClick', function()
        KufOptionsFrame:Hide()
    end)
    closeButton:SetPoint('TOPRIGHT', KufOptionsFrame, 'TOPRIGHT', -5, -5)
    closeButton:SetScript('OnEnter', function(self)
        self:GetNormalTexture():SetVertexColor(230/255, 60/255, 0/255, 255/255)
    end)
    closeButton:SetScript('OnLeave', function(self)
        self:GetNormalTexture():SetVertexColor(255/255, 255/255, 255/255, 255/255)
    end)
end

function KasUnitFrames:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KufDB", defaults, true)
    self:RegisterChatCommand("kuf", "SlashCommand")
    CreateMenu()
end

function KasUnitFrames:OnEnable()
end

function KasUnitFrames:OnDisable()
end

function KasUnitFrames:SlashCommand(msg)
    if not msg or msg:trim() == "" then
        KufOptionsFrame:Show()
    end
end

