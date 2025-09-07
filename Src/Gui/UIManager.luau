--[[
    Imagine rewriting UIManager 🥀
--]]

--[[
    shared:
    ```luau
    {
        NotifySound     = "Obsidian",
        NotifySide      = "TopRight",
        EasingMode      = "Quartic",
        EasingDirection = "Out",
        ToggleKeybind1  = "KeyCode",
        ToggleKeybind2  = "RightControl",
        ForceCheckbox   = false,
        CustomCursor    = false,
        KeybindFrame    = false,
        AlwaysOnTop     = false,
        DisableNotify   = false,
        UIActivated     = true,
        UICorner        = 5,
        DPIScale        = 100,
        Skipped         = 0,
        NotifyVolume    = 200,
        EasingDuration  = 1
    }
    ```

    tips:
    ```luau
    local Random  = Random.new()

    local TipTitles = {
        "Did you know?",
        "Guess what?",
        "Loading...",
        "@upio:",
        "Do you know?",
        "Tip hunt:",
        "MOTD:",
        "Calculating:",
        "Did you know?",
        "Error:",
        "@fr:",
        "upio:",
        "upio:",
        ""
    }

    local TipContents = {
        "You can click on the notification to close it.",
        "You can actually bind any key to open the menu (even mouse buttons <s>although it's stupid fr</s>)",
        "Fetching new tips... (remaining 2147483647 years)",
        "when i skidded and pasted the most",
        "Click me to skip to the next tip",
        "Our tips are currently on vacation, please try again <s>never</s>later",
        "zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib z",
        "Determining the precise gravitational pull exerted by this tip on your mouse cursor... (requires planetary alignment)",
        "Are you reading this tip, or is this tip reading you?🤫🧏",
        "Failed to load tips: Server error, firefighters are putting out the fire on our server",
        "",
        "if no bypass is detected we detect one",
        "If no executor is detected, we default to a generic bypass",
        "<b>⚠️ YOUR SITE HAS BEN DDOS PLEASE SEND 20$ TO UNDDOS</b> :"
    }

    for Index, Content in TipTitles do
        TipTitles[Index]   = Translate(Content)
    end

    for Index, Content in TipContents do
        TipContents[Index] = Translate(Content)
    end

    local function FormatTip(Title, Content)
        return `<u><b><i>{Title}</i></b></u>\n{Content}`
    end

    local AllTips = #TipTitles

    local CurrentIndex = Random:NextInteger(1, AllTips)
    local CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

    AllTips += 1

    table_insert(TipTitles  , Translate("Funny trivia:"))
    table_insert(TipContents, string_format(Translate("You had %f%% chance to roll this tip"), 1 / AllTips * 100))
    ```
--]]

local pcall, table_find, string_find, string_format
    = pcall, table.find, string.find, string.format

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

UIManager.Settings = {
    NotificationSound   = "Obsidian", -- Obsidian: 4590662766, Linoria: 4590657391 (Their names are just arbitrary and unrelated to anything else with the same name)
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
};do
    local HttpService = shared.HttpService
    local JSONDecode  = HttpService.JSONDecode
    local JSONEncode  = HttpService.JSONEncode

    local WriteFile = FileHelper.WriteFile

    local PreData  = JSONEncode(HttpService, UIManager.Settings)
    local Settings = FileHelper:CheckFile("MFeee-New/ui.settings.json", PreData)

    local _, Data = xpcall(JSONDecode, function()
        return {}
    end, HttpService, Settings)

    for Key, Value in Data do
        if UIManager.Settings[Key] == nil then continue end
        UIManager.Settings[Key] = Value
    end

    function UpdateSetting(Key: string, Value: any)
        UIManager.Settings[Key] = Value

        local Success, NewData = pcall(JSONEncode, HttpService, UIManager.Settings)
        if Success then WriteFile(FileHelper, "MFeee-New/ui.settings.json", NewData) end
    end
end

local Library      = require("Library")
local SaveManager  = require("SaveManager")
local ThemeManager = require("ThemeManager")

UIManager.Library      = Library
UIManager.SaveManager  = SaveManager
UIManager.ThemeManager = ThemeManager

UIManager.Dropdowns = Library.Dropdowns
UIManager.Toggles   = Library.Toggles
UIManager.Buttons   = Library.Buttons
UIManager.Sliders   = Library.Sliders
UIManager.Inputs    = Library.Inputs
UIManager.Labels    = Library.Labels

UIManager.KeyPickers   = Library.KeyPickers
UIManager.ColorPickers = Library.ColorPickers

UIManager.Notify = Library.Notify

function UIManager:Init()
    local Window = self.Library:CreateWindow({
        Icon              = 77335290652571,
        Title             = "MFeee~ New",
        DPIScale          = self.Settings.DPIScale,
        NotificationSide  = self.Settings.NotificationSide,
        NotificationSound = self.Settings.NotificationSoundId,
        ShowCustomCursor  = self.Settings.CustomCursor,
        AlwaysOnTop       = self.Settings.AlwaysOnTop,
        UIActivated       = self.Settings.UIActivated,
        NoNotify          = self.Settings.NoNotify,
    })

    self.Window = Window
    self.Tabs   = Window.Tabs

    return (function(self: typeof(UIManager))
        function self.Init() end
        return Window
    end)(self)
end

function UIManager:AddMainTab(IgnoredElements: {string}, IgnoredTabs: {string})
    local UniversalMISC = require("../Universal/MISC")

    local function Create(Self: any, Method: string, Index: string, Data: (hash | string)?): any
        if Method == "AddTab" then
            if IgnoredTabs and table_find(IgnoredTabs, Index) then return end

            local Tab = Self[Method](Self, Index, Data)
            self.Tabs[Index] = Tab

            return Tab
        elseif IgnoredElements and table_find(IgnoredElements, Index) then
            return
        end

        local Element = Self[Method](Self, Index, Data)

        for _, ElementName in Elements do
            if not string_find(Method, ElementName) then continue end

            self[`{ElementName}s`][Index] = Element
            break
        end

        return Element
    end

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
    local function Create(Self: any, Method: string, Index: string, Data: (hash | string)?): any
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
            if not string_find(Method, ElementName) then continue end

            self[`{ElementName}s`][Index] = Element
            break
        end

        return Element
    end

    --// Settings Tab //
    local SettingsTab = Create(self.Window, "AddTab", "Settings", "settings")

end

return UIManager
