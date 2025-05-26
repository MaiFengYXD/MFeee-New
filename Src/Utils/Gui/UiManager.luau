local table_insert, table_find, task_spawn, string_format, string_match, tostring, tonumber, select, pcall
    = table.insert, table.find, task.spawn, string.format, string.match, tostring, tonumber, select, pcall

local UiManager = {}

local ExecutorSupport = wax.shared.ExecutorSupport
local FileHelper      = wax.shared.FileHelper
local Translations    = wax.shared.Translations
local EasingLibrary   = wax.shared.EasingLibrary

local GetTranslation  = Translations.GetTranslation
local FromTranslation = Translations.FromTranslation

local DoesntSupport = GetTranslation("Your executor doesn't support this feature ('%*' not working)")

local DefaultSoundID
local UpdateSettings

UiManager.shared = {
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
    UiActivated     = true,
    UiCorner        = 5,
    DPIScale        = 100,
    Skipped         = 0,
    NotifyVolume    = 200,
    EasingDuration  = 1
};do
    local HttpService = shared.HttpService
    local JSONDecode  = HttpService.JSONDecode
    local JSONEncode  = HttpService.JSONEncode

    local WriteFile = FileHelper.WriteFile

    local _Success, PreData = pcall(JSONEncode, HttpService, UiManager.shared)

    local SettingsJson = FileHelper:CheckFile("MFeee-New/ui.settings.json", _Success and PreData or "{}")
    local _, Data = xpcall(JSONDecode, function()
        return {}
    end, HttpService, SettingsJson)

    for Key, Value in Data do
        if UiManager.shared[Key] == nil then continue end
        UiManager.shared[Key] = Value
    end

    function UpdateSettings()
        local Success, NewData = pcall(JSONEncode, HttpService, UiManager.shared)
        if Success then WriteFile(FileHelper, "MFeee-New/ui.settings.json", NewData) end
    end

    UiManager.Library      = require("Library")
    UiManager.SaveManager  = require("SaveManager")
    UiManager.ThemeManager = require("ThemeManager")

    UiManager.Toggles = UiManager.Library.Toggles
    UiManager.Options = UiManager.Library.Options
    UiManager.Buttons = UiManager.Library.Buttons
    UiManager.Labels  = UiManager.Library.Labels

    UiManager.Library.ForceCheckbox = UiManager.shared.ForceCheckbox

    DefaultSoundID = UiManager.shared.NotifySound == "Obsidian" and 4590662766 or 4590657391
    UiManager.shared.NotifySoundId = UiManager.shared.NotifySoundId or DefaultSoundID
end

do
    local      Destroy, Instance_new
        = game.Destroy, Instance.new

    local Library = UiManager.Library
    local Notify  = Library.Notify

    local SoundService = shared.SoundService

    local function Alert()
        local Sound = Instance_new("Sound", SoundService);do
            Sound.SoundId = `rbxassetid://{UiManager.shared.NotifySoundId}`
            Sound.Volume  = UiManager.shared.NotifyVolume / 100
            Sound.PlayOnRemove = true
            Destroy(Sound)
        end
    end

    function UiManager:Notify(...)
        if UiManager.shared.DisableNotify then return end

        task_spawn(Alert)
        return Notify(Library, ...)
    end
end

function UiManager:CreateWindow()
    UiManager.Window = UiManager.Library:CreateWindow({
        Font  = Enum.Font.BuilderSans,
        Icon  = 77335290652571,
        Title = `MFeee~ New {wax.shared.Emoji}`,
        Footer = `{wax.shared.ScriptDisplay} | {wax.shared.ScriptVersion}`,
        Center = true,
        AutoShow = true,
        AlwaysOnTop  = UiManager.shared.AlwaysOnTop,
        CornerRadius = UiManager.shared.UiCorner,
        NotifySide   = UiManager.shared.NotifySide,
        ShowCustomCursor = UiManager.shared.CustomCursor
    })

    UiManager.Library.KeybindFrame.Visible = UiManager.shared.KeybindFrame

    return UiManager.Window, (function()
        UiManager.CreateWindow = function() end
        return nil
    end)()
end

function UiManager:CreateMainTab()
    local UniversalMISC = require("../Universal/MISC")

    --// Main Tab //
    UiManager.MainTab = UiManager.Window:AddTab(GetTranslation("Main"), "house")

    --// General Groupbox (Left)
    UiManager.MainTabGeneralGroup = UiManager.MainTab:AddLeftGroupbox(GetTranslation("General"))

    UiManager.MainTabGeneralGroup:AddToggle("AntiAFK", {
        Text = GetTranslation("Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        DisabledTooltip = string_format(DoesntSupport, "getconnections")
    })

    UiManager.MainTabGeneralGroup:AddToggle("AntiKick", {
        Text = GetTranslation("Anti Kick (Client)"),
        Disabled = not (ExecutorSupport.hookfunction and ExecutorSupport.hookmetamethod),
        DisabledTooltip = string_format(DoesntSupport, "hookfunction/hookmetamethod")
    })

    --// General Groupbox OnChanged
    UiManager.Toggles.AntiAFK :OnChanged(UniversalMISC.AntiAFK .Start)
    UiManager.Toggles.AntiKick:OnChanged(UniversalMISC.AntiKick.Start)

    --// Other Groupbox (Right)
    UiManager.MainTabOtherGroup = UiManager.MainTab:AddRightGroupbox(GetTranslation("Other"))

    do
        UiManager.ClickTimesLabel = UiManager.MainTabOtherGroup:AddLabel(string_format(GetTranslation("You clicked %d times"), UiManager.shared.Skipped))

        local SetText = UiManager.ClickTimesLabel.SetText
        local ClickMultiplier = 1

        UiManager.MainTabOtherGroup:AddButton(GetTranslation("Click Me!"), function()
            UiManager.shared.Skipped += ClickMultiplier
            SetText(UiManager.ClickTimesLabel, string_format(GetTranslation("You clicked %d times"), UiManager.shared.Skipped))
            UpdateSettings()
        end)

        UiManager.MainTabOtherGroup:AddInput("ClickMultiplier", {
            Text = GetTranslation("Click Multiplier"),
            Default = ClickMultiplier,
            Numeric = true,
            AllowEmpty = false
        });

        (UiManager.MainTabOtherGroup :: any):AddButton({
            Text = GetTranslation("Reset Clicks"),
            DoubleClick = true,
            Func = function()
                UiManager:Notify(string_format(GetTranslation("You lost %d clicks"), UiManager.shared.Skipped))
                UiManager.shared.Skipped = 0
                SetText(UiManager.ClickTimesLabel, string_format(GetTranslation("You clicked %d times"), UiManager.shared.Skipped))
                UpdateSettings()
            end
        })

        UiManager.Options.ClickMultiplier:OnChanged(function(Multiplier)
            ClickMultiplier = Multiplier
        end)
    end

    UiManager.MainTabOtherGroup:AddDivider()

    do
        local EasingModes = {}

        for Mode in EasingLibrary.EasingModes do
            table_insert(EasingModes, Mode)
        end

        UiManager.MainTabOtherGroup:AddDropdown("EasingMode", {
            Text   = GetTranslation("Easing Mode"),
            Values = EasingModes
        })

        UiManager.MainTabOtherGroup:AddDropdown("EasingDirection", {
            Text = GetTranslation("Easing Direction"),
            Values = {
                "In",
                "Out",
                "InOut"
            }
        })

        UiManager.MainTabOtherGroup:AddSlider("EasingDuration", {
            Text = GetTranslation("Easing Duration"),
            Min = 0.1,
            Max = 3,
            Rounding = 1
        })
    end

    --// Other Groupbox OnChanged
    UiManager.Options.EasingMode:OnChanged(function(Mode)
        EasingLibrary.EasingMode = Mode
    end)

    UiManager.Options.EasingDirection:OnChanged(function(Direction)
        EasingLibrary.EasingDirection = Direction
    end)

    UiManager.Options.EasingDuration:OnChanged(function(Duration)
        EasingLibrary.EasingDuration = Duration
    end)

    UiManager.Options.EasingMode:SetValue(UiManager.shared.EasingMode)
    UiManager.Options.EasingDirection:SetValue(UiManager.shared.EasingDirection)
    UiManager.Options.EasingDuration:SetValue(UiManager.shared.EasingDuration)

    return UiManager.MainTab
end

function UiManager:CreatePlayerTab()
    local UniversalPlayer = require("../Universal/Player")

    --// Player Tab //
    UiManager.PlayerTab = UiManager.Window:AddTab(GetTranslation("Player"), "user")

    --// Left Tab Box
    UiManager.PlayerLeftTabBox = UiManager.PlayerTab:AddLeftTabbox()

    --// Player Overrides Tab
    UiManager.PlayerLeftTabBoxOverridesTab = UiManager.PlayerLeftTabBox:AddTab(GetTranslation("Overrides"))

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

        UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("WalkSpeedOverride", {
            Text = GetTranslation("WalkSpeed Override")
        })

        UiManager.PlayerLeftTabBoxOverridesTab:AddSlider("WalkSpeed", {
            Text = GetTranslation("WalkSpeed"),
            Default = TempWalkSpeed,
            Min = 0,
            Max = 200,
            Suffix = TempWalkSpeed > 1 and "studs/s" or "stud/s",
            Compact = true,
            HideMax = true
        })

        UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("JumpHeightOverride", {
            Text = GetTranslation("JumpHeight Override")
        })

        UiManager.PlayerLeftTabBoxOverridesTab:AddSlider("JumpHeight", {
            Text = GetTranslation("JumpHeight"),
            Default = TempJumpHeight,
            Min = 0,
            Max = 100,
            Rounding = 1,
            Suffix = TempJumpHeight > 1 and "studs" or "stud",
            Compact = true,
            HideMax = true
        })

        UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("JumpPowerOverride", {
            Text = GetTranslation("JumpPower Override")
        });

        (UiManager.PlayerLeftTabBoxOverridesTab :: any):AddSlider("JumpPower", {
            Text = GetTranslation("JumpPower"),
            Default = TempJumpPower,
            Min = 0,
            Max = 700,
            Compact = true,
            HideMax = true
        })
    end

    UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("GravityOverride", {
        Text = GetTranslation("Gravity Override")
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddSlider("Gravity", {
        Text = GetTranslation("Gravity"),
        Default = math.floor(shared.Workspace.Gravity),
        Min = 0,
        Max = 1000,
        Suffix = shared.Workspace.Gravity > 1 and "studs/s²" or "stud/s²",
        Compact = true,
        HideMax = true
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddDivider()

    UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("NoAcceleration", {
        Text = GetTranslation("No Acceleration")
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("AntiVoidFall", {
        Text = GetTranslation("Anti Void Fall")
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddToggle("SpeedBoost", {
        Text = GetTranslation("Speed Boost")
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddSlider("BoostSpeed", {
        Text = GetTranslation("Boost Speed"),
        Default = UniversalPlayer.SpeedBoost.BoostSpeed,
        Min = 0,
        Max = 100,
        Suffix = UniversalPlayer.SpeedBoost.BoostSpeed > 1 and "studs/s" or "stud/s",
        Compact = true,
        HideMax = true
    })

    UiManager.PlayerLeftTabBoxOverridesTab:AddDivider()

    UiManager.PlayerLeftTabBoxOverridesTab
    :AddToggle("Noclip", {
        Text = GetTranslation("Noclip")
    })
    :AddKeyPicker("NoclipKeybind", {
        Text = GetTranslation("Noclip"),
        Default = "N",
        Mode = "Toggle",
        SyncToggleState = true
    })

    UiManager.PlayerLeftTabBoxOverridesTab
    :AddToggle("VehicleNoclip", {
        Text = GetTranslation("Vehicle Noclip")
    })
    :AddKeyPicker("VehicleNoclipKeybind", {
        Text = GetTranslation("Vehicle Noclip"),
        Default = "H",
        Mode = "Toggle",
        SyncToggleState = true
    })

    --// Player Groupbox OnChanged
    UiManager.Toggles.WalkSpeedOverride :OnChanged(UniversalPlayer.WalkSpeed.Override)
    UiManager.Toggles.JumpHeightOverride:OnChanged(UniversalPlayer.JumpHeight.Override)
    UiManager.Toggles.JumpPowerOverride :OnChanged(UniversalPlayer.JumpPower.Override)
    UiManager.Toggles.GravityOverride   :OnChanged(UniversalPlayer.Gravity.Override)

    UiManager.Toggles.NoAcceleration:OnChanged(UniversalPlayer.NoAcceleration.Override)
    UiManager.Toggles.AntiVoidFall  :OnChanged(UniversalPlayer.AntiVoidFall.Override)
    UiManager.Toggles.SpeedBoost    :OnChanged(UniversalPlayer.SpeedBoost.Override)

    UiManager.Toggles.Noclip       :OnChanged(UniversalPlayer.Noclip.CharacterNoclip)
    UiManager.Toggles.VehicleNoclip:OnChanged(UniversalPlayer.Noclip.VehicleNoclip)

    UiManager.Options.WalkSpeed :OnChanged(UniversalPlayer.WalkSpeed.SetValue)
    UiManager.Options.JumpHeight:OnChanged(UniversalPlayer.JumpHeight.SetValue)
    UiManager.Options.JumpPower :OnChanged(UniversalPlayer.JumpPower.SetValue)
    UiManager.Options.Gravity   :OnChanged(UniversalPlayer.Gravity.SetValue)

    UiManager.Options.BoostSpeed:OnChanged(function(BoostSpeed)
        UniversalPlayer.SpeedBoost.BoostSpeed = BoostSpeed
    end)

    --// Fly Groupbox (Right)
    return UiManager.PlayerTab
end

function UiManager:CreateUniversalTabs()
    --// MISC Tab //
    UiManager.MiscTab = UiManager.Window:AddTab(GetTranslation("Misc"), "boxes")

    --// Roblox Groupbox (Left)
    UiManager.MiscTabRobloxGroup = UiManager.MiscTab:AddLeftGroupbox("Roblox")

    do
        local StarterGui = shared.StarterGui
        local GetCore    = StarterGui.GetCore
        local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled

        local CoreGuiType: typeof(Enum.CoreGuiType) = Enum.CoreGuiType

        local Toggles = {}

        Toggles.EnableReset = UiManager.MiscTabRobloxGroup:AddToggle("EnableReset", {
            Text = GetTranslation("Enable Reset"),
            Default = GetCore(StarterGui, "ResetButtonCallback")
        })

        Toggles.EnablePlayerList = UiManager.MiscTabRobloxGroup:AddToggle("EnablePlayerList", {
            Text = GetTranslation("Enable Player List"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.PlayerList)
        })

        Toggles.EnableHealth = UiManager.MiscTabRobloxGroup:AddToggle("EnableHealth", {
            Text = GetTranslation("Enable Health Bar"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Health)
        })

        Toggles.EnableBackpack = UiManager.MiscTabRobloxGroup:AddToggle("EnableBackpack", {
            Text = GetTranslation("Enable Backpack"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Backpack)
        })

        Toggles.EnableChat = UiManager.MiscTabRobloxGroup:AddToggle("EnableChat", {
            Text = GetTranslation("Enable Chat"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.Chat)
        })

        Toggles.EnableEmotesMenu = UiManager.MiscTabRobloxGroup:AddToggle("EnableEmotesMenu", {
            Text = GetTranslation("Enable Emotes Menu"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.EmotesMenu)
        })

        Toggles.EnableSelfView = UiManager.MiscTabRobloxGroup:AddToggle("EnableSelfView", {
            Text = GetTranslation("Enable Self View"),
            Tooltip = GetTranslation("Avatar \"selfie\" (with facial capture enabled)"),
            Default = GetCoreGuiEnabled(StarterGui, CoreGuiType.SelfView)
        })

        UiManager.MiscTabRobloxGroup:AddDivider()

        UiManager.MiscTabRobloxGroup:AddToggle("DevConsoleVisible", {
            Text = GetTranslation("Dev Console Visible"),
            Default = GetCore(StarterGui, "DevConsoleVisible")
        })

        Toggles.AvatarContextMenu = UiManager.MiscTabRobloxGroup:AddToggle("AvatarContextMenu", {
            Text = GetTranslation("Avatar Context Menu"),
            Tooltip = GetTranslation("Left-clicking on a player's avatar will pop up a context menu, and stop you from moving\n(which players who enjoy Natural Disaster Survival should be very familiar with)"),
            Default = GetCore(StarterGui, "AvatarContextMenuEnabled")
        })

        --// Roblox Groupbox OnChanged/Connection
        local ChangedToggles = {}

        for Key, Toggle: any in Toggles do
            task_spawn(Toggle.OnChanged, Toggle, function()
                ChangedToggles[Key] = true
            end)
        end

        local SetCore = StarterGui.SetCore
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

        local DevConsoleVisible = UiManager.Toggles.DevConsoleVisible
        local SetValue = DevConsoleVisible.SetValue

        local function SetCoreGui(Type)
            local Key = `Enable{Type}`
            if not ChangedToggles[Key] then return end

            SetCoreGuiEnabled(StarterGui, (CoreGuiType :: any)[Type], UiManager.Toggles[Key].Value)
        end

        shared.Connect:GiveSignal("RobloxGuiLoop", shared.RunService.PreRender:Connect(function()
            if ChangedToggles.EnableReset       then SetCore(StarterGui, "ResetButtonCallback",      UiManager.Toggles.EnableReset.Value      ) end
            if ChangedToggles.AvatarContextMenu then SetCore(StarterGui, "AvatarContextMenuEnabled", UiManager.Toggles.AvatarContextMenu.Value) end

            SetCoreGui("PlayerList")
            SetCoreGui("Health")
            SetCoreGui("Backpack")
            SetCoreGui("Chat")
            SetCoreGui("EmotesMenu")
            SetCoreGui("SelfView")

            SetValue(DevConsoleVisible, GetCore(StarterGui, "DevConsoleVisible"))
        end))

        UiManager.Toggles.DevConsoleVisible:OnChanged(function(Enabled)
            SetCore(StarterGui, "DevConsoleVisible", Enabled)
        end)
    end

    --// Settings Tab //
    UiManager.SettingsTab = UiManager.Window:AddTab(GetTranslation("Settings"), "settings")

    --// Menu Groupbox (Left)
    UiManager.SettingsTabMenuGroup = UiManager.SettingsTab:AddLeftGroupbox(GetTranslation("Menu"))

    UiManager.SettingsTabMenuGroup:AddToggle("OpenKeybindMenu", {
        Text = GetTranslation("Open Keybind Menu")
    })

    UiManager.SettingsTabMenuGroup:AddToggle("ShowCustomCursor", {
        Text = GetTranslation("Show Custom Cursor")
    })

    UiManager.SettingsTabMenuGroup:AddToggle("ForceCheckbox", {
        Text = GetTranslation("Force Checkbox"),
        Default = UiManager.shared.ForceCheckbox
    })

    UiManager.SettingsTabMenuGroup
    :AddLabel(GetTranslation("Menu Keybind"))
    :AddKeyPicker("MenuKeybind", {
        Default = "RightControl",
        Mode = "Toggle",
        NoUI = true,
        IsMenuKeyPicker = true
    })

    UiManager.SettingsTabMenuGroup:AddDivider()

    UiManager.SettingsTabMenuGroup:AddButton({
        Text = GetTranslation("Unload"),
        DoubleClick = true,
        Func = wax.shared.OnUnload
    })

    --// Theme Groupbox
    UiManager.ThemeManager:ApplyToTab(UiManager.SettingsTab)

    --// Menu Groupbox OnChanged
    UiManager.Toggles.OpenKeybindMenu:OnChanged(function(Enabled)
        UiManager.shared.KeybindFrame = Enabled
        UiManager.Library.KeybindFrame.Visible = Enabled

        UpdateSettings()
    end)

    UiManager.Toggles.ShowCustomCursor:OnChanged(function(Enabled)
        UiManager.shared.CustomCursor = Enabled
        UiManager.Library.ShowCustomCursor = Enabled

        UpdateSettings()
    end)

    UiManager.Toggles.ForceCheckbox:OnChanged(function(Enabled)
        UiManager.shared.ForceCheckbox = Enabled
        UiManager.Library.ForceCheckbox = Enabled

        UpdateSettings()
    end)

    do
        local function CheckStupidMenuKeybind(Keybind)
            if Keybind ~= Enum.UserInputType.MouseButton1 then return end

            local Bindable = Instance.new("BindableFunction")
            function Bindable.OnInvoke(Choice)
                if Choice ~= "Yes" then return end

                UiManager.Library.RebindMenuKey(Enum.KeyCode.RightControl)

                UiManager.shared.ToggleKeybind1 = "KeyCode"
                UiManager.shared.ToggleKeybind2 = "RightControl"

                UiManager.Options.MenuKeybind:SetValue({"RightControl"})

                UpdateSettings()
            end

            shared.StarterGui:SetCore("SendNotification", {
                Title = GetTranslation("Need Recovery?"),
                Text  = GetTranslation("You set the menu keybind to MB1 which is not recommended. Do you want to recovery it to default?"),
                Duration = (1 / 0),
                Button1  = GetTranslation("Yes"),
                Button2  = GetTranslation("No"),
                Callback = Bindable
            })
        end

        UiManager.Options.MenuKeybind:OnChanged(function(Keybind)
            CheckStupidMenuKeybind(Keybind)
            UiManager.Library.RebindMenuKey(Keybind)

            Keybind = tostring(Keybind) :: any
            local Keybind1, Keybind2 = string_match(Keybind :: any, "Enum%.(.-)%.(.*)")
            if not (Keybind1 and Keybind2) then return end

            UiManager.shared.ToggleKeybind1 = Keybind1
            UiManager.shared.ToggleKeybind2 = Keybind2

            UpdateSettings()
        end)

        local Key

        local Bind1: string = UiManager.shared.ToggleKeybind1
        local Bind2: string = UiManager.shared.ToggleKeybind2

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
            Key = (Enum.KeyCode :: any)[Bind2] :: Enum.KeyCode
            Key = Key.Name
        end

        UiManager.Options.MenuKeybind:SetValue({Key})
        UiManager.Library.RebindMenuKey(Keybind)

        CheckStupidMenuKeybind(Keybind)
    end

    --// UI Groupbox (Right)
    UiManager.SettingsTabUiGroup = UiManager.SettingsTab:AddRightGroupbox(GetTranslation("UI"))

    UiManager.SettingsTabUiGroup:AddToggle("AlwaysOnTop", {
        Text = GetTranslation("Always On Top"),
        Disabled = not pcall(function()
            Instance.new("ScreenGui").OnTopOfCoreBlur = true
        end)
    });

    (UiManager.SettingsTabUiGroup :: any):AddToggle("UiActivated", {
        Text = GetTranslation("UI Activated")
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

        UiManager.SettingsTabUiGroup:AddDropdown("ChangeLanguage", {
            Text    = GetTranslation("Change Language"),
            Values  = NativeLanguage.Name,
            Default = wax.shared.AllowedLanguages[wax.shared.Language]
        })

        UiManager.Options.ChangeLanguage:OnChanged(function(Language)
            local Index = table_find(NativeLanguage.Name, Language)
            if not Index then return end

            local Tag = NativeLanguage.Tag[Index]
            WriteFile(FileHelper, "MFeee-New/Language.txt", Tag)

            UiManager:Notify(GetTranslation("Restart to Apply"))
        end)
    end

    UiManager.SettingsTabUiGroup:AddSlider("DPIScale", {
        Text = GetTranslation("DPI Scale"),
        Min = 50,
        Max = 200,
        Suffix = "%"
    })

    UiManager.SettingsTabUiGroup:AddSlider("UICorner", {
        Text = GetTranslation("UI Corner"),
        Tooltip = GetTranslation("Some elements require restarting to apply"),
        Min = 0,
        Max = 10,
        Suffix = "px"
    })

    UiManager.SettingsTabUiGroup:AddDivider();

    (UiManager.SettingsTabUiGroup :: any):AddToggle("DisableNotify", {
        Text = GetTranslation("Disable Notify"),
        Default = UiManager.shared.DisableNotify
    })

    UiManager.SettingsTabUiGroup:AddDropdown("NotifySide", {
        Text = GetTranslation("Notify Side"),
        Values = {
            GetTranslation("TopLeft"),
            GetTranslation("TopRight"),
            GetTranslation("BottomLeft"),
            GetTranslation("BottomRight")
        },
        Default = GetTranslation(UiManager.shared.NotifySide)
    })

    UiManager.SettingsTabUiGroup:AddDropdown("NotifySound", {
        Text = GetTranslation("Notify Sound"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = GetTranslation(UiManager.shared.NotifySound)
    })

    UiManager.SettingsTabUiGroup:AddInput("NotifySoundId", {
        Text = GetTranslation("Notify Sound ID"),
        Default = "",
        EmptyReset = "",
        Placeholder = tostring(DefaultSoundID),
        ClearTextOnFocus = false
    })

    UiManager.SettingsTabUiGroup:AddSlider("NotifyVolume", {
        Text = GetTranslation("Notify Volume"),
        Min = 0,
        Max = 1000,
        Suffix = "%"
    })

    do
        local TestNotify  = GetTranslation("Test Notify")
        local TestNotify2 = GetTranslation("This is a test notification")

        UiManager.SettingsTabUiGroup:AddButton(TestNotify, function()
            UiManager:Notify({
                Title = TestNotify,
                Description = TestNotify2
            })
        end)
    end

    --// Config Groupbox
    UiManager.SaveManager:BuildConfigSection(UiManager.SettingsTab)

    --// UI Groupbox OnChanged
    UiManager.Toggles.AlwaysOnTop:OnChanged(function(Enabled)
        UiManager.shared.AlwaysOnTop = Enabled
        UiManager.Library.ScreenGui.OnTopOfCoreBlur = Enabled

        UpdateSettings()
    end)

    UiManager.Toggles.UiActivated:OnChanged(function(Enabled)
        UiManager.shared.UiActivated = Enabled

        for _, Frame in UiManager.Library.WindowFrames do
            Frame.Active = Enabled
        end

        UpdateSettings()
    end)

    do
        shared.Connect:GiveSignal("DPIScaleHold", shared.UserInputService.InputEnded:Connect(function(InputObject: InputObject)
            if (
                InputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and
                InputObject.UserInputType ~= Enum.UserInputType.Touch
            ) then return end

            UiManager.Library:SetDPIScale(UiManager.shared.DPIScale)
        end))

        UiManager.Options.DPIScale:OnChanged(function(Scale)
            UiManager.shared.DPIScale = Scale
            UpdateSettings()
        end)

        UiManager.Library:SetDPIScale(UiManager.shared.DPIScale)
    end

    UiManager.Options.UICorner:OnChanged(function(Corner)
        UiManager.shared.UiCorner = Corner
        UiManager.Library.CornerRadius = Corner

        UpdateSettings()
    end)

    UiManager.Toggles.DisableNotify:OnChanged(function(Enabled)
        UiManager.shared.DisableNotify = Enabled
        UpdateSettings()
    end)

    UiManager.Options.NotifySide:OnChanged(function(Side)
        Side = FromTranslation(Translations, Side)
        if not Side then return end

        UiManager.shared.NotifySide = Side
        UiManager.Library:SetNotifySide(Side)
        UpdateSettings()
    end)

    UiManager.Options.NotifySound:OnChanged(function(Sound)
        UiManager.shared.NotifySoundId = Sound == "Obsidian" and 4590662766 or 4590657391
        UpdateSettings()
    end)

    UiManager.Options.NotifySoundId:OnChanged(function(SoundID)
        if SoundID == "" or type(select(2, pcall(tonumber, SoundID))) ~= "number" then return end

        UiManager.shared.NotifySoundId = SoundID
        UpdateSettings()
        task_spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {SoundID})
    end)

    UiManager.Options.NotifyVolume:OnChanged(function(Volume)
        UiManager.shared.NotifyVolume = Volume
        UpdateSettings()
    end)

    UiManager.Toggles.OpenKeybindMenu:SetValue(UiManager.shared.KeybindFrame)
    UiManager.Toggles.ShowCustomCursor:SetValue(UiManager.shared.CustomCursor)
    UiManager.Toggles.AlwaysOnTop:SetValue(UiManager.shared.AlwaysOnTop)
    UiManager.Toggles.UiActivated:SetValue(UiManager.shared.UiActivated)
    UiManager.Options.DPIScale:SetValue(UiManager.shared.DPIScale)
    UiManager.Options.UICorner:SetValue(UiManager.shared.UiCorner)
    UiManager.Options.NotifyVolume:SetValue(UiManager.shared.NotifyVolume)
    UiManager.Options.NotifySoundId:SetValue(UiManager.shared.NotifySoundId)

    --// Info Tab //
    UiManager.InfoTab = UiManager.Window:AddTab(GetTranslation("Info"), "info")

    --// Developers Groupbox (Left)
    UiManager.InfoTabDevelopersGroup = UiManager.InfoTab:AddLeftGroupbox(GetTranslation("Developers"))

    local function ApplyColor(Text: string | number, NoFrame: any | nil)
        return `{NoFrame and "" or "["}<font color="#1f6feb">{Text}</font>{NoFrame and "" or "]"}`
    end

    UiManager.InfoTabDevelopersGroup:AddLabel({
        Text = `{ApplyColor("MaiFengYXD")} {GetTranslation("Owner, developer")}`,
        DoesWrap = true
    })

    --// Credits Groupbox (Left)
    UiManager.InfoTabCreditsGroup = UiManager.InfoTab:AddLeftGroupbox(GetTranslation("Credits"))

    UiManager.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("upio")} {GetTranslation("Teaches me how to use wax")}`,
        DoesWrap = true
    })

    UiManager.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("mspaint")} {GetTranslation("Gives me inspiration")}`,
        DoesWrap = true
    })

    UiManager.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("GitHub Copilot")} {GetTranslation("Helps complete code")}`,
        DoesWrap = true
    })

    UiManager.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor("Google Gemini")} {GetTranslation("Helps translate")}`,
        DoesWrap = true
    })

    UiManager.InfoTabCreditsGroup:AddLabel({
        Text = `{ApplyColor(GetTranslation("And you!"))} {GetTranslation("For using my script!")}`,
        DoesWrap = true
    })

    --// Special Thanks Groupbox (Left)
    UiManager.InfoTabThanksGroup = UiManager.InfoTab:AddLeftGroupbox(GetTranslation("Special Thanks"))

    UiManager.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("latte-soft")} {GetTranslation("Wax bundler")}`,
        DoesWrap = true
    })

    UiManager.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("Exunys")} {GetTranslation("Aimbot Inspiration")}`,
        DoesWrap = true
    })

    UiManager.InfoTabThanksGroup:AddLabel({
        Text = `{ApplyColor("7GrandDadPGN")} {GetTranslation("SilentAim Inspiration")}`,
        DoesWrap = true
    })

    --// About Game Groupbox (Right)
    UiManager.InfoTabAboutGameGroup = UiManager.InfoTab:AddRightGroupbox(GetTranslation("About Game"))

    local PlayedLabel      = UiManager.InfoTabAboutGameGroup:AddLabel()
    local TimeRunningLabel = UiManager.InfoTabAboutGameGroup:AddLabel()
    local GameNameLabel    = (UiManager.InfoTabAboutGameGroup :: any):AddLabel("Game Name: grabbing...")

    --// About Game Group Update
    do
        local elapsedTime, task_wait
            = elapsedTime, task.wait

        local Workspace = shared.Workspace

        local function ConvertTime(Time: number): string
            Time = tonumber(Time) :: number

            local Hour   = string_format("%02d", Time / 3600)
            local Minute = string_format("%02d", (Time % 3600) / 60)
            local Second = string_format("%02d", Time % 60)

            return `{Hour}:{Minute}:{Second}`
        end

        local YouPlayed   = GetTranslation("You Played: %s")
        local TimeRunning = GetTranslation("Time Running: %s")

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
            GameNameLabel:SetText(string_format(GetTranslation("Game Name: %s"), `{ApplyColor(wax.shared.GameName, 1)}`))
        end)
    end

    do
        local toclipboard
            = toclipboard

        local PlaceId = tostring(game.PlaceId);

        (UiManager.InfoTabAboutGameGroup :: any):AddButton({
            Text = string_format(GetTranslation("Place Id: %s"), PlaceId),
            Func = function()
                toclipboard(PlaceId)
                UiManager:Notify(GetTranslation("Place Id Copied"))
            end
        })

        --// Links Groupbox (Right)
        UiManager.InfoTabLinksGroup = UiManager.InfoTab:AddRightGroupbox(GetTranslation("Links"));

        (UiManager.InfoTabLinksGroup :: any)
        :AddButton({
            Text = GetTranslation("Discord"),
            Func = function()
                toclipboard("https://discord.gg/YBQUd8X8PK")
                UiManager:Notify(GetTranslation("Discord Server Link Copied"))
            end
        })
        :AddButton({
            Text = GetTranslation("GitHub"),
            Func = function()
                toclipboard("https://github.com/MaiFengYXD")
                UiManager:Notify(GetTranslation("GitHub Link Copied"))
            end
        })
    end

    UiManager.InfoTabLinksGroup:AddDivider()

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
            "@fr:",
            "upio:",
            "upio:"
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
            "",
            "if no bypass is detected we detect one",
            "If no executor is detected, we default to a generic bypass"
        }

        for Index, Content in TipTitles do
            TipTitles[Index]   = GetTranslation(Content)
        end

        for Index, Content in TipContents do
            TipContents[Index] = GetTranslation(Content)
        end

        local function FormatTip(Title, Content)
            return `<u><b><i>{Title}</i></b></u>\n{Content}`
        end

        local AllTips = #TipTitles

        local CurrentIndex = Random:NextInteger(1, AllTips)
        local CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

        AllTips += 1

        table_insert(TipTitles  , GetTranslation("Funny trivia:"))
        table_insert(TipContents, string_format(GetTranslation("You had %f%% chance to roll this tip"), 1 / AllTips * 100))

        local Label = (UiManager.InfoTabLinksGroup :: any):AddLabel({
            Text = CurrentTip,
            DoesWrap = true
        })

        Label:BindClickEventListener(function()
            CurrentIndex = Random:NextInteger(1, AllTips)
            CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

            Label:SetText(CurrentTip)
        end)
    end

    return UiManager.MiscTab, UiManager.InfoTab
end

UiManager.SaveManager:SetLibrary  (UiManager.Library)
UiManager.SaveManager:SetFolder   ("MFeee-New")
UiManager.SaveManager:SetSubFolder(wax.shared.ScriptFolder)

UiManager.ThemeManager:SetLibrary (UiManager.Library)
UiManager.ThemeManager:SetFolder  ("MFeee-New")

wax.AddOnUnload(UiManager.Library.Unload, UiManager.Library)

return UiManager
