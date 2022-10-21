local _, addon = ...
KasUnitFrames = LibStub("AceAddon-3.0"):NewAddon("KasUnitFrames", "AceConsole-3.0", "AceEvent-3.0")

local profileOptions = {
    name = "Kas Unit Frames",
    handler = KasUnitFrames,
    type = "group",
    args = {
        btn = {
            type = "execute",
            name = "Open KUF Options",
            func = function()
                if InterfaceOptionsFrame then
                    InterfaceOptionsFrame:Hide()
                end
                HideUIPanel(GameMenuFrame)
                KasUnitFrames:OpenOptions()
            end
        },
    },
}

local defaults = {
    profile = {
        general = {
            enabled = true
        },
        player = {
            enabled = true
        }
    },
}

local tabs = {
    {title = 'General', type = 'header', buttonFrame = nil},
    {title = 'General', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Colors', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Individual', type = 'header', buttonFrame = nil},
    {title = 'Player', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Target', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Focus', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Pet', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'TargetTarget', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Group', type = 'header', buttonFrame = nil},
    {title = 'Party', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Raid Small', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Raid Large', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Boss', type = 'button', buttonFrame = nil, menuFrame = nil},
    {title = 'Profiles', type = 'header', buttonFrame = nil},
    {title = 'Profiles', type = 'button', buttonFrame = nil, menuFrame = nil},
}

local SelectedTab = 'General'

function KasUnitFrames:AddBorder(frame, level)
    local border = CreateFrame('Frame', 'border', frame)
    border:SetFrameLevel(level)
    border:SetFrameStrata('LOW')
    border:SetWidth(frame:GetWidth() + 2)
    border:SetHeight(frame:GetHeight() + 2)
    border:SetPoint('CENTER', frame, 'CENTER')
    border.texture = border:CreateTexture(nil, LOW)
    border.texture:SetAllPoints(border)
    border.texture:SetColorTexture(0/255, 0/255, 0/255, 255/255)
end

function KasUnitFrames:CreateTabMenu(parent)
    local TabMenu = CreateFrame('Frame', 'TabMenu', parent)
    TabMenu:SetFrameLevel(20)
    TabMenu:SetFrameStrata('LOW')
    TabMenu:SetWidth(120)
    TabMenu:SetHeight(460)
    TabMenu:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0)
    KasUnitFrames:AddBorder(TabMenu, 15)

    TabMenu.texture = TabMenu:CreateTexture(nil, 'ARTWORK', nil, 1)
    TabMenu.texture:SetAllPoints(TabMenu)
    TabMenu.texture:SetColorTexture(32/255, 34/255, 37/255, 255/255)

    TabMenu.logo = TabMenu:CreateTexture(nil, 'ARTWORK', nil, 2)
    TabMenu.logo:SetSize(64, 32)
    TabMenu.logo:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\logo')
    TabMenu.logo:SetPoint('TOPLEFT', TabMenu, 'TOPLEFT', 28, -5)

    TabMenu.divider = TabMenu:CreateTexture(nil, 'ARTWORK', nil, 3)
    TabMenu.divider:SetSize(120, 1)
    TabMenu.divider:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\BLACK8X8')
    TabMenu.divider:SetPoint('TOP', TabMenu.logo, 'BOTTOM', 0, -5)

    TabMenu.version = TabMenu:CreateFontString(TabMenu, 'OVERLAY', 'GameTooltipText')
    TabMenu.version:SetPoint('BOTTOM', 0, 2)
    TabMenu.version:SetText('Version: 0.1')
    TabMenu.version:SetTextColor(255/255, 255/255, 255/255, 30/255)

    return TabMenu
end

function KasUnitFrames:GenerateOptionMenus(parent)
    for tab in ipairs(tabs) do
        if tabs[tab].type == 'button' then
            if tabs[tab].title == 'General' then
                tabs[tab].menuFrame = addon.CreateGeneralOptionsFrame(parent)
            elseif tabs[tab].title == 'Player' then
                tabs[tab].menuFrame = addon.CreatePlayerOptionsFrame(parent)
            elseif tabs[tab].title == 'Profiles' then
                tabs[tab].menuFrame = addon.CreateProfileOptionsFrame(parent, self.profilesFrame)
            else
                local testframe = CreateFrame('Frame', 'testframe', parent)
                testframe:SetFrameLevel(30)
                testframe:SetFrameStrata('LOW')
                testframe:SetHeight(460)
                testframe:SetWidth(599)
                testframe:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
                testframe.texture = testframe:CreateTexture(nil, 'LOW')
                testframe.texture:SetAllPoints(testframe)
                testframe.texture:SetColorTexture(35/255, 255/255, 37/255, 100/255)
                testframe.text = testframe:CreateFontString(testframe, 'OVERLAY', 'GameTooltipText')
                testframe.text:SetFont('Interface\\AddOns\\KasUnitFrames\\Media\\Font\\Inter-UI-Bold.ttf', 16, '')
                testframe.text:SetPoint('CENTER')
                testframe.text:SetText('NOT YET IMPLEMENTED')
                testframe.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
                testframe:Hide()

                tabs[tab].menuFrame = testframe
            end
        end
    end
end

function KasUnitFrames:UpdateTabs()
    for tab in ipairs(tabs) do
        if tabs[tab].type == 'button' then
            if tabs[tab].title == SelectedTab then
                tabs[tab].buttonFrame.text:SetTextColor(255/255, 255/255, 255/255, 255/255)
                tabs[tab].buttonFrame.background:SetColorTexture(66/255, 70/255, 77/255, 255/255)
                tabs[tab].menuFrame:Show()
            else
                tabs[tab].buttonFrame.text:SetTextColor(190/255, 190/255, 190/255, 255/255)
                tabs[tab].buttonFrame.background:SetColorTexture(0/255, 0/255, 0/255, 0/255)
                tabs[tab].menuFrame:Hide()
            end
        end
    end
end

function KasUnitFrames:CreateTabButton(parent, text, offset)
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
        KasUnitFrames:UpdateTabs()
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

function KasUnitFrames:CreateTabHeader(parent, text, offset)
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

function KasUnitFrames:CreateMenu()
    local KufOptionsFrame = CreateFrame('Frame', 'KufOptionsFrame', UIParent)
    KufOptionsFrame:SetFrameLevel(10)
    KufOptionsFrame:SetFrameStrata('LOW')
    KufOptionsFrame:SetHeight(460)
    KufOptionsFrame:SetWidth(720)
    KufOptionsFrame:SetPoint('CENTER', UIParent, 'CENTER')
    KufOptionsFrame:SetMovable(true)
    KufOptionsFrame:EnableMouse(true)
    KufOptionsFrame:RegisterForDrag('LeftButton')
    KufOptionsFrame:EnableKeyboard(true)
    KufOptionsFrame:SetPropagateKeyboardInput(true)
    KufOptionsFrame:SetClampedToScreen(true)
    KufOptionsFrame:Hide()

    tinsert(UISpecialFrames, "KufOptionsFrame")

    KufOptionsFrame.background = KufOptionsFrame:CreateTexture(nil, 'LOW')
    KufOptionsFrame.background:SetAllPoints(KufOptionsFrame)
    KufOptionsFrame.background:SetColorTexture(47/255, 49/255, 54/255, 255/255)
    KasUnitFrames:AddBorder(KufOptionsFrame, 5)

    KufOptionsFrame:SetScript('OnDragStart', function(self)
        self:StartMoving()
    end)

    KufOptionsFrame:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
    end)

    local TabMenu = KasUnitFrames:CreateTabMenu(KufOptionsFrame)

    local offset = -43
    for tab in ipairs(tabs) do
        local title = tabs[tab].title

        if (tabs[tab].type == 'button') then
            tabs[tab].buttonFrame = KasUnitFrames:CreateTabButton(TabMenu, title, offset)
            offset = offset - 24
        else
            KasUnitFrames:CreateTabHeader(TabMenu, title, offset)
            offset = offset - 24
        end
    end
    KasUnitFrames:GenerateOptionMenus(KufOptionsFrame)
    KasUnitFrames:UpdateTabs()

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

function KasUnitFrames:InitializeOptionSettings()
    addon.UpdateGeneralOptions()
    addon.UpdatePlayerOptions()
end

function KasUnitFrames:OnInitialize()
    addon.db = LibStub("AceDB-3.0"):New("KufDB", defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("KasUnitFrames_Options", profileOptions)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("KasUnitFrames_Options", "KasUnitFrames")


    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("KasUnitFrames_Profiles", profiles)
    self.profilesFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("KasUnitFrames_Profiles", "Profiles", "KasUnitFrames")

    self:RegisterChatCommand("kuf", "SlashCommand")

    addon.db.RegisterCallback(self, "OnProfileChanged", function()
        KasUnitFrames:InitializeOptionSettings()
    end)

    KasUnitFrames:CreateMenu()
end

function KasUnitFrames:OnEnable()
end

function KasUnitFrames:OnDisable()
end

function KasUnitFrames:SlashCommand(msg)
    if not msg or msg:trim() == "" then
        KasUnitFrames:OpenOptions()
    end
end

function KasUnitFrames:OpenOptions()
    KufOptionsFrame:Show()
    KasUnitFrames:InitializeOptionSettings()
end
