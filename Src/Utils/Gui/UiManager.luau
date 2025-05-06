local table_insert, table_find, task_spawn, string_format, tostring, tonumber, select, pcall
    = table.insert, table.find, task.spawn, string.format, tostring, tonumber, select, pcall

local UiManager = {}

local ExecutorSupport = wax.shared.ExecutorSupport
local FileHelper      = wax.shared.FileHelper
local Translations    = wax.shared.Translations
local EasingLibrary   = wax.shared.EasingLibrary

local WindowStyle   = FileHelper:CheckFile("MFeee~New/WindowStyle.txt"  , "Obsidian" , {"Obsidian", "Linoria"})
local NotifySound   = FileHelper:CheckFile("MFeee~New/NotifySound.txt"  , WindowStyle, {"Obsidian", "Linoria"})
local NotifySide    = FileHelper:CheckFile("MFeee~New/NotifySide.txt"   , "TopRight" , {"TopLeft" , "TopRight", "BottomLeft", "BottomRight"})
local ForceCheckbox = FileHelper:CheckFile("MFeee~New/ForceCheckbox.txt", "false", {"false", "true"}) == "true"
local CustomCursor  = FileHelper:CheckFile("MFeee~New/CustomCursor.txt" , "false", {"false", "true"}) == "true"
local KeybindFrame  = FileHelper:CheckFile("MFeee~New/KeybindFrame.txt" , "false", {"false", "true"}) == "true"
local AlwaysOnTop   = FileHelper:CheckFile("MFeee~New/AlwaysOnTop.txt"  , "false", {"false", "true"}) == "true"
local UiCorner      = FileHelper:CheckFile("MFeee~New/UICorner.txt", 5, 5)
local DPIScale      = FileHelper:CheckFile("MFeee~New/DPIScale.txt", 1, 1)
local Clicked       = FileHelper:CheckFile("MFeee~New/Clicked.txt" , 0, 0)

UiManager.Library      = require(`{WindowStyle}/Library`)
UiManager.SaveManager  = require(`{WindowStyle}/SaveManager`)
UiManager.ThemeManager = require(`{WindowStyle}/ThemeManager`)

UiManager.Toggles = UiManager.Library.Toggles
UiManager.Options = UiManager.Library.Options
UiManager.Buttons = UiManager.Library.Buttons
UiManager.Labels  = UiManager.Library.Labels

UiManager.Library.ForceCheckbox = ForceCheckbox

local DefaultSoundID    = NotifySound == "Obsidian" and 4590662766 or 4590657391
UiManager.NotifySoundID = `rbxassetid://{DefaultSoundID}`
UiManager.NotifyVolume  = 2

do
    local      Destroy, Instance_new
        = game.Destroy, Instance.new

    function UiManager:Notify(...)
        self.Library:Notify(...)

        local Sound = Instance_new("Sound", shared.SoundService);do
            Sound.SoundId = self.NotifySoundID
            Sound.Volume  = self.NotifyVolume
            Sound.PlayOnRemove = true
            Destroy(Sound)
        end
    end
end

function UiManager:CreateWindow()
    self.Window  = self.Library:CreateWindow({
        Icon     = 77335290652571,
        Title    = `MFeee~ New {wax.shared.Emoji}`,
        Footer   = `{wax.shared.ScriptDisplay} | {wax.shared.ScriptVersion}`,
        Center   = true,
        AutoShow = true,
        AlwaysOnTop  = AlwaysOnTop,
        CornerRadius = UiCorner,
        DPIScale     = DPIScale,
        NotifySide   = NotifySide,
        ShowCustomCursor = CustomCursor
    })

    self.Library.KeybindFrame.Visible = KeybindFrame

    return self.Window, (function()
        self.CreateWindow = function() end
    end)()
end

function UiManager:CreateMainTab()
    local UniversalMISC   = require("../Universal/MISC")

    --// Main Tab //
    self.MainTab = self.Window:AddTab(Translations:GetTranslation("Main"), "home")

    --// General Groupbox (Left)
    self.MainTabGeneralGroup = self.MainTab:AddLeftGroupbox(Translations:GetTranslation("General"))

    self.MainTabGeneralGroup:AddToggle("AntiAFK", {
        Text = Translations:GetTranslation("Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        Default = false
    })

    self.MainTabGeneralGroup:AddToggle("AntiKick", {
        Text = Translations:GetTranslation("Anti Kick (Client)"),
        Disabled = not (ExecutorSupport.hookfunction and ExecutorSupport.hookmetamethod),
        Default  = false
    })

    --// General Groupbox OnChanged
    self.Toggles.AntiAFK:OnChanged(UniversalMISC.AntiAFK.Start)

    self.Toggles.AntiKick:OnChanged(UniversalMISC.AntiKick.Start)

    --// Other Groupbox (Right)
    self.MainTabOtherGroup = self.MainTab:AddRightGroupbox(Translations:GetTranslation("Other"))

    do
        self.ClickTimesLabel = self.MainTabOtherGroup:AddLabel(string_format(Translations:GetTranslation("You clicked %d times"), Clicked))

        local SetText = self.ClickTimesLabel.SetText
        local ClickMultiplier = 1

        self.MainTabOtherGroup:AddButton(Translations:GetTranslation("Click Me!"), function()
            Clicked += ClickMultiplier
            SetText(self.ClickTimesLabel, string_format(Translations:GetTranslation("You clicked %d times"), Clicked))
            FileHelper:WriteFile("MFeee~New/Clicked.txt", tostring(Clicked))
        end)

        self.MainTabOtherGroup:AddInput("ClickMultiplier", {
            Text = Translations:GetTranslation("Click Multiplier"),
            Default = ClickMultiplier,
            Numeric = true,
            AllowEmpty = false
        })

        self.MainTabOtherGroup:AddButton({
            Text = Translations:GetTranslation("Reset Clicks"),
            DoubleClick = true,
            Func = function()
                self:Notify(string_format(Translations:GetTranslation("You lost %d clicks"), Clicked))
                Clicked = 0
                SetText(self.ClickTimesLabel, string_format(Translations:GetTranslation("You clicked %d times"), Clicked))
                FileHelper:WriteFile("MFeee~New/Clicked.txt", tostring(Clicked))
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
            Text    = Translations:GetTranslation("Easing Mode"),
            Values  = EasingModes,
            Default = "Quartic"
        })

        self.MainTabOtherGroup:AddDropdown("EasingDirection", {
            Text = Translations:GetTranslation("Easing Direction"),
            Values = {
                "In",
                "Out",
                "InOut"
            },
            Default = "Out"
        })

        self.MainTabOtherGroup:AddSlider("EasingDuration", {
            Text = Translations:GetTranslation("Easing Duration"),
            Default = 1,
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

    return self.MainTab
end

function UiManager:CreatePlayerTab()
    local UniversalPlayer = require("../Universal/Player")

    --// Player Tab //
    self.PlayerTab = self.Window:AddTab(Translations:GetTranslation("Player"), "user")

    --// Left Tab Box
    self.PlayerLeftTabBox = self.PlayerTab:AddLeftTabbox()

    --// Player Overrides Tab
    self.PlayerLeftTabBoxOverridesTab = self.PlayerLeftTabBox:AddTab(Translations:GetTranslation("Overrides"))

    do
        local TempCharacter = shared.Speaker.Character
        local TempHumanoid  = TempCharacter and TempCharacter:FindFirstChildOfClass("Humanoid") or {
            WalkSpeed  = "",
            JumpHeight = ""
        }

        local function Round(Number: number | nil)
            return Number and math.round(Number * 10) / 10
        end

        local TempWalkSpeed  = Round(tonumber(TempHumanoid.WalkSpeed))  or 16
        local TempJumpHeight = Round(tonumber(TempHumanoid.JumpHeight)) or 7.2

        self.PlayerLeftTabBoxOverridesTab:AddToggle("WalkSpeedOverride", {
            Text = Translations:GetTranslation("WalkSpeed Override"),
            Default = false
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("WalkSpeed", {
            Text = Translations:GetTranslation("WalkSpeed"),
            Default = TempWalkSpeed,
            Min = 0,
            Max = 200,
            Suffix = TempWalkSpeed > 1 and "studs/s" or "stud/s",
            Compact = true,
            HideMax = true
        })

        self.PlayerLeftTabBoxOverridesTab:AddToggle("JumpHeightOverride", {
            Text = Translations:GetTranslation("JumpHeight Override"),
            Default = false
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("JumpHeight", {
            Text = Translations:GetTranslation("JumpHeight"),
            Default = TempJumpHeight,
            Min = 0,
            Max = 100,
            Suffix = TempJumpHeight > 1 and "studs" or "stud",
            Compact = true,
            HideMax = true
        })
    end

    self.PlayerLeftTabBoxOverridesTab:AddToggle("GravityOverride", {
        Text = Translations:GetTranslation("Gravity Override"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("Gravity", {
        Text = Translations:GetTranslation("Gravity"),
        Default = shared.Workspace.Gravity,
        Min = 0,
        Max = 1000,
        Suffix = shared.Workspace.Gravity > 1 and "studs/s²" or "stud/s²",
        Compact = true,
        HideMax = true
    })

    self.PlayerLeftTabBoxOverridesTab:AddDivider()

    self.PlayerLeftTabBoxOverridesTab:AddToggle("NoAcceleration", {
        Text = Translations:GetTranslation("No Acceleration"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("AntiRobloxVoid", {
        Text = Translations:GetTranslation("Anti Roblox Void"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("SpeedBoost", {
        Text = Translations:GetTranslation("Speed Boost"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("BoostSpeed", {
        Text = Translations:GetTranslation("Boost Speed"),
        Default = UniversalPlayer.SpeedBoost.Speed,
        Min = 0,
        Max = 100,
        Suffix = UniversalPlayer.SpeedBoost.Speed > 1 and "studs/s" or "stud/s",
        Compact = true,
        HideMax = true
    })

    self.PlayerLeftTabBoxOverridesTab:AddDivider()

    self.PlayerLeftTabBoxOverridesTab
    :AddToggle("Noclip", {
        Text = Translations:GetTranslation("Noclip"),
        Default = false
    })
    :AddKeyPicker("NoclipKeybind", {
        Text = Translations:GetTranslation("Noclip"),
        Default = "N",
        Mode = "Toggle",
        SyncToggleState = true
    })

    self.PlayerLeftTabBoxOverridesTab
    :AddToggle("VehicleNoclip", {
        Text = Translations:GetTranslation("Vehicle Noclip"),
        Default = false
    })
    :AddKeyPicker("VehicleNoclipKeybind", {
        Text = Translations:GetTranslation("Vehicle Noclip"),
        Default = "H",
        Mode = "Toggle",
        SyncToggleState = true
    })

    --// Player Groupbox OnChanged
    self.Toggles.WalkSpeedOverride :OnChanged(UniversalPlayer.WalkSpeed.Override)
    self.Toggles.JumpHeightOverride:OnChanged(UniversalPlayer.JumpHeight.Override)
    self.Toggles.GravityOverride   :OnChanged(UniversalPlayer.Gravity.Override)

    self.Toggles.NoAcceleration :OnChanged(UniversalPlayer.NoAcceleration.Start)
    self.Toggles.AntiRobloxVoid :OnChanged(UniversalPlayer.AntiVoid.Start)
    self.Toggles.SpeedBoost     :OnChanged(UniversalPlayer.SpeedBoost.Start)

    self.Toggles.Noclip       :OnChanged(UniversalPlayer.Noclip.CharacterNoclip)
    self.Toggles.VehicleNoclip:OnChanged(UniversalPlayer.Noclip.VehicleNoclip)

    self.Options.WalkSpeed:OnChanged(function(WalkSpeed)
        UniversalPlayer.WalkSpeed.SetSpeed(WalkSpeed)
    end)

    self.Options.JumpHeight:OnChanged(function(JumpHeight)
        UniversalPlayer.JumpHeight.SetHeight(JumpHeight)
    end)

    self.Options.Gravity:OnChanged(function(Gravity)
        UniversalPlayer.Gravity.SetGravity(Gravity)
    end)

    self.Options.BoostSpeed:OnChanged(function(BoostSpeed)
        UniversalPlayer.SpeedBoost.Speed = BoostSpeed
    end)

    --// Fly Groupbox (Right)
    return self.PlayerTab
end

function UiManager:CreateUniversalTabs()
    --// MISC Tab //
    self.MiscTab = self.Window:AddTab(Translations:GetTranslation("Misc"), "boxes")

    --// Roblox Groupbox (Left)
    self.MiscTabRobloxGroup = self.MiscTab:AddLeftGroupbox("Roblox")

    do
        local Toggles = {}

        Toggles.EnableReset = self.MiscTabRobloxGroup:AddToggle("EnableReset", {
            Text = Translations:GetTranslation("Enable Reset"),
            Default = shared.StarterGui:GetCore("ResetButtonCallback")
        })

        Toggles.EnablePlayerList = self.MiscTabRobloxGroup:AddToggle("EnablePlayerList", {
            Text = Translations:GetTranslation("Enable Player List"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
        })

        Toggles.EnableHealth = self.MiscTabRobloxGroup:AddToggle("EnableHealth", {
            Text = Translations:GetTranslation("Enable Health Bar"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
        })

        Toggles.EnableBackpack = self.MiscTabRobloxGroup:AddToggle("EnableBackpack", {
            Text = Translations:GetTranslation("Enable Backpack"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
        })

        Toggles.EnableChat = self.MiscTabRobloxGroup:AddToggle("EnableChat", {
            Text = Translations:GetTranslation("Enable Chat"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
        })

        Toggles.EnableEmotesMenu = self.MiscTabRobloxGroup:AddToggle("EnableEmotesMenu", {
            Text = Translations:GetTranslation("Enable Emotes Menu"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
        })

        Toggles.EnableSelfView = self.MiscTabRobloxGroup:AddToggle("EnableSelfView", {
            Text = Translations:GetTranslation("Enable Self View"),
            Tooltip = Translations:GetTranslation("Avatar \"selfie\" (with facial capture enabled)"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)
        })

        Toggles.EnableCapture = self.MiscTabRobloxGroup:AddToggle("EnableCapture", {
            Text = Translations:GetTranslation("Enable Capture Button"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures)
        })

        self.MiscTabRobloxGroup:AddDivider()

        self.MiscTabRobloxGroup:AddToggle("DevConsole", {
            Text = Translations:GetTranslation("Dev Console"),
            Default = shared.StarterGui:GetCore("DevConsoleVisible")
        })

        Toggles.AvatarContextMenu = self.MiscTabRobloxGroup:AddToggle("AvatarContextMenu", {
            Text = Translations:GetTranslation("Avatar Context Menu"),
            Tooltip = Translations:GetTranslation("Left-clicking on a player's avatar will pop up a context menu, and stop you from moving\n(which players who enjoy Natural Disaster Survival should be very familiar with)"),
            Default = shared.StarterGui:GetCore("AvatarContextMenuEnabled")
        })

        --// Roblox Groupbox OnChanged/Connection
        do
            local ChangedToggles = {}

            for Index, Toggle in Toggles do
                task_spawn(Toggle.OnChanged, Toggle, function()
                    ChangedToggles[Index] = true
                end)
            end

            local StarterGui = shared.StarterGui
            local SetCore    = StarterGui.SetCore
            local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

            local function SetCoreGui(Type)
                local Index = `Enable{Type}`
                if not ChangedToggles[Index] then return end

                SetCoreGuiEnabled(StarterGui, Enum.CoreGuiType[Type], self.Toggles[Index].Value)
            end

            shared.Connect:GiveSignal("RobloxGuiLoop", shared.RunService.PreRender:Connect(function()
                if ChangedToggles.ResetButtonCallback then SetCore(StarterGui, "ResetButtonCallback",      self.Toggles.EnableReset.Value      ) end
                if ChangedToggles.AvatarContextMenu   then SetCore(StarterGui, "AvatarContextMenuEnabled", self.Toggles.AvatarContextMenu.Value) end
                SetCoreGui("PlayerList")
                SetCoreGui("Health")
                SetCoreGui("Backpack")
                SetCoreGui("Chat")
                SetCoreGui("EmotesMenu")
                SetCoreGui("SelfView")
                SetCoreGui("Captures")
            end))

            self.Toggles.DevConsole:OnChanged(function(Enabled)
                SetCore("DevConsoleVisible", Enabled)
            end)
        end
    end

    --[[
    --// Decompiler Groupbox (Right)
    wax.shared.DecompilerGroup = self.MiscTab:AddRightGroupbox(Translations:GetTranslation("Decompiler"))
    self.DecompilerGroup = wax.shared.DecompilerGroup

    local StatusText = Translations:GetTranslation("Status")
    self.DecompilerInfo = self.DecompilerGroup:AddLabel({
        Text     = `{StatusText}: {Translations:GetTranslation("Idle")}`,
        DoesWrap = true
    })

    self.DecompilerGroup:AddToggle("ToggleDecompilation", {
        Text    = Translations:GetTranslation("Decompile"),
        Default = Decompiler.Running
    })

    self.DecompilerGroup:AddToggle("ToggleDecompilationState", {
        Text    = Translations:GetTranslation("Pause"),
        Default = Decompiler.Paused
    })

    self.DecompilerGroup:AddDivider()

    self.DecompilerGroup:AddToggle("DecompilerOverwrite", {
        Text = Translations:GetTranslation("Overwrite"),
        Tooltip = Translations:GetTranslation("Overwrite existing files"),
        Default = Decompiler.Overwrite
    })

    self.DecompilerGroup:AddToggle("DecompilerDebugMode", {
        Text = Translations:GetTranslation("Debug Mode"),
        Tooltip = Translations:GetTranslation("Print a bunch of logs"),
        Default = Decompiler.DebugMode
    })

    self.DecompilerGroup:AddDropdown("DecompileClasses", {
        Text = Translations:GetTranslation("Classes"),
        Values = {
            "LocalScript",
            "ModuleScript"
        },
        Default = {
            "LocalScript",
            "ModuleScript"
        }
    })

    self.DecompilerGroup:AddInput("DecompilerExtension", {
        Text = Translations:GetTranslation("Extension"),
        Default = Decompiler.Extension,
        EmptyReset = ".luau",
        Placeholder = ".luau",
        ClearTextOnFocus = false
    })

    self.DecompilerGroup:AddInput("DecompilerSaveFolder", {
        Text = Translations:GetTranslation("Save Folder"),
        Default = Decompiler.SaveFolder,
        EmptyReset = "MFeee~New/Decompiled Scripts",
        Placeholder = "MFeee~New/Decompiled Scripts",
        ClearTextOnFocus = false
    })

    --// Decompiler Groupbox OnChanged
    self.Toggles.ToggleDecompilation:OnChanged(function(Enabled)
        local self = Decompiler

        local Message, Success = self:ToggleDecompilation(Enabled)
        self:Notify(Message)

        if Success then
            if self.Running then
                self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Decompiling")}`)
                
                self.WaitingThread = coroutine.create(function()
                    local Info = coroutine.yield()

                    self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Finished Decompiling")}\n{Translations:GetTranslation("Time Used")}: {Info.TotalTime}ms\n{Translations:GetTranslation("Decompiled")}: {Info.Scripts}{Translations:GetTranslation("Scripts")}\n{Translations:GetTranslation("Total Size")}: {Info.Bytes}bytes`)
                    self:Notify(Translations:GetTranslation("Finished Decompiling"))
                end)
            else
                self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Idle")}`)
            end
        end

        shared.Connect:GiveSignal("DecompilationInfo", self.InfoInstance:GetPropertyChangedSignal("Value"):Connect(function()
            if not self.Running then
                shared.Connect:DisconnectSignal("DecompilationInfo")
                return
            end

            self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Decompiled")} {self.InfoInstance.Value}/{self.TotalScripts} {Translations:GetTranslation("Scripts")}`)
        end))
    end)

    self.Toggles.ToggleDecompilationState:OnChanged(function(Enabled)
        local self = Decompiler

        local Message, Success = self:TogglePaused(Enabled)
        self:Notify(Message)

        if Success then
            if self.Paused then
                self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Paused")}`)
            else
                self.DecompilerInfo:SetText(`{StatusText}: {Translations:GetTranslation("Decompiling")}`)
            end
        end
    end)

    self.Toggles.DecompilerOverwrite:OnChanged(function(Enabled)
        Decompiler.Overwrite = Enabled
    end)

    self.Toggles.DecompilerDebugMode:OnChanged(function(Enabled)
        Decompiler.DebugMode = Enabled
    end)

    self.Options.DecompileClasses:OnChanged(function(Classes)
        Decompiler["LocalScript"] = table_find(Classes, "LocalScript") and true or false
        Decompiler["ModuleScript"] = table_find(Classes, "ModuleScript") and true or false
    end)

    self.Options.DecompilerExtension:OnChanged(function(Extension)
        if not Extension:match("^%.%w+$") then
            self.Options.DecompilerExtension:SetValue(".luau")
            return
        end

        Decompiler.Extension = Extension
    end)

    self.Options.DecompilerSaveFolder:OnChanged(function(SaveFolder)
        Decompiler.SaveFolder = SaveFolder
    end)
    ]]

    --// Settings Tab //
    self.SettingsTab = self.Window:AddTab(Translations:GetTranslation("Settings"), "settings")

    --// Menu Groupbox (Left)
    self.SettingsTabMenuGroup = self.SettingsTab:AddLeftGroupbox(Translations:GetTranslation("Menu"))

    self.SettingsTabMenuGroup:AddToggle("OpenKeybindMenu", {
        Text = Translations:GetTranslation("Open Keybind Menu"),
        Default = self.Library.KeybindFrame.Visible
    })

    self.SettingsTabMenuGroup:AddToggle("ShowCustomCursor", {
        Text = Translations:GetTranslation("Show Custom Cursor"),
        Default = CustomCursor
    })

    self.SettingsTabMenuGroup:AddToggle("ForceCheckbox", {
        Text = Translations:GetTranslation("Force Checkbox"),
        Default = ForceCheckbox
    })

    self.SettingsTabMenuGroup:AddLabel(Translations:GetTranslation("Open Menu Key")):AddKeyPicker("OpenMenu", {
        Default = "RightControl",
        Mode = "Toggle",
        NoUI = true
    })

    self.SettingsTabMenuGroup:AddDivider()

    self.SettingsTabMenuGroup:AddButton({
        Text = Translations:GetTranslation("Unload"),
        DoubleClick = true,
        Func = wax.shared.OnUnload
    })

    --// Menu Groupbox OnChanged
    self.Toggles.OpenKeybindMenu:OnChanged(function(Enabled)
        KeybindFrame = Enabled
        self.Library.KeybindFrame.Visible = Enabled

        FileHelper:WriteFile("MFeee~New/KeybindFrame.txt", tostring(Enabled))
    end)

    self.Toggles.ShowCustomCursor:OnChanged(function(Enabled)
        CustomCursor = Enabled
        self.Library.ShowCustomCursor = Enabled

        FileHelper:WriteFile("MFeee~New/CustomCursor.txt", tostring(Enabled))
    end)

    self.Toggles.ForceCheckbox:OnChanged(function(Enabled)
        ForceCheckbox = Enabled
        self.Library.ForceCheckbox = Enabled

        FileHelper:WriteFile("MFeee~New/ForceCheckbox.txt", tostring(Enabled))
    end)

    self.Library.ToggleKeybind = self.Options.OpenMenu

    --// UI Groupbox (Right)
    self.SettingsTabUiGroup = self.SettingsTab:AddRightGroupbox(Translations:GetTranslation("UI"))

    self.SettingsTabUiGroup:AddToggle("AlwaysOnTop", {
        Text = Translations:GetTranslation("Always On Top"),
        Default = AlwaysOnTop
    })

    do
        local NativeLanguage = {
            Tag  = {},
            Name = {}
        }

        for Tag, Name in wax.shared.AllowedLanguages do
            table_insert(NativeLanguage.Tag , Tag)
            table_insert(NativeLanguage.Name, Name)
        end

        self.SettingsTabUiGroup:AddDropdown("ChangeLanguage", {
            Text    = Translations:GetTranslation("Change Language"),
            Values  = NativeLanguage.Name,
            Default = wax.shared.AllowedLanguages[wax.shared.Language]
        })

        self.Options.ChangeLanguage:OnChanged(function(Language)
            local Index = table_find(NativeLanguage.Tag, Language)
            if not Index then return end

            FileHelper:WriteFile("MFeee~New/Language.txt", NativeLanguage[Index])
            self:Notify(Translations:GetTranslation("Restart to Apply"))
        end)
    end

    self.SettingsTabUiGroup:AddDropdown("WindowStyle", {
        Text = Translations:GetTranslation("Window Style"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = Translations:GetTranslation(WindowStyle)
    })

    self.SettingsTabUiGroup:AddSlider("DPIScale", {
        Text = Translations:GetTranslation("DPI Scale"),
        Default = DPIScale,
        Min = 50,
        Max = 200,
        Suffix = "%"
    })

    self.SettingsTabUiGroup:AddSlider("UICorner", {
        Text = Translations:GetTranslation("UI Corner"),
        Tooltip = Translations:GetTranslation("Restart to Apply"),
        Default = UiCorner,
        Min = 0,
        Max = 10,
        Suffix = "px"
    })

    self.SettingsTabUiGroup:AddDivider()

    self.SettingsTabUiGroup:AddDropdown("NotifySide", {
        Text = Translations:GetTranslation("Notify Side"),
        Values = {
            Translations:GetTranslation("Top Left"),
            Translations:GetTranslation("Top Right"),
            Translations:GetTranslation("Bottom Left"),
            Translations:GetTranslation("Bottom Right")
        },
        Default = Translations:GetTranslation(NotifySide)
    })

    self.SettingsTabUiGroup:AddDropdown("NotifySound", {
        Text = Translations:GetTranslation("Notify Sound"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = Translations:GetTranslation(NotifySound)
    })

    self.SettingsTabUiGroup:AddInput("NotifySoundID", {
        Text = Translations:GetTranslation("Notify Sound ID"),
        Default = "",
        EmptyReset = "",
        Placeholder = tostring(DefaultSoundID),
        ClearTextOnFocus = false
    })

    self.SettingsTabUiGroup:AddSlider("NotifyVolume", {
        Text = Translations:GetTranslation("Notify Volume"),
        Default = 200,
        Min = 0,
        Max = 1000,
        Suffix = "%"
    })

    do
        local TestNotify = Translations:GetTranslation("Test Notify")

        self.SettingsTabUiGroup:AddButton(TestNotify, function()
            self:Notify({
                Title = TestNotify,
                Description = TestNotify,
                Duration = 3
            })
        end)
    end

    --// UI Groupbox OnChanged
    self.Toggles.AlwaysOnTop:OnChanged(function(Enabled)
        AlwaysOnTop = Enabled
        self.Library.ScreenGui.OnTopOfCoreBlur = Enabled

        FileHelper:WriteFile("MFeee~New/AlwaysOnTop.txt", tostring(Enabled))
    end)

    self.Options.WindowStyle:OnChanged(function(Style)
        FileHelper:WriteFile("MFeee~New/WindowStyle.txt", Style == "Obsidian" and "Obsidian" or "Linoria")
        self:Notify(Translations:GetTranslation("Restart to Apply"))
    end)

    do
        local LatestDpi = DPIScale

        shared.Connect:BindAction(
            "DPISliderHold",
            function(ActionName: string, InputState: Enum.UserInputState)
                if ActionName == "DPISliderHold" and InputState == Enum.UserInputState.End then
                    self.Library:SetDPIScale(LatestDpi)
                end
                return Enum.ContextActionResult.Pass
            end,
            false,
            Enum.ContextActionPriority.High,
            Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch
        )

        self.Options.DPIScale:OnChanged(function(Scale)
            LatestDpi = Scale
            FileHelper:WriteFile("MFeee~New/DPIScale.txt", Scale)
        end)
    end

    self.Options.UICorner:OnChanged(function(Corner)
        FileHelper:WriteFile("MFeee~New/UICorner.txt", tostring(Corner))
        self:Notify(Translations:GetTranslation("Restart to Apply"))
    end)

    self.Options.NotifySide:OnChanged(function(Side)
        Side = Translations:FromTranslation(Side)
        if not Side then return end

        FileHelper:WriteFile("MFeee~New/NotifySide.txt", Side)
        self.Library:SetNotifySide(Side)
    end)

    self.Options.NotifySound:OnChanged(function(Sound)
        local SoundID = Sound == "Obsidian" and 4590662766 or 4590657391
        self.NotifySoundID = `rbxassetid://{SoundID}`

        FileHelper:WriteFile("MFeee~New/NotifySound.txt", Sound)
    end)

    self.Options.NotifySoundID:OnChanged(function(SoundID)
        if SoundID == "" or type(select(2, pcall(tonumber, SoundID))) ~= "number" then return end
        SoundID = `rbxassetid://{SoundID}`

        self.NotifySoundID = SoundID
        task_spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {SoundID})
    end)

    self.Options.NotifyVolume:OnChanged(function(Volume)
        self.NotifyVolume = Volume / 100
    end)

    --// Info Tab //
    self.InfoTab = self.Window:AddTab(Translations:GetTranslation("Info"), "info")

    --// Developers Groupbox (Left)
    self.InfoTabDevelopersGroup = self.InfoTab:AddLeftGroupbox(Translations:GetTranslation("Developers"))

    self.InfoTabDevelopersGroup:AddLabel({
        Text = `[<font color="#1f6feb">MaiFengYXD</font>] {Translations:GetTranslation("Owner, developer")}`,
        DoesWrap = true
    })

    --// Credits Groupbox (Left)
    self.InfoTabCreditsGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("Credits"))

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">upio</font>] {Translations:GetTranslation("Teaches me how to use wax")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">mspaint</font>] {Translations:GetTranslation("Gives me inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">GitHub Copilot</font>] {Translations:GetTranslation("Helps complete code")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">Google Gemini</font>] {Translations:GetTranslation("Helps translate (English)")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">{Translations:GetTranslation("And you!")}</font>] {Translations:GetTranslation("For using my script!")}`,
        DoesWrap = true
    })

    --// Spechial Thanks Groupbox (Left)
    self.InfoTabThanksGroup = self.InfoTab:AddLeftGroupbox(Translations:GetTranslation("Special Thanks"))

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">latte-soft</font>] {Translations:GetTranslation("Wax bundler")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">deividcomsono</font>] {Translations:GetTranslation("Obsidian UI Library")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">mstudio45</font>] {Translations:GetTranslation("Linoria UI Library and ESP Library")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">Exunys</font>] {Translations:GetTranslation("Aimbot Inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">7GrandDadPGN</font>] {Translations:GetTranslation("SilentAim Inspiration")}`,
        DoesWrap = true
    })

    --// About Game Groupbox (Right)
    self.InfoTabAboutGameGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("About Game"))

    local PlayedLabel      = self.InfoTabAboutGameGroup:AddLabel()
    local TimeRunningLabel = self.InfoTabAboutGameGroup:AddLabel()
    local GameNameLabel    = self.InfoTabAboutGameGroup:AddLabel()

    --// About Game Group Update
    do
        local math_floor, task_wait
            = math.floor, task.wait

        local elapsedTime
            = elapsedTime

        local SetText = PlayedLabel.SetText

        local function ConvertTime(Time: number): string
            local Hour   = math_floor(Time / 3600)
            local Minute = math_floor(Time / 60) % 60
            local Second = math_floor(Time % 60)

            return `{Hour}:{Minute}:{Second}`
        end

        shared.Connect:GiveSignal("YouPlayedLabel"  , shared.RunService.PreRender:Connect(function()
            local Time = ConvertTime(shared.Workspace.DistributedGameTime)
            SetText(PlayedLabel, string_format(Translations:GetTranslation("You Played: %s"), Time))
        end))

        shared.Connect:GiveSignal("TimeRunningLabel", shared.RunService.PreRender:Connect(function()
            local Time = ConvertTime(elapsedTime())
            SetText(TimeRunningLabel, string_format(Translations:GetTranslation("Time Running: %s"), Time))
        end))

        task_spawn(function()
            repeat task_wait() until wax.shared.GameName
            SetText(GameNameLabel, string_format(Translations:GetTranslation("Game Name: %s"), wax.shared.GameName))
        end)
    end

    do
        local PlaceId = tostring(game.PlaceId)

        self.InfoTabAboutGameGroup:AddButton({
            Text = string_format(Translations:GetTranslation("Place Id: %s"), PlaceId),
            Func = function()
                shared.ToClipboard(PlaceId)
                self:Notify(Translations:GetTranslation("Place Id Copied"))
            end
        })
    end

    --// Links Groupbox (Right)
    self.InfoTabLinksGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("Links"))

    self.InfoTabLinksGroup
    :AddButton({
        Text = Translations:GetTranslation("Discord"),
        Func = function()
            shared.ToClipboard("https://discord.gg/YBQUd8X8PK")
            self:Notify(Translations:GetTranslation("Discord Server Link Copied"))
        end
    })
    :AddButton({
        Text = Translations:GetTranslation("GitHub"),
        Func = function()
            shared.ToClipboard("https://github.com/MaiFengYXD")
            self:Notify(Translations:GetTranslation("GitHub Link Copied"))
        end
    })

    return self.MiscTab, self.InfoTab
end

return UiManager
