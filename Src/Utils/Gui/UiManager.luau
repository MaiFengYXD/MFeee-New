local UiManager = {}

local ExecutorSupport  = wax.shared.ExecutorSupport
local FileHelper       = wax.shared.FileHelper
local Translations     = wax.shared.Translations
--local Decompiler     = wax.shared.Decompiler
local EasingLibrary    = wax.shared.EasingLibrary
local PlayerUniversal  = wax.shared.PlayerUniversal
local MISCUniversal    = wax.shared.MISCUniversal

shared.WindowStyle     = FileHelper:CheckFile("MFeee~New/WindowStyle.txt", "Obsidian", {"Obsidian", "Linoria"})
shared.NotifySound     = FileHelper:CheckFile("MFeee~New/NotifySound.txt", shared.WindowStyle, {"Obsidian", "Linoria"})
shared.NotifySide      = FileHelper:CheckFile("MFeee~New/NotifySide.txt", "TopRight", {"TopLeft", "TopRight", "BottomLeft", "BottomRight"})
shared.ForceCheckbox   = FileHelper:CheckFile("MFeee~New/ForceCheckbox.txt", "false", {"false", "true"}) == "true"
shared.CustomCursor    = FileHelper:CheckFile("MFeee~New/CustomCursor.txt", "false", {"false", "true"}) == "true"
shared.KeybindFrame    = FileHelper:CheckFile("MFeee~New/KeybindFrame.txt", "false", {"false", "true"}) == "true"
shared.UseRPC          = FileHelper:CheckFile("MFeee~New/UseRPC.txt", "false", {"false", "true"}) == "true"
shared.UiCorner        = FileHelper:CheckFile("MFeee~New/UiCorner.txt", 5, 5)
shared.DPIScale        = FileHelper:CheckFile("MFeee~New/DPIScale.txt", 1, 1)
local  Clicked         = FileHelper:CheckFile("MFeee~New/Clicked.txt", 0, 0)

UiManager.Library      = require(`{shared.WindowStyle}/Library`)
UiManager.SaveManager  = require(`{shared.WindowStyle}/SaveManager`)
UiManager.ThemeManager = require(`{shared.WindowStyle}/ThemeManager`)

UiManager.Toggles = UiManager.Library.Toggles
UiManager.Options = UiManager.Library.Options
UiManager.Buttons = UiManager.Library.Buttons
UiManager.Labels  = UiManager.Library.Labels

UiManager.Library.ForceCheckbox = shared.ForceCheckbox

local DefaultSoundID = shared.NotifySound == "Obsidian" and 4590662766 or 4590657391
UiManager.NotifySoundID = `rbxassetid://{DefaultSoundID}`
UiManager.NotifyVolume = 2

local Obsidian = shared.WindowStyle == "Obsidian"
local Scheme = if Obsidian then UiManager.Library.Scheme else UiManager.Library
Scheme.FontFace = Font.fromEnum(Enum.Font.BuilderSans)

function UiManager:Notify(...)
    self.Library:Notify(...)

    local Sound = Instance.new("Sound", shared.SoundService)
    Sound.SoundId = self.NotifySoundID
    Sound.Volume = self.NotifyVolume
    Sound.PlayOnRemove = true
    Sound:Destroy()
end

function UiManager:CreateWindow()
    self.Window = self.Library:CreateWindow({
        Title = `MFeee~ New {wax.shared.Emoji}`,
        Footer = `{shared.ScriptDisplay} | {shared.ScriptVersion}`,
        Center = true,
        AutoShow = true,
        ShowCustomCursor = shared.CustomCursor,
        CornerRadius = shared.UiCorner,
        DPIScale = shared.DPIScale,
        NotifySide = shared.NotifySide,
        Icon = 77335290652571
    })

    self.Library.KeybindFrame.Visible = shared.KeybindFrame
    return self.Window
end

function UiManager:CreateMainTab()
    --// Main Tab //
    wax.shared.MainTab = self.Window:AddTab(Translations:GetTranslation("Main"), "home")
    self.MainTab = wax.shared.MainTab

    --// General Groupbox (Left)
    wax.shared.GeneralGroup = self.MainTab:AddLeftGroupbox(Translations:GetTranslation("General"))
    self.GeneralGroup = wax.shared.GeneralGroup

    self.GeneralGroup:AddToggle("AntiAFK", {
        Text = Translations:GetTranslation("Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        Default = false
    })

    self.GeneralGroup:AddToggle("AntiKick", {
        Text = Translations:GetTranslation("Anti Kick (Client)"),
        Disabled = not (ExecutorSupport.hookfunction and ExecutorSupport.hookmetamethod),
        Default = false
    })

    --// General Groupbox OnChanged
    self.Toggles.AntiAFK:OnChanged(MISCUniversal.AntiAFK.Start)

    self.Toggles.AntiKick:OnChanged(MISCUniversal.AntiKick.Start)

    --// Other Groupbox (Right)
    wax.shared.OtherGroup = self.MainTab:AddRightGroupbox(Translations:GetTranslation("Other"))
    self.OtherGroup = wax.shared.OtherGroup

    self.ClickTimesLabel = self.OtherGroup:AddLabel(Translations:GetTranslation("You clicked %d times"):format(Clicked))

    local ClickMultiplier = 1

    self.OtherGroup:AddButton(Translations:GetTranslation("Click Me!"), function()
        Clicked += ClickMultiplier
        self.ClickTimesLabel:SetText(Translations:GetTranslation("You clicked %d times"):format(Clicked))
        FileHelper:WriteFile("MFeee~New/Clicked.txt", tostring(Clicked))
    end)

    self.OtherGroup:AddInput("ClickMultiplier", {
        Text = Translations:GetTranslation("Click Multiplier"),
        Default = ClickMultiplier,
        Numeric = true,
        AllowEmpty = false
    })

    self.OtherGroup:AddButton({
        Text = Translations:GetTranslation("Reset Clicks"),
        DoubleClick = true,
        Func = function()
            self:Notify(Translations:GetTranslation("You lost %d clicks"):format(Clicked))
            Clicked = 0
            self.ClickTimesLabel:SetText(Translations:GetTranslation("You clicked %d times"):format(Clicked))
            FileHelper:WriteFile("MFeee~New/Clicked.txt", tostring(Clicked))
        end
    })

    self.OtherGroup:AddDivider()

    self.OtherGroup:AddDropdown("EasingMode", {
        Text = Translations:GetTranslation("Easing Mode"),
        Values = {
            --/ Polynomial
            "Linear",
            "Quadratic",
            "Cubic",
            "Quartic",
            "Quintic",

            --/ Trigonometric
            "Circular",
            "Sine",

            --/ Exponential
            "Exponential",

            --/ Special
            "Back",
            "Bounce",
            "Elastic",

            --/ Other
            "None"
        },
        Default = "Quartic"
    })

    self.OtherGroup:AddDropdown("EasingDirection", {
        Text = Translations:GetTranslation("Easing Direction"),
        Values = {
            "In",
            "Out",
            "InOut"
        },
        Default = "Out"
    })

    self.OtherGroup:AddSlider("EasingDuration", {
        Text = Translations:GetTranslation("Easing Duration"),
        Default = 1,
        Min = 0.1,
        Max = 3,
        Rounding = 1
    })

    --// Other Groupbox OnChanged
    self.Options.ClickMultiplier:OnChanged(function(Multiplier)
        ClickMultiplier = Multiplier
    end)

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
    --// Player Tab //
    wax.shared.PlayerTab = self.Window:AddTab(Translations:GetTranslation("Player"), "user")
    self.PlayerTab = wax.shared.PlayerTab

    --// Left Tab Box
    wax.shared.PlayerLeftTabBox = self.PlayerTab:AddLeftTabbox()
    self.PlayerLeftTabBox = wax.shared.PlayerLeftTabBox

    --// Player Overrides Tab
    wax.shared.PlayerOverridesTab = self.PlayerLeftTabBox:AddTab(Translations:GetTranslation("Overrides"))
    self.PlayerOverridesTab = wax.shared.PlayerOverridesTab

    local TempCharacter = shared.Speaker.Character
    local TempHumanoid = TempCharacter and TempCharacter:FindFirstChildOfClass("Humanoid") or setmetatable({}, {__index = function() return nil end})

    local TempWalkSpeed = TempHumanoid.WalkSpeed or 16
    local TempJumpHeight = TempHumanoid.JumpHeight or 7.2

    self.PlayerOverridesTab:AddToggle("WalkSpeedOverride", {
        Text = Translations:GetTranslation("WalkSpeed Override"),
        Default = false
    })

    self.PlayerOverridesTab:AddSlider("WalkSpeed", {
        Text = Translations:GetTranslation("WalkSpeed"),
        Default = TempWalkSpeed,
        Min = 0,
        Max = 200,
        Suffix = TempWalkSpeed > 1 and "studs/s" or "stud/s",
        Compact = true,
        HideMax = true
    })

    self.PlayerOverridesTab:AddToggle("JumpHeightOverride", {
        Text = Translations:GetTranslation("JumpHeight Override"),
        Default = false
    })

    self.PlayerOverridesTab:AddSlider("JumpHeight", {
        Text = Translations:GetTranslation("JumpHeight"),
        Default = TempJumpHeight,
        Min = 0,
        Max = 100,
        Suffix = TempJumpHeight > 1 and "studs" or "stud",
        Compact = true,
        HideMax = true
    })

    self.PlayerOverridesTab:AddToggle("GravityOverride", {
        Text = Translations:GetTranslation("Gravity Override"),
        Default = false
    })

    self.PlayerOverridesTab:AddSlider("Gravity", {
        Text = Translations:GetTranslation("Gravity"),
        Default = shared.Workspace.Gravity,
        Min = 0,
        Max = 1000,
        Suffix = shared.Workspace.Gravity > 1 and "studs/s²" or "stud/s²",
        Compact = true,
        HideMax = true
    })

    self.PlayerOverridesTab:AddDivider()

    self.PlayerOverridesTab:AddToggle("NoAcceleration", {
        Text = Translations:GetTranslation("No Acceleration"),
        Default = false
    })

    self.PlayerOverridesTab:AddToggle("AntiRobloxVoid", {
        Text = Translations:GetTranslation("Anti Roblox Void"),
        Default = false
    })

    self.PlayerOverridesTab:AddToggle("SpeedBoost", {
        Text = Translations:GetTranslation("Speed Boost"),
        Default = false
    })

    self.PlayerOverridesTab:AddSlider("BoostSpeed", {
        Text = Translations:GetTranslation("Boost Speed"),
        Default = PlayerUniversal.SpeedBoost.Speed,
        Min = 0,
        Max = 100,
        Suffix = PlayerUniversal.SpeedBoost.Speed > 1 and "studs/s" or "stud/s",
        Compact = true,
        HideMax = true
    })

    self.PlayerOverridesTab:AddDivider()

    self.PlayerOverridesTab:AddToggle("Noclip", {
        Text = Translations:GetTranslation("Noclip"),
        Default = false
    })
    :AddKeyPicker("NoclipKeybind", {
        Text = Translations:GetTranslation("Noclip"),
        Default = "N",
        Mode = "Toggle",
        SyncToggleState = true
    })

    self.PlayerOverridesTab:AddToggle("VehicleNoclip", {
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
    self.Toggles.WalkSpeedOverride:OnChanged(PlayerUniversal.WalkSpeed.Override)
    self.Toggles.JumpHeightOverride:OnChanged(PlayerUniversal.JumpHeight.Override)
    self.Toggles.GravityOverride:OnChanged(PlayerUniversal.Gravity.Override)

    self.Toggles.NoAcceleration:OnChanged(PlayerUniversal.NoAcceleration.Start)
    self.Toggles.AntiRobloxVoid:OnChanged(PlayerUniversal.AntiVoid.Start)
    self.Toggles.SpeedBoost:OnChanged(PlayerUniversal.SpeedBoost.Start)
    self.Toggles.CharacterScaled:OnChanged(PlayerUniversal.Scale.Start)

    self.Toggles.Noclip:OnChanged(PlayerUniversal.Noclip.CharacterNoclip)
    self.Toggles.VehicleNoclip:OnChanged(PlayerUniversal.Noclip.VehicleNoclip)

    self.Options.WalkSpeed:OnChanged(function(WalkSpeed)
        PlayerUniversal.WalkSpeed.SetSpeed(WalkSpeed)
    end)

    self.Options.JumpHeight:OnChanged(function(JumpHeight)
        PlayerUniversal.JumpHeight.SetHeight(JumpHeight)
    end)

    self.Options.Gravity:OnChanged(function(Gravity)
        PlayerUniversal.Gravity.SetGravity(Gravity)
    end)

    self.Options.BoostSpeed:OnChanged(function(BoostSpeed)
        PlayerUniversal.SpeedBoost.Speed = BoostSpeed
    end)

    self.Options.CharacterScale:OnChanged(function(CharacterScale)
        PlayerUniversal.Scale.SetScale(CharacterScale)
    end)

    --// Fly Groupbox (Right)
    return self.PlayerTab
end

function UiManager:CreateUniversalTabs()
    --// MISC Tab //
    wax.shared.MiscTab = self.Window:AddTab(Translations:GetTranslation("Misc"), "boxes")
    self.MiscTab = wax.shared.MiscTab

    --// Roblox Groupbox (Left)
    wax.shared.RobloxGroup = self.MiscTab:AddLeftGroupbox("Roblox")
    self.RobloxGroup = wax.shared.RobloxGroup

    self.RobloxGroup:AddToggle("EnableReset", {
        Text = Translations:GetTranslation("Enable Reset"),
        Default = shared.StarterGui:GetCore("ResetButtonCallback")
    })

    self.RobloxGroup:AddToggle("EnablePlayerList", {
        Text = Translations:GetTranslation("Enable Player List"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
    })

    self.RobloxGroup:AddToggle("EnableHealthBar", {
        Text = Translations:GetTranslation("Enable Health Bar"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
    })

    self.RobloxGroup:AddToggle("EnableBackpack", {
        Text = Translations:GetTranslation("Enable Backpack"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
    })

    self.RobloxGroup:AddToggle("EnableChat", {
        Text = Translations:GetTranslation("Enable Chat"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
    })

    self.RobloxGroup:AddToggle("EnableEmotesMenu", {
        Text = Translations:GetTranslation("Enable Emotes Menu"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
    })

    self.RobloxGroup:AddToggle("EnableSelfView", {
        Text = Translations:GetTranslation("Enable Self View"),
        Tooltip = Translations:GetTranslation("Avatar \"selfie\" (with facial capture enabled)"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)
    })

    self.RobloxGroup:AddToggle("EnableCaptureButton", {
        Text = Translations:GetTranslation("Enable Capture Button"),
        Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures)
    })

    self.RobloxGroup:AddDivider()

    self.RobloxGroup:AddToggle("DevConsole", {
        Text = Translations:GetTranslation("Dev Console"),
        Default = shared.StarterGui:GetCore("DevConsoleVisible")
    })

    self.RobloxGroup:AddToggle("AvatarContextMenu", {
        Text = Translations:GetTranslation("Avatar Context Menu"),
        Tooltip = Translations:GetTranslation("Left-clicking on a player's avatar will pop up a context menu, and stop you from moving\n(which players who enjoy Natural Disaster Survival should be very familiar with)"),
        Default = shared.StarterGui:GetCore("AvatarContextMenuEnabled")
    })

    --// Roblox Groupbox OnChanged/Connection
    shared.Connection:GiveSignal("RobloxGuiLoop", shared.RunService.PreRender:Connect(function()
        shared.StarterGui:SetCore("ResetButtonCallback",      self.Toggles.EnableReset.Value)
        shared.StarterGui:SetCore("AvatarContextMenuEnabled", self.Toggles.AvatarContextMenu.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, self.Toggles.EnablePlayerList.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health,     self.Toggles.EnableHealthBar.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,   self.Toggles.EnableBackpack.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,       self.Toggles.EnableChat.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, self.Toggles.EnableEmotesMenu.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.SelfView,   self.Toggles.EnableSelfView.Value)
        shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures,   self.Toggles.EnableCaptureButton.Value)
    end))

    self.Toggles.DevConsole:OnChanged(function(Enabled)
        shared.StarterGui:SetCore("DevConsoleVisible", Enabled)
    end)

    --[[--// Decompiler Groupbox (Right)
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

        shared.Connection:GiveSignal("DecompilationInfo", self.InfoInstance:GetPropertyChangedSignal("Value"):Connect(function()
            if not self.Running then
                shared.Connection:DisconnectSignal("DecompilationInfo")
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
        Decompiler["LocalScript"] = table.find(Classes, "LocalScript") and true or false
        Decompiler["ModuleScript"] = table.find(Classes, "ModuleScript") and true or false
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
    end)]]

    --// Settings Tab //
    wax.shared.SettingsTab = self.Window:AddTab(Translations:GetTranslation("Settings"), "settings")
    self.SettingsTab = wax.shared.SettingsTab

    --// Menu Groupbox (Left)
    wax.shared.MenuGroup = self.SettingsTab:AddLeftGroupbox(Translations:GetTranslation("Menu"))
    self.MenuGroup = wax.shared.MenuGroup

    self.MenuGroup:AddToggle("OpenKeybindMenu", {
        Text = Translations:GetTranslation("Open Keybind Menu"),
        Default = self.Library.KeybindFrame.Visible
    })

    self.MenuGroup:AddToggle("ShowCustomCursor", {
        Text = Translations:GetTranslation("Show Custom Cursor"),
        Default = shared.CustomCursor
    })

    self.MenuGroup:AddToggle("ForceCheckbox", {
        Text = Translations:GetTranslation("Force Checkbox"),
        Default = shared.ForceCheckbox
    })

    self.MenuGroup:AddLabel(Translations:GetTranslation("Open Menu Key")):AddKeyPicker("OpenMenu", {
        Default = "RightControl",
        Mode = "Toggle",
        NoUI = true
    })

    self.MenuGroup:AddDivider()

    self.MenuGroup:AddToggle("BloxstrapRPC", {
        Text = Translations:GetTranslation("Bloxstrap RPC"),
        Default = false
    })

    self.MenuGroup:AddButton({
        Text = Translations:GetTranslation("Unload"),
        DoubleClick = true,
        Func = wax.shared.OnUnload
    })

    --// Menu Groupbox OnChanged
    self.Toggles.OpenKeybindMenu:OnChanged(function(Enabled)
        shared.KeybindFrame = Enabled
        self.Library.KeybindFrame.Visible = Enabled

        FileHelper:WriteFile("MFeee~New/KeybindFrame.txt", tostring(Enabled))
    end)

    self.Toggles.ShowCustomCursor:OnChanged(function(Enabled)
        shared.CustomCursor = Enabled
        self.Library.ShowCustomCursor = Enabled

        FileHelper:WriteFile("MFeee~New/CustomCursor.txt", tostring(Enabled))
    end)

    self.Toggles.ForceCheckbox:OnChanged(function(Enabled)
        shared.ForceCheckbox = Enabled
        self.Library.ForceCheckbox = Enabled

        FileHelper:WriteFile("MFeee~New/ForceCheckbox.txt", tostring(Enabled))
    end)

    self.Library.ToggleKeybind = self.Options.OpenMenu

    self.Toggles.BloxstrapRPC:OnChanged(function(Enabled)
        wax.shared.BloxstrapRPC.Enabled = Enabled
        wax.shared.BloxstrapRPC.SetRichPresence()
    end)

    if shared.UseRPC then
        self.Toggles.BloxstrapRPC:SetValue(true)
    end

    --// UI Groupbox (Right)
    wax.shared.UiGroup = self.SettingsTab:AddRightGroupbox(Translations:GetTranslation("UI"))
    self.UiGroup = wax.shared.UiGroup

    self.UiGroup:AddDropdown("ChangeLanguage", {
        Text = Translations:GetTranslation("Change Language"),
        Values = {
            "English",
            "简体中文"
        },
        Default = Translations.Registry[wax.shared.Language]
    })

    self.UiGroup:AddDropdown("WindowStyle", {
        Text = Translations:GetTranslation("Window Style"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = Translations:GetTranslation(shared.WindowStyle)
    })

    self.UiGroup:AddDropdown("DPIScale", {
        Text = Translations:GetTranslation("DPI Scale"),
        Values = {
            "50%",
            "75%",
            "100%",
            "125%",
            "150%",
            "175%",
            "200%"
        },
        Default = `{tostring(shared.DPIScale * 100)}%`,
    })

    self.UiGroup:AddSlider("UICorner", {
        Text = Translations:GetTranslation("UI Corner"),
        Tooltip = Translations:GetTranslation("Restart to Apply"),
        Default = shared.UiCorner,
        Min = 0,
        Max = 10,
        Suffix = "px"
    })

    self.UiGroup:AddDivider()

    self.UiGroup:AddDropdown("NotifySide", {
        Text = Translations:GetTranslation("Notify Side"),
        Values = {
            Translations:GetTranslation("Top Left"),
            Translations:GetTranslation("Top Right"),
            Translations:GetTranslation("Bottom Left"),
            Translations:GetTranslation("Bottom Right")
        },
        Default = Translations:GetTranslation(shared.NotifySide)
    })

    self.UiGroup:AddDropdown("NotifySound", {
        Text = Translations:GetTranslation("Notify Sound"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = Translations:GetTranslation(shared.NotifySound)
    })

    self.UiGroup:AddInput("NotifySoundID", {
        Text = Translations:GetTranslation("Notify Sound ID"),
        Default = "rbxassetid://",
        EmptyReset = "rbxassetid://",
        Placeholder = "rbxassetid://",
        ClearTextOnFocus = false
    })

    self.UiGroup:AddSlider("NotifyVolume", {
        Text = Translations:GetTranslation("Notify Volume"),
        Default = 200,
        Min = 0,
        Max = 1000,
        Suffix = "%"
    })

    local TestNotify = Translations:GetTranslation("Test Notify")

    self.UiGroup:AddButton(TestNotify, function()
        self:Notify({
            Title = TestNotify,
            Description = TestNotify,
            Duration = 3
        })
    end)

    --// UI Groupbox OnChanged
    self.Options.ChangeLanguage:OnChanged(function(Language)
        FileHelper:WriteFile("MFeee~New/Language.txt", Language == "English" and "en" or "zh-cn")

        self:Notify(Translations:GetTranslation("Restart to Apply"))
    end)

    self.Options.WindowStyle:OnChanged(function(Style)
        FileHelper:WriteFile("MFeee~New/WindowStyle.txt", Style == "Obsidian" and "Obsidian" or "Linoria")

        self:Notify(Translations:GetTranslation("Restart to Apply"))
    end)

    self.Options.DPIScale:OnChanged(function(Scale)
        local DPI = tonumber(string.sub(Scale, 1, -2))
        if not DPI then return end

        DPI = DPI / 100
        FileHelper:WriteFile("MFeee~New/DPIScale.txt", tostring(DPI))

        self.Library:SetDPIScale(DPI)
    end)

    self.Options.UICorner:OnChanged(function(Corner)
        FileHelper:WriteFile("MFeee~New/UiCorner.txt", tostring(Corner))
        
        self:Notify(Translations:GetTranslation("Restart to Apply"))
    end)

    self.Options.NotifySide:OnChanged(function(Side)
        local RealSide
        if Side == Translations:GetTranslation("Top Left") then
            RealSide = "TopLeft"
        elseif Side == Translations:GetTranslation("Top Right") then
            RealSide = "TopRight"
        elseif Side == Translations:GetTranslation("Bottom Left") then
            RealSide = "BottomLeft"
        elseif Side == Translations:GetTranslation("Bottom Right") then
            RealSide = "BottomRight"
        end

        FileHelper:WriteFile("MFeee~New/NotifySide.txt", RealSide)
        self.Library:SetNotifySide(RealSide)
    end)

    self.Options.NotifySound:OnChanged(function(Sound)
        local SoundID = Sound == "Obsidian" and 4590662766 or 4590657391
        self.NotifySoundID = `rbxassetid://{SoundID}`

        FileHelper:WriteFile("MFeee~New/NotifySound.txt", Sound)
    end)

    self.Options.NotifySoundID:OnChanged(function(SoundID)
        if not SoundID:match("^rbxassetid://%d+$") then
            self.Options.NotifySoundID:SetValue("rbxassetid://")
            return
        end

        self.NotifySoundID = SoundID
    end)

    self.Options.NotifyVolume:OnChanged(function(Volume)
        self.NotifyVolume = Volume / 100
    end)

    --// Info Tab //
    wax.shared.InfoTab = self.Window:AddTab(Translations:GetTranslation("Info"), "info")
    self.InfoTab = wax.shared.InfoTab

    --// Developers Groupbox (Left)
    wax.shared.DevelopersGroup = self.InfoTab:AddLeftGroupbox(Translations:GetTranslation("Developers"))
    self.DevelopersGroup = wax.shared.DevelopersGroup

    self.DevelopersGroup:AddLabel({
        Text = `[<font color="#1f6feb">MaiFengYXD</font>] {Translations:GetTranslation("Owner, developer")}`,
        DoesWrap = true
    })

    --// Credits Groupbox (Left)
    wax.shared.CreditsGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("Credits"))
    self.CreditsGroup = wax.shared.CreditsGroup

    self.CreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">upio</font>] {Translations:GetTranslation("Teaches me how to use wax")}`,
        DoesWrap = true
    })

    self.CreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">mspaint</font>] {Translations:GetTranslation("Gives me inspiration")}`,
        DoesWrap = true
    })

    self.CreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">GitHub Copilot</font>] {Translations:GetTranslation("Helps complete code")}`,
        DoesWrap = true
    })

    self.CreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">Google Gemini</font>] {Translations:GetTranslation("Helps translate (English)")}`,
        DoesWrap = true
    })

    self.CreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">{Translations:GetTranslation("And you!")}</font>] {Translations:GetTranslation("For using my script!")}`,
        DoesWrap = true
    })

    --// Spechial Thanks Groupbox (Left)
    wax.shared.ThanksGroup = self.InfoTab:AddLeftGroupbox(Translations:GetTranslation("Special Thanks"))
    self.ThanksGroup = wax.shared.ThanksGroup

    self.ThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">latte-soft</font>] {Translations:GetTranslation("Wax bundler")}`,
        DoesWrap = true
    })

    self.ThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">deividcomsono</font>] {Translations:GetTranslation("Obsidian UI Library")}`,
        DoesWrap = true
    })

    self.ThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">mstudio45</font>] {Translations:GetTranslation("Linoria UI Library and ESP Library")}`,
        DoesWrap = true
    })

    self.ThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">Exunys</font>] {Translations:GetTranslation("Aimbot Inspiration")}`,
        DoesWrap = true
    })

    self.ThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">7GrandDadPGN</font>] {Translations:GetTranslation("SilentAim Inspiration")}`,
        DoesWrap = true
    })

    --// About Game Groupbox (Right)
    wax.shared.AboutGameGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("About Game"))
    self.AboutGameGroup = wax.shared.AboutGameGroup

    self.PlayedLabel = self.AboutGameGroup:AddLabel()

    self.TimeRunningLabel = self.AboutGameGroup:AddLabel()

    self.GameNameLabel = self.AboutGameGroup:AddLabel()

    self.AboutGameGroup:AddButton({
        Text = Translations:GetTranslation("Place Id: %s"):format(game.PlaceId),
        Func = function()
            shared.ToClipboard(game.PlaceId)
            self:Notify(Translations:GetTranslation("Place Id Copied"))
        end
    })

    --// About Game Group Update
    local function ConvertTime(Time: number): string
        local Hour = math.floor(Time / 3600)
        local Minute = math.floor(Time / 60) % 60
        local Second = math.floor(Time % 60)

        return string.format("%02d:%02d:%02d", Hour, Minute, Second)
    end

    shared.Connection:GiveSignal("YouPlayedLabel", shared.RunService.Stepped:Connect(function()
        local Time = ConvertTime(shared.Workspace.DistributedGameTime)
        self.PlayedLabel:SetText(Translations:GetTranslation("You Played: %s"):format(Time))
    end))

    shared.Connection:GiveSignal("TimeRunningLabel", shared.RunService.Stepped:Connect(function()
        local Time = ConvertTime(elapsedTime())
        self.TimeRunningLabel:SetText(Translations:GetTranslation("Time Running: %s"):format(Time))
    end))

    task.spawn(function()
        shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
        self.GameNameLabel:SetText(Translations:GetTranslation("Game Name: %s"):format(shared.GameName))
    end)

    --// Links Groupbox (Right)
    wax.shared.LinksGroup = self.InfoTab:AddRightGroupbox(Translations:GetTranslation("Links"))
    self.LinksGroup = wax.shared.LinksGroup

    self.LinksGroup:AddButton({
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
