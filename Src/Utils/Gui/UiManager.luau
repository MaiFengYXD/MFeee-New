local table_insert, table_find, task_spawn, string_format, string_match, tostring, tonumber, select, pcall
    = table.insert, table.find, task.spawn, string.format, string.match, tostring, tonumber, select, pcall

local UiManager = {
    Library      = nil,
    ThemeManager = nil,
    SaveManager  = nil
}

local ExecutorSupport = wax.shared.ExecutorSupport
local FileHelper      = wax.shared.FileHelper
local Translations    = wax.shared.Translations
local EasingLibrary   = wax.shared.EasingLibrary

local GetTranslation  = Translations.GetTranslation
local FromTranslation = Translations.FromTranslation

local DoesntSupport = GetTranslation(Translations, "Your executor doesn't support this feature ('%s' not working)")

local DefaultSoundID
local UpdateSettings

UiManager.shared = {
    WindowStyle = "Obsidian",
    NotifySound = "Obsidian",
    NotifySide  = "TopRight",
    EasingMode  = "Quartic",
    EasingDirection = "Out",
    ToggleKeybind1  = "KeyCode",
    ToggleKeybind2  = "RightControl",
    ForceCheckbox = false,
    CustomCursor  = false,
    KeybindFrame  = false,
    AlwaysOnTop   = false,
    DisableNotify = false,
    UiActivated   = true,
    UiCorner = 5,
    DPIScale = 100,
    Skipped  = 0,
    NotifyVolume   = 200,
    NotifySoundId  = nil,
    EasingDuration = 1
};do
    local self = UiManager

    local HttpService = shared.HttpService
    local JSONDecode  = HttpService.JSONDecode
    local JSONEncode  = HttpService.JSONEncode

    local WriteFile = FileHelper.WriteFile

    local _Success, PreData = pcall(JSONEncode, HttpService, self.shared)

    local SettingsJson = FileHelper:CheckFile("MFeee-New/ui.settings.json", _Success and PreData or "{}")
    local _, Data = xpcall(JSONDecode, function()
        return {}
    end, HttpService, SettingsJson)

    for Key, Value in Data do
        if self.shared[Key] == nil then continue end
        self.shared[Key] = Value
    end

    function UpdateSettings()
        local Success, NewData = pcall(JSONEncode, HttpService, self.shared)
        if Success then WriteFile(FileHelper, "MFeee-New/ui.settings.json", NewData) end
    end

    self.Library      = require(`{self.shared.WindowStyle}/Library`)
    self.SaveManager  = require(`{self.shared.WindowStyle}/SaveManager`)
    self.ThemeManager = require(`{self.shared.WindowStyle}/ThemeManager`)

    self.Toggles = self.Library.Toggles
    self.Options = self.Library.Options
    self.Buttons = self.Library.Buttons
    self.Labels  = self.Library.Labels

    self.Library.ForceCheckbox = self.shared.ForceCheckbox

    DefaultSoundID     = self.shared.NotifySound == "Obsidian" and 4590662766 or 4590657391
    self.shared.NotifySoundId = self.shared.NotifySoundId or DefaultSoundID
end

do
    local      Destroy, Instance_new
        = game.Destroy, Instance.new

    local Library = UiManager.Library
    local Notify  = Library.Notify

    local SoundService = shared.SoundService

    local function Alert(self)
        local Sound = Instance_new("Sound", SoundService);do
            Sound.SoundId = `rbxassetid://{self.shared.NotifySoundId}`
            Sound.Volume  = self.shared.NotifyVolume / 100
            Sound.PlayOnRemove = true
            Destroy(Sound)
        end
    end

    function UiManager:Notify(...)
        if self.shared.DisableNotify then return end

        task_spawn(Alert, self)
        return Notify(Library, ...)
    end
end

function UiManager:CreateWindow()
    self.Window = self.Library:CreateWindow({
        Font  = Enum.Font.BuilderSans,
        Icon  = 77335290652571,
        Title = `MFeee~ New {wax.shared.Emoji}`,
        Footer = `{wax.shared.ScriptDisplay} | {wax.shared.ScriptVersion}`,
        Center = true,
        AutoShow = true,
        AlwaysOnTop  = self.shared.AlwaysOnTop,
        CornerRadius = self.shared.UiCorner,
        NotifySide   = self.shared.NotifySide,
        ShowCustomCursor = self.shared.CustomCursor
    })

    self.Library.KeybindFrame.Visible = self.shared.KeybindFrame

    return self.Window, (function()
        self.CreateWindow = function() end
        return nil
    end)()
end

function UiManager:CreateMainTab()
    local UniversalMISC = require("../Universal/MISC")

    --// Main Tab //
    self.MainTab = self.Window:AddTab(GetTranslation(Translations, "Main"), "house")

    --// General Groupbox (Left)
    self.MainTabGeneralGroup = self.MainTab:AddLeftGroupbox(GetTranslation(Translations, "General"))

    self.MainTabGeneralGroup:AddToggle("AntiAFK", {
        Text = GetTranslation(Translations, "Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        DisabledTooltip = string_format(DoesntSupport, "getconnections")
    })

    self.MainTabGeneralGroup:AddToggle("AntiKick", {
        Text = GetTranslation(Translations, "Anti Kick (Client)"),
        Disabled = not (ExecutorSupport.hookfunction and ExecutorSupport.hookmetamethod),
        DisabledTooltip = string_format(DoesntSupport, "hookfunction/hookmetamethod")
    })

    --// General Groupbox OnChanged
    self.Toggles.AntiAFK :OnChanged(UniversalMISC.AntiAFK .Start)
    self.Toggles.AntiKick:OnChanged(UniversalMISC.AntiKick.Start)

    --// Other Groupbox (Right)
    self.MainTabOtherGroup = self.MainTab:AddRightGroupbox(GetTranslation(Translations, "Other"))

    do
        self.ClickTimesLabel = self.MainTabOtherGroup:AddLabel(string_format(GetTranslation(Translations, "You clicked %d times"), self.shared.Skipped))

        local SetText = self.ClickTimesLabel.SetText
        local ClickMultiplier = 1

        self.MainTabOtherGroup:AddButton(GetTranslation(Translations, "Click Me!"), function()
            self.shared.Skipped += ClickMultiplier
            SetText(self.ClickTimesLabel, string_format(GetTranslation(Translations, "You clicked %d times"), self.shared.Skipped))
            UpdateSettings()
        end)

        self.MainTabOtherGroup:AddInput("ClickMultiplier", {
            Text = GetTranslation(Translations, "Click Multiplier"),
            Default = ClickMultiplier,
            Numeric = true,
            AllowEmpty = false
        })

        self.MainTabOtherGroup:AddButton({
            Text = GetTranslation(Translations, "Reset Clicks"),
            DoubleClick = true,
            Func = function()
                self:Notify(string_format(GetTranslation(Translations, "You lost %d clicks"), self.shared.Skipped))
                self.shared.Skipped = 0
                SetText(self.ClickTimesLabel, string_format(GetTranslation(Translations, "You clicked %d times"), self.shared.Skipped))
                UpdateSettings()
            end
        })

        self.Options.ClickMultiplier:OnChanged(function(Multiplier)
            ClickMultiplier = Multiplier
        end)
    end

    self.MainTabOtherGroup:AddDivider()

    do
        local EasingModes = {}

        for Mode in EasingLibrary.EasingModes do
            table_insert(EasingModes, Mode)
        end

        self.MainTabOtherGroup:AddDropdown("EasingMode", {
            Text   = GetTranslation(Translations, "Easing Mode"),
            Values = EasingModes
        })

        self.MainTabOtherGroup:AddDropdown("EasingDirection", {
            Text = GetTranslation(Translations, "Easing Direction"),
            Values = {
                "In",
                "Out",
                "InOut"
            }
        })

        self.MainTabOtherGroup:AddSlider("EasingDuration", {
            Text = GetTranslation(Translations, "Easing Duration"),
            Min = 0.1,
            Max = 3,
            Rounding = 1
        })
    end

    --// Other Groupbox OnChanged
    self.Options.EasingMode:OnChanged(function(Mode)
        EasingLibrary.EasingMode = Mode
    end)

    self.Options.EasingDirection:OnChanged(function(Direction)
        EasingLibrary.EasingDirection = Direction
    end)

    self.Options.EasingDuration:OnChanged(function(Duration)
        EasingLibrary.EasingDuration = Duration
    end)

    self.Options.EasingMode:SetValue(self.shared.EasingMode)
    self.Options.EasingDirection:SetValue(self.shared.EasingDirection)
    self.Options.EasingDuration:SetValue(self.shared.EasingDuration)

    return self.MainTab
end

function UiManager:CreatePlayerTab()
    local UniversalPlayer = require("../Universal/Player")

    --// Player Tab //
    self.PlayerTab = self.Window:AddTab(GetTranslation(Translations, "Player"), "user")

    --// Left Tab Box
    self.PlayerLeftTabBox = self.PlayerTab:AddLeftTabbox()

    --// Player Overrides Tab
    self.PlayerLeftTabBoxOverridesTab = self.PlayerLeftTabBox:AddTab(GetTranslation(Translations, "Overrides"))

    local function Round(Number: number | nil)
        return Number and math.round(Number * 10) / 10
    end

    do
        local TempCharacter = shared.Speaker.Character
        local TempHumanoid  = TempCharacter and TempCharacter:FindFirstChildOfClass("Humanoid") or {
            WalkSpeed  = "",
            JumpHeight = "",
            JumpPower  = ""
        }

        local TempWalkSpeed  = Round(tonumber(TempHumanoid.WalkSpeed))  or 16
        local TempJumpHeight = Round(tonumber(TempHumanoid.JumpHeight)) or 7.2
        local TempJumpPower  = Round(tonumber(TempHumanoid.JumpPower))  or 50

        self.PlayerLeftTabBoxOverridesTab:AddToggle("WalkSpeedOverride", {
            Text = GetTranslation(Translations, "WalkSpeed Override")
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("WalkSpeed", {
            Text = GetTranslation(Translations, "WalkSpeed"),
            Default = TempWalkSpeed,
            Min = 0,
            Max = 200,
            Suffix = TempWalkSpeed > 1 and "studs/s" or "stud/s",
            Compact = true,
            HideMax = true
        })

        self.PlayerLeftTabBoxOverridesTab:AddToggle("JumpHeightOverride", {
            Text = GetTranslation(Translations, "JumpHeight Override")
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("JumpHeight", {
            Text = GetTranslation(Translations, "JumpHeight"),
            Default = TempJumpHeight,
            Min = 0,
            Max = 100,
            Rounding = 1,
            Suffix = TempJumpHeight > 1 and "studs" or "stud",
            Compact = true,
            HideMax = true
        })

        self.PlayerLeftTabBoxOverridesTab:AddToggle("JumpPowerOverride", {
            Text = GetTranslation(Translations, "JumpPower Override")
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("JumpPower", {
            Text = GetTranslation(Translations, "JumpPower"),
            Default = TempJumpPower,
            Min = 0,
            Max = 700,
            Compact = true,
            HideMax = true
        })
    end

    self.PlayerLeftTabBoxOverridesTab:AddToggle("GravityOverride", {
        Text = GetTranslation(Translations, "Gravity Override")
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("Gravity", {
        Text = GetTranslation(Translations, "Gravity"),
        Default = math.floor(shared.Workspace.Gravity),
        Min = 0,
        Max = 1000,
        Suffix = shared.Workspace.Gravity > 1 and "studs/s²" or "stud/s²",
        Compact = true,
        HideMax = true
    })

    self.PlayerLeftTabBoxOverridesTab:AddDivider()

    self.PlayerLeftTabBoxOverridesTab:AddToggle("NoAcceleration", {
        Text = GetTranslation(Translations, "No Acceleration")
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("AntiVoidFall", {
        Text = GetTranslation(Translations, "Anti Void Fall")
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("SpeedBoost", {
        Text = GetTranslation(Translations, "Speed Boost")
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("BoostSpeed", {
        Text = GetTranslation(Translations, "Boost Speed"),
        Default = UniversalPlayer.SpeedBoost.BoostSpeed,
        Min = 0,
        Max = 100,
        Suffix = UniversalPlayer.SpeedBoost.BoostSpeed > 1 and "studs/s" or "stud/s",
        Compact = true,
        HideMax = true
    })

    self.PlayerLeftTabBoxOverridesTab:AddDivider()

    self.PlayerLeftTabBoxOverridesTab
    :AddToggle("Noclip", {
        Text = GetTranslation(Translations, "Noclip")
    })
    :AddKeyPicker("NoclipKeybind", {
        Text = GetTranslation(Translations, "Noclip"),
        Default = "N",
        Mode = "Toggle",
        SyncToggleState = true
    })

    self.PlayerLeftTabBoxOverridesTab
    :AddToggle("VehicleNoclip", {
        Text = GetTranslation(Translations, "Vehicle Noclip")
    })
    :AddKeyPicker("VehicleNoclipKeybind", {
        Text = GetTranslation(Translations, "Vehicle Noclip"),
        Default = "H",
        Mode = "Toggle",
        SyncToggleState = true
    })

    --// Player Groupbox OnChanged
    self.Toggles.WalkSpeedOverride :OnChanged(UniversalPlayer.WalkSpeed.Override)
    self.Toggles.JumpHeightOverride:OnChanged(UniversalPlayer.JumpHeight.Override)
    self.Toggles.JumpPowerOverride :OnChanged(UniversalPlayer.JumpPower.Override)
    self.Toggles.GravityOverride   :OnChanged(UniversalPlayer.Gravity.Override)

    self.Toggles.NoAcceleration:OnChanged(UniversalPlayer.NoAcceleration.Override)
    self.Toggles.AntiVoidFall  :OnChanged(UniversalPlayer.AntiVoidFall.Override)
    self.Toggles.SpeedBoost    :OnChanged(UniversalPlayer.SpeedBoost.Override)

    self.Toggles.Noclip       :OnChanged(UniversalPlayer.Noclip.CharacterNoclip)
    self.Toggles.VehicleNoclip:OnChanged(UniversalPlayer.Noclip.VehicleNoclip)

    self.Options.WalkSpeed :OnChanged(UniversalPlayer.WalkSpeed.SetValue)
    self.Options.JumpHeight:OnChanged(UniversalPlayer.JumpHeight.SetValue)
    self.Options.JumpPower :OnChanged(UniversalPlayer.JumpPower.SetValue)
    self.Options.Gravity   :OnChanged(UniversalPlayer.Gravity.SetValue)

    self.Options.BoostSpeed:OnChanged(function(BoostSpeed)
        UniversalPlayer.SpeedBoost.BoostSpeed = BoostSpeed
    end)

    --// Fly Groupbox (Right)
    return self.PlayerTab
end

function UiManager:CreateUniversalTabs()
    --// MISC Tab //
    self.MiscTab = self.Window:AddTab(GetTranslation(Translations, "Misc"), "boxes")

    --// Roblox Groupbox (Left)
    self.MiscTabRobloxGroup = self.MiscTab:AddLeftGroupbox("Roblox")

    do
        local StarterGui = shared.StarterGui
        local GetCore    = StarterGui.GetCore
        local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled

        local CoreGuiType: typeof(Enum.CoreGuiType) = Enum.CoreGuiType

        local Toggles = {}

        Toggles.EnableReset = self.MiscTabRobloxGroup:AddToggle("EnableReset", {
            Text = GetTranslation(Translations, "Enable Reset"),
            Default = GetCore(StarterGui, "ResetButtonCallback")
        })

        Toggles.EnablePlayerList = self.MiscTabRobloxGroup:AddToggle("EnablePlayerList", {
            Text = GetTranslation(Translations, "Enable Player List"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.PlayerList)
        })

        Toggles.EnableHealth = self.MiscTabRobloxGroup:AddToggle("EnableHealth", {
            Text = GetTranslation(Translations, "Enable Health Bar"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Health)
        })

        Toggles.EnableBackpack = self.MiscTabRobloxGroup:AddToggle("EnableBackpack", {
            Text = GetTranslation(Translations, "Enable Backpack"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Backpack)
        })

        Toggles.EnableChat = self.MiscTabRobloxGroup:AddToggle("EnableChat", {
            Text = GetTranslation(Translations, "Enable Chat"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Chat)
        })

        Toggles.EnableEmotesMenu = self.MiscTabRobloxGroup:AddToggle("EnableEmotesMenu", {
            Text = GetTranslation(Translations, "Enable Emotes Menu"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.EmotesMenu)
        })

        Toggles.EnableSelfView = self.MiscTabRobloxGroup:AddToggle("EnableSelfView", {
            Text = GetTranslation(Translations, "Enable Self View"),
            Tooltip = GetTranslation(Translations, "Avatar \"selfie\" (with facial capture enabled)"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.SelfView)
        })

        self.MiscTabRobloxGroup:AddDivider()

        self.MiscTabRobloxGroup:AddToggle("DevConsoleVisible", {
            Text = GetTranslation(Translations, "Dev Console Visible"),
            Default = GetCore(StarterGui, "DevConsoleVisible")
        })

        Toggles.AvatarContextMenu = self.MiscTabRobloxGroup:AddToggle("AvatarContextMenu", {
            Text = GetTranslation(Translations, "Avatar Context Menu"),
            Tooltip = GetTranslation(Translations, "Left-clicking on a player's avatar will pop up a context menu, and stop you from moving\n(which players who enjoy Natural Disaster Survival should be very familiar with)"),
            Default = GetCore(StarterGui, "AvatarContextMenuEnabled")
        })

        --// Roblox Groupbox OnChanged/Connection
        local ChangedToggles = {}

        for Key, Toggle in Toggles do
            task_spawn(Toggle.OnChanged, Toggle, function()
                ChangedToggles[Key] = true
            end)
        end

        local SetCore = StarterGui.SetCore
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

        local DevConsoleVisible = self.Toggles.DevConsoleVisible
        local SetValue = DevConsoleVisible.SetValue

        local function SetCoreGui(Type)
            local Key = `Enable{Type}`
            if not ChangedToggles[Key] then return end

            SetCoreGuiEnabled(StarterGui, CoreGuiType[Type], self.Toggles[Key].Value)
        end

        shared.Connect:GiveSignal("RobloxGuiLoop", shared.RunService.PreRender:Connect(function()
            if ChangedToggles.EnableReset       then SetCore(StarterGui, "ResetButtonCallback",      self.Toggles.EnableReset.Value      ) end
            if ChangedToggles.AvatarContextMenu then SetCore(StarterGui, "AvatarContextMenuEnabled", self.Toggles.AvatarContextMenu.Value) end

            SetCoreGui("PlayerList")
            SetCoreGui("Health")
            SetCoreGui("Backpack")
            SetCoreGui("Chat")
            SetCoreGui("EmotesMenu")
            SetCoreGui("SelfView")

            SetValue(DevConsoleVisible, GetCore(StarterGui, "DevConsoleVisible"))
        end))

        self.Toggles.DevConsoleVisible:OnChanged(function(Enabled)
            SetCore(StarterGui, "DevConsoleVisible", Enabled)
        end)
    end

    --// Settings Tab //
    self.SettingsTab = self.Window:AddTab(GetTranslation(Translations, "Settings"), "settings")

    --// Menu Groupbox (Left)
    self.SettingsTabMenuGroup = self.SettingsTab:AddLeftGroupbox(GetTranslation(Translations, "Menu"))

    self.SettingsTabMenuGroup:AddToggle("OpenKeybindMenu", {
        Text = GetTranslation(Translations, "Open Keybind Menu")
    })

    self.SettingsTabMenuGroup:AddToggle("ShowCustomCursor", {
        Text = GetTranslation(Translations, "Show Custom Cursor")
    })

    self.SettingsTabMenuGroup:AddToggle("ForceCheckbox", {
        Text = GetTranslation(Translations, "Force Checkbox"),
        Default = self.shared.ForceCheckbox
    })

    self.SettingsTabMenuGroup
    :AddLabel(GetTranslation(Translations, "Menu Keybind"))
    :AddKeyPicker("MenuKeybind", {
        Default = "RightControl",
        Mode = "Toggle",
        NoUI = true,
        IsMenuKeyPicker = true
    })

    self.SettingsTabMenuGroup:AddDivider()

    self.SettingsTabMenuGroup:AddButton({
        Text = GetTranslation(Translations, "Unload"),
        DoubleClick = true,
        Func = wax.shared.OnUnload
    })

    --// Theme Groupbox
    self.ThemeManager:ApplyToTab(self.SettingsTab)

    --// Menu Groupbox OnChanged
    self.Toggles.OpenKeybindMenu:OnChanged(function(Enabled)
        self.shared.KeybindFrame = Enabled
        self.Library.KeybindFrame.Visible = Enabled

        UpdateSettings()
    end)

    self.Toggles.ShowCustomCursor:OnChanged(function(Enabled)
        self.shared.CustomCursor = Enabled
        self.Library.ShowCustomCursor = Enabled

        UpdateSettings()
    end)

    self.Toggles.ForceCheckbox:OnChanged(function(Enabled)
        self.shared.ForceCheckbox = Enabled
        self.Library.ForceCheckbox = Enabled

        UpdateSettings()
    end)

    do
        local function CheckStupidMenuKeybind(Keybind)
            if Keybind ~= Enum.UserInputType.MouseButton1 then return end

            local Bindable = Instance.new("BindableFunction")
            function Bindable.OnInvoke(Choice)
                if Choice ~= "Yes" then return end

                self.Library.RebindMenuKey(Enum.KeyCode.RightControl)

                self.shared.ToggleKeybind1 = "KeyCode"
                self.shared.ToggleKeybind2 = "RightControl"

                self.Options.MenuKeybind:SetValue({"RightControl"})

                UpdateSettings()
            end

            shared.StarterGui:SetCore("SendNotification", {
                Title = GetTranslation(Translations, "Need Recovery?"),
                Text  = GetTranslation(Translations, "You set the menu keybind to MB1 which is not recommended. Do you want to recovery it to default?"),
                Duration = (1 / 0),
                Button1  = GetTranslation(Translations, "Yes"),
                Button2  = GetTranslation(Translations, "No"),
                Callback = Bindable
            })
        end

        self.Options.MenuKeybind:OnChanged(function(Keybind)
            CheckStupidMenuKeybind(Keybind)
            self.Library.RebindMenuKey(Keybind)

            Keybind = tostring(Keybind)
            local Keybind1, Keybind2 = string_match(Keybind, "Enum%.(.-)%.(.*)")
            if not (Keybind1 and Keybind2) then return end

            self.shared.ToggleKeybind1 = Keybind1
            self.shared.ToggleKeybind2 = Keybind2

            UpdateSettings()
        end)

        local Key

        local Bind1: string = self.shared.ToggleKeybind1
        local Bind2: string = self.shared.ToggleKeybind2

        local Keybind = Enum[Bind1][Bind2]

        if Bind1 == "UserInputType" then
            Key = GetTranslation(
                Translations,
                Bind2 == "MouseButton1" and "MB1" or
                Bind2 == "MouseButton2" and "MB2" or
                Bind2 == "MouseButton3" and "MB3" or
                Bind2
            )
        else
            Key = Enum.KeyCode[Bind2] :: Enum.KeyCode
            Key = Key.Name
        end

        self.Options.MenuKeybind:SetValue({Key})
        self.Library.RebindMenuKey(Keybind)

        CheckStupidMenuKeybind(Keybind)
    end

    --// UI Groupbox (Right)
    self.SettingsTabUiGroup = self.SettingsTab:AddRightGroupbox(GetTranslation(Translations, "UI"))

    self.SettingsTabUiGroup:AddToggle("AlwaysOnTop", {
        Text = GetTranslation(Translations, "Always On Top"),
        Disabled = not pcall(function()
            Instance.new("ScreenGui").OnTopOfCoreBlur = true
        end)
    })

    self.SettingsTabUiGroup:AddToggle("UiActivated", {
        Text = GetTranslation(Translations, "UI Activated")
    })

    do
        local NativeLanguage = {
            Tag  = {},
            Name = {}
        }

        local WriteFile = FileHelper.WriteFile

        for Tag, Name in wax.shared.AllowedLanguages do
            table_insert(NativeLanguage.Tag , Tag)
            table_insert(NativeLanguage.Name, Name)
        end

        self.SettingsTabUiGroup:AddDropdown("ChangeLanguage", {
            Text    = GetTranslation(Translations, "Change Language"),
            Values  = NativeLanguage.Name,
            Default = wax.shared.AllowedLanguages[wax.shared.Language]
        })

        self.Options.ChangeLanguage:OnChanged(function(Language)
            local Index = table_find(NativeLanguage.Name, Language)
            if not Index then return end

            local Tag = NativeLanguage.Tag[Index]
            WriteFile(FileHelper, "MFeee-New/Language.txt", Tag)

            self:Notify(GetTranslation(Translations, "Restart to Apply"))
        end)
    end

    self.SettingsTabUiGroup:AddDropdown("WindowStyle", {
        Text = GetTranslation(Translations, "Window Style"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = GetTranslation(Translations, self.shared.WindowStyle)
    })

    self.SettingsTabUiGroup:AddSlider("DPIScale", {
        Text = GetTranslation(Translations, "DPI Scale"),
        Min = 50,
        Max = 200,
        Suffix = "%"
    })

    self.SettingsTabUiGroup:AddSlider("UICorner", {
        Text = GetTranslation(Translations, "UI Corner"),
        Tooltip = GetTranslation(Translations, "Some elements require restarting to apply"),
        Min = 0,
        Max = 10,
        Suffix = "px"
    })

    self.SettingsTabUiGroup:AddDivider()

    self.SettingsTabUiGroup:AddToggle("DisableNotify", {
        Text = GetTranslation(Translations, "Disable Notify"),
        Default = self.shared.DisableNotify
    })

    self.SettingsTabUiGroup:AddDropdown("NotifySide", {
        Text = GetTranslation(Translations, "Notify Side"),
        Values = {
            GetTranslation(Translations, "TopLeft"),
            GetTranslation(Translations, "TopRight"),
            GetTranslation(Translations, "BottomLeft"),
            GetTranslation(Translations, "BottomRight")
        },
        Default = GetTranslation(Translations, self.shared.NotifySide)
    })

    self.SettingsTabUiGroup:AddDropdown("NotifySound", {
        Text = GetTranslation(Translations, "Notify Sound"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = GetTranslation(Translations, self.shared.NotifySound)
    })

    self.SettingsTabUiGroup:AddInput("NotifySoundId", {
        Text = GetTranslation(Translations, "Notify Sound ID"),
        Default = "",
        EmptyReset = "",
        Placeholder = tostring(DefaultSoundID),
        ClearTextOnFocus = false
    })

    self.SettingsTabUiGroup:AddSlider("NotifyVolume", {
        Text = GetTranslation(Translations, "Notify Volume"),
        Min = 0,
        Max = 1000,
        Suffix = "%"
    })

    do
        local TestNotify  = GetTranslation(Translations, "Test Notify")
        local TestNotify2 = GetTranslation(Translations, "This is a test notification")

        self.SettingsTabUiGroup:AddButton(TestNotify, function()
            self:Notify({
                Title = TestNotify,
                Description = TestNotify2
            })
        end)
    end

    --// Config Groupbox
    self.SaveManager:BuildConfigSection(self.SettingsTab)

    --// UI Groupbox OnChanged
    self.Toggles.AlwaysOnTop:OnChanged(function(Enabled)
        self.shared.AlwaysOnTop = Enabled
        self.Library.ScreenGui.OnTopOfCoreBlur = Enabled

        UpdateSettings()
    end)

    self.Toggles.UiActivated:OnChanged(function(Enabled)
        self.shared.UiActivated = Enabled

        for _, Frame: Frame in self.Library.WindowFrames do
            Frame.Active = Enabled
        end

        UpdateSettings()
    end)

    self.Options.WindowStyle:OnChanged(function(Style)
        self.shared.WindowStyle = Style
        self:Notify(GetTranslation(Translations, "Restart to Apply"))
        UpdateSettings()
    end)

    do
        shared.Connect:GiveSignal("DPIScaleHold", shared.UserInputService.InputEnded:Connect(function(InputObject: InputObject)
            if (
                InputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and
                InputObject.UserInputType ~= Enum.UserInputType.Touch
            ) then return end

            self.Library:SetDPIScale(self.shared.DPIScale)
        end))

        self.Options.DPIScale:OnChanged(function(Scale)
            self.shared.DPIScale = Scale
            UpdateSettings()
        end)

        self.Library:SetDPIScale(self.shared.DPIScale)
    end

    self.Options.UICorner:OnChanged(function(Corner)
        self.shared.UiCorner = Corner
        self.Library.CornerRadius = Corner

        UpdateSettings()
    end)

    self.Toggles.DisableNotify:OnChanged(function(Enabled)
        self.shared.DisableNotify = Enabled
        UpdateSettings()
    end)

    self.Options.NotifySide:OnChanged(function(Side)
        Side = FromTranslation(Translations, Side)
        if not Side then return end

        self.shared.NotifySide = Side
        self.Library:SetNotifySide(Side)
        UpdateSettings()
    end)

    self.Options.NotifySound:OnChanged(function(Sound)
        self.shared.NotifySoundId = Sound == "Obsidian" and 4590662766 or 4590657391
        UpdateSettings()
    end)

    self.Options.NotifySoundId:OnChanged(function(SoundID)
        if SoundID == "" or type(select(2, pcall(tonumber, SoundID))) ~= "number" then return end

        self.shared.NotifySoundId = SoundID
        UpdateSettings()
        task_spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {SoundID})
    end)

    self.Options.NotifyVolume:OnChanged(function(Volume)
        self.shared.NotifyVolume = Volume
        UpdateSettings()
    end)

    self.Toggles.OpenKeybindMenu:SetValue(self.shared.KeybindFrame)
    self.Toggles.ShowCustomCursor:SetValue(self.shared.CustomCursor)
    self.Toggles.AlwaysOnTop:SetValue(self.shared.AlwaysOnTop)
    self.Toggles.UiActivated:SetValue(self.shared.UiActivated)
    self.Options.DPIScale:SetValue(self.shared.DPIScale)
    self.Options.UICorner:SetValue(self.shared.UiCorner)
    self.Options.NotifyVolume:SetValue(self.shared.NotifyVolume)
    self.Options.NotifySoundId:SetValue(self.shared.NotifySoundId)

    --// Info Tab //
    self.InfoTab = self.Window:AddTab(GetTranslation(Translations, "Info"), "info")

    --// Developers Groupbox (Left)
    self.InfoTabDevelopersGroup = self.InfoTab:AddLeftGroupbox(GetTranslation(Translations, "Developers"))

    local function ApplyColor(Text: string | number, NoFrame: any | nil)
        return `{NoFrame and "" or "["}<font color="#1f6feb">{Text}</font>{NoFrame and "" or "]"}`
    end

    self.InfoTabDevelopersGroup:AddLabel({
        Text = `{ApplyColor("MaiFengYXD")} {GetTranslation(Translations, "Owner, developer")}`,
        DoesWrap = true
    })

    --// Credits Groupbox (Left)
    self.InfoTabCreditsGroup = self.InfoTab:AddLeftGroupbox(GetTranslation(Translations, "Credits"))

    self.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("upio")} {GetTranslation(Translations, "Teaches me how to use wax")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("mspaint")} {GetTranslation(Translations, "Gives me inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("GitHub Copilot")} {GetTranslation(Translations, "Helps complete code")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("Google Gemini")} {GetTranslation(Translations, "Helps translate")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor(GetTranslation(Translations, "And you!"))} {GetTranslation(Translations, "For using my script!")}`,
        DoesWrap = true
    })

    --// Special Thanks Groupbox (Left)
    self.InfoTabThanksGroup = self.InfoTab:AddLeftGroupbox(GetTranslation(Translations, "Special Thanks"))

    self.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("latte-soft")} {GetTranslation(Translations, "Wax bundler")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("deividcomsono")} {GetTranslation(Translations, "Obsidian UI")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("mstudio45")} {GetTranslation(Translations, "Linoria UI and ESP")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("Exunys")} {GetTranslation(Translations, "Aimbot Inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("7GrandDadPGN")} {GetTranslation(Translations, "SilentAim Inspiration")}`,
        DoesWrap = true
    })

    --// About Game Groupbox (Right)
    self.InfoTabAboutGameGroup = self.InfoTab:AddRightGroupbox(GetTranslation(Translations, "About Game"))

    local PlayedLabel      = self.InfoTabAboutGameGroup:AddLabel()
    local TimeRunningLabel = self.InfoTabAboutGameGroup:AddLabel()
    local GameNameLabel    = self.InfoTabAboutGameGroup:AddLabel("Game Name: grabbing...")

    --// About Game Group Update
    do
        local elapsedTime, task_wait
            = elapsedTime, task.wait

        local Workspace = shared.Workspace

        local function ConvertTime(Time: number): string
            Time = tonumber(Time)

            local Hour   = string_format("%02d", Time / 3600)
            local Minute = string_format("%02d", (Time % 3600) / 60)
            local Second = string_format("%02d", Time % 60)

            return `{Hour}:{Minute}:{Second}`
        end

        local YouPlayed   = GetTranslation(Translations, "You Played: %s")
        local TimeRunning = GetTranslation(Translations, "Time Running: %s")

        shared.Connect:RunThread("YouPlayedLabel"  , coroutine.create(function()
            repeat
                local Time = ConvertTime(Workspace.DistributedGameTime)
                PlayedLabel:SetText(string_format(YouPlayed, Time))
            until not task_wait(1)
        end))

        shared.Connect:RunThread("TimeRunningLabel", coroutine.create(function()
            repeat
                local Time = ConvertTime(elapsedTime())
                TimeRunningLabel:SetText(string_format(TimeRunning, Time))
            until not task_wait(1)
        end))

        task_spawn(function()
            repeat task_wait() until wax.shared.GameName
            GameNameLabel:SetText(string_format(GetTranslation(Translations, "Game Name: %s"), `{ApplyColor(wax.shared.GameName, 1)}`))
        end)
    end

    do
        local toclipboard
            = toclipboard

        local PlaceId = tostring(game.PlaceId)

        self.InfoTabAboutGameGroup:AddButton({
            Text = string_format(GetTranslation(Translations, "Place Id: %s"), PlaceId),
            Func = function()
                toclipboard(PlaceId)
                self:Notify(GetTranslation(Translations, "Place Id Copied"))
            end
        })

        --// Links Groupbox (Right)
        self.InfoTabLinksGroup = self.InfoTab:AddRightGroupbox(GetTranslation(Translations, "Links"))

        self.InfoTabLinksGroup
        :AddButton({
            Text = GetTranslation(Translations, "Discord"),
            Func = function()
                toclipboard("https://discord.gg/YBQUd8X8PK")
                self:Notify(GetTranslation(Translations, "Discord Server Link Copied"))
            end
        })
        :AddButton({
            Text = GetTranslation(Translations, "GitHub"),
            Func = function()
                toclipboard("https://github.com/MaiFengYXD")
                self:Notify(GetTranslation(Translations, "GitHub Link Copied"))
            end
        })
    end

    self.InfoTabLinksGroup:AddDivider()

    do
        local Random  = Random.new()

        local TipTitles = {
            "Did you know?",
            "Guess what?",
            "Loading...",
            "The Ascent Begins:",
            "Do you know?",
            "Tip hunt:",
            "MOTD:",
            "Calculating:",
            "Did you know?",
            "Error:",
            "@fr:"
        }

        local TipContents = {
            "You can click on the notification to close it.",
            "You can actually bind any key to open the menu (even mouse buttons <s>although it's stupid fr</s>)",
            "Fetching new tips... (remaining 2147483647 years)",
            "With a groan like tortured stone, the black iron gate yielded. The warrior, known only as Kael, stepped into the echoing darkness of the Maw. The air was thick with the smell of damp earth and ancient dust. Eyes adjusted slowly, revealing twisted tunnels leading into the deep. From the shadows, a low growl erupted. Goblins, small and vicious, swarmed forward, crude blades glinting. Kael met them head-on, his axe a blur of steel. Parrying, striking, the clang of metal on metal filled the confined space. He felt a blade bite his arm, a sharp pain that fueled his fury. He learned their patterns, the way they feinted left before thrusting right. He moved faster, anticipating their blows, his defense hardening. Finally, the last goblin fell, leaving only the sound of his own ragged breath and the dripping water. Wiping sweat and blood from his brow, Kael felt a new strength settle in his bones. His movements felt more fluid, his senses sharper. The trial had left its mark, physically and... somewhere deeper. But the path ahead plunged further into the mountain's core, and from the depths, a deeper, more ominous rumble echoed. His journey had just begun.\n<i>to be continued...</i>",
            "Click me to skip to the next tip",
            "Our tips are currently on vacation, please try again <s>never</s>later",
            "zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib z",
            "Determining the precise gravitational pull exerted by this tip on your mouse cursor... (requires planetary alignment)",
            "Are you reading this tip, or is this tip reading you?🤫🧏",
            "Failed to load tips: Server error, firefighters are putting out the fire on our server",
            ""
        }

        for Index, Content in TipTitles do
            TipTitles[Index]   = GetTranslation(Translations, Content)
        end

        for Index, Content in TipContents do
            TipContents[Index] = GetTranslation(Translations, Content)
        end

        local function FormatTip(Title, Content)
            return `<u><b><i>{Title}</i></b></u>\n{Content}`
        end

        local AllTips = #TipTitles

        local CurrentIndex = Random:NextInteger(1, AllTips)
        local CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

        AllTips += 1

        table_insert(TipTitles  , GetTranslation(Translations, "A trivia:"))
        table_insert(TipContents, string_format(GetTranslation(Translations, "You had %f%% chance to roll this tip"), 1 / AllTips * 100))

        local Label = self.InfoTabLinksGroup:AddLabel({
            Text = CurrentTip,
            DoesWrap = true
        })

        Label:BindClickEventListener(function()
            CurrentIndex = Random:NextInteger(1, AllTips)
            CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

            Label:SetText(CurrentTip)
        end)
    end

    return self.MiscTab, self.InfoTab
end

UiManager.SaveManager:SetLibrary  (UiManager.Library)
UiManager.SaveManager:SetFolder   ("MFeee-New")
UiManager.SaveManager:SetSubFolder(wax.shared.ScriptFolder)

UiManager.ThemeManager:SetLibrary (UiManager.Library)
UiManager.ThemeManager:SetFolder  ("MFeee-New")

wax.AddOnUnload(UiManager.Library.Unload, UiManager.Library)

return UiManager
