-- UIManager; aka Gui

local pcall, table_find, string_sub, string_format
    = pcall, table.find, string.sub, string.format

local UIManager = {}

local Elements = {
    "Dropdown",
    "Toggle",
    "Button",
    "Slider",
    "Input",
    "ColorPicker",
    "KeyPicker"
}

local ExecutorSupport = shared.ExecutorSupport
local EasingLibrary   = shared.EasingLibrary
local Translator      = shared.Translator
local FileHelper      = shared.FileHelper

local Translate = Translator.Translate
local Reverse   = Translator.Reverse

local DoesntSupport = Translate("Your executor doesn't support this feature (missing function '%*')")

local UpdateSetting: (Key: string, Value: any) -> ()

UIManager.Config = shared.ConfigManager.new("Gui", {
    NotificationSound   = "Obsidian", -- Obsidian: 4590662766, Linoria: 4590657391 (Their names are just casual and unrelated to anything else with the same name)
    NotificationSide    = "TopRight",
    EasingMode          = "Quartic",
    EasingDirection     = "Out",
    ToggleKeybind       = "RightShift",
    UseCheckbox         = false,
    CustomCursor        = false,
    KeybindFrame        = false,
    AlwaysOnTop         = false,
    NoNotify            = false,
    UIActivated         = true,
    DPIScale            = 1,
    NotificationVolume  = 2,
    EasingDuration      = 1,
    NotificationSoundId = 4590662766
}, "gui.config.json")

local Library      = require("@self/Library")
local SaveManager  = require("@self/SaveManager")
local ThemeManager = require("@self/ThemeManager")

UIManager.SaveManager  = SaveManager
UIManager.ThemeManager = ThemeManager

for _, ElementName in Elements do
    local Key = `{ElementName}s`
    UIManager[Key] = Library[Key]
end

UIManager.Notify = Library.Notify

function UIManager:Init()
    local Window = self.Library:CreateWindow({
        Icon              = 77335290652571,
        Title             = "MFeee~ New",
        DPIScale          = self.Config.DPIScale,
        NotificationSide  = self.Config.NotificationSide,
        NotificationSound = self.Config.NotificationSoundId,
        ShowCustomCursor  = self.Config.CustomCursor,
        AlwaysOnTop       = self.Config.AlwaysOnTop,
        UIActivated       = self.Config.UIActivated,
        NoNotify          = self.Config.NoNotify,
    })

    self.Window = Window
    self.Tabs   = Window.Tabs

    function self.Init() end
    return Window
end

local function Creating(IgnoredElements: {string}, IgnoredTabs: {string})
    local function Create(Self: any, Method: "AddTab" | string, Index: string, Data: (hash | string)?): any
        local self = UIManager
        if not self.Tabs then return end

        if Method == "AddTab" then
            if table_find(IgnoredTabs, Index) then return end

            local Tab = Self[Method](Self, Index, Data)
            self.Tabs[Index] = Tab

            return Tab
        elseif table_find(IgnoredElements, Index) then
            return
        end

        local Element = Self[Method](Self, Index, Data)

        for _, ElementName in Elements do
            if string_sub(Method, 1, 3) ~= ElementName then continue end

            self[`{ElementName}s`][Index] = Element
            break
        end

        return Element
    end

    return Create
end

function UIManager:AddMainTab(IgnoredElements: {string}, IgnoredTabs: {string})
    local UniversalMISC = require("../Universal/MISC")

    local Create = Creating(IgnoredElements, IgnoredTabs)

    --// Main Tab //
    local MainTab = Create(self.Window, "AddTab", Translate("Main"), "house")

    --// Common Groupbox
    local CommonGroupbox = Create(MainTab, "AddLeftGroupbox", Translate("Common"))

    local AntiAFKToggle = Create(CommonGroupbox, "AddToggle", "AntiAFK", {
        Text = Translate("Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        DisabledTooltip = string_format(DoesntSupport, "getconnections")
    })

    local AntiKickToggle = Create(CommonGroupbox, "AddToggle", "AntiKick", {
        Text = Translate("Anti Kick"),
        Disabled = not (ExecutorSupport.hookfunction or (ExecutorSupport.getnamecallmethod and ExecutorSupport.hookmetamethod)),
        DisabledTooltip = string_format(DoesntSupport, "hookfunction or (getnamecallmethod and hookmetamethod)")
    })

    local AntiLagToggle = Create(CommonGroupbox, "AddToggle", "AntiLag", {
        Text = Translate("Anti Lag")
    })

    --// :: TESTS :: //
    local TestDropdown1 = Create(CommonGroupbox, "AddDropdown", "TestDropdown1", {
        Text = Translate("Test Dropdown 1"),
        Values = {
            Translate("Option 1"),
            Translate("Option 2"),
            Translate("Option 3")
        },
        Default = Translate("Option 1")
    })

    local TestDropdown2 = Create(CommonGroupbox, "AddDropdown", "TestDropdown2", {
        Text = Translate("Test Dropdown 2"),
        Values = {
            Translate("Option 4"),
            Translate("Option 5"),
            Translate("Option 6")
        },
        Default = Translate("Option 4")
    })
end

function UIManager:AddUniversalTabs(IgnoredElements: {string}, IgnoredTabs: {string})
    local Create = Creating(IgnoredElements, IgnoredTabs)

    --// Config Tab //
    local SettingsTab = Create(self.Window, "AddTab", "Config", "settings")

end

return UIManager
