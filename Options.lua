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
        colors = {
            gradient = true,
            classes = {
                useSharedFG = false,
                useSharedBG = true,
                solid = {
                    shared = {
                        fg = {
                            r = 220,
                            g = 220,
                            b = 220,
                            a = 100
                        },
                        bg = {
                            r = 0,
                            g = 0,
                            b = 0,
                            a = 60
                        }
                    },
                    deathknight = {
                        r = 196,
                        g = 30,
                        b = 58,
                        a = 100
                    },
                    demonhunter = {
                        r = 163,
                        g = 48,
                        b = 201,
                        a = 100
                    },
                    druid = {
                        r = 255,
                        g = 124,
                        b = 10,
                        a = 100
                    },
                    evoker = {
                        r = 51,
                        g = 147,
                        b = 127,
                        a = 100
                    },
                    hunter = {
                        r = 170,
                        g = 211,
                        b = 114,
                        a = 100
                    },
                    mage = {
                        r = 63,
                        g = 199,
                        b = 235,
                        a = 100
                    },
                    monk = {
                        r = 0,
                        g = 255,
                        b = 152,
                        a = 100
                    },
                    paladin = {
                        r = 244,
                        g = 140,
                        b = 186,
                        a = 100
                    },
                    priest = {
                        r = 255,
                        g = 255,
                        b = 255,
                        a = 100
                    },
                    rogue = {
                        r = 255,
                        g = 244,
                        b = 104,
                        a = 100
                    },
                    shaman = {
                        r = 0,
                        g = 112,
                        b = 221,
                        a = 100
                    },
                    warlock = {
                        r = 135,
                        g = 136,
                        b = 238,
                        a = 100
                    },
                    warrior = {
                        r = 198,
                        g = 155,
                        b = 109,
                        a = 100
                    },
                },
                gradient = {

                }
            }
        },
        player = {
            enabled = true,
            size = {
                x = -500,
                y = -400,
                width = 230,
                height = 40,
            },
            power = {
                enabled = true,
                height = 8,
            }
        },
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
    border.texture = border:CreateTexture(nil, 'ARTWORK')
    border.texture:SetAllPoints(border)
    border.texture:SetColorTexture(0/255, 0/255, 0/255, 255/255)
end

function KasUnitFrames:CreateTabMenu(parent)
    local TabMenu = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
    TabMenu:SetFrameLevel(20)
    TabMenu:SetFrameStrata('LOW')
    TabMenu:SetWidth(120)

    TabMenu:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8",
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    TabMenu:SetBackdropColor(32/255, 34/255, 37/255, 255/255)
    TabMenu:SetBackdropBorderColor(0, 0, 0)

    TabMenu.logo = TabMenu:CreateFontString(nil, 'OVERLAY', 'KufLogo')
    TabMenu.logo:SetPoint('TOP', 0, -7)
    TabMenu.logo:SetTextColor(1, 1, 1, 1)
    TabMenu.logo:SetText('KUF')

    TabMenu.divider = TabMenu:CreateTexture(nil, 'ARTWORK', nil, 3)
    TabMenu.divider:SetSize(120, 1)
    TabMenu.divider:SetTexture('Interface\\AddOns\\KasUnitFrames\\Media\\Texture\\BLACK8X8')
    TabMenu.divider:SetPoint('TOP', TabMenu.logo, 'BOTTOM', 0, -5)

    TabMenu.version = TabMenu:CreateFontString(nil, 'OVERLAY', 'KufVersionText')
    TabMenu.version:SetPoint('BOTTOM', 0, 2)
    TabMenu.version:SetText('Version: 0.1')
    TabMenu.version:SetTextColor(255/255, 255/255, 255/255, 90/255)

    return TabMenu
end

function KasUnitFrames:GenerateOptionMenus(parent)
    for tab in ipairs(tabs) do
        if tabs[tab].type == 'button' then
            if tabs[tab].title == 'General' then
                tabs[tab].menuFrame = addon.CreateGeneralOptionsFrame(parent)
            elseif tabs[tab].title == 'Colors' then
                tabs[tab].menuFrame = addon.CreateColorOptionsFrame(parent)
            elseif tabs[tab].title == 'Player' then
                tabs[tab].menuFrame = addon.CreatePlayerOptionsFrame(parent)
            elseif tabs[tab].title == 'Target' then
                tabs[tab].menuFrame = addon.CreateTargetOptionsFrame(parent)
            elseif tabs[tab].title == 'Profiles' then
                tabs[tab].menuFrame = addon.CreateProfileOptionsFrame(parent, self.profilesFrame)
            else
                local testframe = CreateFrame('Frame', 'testframe', parent)
                testframe:SetFrameLevel(30)
                testframe:SetFrameStrata('LOW')
                testframe:SetHeight(460)
                testframe:SetWidth(599)
                testframe:SetPoint('TOPRIGHT', parent, 'TOPRIGHT')
                testframe.texture = testframe:CreateTexture(nil, 'ARTWORK')
                testframe.texture:SetAllPoints(testframe)
                testframe.texture:SetColorTexture(35/255, 255/255, 37/255, 100/255)
                testframe.text = testframe:CreateFontString(nil, 'OVERLAY', 'KufHeaderText')
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
    TabItem:SetWidth(118)
    TabItem:SetHeight(24)
    TabItem:SetPoint('TOP', parent, 'TOP', 0, offset)

    TabItem.background = TabItem:CreateTexture(nil, 'ARTWORK')
    TabItem.background:SetWidth(110)
    TabItem.background:SetHeight(20)
    TabItem.background:SetAllPoints(TabItem)
    TabItem.background:SetColorTexture(0/255, 0/255, 0/255, 0/255)

    TabItem.text = TabItem:CreateFontString(nil, 'OVERLAY', 'KufButtonText')
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

    TabHeader.text = TabHeader:CreateFontString(nil, 'OVERLAY', 'KufHeaderText')
    TabHeader.text:SetPoint('LEFT', 5, 0)
    TabHeader.text:SetText(text)
    TabHeader.text:SetJustifyH('LEFT')
    TabHeader.text:SetTextColor(1, 1, 1, 1)
end

function KasUnitFrames:CreateMenu()
    local KufOptionsFrame = CreateFrame('Frame', 'KufOptionsFrame', UIParent, "BackdropTemplate")
    KufOptionsFrame:SetSize(720, 460)
    KufOptionsFrame:SetResizeBounds(600, 450, 1300, 800)
    KufOptionsFrame:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8",
        edgeFile="Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    KufOptionsFrame:SetFrameStrata('LOW')
    KufOptionsFrame:SetFrameLevel(10)
    KufOptionsFrame:SetBackdropColor(47/255, 49/255, 54/255, 255/255)
    KufOptionsFrame:SetBackdropBorderColor(0, 0, 0)
    KufOptionsFrame:SetPoint('CENTER', UIParent, 'CENTER')
    KufOptionsFrame:RegisterForDrag('LeftButton')
    KufOptionsFrame:SetMovable(true)
    KufOptionsFrame:SetResizable(true)
    KufOptionsFrame:EnableMouse(true)
    KufOptionsFrame:EnableKeyboard(true)
    KufOptionsFrame:SetClampedToScreen(true)
    KufOptionsFrame:SetPropagateKeyboardInput(true)
    KufOptionsFrame:Hide()
    tinsert(UISpecialFrames, "KufOptionsFrame")

    KufOptionsFrame:SetScript('OnDragStart', function(self)
        self:StartMoving()
    end)

    KufOptionsFrame:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
    end)

    local TabMenu = KasUnitFrames:CreateTabMenu(KufOptionsFrame)
    TabMenu:SetPoint('TOPRIGHT', KufOptionsFrame, 'TOPLEFT', 1, 0)
    TabMenu:SetPoint('BOTTOMRIGHT', KufOptionsFrame, 'BOTTOMLEFT', 1, 0)

    resize = CreateFrame("Button", nil, KufOptionsFrame)
    resize:EnableMouse("true")
    resize:SetPoint("BOTTOMRIGHT")
    resize:SetSize(16,16)
    resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resize:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resize:SetScript("OnMouseDown", function(self)
        self:GetParent():StartSizing("BOTTOMRIGHT")
        print(self:GetParent():GetHeight())
    end)
    resize:SetScript("OnMouseUp", function(self)
        self:GetParent():StopMovingOrSizing("BOTTOMRIGHT")
    end)

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
    --addon:UpdateColorPickerFrame()
    addon:EnhanceColorPicker()
end

function KasUnitFrames:OnInitialize()
    addon.defaults = defaults
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
