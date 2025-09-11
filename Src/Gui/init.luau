-- UIManager; aka Gui

local pcall, table_find, string_sub, string_format
    = pcall, table.find, string.sub, string.format

local UIManager = {}

local ElementTypes = {
    "Dropdown",
    "SortableList",
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

local DoesntSupport = Translate("Your executor doesn't support this feature\n(missing function %*)")

local UpdateSetting: (Key: string, Value: any) -> ()

-- UIManager.Config = shared.ConfigManager.new("Gui", {
--     NotificationSound   = "Obsidian", -- Obsidian: 4590662766, Linoria: 4590657391 (Their names are just casual and unrelated to anything else with the same name)
--     NotificationSide    = "TopRight",
--     EasingMode          = "Quartic",
--     EasingDirection     = "Out",
--     ToggleKeybind       = "RightShift",
--     UseCheckbox         = false,
--     CustomCursor        = false,
--     KeybindFrame        = false,
--     AlwaysOnTop         = false,
--     NoNotify            = false,
--     UIActivated         = true,
--     DPIScale            = 1,
--     NotificationVolume  = 2,
--     NotificationSoundId = 4590662766
-- }, "gui.config.json")

local Library      = require("@self/Library")
local SaveManager  = require("@self/SaveManager")
local ThemeManager = require("@self/ThemeManager")

UIManager.SaveManager  = SaveManager
UIManager.ThemeManager = ThemeManager
UIManager.Elements     = Library.Elements
UIManager.Notify       = Library.Notify

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

        for _, ElementType in ElementTypes do
            if string_sub(Method, 1, 3) ~= ElementType then continue end

            self.Elements[`{ElementType}s`][Index] = Element
            break
        end

        return Element
    end

    return Create
end

function UIManager:AddMainTab(IgnoredElements: {string}, IgnoredTabs: {string})
    local UniversalMISC = require("Universal/MISC")

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

local Window = UIManager.Library:CreateWindow({
    Icon  = 77335290652571,
    Title = "MFeee~ New"
})

UIManager.Window = Window
UIManager.Tabs   = Window.Tabs

return UIManager
