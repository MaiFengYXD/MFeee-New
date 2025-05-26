--[[

$$\      $$\ $$$$$$$$\                              ~
$$$\    $$$ |$$  _____|                              
$$$$\  $$$$ |$$ |       $$$$$$\   $$$$$$\   $$$$$$\  
$$\$$\$$ $$ |$$$$$\    $$  __$$\ $$  __$$\ $$  __$$\ 
$$ \$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |
$$ |\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|
$$ | \_/ $$ |$$ |      \$$$$$$$\ \$$$$$$$\ \$$$$$$$\ 
\__|     \__|\__|       \_______| \_______| \_______|

[+] Creator | MaiFengYXD
[+] License | MIT
[+] Version | Build 1

[~] This script was bundled by Wax, and is NOT intended to be modified.
[~] View the source code in the 'Src' folder at https://github.com/MaiFengYXD/MFeee-New.
[~] Join my Discord channel: https://discord.gg/YBQUd8X8PK.

--]]

--!nocheck
--!nolint
--!optimize 2

-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Holds direct closure data
local ClosureBindings = {
    function(shared, wax, script, require)
        local pcall
            = pcall

        wax.Unloaded = false

        --// Pre-Checks //
        require("Utils/Services"):GetServices({
            "ContextActionService",
            "MarketplaceService",
            "CollectionService",
            "ReplicatedStorage",
            "UserInputService",
            "ContentProvider",
            "SoundService",
            "TweenService",
            "TextService",
            "HttpService",
            "StarterGui",
            "RunService",
            "Workspace",
            "Players",
            "Teams"
        })

        shared.Speaker = shared.Players.LocalPlayer

        if type(getgenv) ~= "function" then
            shared.Speaker:Kick("This script doesn't support non-executor environments.");return
        end

        local Global = getgenv()

        local function Notify(Title: string, Text: string)
            print(`[MFeee~ New] {Title} {Text}`)

            shared.StarterGui:SetCore("SendNotification", {
                Title    = Title,
                Text     = Text,
                Button1  = "Close",
                Duration = 30
            })
        end

        wax.shared.MiniNotify = Notify

        if Global.MFeeeLoaded  then Notify("Loading Stopped!", "Error: already loaded.") ;return end
        if Global.MFeeeLoading then Notify("Loading Stopped!", "Error: already loading.");return end

        Global.MFeeeLoading = true
        Global.MFeeeLoaded  = false

        task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
            "rbxassetid://103134660123798",
            "rbxassetid://77335290652571",
            "rbxassetid://4590662766",
            "rbxassetid://4590657391"
        })

        if not game:IsLoaded() then game.Loaded:Wait() end

        shared.PlayerGui = shared.Speaker:FindFirstChildOfClass("PlayerGui") or (function(IsA, Wait, ChildAdded)
            local PlayerGui

            repeat
                PlayerGui = Wait(ChildAdded)
            until IsA(PlayerGui, "PlayerGui")

            return PlayerGui
        end)(game.IsA, game.Close.Wait, shared.Speaker.ChildAdded)

        do
            local table_insert, unpack
                = table.insert, unpack

            local OnUnloadFunctions = {} :: {{any}}

            function wax.Unload()
                if wax.Unloaded then return end

                local pcall, task_defer
                    = pcall, task.defer

                for _, Bundled in OnUnloadFunctions do
                    task_defer(pcall, Bundled[1], unpack(Bundled[2]))
                end
                OnUnloadFunctions = table.clear(OnUnloadFunctions)

                Global.MFeeeLoaded  = false
                Global.MFeeeLoading = false

                wax.Unloaded = true
            end

            function wax.AddOnUnload(Callback: () -> (), ...: any)
                table_insert(OnUnloadFunctions, {(Callback :: any), {...}})
            end
        end

        --// Start to Load //
        wax.shared.TempStorage = {}

        task.spawn(function()
            while not (pcall(function()
                wax.shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
            end) and wax.shared.GameName) do end
        end)

        shared.Camera = shared.Workspace.CurrentCamera

        wax.shared.Emoji           = require("Utils/ArtEmoji")
        wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
        wax.shared.FileHelper      = require("Utils/FileHelper")

        do
            local utf8_char
                = utf8.char

            local Random      = Random.new()
            local NextInteger = Random.NextInteger

            function Global.randomstring(Length: number | nil): string
                local String = ""

                for _ = 1, Length or 16 do
                    String ..= utf8_char(NextInteger(Random, 0, 1114111))
                end

                return String
            end
        end

        do
            local Color3_fromHSV, tick
                = Color3.fromHSV, tick

            function Global.getrainbowcolor(RainbowSpeed: number | nil): Color3
                return Color3_fromHSV((tick() * (RainbowSpeed or 0.4)) % 1, 1, 1)
            end
        end

        shared.Connect = require("Utils/Connect")

        wax.shared.AllowedLanguages = {
            ["am"] = "አማርኛ",
            ["ar"] = "العربية",
            ["az"] = "Azərbaycan dili",
            ["de"] = "Deutsch",
            ["en"] = "English",
            ["es"] = "Español",
            ["et"] = "Eesti",
            ["fa"] = "فارسی",
            ["fr"] = "Français",
            ["hi"] = "हिन्दी",
            ["hr"] = "Hrvatski",
            ["hu"] = "Magyar",
            ["id"] = "Bahasa Indonesia",
            ["ja"] = "日本語",
            ["kz"] = "Қазақ тілі",
            ["ms"] = "Bahasa Melayu",
            ["pt"] = "Português",
            ["ru"] = "Русский язык",
            ["sv"] = "Svenska",
            ["tr"] = "Türkçe",
            ["uk"] = "Українська мова",
            ["ur"] = "اردو",
            ["vi"] = "Tiếng Việt",
            ["zh-cn"  ] = "简体中文",
            ["zh-hant"] = "繁體中文"
        }

        wax.shared.Language = wax.shared.FileHelper:CheckFile("MFeee-New/Language.txt", "en", wax.shared.AllowedLanguages)

        do
            wax.shared.ScriptName    = "Universal"
            wax.shared.ScriptFolder  = "Universal"
            wax.shared.ScriptDisplay = "Universal"

            local Mappings = require("Mappings")
            local Mapping  = Mappings[game.PlaceId]

            if Mapping then
                wax.shared.ScriptName    = Mapping.Name
                wax.shared.ScriptFolder  = Mapping.Folder
                wax.shared.ScriptDisplay = Mapping.Display
            end
        end

        do
            local tonumber, string_match, table_sort
                = tonumber, string.match, table.sort

            function wax.shared.Sequencing(Table: table): table
                table_sort(Table, function(A, B)
                    local NumA = tonumber(string_match(A.Name, "^(%d+)%."))
                    local NumB = tonumber(string_match(B.Name, "^(%d+)%."))

                    return NumA < NumB
                end)

                return Table
            end
        end

        wax.shared.Translations  = require("Translations")
        wax.shared.EasingLibrary = require("Utils/EasingLibrary")

        shared.Connect:GiveSignal("CameraChangedSignal" , shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            shared.Camera  = shared.Workspace.CurrentCamera
        end))

        shared.Connect:GiveSignal("SpeakerChangedSignal", shared.Players  :GetPropertyChangedSignal("LocalPlayer"  ):Connect(function()
            shared.Speaker = shared.Players  .LocalPlayer
        end))

        --// Loader //
        wax.shared.ScriptVersion = "Build 1"

        wax.shared.UiManager = require("Utils/Gui/UIManager")
        wax.shared.Window    = wax.shared.UiManager:CreateWindow();

        (require :: Function)((`Places/Loader/{wax.shared.ScriptFolder}`) :: string)

        wax.shared.UiManager:CreateUniversalTabs()

        wax.shared.UiManager.SaveManager :LoadAutoloadConfig()
        wax.shared.UiManager.ThemeManager:LoadDefault()

        Global.MFeeeLoaded  = true
        Global.MFeeeLoading = false

        task.spawn(pcall, function()
            local Version   = game:HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")
            assert(Version ~= wax.shared.ScriptVersion and #Version > 0)

            wax.shared.UiManager:Notify({
                Title       = wax.shared.Translations:GetTranslation("Version Mismatch"),
                Description = wax.shared.Translations:GetTranslation("The script version is outdated, please update it!"),
                Time        = 15
            })
        end)
    end,

    function(shared, wax, script, require)
        return {
            [77614252294790] = {
                Name = "The Foundation",
                Folder = "The Foundation/Game",
                Display = "THE FOUNDATION (Game)",
            },

            [18186775539] = {
                Name = "The Foundation",
                Folder = "The Foundation/Lobby",
                Display = "THE FOUNDATION (Lobby)",
            }
        }
    end,

    [6] = function(shared, wax, script, require)

    end,

    [7] = function(shared, wax, script, require)

    end,

    [8] = function(shared, wax, script, require)
        for _, Module: ModuleScript in (
            wax.shared.Sequencing(script.Parent.Parent.Tabs.Universal:GetChildren()) :: table
        ) do
            (require :: Function)(Module)
        end

        return {}
    end,

    [12] = function(shared, wax, script, require)

    end,

    [13] = function(shared, wax, script, require)

    end,

    [14] = function(shared, wax, script, require)

    end,

    [15] = function(shared, wax, script, require)

    end,

    [16] = function(shared, wax, script, require)

    end,

    [17] = function(shared, wax, script, require)

    end,

    [19] = function(shared, wax, script, require)

    end,

    [20] = function(shared, wax, script, require)

    end,

    [21] = function(shared, wax, script, require)

    end,

    [22] = function(shared, wax, script, require)

    end,

    [23] = function(shared, wax, script, require)

    end,

    [24] = function(shared, wax, script, require)

    end,

    [26] = function(shared, wax, script, require)
        return wax.shared.UiManager:CreateMainTab()
    end,

    [27] = function(shared, wax, script, require)
        return wax.shared.UiManager:CreatePlayerTab()
    end,

    [28] = function(shared, wax, script, require)
        return {}
    end,

    [29] = function(shared, wax, script, require)
        return {}
    end,

    [30] = function(shared, wax, script, require)
        return {}
    end,

    [31] = function(shared, wax, script, require)
        return {}
    end,

    [35] = function(shared, wax, script, require)
        --[[
        local Utils = {}

        local Support = wax.shared.ExecutorSupport
        local UiManager = wax.shared.UiManager
        local Translations = wax.shared.Translations
        local GetTranslation = Transitions.GetTranslation

        wax.shared.ClientModule = shared.Speaker:WaitForChild("PlayerGui"):WaitForChild("NotBrokenUI"):WaitForChild("CLIENT_MAIN"):WaitForChild("CLIENT")
        local ClientValues = wax.shared.ClientModule:WaitForChild("Values")

        local CurrentRoomValue = ClientValues:WaitForChild("CurrentRoom")
        wax.shared.CurrentRoomObject = CurrentRoomValue.Value

        local Rooms = shared.Workspace:WaitForChild("GeneratedRooms")

        shared.Connect:GiveSignal("CurrentRoomObjectChanged", CurrentRoomValue:GetPropertyChangedSignal("Value"):Connect(function()
            wax.shared.CurrentRoomObject = CurrentRoomValue.Value
        end))

        Utils.LadderSpeed = {
            Enabled = false,
            Speed = 10,

            Start = function(Enabled: boolean)
                local self = Utils.LadderSpeed
                self.Enabled = Enabled

                if Enabled then
                    local function DoBoost(Character)
                        pcall(function()
                            local Align = Character.AlignPosition

                            repeat
                                Align.MaxVelocity = self.Speed
                                task.wait()
                            until Align.Parent ~= Character
                        end)

                        shared.Connect:GiveSignal("LadderSpeedChildAdded", Character.ChildAdded:Connect(function(Child)
                            if Child:IsA("AlignPosition") then
                                repeat
                                    Child.MaxVelocity = self.Speed
                                    task.wait()
                                until Child.Parent ~= Character
                            end
                        end))
                    end

                    local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
                    DoBoost(Character)

                    shared.Connect:GiveSignal("LadderSpeedCharacterAdded", shared.Speaker.CharacterAdded:Connect(DoBoost))
                else
                    shared.Connect:DisconnectSignal("LadderSpeedChildAdded")
                    shared.Connect:DisconnectSignal("LadderSpeedCharacterAdded")

                    pcall(function()
                        shared.Speaker.Character.AlignPosition.MaxVelocity = 10
                    end)
                end
            end
        }

        Utils.AntiScreech = {
            Enabled = false,
            ScreechValue = ClientValues:WaitForChild("ScreechActive"),

            Start = function(Enabled: boolean)
                local self = Utils.AntiScreech
                self.Enabled = Enabled

                if Enabled then
                    self.ScreechValue.Value = true

                    shared.Connect:GiveSignal("ScreechValueChanged", self.ScreechValue:GetPropertyChangedSignal("Value"):Connect(function()
                        self.ScreechValue.Value = true
                    end))
                else
                    shared.Connect:DisconnectSignal("ScreechValueChanged")
                    self.ScreechValue.Value = false
                end
            end
        }

        Utils.DoorReach = {
            Enabled = false,
            Multiplier = 1,

            Origin = Vector3.new(11, 7.4, 11),
            DoorHitboxes = {},

            Handle = function(self)
                table.clear(self.DoorHitboxes)

                for _, Object in Rooms:GetDescendants() do
                    if Object:IsA("Folder") and Object.Name == "Assets" then
                        for _, Door in Object:GetChildren() do
                            if not Door:IsA("Model") or Door.Name ~= "OpenableDoor" then continue end

                            local Hitbox = Door:FindFirstChild("Hitbox")
                            if not (Hitbox and Hitbox:IsA("Part")) then continue end

                            self.DoorHitboxes[Hitbox] = Hitbox
                        end
                    elseif Object:IsA("Folder") and Object.Name == "Important" then
                        local Trigger = Object:FindFirstChild("DoorTrigger")
                        if not (Trigger and Trigger:IsA("Part")) then continue end

                        self.DoorHitboxes[Trigger] = Trigger
                    end

                    if not Object:IsA("Model") then continue end
                    if Object.Name ~= "Door" and Object.Name ~= "DoorNormal" then continue end

                    local Hitbox = Object:FindFirstChild("Hitbox")
                    if not (Hitbox and Hitbox:IsA("Part")) then continue end

                    self.DoorHitboxes[Hitbox] = Hitbox
                end

                for Object in self.DoorHitboxes do
                    Object.Size = self.Origin * if self.Enabled then self.Multiplier else 1
                end
            end,

            Start = function(Enabled: boolean)
                local self = Utils.DoorReach
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("DoorReachDescendantAdded", Rooms.DescendantAdded:Connect(function(Descendant)
                        if (
                           Descendant.Name == "Hitbox" and
                           Descendant:IsA("Part") and
                           (Descendant.Parent.Name == "Door" or Descendant.Parent.Name == "DoorNormal")
                        )
                        then
                            self.DoorHitboxes[Descendant] = Descendant
                            Descendant.Size = self.Origin * if self.Enabled then self.Multiplier else 1
                        end
                    end))

                    shared.Connect:GiveSignal("DoorReachDescendantRemoving", Rooms.DescendantRemoving:Connect(function(Descendant)
                        self.DoorHitboxes[Descendant] = nil
                    end))
                else
                    shared.Connect:DisconnectSignal("DoorReachDescendantAdded")
                    shared.Connect:DisconnectSignal("DoorReachDescendantRemoving")
                end

                self:Handle()
            end,

            SetMultiplier = function(Multiplier: number)
                local self = Utils.DoorReach
                self.Multiplier = Multiplier

                for Object in self.DoorHitboxes do
                    Object.Size = self.Origin * if self.Enabled then self.Multiplier else 1
                end
            end
        }

        Utils.AntiDarkRoom = {
            Enabled = false,
            DarkRoomValue = ClientValues:WaitForChild("IsCurrentRoomDark"),
            BrightRooms = {},

            Start = function(Enabled: boolean)
                local self = Utils.AntiDarkRoom
                self.Enabled = Enabled

                if Enabled then
                    self.DarkRoomValue.Value = false

                    shared.Connect:GiveSignal("DarkRoomValueChanged", self.DarkRoomValue:GetPropertyChangedSignal("Value"):Connect(function()
                        self.DarkRoomValue.Value = false
                    end))

                    for _, Object in wax.shared.CurrentRoomObject:GetChildren() do
                        if not Object:HasTag("DarkRoom") then continue end

                        shared.CollectionService:RemoveTag(Object, "DarkRoom")
                        table.insert(self.BrightRooms, Object)
                    end

                    shared.Connect:GiveSignal("DarkRoomAdded", wax.shared.CurrentRoomObject.ChildAdded:Connect(function(Object)
                        if not Object:HasTag("DarkRoom") then return end

                        shared.CollectionService:RemoveTag(Object, "DarkRoom")
                        table.insert(self.BrightRooms, Object)
                    end))
                else
                    shared.Connect:DisconnectSignal("DarkRoomValueChanged")
                    shared.Connect:DisconnectSignal("DarkRoomAdded")

                    for _, Object in self.BrightRooms do
                        if Object.Parent ~= wax.shared.CurrentRoomObject then continue end
                        shared.CollectionService:AddTag(Object, "DarkRoom")
                    end
                end
            end
        }

        Utils.AntiVoid = {
            Enabled = false,
            Script = Support.require and require(wax.shared.ClientModule:WaitForChild("CurrentRoomDependency"):WaitForChild("Modules"):WaitForChild("Void")),
            OldFunction = nil,

            Start = function(Enabled: boolean)
                local self = Utils.AntiVoid
                self.Enabled = Enabled

                if Enabled then
                    if not self.OldFunction and self.Script then
                        self.OldFunction = self.Script.VoidPlayer
                        self.Script.VoidPlayer = function() end
                    end
                else
                    if not (self.OldFunction and self.Script) then return end

                    self.Script.VoidPlayer = self.OldFunction
                end
            end
        }

        Utils.AutoBreaker = {
            Enabled = false,
            AutoPlayMode = "Auto" :: "Auto" | "Skip",
            Script = Support.require and require(wax.shared.ClientModule:WaitForChild("BreakerMinigame")),
            Event = shared.ReplicatedStorage:WaitForChild("Events"):WaitForChild("TheObservatory"):WaitForChild("BeatPuzzle"),
            OldRunNumber = nil,

            Condition = function(Object: Instance)
                return not (
                    Object:IsA("Model") and
                    Object.Name == "Minigame" and
                    Object:FindFirstChild("Switches")
                )
            end,

            Start = function(Enabled: boolean)
                local self = Utils.AutoBreaker
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("AutoBreakerDescendantAdded", Rooms.DescendantAdded:Connect(function(Descendant)
                        if self.AutoPlayMode ~= "Skip" then return end
                        if self.Condition(Descendant) then return end

                        while Descendant.Parent.Parent ~= wax.shared.CurrentRoomObject do
                            task.wait()
                        end

                        self.Event:FireServer()
                    end))

                    if self.AutoPlayMode == "Skip" then
                        for _, Object in wax.shared.CurrentRoomObject:GetDescendants() do
                            if self.Condition(Object) then continue end

                            self.Event:FireServer()
                            break
                        end

                        return
                    end

                    if self.OldRunNumber or not self.Script then return end

                    self.OldRunNumber = self.Script.RunNumbers
                    self.Script.RunNumbers = function(Self, NumberMap, Speed)
                        task.spawn(self.OldRunNumber, Self, NumberMap, Speed)

                        for NumberString, ShouldBeOn in NumberMap do
                            task.wait(Speed ~= Speed and 0.5 or Speed)

                            local Switch = Self.SwitchesFolder:FindFirstChild(`Unit{NumberString}`)
                            if not Switch then continue end

                            local Status = Switch:GetAttribute("Status")

                            if Status and not ShouldBeOn then
                                Self.AllSwitches[Switch].TurnOff(true, false)
                            elseif not Status and ShouldBeOn then
                                Self.AllSwitches[Switch].TurnOn(true, false)
                            end
                        end
                    end
                else
                    shared.Connect:DisconnectSignal("AutoBreakerDescendantAdded")

                    if not (self.OldRunNumber and self.Script) then return end

                    self.Script.RunNumbers = self.OldRunNumber
                    self.OldRunNumber = nil
                end
            end
        }

        Utils.AntiStare = {
            Enabled = false,
            Remote = shared.ReplicatedStorage:WaitForChild("Events"):WaitForChild("Entities"):WaitForChild("Stare"):WaitForChild("RequestIfCanSee"),
            Module = Support.require and require(wax.shared.ClientModule:WaitForChild("EntityModules"):WaitForChild("Stare")),

            Start = function(Enabled: boolean)
                local self = Utils.AntiStare
                self.Enabled = Enabled

                while task.wait() and self.Enabled do
                    function self.Remote.OnClientInvoke(...)
                        return typeof(shared.Workspace:FindFirstChild("Stare")) == "Instance"
                    end
                end

                if Enabled then return end

                if self.Module then
                    self.Module.Init()
                end
            end
        }

        Utils.GetFreeBadges = function()
            for _, Object in game:GetDescendants() do
                if Object:IsA("RemoteEvent") and Object.Name:find("Badge") then
                    Object:FireServer()
                end
            end
        end

        Utils.AntiDecoyLockers = {
            Enabled = false,
            DecoyLockers = {},

            Handle = function(self)
                table.clear(self.DecoyLockers)

                for _, Object in Rooms:GetDescendants() do
                    if not Object:IsA("Model") then continue end
                    if Object.Name ~= "decoyLocker" then continue end

                    local Attacker = Object:FindFirstChild("AttackRange")
                    if not (Attacker and Attacker:IsA("Part")) then continue end

                    self.DecoyLockers[Attacker] = Attacker
                end

                for Object in self.DecoyLockers do
                    Object.CanTouch = not self.Enabled
                end
            end,

            Start = function(Enabled: boolean)
                local self = Utils.AntiDecoyLockers
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("DecoyLockerDescendantAdded", Rooms.DescendantAdded:Connect(function(Descendant)
                        if Descendant.Name == "AttackRange" and Descendant:IsA("Part") and Descendant.Parent.Name == "decoyLocker" then
                            self.DecoyLockers[Descendant] = Descendant
                            Descendant.CanTouch = not self.Enabled
                        end
                    end))

                    shared.Connect:GiveSignal("DecoyLockerDescendantRemoving", Rooms.DescendantRemoving:Connect(function(Descendant)
                        self.DecoyLockers[Descendant] = nil
                    end))
                else
                    shared.Connect:DisconnectSignal("DecoyLockerDescendantAdded")
                    shared.Connect:DisconnectSignal("DecoyLockerDescendantRemoving")
                end

                self:Handle()
            end
        }

        Utils.SkipSeek = {
            Enabled = false,
            SeekTriggers = {},

            SeekRoomCondition = function(self, Object: Instance)
                if not Object:IsA("Model") then return end

                local Scriptable = Object:FindFirstChild("Scriptable")
                local Trigger = Scriptable and Scriptable:FindFirstChild("Trigger")
                if not (Trigger and Trigger:IsA("Part")) then return end

                local Seek = Scriptable:FindFirstChild("Seek")
                if not (Seek and Seek:FindFirstChildOfClass("Humanoid")) then return end

                self.SeekTriggers[Trigger] = Trigger
            end,

            SewerCondition = function(self, Object: Instance)
                if not Object:IsA("Model") then return end

                local Scriptable = Object:FindFirstChild("Scriptable")
                local Trigger = Scriptable and Scriptable:FindFirstChild("Trigger")
                if not (Trigger and Trigger:IsA("Part")) then return end

                local Cutscene = Scriptable:FindFirstChild("Cutscene")
                local Seek = Cutscene and Cutscene:FindFirstChild("Seek")
                if not (Seek and Seek:FindFirstChildOfClass("Humanoid")) then return end

                self.SeekTriggers[Trigger] = Trigger
            end,

            EndChasingCondition = function(self, Object: Instance)
                if not Object:IsA("Model") then return end

                local Scriptable = Object:FindFirstChild("Scriptable")
                if not (Scriptable and Scriptable:IsA("Folder")) then return end

                local Barrier, MainSequence, Wall =
                    Scriptable:FindFirstChild("Barrier"),
                    Scriptable:FindFirstChild("MainSequence"),
                    Scriptable:FindFirstChild("Wall")
                if not (Barrier and MainSequence and Wall) then return end

                local Start = Scriptable:FindFirstChild("Start")
                local Hitbox = Start and Start:FindFirstChild("Hitbox")
                if not (Hitbox and Hitbox:IsA("Part")) then return end

                local EndHitbox = Scriptable:FindFirstChild("EndSequenceHitbox")
                if not (EndHitbox and EndHitbox:IsA("Part")) then return end

                self.SeekTriggers[Hitbox] = Hitbox
                self.SeekTriggers[EndHitbox] = EndHitbox
            end,

            Start = function(Enabled: boolean)
                local self = Utils.SkipSeek
                self.Enabled = Enabled

                for _, Object in Rooms:GetChildren() do
                    self:SeekRoomCondition(Object)
                    self:SewerCondition(Object)
                    self:EndChasingCondition(Object)
                end

                for Object in self.SeekTriggers do
                    Object.CanTouch = not self.Enabled
                end

                if Enabled then
                    shared.Connect:GiveSignal("SkipSeekChildAdded", Rooms.ChildAdded:Connect(function(Child)
                        task.wait()

                        self:SeekRoomCondition(Child)
                        self:SewerCondition(Child)
                        self:EndChasingCondition(Child)

                        for Object in self.SeekTriggers do
                            Object.CanTouch = not self.Enabled
                        end
                    end))
                else
                    shared.Connect:DisconnectSignal("SkipSeekChildAdded")
                end
            end
        }

        Utils.AutoCageMinigame = {
            Enabled = false,
            Event = shared.ReplicatedStorage:WaitForChild("Events"):WaitForChild("ThePrision"):WaitForChild("MinigameFinished"),
            AutoPlayMode = "Position" :: "Size" | "Position" | "Skip",
            ConnectionIds = {},

            Function = function(self)
                if not self.Enabled then return end
                local ClientMain = wax.shared.ClientModule.Parent

                for _, Ui in ClientMain:GetChildren() do
                    if Ui.Name ~= "CageMinigame" then continue end

                    local Bar = Ui.CageMinigameUI.Minigame.ZBar.Bar
                    local Region = Ui.CageMinigameUI.Minigame.ZBar.Region

                    if self.AutoPlayMode == "Size" then
                        shared.Connect:GiveSignal(`AutoCageMinigameChanged{Ui}`, Bar:GetPropertyChangedSignal("Size"):Connect(function()
                            Bar.Size = UDim2.fromScale(1, 4.378)
                        end))

                        self.ConnectionIds[Ui] = Ui
                        Bar.Size = UDim2.fromScale(1, 4.378)
                    elseif self.AutoPlayMode == "Position" then
                        shared.Connect:GiveSignal(`AutoCageMinigameChanged{Ui}`, Bar:GetPropertyChangedSignal("Position"):Connect(function()
                            Region.Position = Bar.Position
                        end))

                        self.ConnectionIds[Ui] = Ui
                        Bar.Position = UDim2.fromScale(0.5, 0.5)
                    end
                end
            end,

            Start = function(Enabled: boolean)
                local self = Utils.AutoCageMinigame
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("AutoCageMinigamePreRender", shared.RunService.PreRender:Connect(function()
                        if self.AutoPlayMode == "Skip" then
                            self.Event:FireServer()
                            return
                        end

                        pcall(self.Function, self)
                    end))
                else
                    shared.Connect:DisconnectSignal("AutoCageMinigamePreRender")

                    for Id in self.ConnectionIds do
                        shared.Connect:DisconnectSignal(`AutoCageMinigameChanged{Id}`)
                    end
                end
            end
        }

        Utils.NoCageMinigameDamages = {
            Enabled = false,
            Event = shared.ReplicatedStorage:WaitForChild("Events"):WaitForChild("ThePrision"):WaitForChild("CageDamage"),

            Start = function(Enabled: boolean)
                local self = Utils.NoCageMinigameDamages
                self.Enabled = Enabled

                if Enabled then
                    self.Event.Parent = nil
                else
                    self.Event.Parent = shared.ReplicatedStorage.Events.ThePrision
                end
            end
        }

        Utils.FixCamera = {
            Enabled = false,

            Start = function(Enabled: boolean)
                local self = Utils.FixCamera
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("FixCameraChanged", shared.Workspace.CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function()
                        shared.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    end))

                    shared.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
                else
                    shared.Connect:DisconnectSignal("FixCameraChanged")
                end
            end
        }

        Utils.AntiDeathPit = {
            Enabled = false,
            DeathPits = {},

            Handle = function(self)
                table.clear(self.DeathPits)

                for _, Object in Rooms:GetDescendants() do
                    if not (Object:IsA("Part") and Object.Name == "DeathPit") then continue end

                    Object.CanTouch = not self.Enabled
                    self.DeathPits[Object] = Object
                end
            end,

            Start = function(Enabled)
                local self = Utils.AntiDeathPit
                self.Enabled = Enabled

                if Enabled then
                    shared.Connect:GiveSignal("DeathPitDescendantAdded", Rooms.DescendantAdded:Connect(function(Descendant)
                        if not (Descendant:IsA("Part") and Descendant.Name == "DeathPit") then return end

                        Descendant.CanTouch = not self.Enabled
                        self.DeathPits[Descendant] = Descendant
                    end))
                else
                    shared.Connect:DisconnectSignal("DeathPitDescendantAdded")
                end

                self:Handle()
            end
        }

        Utils.NoCutscenes = {
            Enabled = false,
            Cutscenes = wax.shared.ClientModule:WaitForChild("CutsceneHandler"):WaitForChild("Cutscenes"):GetChildren(),

            Start = function(Enabled: boolean)
                local self = Utils.NoCutscenes
                self.Enabled = Enabled

                for _, Cutscene in self.Cutscenes do
                    if Cutscene.Name == "EndingCutscene" or Cutscene.Name == "CartCutscene" then continue end
                    Cutscene.Parent = if Enabled then nil else wax.shared.ClientModule:WaitForChild("CutsceneHandler"):WaitForChild("Cutscenes")
                end
            end
        }

        Utils.BeatThePrision = function()
            if wax.shared.CurrentRoomObject.Name ~= "Room150" then
                UiManager:Notify({
                    Title = GetTranslation(Translations, "Beat The Prision"),
                    Description = GetTranslation(Translations, "You need to beat Room 149 first!")
                })
            else
                shared.ReplicatedStorage.Events.ThePrision.FinishedTerminal:FireServer()
                UiManager:Notify({
                    Title = GetTranslation(Translations, "Beat The Prision"),
                    Description = GetTranslation(Translations, "You have beaten the prision!")
                })
            end
        end

        Utils.BeatFigureRooms = {
            Beating = false,

            Beat = function()
                local self = Utils.BeatFigureRooms

                if self.Beating then
                    UiManager:Notify({
                        Title = GetTranslation(Translations, "Beat Figure Rooms"),
                        Description = GetTranslation(Translations, "You are already beating the rooms!")
                    })
                    return
                end

                self.Beating = true

                local Character = shared.Speaker.Character
                if not Character then return end

                --// Match the Room with the Figure's Room
                local Matches = {}
                local Matched = false

                local function UpdateMatchs()
                    Matches = {}

                    for Number = 194, 199 do
                        Matches[`Room{Number}`] = Rooms:FindFirstChild(`Room{Number}`)
                    end

                    for _, State in Matches do
                        if typeof(State) == "Instance" then
                            Matched = true
                            break
                        end
                    end
                end
                UpdateMatchs()

                if not Matched then
                    UiManager:Notify({
                        Title = GetTranslation(Translations, "Beat Figure Rooms"),
                        Description = GetTranslation(Translations, "You are not in the right room! Please come to Room 194 first!")
                    })
                    return
                end

                if Matched.Room194 and not Matched.Room196 then
                    shared.ReplicatedStorage.Events.TheObservatory.BeatPuzzle:FireServer()

                    local Prompt = Matched.Room194.CaveLever.ProximityPrompt
                    if not Prompt.Enabled then
                        Prompt:GetPropertyChangedSignal("Enabled"):Wait()
                    end

                    while Prompt.Enabled do
                        Character:PivotTo(Prompt.Parent:GetPivot())
                        fireproximityprompt(Prompt)
                        task.wait()
                    end
                end

                for Number = 195, 199 do
                    task.wait(1)
                    UpdateMatchs()

                    local Prompt = Matched[`Room{Number}`] and Matched[`Room{Number}`].CaveLever.ProximityPrompt
                    if not Prompt then continue end

                    while Prompt.Enabled do
                        Character:PivotTo(Prompt.Parent:GetPivot())
                        fireproximityprompt(Prompt)
                        task.wait()
                    end
                end

                UiManager:Notify({
                    Title = GetTranslation(Translations, "Beat Figure Rooms"),
                    Description = GetTranslation(Translations, "You have beaten the figure rooms!")
                })
                self.Beating = false
            end
        }

        do  --// Cutscene Handler //
            local Events = shared.ReplicatedStorage:WaitForChild("Events")

            local SeekEvents = Events:WaitForChild("SeekEvents")
            local PrisonEvents = Events:WaitForChild("ThePrision")
            local ObservatoryEvents = Events:WaitForChild("TheObservatory")
            local OverseerEvents = Events:WaitForChild("OverseerEvents")

            local EventsToCutscenes: {[string]: RemoteEvent} = {
                ["Prison Start"] = PrisonEvents:WaitForChild("StartCutscene"),
                ["Seek Start"] = SeekEvents:WaitForChild("StartCutscene"),
                ["Seek Transition"] = SeekEvents:WaitForChild("Transition"),
                ["Locker Gas Equip"] = Events:WaitForChild("PlayerActions"):WaitForChild("LockerGasEquip"),
                ["Observatory Cutscene"] = ObservatoryEvents:WaitForChild("Cutscene"),
                ["Overseer Cutscene"] = OverseerEvents:WaitForChild("Cutscene"),
                ["Overseer Transition"] = OverseerEvents:WaitForChild("Transition"),
                ["Watcher Chase End"] = OverseerEvents:WaitForChild("WatcherChaseEnd"),
                ["Watcher Trapped"] = PrisonEvents:WaitForChild("EndingCutscene"),
                ["Watcher Escape"] = PrisonEvents:WaitForChild("HintEnding")
            }

            --// Notify When NoCutscenes Enabled
            for EventName, Event in EventsToCutscenes do
                Event.OnClientEvent:Connect(function(Params)
                    if not Utils.NoCutscenes.Enabled then return end

                    UiManager:Notify({
                        Title = GetTranslation(Translations, "Cutscene Started!"),
                        Description = GetTranslation(Translations, "Cutscene: %s"):format(EventName)
                    })

                    if EventName == "Watcher Trapped" then
                        if not Support.require then
                            wax.shared.TempStorage.SkippedWarn = Instance.new("Part")

                            UiManager:Notify({
                                Title = GetTranslation(Translations, "Skipped Warn"),
                                Description = GetTranslation(Translations, "You might get stuck cause your executor doesn't support 'require' function, please click 'Beat The Prision' button in the 'Exploit' tab to finish it."),
                                Time = wax.shared.TempStorage.SkippedWarn
                            })
                        else
                            local MinigameModule = require(wax.shared.ClientModule:WaitForChild("MinigameModule"))
                            MinigameModule.beginMinigame("TerminalMinigame", Params)
                        end
                    end
                end)
            end
        end

        return Utils

        --]]
    end,

    [37] = function(shared, wax, script, require)

    end,

    [38] = function(shared, wax, script, require)
        local Translations = {}

        local Language = wax.shared.Language

        if Language ~= "en" then
            local task_wait
                = task.wait

            local Success, Result
            local Elasped = 0

            local Thread = coroutine.create(function()
                print(`[MFeee~ New] Fetching translations for {Language}...`)

                Success, Result = pcall(function()
                    local UrlContent = game:HttpGet(`https://raw.githubusercontent.com/MaiFengYXD/Translations/refs/heads/main/Translations/{Language}.json`)
                    if not (UrlContent:find("{") and UrlContent:find("}")) then
                        error("Translations raw page error or HttpGet problem, please report it!", (0 / 0))
                    end

                    return shared.HttpService:JSONDecode(UrlContent)
                end)
            end)
            coroutine.resume(Thread)

            repeat
                Elasped += task_wait()

                if Elasped >= 10 then
                    coroutine.close(Thread)
                    Success = false
                    Result  = "Timeout! time exceeded 10 seconds."
                end
            until Success ~= nil

            if Success then
                Translations[Language] = Result
            else
                if Result:find("HttpGet is not a valid member of") then
                    Result = "HttpGet doesn't exist!"
                end

                wax.shared.MiniNotify("Translations:", `Failed to fetch translations for {Language} due to {Result}`)
            end
        end

        Translations.Reverse = {};do
            for Key, Value in Translations[Language] or {} do
                Translations.Reverse[Value] = Key
            end
        end

        local Translation = Translations[Language]
        local Reverse     = Translations.Reverse

        function Translations:GetTranslation(Key: string): string
            return Translation and Translation[Key] or Key
        end

        function Translations:FromTranslation(Value: string): string?
            return not Translation and Value or Reverse[Value]
        end

        return Translations
    end,

    [40] = function(shared, wax, script, require)
        local Random = Random.new()

        print(({
            --/ https://patorjk.com/software/taag
            "\n                 .-.                                \n                /    \\                              \n  ___ .-. .-.   | .`. ;    .--.     .--.     .--.   \n (   )   '   \\  | |(___)  /    \\   /    \\   /    \\  \n |  .-.  .-. ;  | |_     |  .-. ; |  .-. ; |  .-. ; \n | |  | |  | | (   __)   |  | | | |  | | | |  | | | \n | |  | |  | |  | |      |  |/  | |  |/  | |  |/  | \n | |  | |  | |  | |      |  ' _.' |  ' _.' |  ' _.' \n | |  | |  | |  | |      |  .'.-. |  .'.-. |  .'.-. \n | |  | |  | |  | |      '  `-' / '  `-' / '  `-' / \n(___)(___)(___)(___)      `.__.'   `.__.'   `.__.'  \n",
            "\n     ______  _______         _____       ______        ______        ______   \n    |      \\/       \\   ____|\\    \\  ___|\\     \\   ___|\\     \\   ___|\\     \\  \n   /          /\\     \\ |    | \\    \\|     \\     \\ |     \\     \\ |     \\     \\ \n  /     /\\   / /\\     ||    |______/|     ,_____/||     ,_____/||     ,_____/|\n /     /\\ \\_/ / /    /||    |----'\\ |     \\--'\\_|/|     \\--'\\_|/|     \\--'\\_|/\n|     |  \\|_|/ /    / ||    |_____/ |     /___/|  |     /___/|  |     /___/|  \n|     |       |    |  ||    |       |     \\____|\\ |     \\____|\\ |     \\____|\\ \n|\\____\\       |____|  /|____|       |____ '     /||____ '     /||____ '     /|\n| |    |      |    | / |    |       |    /_____/ ||    /_____/ ||    /_____/ |\n \\|____|      |____|/  |____|       |____|     | /|____|     | /|____|     | /\n    \\(          )/       )/           \\( |_____|/   \\( |_____|/   \\( |_____|/ \n     '          '        '             '    )/       '    )/       '    )/    \n                                            '             '             '     \n",
            "\n ___      ___   _______    _______    _______    _______  \n|\"  \\    /\"  | /\"     \"|  /\"     \"|  /\"     \"|  /\"     \"| \n \\   \\  //   |(: ______) (: ______) (: ______) (: ______) \n /\\\\  \\/.    | \\/    |    \\/    |    \\/    |    \\/    |   \n|: \\.        | // ___)    // ___)_   // ___)_   // ___)_  \n|.  \\    /:  |(:  (      (:      \"| (:      \"| (:      \"| \n|___|\\__/|___| \\__/       \\_______)  \\_______)  \\_______) \n",
            "\n<-. (`-')              (`-')  _  (`-')  _  (`-')  _ \n   \\(OO )_    <-.      ( OO).-/  ( OO).-/  ( OO).-/ \n,--./  ,-.)(`-')-----.(,------. (,------. (,------. \n|   `.'   |(OO|(_\\---' |  .---'  |  .---'  |  .---' \n|  |'.'|  | / |  '--. (|  '--.  (|  '--.  (|  '--.  \n|  |   |  | \\_)  .--'  |  .--'   |  .--'   |  .--'  \n|  |   |  |  `|  |_)   |  `---.  |  `---.  |  `---. \n`--'   `--'   `--'     `------'  `------'  `------' \n",
            "\n __  __      ___                             \n|  \\/  |    | __|    ___      ___      ___   \n| |\\/| |    | _|    / -_)    / -_)    / -_)  \n|_|__|_|   _|_|_    \\___|    \\___|    \\___|  \n_|\"\"\"\"\"| _| \"\"\" | _|\"\"\"\"\"| _|\"\"\"\"\"| _|\"\"\"\"\"| \n\"`-0-0-' \"`-0-0-' \"`-0-0-' \"`-0-0-' \"`-0-0-' \n",
            "\n███╗   ███╗███████╗███████╗███████╗███████╗\n████╗ ████║██╔════╝██╔════╝██╔════╝██╔════╝\n██╔████╔██║█████╗  █████╗  █████╗  █████╗  \n██║╚██╔╝██║██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  \n██║ ╚═╝ ██║██║     ███████╗███████╗███████╗\n╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝╚══════╝\n",
            "\n███▄ ▄▄███▓ ██████▒▓█████ ▓█████ ▓█████ \n▓██▒▀█▀ ██▒▓██   ▒ ▓█   ▀ ▓█   ▀ ▓█   ▀ \n▓██    ▓██░▒████ ░▒███   ▒███   ▒███    \n▒██    ▒██ ░▓█▒  ░▒▓█  ▄ ▒▓█  ▄ ▒▓█  ▄  \n▒██▒   ░██▒░▒█░   ░▒████▒░▒████▒░▒████▒ \n░ ▒░   ░  ░ ▒ ░    ░░ ▒░ ░░░ ▒░ ░░░ ▒░ ░\n░  ░      ░ ░       ░ ░  ░ ░ ░  ░ ░ ░  ░\n░      ░    ░ ░       ░      ░      ░   \n    ░              ░  ░   ░  ░   ░  ░   \n",
            "\n     e    e      888~~                                \n    d8b  d8b     888___  e88~~8e   e88~~8e   e88~~8e  \n   d888bdY88b    888    d888  88b d888  88b d888  88b \n  / Y88Y Y888b   888    8888__888 8888__888 8888__888 \n /   YY   Y888b  888    Y888    , Y888    , Y888    , \n/          Y888b 888     \"88___/   \"88___/   \"88___/  \n",
            "\n.        :   .-:::::'                              \n;;,.    ;;;  ;;;''''                               \n[[[[, ,[[[[, [[[,,== ,cc[[[cc. ,cc[[[cc. ,cc[[[cc. \n$$$$$$$$\"$$$ `$$$\"`` $$$___--' $$$___--' $$$___--' \n888 Y88\" 888o 888    88b    ,o,88b    ,o,88b    ,o,\nMMM  M'  \"MMM \"MM,    \"YUMMMMP\" \"YUMMMMP\" \"YUMMMMP\"\n",
            "    \n--------------\n4D 46 65 65 65\n--------------\n",
            "\n     _         _         _         _         _    \n   _( )__    _( )__    _( )__    _( )__    _( )__ \n _|     _| _|     _| _|     _| _|     _| _|     _|\n(_ M _ (_ (_ F _ (_ (_ e _ (_ (_ e _ (_ (_ e _ (_ \n  |_( )__|  |_( )__|  |_( )__|  |_( )__|  |_( )__|\n",
            "\n_______________________________________________________\n/~~\\__/~~\\_/~~~~~~~~\\_/~~~~~~~~\\_/~~~~~~~~\\_/~~~~~~~~\\_\n/~~~\\/~~~\\_/~~\\_______/~~\\_______/~~\\_______/~~\\_______\n/~~~~~~~~\\_/~~~~~~\\___/~~~~~~\\___/~~~~~~\\___/~~~~~~\\___\n/~~\\__/~~\\_/~~\\_______/~~\\_______/~~\\_______/~~\\_______\n/~~\\__/~~\\_/~~\\_______/~~~~~~~~\\_/~~~~~~~~\\_/~~~~~~~~\\_\n_______________________________________________________\n",
            "\n\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n/// \\\\/// \\///////// \\///////// \\///////// \\///////// \\\n//// //// \\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\\n/// / /// \\/////// \\\\\\/////// \\\\\\/////// \\\\\\/////// \\\\\\\n/// \\\\/// \\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\/// \\\\\\\\\\\\\\\n/// \\\\/// \\/// \\\\\\\\\\\\\\///////// \\///////// \\///////// \\\n\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\n",
            "\n _______  _______                      \n(_______)(_______)                     \n _  _  _  _____    _____  _____  _____ \n| ||_|| ||  ___)  | ___ || ___ || ___ |\n| |   | || |      | ____|| ____|| ____|\n|_|   |_||_|      |_____)|_____)|_____)\n",
            "\n______________________________________\n7        77     77     77     77     7\n|  _  _  ||  ___!|  ___!|  ___!|  ___!\n|  7  7  ||  __| |  __|_|  __|_|  __|_\n|  |  |  ||  7   |     7|     7|     7\n!__!__!__!!__!   !_____!!_____!!_____!\n",
            "\n     _/\\/\\______/\\/\\__/\\/\\/\\/\\/\\/\\_____________________________________\n    _/\\/\\/\\__/\\/\\/\\__/\\/\\____________/\\/\\/\\______/\\/\\/\\______/\\/\\/\\___ \n   _/\\/\\/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\____/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\_  \n  _/\\/\\__/\\__/\\/\\__/\\/\\__________/\\/\\________/\\/\\________/\\/\\_______   \n _/\\/\\______/\\/\\__/\\/\\____________/\\/\\/\\/\\____/\\/\\/\\/\\____/\\/\\/\\/\\_    \n__________________________________________________________________     \n",
            "\n_/\\/\\______/\\/\\__/\\/\\/\\/\\/\\/\\_____________________________________\n_/\\/\\/\\__/\\/\\/\\__/\\/\\____________/\\/\\/\\______/\\/\\/\\______/\\/\\/\\___\n_/\\/\\/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\____/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\__/\\/\\/\\/\\/\\_\n_/\\/\\__/\\__/\\/\\__/\\/\\__________/\\/\\________/\\/\\________/\\/\\_______\n_/\\/\\______/\\/\\__/\\/\\____________/\\/\\/\\/\\____/\\/\\/\\/\\____/\\/\\/\\/\\_\n__________________________________________________________________\n",
            "\n$$\\      $$\\ $$$$$$$$\\                               \n$$$\\    $$$ |$$  _____|                              \n$$$$\\  $$$$ |$$ |       $$$$$$\\   $$$$$$\\   $$$$$$\\  \n$$\\$$\\$$ $$ |$$$$$\\    $$  __$$\\ $$  __$$\\ $$  __$$\\ \n$$ \\$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |\n$$ |\\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|\n$$ | \\_/ $$ |$$ |      \\$$$$$$$\\ \\$$$$$$$\\ \\$$$$$$$\\ \n\\__|     \\__|\\__|       \\_______| \\_______| \\_______|\n"
            --[==[
            [[

                         .-.                                
                        /    \                              
          ___ .-. .-.   | .`. ;    .--.     .--.     .--.   
         (   )   '   \  | |(___)  /    \   /    \   /    \  
         |  .-.  .-. ;  | |_     |  .-. ; |  .-. ; |  .-. ; 
         | |  | |  | | (   __)   |  | | | |  | | | |  | | | 
         | |  | |  | |  | |      |  |/  | |  |/  | |  |/  | 
         | |  | |  | |  | |      |  ' _.' |  ' _.' |  ' _.' 
         | |  | |  | |  | |      |  .'.-. |  .'.-. |  .'.-. 
         | |  | |  | |  | |      '  `-' / '  `-' / '  `-' / 
        (___)(___)(___)(___)      `.__.'   `.__.'   `.__.'  
        ]],
            [[

             ______  _______         _____       ______        ______        ______   
            |      \/       \   ____|\    \  ___|\     \   ___|\     \   ___|\     \  
           /          /\     \ |    | \    \|     \     \ |     \     \ |     \     \ 
          /     /\   / /\     ||    |______/|     ,_____/||     ,_____/||     ,_____/|
         /     /\ \_/ / /    /||    |----'\ |     \--'\_|/|     \--'\_|/|     \--'\_|/
        |     |  \|_|/ /    / ||    |_____/ |     /___/|  |     /___/|  |     /___/|  
        |     |       |    |  ||    |       |     \____|\ |     \____|\ |     \____|\ 
        |\____\       |____|  /|____|       |____ '     /||____ '     /||____ '     /|
        | |    |      |    | / |    |       |    /_____/ ||    /_____/ ||    /_____/ |
         \|____|      |____|/  |____|       |____|     | /|____|     | /|____|     | /
            \(          )/       )/           \( |_____|/   \( |_____|/   \( |_____|/ 
             '          '        '             '    )/       '    )/       '    )/    
                                                    '             '             '     
        ]],
            [[

         ___      ___   _______    _______    _______    _______  
        |"  \    /"  | /"     "|  /"     "|  /"     "|  /"     "| 
         \   \  //   |(: ______) (: ______) (: ______) (: ______) 
         /\\  \/.    | \/    |    \/    |    \/    |    \/    |   
        |: \.        | // ___)    // ___)_   // ___)_   // ___)_  
        |.  \    /:  |(:  (      (:      "| (:      "| (:      "| 
        |___|\__/|___| \__/       \_______)  \_______)  \_______) 
        ]],
            [[

        <-. (`-')              (`-')  _  (`-')  _  (`-')  _ 
           \(OO )_    <-.      ( OO).-/  ( OO).-/  ( OO).-/ 
        ,--./  ,-.)(`-')-----.(,------. (,------. (,------. 
        |   `.'   |(OO|(_\---' |  .---'  |  .---'  |  .---' 
        |  |'.'|  | / |  '--. (|  '--.  (|  '--.  (|  '--.  
        |  |   |  | \_)  .--'  |  .--'   |  .--'   |  .--'  
        |  |   |  |  `|  |_)   |  `---.  |  `---.  |  `---. 
        `--'   `--'   `--'     `------'  `------'  `------' 
        ]],
            [[

         __  __      ___                             
        |  \/  |    | __|    ___      ___      ___   
        | |\/| |    | _|    / -_)    / -_)    / -_)  
        |_|__|_|   _|_|_    \___|    \___|    \___|  
        _|"""""| _| """ | _|"""""| _|"""""| _|"""""| 
        "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' "`-0-0-' 
        ]],
            [[

        ███╗   ███╗███████╗███████╗███████╗███████╗
        ████╗ ████║██╔════╝██╔════╝██╔════╝██╔════╝
        ██╔████╔██║█████╗  █████╗  █████╗  █████╗  
        ██║╚██╔╝██║██╔══╝  ██╔══╝  ██╔══╝  ██╔══╝  
        ██║ ╚═╝ ██║██║     ███████╗███████╗███████╗
        ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝╚══════╝
        ]],
            [[

        ███▄ ▄▄███▓ ██████▒▓█████ ▓█████ ▓█████ 
        ▓██▒▀█▀ ██▒▓██   ▒ ▓█   ▀ ▓█   ▀ ▓█   ▀ 
        ▓██    ▓██░▒████ ░▒███   ▒███   ▒███    
        ▒██    ▒██ ░▓█▒  ░▒▓█  ▄ ▒▓█  ▄ ▒▓█  ▄  
        ▒██▒   ░██▒░▒█░   ░▒████▒░▒████▒░▒████▒ 
        ░ ▒░   ░  ░ ▒ ░    ░░ ▒░ ░░░ ▒░ ░░░ ▒░ ░
        ░  ░      ░ ░       ░ ░  ░ ░ ░  ░ ░ ░  ░
        ░      ░    ░ ░       ░      ░      ░   
            ░              ░  ░   ░  ░   ░  ░   
        ]],
            [[

             e    e      888~~                                
            d8b  d8b     888___  e88~~8e   e88~~8e   e88~~8e  
           d888bdY88b    888    d888  88b d888  88b d888  88b 
          / Y88Y Y888b   888    8888__888 8888__888 8888__888 
         /   YY   Y888b  888    Y888    , Y888    , Y888    , 
        /          Y888b 888     "88___/   "88___/   "88___/  
        ]],
            [=[

        .        :   .-:::::'                              
        ;;,.    ;;;  ;;;''''                               
        [[[[, ,[[[[, [[[,,== ,cc[[[cc. ,cc[[[cc. ,cc[[[cc. 
        $$$$$$$$"$$$ `$$$"`` $$$___--' $$$___--' $$$___--' 
        888 Y88" 888o 888    88b    ,o,88b    ,o,88b    ,o,
        MMM  M'  "MMM "MM,    "YUMMMMP" "YUMMMMP" "YUMMMMP"
        ]=],
            [[
            
        --------------
        4D 46 65 65 65
        --------------
        ]],
            [[

             _         _         _         _         _    
           _( )__    _( )__    _( )__    _( )__    _( )__ 
         _|     _| _|     _| _|     _| _|     _| _|     _|
        (_ M _ (_ (_ F _ (_ (_ e _ (_ (_ e _ (_ (_ e _ (_ 
          |_( )__|  |_( )__|  |_( )__|  |_( )__|  |_( )__|
        ]],
            [[

        _______________________________________________________
        /~~\__/~~\_/~~~~~~~~\_/~~~~~~~~\_/~~~~~~~~\_/~~~~~~~~\_
        /~~~\/~~~\_/~~\_______/~~\_______/~~\_______/~~\_______
        /~~~~~~~~\_/~~~~~~\___/~~~~~~\___/~~~~~~\___/~~~~~~\___
        /~~\__/~~\_/~~\_______/~~\_______/~~\_______/~~\_______
        /~~\__/~~\_/~~\_______/~~~~~~~~\_/~~~~~~~~\_/~~~~~~~~\_
        _______________________________________________________
        ]],
            [[

        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        /// \\/// \///////// \///////// \///////// \///////// \
        //// //// \/// \\\\\\\/// \\\\\\\/// \\\\\\\/// \\\\\\\
        /// / /// \/////// \\\/////// \\\/////// \\\/////// \\\
        /// \\/// \/// \\\\\\\/// \\\\\\\/// \\\\\\\/// \\\\\\\
        /// \\/// \/// \\\\\\\///////// \///////// \///////// \
        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        ]],
            [[

         _______  _______                      
        (_______)(_______)                     
         _  _  _  _____    _____  _____  _____ 
        | ||_|| ||  ___)  | ___ || ___ || ___ |
        | |   | || |      | ____|| ____|| ____|
        |_|   |_||_|      |_____)|_____)|_____)
        ]],
            [[

        ______________________________________
        7        77     77     77     77     7
        |  _  _  ||  ___!|  ___!|  ___!|  ___!
        |  7  7  ||  __| |  __|_|  __|_|  __|_
        |  |  |  ||  7   |     7|     7|     7
        !__!__!__!!__!   !_____!!_____!!_____!
        ]],
            [[

             _/\/\______/\/\__/\/\/\/\/\/\_____________________________________
            _/\/\/\__/\/\/\__/\/\____________/\/\/\______/\/\/\______/\/\/\___ 
           _/\/\/\/\/\/\/\__/\/\/\/\/\____/\/\/\/\/\__/\/\/\/\/\__/\/\/\/\/\_  
          _/\/\__/\__/\/\__/\/\__________/\/\________/\/\________/\/\_______   
         _/\/\______/\/\__/\/\____________/\/\/\/\____/\/\/\/\____/\/\/\/\_    
        __________________________________________________________________     
        ]],
            [[

        _/\/\______/\/\__/\/\/\/\/\/\_____________________________________
        _/\/\/\__/\/\/\__/\/\____________/\/\/\______/\/\/\______/\/\/\___
        _/\/\/\/\/\/\/\__/\/\/\/\/\____/\/\/\/\/\__/\/\/\/\/\__/\/\/\/\/\_
        _/\/\__/\__/\/\__/\/\__________/\/\________/\/\________/\/\_______
        _/\/\______/\/\__/\/\____________/\/\/\/\____/\/\/\/\____/\/\/\/\_
        __________________________________________________________________
        ]],
            [[

        $$\      $$\ $$$$$$$$\                               
        $$$\    $$$ |$$  _____|                              
        $$$$\  $$$$ |$$ |       $$$$$$\   $$$$$$\   $$$$$$\  
        $$\$$\$$ $$ |$$$$$\    $$  __$$\ $$  __$$\ $$  __$$\ 
        $$ \$$$  $$ |$$  __|   $$$$$$$$ |$$$$$$$$ |$$$$$$$$ |
        $$ |\$  /$$ |$$ |      $$   ____|$$   ____|$$   ____|
        $$ | \_/ $$ |$$ |      \$$$$$$$\ \$$$$$$$\ \$$$$$$$\ 
        \__|     \__|\__|       \_______| \_______| \_______|
        ]]
            --]==]
        })[Random:NextInteger(1, 18)])

        --// Festivals and Emojis //
        local Year = tonumber(os.date("%Y")) :: number
        local Easter, Mother, Father

        local function Calculate(First: number, Second: number, Month: number): string?
            for Day = First, Second do
                if os.date("%w", os.time({year = Year, month = Month, day = Day})) == "0" then
                    return `{Month} {Day}`
                end
            end
            return
        end

        do
            local A = math.floor(Year / 100)
            local B = math.floor((13 + 8 * A) / 25)
            local C = (15 - B + A - math.floor(A / 4)) % 30
            local D = (4 + A - math.floor(A / 4)) % 7
            local E = (19 * (Year % 19) + C) % 30
            local F = (2 * (Year % 4) + 4 * (Year % 7) + 6 * E + D) % 7
            local G = (22 + E + F)

            Easter = (
                (E == 29 and F == 6 and "04 19") or
                (E == 28 and F == 6 and "04 18") or
                (31 < G and (`04 {G - 31}`)) or
                (`03 {G}`)
            )
            Mother = Calculate( 8, 14, 5)
            Father = Calculate(15, 21, 6)
        end

        local EmojiList = {
            ["01 01"] = "🎇",
            ["02 14"] = ({"💚", "💛", "🧡", "❤️", "💗"})[Random:NextInteger(1, 5)],
            ["03 08"] = "👩",
            ["03 12"] = "🌳",
            [Easter ] = "🥚",
            ["04 01"] = utf8.char(Random:NextInteger(0x1F600, 0x1F64F)),
            [Mother ] = "👩",
            ["06 01"] = "👶",
            [Father ] = "👨",
            ["10 29"] = "🎃",
            ["10 30"] = "🎃",
            ["10 31"] = "🎃",
            ["11 01"] = "🎃",
            ["12 24"] = "🎄",
            ["12 25"] = "🎄"
        } :: {[string?]: string}

        if wax.shared.Language == "zh-cn" then
            EmojiList["01 26"] = "🥣" --/ 2026
            EmojiList["02 16"] = "🧨" --/ 2026
            EmojiList["03 03"] = "🏮" --/ 2026
            EmojiList["05 31"] = "🍃" --/ 2025
            EmojiList["10 06"] = "🥮" --/ 2025
            EmojiList["04 04"] = "🪦"
            EmojiList["04 05"] = "🪦"
            EmojiList["04 06"] = "🪦"
            EmojiList["10 06"] = "🥮" --/ 2025

            for Date = 17, 22 do
                EmojiList[`02 {Date}`] = "🧧" --/ 2026
            end

            for Date = 1, 5 do
                EmojiList[`05 {Date}`] = "🏭"
            end
        end

        return EmojiList[os.date("%m %d")] or ""
    end,

    [41] = function(shared, wax, script, require)
        local unpack, pcall, typeof, table_clear, coroutine_close, coroutine_resume
            = unpack, pcall, typeof, table.clear, coroutine.close, coroutine.resume

        local _Connect   = game.Close.Connect
        local Disconnect = game.Close:Once(function() end).Disconnect

        local RunService = shared.RunService

        local BindToRenderStep     = RunService.BindToRenderStep
        local UnbindFromRenderStep = RunService.UnbindFromRenderStep

        local ContextService = shared.ContextActionService

        local BindAction           = ContextService.BindAction
        local BindActionAtPriority = ContextService.BindActionAtPriority
        local UnbindAction         = ContextService.UnbindAction

        local Connect = {}

        local Connections       = {}
        local Threads           = {}
        local RenderConnections = {}
        local ActionConnections = {}

        type ActionCallback = (
            ActionName:  string,
            InputState:  Enum.UserInputState,
            InputObject: InputObject
        ) -> (nil)

        function Connect:GiveSignal(
            Index:    string?,
            Signal:   RBXScriptSignal | RBXScriptConnection,
            Callback: Function?
        ): RBXScriptConnection
            if Connections[Index] then self:DisconnectSignal(Index) end

            if typeof(Signal) == "RBXScriptSignal" then
                return self:GiveSignal(Index, _Connect(Signal, Callback))
            end

            Connections[Index] = Signal
            return (Signal :: RBXScriptConnection)
        end

        function Connect:RunThread(Index: string?, Thread: thread): thread
            if Threads[Index] then self:StopThread(Index) end
            Threads[Index] = Thread

            pcall(coroutine_resume, Thread)
            return Thread
        end

        function Connect:BindRenderStep(
            Index:     string?,
            Priority:  Enum.RenderPriority | number,
            Function: (number) -> nil
        ): (number) -> nil
            self:UnbindRenderStep(Index)

            Priority = if typeof(Priority) ~= "number" then (Priority :: Enum.RenderPriority).Value else Priority

            BindToRenderStep(RunService, Index, Priority, Function)

            RenderConnections[Index] = Function
            return RenderConnections[Index]
        end

        function Connect:BindAction(
            Index:     string?,
            Function:  ActionCallback,
            TouchIcon: boolean?,
            Priority:  (Enum.ContextActionPriority | number)?,
            ...:       EnumItem
        ): ActionCallback
            self:UnbindAction(Index)

            local Enums = {...}
            local IsNormal = false

            if typeof(Priority) ~= "EnumItem" then
                if typeof(Priority) ~= "number" then IsNormal = true end
            else
                Priority = (Priority :: Enum.ContextActionPriority).Value
            end

            if IsNormal then
                BindAction(ContextService, Index, Function, TouchIcon, unpack(Enums))
            else
                BindActionAtPriority(ContextService, Index, Function, TouchIcon, Priority, unpack(Enums))
            end

            table_clear(Enums)
            ActionConnections[Index] = Function

            return Function
        end

        function Connect:DisconnectSignal(Index: string?)
            if pcall(Disconnect,  Connections[Index]) then Connections[Index] = nil end
        end

        function Connect:StopThread(Index: string?)
            if pcall(coroutine_close, Threads[Index]) then Threads[Index] = nil end
        end

        function Connect:UnbindRenderStep(Index: string?)
            UnbindFromRenderStep(RunService, Index)
            RenderConnections[Index] = nil
        end

        function Connect:UnbindAction(Index: string?)
            UnbindAction(ContextService, Index)
            ActionConnections[Index] = nil
        end

        wax.AddOnUnload(function()
            local Connect
                = Connect

            local         DisconnectSignal,         StopThread,         UnbindRenderStep,         UnbindAction
                = Connect.DisconnectSignal, Connect.StopThread, Connect.UnbindRenderStep, Connect.UnbindAction

            for Index in Connections do
                DisconnectSignal(Connect, Index)
            end

            for Index in Threads do
                StopThread(Connect, Index)
            end

            for Index in RenderConnections do
                UnbindRenderStep(Connect, Index)
            end

            for Index in ActionConnections do
                UnbindAction(Connect, Index)
            end
        end)

        return Connect
    end,

    [42] = function(shared, wax, script, require)
        local TweenInfo_new, type
            = TweenInfo.new, type

        local      Destroy
            = game.Destroy

        local TweenService = shared.TweenService
        local Create       = TweenService.Create

        local Play, Cancel;do
            local Tween = Instance.new("Tween")

            Play   = Tween.Play
            Cancel = Tween.Cancel

            Destroy(Tween)
        end

        local EasingStyle     = Enum.EasingStyle
        local EasingDirection = Enum.EasingDirection

        local EasingLibrary = {
            RunningTween = {},

            EasingModes = {
                --// Polynomial
                ["Linear"   ] = EasingStyle.Linear,
                ["Quadratic"] = EasingStyle.Quad,
                ["Cubic"    ] = EasingStyle.Cubic,
                ["Quartic"  ] = EasingStyle.Quart,
                ["Quintic"  ] = EasingStyle.Quint,

                --// Trigonometric
                ["Circular"] = EasingStyle.Circular,
                ["Sine"    ] = EasingStyle.Sine,

                --// Exponential
                ["Exponential"] = EasingStyle.Exponential,

                --// Special
                ["Back"   ] = EasingStyle.Back,
                ["Elastic"] = EasingStyle.Elastic,
                ["Bounce" ] = EasingStyle.Bounce
            },

            EasingDirections = {
                ["In"   ] = EasingDirection.In,
                ["Out"  ] = EasingDirection.Out,
                ["InOut"] = EasingDirection.InOut
            },

            EasingMode      = "Quartic" :: "None" | string,
            EasingDirection = "Out" :: string,
            EasingDuration  = 1,
        }

        local Quart = EasingStyle.Quart
        local Out   = EasingDirection.Out

        type StoredTween = {
            Tween:       Tween | TweenBase,
            OnCompleted: RBXScriptConnection
        }

        function EasingLibrary:CancelTween(Index: string)
            local Running = self.RunningTween[Index]
            if not Running then return end

            Cancel (Running.Tween) --/ OnCompleted will automatically clean the RunningTween
            Destroy(Running.Tween)
        end

        function EasingLibrary:PlayTween(Index: string?, Tween: Tween | TweenBase): StoredTween
            self.RunningTween[Index] = (self:CancelTween(Index) :: nil) or {
                Tween = Tween,

                OnCompleted = Tween.Completed:Once(function()
                    self.RunningTween[Index] = Destroy(self.RunningTween[Index].Tween)
                end)
            } :: StoredTween

            Play(Tween)

            return self.RunningTween[Index]
        end

        function EasingLibrary:Ease(
            Target:    Instance & any,
            Property:  string | {[string]: any},
            EndValue:  any,
            Index:     string?,
            Duration:  number | nil,
            Mode:      string | Enum.EasingStyle | nil,
            Direction: string | Enum.EasingDirection | nil
        ): StoredTween | nil
            if Mode == "None" or self.EasingMode == "None" then
                if type(Property) == "string" then
                    (Target :: any)[Property] = EndValue
                else
                    for Key, Value in (Property :: table) do
                        (Target :: any)[Key] = Value
                    end
                end
                return
            end

            local TweenInfo = TweenInfo_new(
                Duration  or self.EasingDuration or 1,
                type(Mode) == "string" and self.EasingModes[Mode] or self.EasingModes[self.EasingMode] or Quart,
                type(Direction) == "string" and self.EasingDirections[Direction] or self.EasingDirections[self.EasingDirection] or Out
            )
            local Goal = if type(Property) == "table" then Property else {[Property] = EndValue}

            return self:PlayTween(Index, Create(TweenService, Target, TweenInfo, Goal))
        end

        return EasingLibrary
    end,

    [43] = function(shared, wax, script, require)
        --[[
        Extended from NPCHandler.luau

        Including:
        + Entities
         L Npcs
        + Players (characters)
        --]]

        --// Local Caches //
        local Instance_new, table_clear, table_insert, task_defer, task_spawn, task_cancel
            = Instance.new, table.clear, table.insert, task.defer, task.spawn, task.cancel

        local      FindFirstChild,      FindFirstChildOfClass,      IsA,      GetPropertyChangedSignal,      IsDescendantOf,      WaitForChild
            = game.FindFirstChild, game.FindFirstChildOfClass, game.IsA, game.GetPropertyChangedSignal, game.IsDescendantOf, game.WaitForChild

        local Fire, Destroy, Wait, Connect, Disconnect, GetPivot;do
            local Bindable = Instance_new("BindableEvent")
            local Signal   = Bindable.Event
            local Model    = Instance_new("Model")

            Fire    = Bindable.Fire
            Destroy = Bindable.Destroy

            Wait       = Signal.Wait
            Connect    = Signal.Connect
            Disconnect = Connect(Signal, function() end).Disconnect

            GetPivot = Model.GetPivot

            Destroy(Bindable)
        end

        local AddOnUnload = wax.AddOnUnload :: (Callback, ...any) -> ()

        local Workspace = shared.Workspace :: Workspace
        local _Players  = shared.Players   :: Players

        local _PlayerRemoving = _Players.PlayerRemoving

        --// Helper Functions //
        local PlayerTempEvents = {}

        local function GetRootPart(Character: Model, Humanoid: Humanoid?): BasePart?
            return if Humanoid then Humanoid.RootPart else FindFirstChild(Character, "HumanoidRootPart")
        end

        local function GetForceField(Character: Model): ForceField?
            return FindFirstChildOfClass(Character, "ForceField")
        end

        local function TryGetHumanoid(Character: Model?): Humanoid?
            return if Character then FindFirstChildOfClass(Character, "Humanoid") else nil
        end

        local function TryGetRootPart(Character: Model?): BasePart?
            return if Character then GetRootPart(Character) else nil
        end

        local function TryGetHead(Character: Model?): BasePart?
            return if Character then FindFirstChild(Character, "Head") else nil
        end

        local function TryGetForceField(Character: Model?): ForceField?
            return if Character then GetForceField(Character) else nil
        end

        local function WaitPlayerData(Player: Player): ((Character: Model) -> Humanoid, (Character: Model) -> BasePart)
            local Event = Instance_new("BindableEvent")
            local HumanoidThread, RootPartThread

            local CurrentHumanoidIndex,
                  CurrentRootPartIndex
                = 1, 1

            PlayerTempEvents[Player] = Event

            local function WaitHumanoid(Character: Model): Humanoid
                if HumanoidThread then task_cancel(HumanoidThread) end

                local ThisHumanoidIndex = CurrentHumanoidIndex
                CurrentHumanoidIndex += 1

                HumanoidThread = task_spawn(function()
                    local Humanoid = WaitForChild(Character, "Humanoid")
                    local Signal

                    while not (Humanoid and IsA(Humanoid, "Humanoid")) do
                        if not Signal then
                            Signal = Character.ChildAdded
                        end

                        Humanoid = Wait(Signal)
                    end

                    Fire(Event, "Humanoid", Humanoid)
                end)

                local EventName, Humanoid

                repeat
                    EventName, Humanoid = Wait(Event.Event)
                until EventName == "Humanoid" or ThisHumanoidIndex ~= CurrentHumanoidIndex
                return Humanoid
            end

            local function WaitRootPart(Character: Model): BasePart
                if RootPartThread then task_cancel(RootPartThread) end

                local ThisRootPartIndex = CurrentRootPartIndex
                CurrentRootPartIndex += 1

                RootPartThread = task_spawn(function()
                    local RootPart = WaitForChild(Character, "HumanoidRootPart")
                    local Signal

                    while not (RootPart and IsA(RootPart, "BasePart")) do
                        if not Signal then
                            Signal = Character.ChildAdded
                        end

                        RootPart = Wait(Signal)
                    end

                    Fire(Event, "RootPart", RootPart)
                end)

                local EventName, RootPart

                repeat
                    EventName, RootPart = Wait(Event.Event)
                until EventName == "RootPart" or ThisRootPartIndex ~= CurrentRootPartIndex
                return RootPart
            end

            return WaitHumanoid, WaitRootPart
        end

        shared.Connect:GiveSignal("PlayerTempEvents", Connect(_Players.PlayerRemoving, function(Player: Player)
            if PlayerTempEvents[Player] then
                Destroy(PlayerTempEvents[Player])
            end
        end))

        AddOnUnload(function()
            for _, Event in PlayerTempEvents do
                Destroy(Event)
            end
        end)

        --// Npcs //
        type NpcStore = {
            Character:  Model,
            Humanoid:   Humanoid,
            RootPart:   BasePart?,
            Head:       BasePart?,
            ForceField: ForceField?,

            Health:   number,
            Alive:    boolean,
            Position: Vector3,

            Destroy: (() -> ())?
        }

        local _OnNpcAdded

        local Npcs = {} :: {[Model]: NpcStore};do
            local OnNpcAdded = Instance_new("BindableEvent")
            local Event      = OnNpcAdded.Event
            local Events     = {} :: {RBXScriptConnection}

            local GetPlayerFromCharacter = _Players.GetPlayerFromCharacter

            local function Init(Character: Model, Humanoid: Humanoid)
                if Npcs[Character] then return end
                Npcs[Character] = {} :: any

                --// Setup Store
                local Destroyed  = false

                local RootPart   = GetRootPart(Character, Humanoid)
                local Head       = TryGetHead(Character)
                local ForceField = GetForceField(Character)

                Npcs[Character] = {
                    Character  = Character,
                    Humanoid   = Humanoid,
                    RootPart   = RootPart,
                    Head       = Head,
                    ForceField = ForceField,

                    Health     = Humanoid.Health,
                    Alive      = Humanoid.Health > 0,
                    Position   = RootPart and RootPart.Position or GetPivot(Character).Position
                }

                --// Functions
                local CurrentStore = Npcs[Character]

                local ChildAdded,
                      ChildRemoved,
                      Died,
                      HealthChanged,
                      PositionChanged,
                      CharacterAncestryChanged

                local function SetUpPositionMonitor(RootPart: BasePart)
                    PositionChanged = (PositionChanged and Disconnect(PositionChanged) :: any) or Connect(GetPropertyChangedSignal(RootPart, "Position"), function()
                        CurrentStore.Position = RootPart.Position
                    end)
                end

                if RootPart then SetUpPositionMonitor(RootPart) end

                ChildAdded = Connect(Character.ChildAdded, function(Child: Instance)
                    if IsA(Child, "ForceField") then
                        CurrentStore.ForceField = Child :: ForceField
                    elseif Child == Humanoid.RootPart then
                        CurrentStore.RootPart = Child :: BasePart
                        RootPart = Child :: BasePart
                        SetUpPositionMonitor(Child :: BasePart)
                    elseif Child.Name == "Head" and not Head then
                        Head = Child :: BasePart
                        CurrentStore.Head = Head
                    end
                end)

                ChildRemoved = Connect(Character.ChildRemoved, function(Child: Instance)
                    if IsA(Child, "ForceField") and (CurrentStore.ForceField :: ForceField?) == Child then
                        CurrentStore.ForceField = nil
                    elseif Child == (CurrentStore.RootPart :: any) then
                        CurrentStore.RootPart = nil
                        PositionChanged = PositionChanged and Disconnect(PositionChanged) :: any
                    elseif Child == Head then
                        Head = nil
                        CurrentStore.Head = nil
                    end
                end)

                Died = Connect(Humanoid.Died, function()
                    CurrentStore.Alive = false
                end)

                HealthChanged = Connect(Humanoid.HealthChanged, function()
                    CurrentStore.Health = Humanoid.Health
                end)

                local function DestroyStore(): ()
                    if Destroyed then return end
                    Destroyed = true

                    if ChildAdded then Disconnect(ChildAdded) end
                    if ChildRemoved then Disconnect(ChildRemoved) end
                    if Died then Disconnect(Died) end
                    if HealthChanged then Disconnect(HealthChanged) end
                    if PositionChanged then Disconnect(PositionChanged) end
                    if CharacterAncestryChanged then Disconnect(CharacterAncestryChanged) end

                    Npcs[Character] = table_clear(CurrentStore)
                end

                CharacterAncestryChanged = Connect(Character.AncestryChanged, function()
                    if IsDescendantOf(Character, Workspace) then return end
                    DestroyStore()
                end)

                --// Finalize Setup
                CurrentStore.Destroy = DestroyStore
                AddOnUnload(DestroyStore)

                Fire(OnNpcAdded, CurrentStore)
            end

            local function Handle(Humanoid: Humanoid)
                local Character = Humanoid.Parent

                if not IsA(Character, "Model") then return end
                if GetPlayerFromCharacter(_Players, Character :: Model) then return end

                Init(Character :: Model, Humanoid)
            end

            for _, Instance in Workspace:GetDescendants() do
                if not IsA(Instance, "Humanoid") then continue end
                task_defer(Handle, Instance :: Humanoid)
            end

            shared.Connect:GiveSignal("NpcHandler", Connect(Workspace.DescendantAdded, function(Descendnat: Instance)
                if not IsA(Descendnat, "Humanoid") then return end
                Handle(Descendnat :: Humanoid)
            end))

            function _OnNpcAdded(Callback: (NpcStore) -> ())
                local Event = Connect(Event, Callback)
                table_insert(Events, Event)
            end

            AddOnUnload(Destroy, OnNpcAdded)
            AddOnUnload(function(Disconnect)
                for _, Event in Events do
                    Disconnect(Event)
                end
                table_clear(Events)
            end, Disconnect)
        end

        --// Players //
        type PlayerStore = {
            Character:  Model?,
            Humanoid:   Humanoid?,
            RootPart:   BasePart?,
            Head:       BasePart?,
            ForceField: ForceField?,

            Health:    number,
            Alive:     boolean,
            Position:  Vector3,
            TeamColor: Color3,

            Events: {
                RootPartChanged:   BindableEvent,
                ForceFieldChanged: BindableEvent,
                HealthChanged:     BindableEvent,
                PositionChanged:   BindableEvent,
                TeamColorChanged:  BindableEvent
            },

            Destroy: (() -> ())?
        }

        local _OnPlayerAdded, _OnCharacterAdded

        local Players = {} :: {[Player]: PlayerStore};do
            local Vector3_zero
                = Vector3.zero

            local OnPlayerAdded    = Instance_new("BindableEvent")
            local OnCharacterAdded = Instance_new("BindableEvent")
            local PlayerEvent      = OnPlayerAdded.Event
            local CharacterEvent   = OnCharacterAdded.Event
            local Events           = {} :: {RBXScriptConnection}

            local function Init(Player: Player)
                if Players[Player] then return end
                Players[Player] = {} :: any

                --// Setup Store
                local Destroyed = false

                local Character  = Player.Character
                local Humanoid   = TryGetHumanoid(Character)
                local RootPart   = TryGetRootPart(Character)
                local Head      = TryGetHead(Character)
                local ForceField = TryGetForceField(Character)

                local Events_RootPartChanged,
                      Events_ForceFieldChanged,
                      Events_HealthChanged,
                      Events_PositionChanged,
                      Events_TeamColorChanged

                    = Instance_new("BindableEvent"),
                      Instance_new("BindableEvent"),
                      Instance_new("BindableEvent"),
                      Instance_new("BindableEvent"),
                      Instance_new("BindableEvent")

                Players[Player] = {
                    Character  = Character,
                    Humanoid   = Humanoid,
                    RootPart   = RootPart,
                    Head       = Head,
                    ForceField = ForceField,

                    Health     = Humanoid and Humanoid.Health or 0,
                    Alive      = (Humanoid and Humanoid.Health > 0) :: boolean,
                    Position   = RootPart and RootPart.Position or Character and GetPivot(Character).Position or Vector3_zero,
                    TeamColor  = Player.TeamColor.Color,

                    Events = {
                        RootPartChanged   = Events_RootPartChanged,
                        ForceFieldChanged = Events_ForceFieldChanged,
                        HealthChanged     = Events_HealthChanged,
                        PositionChanged   = Events_PositionChanged,
                        TeamColorChanged  = Events_TeamColorChanged
                    }
                }

                --// Functions
                local CurrentStore = Players[Player]

                local CharacterAdded,
                      CharacterRemoving,
                      ChildAdded,
                      ChildRemoved,
                      Died,
                      HealthChanged,
                      PlayerRemoving,
                      PositionChanged,
                      TeamColorChanged

                local WaitHumanoid, WaitRootPart = WaitPlayerData(Player)
                local HumanoidThread, RootPartThread

                local function DestroyStore(): ()
                    if Destroyed then return end
                    Destroyed = true

                    if CharacterAdded then Disconnect(CharacterAdded) end
                    if CharacterRemoving then Disconnect(CharacterRemoving) end
                    if ChildAdded then Disconnect(ChildAdded) end
                    if ChildRemoved then Disconnect(ChildRemoved) end
                    if Died then Disconnect(Died) end
                    if HealthChanged then Disconnect(HealthChanged) end
                    if PlayerRemoving then Disconnect(PlayerRemoving) end
                    if PositionChanged then Disconnect(PositionChanged) end
                    if TeamColorChanged then Disconnect(TeamColorChanged) end

                    Destroy(Events_RootPartChanged)
                    Destroy(Events_ForceFieldChanged)
                    Destroy(Events_HealthChanged)
                    Destroy(Events_PositionChanged)
                    Destroy(Events_TeamColorChanged)

                    Players[Player] = table_clear(CurrentStore)
                end

                local function SetUpPositionMonitor(RootPart: BasePart)
                    PositionChanged = (PositionChanged and Disconnect(PositionChanged) :: any) or Connect(GetPropertyChangedSignal(RootPart, "Position"), function()
                        local Position = RootPart.Position
                        CurrentStore.Position = Position
                        Fire(Events_PositionChanged, Position)
                    end)
                end

                local function ConnectCharacter(Character: Model)
                    if RootPartThread then task_cancel(RootPartThread) end

                    RootPartThread = task_spawn(function()
                        if PositionChanged then Disconnect(PositionChanged) end
                        RootPart = WaitRootPart(Character)

                        SetUpPositionMonitor(RootPart :: BasePart)
                    end)

                    ChildAdded = (ChildAdded and Disconnect(ChildAdded) :: any) or Connect(Character.ChildAdded, function(Child: Instance)
                        if IsA(Child, "ForceField") then
                            CurrentStore.ForceField = Child :: ForceField
                            Fire(Events_ForceFieldChanged, Child)
                        elseif Humanoid and Child == Humanoid.RootPart then
                            CurrentStore.RootPart = Child :: BasePart
                            RootPart = Child :: BasePart

                            SetUpPositionMonitor(Child :: BasePart)
                            Fire(Events_RootPartChanged, Child)
                        elseif Child.Name == "Head" and not Head then
                            Head = Child :: BasePart
                            CurrentStore.Head = Head
                        end
                    end)

                    ChildRemoved = (ChildRemoved and Disconnect(ChildRemoved) :: any) or Connect(Character.ChildRemoved, function(Child: Instance)
                        if IsA(Child, "ForceField") then
                            CurrentStore.ForceField = nil
                            Fire(Events_ForceFieldChanged, nil)
                        elseif Humanoid and Child == Humanoid.RootPart then
                            CurrentStore.RootPart = nil
                            RootPart = nil
                            Fire(Events_RootPartChanged, nil)

                            if PositionChanged then Disconnect(PositionChanged) end
                        elseif Child == Head then
                            CurrentStore.Head = nil
                            Head = nil
                        end
                    end)

                    if HumanoidThread then task_cancel(HumanoidThread) end

                    HumanoidThread = task_spawn(function()
                        if HealthChanged then Disconnect(HealthChanged) end
                        if Died then Disconnect(Died) end

                        Humanoid = WaitHumanoid(Character)
                        local Humanoid = Humanoid :: Humanoid

                        CurrentStore.Health = Humanoid.Health
                        CurrentStore.Alive  = (Humanoid.Health > 0) :: boolean

                        HealthChanged = Connect((Humanoid :: Humanoid).HealthChanged, function(Health: number)
                            CurrentStore.Health = Health
                            Fire(Events_HealthChanged, Health)
                        end)

                        Died = Connect((Humanoid :: Humanoid).Died, function()
                            CurrentStore.Alive = false :: boolean
                        end)
                    end)
                end

                if Character then ConnectCharacter(Character) end

                CharacterAdded = Connect(Player.CharacterAdded, function(NewCharacter)
                    CurrentStore.Character = NewCharacter
                    ConnectCharacter(NewCharacter)
                end)

                CharacterRemoving = Connect(Player.CharacterRemoving, function()
                    Character  = nil
                    RootPart   = nil
                    Head       = nil
                    Humanoid   = nil
                    ForceField = nil

                    RootPartThread = RootPartThread and task_cancel(RootPartThread) :: any
                    HumanoidThread = HumanoidThread and task_cancel(HumanoidThread) :: any

                    PositionChanged = PositionChanged and Disconnect(PositionChanged) :: any
                    HealthChanged   = HealthChanged   and Disconnect(HealthChanged)   :: any

                    CurrentStore.Character  = nil
                    CurrentStore.RootPart   = nil
                    CurrentStore.Head       = nil
                    CurrentStore.Humanoid   = nil
                    CurrentStore.ForceField = nil

                    CurrentStore.Health   = 0
                    CurrentStore.Alive    = false :: boolean
                    CurrentStore.Position = Vector3_zero

                    Fire(Events_PositionChanged, Vector3_zero)
                    Fire(Events_HealthChanged, 0)
                    Fire(Events_ForceFieldChanged, nil)
                    Fire(Events_RootPartChanged, nil)
                end)

                PlayerRemoving = Connect(_PlayerRemoving, function(Player_: Player)
                    if Player == Player_ then
                        DestroyStore()
                    end
                end)

                TeamColorChanged = Connect(GetPropertyChangedSignal(Player, "TeamColor"), function()
                    local TeamColor = Player.TeamColor.Color
                    CurrentStore.TeamColor = TeamColor

                    Fire(Events_TeamColorChanged, TeamColor)
                end)

                --// Finalize Setup
                CurrentStore.Destroy = DestroyStore
                AddOnUnload(DestroyStore)

                Fire(OnPlayerAdded, Player)
            end

            for _, Player in _Players:GetPlayers() do
                task_defer(Init, Player)
            end

            shared.Connect:GiveSignal("PlayerHandler", Connect(_Players.PlayerAdded, Init))

            function _OnPlayerAdded(Callback: (PlayerStore) -> ())
                local Event = Connect(PlayerEvent, Callback)
                table_insert(Events, Event)
            end

            function _OnCharacterAdded(Callback: (Player) -> ())
                local Event = Connect(CharacterEvent, Callback)
                table_insert(Events, Event)
            end

            AddOnUnload(Destroy, OnPlayerAdded)
            AddOnUnload(Destroy, OnCharacterAdded)

            AddOnUnload(function(Disconnect)
                for _, Event in Events do
                    Disconnect(Event)
                end
                table_clear(Events)
            end, Disconnect)
        end

        --// Bundle and Return //
        return {
            Npcs    = Npcs,
            Players = Players,

            OnNpcAdded       = _OnNpcAdded,
            OnPlayerAdded    = _OnPlayerAdded,
            OnCharacterAdded = _OnCharacterAdded,
        }
    end,

    [44] = function(shared, wax, script, require)
        require("LiteralBlank")

        local pcall, xpcall, error, type, print, string_find, string_sub, table_clear, table_insert, task_defer
            = pcall, xpcall, error, type, print, string.find, string.sub, table.clear, table.insert, task.defer

        local Global = getgenv()

        --// Prepare Environment //
        local ExecutorSupport = {
            SupportFileSystem = false,
            TotalTestes       = 0,
            TotalWorking      = 0
        }

        local OutputList = {}
        local Grabages   = {} :: {Function}

        local assert;do
            --/ Disable error traceback
            local Nan = (0 / 0)

            function assert<T>(Assertion: T, Message: string?): (nil)
                return if Assertion then nil else error(Message, Nan)
            end
        end

        local function Test(
            Name:     string,
            Requires: {string?},
            Aliases:  {string?},
            TestFunction: (...any) -> (nil),
            Fix: ((nil) -> (nil)) | nil,
            CannotTest: boolean   | nil,
            CustomInfo: string    | nil
        ): (nil)
            ExecutorSupport.TotalTestes += 1

            local Success:    boolean,
                  TestResult: string?

            local IsFixable = type(Fix) == "function"

            local function GoSummary()
                for _, Function in Grabages do
                    task_defer(pcall, Function)
                end

                local RealSuccess = Success or IsFixable

                ExecutorSupport[Name] = RealSuccess
                ExecutorSupport.TotalWorking += RealSuccess and 1 or 0

                table_insert(OutputList, `> {Success and (CannotTest and "⏺️" or "✅") or RealSuccess and "⚠️" or "❌"} [{Name}]{not Success and ` - {TestResult}` or CustomInfo and ` - {CustomInfo}` or ""}`)

                task_defer(table_clear, Requires)
                task_defer(table_clear, Aliases)
            end

            local function TryToFix(ErrorMessage: string): string?
                if not IsFixable then return ErrorMessage end

                local FixSuccess = pcall((Fix :: Function))
                IsFixable = FixSuccess

                return if FixSuccess then `{ErrorMessage}, but it can be fixed` else ErrorMessage
            end

            local RequirementValidated = true

            for _, Requirement in Requires do
                if type(Global[Requirement]) == "function" then continue end

                RequirementValidated = false
                Success    = false
                TestResult = `Missing requirement '{Requirement}'`
                break
            end

            if not RequirementValidated then
                return GoSummary()
            end

            local RealFunction = Global[Name]
            local UsesAlias    = false

            if not RealFunction then
                for _, Alias in (Aliases :: {string}) do
                    local Table = string_find(Alias, "table: ")
                    local Key   = string_find(Alias, "key: ")

                    if Table and Key then
                        local TableName = string_sub(Alias, Table + 1, Key - 1)
                        local KeyName   = string_sub(Alias, Key + 4)

                        local TableFunction = if type(Global[TableName]) == "table" then Global[TableName][KeyName] else nil
                        RealFunction = if type(TableFunction) == "function" then TableFunction else nil

                        if not RealFunction then continue
                        else break end
                    end

                    if type(Global[Alias]) ~= "function" then continue end

                    RealFunction = Global[Alias]
                    break
                end

                if not RealFunction then
                    Success    = false
                    TestResult = TryToFix(`Missing function '{Name}' and its aliases`) :: string

                    return GoSummary()
                end

                UsesAlias = true
            end

            Success, TestResult = xpcall(TestFunction, TryToFix, RealFunction)

            if UsesAlias then
                Global[Name] = RealFunction
            end

            return GoSummary()
        end

        table_insert(OutputList, "----------------")

        --// File System //
        local TestFolder = "MFeee-New/.test"
        local TestFile   = `{TestFolder}/test.txt`

        local function CleanFolder()
            delfolder(TestFolder)
        end

        --// Folder
        Test("makefolder", {"isfolder"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            assert(isfolder(TestFolder), "Folder not created")
        end)

        Test("isfolder", {"makefolder"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            assert(isfolder(TestFolder), "Folder existence check failed")
        end)

        Test("delfolder", {"makefolder", "isfolder"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            delfolder(TestFolder)
            assert(isfolder(TestFolder) == false, "Folder deletion failed")
        end)

        --// File
        Test("writefile", {"makefolder", "readfile"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            writefile(TestFile, "Hello, World!")
            assert(readfile(TestFile) == "Hello, World!", "File content mismatch")
        end)

        Test("isfile", {"makefolder", "writefile"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            writefile(TestFile, "Hello, World!")
            assert(isfile(TestFile), "File existence check failed")
        end)

        Test("readfile", {"makefolder", "writefile"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            writefile(TestFile, "Hello, World!")
            assert(readfile(TestFile) == "Hello, World!", "File content mismatch")
        end)

        Test("delfile", {"makefolder", "writefile"}, {}, function()
            table_insert(Grabages, CleanFolder)
            makefolder(TestFolder)
            writefile(TestFile, "Hello, World!")
            delfile(TestFile)
            assert(isfile(TestFile) == false, "File deletion failed")
        end)

        --// Metatable //
        Test("hookmetamethod", {}, {}, function()
            local Object    = newproxy(true)
            local MetaTable = getmetatable(Object)

            table_insert(Grabages, function()
                Object, MetaTable = nil, nil
            end)

            --// Original meta methods
            MetaTable.__index = function(_, Key)
                return Key == "Banana" and 123 or "Hello "
            end

            MetaTable.__namecall = function(_, Arg)
                return Arg == "Orange" and 456 or "World!"
            end

            local Originals = {} :: {
                ["__index"   ]: (any, Key: string?) -> string | number,
                ["__namecall"]: (any, Arg: string?) -> string | number
            }

            --// Hook and store references from the original meta method
            Originals.__index    = hookmetamethod(Object, "__index"   , function(_, Key)
                return Key == "Banana" and "Hello " or 123
            end)

            Originals.__namecall = hookmetamethod(Object, "__namecall", function(_, Arg)
                return Arg == "Orange" and "World!" or 456
            end)

            --// Test hooked meta methods
            assert(Object.Banana           == "Hello " and Object.Orange           == 123, "Failed to hook (__index)")
            assert(Object:OhTest("Orange") == "World!" and Object:OhTest("Banana") == 456, "Failed to hook (__namecall)")

            --// Test original references
            assert(Originals.__index   (nil, "Banana") == 123 and Originals.__index   (nil, "Orange") == "Hello ", "Failed to get original reference (__index)")
            assert(Originals.__namecall(nil, "Orange") == 456 and Originals.__namecall(nil, "Banana") == "World!", "Failed to get original reference (__namecall)")

            --// Hook back original meta methods and test again
            hookmetamethod(Object, "__index"   , Originals.__index)
            hookmetamethod(Object, "__namecall", Originals.__namecall)

            assert(Object.Banana           == 123 and Object.Orange           == "Hello ", "Failed to restore original reference (__index)")
            assert(Object:OhTest("Orange") == 456 and Object:OhTest("Banana") == "World!", "Failed to restore original reference (__namecall)")
        end)

        Test("getnamecallmethod", {}, {}, function()
            pcall(function()
                game:HelloWorld() 
            end)

            local Method = tostring(getnamecallmethod())

            assert(Method == "HelloWorld", `Failed to get __namecall method (expected 'HelloWorld', got '{Method}')`)
        end)

        --// Closures //
        Test("hookfunction", {}, {"replaceclosure", "hookfunc"}, function(RealFunction: ((Function, Function) -> Function))
            local Test = ({
                function(Arg)
                    return Arg == "Hello " and "World!" or 456
                end
            })[1]

            --// Hook function and store reference to the original function
            local Original = RealFunction(Test, function(Arg)
                return Arg == "Hello " and 456 or "World!"
            end)

            assert(Test    ("Hello ") == 456      and Test    (123) == "World!", "Failed to hook function")
            assert(Original("Hello ") == "World!" and Original(123) == 456     , "Failed to get original reference")

            --// Hook back the original function and test again
            RealFunction(Test, Original)

            assert(Test("Hello ") == "World!" and Test(123) == 456, "Failed to restore original reference")
        end)

        Test("checkcaller", {}, {}, function()
            local IsCaller = checkcaller()
            assert(IsCaller == true, `Failed to check caller (expected true, got {tostring(IsCaller)}`)
        end)

        Test("getcallingscript", {}, {}, function()
            local Calling = getcallingscript()
            assert(Calling == nil, `Failed to get calling script (expected nil, got {typeof(Calling) == "Instance" and Calling:GetFullName() or tostring(Calling)})`)
        end)

        --// Cache //
        Test("cloneref", {}, {"clonereference"}, function()
            local Part = Instance.new("Part")
            table_insert(Grabages, function()
                Part:Destroy()
            end)

            local Cloned = cloneref(Part) :: Part

            assert(Cloned ~= Part, "Failed to clone reference (clone is same as original)")

            Cloned.Name = "ClonedPart"
            assert(Part.Name == "ClonedPart", "Failed to get cloned reference")
        end)

        Test("iscached", {}, {}, function()
            local Part = Instance.new("Part")
            table_insert(Grabages, function()
                Part:Destroy()
            end)

            assert(cache.iscached(Part), "Failed to check if part is cached")
            cache.invalidate(Part)
            assert(not cache.iscached(Part), "Failed to invalidate cache for part")
        end)

        --// Instance //
        Test("getconnections", {}, {"get_signal_cons"}, function(RealFunction: (RBXScriptConnection) -> Table)
            local Returns = {
                Enabled = "boolean",
                ForeignState = "boolean",
                LuaConnection = "boolean",
                Function = "function",
                Thread = "thread",
                Fire = "function",
                Defer = "function",
                Disconnect = "function",
                Disable = "function",
                Enable = "function"
            }

            --// Create a RBXScriptConnection and get its connections
            game.ChildAdded:Once(function() end)
            local Connection = RealFunction(game.ChildAdded)[1]

            for Key, Type in Returns do
                assert(Connection[Key] ~= nil, `Failed to get connection property {Key}`)
                assert(type(Connection[Key]) == Type, `Failed to get connection property {Key} (expected '{Type}', got '{type(Connection[Key])}')`)
            end
        end)

        Test("fireproximityprompt", {}, {}, function()
            local Prompt = Instance.new("ProximityPrompt", shared.Workspace) :: any & Instance

            local function DestroyPrompt()
                Prompt = Prompt:Destroy()
            end

            table_insert(Grabages, DestroyPrompt)
            Prompt.Triggered:Once(DestroyPrompt)

            fireproximityprompt(Prompt)

            task.wait(0.1)
            assert(Prompt == nil, "Failed to fire proximity prompt")
        end, function()
            local      IsA,            Once, shared
                = game.IsA, game.Close.Once, shared

            local InputHoldBegin, InputHoldEnd;do
                local Prompt = Instance.new("ProximityPrompt")

                InputHoldBegin = Prompt.InputHoldBegin
                InputHoldEnd   = Prompt.InputHoldEnd

                Prompt:Destroy()
            end

            local Firing = {}
            local Inf    = (1 / 0)

            function Global.fireproximityprompt(Prompt: ProximityPrompt, Distance: number): boolean
                local Success, Result = xpcall(function()
                    if Firing[Prompt] then return false end

                    assert((Prompt :: any) ~= nil, "missing argument #1 to 'fireproximityprompt' (userdata expected)")
                    assert(type(Prompt) == "userdata", `invalid argument #1 to 'fireproximityprompt' (userdata expected, got {type(Prompt)})`)
                    assert(IsA(Prompt, "ProximityPrompt"), `invalid argument #1 to 'fireproximityprompt' (expected ProximityPrompt, got {Prompt.ClassName})`)

                    Firing[Prompt] = true

                    if type(Distance) ~= "number" or not shared.Speaker.Character or Distance ~= Distance then
                        Distance = Inf
                    end

                    local PreDuration = Prompt.HoldDuration
                    local PreDistance = Prompt.MaxActivationDistance
                    local PreNoclip   = Prompt.RequiresLineOfSight

                    Prompt.HoldDuration = 0
                    Prompt.MaxActivationDistance = Distance
                    Prompt.RequiresLineOfSight   = false

                    Once(Prompt.Triggered, function()
                        InputHoldEnd(Prompt)

                        Prompt.HoldDuration          = PreDuration
                        Prompt.MaxActivationDistance = PreDistance
                        Prompt.RequiresLineOfSight   = PreNoclip

                        Firing[Prompt] = nil
                    end)

                    InputHoldBegin(Prompt)
                    return true
                end, function(Message)
                    Firing[Prompt] = nil
                    error(Message, 2)
                end)

                return if Success then Result else false
            end
        end)

        Test("firetouchinterest", {}, {"firetouchtransmitter"}, function(RealFunction: (Part1: BasePart, Part2: BasePart, State: number) -> nil)
            --/ nope cause firetouchinterest only works on server-side BasePart
        end, nil, true, "Hard to test cause it only works on server-side BasePart")

        Test("gethui", {}, {}, function()
            local HiddenUi = gethui()

            assert(typeof(HiddenUi) == "Instance", `Failed to get hidden UI (expected type 'Instance', got type '{typeof(HiddenUi)}')`)
            assert(HiddenUi:IsA("CoreGui"), `Failed to get hidden UI (expected class 'CoreGui', got class '{HiddenUi.ClassName}')`)
            assert(HiddenUi ~= game:GetService("CoreGui"), "Failed to get hidden UI (useless)")
        end, function()
            function Global.gethui(): CoreGui
                return shared.CoreGui
            end
        end)

        --// Environment //
        Test("require", {}, {}, function()
            local      IsA,     require
                = game.IsA, wax.require

            for _, Object in game:GetDescendants() do
                if not IsA(Object, "ModuleScript") then continue end
                if require(Object) == nil then continue end

                return
            end

            assert(false, "Failed to find an available module script (or require is broken)")
        end)

        --// Miscellaneous //
        Test("queue_on_teleport", {}, {"queueonteleport", "table: syn key: queue_on_teleport", "table: fluxus key: queue_on_teleport"}, function(RealFunction: (string) -> nil)
            xpcall(RealFunction, function(Message)
                return assert(false, `Failed to queue on teleport due to {Message}`)
            end, "return 1")
            --/ There's only this much I can do
        end, nil, true, "Only test whether the call is successful")

        Test("toclipboard", {}, {"setclipboard", "write_clipboard", "setrbxclipboard", "table: syn key: write_clipboard", "table: Clipboard key: set"}, function(RealFunction: (string) -> nil)
            --/ nope cause it involves managing the user's clipboard (it may be impolite and cannot verify if it works)
        end, nil, true, "This test cannot be tested, only checking the existence")

        Test("mousemoverel", {}, {}, function()
            --/ idk
        end, nil, true, "idk")

        Test("Drawing", {}, {}, function()
            local typeof
                = typeof

            local Properties = {
                Color = "Color3",
                Filled = "boolean",
                NumSides = "number",
                -- Opacity = "number",
                Position = "Vector2",
                Radius = "number",
                Thickness = "number",
                Transparency = "number",
                Visible = "boolean",
                ZIndex = "number",
                Destroy = "function",
                -- MoveToBack = "function",
                -- MoveToFront = "function",
                Remove = "function"
            }

            local Circle: any = Drawing.new("Circle")
            table_insert(Grabages, function()
                Circle:Remove()
            end)

            for Property, Type in Properties do
                assert(typeof(Circle[Property]) ~= "string", `Failed to get property '{Property}' (got unexpected type string)`)
                assert(typeof(Circle[Property]) == Type, `Failed to get property '{Property}' (expected type '{Type}', got type '{typeof(Circle[Property])}')`)
            end

            xpcall(Circle.Remove, function()
                assert(false, "Failed to test")
            end, Circle)
        end)

        --// Summary //
        do
            local FileSystem = {
                "makefolder",
                "isfolder",
                "delfolder",
                "writefile",
                "isfile",
                "readfile",
                "delfile"
            }

            local FileSystemSupport = 0

            for _, Function in FileSystem do
                FileSystemSupport += ExecutorSupport[Function] and 1 or 0
            end

            ExecutorSupport.SupportFileSystem = FileSystemSupport == #FileSystem
        end

        table_insert(OutputList, "----------------")
        table_insert(OutputList, `> 🛠️ Total working: {ExecutorSupport.TotalWorking}/{ExecutorSupport.TotalTestes}\n`)

        for _, Output in OutputList do
            print(Output)
        end

        return ExecutorSupport
    end,

    [45] = function(shared, wax, script, require)
        local makefolder, writefile, isfile, readfile, type, tostring, tonumber, string_match
            = makefolder, writefile, isfile, readfile, type, tostring, tonumber, string.match

        local FileHelper = {}

        function FileHelper:CheckAPI()
            return not wax.shared.ExecutorSupport.SupportFileSystem
        end

        function FileHelper:CreateParentFolder(FilePath: string): string?
            if self:CheckAPI() then return nil end

            local FolderPath = FilePath:match("^(.*)/[^/]*$")
            if not FolderPath then return nil end

            makefolder(FolderPath)
            return FolderPath
        end

        function FileHelper:CreateFolder(Path: string): string?
            if self:CheckAPI() then return nil end

            makefolder(Path)
            return Path
        end

        function FileHelper:CheckFile(Path: string, Fallback: string, Targets: any): string | number?
            Fallback = tostring(Fallback)

            if self:CheckAPI() then return Fallback end
            self:CreateParentFolder(Path)

            local function Return(type: ("number" | "string")? | any): string | number?
                writefile(Path, Fallback)

                if type == "number" then
                    return tonumber(Fallback)
                end

                return Fallback
            end

            local TargetType = type(Targets)

            if isfile(Path) then
                local Content = readfile(Path)

                if TargetType == "table" then
                    local Matched

                    for Target1, Target2 in Targets do
                        if Content ~= Target1 and Content ~= Target2 then continue end

                        Matched = Content
                        break
                    end

                    return Matched or Return("string")
                elseif TargetType == "number" then
                    if type(tonumber(Content)) ~= TargetType then return Return("number") end

                    return tonumber(Content)
                elseif TargetType == "nil" then
                    return Content
                end
            end

            return Return(TargetType)
        end

        function FileHelper:WriteFile(Path: string, Content: string, DontOverwrite: boolean?): string?
            Content = tostring(Content)

            if self:CheckAPI() then return Content end
            self:CreateParentFolder(Path)

            local LoopedTimes = 1
            local BasePath    = string_match(Path, "(.+)%.[^%.]+$")
            local Extension   = string_match(Path, "%.([^%.]+)$")

            while isfile(Path) and DontOverwrite do
                LoopedTimes += 1
                Path = `{BasePath} ({LoopedTimes}).{Extension}`
            end

            writefile(Path, Content)
            return Content
        end

        function FileHelper:IsFile(Path: string): (boolean | string)
            if self:CheckAPI() then return false end

            if isfile(Path) then
                return readfile(Path)
            end

            return false
        end

        return FileHelper
    end,

    [48] = function(shared, wax, script, require)
        --// Source by mstudio45 //

        local randomstring
            = randomstring;

        local PreRender = shared.RunService.PreRender;
        local LocalPlayer = shared.Speaker;
        local Mouse = LocalPlayer:GetMouse();

        local Translations = wax.shared.Translations;
        local GetTranslation = Translations.GetTranslation

        local DrawingLib = wax.shared.ExecutorSupport.Drawing and Drawing or { drawing_replaced = true };

        local IsBadDrawingLib = false;

        local ScreenGui = Instance.new('ScreenGui');

        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
        ScreenGui.DisplayOrder = 1e7;
        ScreenGui.ResetOnSpawn = false;

        pcall(function() ScreenGui.Parent = (gethui() :: CoreGui); end);

        --[[
            You can access Toggles & Options through (I'm planning to remove **a** option):
                a) getgenv().Toggles, getgenv().Options (IY will break this getgenv)
                ~~b) getgenv().Linoria.Toggles, getgenv().Linoria.Options~~
                c) Library.Toggles, Library.Options
        --]]

        local Toggles = {};
        local Options = {};
        local Labels  = {};
        local Buttons = {};

        getgenv().Linoria = {
            Toggles = Toggles;
            Options = Options;
            Labels  = Labels;
            Buttons = Buttons;
        }

        getgenv().Toggles = Toggles; -- if you load infinite yeild after you executed any script with LinoriaLib it will just break the whole UI lib :/ (thats why I added getgenv().Linoria)
        getgenv().Options = Options;
        getgenv().Labels  = Labels;
        getgenv().Buttons = Buttons;

        local LibraryMainOuterFrame = nil;
        local Library = {
            Registry = {};
            RegistryMap = {};

            HudRegistry = {};

            SaveManager = nil;

            Window = nil;
            KeybindContainer = nil;
            KeybindFrame = nil;

            FontColor = Color3.fromRGB(255, 255, 255);
            MainColor = Color3.fromRGB(28, 28, 28);
            BackgroundColor = Color3.fromRGB(20, 20, 20);

            AccentColor = Color3.fromRGB(0, 85, 255);
            DisabledAccentColor = Color3.fromRGB(142, 142, 142);

            OutlineColor = Color3.fromRGB(50, 50, 50);
            DisabledOutlineColor = Color3.fromRGB(70, 70, 70);

            DisabledTextColor = Color3.fromRGB(142, 142, 142);

            RiskColor = Color3.fromRGB(255, 50, 50);

            Black = Color3.new(0, 0, 0);
            Font = Enum.Font.BuilderSans;

            OpenedFrames = {};
            DependencyBoxes = {};

            UnloadSignals = {};
            Signals = {};
            ScreenGui = ScreenGui;

            ActiveTab = nil;
            Toggled = false;

            IsMobile = false;
            DevicePlatform = Enum.Platform.None;

            CanDrag = true;
            CantDragForced = false;

            NotifySide = "TopRight";
            ShowCustomCursor = true;
            ShowToggleFrameInKeybinds = true;
            NotifyOnError = false; -- true = Library:Notify for SafeCallback (still warns in the developer console)

            ToggleKeybind = {
                Type = "KeyPicker";
                Value = "RightControl";
            };

            VideoLink = "";
            TotalTabs = 0;

            -- for better usage --
            Toggles = Toggles;
            Options = Options;
            Labels  = Labels;
            Buttons = Buttons;
        };

        pcall(function() Library.DevicePlatform = shared.UserInputService:GetPlatform(); end); -- For safety so the UI library doesn't error.
        Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS);
        Library.MinSize = if Library.IsMobile then Vector2.new(550, 200) else Vector2.new(550, 300);

        local DPIScale = 1

        local function ApplyDPIScale(Position)
            return UDim2.new(Position.X.Scale, Position.X.Offset * DPIScale, Position.Y.Scale, Position.Y.Offset * DPIScale);
        end;

        local function ApplyTextScale(TextSize)
            return TextSize * DPIScale;
        end;

        local function GetTableSize(t)
            local n = 0
            for _ in t do
                n = n + 1
            end
            return n;
        end;

        local function GetPlayers(ExcludeLocalPlayer, ReturnInstances)
            local PlayerList = shared.Players:GetPlayers();

            if ExcludeLocalPlayer then
                local Idx = table.find(PlayerList, LocalPlayer);

                if Idx then
                    table.remove(PlayerList, Idx);
                end
            end

            table.sort(PlayerList, function(Player1, Player2)
                return Player1.Name:lower() < Player2.Name:lower();
            end)

            if ReturnInstances == true then
                return PlayerList;
            end;

            local FixedPlayerList = {};
            for _, player in PlayerList do
                FixedPlayerList[#FixedPlayerList + 1] = player.Name;
            end;

            return FixedPlayerList;
        end;

        local function GetTeams(ReturnInstances)
            local TeamList = shared.Teams:GetTeams();

            table.sort(TeamList, function(Team1, Team2)
                return Team1.Name:lower() < Team2.Name:lower();
            end)

            if ReturnInstances == true then
                return TeamList;
            end;

            local FixedTeamList = {};
            for _, team in TeamList do
                FixedTeamList[#FixedTeamList + 1] = team.Name;
            end;

            return FixedTeamList;
        end;

        function Library:SetDPIScale(value: number) 
            assert(type(value) == "number", GetTranslation(Translations, "Expected type number for DPI scale but got ") .. typeof(value))
            
            DPIScale = value / 100;
            Library.MinSize = (if Library.IsMobile then Vector2.new(550, 200) else Vector2.new(550, 300)) * DPIScale;
        end;

        -- < Create Notify UI >
        function Library:Create(Class, Properties)
            local _Instance = Class;

            if typeof(Class) == "string" then
                _Instance = Instance.new(Class);
                _Instance.Name = randomstring();
            end;

            for Property, Value in Properties do
                if (Property == "Size" or Property == "Position") then
                    Value = ApplyDPIScale(Value);
                elseif Property == "TextSize" then
                    Value = ApplyTextScale(Value);
                elseif Property == "Name" then
                    continue
                end

                xpcall(function()
                    _Instance[Property] = Value;
                end, function(Error)
                    warn(`Failed to create instance {Class} due to {Error}`)
                end);
            end;

            return _Instance;
        end;

        do
            Library.TopLeftNotificationArea = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 0, 0, 40);
                Size = UDim2.new(0, 300, 0, 200);
                ZIndex = 100;
                Parent = ScreenGui;
            });

            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Library.TopLeftNotificationArea;
            });

            Library.TopRightNotificationArea = Library:Create('Frame', {
                AnchorPoint = Vector2.new(1, 0);
                BackgroundTransparency = 1;
                Position = UDim2.new(1, 0, 0, 40);
                Size = UDim2.new(0, 300, 0, 200);
                ZIndex = 100;
                Parent = ScreenGui;
            });

            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Vertical;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Library.TopRightNotificationArea;
            });

            Library.BottomLeftNotificationArea = Library:Create('Frame', {
                AnchorPoint = Vector2.new(0, 1);
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 0, 1, 0);
                Size = UDim2.new(0, 300, 0, 200);
                ZIndex = 100;
                Parent = ScreenGui;
            });

            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Vertical;
                VerticalAlignment = Enum.VerticalAlignment.Bottom;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Library.BottomLeftNotificationArea;
            });

            Library.BottomRightNotificationArea = Library:Create('Frame', {
                AnchorPoint = Vector2.new(1, 1);
                BackgroundTransparency = 1;
                Position = UDim2.new(1, 0, 1, 0);
                Size = UDim2.new(0, 300, 0, 200);
                ZIndex = 100;
                Parent = ScreenGui;
            });

            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Vertical;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                VerticalAlignment = Enum.VerticalAlignment.Bottom;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Library.BottomRightNotificationArea;
            });

            Library = setmetatable(Library, {
                __index = function(self, Key)
                    if Key:find("NotificationArea") then
                        Key = Key:lower()
                        return self[`{Key:find("left") and "Top" or "Bottom"}{Key:find("top") and "Left" or "Right"}NotificationArea`]
                    end

                    return nil
                end
            })
        end;

        function Library:Notify(...)
            local Data = { Steps = 1 }
            local Info = select(1, ...)

            if typeof(Info) == "table" then
                Data.Title = Info.Title and tostring(Info.Title) or ""
                Data.Description = tostring(Info.Description)
                Data.Time = Info.Time or 5
                Data.SoundId = Info.SoundId
            else
                Data.Title = ""
                Data.Description = tostring(Info)
                Data.Time = select(2, ...) or 5
                Data.SoundId = select(3, ...)
            end

            local Side = string.lower(Library.NotifySide);
            local XSize, YSize = Library:GetTextBounds(Data.Description, Library.Font, 14);
            YSize = YSize + 7

            local NotifyOuter: Frame = Library:Create('Frame', {
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(0, 0, 0, YSize);
                ClipsDescendants = true;
                ZIndex = 100;
                Parent = Library[`{Side}NotificationArea`];
            });

            local NotifyInner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 101;
                Parent = NotifyOuter;
            });

            Library:AddToRegistry(NotifyInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            }, true);

            local InnerFrame = Library:Create('Frame', {
                BackgroundColor3 = Color3.new(1, 1, 1);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 1, 0, 1);
                Size = UDim2.new(1, -2, 1, -2);
                ZIndex = 102;
                Parent = NotifyInner;
            });

            local Gradient = Library:Create('UIGradient', {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                    ColorSequenceKeypoint.new(1, Library.MainColor),
                });
                Rotation = -90;
                Parent = InnerFrame;
            });

            Library:AddToRegistry(Gradient, {
                Color = function()
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                end
            });

            local IsLeft = Side:find("left")
            local IsTop  = Side:find("top")

            local NotifyLabel = Library:CreateLabel({
                AnchorPoint = Vector2.new(IsLeft and 0 or 1, 0);
                Position = if IsLeft then UDim2.new(0, 4, 0, 0) else UDim2.new(1, -4, 0, 0);
                Size = UDim2.new(1, -4, 1, 0);
                Text = (if Data.Title == "" then "" else "[" .. Data.Title .. "] ") .. tostring(Data.Description);
                TextXAlignment = if IsLeft then Enum.TextXAlignment.Left else Enum.TextXAlignment.Right;
                TextYAlignment = if IsTop then Enum.TextYAlignment.Top else Enum.TextYAlignment.Bottom;
                TextSize = 14;
                ZIndex = 103;
                RichText = true;
                Parent = InnerFrame;
            });

            local SideColor = Library:Create('Frame', {
                AnchorPoint = Vector2.new(IsLeft and 0 or 1, 0);
                Position = if IsLeft then UDim2.new(0, -1, 0, -1) else UDim2.new(1, -1, 0, -1);
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(0, 3, 1, 2);
                ZIndex = 104;
                Parent = NotifyOuter;
            });

            local TweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            function Data:Resize()
                XSize, YSize = Library:GetTextBounds(NotifyLabel.Text, Library.Font, 14);
                YSize = YSize + 7

                shared.TweenService:Create(NotifyOuter, TweenInfo, {
                    Size = UDim2.new(0, XSize * DPIScale + 8 + 4, 0, YSize)
                }):Play()
            end

            function Data:ChangeTitle(NewText)
                NewText = if NewText == nil then "" else tostring(NewText);

                Data.Title = NewText;
                NotifyLabel.Text = (if Data.Title == "" then "" else "[" .. Data.Title .. "] ") .. tostring(Data.Description);

                Data:Resize();
            end

            function Data:ChangeDescription(NewText)
                if NewText == nil then return end
                NewText = tostring(NewText);

                Data.Description = NewText;
                NotifyLabel.Text = (if Data.Title == "" then "" else "[" .. Data.Title .. "] ") .. tostring(Data.Description);

                Data:Resize();
            end

            function Data:ChangeStep()
                -- this is supposed to be empty
            end

            Data:Resize();

            Library:AddToRegistry(SideColor, {
                BackgroundColor3 = 'AccentColor';
            }, true);

            if Data.SoundId then
                Library:Create('Sound', {
                    SoundId = "rbxassetid://" .. tostring(Data.SoundId):gsub("rbxassetid://", "");
                    Volume = 3;
                    PlayOnRemove = true;
                    Parent = shared.SoundService;
                }):Destroy();
            end

            local Tween: Tween = shared.TweenService:Create(NotifyOuter, TweenInfo, {
                Size = UDim2.new(0, XSize * DPIScale + 8 + 4, 0, YSize)
            })
            Tween:Play()

            task.delay(0.4, function() Tween = nil :: any;end)

            local Finished = false
            local Connection: RBXScriptConnection
            local Thread: thread

            local function OnFinihied()
                if Finished then return end
                Finished = true

                if Tween  then Tween:Cancel() end
                if Thread then coroutine.close(Thread) end
                if Connection then Connection:Disconnect() end

                shared.TweenService:Create(NotifyOuter, TweenInfo, {
                    Size = UDim2.new(0, 0, 0, YSize)
                }):Play()
                task.delay(0.4, NotifyOuter.Destroy, NotifyOuter)
            end

            Connection = Library:GiveSignal(NotifyOuter.InputBegan:Connect(function(InputObject: InputObject)
                if InputObject.UserInputType == Enum.UserInputType.MouseButton1 or InputObject.UserInputType == Enum.UserInputType.Touch then
                    OnFinihied()
                end
            end))

            Thread = coroutine.create(function()
                if typeof(Data.Time) == "Instance" then
                    Data.Time.Destroying:Wait();
                else
                    task.wait(Data.Time or 5);
                end

                OnFinihied()
            end);

            coroutine.resume(Thread);
            return Data
        end;

        function Library:SafeCallback(Func, ...)
            if not (Func and typeof(Func) == "function") then
                return
            end;

            local Success, Response = xpcall(Func, function(Error)
                local Traceback = debug.traceback():gsub("\n", " ")
                local _, i = Traceback:find(":%d+ ")
                Traceback = Traceback:sub(i + 1):gsub(" :", ":")

                task.defer(error, Error .. " - " .. Traceback)
                if Library.NotifyOnError then
                    Library:Notify(Error)
                end
            end, ...);

            return if Success then Response else nil;
        end;

        function Library:AttemptSave()
            if (not Library.SaveManager) then return end;
            Library.SaveManager:Save();
        end;

        function Library:ApplyTextStroke(Inst)
            Inst.TextStrokeTransparency = 1;

            return Library:Create('UIStroke', {
                Color = Color3.new(0, 0, 0);
                Thickness = 1;
                LineJoinMode = Enum.LineJoinMode.Miter;
                Parent = Inst;
            });
        end;

        function Library:CreateLabel(Properties, IsHud)
            local _Instance = Library:Create('TextLabel', {
                BackgroundTransparency = 1;
                Font = Library.Font;
                TextColor3 = Library.FontColor;
                TextSize = 16;
                TextStrokeTransparency = 0;
            });

            Library:ApplyTextStroke(_Instance);

            Library:AddToRegistry(_Instance, {
                TextColor3 = 'FontColor';
            }, IsHud);

            return Library:Create(_Instance, Properties);
        end;

        function Library:MakeDraggable(Instance, Cutoff, IsMainWindow)
            Instance.Active = true;

            if Library.IsMobile == false then
                Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if IsMainWindow == true and Library.CantDragForced == true then
                            return;
                        end;
                   
                        local ObjPos = Vector2.new(
                            Mouse.X - Instance.AbsolutePosition.X,
                            Mouse.Y - Instance.AbsolutePosition.Y
                        );

                        if ObjPos.Y > (Cutoff or 40) then
                            return;
                        end;

                        while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            Instance.Position = UDim2.new(
                                0,
                                Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                                0,
                                Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                            );

                            PreRender:Wait();
                        end;
                    end;
                end);
            else
                local Dragging, DraggingInput, DraggingStart, StartPosition;

                shared.UserInputService.TouchStarted:Connect(function(Input)
                    if IsMainWindow == true and Library.CantDragForced == true then
                        Dragging = false
                        return;
                    end

                    if not Dragging and Library:MouseIsOverFrame(Instance, Input) and (IsMainWindow == true and (Library.CanDrag == true and Library.Window.Holder.Visible == true) or true) then
                        DraggingInput = Input;
                        DraggingStart = Input.Position;
                        StartPosition = Instance.Position;

                        local OffsetPos = Input.Position - DraggingStart;
                        if OffsetPos.Y > (Cutoff or 40) then
                            Dragging = false;
                            return;
                        end;

                        Dragging = true;
                    end;
                end);
                shared.UserInputService.TouchMoved:Connect(function(Input)
                    if IsMainWindow == true and Library.CantDragForced == true then
                        Dragging = false;
                        return;
                    end

                    if Input == DraggingInput and Dragging and (IsMainWindow == true and (Library.CanDrag == true and Library.Window.Holder.Visible == true) or true) then
                        local OffsetPos = Input.Position - DraggingStart;

                        Instance.Position = UDim2.new(
                            StartPosition.X.Scale,
                            StartPosition.X.Offset + OffsetPos.X,
                            StartPosition.Y.Scale,
                            StartPosition.Y.Offset + OffsetPos.Y
                        );
                    end;
                end);
                shared.UserInputService.TouchEnded:Connect(function(Input)
                    if Input == DraggingInput then 
                        Dragging = false;
                    end;
                end);
            end;
        end;

        function Library:MakeDraggableUsingParent(Instance, Parent, Cutoff, IsMainWindow)
            Instance.Active = true;

            if Library.IsMobile == false then
                Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if IsMainWindow == true and Library.CantDragForced == true then
                            return;
                        end;
          
                        local ObjPos = Vector2.new(
                            Mouse.X - Parent.AbsolutePosition.X,
                            Mouse.Y - Parent.AbsolutePosition.Y
                        );

                        if ObjPos.Y > (Cutoff or 40) then
                            return;
                        end;

                        while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            Parent.Position = UDim2.new(
                                0,
                                Mouse.X - ObjPos.X + (Parent.Size.X.Offset * Parent.AnchorPoint.X),
                                0,
                                Mouse.Y - ObjPos.Y + (Parent.Size.Y.Offset * Parent.AnchorPoint.Y)
                            );

                            PreRender:Wait();
                        end;
                    end;
                end);
            else  
                Library:MakeDraggable(Parent, Cutoff, IsMainWindow)
            end;
        end;

        function Library:MakeResizable(Instance, MinSize)
            if Library.IsMobile then
                return;
            end;

            Instance.Active = true;

            local ResizerImage_Size = 25 * DPIScale;
            local ResizerImage_HoverTransparency = 0.5;

            local Resizer = Library:Create('Frame', {
                SizeConstraint = Enum.SizeConstraint.RelativeXX;
                BackgroundColor3 = Color3.new(0, 0, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = UDim2.new(0, 30, 0, 30);
                Position = UDim2.new(1, -30, 1, -30);
                Visible = true;
                ClipsDescendants = true;
                ZIndex = 1;
                Parent = Instance;--Library.ScreenGui;
            });

            local ResizerImage = Library:Create('ImageButton', {
                BackgroundColor3 = Library.AccentColor;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Size = UDim2.new(2, 0, 2, 0);
                Position = UDim2.new(1, -30, 1, -30);
                ZIndex = 2;
                Parent = Resizer;
            });

            local ResizerImageUICorner = Library:Create('UICorner', {
                CornerRadius = UDim.new(0.5, 0);
                Parent = ResizerImage;
            });

            Library:AddToRegistry(ResizerImage, { BackgroundColor3 = 'AccentColor'; });

            Resizer.Size = UDim2.fromOffset(ResizerImage_Size, ResizerImage_Size);
            Resizer.Position = UDim2.new(1, -ResizerImage_Size, 1, -ResizerImage_Size);
            MinSize = MinSize or Library.MinSize;

            local OffsetPos;
            Resizer.Parent = Instance;

            local function FinishResize(Transparency)
                ResizerImage.Position = UDim2.new();
                ResizerImage.Size = UDim2.new(2, 0, 2, 0);
                ResizerImage.Parent = Resizer;
                ResizerImage.BackgroundTransparency = Transparency;
                ResizerImageUICorner.Parent = ResizerImage;
                OffsetPos = nil;
            end;

            ResizerImage.MouseButton1Down:Connect(function()
                if not OffsetPos then
                    OffsetPos = Vector2.new(Mouse.X - (Instance.AbsolutePosition.X + Instance.AbsoluteSize.X), Mouse.Y - (Instance.AbsolutePosition.Y + Instance.AbsoluteSize.Y));

                    ResizerImage.BackgroundTransparency = 1
                    ResizerImage.Size = UDim2.fromOffset(Library.ScreenGui.AbsoluteSize.X, Library.ScreenGui.AbsoluteSize.Y);
                    ResizerImage.Position = UDim2.new();
                    ResizerImageUICorner.Parent = nil;
                    ResizerImage.Parent = Library.ScreenGui;
                end;
            end);

            ResizerImage.MouseMoved:Connect(function()
                if OffsetPos then
                    local MousePos = Vector2.new(Mouse.X - OffsetPos.X, Mouse.Y - OffsetPos.Y);
                    local FinalSize = Vector2.new(math.clamp(MousePos.X - Instance.AbsolutePosition.X, MinSize.X, math.huge), math.clamp(MousePos.Y - Instance.AbsolutePosition.Y, MinSize.Y, math.huge));
                    Instance.Size = UDim2.fromOffset(FinalSize.X, FinalSize.Y);
                end;
            end);

            ResizerImage.MouseEnter:Connect(function()
                FinishResize(ResizerImage_HoverTransparency);
            end);

            ResizerImage.MouseLeave:Connect(function()
                FinishResize(1);
            end);

            ResizerImage.MouseButton1Up:Connect(function()
                FinishResize(ResizerImage_HoverTransparency);
            end);
        end;

        function Library:AddToolTip(InfoStr, DisabledInfoStr, HoverInstance)
            InfoStr = typeof(InfoStr) == "string" and InfoStr or nil;
            DisabledInfoStr = typeof(DisabledInfoStr) == "string" and DisabledInfoStr or nil;

            local Tooltip = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;

                ZIndex = 100;
                Parent = Library.ScreenGui;

                Visible = false;
            });

            local Label = Library:CreateLabel({
                Position = UDim2.fromOffset(3, 1);
                
                TextSize = 14;
                Text = InfoStr;
                TextColor3 = Library.FontColor;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = Tooltip.ZIndex + 1;

                Parent = Tooltip;
            });

            Library:AddToRegistry(Tooltip, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            Library:AddToRegistry(Label, {
                TextColor3 = 'FontColor',
            });

            local TooltipTable = {
                Tooltip = Tooltip;
                Disabled = false;

                Signals = {};
            }
            local IsHovering = false

            local function UpdateText(Text)
                if Text == nil then return end

                local X, Y = Library:GetTextBounds(Text, Library.Font, 14 * DPIScale);

                Label.Text = Text;
                Tooltip.Size = UDim2.fromOffset(X + 5, Y + 4);
                Label.Size = UDim2.fromOffset(X, Y);
            end
            UpdateText(InfoStr);

            table.insert(TooltipTable.Signals, HoverInstance.MouseEnter:Connect(function()
                if Library:MouseIsOverOpenedFrame() then
                    Tooltip.Visible = false
                    return
                end

                if not TooltipTable.Disabled then
                    if InfoStr == nil or InfoStr == "" then
                        Tooltip.Visible = false
                        return
                    end

                    if Label.Text ~= InfoStr then UpdateText(InfoStr); end
                else
                    if DisabledInfoStr == nil or DisabledInfoStr == "" then
                        Tooltip.Visible = false
                        return
                    end

                    if Label.Text ~= DisabledInfoStr then UpdateText(DisabledInfoStr); end
                end

                IsHovering = true

                Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
                Tooltip.Visible = true

                while IsHovering do
                    if TooltipTable.Disabled == true and DisabledInfoStr == nil then break end

                    shared.RunService.Heartbeat:Wait()
                    Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
                end

                IsHovering = false
                Tooltip.Visible = false
            end))

            table.insert(TooltipTable.Signals, HoverInstance.MouseLeave:Connect(function()
                IsHovering = false
                Tooltip.Visible = false
            end))

            if LibraryMainOuterFrame then
                table.insert(TooltipTable.Signals, LibraryMainOuterFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                    if LibraryMainOuterFrame.Visible == false then
                        IsHovering = false
                        Tooltip.Visible = false
                    end
                end))
            end

            function TooltipTable:Destroy()
                Tooltip:Destroy();

                for Idx = #TooltipTable.Signals, 1, -1 do
                    local Connection = table.remove(TooltipTable.Signals, Idx);
                    Connection:Disconnect();
                end
            end

            return TooltipTable
        end

        function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault, condition)
            local function undoHighlight()
                local Reg = Library.RegistryMap[Instance];

                for Property, ColorIdx in PropertiesDefault do
                    Instance[Property] = Library[ColorIdx] or ColorIdx;

                    if Reg and Reg.Properties[Property] then
                        Reg.Properties[Property] = ColorIdx;
                    end;
                end;
            end
            local function doHighlight()
                if condition and not condition() then undoHighlight(); return end
                local Reg = Library.RegistryMap[Instance];

                for Property, ColorIdx in Properties do
                    Instance[Property] = Library[ColorIdx] or ColorIdx;

                    if Reg and Reg.Properties[Property] then
                        Reg.Properties[Property] = ColorIdx;
                    end;
                end;
            end

            HighlightInstance.MouseEnter:Connect(function()
                doHighlight()
            end)
            HighlightInstance.MouseMoved:Connect(function()
                doHighlight()
            end)
            HighlightInstance.MouseLeave:Connect(function()
                undoHighlight()
            end)
        end;

        function Library:MouseIsOverOpenedFrame(Input)
            local Pos = Mouse;
            if Library.IsMobile and Input then 
                Pos = Input.Position;
            end;

            for Frame in Library.OpenedFrames do
                local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

                if Pos.X >= AbsPos.X and Pos.X <= AbsPos.X + AbsSize.X
                    and Pos.Y >= AbsPos.Y and Pos.Y <= AbsPos.Y + AbsSize.Y then

                    return true;
                end;
            end;
            return false
        end;

        function Library:MouseIsOverFrame(Frame, Input)
            local Pos = Mouse;
            if Library.IsMobile and Input then 
                Pos = Input.Position;
            end;
            local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

            if Pos.X >= AbsPos.X and Pos.X <= AbsPos.X + AbsSize.X
                and Pos.Y >= AbsPos.Y and Pos.Y <= AbsPos.Y + AbsSize.Y then

                return true;
            end;
            return false
        end;

        function Library:UpdateDependencyBoxes()
            for _, Depbox in Library.DependencyBoxes do
                Depbox:Update();
            end;
        end;

        function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
            return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
        end;

        function Library:GetTextBounds(Text, Font, Size, Resolution)
            -- Ignores rich text formatting --
            local Bounds = shared.TextService:GetTextSize(Text:gsub("<%/?[%w:]+[^>]*>", ""), Size, Font, Resolution or Vector2.new(1920, 1080))
            return Bounds.X, Bounds.Y
        end;

        function Library:GetDarkerColor(Color)
            local H, S, V = Color3.toHSV(Color);
            return Color3.fromHSV(H, S, V / 1.5);
        end;
        Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

        function Library:AddToRegistry(Instance, Properties, IsHud)
            local Idx = #Library.Registry + 1;
            local Data = {
                Instance = Instance;
                Properties = Properties;
                Idx = Idx;
            };

            table.insert(Library.Registry, Data);
            Library.RegistryMap[Instance] = Data;

            if IsHud then
                table.insert(Library.HudRegistry, Data);
            end;
        end;

        function Library:RemoveFromRegistry(Instance)
            local Data = Library.RegistryMap[Instance];

            if Data then
                for Idx = #Library.Registry, 1, -1 do
                    if Library.Registry[Idx] == Data then
                        table.remove(Library.Registry, Idx);
                    end;
                end;

                for Idx = #Library.HudRegistry, 1, -1 do
                    if Library.HudRegistry[Idx] == Data then
                        table.remove(Library.HudRegistry, Idx);
                    end;
                end;

                Library.RegistryMap[Instance] = nil;
            end;
        end;

        function Library:UpdateColorsUsingRegistry()
            -- TODO: Could have an 'active' list of objects
            -- where the active list only contains Visible objects.

            -- IMPL: Could setup .Changed events on the AddToRegistry function
            -- that listens for the 'Visible' propert being changed.
            -- Visible: true => Add to active list, and call UpdateColors function
            -- Visible: false => Remove from active list.

            -- ~~The above would be especially efficient for a rainbow menu color or live color-changing.~~

            for Idx, Object in Library.Registry do
                for Property, ColorIdx in Object.Properties do
                    if typeof(ColorIdx) == "string" then
                        Object.Instance[Property] = Library[ColorIdx];
                    elseif typeof(ColorIdx) == 'function' then
                        Object.Instance[Property] = ColorIdx()
                    end
                end;
            end;
        end;

        function Library:GiveSignal(Signal)
            -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
            table.insert(Library.Signals, Signal)
        end

        function Library:Unload()
            -- Unload all of the signals
            for Idx = #Library.Signals, 1, -1 do
                local Connection = table.remove(Library.Signals, Idx)
                Connection:Disconnect()
            end

            -- Call our unload callback, maybe to undo some hooks etc
            for _, UnloadCallback in Library.UnloadSignals do
                Library:SafeCallback(UnloadCallback)
            end

            getgenv().Linoria = nil
            ScreenGui:Destroy()
        end

        function Library:OnUnload(Callback)
            table.insert(Library.UnloadSignals, Callback)
        end

        Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
            if Library.RegistryMap[Instance] then
                Library:RemoveFromRegistry(Instance);
            end;
        end))

        local function Trim(Text: string)
            return Text:match("^%s*(.-)%s*$")
        end

        local BaseAddons = {};

        do
            local BaseAddonsFuncs = {};

            function BaseAddonsFuncs:AddColorPicker(Idx, Info)
                local ParentObj = self
                local ToggleLabel = self.TextLabel;
                --local Container = self.Container;

                assert(Info.Default, GetTranslation(Translations, "AddColorPicker: Missing default value."));

                local ColorPicker = {
                    Value = Info.Default;
                    Transparency = Info.Transparency or 0;
                    Type = 'ColorPicker';
                    Title = typeof(Info.Title) == "string" and Info.Title or GetTranslation(Translations, 'Color picker'),
                    Callback = Info.Callback or function(Color) end;
                    Changed = Info.Changed or function(Color) end;
                };

                function ColorPicker:SetHSVFromRGB(Color)
                    local H, S, V = Color:ToHSV();

                    ColorPicker.Hue = H;
                    ColorPicker.Sat = S;
                    ColorPicker.Vib = V;
                end;

                ColorPicker:SetHSVFromRGB(ColorPicker.Value);

                local DisplayFrame = Library:Create('Frame', {
                    BackgroundColor3 = ColorPicker.Value;
                    BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(0, 28, 0, 18);
                    ZIndex = 6;
                    Parent = ToggleLabel;
                });

                -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
                Library:Create('ImageLabel', {
                    BorderSizePixel = 0;
                    Size = UDim2.new(0, 27, 0, 13);
                    ZIndex = 5;
                    Image = 'http://www.roblox.com/asset/?id=12977615774';
                    Visible = not not Info.Transparency;
                    Parent = DisplayFrame;
                });

                -- 1/16/23
                -- Rewrote this to be placed inside the Library ScreenGui
                -- There was some issue which caused RelativeOffset to be way off
                -- Thus the color picker would never show

                local PickerFrameOuter = Library:Create('Frame', {
                    Name = 'Color';
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
                    Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253);
                    Visible = false;
                    ZIndex = 15;
                    Parent = ScreenGui,
                });

                DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                    PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18);
                end)

                local PickerFrameInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 16;
                    Parent = PickerFrameOuter;
                });

                local Highlight = Library:Create('Frame', {
                    BackgroundColor3 = Library.AccentColor;
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 2);
                    ZIndex = 17;
                    Parent = PickerFrameInner;
                });

                local SatVibMapOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0, 4, 0, 25);
                    Size = UDim2.new(0, 200, 0, 200);
                    ZIndex = 17;
                    Parent = PickerFrameInner;
                });

                local SatVibMapInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 18;
                    Parent = SatVibMapOuter;
                });

                local SatVibMap = Library:Create('ImageLabel', {
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 18;
                    Image = 'rbxassetid://4155801252';
                    Parent = SatVibMapInner;
                });

                local CursorOuter = Library:Create('ImageLabel', {
                    AnchorPoint = Vector2.new(0.5, 0.5);
                    Size = UDim2.new(0, 6, 0, 6);
                    BackgroundTransparency = 1;
                    Image = 'http://www.roblox.com/asset/?id=9619665977';
                    ImageColor3 = Color3.new(0, 0, 0);
                    ZIndex = 19;
                    Parent = SatVibMap;
                });

                Library:Create('ImageLabel', {
                    Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = 'http://www.roblox.com/asset/?id=9619665977';
                    ZIndex = 20;
                    Parent = CursorOuter;
                })

                local HueSelectorOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0, 208, 0, 25);
                    Size = UDim2.new(0, 15, 0, 200);
                    ZIndex = 17;
                    Parent = PickerFrameInner;
                });

                local HueSelectorInner = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 18;
                    Parent = HueSelectorOuter;
                });

                local HueCursor = Library:Create('Frame', { 
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    AnchorPoint = Vector2.new(0, 0.5);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(1, 0, 0, 1);
                    ZIndex = 18;
                    Parent = HueSelectorInner;
                });

                local HueBoxOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.fromOffset(4, 228),
                    Size = UDim2.new(0.5, -6, 0, 20),
                    ZIndex = 18,
                    Parent = PickerFrameInner;
                });

                local HueBoxInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 18,
                    Parent = HueBoxOuter;
                });

                Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                    });
                    Rotation = 90;
                    Parent = HueBoxInner;
                });

                local HueBox = Library:Create('TextBox', {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -5, 1, 0);
                    Font = Library.Font;
                    PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                    PlaceholderText = GetTranslation(Translations, 'Hex color'),
                    Text = '#FFFFFF',
                    TextColor3 = Library.FontColor;
                    TextSize = 14;
                    TextStrokeTransparency = 0;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 20,
                    Parent = HueBoxInner;
                });

                Library:ApplyTextStroke(HueBox);

                local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
                    Position = UDim2.new(0.5, 2, 0, 228),
                    Size = UDim2.new(0.5, -6, 0, 20),
                    Parent = PickerFrameInner
                });

                local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
                    Text = '255, 255, 255',
                    PlaceholderText = GetTranslation(Translations, 'RGB color'),
                    TextColor3 = Library.FontColor
                });

                local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor;
                
                if Info.Transparency then 
                    TransparencyBoxOuter = Library:Create('Frame', {
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.fromOffset(4, 251);
                        Size = UDim2.new(1, -8, 0, 15);
                        ZIndex = 19;
                        Parent = PickerFrameInner;
                    });

                    TransparencyBoxInner = Library:Create('Frame', {
                        BackgroundColor3 = ColorPicker.Value;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 19;
                        Parent = TransparencyBoxOuter;
                    });

                    Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = 'OutlineColor' });

                    Library:Create('ImageLabel', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 1, 0);
                        Image = 'http://www.roblox.com/asset/?id=12978095818';
                        ZIndex = 20;
                        Parent = TransparencyBoxInner;
                    });

                    TransparencyCursor = Library:Create('Frame', { 
                        BackgroundColor3 = Color3.new(1, 1, 1);
                        AnchorPoint = Vector2.new(0.5, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(0, 1, 1, 0);
                        ZIndex = 21;
                        Parent = TransparencyBoxInner;
                    });
                end;

                Library:CreateLabel({
                    Size = UDim2.new(1, 0, 0, 14);
                    Position = UDim2.fromOffset(5, 5);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 14;
                    Text = ColorPicker.Title,--Info.Default;
                    TextWrapped = false;
                    ZIndex = 16;
                    Parent = PickerFrameInner;
                });

                local ContextMenu = {}
                do
                    ContextMenu.Options = {}
                    ContextMenu.Container = Library:Create('Frame', {
                        BorderColor3 = Color3.new(),
                        ZIndex = 14,

                        Visible = false,
                        Parent = ScreenGui
                    })

                    ContextMenu.Inner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.fromScale(1, 1);
                        ZIndex = 15;
                        Parent = ContextMenu.Container;
                    });

                    Library:Create('UIListLayout', {
                        Name = 'Layout',
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = ContextMenu.Inner;
                    });

                    Library:Create('UIPadding', {
                        Name = 'Padding',
                        PaddingLeft = UDim.new(0, 4),
                        Parent = ContextMenu.Inner,
                    });

                    local function updateMenuPosition()
                        ContextMenu.Container.Position = UDim2.fromOffset(
                            (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                            DisplayFrame.AbsolutePosition.Y + 1
                        )
                    end

                    local function updateMenuSize()
                        local menuWidth = 60
                        for i, label in ContextMenu.Inner:GetChildren() do
                            if label:IsA('TextLabel') then
                                menuWidth = math.max(menuWidth, label.TextBounds.X)
                            end
                        end

                        ContextMenu.Container.Size = UDim2.fromOffset(
                            menuWidth + 8,
                            ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                        )
                    end

                    DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(updateMenuPosition)
                    ContextMenu.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(updateMenuSize)

                    task.spawn(updateMenuPosition)
                    task.spawn(updateMenuSize)

                    Library:AddToRegistry(ContextMenu.Inner, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    function ContextMenu:Show()
                        if Library.IsMobile then
                            Library.CanDrag = false;
                        end;

                        self.Container.Visible = true;
                    end

                    function ContextMenu:Hide()
                        if Library.IsMobile then
                            Library.CanDrag = true;
                        end;
                        
                        self.Container.Visible = false;
                    end

                    function ContextMenu:AddOption(Str, Callback)
                        if typeof(Callback) ~= 'function' then
                            Callback = function() end
                        end

                        local Button = Library:CreateLabel({
                            Active = false;
                            Size = UDim2.new(1, 0, 0, 15);
                            TextSize = 13;
                            Text = Str;
                            ZIndex = 16;
                            Parent = self.Inner;
                            TextXAlignment = Enum.TextXAlignment.Left,
                        });

                        Library:OnHighlight(Button, Button, 
                            { TextColor3 = 'AccentColor' },
                            { TextColor3 = 'FontColor' }
                        );

                        Button.InputBegan:Connect(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 or Input.UserInputType ~= Enum.UserInputType.Touch then
                                return
                            end

                            Callback()
                        end)
                    end

                    function ColorPicker:Display()
                        ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
                        SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

                        Library:Create(DisplayFrame, {
                            BackgroundColor3 = ColorPicker.Value;
                            BackgroundTransparency = ColorPicker.Transparency;
                            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
                        });

                        if TransparencyBoxInner then
                            TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value;
                            TransparencyCursor.Position = UDim2.new(1 - ColorPicker.Transparency, 0, 0, 0);
                        end;

                        CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0);
                        HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0);

                        HueBox.Text = '#' .. ColorPicker.Value:ToHex()
                        RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

                        Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value, ColorPicker.Transparency);
                        Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value, ColorPicker.Transparency);
                    end;

                    function ColorPicker:SetValueRGB(Color, Transparency)
                        ColorPicker.Transparency = Transparency or 0;
                        ColorPicker:SetHSVFromRGB(Color);
                        ColorPicker:Display();
                    end;

                    ContextMenu:AddOption('Copy color', function()
                        Library.ColorClipboard = ColorPicker.Value
                        Library:Notify(GetTranslation(Translations, 'Copied color!'), 2)
                    end)

                    ContextMenu:AddOption('Paste color', function()
                        if not Library.ColorClipboard then
                            return Library:Notify(GetTranslation(Translations, 'You have not copied a color!'), 2)
                        end
                        return ColorPicker:SetValueRGB(Library.ColorClipboard)
                    end)

                    ContextMenu:AddOption('Copy HEX', function()
                        pcall(setclipboard, ColorPicker.Value:ToHex())
                        Library:Notify(GetTranslation(Translations, 'Copied hex code to clipboard!'), 2)
                    end)

                    ContextMenu:AddOption('Copy RGB', function()
                        pcall(setclipboard, table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', '))
                        Library:Notify(GetTranslation(Translations, 'Copied RGB values to clipboard!'), 2)
                    end)

                end
                ColorPicker.ContextMenu = ContextMenu;

                Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
                Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
                Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

                Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
                Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
                Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
                Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

                local SequenceTable = {};

                for Hue = 0, 1, 0.1 do
                    table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)));
                end;

                Library:Create('UIGradient', {
                    Color = ColorSequence.new(SequenceTable);
                    Rotation = 90;
                    Parent = HueSelectorInner;
                });

                HueBox.FocusLost:Connect(function(enter)
                    if enter then
                        local success, result = pcall(Color3.fromHex, HueBox.Text)
                        if success and typeof(result) == 'Color3' then
                            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                        end
                    end

                    ColorPicker:Display()
                end)

                RgbBox.FocusLost:Connect(function(enter)
                    if enter then
                        local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                        if r and g and b then
                            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                        end
                    end

                    ColorPicker:Display()
                end)



                function ColorPicker:OnChanged(Func)
                    ColorPicker.Changed = Func;
                    
                    Library:SafeCallback(Func, ColorPicker.Value, ColorPicker.Transparency);
                end;

                if ParentObj.Addons then
                    table.insert(ParentObj.Addons, ColorPicker)
                end

                function ColorPicker:Show()
                    for Frame, Val in Library.OpenedFrames do
                        if Frame.Name == 'Color' then
                            Frame.Visible = false;
                            Library.OpenedFrames[Frame] = nil;
                        end;
                    end;

                    PickerFrameOuter.Visible = true;
                    Library.OpenedFrames[PickerFrameOuter] = true;
                end;

                function ColorPicker:Hide()
                    PickerFrameOuter.Visible = false;
                    Library.OpenedFrames[PickerFrameOuter] = nil;
                end;

                function ColorPicker:SetValue(HSV, Transparency)
                    local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

                    ColorPicker.Transparency = Transparency or 0;
                    ColorPicker:SetHSVFromRGB(Color);
                    ColorPicker:Display();
                end;

                SatVibMap.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                            local MinX = SatVibMap.AbsolutePosition.X;
                            local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                            local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                            local MinY = SatVibMap.AbsolutePosition.Y;
                            local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                            local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                            ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                            ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                            ColorPicker:Display();

                            PreRender:Wait();
                        end;

                        Library:AttemptSave();
                    end;
                end);

                HueSelectorInner.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                            local MinY = HueSelectorInner.AbsolutePosition.Y;
                            local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                            local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                            ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                            ColorPicker:Display();

                            PreRender:Wait();
                        end;

                        Library:AttemptSave();
                    end;
                end);

                DisplayFrame.InputBegan:Connect(function(Input)
                    if Library:MouseIsOverOpenedFrame(Input) then
                        return;
                    end;

                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        if PickerFrameOuter.Visible then
                            ColorPicker:Hide()
                        else
                            ContextMenu:Hide()
                            ColorPicker:Show()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        ContextMenu:Show()
                        ColorPicker:Hide()
                    end
                end);

                if TransparencyBoxInner then
                    TransparencyBoxInner.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                            while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                                local MinX = TransparencyBoxInner.AbsolutePosition.X;
                                local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X;
                                local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                                ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX));

                                ColorPicker:Display();

                                PreRender:Wait();
                            end;

                            Library:AttemptSave();
                        end;
                    end);
                end;

                Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                        if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                            or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                            ColorPicker:Hide();
                        end;

                        if not Library:MouseIsOverFrame(ContextMenu.Container) then
                            ContextMenu:Hide()
                        end
                    end;

                    if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                        if not Library:MouseIsOverFrame(ContextMenu.Container) and not Library:MouseIsOverFrame(DisplayFrame) then
                            ContextMenu:Hide()
                        end
                    end
                end))

                ColorPicker:Display();
                ColorPicker.DisplayFrame = DisplayFrame

                Options[Idx] = ColorPicker;

                return self;
            end;

            function BaseAddonsFuncs:AddKeyPicker(Idx, Info)
                local ParentObj = self;
                local ToggleLabel = self.TextLabel;
                --local Container = self.Container;

                assert(Info.Default, GetTranslation(Translations, "AddKeyPicker: Missing default value."));

                local KeyPicker = {
                    Value = Info.Default;
                    Toggled = false;
                    Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
                    Type = 'KeyPicker';
                    Callback = Info.Callback or function(Value) end;
                    ChangedCallback = Info.ChangedCallback or function(New) end;
                    SyncToggleState = Info.SyncToggleState or false;
                    Clicked = false;
                };

                if KeyPicker.SyncToggleState then
                    Info.Modes = { 'Toggle' }
                    Info.Mode = 'Toggle'
                end

                local PickOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0, 28, 0, 18);
                    ZIndex = 6;
                    Parent = ToggleLabel;
                });

                local PickInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 7;
                    Parent = PickOuter;
                });

                Library:AddToRegistry(PickInner, {
                    BackgroundColor3 = 'BackgroundColor';
                    BorderColor3 = 'OutlineColor';
                });

                local DisplayLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    TextSize = 13;
                    Text = Info.Default;
                    TextWrapped = true;
                    ZIndex = 8;
                    Parent = PickInner;
                });

                local ModeSelectOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
                    Size = UDim2.new(0, 60, 0, 2);
                    Visible = false;
                    ZIndex = 14;
                    Parent = ScreenGui;
                });

                ToggleLabel:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                    ModeSelectOuter.Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
                end);

                local ModeSelectInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 15;
                    Parent = ModeSelectOuter;
                });

                Library:AddToRegistry(ModeSelectInner, {
                    BackgroundColor3 = 'BackgroundColor';
                    BorderColor3 = 'OutlineColor';
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = ModeSelectInner;
                });

                -- Keybinds Text
                local KeybindsToggle = {}
                do
                    local KeybindsToggleContainer = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 0, 18);
                        Visible = false;
                        ZIndex = 110;
                        Parent = Library.KeybindContainer;
                    });

                    local KeybindsToggleOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(0, 13, 0, 13);
                        Position = UDim2.new(0, 0, 0, 6);
                        Visible = true;
                        ZIndex = 110;
                        Parent = KeybindsToggleContainer;
                    });

                    Library:AddToRegistry(KeybindsToggleOuter, {
                        BorderColor3 = 'Black';
                    });

                    local KeybindsToggleInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 111;
                        Parent = KeybindsToggleOuter;
                    });

                    Library:AddToRegistry(KeybindsToggleInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local KeybindsToggleLabel = Library:CreateLabel({
                        BackgroundTransparency = 1;
                        Size = UDim2.new(0, 216, 1, 0);
                        Position = UDim2.new(1, 6, 0, -1);
                        TextSize = 14;
                        Text = "";
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 111;
                        Parent = KeybindsToggleInner;
                    });

                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 4);
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = KeybindsToggleLabel;
                    });

                    local KeybindsToggleRegion = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(0, 170, 1, 0);
                        ZIndex = 113;
                        Parent = KeybindsToggleOuter;
                    });

                    Library:OnHighlight(KeybindsToggleRegion, KeybindsToggleOuter,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' },
                        function()
                            return true
                        end
                    );

                    function KeybindsToggle:Display(State)
                        KeybindsToggleInner.BackgroundColor3 = State and Library.AccentColor or Library.MainColor;
                        KeybindsToggleInner.BorderColor3 = State and Library.AccentColorDark or Library.OutlineColor;
                        KeybindsToggleLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

                        Library.RegistryMap[KeybindsToggleInner].Properties.BackgroundColor3 = State and 'AccentColor' or 'MainColor';
                        Library.RegistryMap[KeybindsToggleInner].Properties.BorderColor3 = State and 'AccentColorDark' or 'OutlineColor';
                        Library.RegistryMap[KeybindsToggleLabel].Properties.TextColor3 = State and 'AccentColor' or 'FontColor';
                    end;

                    function KeybindsToggle:SetText(Text)
                        KeybindsToggleLabel.Text = Text
                    end

                    function KeybindsToggle:SetVisibility(bool)
                        KeybindsToggleContainer.Visible = bool
                    end

                    function KeybindsToggle:SetNormal(bool)
                        KeybindsToggle.Normal = bool

                        KeybindsToggleOuter.BackgroundTransparency = if KeybindsToggle.Normal then 1 else 0;

                        KeybindsToggleInner.BackgroundTransparency = if KeybindsToggle.Normal then 1 else 0;
                        KeybindsToggleInner.BorderSizePixel = if KeybindsToggle.Normal then 0 else 1;

                        KeybindsToggleLabel.Position = if KeybindsToggle.Normal then UDim2.new(1, -13, 0, -1) else UDim2.new(1, 6, 0, -1);
                    end

                    function KeyPicker:DoClick()
                        if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
                            ParentObj:SetValue(not ParentObj.Value)
                        end

                        Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
                        Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
                    end

                    Library:GiveSignal(KeybindsToggleRegion.InputBegan:Connect(function(Input)
                        if KeybindsToggle.Normal then return end
                                                
                        if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end));

                    KeybindsToggle.Loaded = true;
                end;

                local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
                local ModeButtons = {};

                for Idx, Mode in Modes do
                    local ModeButton = {};

                    local Label = Library:CreateLabel({
                        Active = false;
                        Size = UDim2.new(1, 0, 0, 15);
                        TextSize = 13;
                        Text = Mode;
                        ZIndex = 16;
                        Parent = ModeSelectInner;
                    });
                    ModeSelectOuter.Size = ModeSelectOuter.Size + UDim2.new(0, 0, 0, 17)

                    function ModeButton:Select()
                        for _, Button in ModeButtons do
                            Button:Deselect();
                        end;

                        KeyPicker.Mode = Mode;

                        Label.TextColor3 = Library.AccentColor;
                        Library.RegistryMap[Label].Properties.TextColor3 = 'AccentColor';

                        ModeSelectOuter.Visible = false;
                    end;

                    function ModeButton:Deselect()
                        KeyPicker.Mode = nil;

                        Label.TextColor3 = Library.FontColor;
                        Library.RegistryMap[Label].Properties.TextColor3 = 'FontColor';
                    end;

                    Label.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            ModeButton:Select();
                            Library:AttemptSave();
                        end;
                    end);

                    if Mode == KeyPicker.Mode then
                        ModeButton:Select();
                    end;

                    ModeButtons[Mode] = ModeButton;
                end;

                function KeyPicker:Update()
                    if Info.NoUI then
                        return;
                    end;

                    local State = KeyPicker:GetState();
                    local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == 'Toggle';

                    if KeybindsToggle.Loaded then
                        KeybindsToggle:SetNormal(not ShowToggle)

                        KeybindsToggle:SetVisibility(true);
                        KeybindsToggle:SetText(string.format('[%s] %s (%s)', KeyPicker.Value, Info.Text, GetTranslation(Translations, KeyPicker.Mode)));
                        KeybindsToggle:Display(State);
                    end

                    local YSize = 0
                    local XSize = 0

                    for _, Frame in Library.KeybindContainer:GetChildren() do
                        if Frame:IsA('Frame') and Frame.Visible then
                            YSize = YSize + 18;
                            local Label = Frame:FindFirstChild("TextLabel", true)
                            if not Label then continue end

                            if (Label.TextBounds.X > XSize) then
                                XSize = Label.TextBounds.X + 20;
                            end
                        end;

                        --[[if Frame:IsA('TextLabel') and Frame.Visible then
                            YSize = YSize + 18;
                            if (Frame.TextBounds.X > XSize) then
                                XSize = Frame.TextBounds.X;
                            end
                        end;--]]
                    end;

                    Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, (YSize + 23 + 6) * DPIScale)
                end;

                function KeyPicker:GetState()
                    if KeyPicker.Mode == 'Always' then
                        return true;
                    elseif KeyPicker.Mode == 'Hold' then
                        if KeyPicker.Value == GetTranslation(Translations, "None") then
                            return false;
                        end

                        local Key = KeyPicker.Value;

                        if Key == GetTranslation(Translations, "MB1") then
                            return shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        elseif Key == GetTranslation(Translations, "MB2") then
                            return shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
                        else
                            return shared.UserInputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]) and not shared.UserInputService:GetFocusedTextBox();
                        end;
                    else
                        return KeyPicker.Toggled;
                    end;
                end;

                function KeyPicker:SetValue(Data)
                    local Key, Mode = Data[1], Data[2];
                    DisplayLabel.Text = Key;
                    KeyPicker.Value = Key;
                    if ModeButtons[Mode] then ModeButtons[Mode]:Select(); end
                    KeyPicker:Update();
                end;

                function KeyPicker:OnClick(Callback)
                    KeyPicker.Clicked = Callback
                end

                function KeyPicker:OnChanged(Callback)
                    KeyPicker.Changed = Callback
                    Callback(KeyPicker.Value)
                end

                if ParentObj.Addons then
                    table.insert(ParentObj.Addons, KeyPicker)
                end

                function KeyPicker:SetModePickerVisibility(bool)
                    ModeSelectOuter.Visible = bool;
                end

                function KeyPicker:GetModePickerVisibility()
                    return ModeSelectOuter.Visible;
                end

                local Picking = false;

                PickOuter.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                        Picking = true;

                        DisplayLabel.Text = '';

                        local Break;
                        local Text = '';

                        task.spawn(function()
                            while (not Break) do
                                if Text == '...' then
                                    Text = '';
                                end;

                                Text = Text .. '.';
                                DisplayLabel.Text = Text;

                                task.wait(0.4);
                            end;
                        end);

                        task.wait(0.2);

                        local Event;
                        Event = shared.UserInputService.InputBegan:Connect(function(Input)
                            local Key;

                            if Input.UserInputType == Enum.UserInputType.Keyboard then
                                Key = Input.KeyCode.Name;
                            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Key = GetTranslation(Translations, "MB1");
                            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                                Key = GetTranslation(Translations, "MB2");
                            end;

                            Break = true;
                            Picking = false;

                            DisplayLabel.Text = Key;
                            KeyPicker.Value = Key;

                            Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
                            Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

                            Library:AttemptSave();

                            Event:Disconnect();
                        end);
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                        KeyPicker:SetModePickerVisibility(not KeyPicker:GetModePickerVisibility())
                    end;
                end)

                Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input)
                    if KeyPicker.Value == GetTranslation(Translations, "Unknown") then return end
                
                    if (not Picking) and (not shared.UserInputService:GetFocusedTextBox()) then
                        if KeyPicker.Mode == 'Toggle' then
                            local Key = KeyPicker.Value;

                            if Key == GetTranslation(Translations, "MB1") or Key == GetTranslation(Translations, "MB2") then
                                if Key == GetTranslation(Translations, "MB1") and Input.UserInputType == Enum.UserInputType.MouseButton1
                                or Key == GetTranslation(Translations, "MB2") and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    KeyPicker.Toggled = not KeyPicker.Toggled
                                    KeyPicker:DoClick()
                                end;
                            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                                if Input.KeyCode.Name == Key then
                                    KeyPicker.Toggled = not KeyPicker.Toggled;
                                    KeyPicker:DoClick()
                                end;
                            end;
                        end;

                        KeyPicker:Update();
                    end;

                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                        if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                            or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                            KeyPicker:SetModePickerVisibility(false);
                        end;
                    end;
                end))

                Library:GiveSignal(shared.UserInputService.InputEnded:Connect(function(Input)
                    if (not Picking) then
                        KeyPicker:Update();
                    end;
                end))

                KeyPicker:Update();
                KeyPicker.DisplayFrame = PickOuter

                Options[Idx] = KeyPicker;

                return self;
            end;

            function BaseAddonsFuncs:AddDropdown(Idx, Info)
                Info.ReturnInstanceInstead = if typeof(Info.ReturnInstanceInstead) == "boolean" then Info.ReturnInstanceInstead else false;

                if Info.SpecialType == 'Player' then
                    Info.ExcludeLocalPlayer = if typeof(Info.ExcludeLocalPlayer) == "boolean" then Info.ExcludeLocalPlayer else false;

                    Info.Values = GetPlayers(Info.ExcludeLocalPlayer, Info.ReturnInstanceInstead);
                    Info.AllowNull = true;
                elseif Info.SpecialType == 'Team' then
                    Info.Values = GetTeams(Info.ReturnInstanceInstead);
                    Info.AllowNull = true;
                end;

                assert(Info.Values, GetTranslation(Translations, "AddDropdown: Missing dropdown value list."));
                assert(Info.AllowNull or Info.Default, GetTranslation(Translations, "AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional."));

                Info.Searchable = if typeof(Info.Searchable) == "boolean" then Info.Searchable else false;
                Info.FormatDisplayValue = if typeof(Info.FormatDisplayValue) == "function" then Info.FormatDisplayValue else nil;

                local Dropdown = {
                    Values = Info.Values;
                    Value = Info.Multi and {};
                    DisabledValues = Info.DisabledValues or {};
                    Multi = Info.Multi;
                    Type = 'Dropdown';
                    SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
                    Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
                    Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
                    Callback = Info.Callback or function(Value) end;
                    Changed = Info.Changed or function(Value) end;

                    OriginalText = Info.Text; Text = Info.Text;
                    ExcludeLocalPlayer = Info.ExcludeLocalPlayer;
                    ReturnInstanceInstead = Info.ReturnInstanceInstead;
                };

                local Tooltip;

                local ParentObj = self
                local ToggleLabel = self.TextLabel;
                local Container = self.Container;

                local RelativeOffset = 0;

                for _, Element in Container:GetChildren() do
                    if not Element:IsA('UIListLayout') then
                        RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
                    end;
                end;

                local DropdownOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0, 60, 0, 18);
                    Visible = Dropdown.Visible;
                    ZIndex = 6;
                    Parent = ToggleLabel;
                    Name = "drodpwon_outer";
                });

                Library:AddToRegistry(DropdownOuter, {
                    BorderColor3 = 'Black';
                });

                local DropdownInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = DropdownOuter;
                });

                Library:AddToRegistry(DropdownInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                    });
                    Rotation = 90;
                    Parent = DropdownInner;
                });

                local DropdownInnerSearch;
                if Info.Searchable then
                    DropdownInnerSearch = Library:Create('TextBox', {
                        BackgroundTransparency = 1;
                        Visible = false;

                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(0.9, -5, 1, 0);

                        Font = Library.Font;
                        PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                        PlaceholderText = 'Search...';

                        Text = '';
                        TextColor3 = Library.FontColor;
                        TextSize = 14;
                        TextStrokeTransparency = 0;
                        TextXAlignment = Enum.TextXAlignment.Left;

                        ClearTextOnFocus = false;

                        ZIndex = 7;
                        Parent = DropdownOuter;
                    });

                    Library:ApplyTextStroke(DropdownInnerSearch);

                    Library:AddToRegistry(DropdownInnerSearch, {
                        TextColor3 = 'FontColor';
                    });
                end

                local DropdownArrow = Library:Create('ImageLabel', {
                    AnchorPoint = Vector2.new(0, 0.5);
                    BackgroundTransparency = 1;
                    Position = UDim2.new(1, -16, 0.5, 0);
                    Size = UDim2.new(0, 12, 0, 12);
                    Image = 'http://www.roblox.com/asset/?id=6282522798';
                    ZIndex = 8;
                    Parent = DropdownInner;
                });

                local ItemList = Library:CreateLabel({
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -5, 1, 0);
                    TextSize = 14;
                    Text = '--';
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = false;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    RichText = true;
                    ZIndex = 7;
                    Parent = DropdownInner;
                });

                Library:OnHighlight(DropdownOuter, DropdownOuter,
                    { BorderColor3 = 'AccentColor' },
                    { BorderColor3 = 'Black' },
                    function()
                        return not Dropdown.Disabled;
                    end
                );

                if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
                    Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, DropdownOuter)
                    Tooltip.Disabled = Dropdown.Disabled;
                end

                local MAX_DROPDOWN_ITEMS = if typeof(Info.MaxVisibleDropdownItems) == "number" then math.clamp(Info.MaxVisibleDropdownItems, 4, 16) else 8;

                local ListOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    ZIndex = 20;
                    Visible = false;
                    Parent = ScreenGui;
                });

                local function RecalculateListPosition()
                    ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1);
                end;

                local function RecalculateListSize(YSize)
                    local Y = YSize or math.clamp(GetTableSize(Dropdown.Values) * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1;
                    ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X + 0.5, Y)
                end;

                RecalculateListPosition();
                RecalculateListSize();

                DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);
                DropdownOuter:GetPropertyChangedSignal('AbsoluteSize'):Connect(RecalculateListSize);

                local ListInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 21;
                    Parent = ListOuter;
                });

                Library:AddToRegistry(ListInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local Scrolling = Library:Create('ScrollingFrame', {
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    CanvasSize = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 21;
                    Parent = ListInner;

                    TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
                    BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Library.AccentColor,
                });

                Library:AddToRegistry(Scrolling, {
                    ScrollBarImageColor3 = 'AccentColor'
                })

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 0);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Scrolling;
                });

                function Dropdown:UpdateColors()
                    ItemList.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                    DropdownArrow.ImageColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                end;

                function Dropdown:Display()
                    local Values = Dropdown.Values;
                    local Str = '';

                    if Info.Multi then
                        for Idx, Value in Values do
                            local StringValue = if typeof(Value) == "Instance" then Value.Name else Value;

                            if Dropdown.Value[Value] then
                                Str = Str .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue) .. ', ';
                            end;
                        end;

                        Str = Str:sub(1, #Str - 2);
                        ItemList.Text = (Str == '' and '--' or Str);
                    else
                        if not Dropdown.Value then
                            ItemList.Text = '--';
                            return;
                        end;

                        local StringValue = if typeof(Dropdown.Value) == "Instance" then Dropdown.Value.Name else Dropdown.Value;
                        ItemList.Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                    end;

                    local X = Library:GetTextBounds(ItemList.Text, Library.Font, ItemList.TextSize, Vector2.new(ToggleLabel.AbsoluteSize.X, math.huge)) + 26;
                    DropdownOuter.Size = UDim2.new(0, X, 0, 18)
                end;

                function Dropdown:GetActiveValues()
                    if Info.Multi then
                        local T = {};

                        for Value, Bool in Dropdown.Value do
                            table.insert(T, Value);
                        end;

                        return T;
                    else
                        return Dropdown.Value and 1 or 0;
                    end;
                end;

                function Dropdown:BuildDropdownList()
                    local Values = Dropdown.Values;
                    local DisabledValues = Dropdown.DisabledValues;
                    local Buttons = {};

                    for _, Element in Scrolling:GetChildren() do
                        if not Element:IsA('UIListLayout') then
                            Element:Destroy();
                        end;
                    end;

                    local Count = 0;
                    for Idx, Value in Values do
                        local StringValue = if typeof(Value) == "Instance" then Value.Name else Value;
                        if Info.Searchable and not string.lower(StringValue):match(string.lower(DropdownInnerSearch.Text)) then
                            continue;
                        end

                        local IsDisabled = table.find(DisabledValues, StringValue);
                        local Table = {};

                        Count = Count + 1;

                        local Button = Library:Create('TextButton', {
                            AutoButtonColor = false,
                            BackgroundColor3 = Library.MainColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Middle;
                            Size = UDim2.new(1, -1, 0, 20);
                            Text = '';
                            ZIndex = 23;
                            Parent = Scrolling;
                        });

                        Library:AddToRegistry(Button, {
                            BackgroundColor3 = 'MainColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        local ButtonLabel = Library:CreateLabel({
                            Active = false;
                            Size = UDim2.new(1, -6, 1, 0);
                            Position = UDim2.new(0, 6, 0, 0);
                            TextSize = 14;
                            Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            RichText = true;
                            ZIndex = 25;
                            Parent = Button;
                        });

                        Library:OnHighlight(Button, Button,
                            { BorderColor3 = IsDisabled and 'DisabledAccentColor' or 'AccentColor', ZIndex = 24 },
                            { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                        );

                        local Selected;

                        if Info.Multi then
                            Selected = Dropdown.Value[Value];
                        else
                            Selected = Dropdown.Value == Value;
                        end;

                        function Table:UpdateButton()
                            if Info.Multi then
                                Selected = Dropdown.Value[Value];
                            else
                                Selected = Dropdown.Value == Value;
                            end;

                            ButtonLabel.TextColor3 = Selected and Library.AccentColor or (IsDisabled and Library.DisabledAccentColor or Library.FontColor);
                            Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or (IsDisabled and 'DisabledAccentColor' or 'FontColor');
                        end;

                        if not IsDisabled then
                            Button.MouseButton1Click:Connect(function(Input)
                                local Try = not Selected;

                                if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                                else
                                    if Info.Multi then
                                        Selected = Try;

                                        if Selected then
                                            Dropdown.Value[Value] = true;
                                        else
                                            Dropdown.Value[Value] = nil;
                                        end;
                                    else
                                        Selected = Try;

                                        if Selected then
                                            Dropdown.Value = Value;
                                        else
                                            Dropdown.Value = nil;
                                        end;

                                        for _, OtherButton in Buttons do
                                            OtherButton:UpdateButton();
                                        end;
                                    end;

                                    Table:UpdateButton();
                                    Dropdown:Display();
                                    
                                    Library:UpdateDependencyBoxes();
                                    Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                                    Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                                    Library:AttemptSave();
                                end;
                            end);
                        end

                        Table:UpdateButton();
                        Dropdown:Display();

                        Buttons[Button] = Table;
                    end;

                    Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * (20 * DPIScale)) + 1);

                    -- Workaround for silly roblox bug - not sure why it happens but sometimes the dropdown list will be empty
                    -- ... and for some reason refreshing the Visible property fixes the issue??????? thanks roblox!
                    Scrolling.Visible = false;
                    Scrolling.Visible = true;

                    local Y = math.clamp(Count * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1;
                    RecalculateListSize(Y);
                end;

                function Dropdown:SetValues(NewValues)
                    if NewValues then
                        Dropdown.Values = NewValues;
                    end;

                    Dropdown:BuildDropdownList();
                end;

                function Dropdown:AddValues(NewValues)
                    if typeof(NewValues) == "table" then
                        for _, val in NewValues do
                            table.insert(Dropdown.Values, val);
                        end
                    elseif typeof(NewValues) == "string" then
                        table.insert(Dropdown.Values, NewValues);
                    else
                        return;
                    end

                    Dropdown:BuildDropdownList();
                end;

                function Dropdown:SetDisabledValues(NewValues)
                    if NewValues then
                        Dropdown.DisabledValues = NewValues;
                    end;

                    Dropdown:BuildDropdownList();
                end

                function Dropdown:AddDisabledValues(DisabledValues)
                    if typeof(DisabledValues) == "table" then
                        for _, val in DisabledValues do
                            table.insert(Dropdown.DisabledValues, val)
                        end
                    elseif typeof(DisabledValues) == "string" then
                        table.insert(Dropdown.DisabledValues, DisabledValues)
                    else
                        return
                    end

                    Dropdown:BuildDropdownList()
                end

                function Dropdown:SetVisible(Visibility)
                    Dropdown.Visible = Visibility;

                    DropdownOuter.Visible = Dropdown.Visible;
                    if not Dropdown.Visible then Dropdown:CloseDropdown(); end;
                end;

                function Dropdown:SetDisabled(Disabled)
                    Dropdown.Disabled = Disabled;

                    if Tooltip then
                        Tooltip.Disabled = Disabled;
                    end

                    if Disabled then
                        Dropdown:CloseDropdown();
                    end

                    Dropdown:Display();
                    Dropdown:UpdateColors();
                end;

                function Dropdown:OpenDropdown()
                    if Dropdown.Disabled then
                        return;
                    end;

                    if Library.IsMobile then
                        Library.CanDrag = false;
                    end;

                    if Info.Searchable then
                        ItemList.Visible = false;
                        DropdownInnerSearch.Text = "";
                        DropdownInnerSearch.Visible = true;
                    end

                    ListOuter.Visible = true;
                    Library.OpenedFrames[ListOuter] = true;
                    DropdownArrow.Rotation = 180;

                    RecalculateListSize();
                end;

                function Dropdown:CloseDropdown()
                    if Library.IsMobile then         
                        Library.CanDrag = true;
                    end;

                    if Info.Searchable then
                        DropdownInnerSearch.Text = "";
                        DropdownInnerSearch.Visible = false;
                        ItemList.Visible = true;
                    end

                    ListOuter.Visible = false;
                    Library.OpenedFrames[ListOuter] = nil;
                    DropdownArrow.Rotation = 0;
                end;

                function Dropdown:OnChanged(Func)
                    Dropdown.Changed = Func;

                    if Dropdown.Disabled then
                        return;
                    end;

                    Library:SafeCallback(Func, Dropdown.Value);
                end;

                function Dropdown:SetValue(Val)
                    if Dropdown.Multi then
                        local nTable = {};

                        for Value, Bool in Val do
                            if table.find(Dropdown.Values, Value) then
                                nTable[Value] = true
                            end;
                        end;

                        Dropdown.Value = nTable;
                    else
                        if (not Val) then
                            Dropdown.Value = nil;
                        elseif table.find(Dropdown.Values, Val) then
                            Dropdown.Value = Val;
                        end;
                    end;

                    Dropdown:BuildDropdownList();

                    if not Dropdown.Disabled then
                        Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                        Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
                    end;
                end;

                function Dropdown:SetText(...)
                    -- This is an Compat dropdown for Toggles, it doesn't have an TextLabel --
                    return;
                end;

                DropdownOuter.InputBegan:Connect(function(Input)
                    if Dropdown.Disabled then
                        return;
                    end;

                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                        if ListOuter.Visible then
                            Dropdown:CloseDropdown();
                        else
                            Dropdown:OpenDropdown();
                        end;
                    end;
                end);

                if Info.Searchable then
                    DropdownInnerSearch:GetPropertyChangedSignal("Text"):Connect(function()
                        Dropdown:BuildDropdownList()
                    end);
                end;

                shared.UserInputService.InputBegan:Connect(function(Input)
                    if Dropdown.Disabled then
                        return;
                    end;

                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                        if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                            or Mouse.Y < (AbsPos.Y - (20 * DPIScale) - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                            Dropdown:CloseDropdown();
                        end;
                    end;
                end);

                Dropdown:BuildDropdownList();
                Dropdown:Display();

                local Defaults = {}

                if typeof(Info.Default) == "string" then
                    local _Idx = table.find(Dropdown.Values, Info.Default)
                    if _Idx then
                        table.insert(Defaults, _Idx)
                    end
                elseif typeof(Info.Default) == 'table' then
                    for _, Value in Info.Default do
                        local _Idx = table.find(Dropdown.Values, Value)
                        if _Idx then
                            table.insert(Defaults, _Idx)
                        end
                    end
                elseif typeof(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
                    table.insert(Defaults, Info.Default)
                end

                if next(Defaults) then
                    for i = 1, #Defaults do
                        local Index = Defaults[i]
                        if Info.Multi then
                            Dropdown.Value[Dropdown.Values[Index]] = true
                        else
                            Dropdown.Value = Dropdown.Values[Index];
                        end

                        if (not Info.Multi) then break end
                    end

                    Dropdown:BuildDropdownList();
                    Dropdown:Display();
                end

                task.delay(0.1, Dropdown.UpdateColors, Dropdown)

                Dropdown.DisplayFrame = DropdownOuter;
                if ParentObj.Addons then
                    table.insert(ParentObj.Addons, Dropdown)
                end

                Options[Idx] = Dropdown;

                return self;
            end;

            BaseAddons.__index = BaseAddonsFuncs;
            BaseAddons.__namecall = function(Table, Key, ...)
                return BaseAddonsFuncs[Key](...);
            end;
        end;

        local BaseGroupbox = {};

        do
            local BaseGroupboxFuncs = {};

            function BaseGroupboxFuncs:AddBlank(Size, Visible)
                local Groupbox = self;
                local Container = Groupbox.Container;

                return Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(1, 0, 0, Size);
                    Visible = if typeof(Visible) == "boolean" then Visible else true;
                    ZIndex = 1;
                    Parent = Container;
                });
            end;

            function BaseGroupboxFuncs:AddLabel(...)
                local Data = {}

                if select(2, ...) ~= nil and typeof(select(2, ...)) == "table" then
                    if select(1, ...) ~= nil then
                        assert(typeof(select(1, ...)) == "string", GetTranslation(Translations, "Expected string for Idx, got ") .. typeof(select(1, ...)))
                    end

                    local Params = select(2, ...)

                    Data.Text = Params.Text or ""
                    Data.DoesWrap = Params.DoesWrap or false
                    Data.Idx = select(1, ...)
                else
                    Data.Text = select(1, ...) or ""
                    Data.DoesWrap = select(2, ...) or false
                    Data.Idx = select(3, ...) or nil
                end

                Data.OriginalText = Data.Text;
                
                local Label = {

                };

                local Groupbox = self;
                local Container = Groupbox.Container;

                local TextLabel = Library:CreateLabel({
                    Size = UDim2.new(1, -4, 0, 15);
                    TextSize = 14;
                    Text = Data.Text;
                    TextWrapped = Data.DoesWrap or false,
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 5;
                    Parent = Container;
                    RichText = true;
                });

                if Data.DoesWrap then
                    local Y = select(2, Library:GetTextBounds(Data.Text, Library.Font, 14 * DPIScale, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                    TextLabel.Size = UDim2.new(1, -4, 0, Y)
                else
                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 4 * DPIScale);
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = TextLabel;
                    });
                end

                Label.TextLabel = TextLabel;
                Label.Container = Container;

                function Label:SetText(Text)
                    TextLabel.Text = Text

                    if Data.DoesWrap then
                        local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14 * DPIScale, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                        TextLabel.Size = UDim2.new(1, -4, 0, Y)
                    end

                    Groupbox:Resize();
                end

                if (not Data.DoesWrap) then
                    setmetatable(Label, BaseAddons);
                end

                Groupbox:AddBlank(5);
                Groupbox:Resize();
                
                if Data.Idx then
                    -- Options[Data.Idx] = Label;
                    Labels[Data.Idx] = Label;
                else
                    table.insert(Labels, Label);
                end

                return Label;
            end;
            
            function BaseGroupboxFuncs:AddButton(...)
                local Button = typeof(select(1, ...)) == "table" and select(1, ...) or {
                    Text = select(1, ...),
                    Func = select(2, ...)
                }
                Button.OriginalText = Button.Text;
                
                assert(typeof(Button.Func) == 'function', GetTranslation(Translations, "AddButton: `Func` callback is missing."));

                local Blank = nil;
                local Groupbox = self;
                local Container = Groupbox.Container;
                local IsVisible = if typeof(Button.Visible) == "boolean" then Button.Visible else true;

                local function CreateBaseButton(Button)
                    local Outer = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, -4, 0, 20);
                        Visible = IsVisible;
                        ZIndex = 5;
                    });

                    local Inner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = Outer;
                    });

                    local Label = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 1, 0);
                        TextSize = 14;
                        Text = Button.Text;
                        ZIndex = 6;
                        Parent = Inner;
                        RichText = true;
                    });

                    Library:Create('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                        });
                        Rotation = 90;
                        Parent = Inner;
                    });

                    Library:AddToRegistry(Outer, {
                        BorderColor3 = 'Black';
                    });

                    Library:AddToRegistry(Inner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Library:OnHighlight(Outer, Outer,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' }
                    );

                    return Outer, Inner, Label
                end

                local function InitEvents(Button)
                    local function WaitForEvent(event, timeout, validator)
                        local bindable = Instance.new('BindableEvent')
                        local connection = event:Once(function(...)

                            if typeof(validator) == 'function' and validator(...) then
                                bindable:Fire(true)
                            else
                                bindable:Fire(false)
                            end
                        end)
                        task.delay(timeout, function()
                            connection:disconnect()
                            bindable:Fire(false)
                        end)
                        return bindable.Event:Wait()
                    end

                    local function ValidateClick(Input)
                        if Library:MouseIsOverOpenedFrame(Input) then
                            return false
                        end

                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            return true
                        elseif Input.UserInputType == Enum.UserInputType.Touch then
                            return true
                        else
                            return false
                        end
                    end

                    Button.Outer.InputBegan:Connect(function(Input)
                        if Button.Disabled then
                            return;
                        end;

                        if not ValidateClick(Input) then return end
                        if Button.Locked then return end

                        if Button.DoubleClick then
                            Library:RemoveFromRegistry(Button.Label)
                            Library:AddToRegistry(Button.Label, { TextColor3 = 'AccentColor' })

                            Button.Label.TextColor3 = Library.AccentColor
                            Button.Label.Text = GetTranslation(Translations, 'Are you sure?')
                            Button.Locked = true

                            local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

                            Library:RemoveFromRegistry(Button.Label)
                            Library:AddToRegistry(Button.Label, { TextColor3 = 'FontColor' })

                            Button.Label.TextColor3 = Library.FontColor
                            Button.Label.Text = Button.Text
                            task.defer(rawset, Button, 'Locked', false)

                            if clicked then
                                Library:SafeCallback(Button.Func)
                            end

                            return
                        end

                        Library:SafeCallback(Button.Func);
                    end)
                end

                Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
                Button.Outer.Parent = Container

                InitEvents(Button)

                function Button:AddButton(...)
                    local SubButton = typeof(select(1, ...)) == "table" and select(1, ...) or {
                        Text = select(1, ...),
                        Func = select(2, ...)
                    }

                    assert(typeof(SubButton.Func) == 'function', GetTranslation(Translations, "AddButton: `Func` callback is missing."));

                    self.Outer.Size = UDim2.new(0.5, -2, 0, 20 * DPIScale)

                    SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

                    SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
                    SubButton.Outer.Size = UDim2.fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
                    SubButton.Outer.Parent = self.Outer

                    function SubButton:UpdateColors()
                        SubButton.Label.TextColor3 = SubButton.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                    end;

                    function SubButton:AddToolTip(tooltip, disabledTooltip)
                        if typeof(tooltip) == "string" or typeof(disabledTooltip) == "string" then
                            if SubButton.TooltipTable then
                                SubButton.TooltipTable:Destroy()
                            end
                        
                            SubButton.TooltipTable = Library:AddToolTip(tooltip, disabledTooltip, self.Outer)
                            SubButton.TooltipTable.Disabled = SubButton.Disabled;
                        end

                        return SubButton
                    end

                    function SubButton:SetDisabled(Disabled)
                        SubButton.Disabled = Disabled;

                        if SubButton.TooltipTable then
                            SubButton.TooltipTable.Disabled = Disabled;
                        end

                        SubButton:UpdateColors();
                    end;

                    function SubButton:SetText(Text)
                        if typeof(Text) == "string" then
                            SubButton.Text = Text;
                            SubButton.Label.Text = SubButton.Text;
                        end
                    end;

                    if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                        SubButton.TooltipTable = SubButton:AddToolTip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Outer)
                        SubButton.TooltipTable.Disabled = SubButton.Disabled;
                    end

                    task.delay(0.1, SubButton.UpdateColors, SubButton);
                    InitEvents(SubButton)

                    table.insert(Buttons, SubButton);
                    return SubButton
                end

                function Button:UpdateColors()
                    Button.Label.TextColor3 = Button.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                end;

                function Button:AddToolTip(tooltip, disabledTooltip)
                    if typeof(tooltip) == "string" or typeof(disabledTooltip) == "string" then
                        if Button.TooltipTable then
                            Button.TooltipTable:Destroy()
                        end

                        Button.TooltipTable = Library:AddToolTip(tooltip, disabledTooltip, self.Outer)
                        Button.TooltipTable.Disabled = Button.Disabled;
                    end

                    return Button
                end;

                if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
                    Button.TooltipTable = Button:AddToolTip(Button.Tooltip, Button.DisabledTooltip, Button.Outer)
                    Button.TooltipTable.Disabled = Button.Disabled;
                end

                function Button:SetVisible(Visibility)
                    IsVisible = Visibility;

                    Button.Outer.Visible = IsVisible;
                    if Blank then Blank.Visible = IsVisible end;

                    Groupbox:Resize();
                end;

                function Button:SetText(Text)
                    if typeof(Text) == "string" then
                        Button.Text = Text;
                        Button.Label.Text = Button.Text;
                    end
                end;

                function Button:SetDisabled(Disabled)
                    Button.Disabled = Disabled;

                    if Button.TooltipTable then
                        Button.TooltipTable.Disabled = Disabled;
                    end

                    Button:UpdateColors();
                end;

                task.delay(0.1, Button.UpdateColors, Button);
                Blank = Groupbox:AddBlank(5, IsVisible);
                Groupbox:Resize();

                table.insert(Buttons, Button);
                return Button;
            end;

            function BaseGroupboxFuncs:AddDivider()
                local Groupbox = self;
                local Container = self.Container

                Groupbox:AddBlank(2);
                local DividerOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(1, -4, 0, 5);
                    ZIndex = 5;
                    Parent = Container;
                });

                local DividerInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = DividerOuter;
                });

                Library:AddToRegistry(DividerOuter, {
                    BorderColor3 = 'Black';
                });

                Library:AddToRegistry(DividerInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                Groupbox:AddBlank(9);
                Groupbox:Resize();
            end

            function BaseGroupboxFuncs:AddInput(Idx, Info)
                assert(Info.Text, GetTranslation(Translations, "AddInput: Missing `Text` string."))

                Info.ClearTextOnFocus = if typeof(Info.ClearTextOnFocus) == "boolean" then Info.ClearTextOnFocus else true;

                local Textbox = {
                    Value = Info.Default or '';
                    Numeric = Info.Numeric or false;
                    Finished = Info.Finished or false;
                    Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
                    Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
                    AllowEmpty = if typeof(Info.AllowEmpty) == "boolean" then Info.AllowEmpty else true;
                    EmptyReset = if typeof(Info.EmptyReset) == "string" then Info.EmptyReset else "---";
                    Type = 'Input';

                    Callback = Info.Callback or function(Value) end;
                };

                local Groupbox = self;
                local Container = Groupbox.Container;
                local Blank;

                local InputLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 0, 15);
                    TextSize = 14;
                    Text = Info.Text;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 5;
                    Parent = Container;
                });

                Groupbox:AddBlank(1);

                local TextBoxOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(1, -4, 0, 20);
                    ZIndex = 5;
                    Parent = Container;
                });

                local TextBoxInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = TextBoxOuter;
                });

                Library:AddToRegistry(TextBoxInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                Library:OnHighlight(TextBoxOuter, TextBoxOuter,
                    { BorderColor3 = 'AccentColor' },
                    { BorderColor3 = 'Black' }
                );

                local TooltipTable;
                if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
                    TooltipTable = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, TextBoxOuter)
                    TooltipTable.Disabled = Textbox.Disabled;
                end

                Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                    });
                    Rotation = 90;
                    Parent = TextBoxInner;
                });

                local _Container = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    ClipsDescendants = true;

                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -5, 1, 0);

                    ZIndex = 7;
                    Parent = TextBoxInner;
                })

                local Box = Library:Create('TextBox', {
                    BackgroundTransparency = 1;

                    Position = UDim2.fromOffset(0, 0),
                    Size = UDim2.fromScale(5, 1),

                    Font = Library.Font;
                    PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                    PlaceholderText = Info.Placeholder or '';

                    Text = Info.Default or (if Textbox.AllowEmpty == false then Textbox.EmptyReset else "---");
                    TextColor3 = Library.FontColor;
                    TextSize = 14;
                    TextStrokeTransparency = 0;
                    TextXAlignment = Enum.TextXAlignment.Left;

                    TextEditable = not Textbox.Disabled;
                    ClearTextOnFocus = not Textbox.Disabled and Info.ClearTextOnFocus;

                    ZIndex = 7;
                    Parent = _Container;
                });

                Library:ApplyTextStroke(Box);

                Library:AddToRegistry(Box, {
                    TextColor3 = 'FontColor';
                });

                function Textbox:OnChanged(Func)
                    Textbox.Changed = Func;

                    if Textbox.Disabled then
                        return;
                    end;

                    Library:SafeCallback(Func, Textbox.Value);
                end;

                function Textbox:UpdateColors()
                    Box.TextColor3 = Textbox.Disabled and Library.DisabledAccentColor or Library.FontColor;

                    Library.RegistryMap[Box].Properties.TextColor3 = Textbox.Disabled and 'DisabledAccentColor' or 'FontColor';
                end;

                function Textbox:Display()
                    TextBoxOuter.Visible = Textbox.Visible;
                    InputLabel.Visible = Textbox.Visible;
                    if Blank then Blank.Visible = Textbox.Visible; end

                    Groupbox:Resize();
                end;

                function Textbox:SetValue(Text)
                if not Textbox.AllowEmpty and Trim(Text) == "" then
                Text = Textbox.EmptyReset;
                end

                    if Info.MaxLength and #Text > Info.MaxLength then
                        Text = Text:sub(1, Info.MaxLength);
                    end;

                    if Textbox.Numeric then
                        if (not tonumber(Text)) and Text:len() > 0 then
                            Text = Textbox.Value
                        end
                    end

                    Textbox.Value = Text;
                    Box.Text = Text;

                    if not Textbox.Disabled then
                        Library:SafeCallback(Textbox.Callback, Textbox.Value);
                        Library:SafeCallback(Textbox.Changed, Textbox.Value);
                    end;
                end;

                function Textbox:SetVisible(Visibility)
                    Textbox.Visible = Visibility;

                    Textbox:Display();
                end;

                function Textbox:SetDisabled(Disabled)
                    Textbox.Disabled = Disabled;

                    Box.TextEditable = not Disabled;
                    Box.ClearTextOnFocus = not Disabled and Info.ClearTextOnFocus;

                    if TooltipTable then
                        TooltipTable.Disabled = Disabled;
                    end

                    Textbox:UpdateColors();
                end;

                if Textbox.Finished then
                    Box.FocusLost:Connect(function(enter)
                        if not enter then return end

                        Textbox:SetValue(Box.Text);
                        Library:AttemptSave();
                    end)
                else
                    Box:GetPropertyChangedSignal('Text'):Connect(function()
                        Textbox:SetValue(Box.Text);
                        Library:AttemptSave();
                    end);
                end

                -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
                -- thank you nicemike40 :)

                local function Update()
                    local PADDING = 2
                    local reveal = _Container.AbsoluteSize.X

                    if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                        -- we aren't focused, or we fit so be normal
                        Box.Position = UDim2.new(0, PADDING, 0, 0)
                    else
                        -- we are focused and don't fit, so adjust position
                        local cursor = Box.CursorPosition
                        if cursor ~= -1 then
                            -- calculate pixel width of text from start to cursor
                            local subtext = string.sub(Box.Text, 1, cursor-1)
                            local width = shared.TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

                            -- check if we're inside the box with the cursor
                            local currentCursorPos = Box.Position.X.Offset + width

                            -- adjust if necessary
                            if currentCursorPos < PADDING then
                                Box.Position = UDim2.fromOffset(PADDING-width, 0)
                            elseif currentCursorPos > reveal - PADDING - 1 then
                                Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                            end
                        end
                    end
                end

                task.spawn(Update)

                Box:GetPropertyChangedSignal('Text'):Connect(Update)
                Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
                Box.FocusLost:Connect(Update)
                Box.Focused:Connect(Update)

                Blank = Groupbox:AddBlank(5, Textbox.Visible);
                task.delay(0.1, Textbox.UpdateColors, Textbox);
                Textbox:Display();
                Groupbox:Resize();

                Options[Idx] = Textbox;

                return Textbox;
            end;

            function BaseGroupboxFuncs:AddToggle(Idx, Info)
                assert(Info.Text, GetTranslation(Translations, "AddInput: Missing `Text` string."))

                local Toggle = {
                    Value = Info.Default or false;
                    Type = 'Toggle';
                    Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
                    Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
                    Risky = if typeof(Info.Risky) == "boolean" then Info.Risky else false;
                    OriginalText = Info.Text; Text = Info.Text;

                    Callback = Info.Callback or function(Value) end;
                    Addons = {};
                };

                local Blank;
                local Tooltip;
                local Groupbox = self;
                local Container = Groupbox.Container;

                local ToggleOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0, 13, 0, 13);
                    Visible = Toggle.Visible;
                    ZIndex = 5;
                    Parent = Container;
                });

                Library:AddToRegistry(ToggleOuter, {
                    BorderColor3 = 'Black';
                });

                local ToggleInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = ToggleOuter;
                });

                Library:AddToRegistry(ToggleInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local ToggleLabel = Library:CreateLabel({
                    Size = UDim2.new(0, 216, 2, 0);
                    Position = UDim2.new(1, 6, -0.5, 0);
                    TextSize = 14;
                    Text = Info.Text;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 6;
                    Parent = ToggleInner;
                    RichText = true;
                });

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 4);
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = ToggleLabel;
                });

                local ToggleRegion = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(0, 170, 1, 0);
                    ZIndex = 8;
                    Parent = ToggleOuter;
                });

                Library:OnHighlight(ToggleRegion, ToggleOuter,
                    { BorderColor3 = 'AccentColor' },
                    { BorderColor3 = 'Black' },
                    function()
                        if Toggle.Disabled then
                            return false;
                        end;

                        for _, Addon in Toggle.Addons do
                            if Library:MouseIsOverFrame(Addon.DisplayFrame) then return false end
                        end
                        return true
                    end
                );

                function Toggle:UpdateColors()
                    Toggle:Display();
                end;

                if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
                    Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, ToggleRegion)
                    Tooltip.Disabled = Toggle.Disabled;
                end

                function Toggle:Display()
                    if Toggle.Disabled then
                        ToggleLabel.TextColor3 = Library.DisabledTextColor;

                        ToggleInner.BackgroundColor3 = Toggle.Value and Library.DisabledAccentColor or Library.MainColor;
                        ToggleInner.BorderColor3 = Library.DisabledOutlineColor;

                        Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'DisabledAccentColor' or 'MainColor';
                        Library.RegistryMap[ToggleInner].Properties.BorderColor3 = 'DisabledOutlineColor';
                        Library.RegistryMap[ToggleLabel].Properties.TextColor3 = 'DisabledTextColor';

                        return;
                    end;

                    ToggleLabel.TextColor3 = Toggle.Risky and Library.RiskColor or Color3.new(1, 1, 1);

                    ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor;
                    ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

                    Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
                    Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';

                    Library.RegistryMap[ToggleLabel].Properties.TextColor3 = Toggle.Risky and 'RiskColor' or nil;
                end;

                function Toggle:OnChanged(Func)
                    Toggle.Changed = Func;

                    if Toggle.Disabled then
                        return;
                    end;

                    Library:SafeCallback(Func, Toggle.Value);
                end;

                function Toggle:SetValue(Bool)
                    if Toggle.Disabled then
                        return;
                    end;

                    Bool = (not not Bool);

                    Toggle.Value = Bool;
                    Toggle:Display();

                    for _, Addon in Toggle.Addons do
                        if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                            Addon.Toggled = Bool
                            Addon:Update()
                        end
                    end

                    if not Toggle.Disabled then
                        Library:SafeCallback(Toggle.Callback, Toggle.Value);
                        Library:SafeCallback(Toggle.Changed, Toggle.Value);
                    end;

                    Library:UpdateDependencyBoxes();
                end;

                function Toggle:SetVisible(Visibility)
                    Toggle.Visible = Visibility;

                    ToggleOuter.Visible = Toggle.Visible;
                    if Blank then Blank.Visible = Toggle.Visible end;

                    Groupbox:Resize();
                end;

                function Toggle:SetDisabled(Disabled)
                    Toggle.Disabled = Disabled;

                    if Tooltip then
                        Tooltip.Disabled = Disabled;
                    end

                    Toggle:Display();
                end;

                function Toggle:SetText(Text)
                    if typeof(Text) == "string" then
                        Toggle.Text = Text;
                        ToggleLabel.Text = Toggle.Text;
                    end
                end;

                ToggleRegion.InputBegan:Connect(function(Input)
                    if Toggle.Disabled then
                        return;
                    end;

                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                        for _, Addon in Toggle.Addons do
                            if Library:MouseIsOverFrame(Addon.DisplayFrame) then return end
                        end

                        Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                        Library:AttemptSave();
                    end;
                end);

                if Toggle.Risky == true then
                    Library:RemoveFromRegistry(ToggleLabel)

                    ToggleLabel.TextColor3 = Library.RiskColor
                    Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
                end

                Toggle:Display();
                Blank = Groupbox:AddBlank(Info.BlankSize or 5 + 2, Toggle.Visible);
                Groupbox:Resize();

                Toggle.TextLabel = ToggleLabel;
                Toggle.Container = Container;
                setmetatable(Toggle, BaseAddons);

                Toggles[Idx] = Toggle;

                Library:UpdateDependencyBoxes();

                return Toggle;
            end;

            function BaseGroupboxFuncs:AddSlider(Idx, Info)
                assert(Info.Default, GetTranslation(Translations, "AddSlider: Missing default value."));
                assert(Info.Text, GetTranslation(Translations, "AddSlider: Missing slider text."));
                assert(Info.Min, GetTranslation(Translations, "AddSlider: Missing minimum value."));
                assert(Info.Max, GetTranslation(Translations, "AddSlider: Missing maximum value."));
                assert(Info.Rounding, GetTranslation(Translations, "AddSlider: Missing rounding value."));

                local Slider = {
                    Value = Info.Default;
                    Min = Info.Min;
                    Max = Info.Max;
                    Rounding = Info.Rounding;
                    MaxSize = 232;
                    Type = 'Slider';
                    Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
                    Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
                    OriginalText = Info.Text; Text = Info.Text;

                    Prefix = typeof(Info.Prefix) == "string" and Info.Prefix or "";
                    Suffix = typeof(Info.Suffix) == "string" and Info.Suffix or "";

                    Callback = Info.Callback or function(Value) end;
                };

                local Blanks = {};
                local SliderText = nil;
                local Groupbox = self;
                local Container = Groupbox.Container;
                local Tooltip;

                if not Info.Compact then
                    SliderText = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 0, 10);
                        TextSize = 14;
                        Text = Info.Text;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Bottom;
                        Visible = Slider.Visible;
                        ZIndex = 5;
                        Parent = Container;
                        RichText = true;
                    });

                    table.insert(Blanks, Groupbox:AddBlank(3, Slider.Visible));
                end

                local SliderOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(1, -4, 0, 13);
                    Visible = Slider.Visible;
                    ZIndex = 5;
                    Parent = Container;
                });

                SliderOuter:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
                    Slider.MaxSize = SliderOuter.AbsoluteSize.X - 2;
                end);

                Library:AddToRegistry(SliderOuter, {
                    BorderColor3 = 'Black';
                });

                local SliderInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = SliderOuter;
                });

                Library:AddToRegistry(SliderInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local Fill = Library:Create('Frame', {
                    BackgroundColor3 = Library.AccentColor;
                    BorderColor3 = Library.AccentColorDark;
                    Size = UDim2.new(0, 0, 1, 0);
                    ZIndex = 7;
                    Parent = SliderInner;
                });

                Library:AddToRegistry(Fill, {
                    BackgroundColor3 = 'AccentColor';
                    BorderColor3 = 'AccentColorDark';
                });

                local HideBorderRight = Library:Create('Frame', {
                    BackgroundColor3 = Library.AccentColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(1, 0, 0, 0);
                    Size = UDim2.new(0, 1, 1, 0);
                    ZIndex = 8;
                    Parent = Fill;
                });

                Library:AddToRegistry(HideBorderRight, {
                    BackgroundColor3 = 'AccentColor';
                });

                local DisplayLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    TextSize = 14;
                    Text = GetTranslation(Translations, 'Infinite');
                    ZIndex = 9;
                    Parent = SliderInner;
                    RichText = true;
                });

                Library:OnHighlight(SliderOuter, SliderOuter,
                    { BorderColor3 = 'AccentColor' },
                    { BorderColor3 = 'Black' },
                    function()
                        return not Slider.Disabled;
                    end
                );

                if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
                    Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, SliderOuter)
                    Tooltip.Disabled = Slider.Disabled;
                end

                function Slider:UpdateColors()
                    if SliderText then
                        SliderText.TextColor3 = Slider.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                    end;
                    DisplayLabel.TextColor3 = Slider.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);

                    HideBorderRight.BackgroundColor3 = Slider.Disabled and Library.DisabledAccentColor or Library.AccentColor;

                    Fill.BackgroundColor3 = Slider.Disabled and Library.DisabledAccentColor or Library.AccentColor;
                    Fill.BorderColor3 = Slider.Disabled and Library.DisabledOutlineColor or Library.AccentColorDark;

                    Library.RegistryMap[HideBorderRight].Properties.BackgroundColor3 = Slider.Disabled and 'DisabledAccentColor' or 'AccentColor';

                    Library.RegistryMap[Fill].Properties.BackgroundColor3 = Slider.Disabled and 'DisabledAccentColor' or 'AccentColor';
                    Library.RegistryMap[Fill].Properties.BorderColor3 = Slider.Disabled and 'DisabledOutlineColor' or 'AccentColorDark';
                end;
                
                function Slider:Display()
                    if Info.Compact then
                        DisplayLabel.Text = Slider.Text .. ': ' .. Slider.Prefix .. Slider.Value .. Slider.Suffix;
                    elseif Info.HideMax then
                        DisplayLabel.Text = string.format('%s', Slider.Prefix .. Slider.Value .. Slider.Suffix);
                    else
                        DisplayLabel.Text = string.format('%s/%s', Slider.Prefix .. Slider.Value .. Slider.Suffix, Slider.Prefix .. Slider.Max .. Slider.Suffix);
                    end

                    local X = Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, 1);
                    Fill.Size = UDim2.new(X, 0, 1, 0);

                    -- I have no idea what this is
                    HideBorderRight.Visible = not (X == 1 or X == 0);
                end;

                function Slider:OnChanged(Func)
                    Slider.Changed = Func;

                    if Slider.Disabled then
                        return;
                    end;
                    
                    Library:SafeCallback(Func, Slider.Value);
                end;

                local function Round(Value)
                    if Slider.Rounding == 0 then
                        return math.floor(Value);
                    end;

                    return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
                end;

                function Slider:GetValueFromXScale(X)
                    return Round(Library:MapValue(X, 0, 1, Slider.Min, Slider.Max));
                end;
                
                function Slider:SetMax(Value)
                    assert(Value > Slider.Min, GetTranslation(Translations, "Max value cannot be less than the current min value."));

                    Slider.Value = math.clamp(Slider.Value, Slider.Min, Value);
                    Slider.Max = Value;
                    Slider:Display();
                end;

                function Slider:SetMin(Value)
                    assert(Value < Slider.Max, GetTranslation(Translations, "Min value cannot be greater than the current max value."));

                    Slider.Value = math.clamp(Slider.Value, Value, Slider.Max);
                    Slider.Min = Value;
                    Slider:Display();
                end;

                function Slider:SetValue(Str)
                    if Slider.Disabled then
                        return;
                    end;

                    local Num = tonumber(Str);

                    if (not Num) then
                        return;
                    end;

                    Num = math.clamp(Num, Slider.Min, Slider.Max);

                    Slider.Value = Num;
                    Slider:Display();

                    if not Slider.Disabled then
                        Library:SafeCallback(Slider.Callback, Slider.Value);
                        Library:SafeCallback(Slider.Changed, Slider.Value);
                    end;
                end;

                function Slider:SetVisible(Visibility)
                    Slider.Visible = Visibility;

                    if SliderText then SliderText.Visible = Slider.Visible end;
                    SliderOuter.Visible = Slider.Visible;

                    for _, Blank in Blanks do
                        Blank.Visible = Slider.Visible
                    end

                    Groupbox:Resize();
                end;

                function Slider:SetDisabled(Disabled)
                    Slider.Disabled = Disabled;

                    if Tooltip then
                        Tooltip.Disabled = Disabled;
                    end

                    Slider:UpdateColors();
                end;

                function Slider:SetText(Text)
                    if typeof(Text) == "string" then
                        Slider.Text = Text;

                        if SliderText then SliderText.Text = Slider.Text end;
                        Slider:Display();
                    end
                end;

                function Slider:SetPrefix(Prefix)
                    if typeof(Prefix) == "string" then
                        Slider.Prefix = Prefix;
                        Slider:Display();
                    end
                end;

                function Slider:SetSuffix(Suffix)
                    if typeof(Suffix) == "string" then
                        Slider.Suffix = Suffix;
                        Slider:Display();
                    end
                end;

                SliderInner.InputBegan:Connect(function(Input)
                    if Slider.Disabled then
                        return;
                    end;

                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                        if Library.IsMobile then
                            Library.CanDrag = false;
                        end;

                        local Sides = {};
                        if Library.Window then
                            Sides = Library.Window.Tabs[Library.ActiveTab]:GetSides();
                        end

                        for _, Side in Sides do
                            if typeof(Side) == "Instance" then
                                if Side:IsA("ScrollingFrame") then
                                    Side.ScrollingEnabled = false;
                                end
                            end;
                        end;

                        local mPos = Mouse.X;
                        local gPos = Fill.AbsoluteSize.X;
                        local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                        while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                            local nMPos = Mouse.X;
                            local nXOffset = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize); -- what in tarnation are these variable names
                            local nXScale = Library:MapValue(nXOffset, 0, Slider.MaxSize, 0, 1);

                            local nValue = Slider:GetValueFromXScale(nXScale);
                            local OldValue = Slider.Value;
                            Slider.Value = nValue;

                            Slider:Display();

                            if nValue ~= OldValue then
                                Library:SafeCallback(Slider.Callback, Slider.Value);
                                Library:SafeCallback(Slider.Changed, Slider.Value);
                            end;

                            PreRender:Wait();
                        end;

                        if Library.IsMobile then
                            Library.CanDrag = true;
                        end;
                        
                        for _, Side in Sides do
                            if typeof(Side) == "Instance" then
                                if Side:IsA("ScrollingFrame") then
                                    Side.ScrollingEnabled = true;
                                end
                            end;
                        end;

                        Library:AttemptSave();
                    end;
                end);

                task.delay(0.1, Slider.UpdateColors, Slider);
                Slider:Display();
                table.insert(Blanks, Groupbox:AddBlank(Info.BlankSize or 6, Slider.Visible));
                Groupbox:Resize();

                Options[Idx] = Slider;

                return Slider;
            end;

            function BaseGroupboxFuncs:AddDropdown(Idx, Info)
                Info.ReturnInstanceInstead = if typeof(Info.ReturnInstanceInstead) == "boolean" then Info.ReturnInstanceInstead else false;

                if Info.SpecialType == 'Player' then
                    Info.ExcludeLocalPlayer = if typeof(Info.ExcludeLocalPlayer) == "boolean" then Info.ExcludeLocalPlayer else false;

                    Info.Values = GetPlayers(Info.ExcludeLocalPlayer, Info.ReturnInstanceInstead);
                    Info.AllowNull = true;
                elseif Info.SpecialType == 'Team' then
                    Info.Values = GetTeams(Info.ReturnInstanceInstead);
                    Info.AllowNull = true;
                end;

                assert(Info.Values, GetTranslation(Translations, "AddDropdown: Missing dropdown value list."));
                assert(Info.AllowNull or Info.Default, GetTranslation(Translations, "AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional."));

                Info.Searchable = if typeof(Info.Searchable) == "boolean" then Info.Searchable else false;
                Info.FormatDisplayValue = if typeof(Info.FormatDisplayValue) == "function" then Info.FormatDisplayValue else nil;

                if (not Info.Text) then
                    Info.Compact = true;
                end;

                local Dropdown = {
                    Values = Info.Values;
                    Value = Info.Multi and {};
                    DisabledValues = Info.DisabledValues or {};
                    Multi = Info.Multi;
                    Type = 'Dropdown';
                    SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
                    Visible = if typeof(Info.Visible) == "boolean" then Info.Visible else true;
                    Disabled = if typeof(Info.Disabled) == "boolean" then Info.Disabled else false;
                    Callback = Info.Callback or function(Value) end;
                    Changed = Info.Changed or function(Value) end;

                    OriginalText = Info.Text; Text = Info.Text;
                    ExcludeLocalPlayer = Info.ExcludeLocalPlayer;
                    ReturnInstanceInstead = Info.ReturnInstanceInstead;
                };

                local DropdownLabel;
                local Tooltip;
                local Groupbox = self;
                local Container = Groupbox.Container;

                local RelativeOffset = 0;

                if not Info.Compact then
                    DropdownLabel = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 0, 10);
                        TextSize = 14;
                        Text = Info.Text;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Bottom;
                        Visible = Dropdown.Visible;
                        ZIndex = 5;
                        Parent = Container;
                        RichText = true;
                    });

                    Groupbox:AddBlank(3, Dropdown.Visible);
                end

                for _, Element in Container:GetChildren() do
                    if not Element:IsA('UIListLayout') then
                        RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
                    end;
                end;

                local DropdownOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(1, -4, 0, 20);
                    Visible = Dropdown.Visible;
                    ZIndex = 5;
                    Parent = Container;
                });

                Library:AddToRegistry(DropdownOuter, {
                    BorderColor3 = 'Black';
                });

                local DropdownInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 6;
                    Parent = DropdownOuter;
                });

                Library:AddToRegistry(DropdownInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                    });
                    Rotation = 90;
                    Parent = DropdownInner;
                });

                local DropdownInnerSearch;
                if Info.Searchable then
                    DropdownInnerSearch = Library:Create('TextBox', {
                        BackgroundTransparency = 1;
                        Visible = false;

                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(0.9, -5, 1, 0);

                        Font = Library.Font;
                        PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                        PlaceholderText = GetTranslation(Translations, 'Search...');

                        Text = '';
                        TextColor3 = Library.FontColor;
                        TextSize = 14;
                        TextStrokeTransparency = 0;
                        TextXAlignment = Enum.TextXAlignment.Left;

                        ClearTextOnFocus = false;

                        ZIndex = 7;
                        Parent = DropdownOuter;
                    });

                    Library:ApplyTextStroke(DropdownInnerSearch);

                    Library:AddToRegistry(DropdownInnerSearch, {
                        TextColor3 = 'FontColor';
                    });
                end

                local DropdownArrow = Library:Create('ImageLabel', {
                    AnchorPoint = Vector2.new(0, 0.5);
                    BackgroundTransparency = 1;
                    Position = UDim2.new(1, -16, 0.5, 0);
                    Size = UDim2.new(0, 12, 0, 12);
                    Image = 'http://www.roblox.com/asset/?id=6282522798';
                    ZIndex = 8;
                    Parent = DropdownInner;
                });

                local ItemList = Library:CreateLabel({
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -5, 1, 0);
                    TextSize = 14;
                    Text = '--';
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextWrapped = false;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    RichText = true;
                    ZIndex = 7;
                    Parent = DropdownInner;
                });

                Library:OnHighlight(DropdownOuter, DropdownOuter,
                    { BorderColor3 = 'AccentColor' },
                    { BorderColor3 = 'Black' },
                    function()
                        return not Dropdown.Disabled;
                    end
                );

                if typeof(Info.Tooltip) == "string" or typeof(Info.DisabledTooltip) == "string" then
                    Tooltip = Library:AddToolTip(Info.Tooltip, Info.DisabledTooltip, DropdownOuter)
                    Tooltip.Disabled = Dropdown.Disabled;
                end

                local MAX_DROPDOWN_ITEMS = if typeof(Info.MaxVisibleDropdownItems) == "number" then math.clamp(Info.MaxVisibleDropdownItems, 4, 16) else 8;

                local ListOuter = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderColor3 = Color3.new(0, 0, 0);
                    ZIndex = 20;
                    Visible = false;
                    Parent = ScreenGui;
                });

                local function RecalculateListPosition()
                    ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1);
                end;

                local function RecalculateListSize(YSize)
                    local Y = YSize or math.clamp(GetTableSize(Dropdown.Values) * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1;
                    ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X + 0.5, Y)
                end;

                RecalculateListPosition();
                RecalculateListSize();

                DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);

                local ListInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 21;
                    Parent = ListOuter;
                });

                Library:AddToRegistry(ListInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local Scrolling = Library:Create('ScrollingFrame', {
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    CanvasSize = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 21;
                    Parent = ListInner;

                    TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
                    BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Library.AccentColor,
                });

                Library:AddToRegistry(Scrolling, {
                    ScrollBarImageColor3 = 'AccentColor'
                })

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 0);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Scrolling;
                });

                function Dropdown:UpdateColors()
                    if DropdownLabel then
                        DropdownLabel.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                    end;

                    ItemList.TextColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                    DropdownArrow.ImageColor3 = Dropdown.Disabled and Library.DisabledAccentColor or Color3.new(1, 1, 1);
                end;

                function Dropdown:Display()
                    local Values = Dropdown.Values;
                    local Str = '';

                    if Info.Multi then
                        for Idx, Value in Values do
                            local StringValue = if typeof(Value) == "Instance" then Value.Name else Value;

                            if Dropdown.Value[Value] then
                                Str = Str .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue) .. ', ';
                            end;
                        end;

                        Str = Str:sub(1, #Str - 2);
                        ItemList.Text = (Str == '' and '--' or Str);
                    else
                        if not Dropdown.Value then
                            ItemList.Text = '--';
                            return;
                        end;

                        local StringValue = if typeof(Dropdown.Value) == "Instance" then Dropdown.Value.Name else Dropdown.Value;
                        ItemList.Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                    end;
                end;

                function Dropdown:GetActiveValues()
                    if Info.Multi then
                        local T = {};

                        for Value, Bool in Dropdown.Value do
                            table.insert(T, Value);
                        end;

                        return T;
                    else
                        return Dropdown.Value and 1 or 0;
                    end;
                end;

                function Dropdown:BuildDropdownList()
                    local Values = Dropdown.Values;
                    local DisabledValues = Dropdown.DisabledValues;
                    local Buttons = {};

                    for _, Element in Scrolling:GetChildren() do
                        if not Element:IsA('UIListLayout') then
                            Element:Destroy();
                        end;
                    end;

                    local Count = 0;
                    for Idx, Value in Values do
                        local StringValue = if typeof(Value) == "Instance" then Value.Name else Value;
                        if Info.Searchable and not string.lower(StringValue):match(string.lower(DropdownInnerSearch.Text)) then
                            continue;
                        end

                        local IsDisabled = table.find(DisabledValues, StringValue);
                        local Table = {};

                        Count = Count + 1;

                        local Button = Library:Create('TextButton', {
                            AutoButtonColor = false,
                            BackgroundColor3 = Library.MainColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Middle;
                            Size = UDim2.new(1, -1, 0, 20);
                            Text = '';
                            ZIndex = 23;
                            Parent = Scrolling;
                        });

                        Library:AddToRegistry(Button, {
                            BackgroundColor3 = 'MainColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        local ButtonLabel = Library:CreateLabel({
                            Active = false;
                            Size = UDim2.new(1, -6, 1, 0);
                            Position = UDim2.new(0, 6, 0, 0);
                            TextSize = 14;
                            Text = Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(StringValue)) or StringValue;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            RichText = true;
                            ZIndex = 25;
                            Parent = Button;
                        });

                        Library:OnHighlight(Button, Button,
                            { BorderColor3 = IsDisabled and 'DisabledAccentColor' or 'AccentColor', ZIndex = 24 },
                            { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                        );

                        local Selected;

                        if Info.Multi then
                            Selected = Dropdown.Value[Value];
                        else
                            Selected = Dropdown.Value == Value;
                        end;

                        function Table:UpdateButton()
                            if Info.Multi then
                                Selected = Dropdown.Value[Value];
                            else
                                Selected = Dropdown.Value == Value;
                            end;

                            ButtonLabel.TextColor3 = Selected and Library.AccentColor or (IsDisabled and Library.DisabledAccentColor or Library.FontColor);
                            Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or (IsDisabled and 'DisabledAccentColor' or 'FontColor');
                        end;

                        if not IsDisabled then
                            Button.MouseButton1Click:Connect(function(Input)
                                local Try = not Selected;

                                if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                                else
                                    if Info.Multi then
                                        Selected = Try;

                                        if Selected then
                                            Dropdown.Value[Value] = true;
                                        else
                                            Dropdown.Value[Value] = nil;
                                        end;
                                    else
                                        Selected = Try;

                                        if Selected then
                                            Dropdown.Value = Value;
                                        else
                                            Dropdown.Value = nil;
                                        end;

                                        for _, OtherButton in Buttons do
                                            OtherButton:UpdateButton();
                                        end;
                                    end;

                                    Table:UpdateButton();
                                    Dropdown:Display();
                                    
                                    Library:UpdateDependencyBoxes();
                                    Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                                    Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                                    Library:AttemptSave();
                                end;
                            end);
                        end

                        Table:UpdateButton();
                        Dropdown:Display();

                        Buttons[Button] = Table;
                    end;

                    Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * (20 * DPIScale)) + 1);

                    -- Workaround for silly roblox bug - not sure why it happens but sometimes the dropdown list will be empty
                    -- ... and for some reason refreshing the Visible property fixes the issue??????? thanks roblox!
                    Scrolling.Visible = false;
                    Scrolling.Visible = true;

                    local Y = math.clamp(Count * (20 * DPIScale), 0, MAX_DROPDOWN_ITEMS * (20 * DPIScale)) + 1;
                    RecalculateListSize(Y);
                end;

                function Dropdown:SetValues(NewValues)
                    if NewValues then
                        Dropdown.Values = NewValues;
                    end;

                    Dropdown:BuildDropdownList();
                end;

                function Dropdown:AddValues(NewValues)
                    if typeof(NewValues) == "table" then
                        for _, val in NewValues do
                            table.insert(Dropdown.Values, val);
                        end
                    elseif typeof(NewValues) == "string" then
                        table.insert(Dropdown.Values, NewValues);
                    else
                        return;
                    end

                    Dropdown:BuildDropdownList();
                end;

                function Dropdown:SetDisabledValues(NewValues)
                    if NewValues then
                        Dropdown.DisabledValues = NewValues;
                    end;

                    Dropdown:BuildDropdownList();
                end

                function Dropdown:AddDisabledValues(DisabledValues)
                    if typeof(DisabledValues) == "table" then
                        for _, val in DisabledValues do
                            table.insert(Dropdown.DisabledValues, val)
                        end
                    elseif typeof(DisabledValues) == "string" then
                        table.insert(Dropdown.DisabledValues, DisabledValues)
                    else
                        return
                    end

                    Dropdown:BuildDropdownList()
                end

                function Dropdown:SetVisible(Visibility)
                    Dropdown.Visible = Visibility;

                    DropdownOuter.Visible = Dropdown.Visible;
                    if DropdownLabel then DropdownLabel.Visible = Dropdown.Visible end;
                    if not Dropdown.Visible then Dropdown:CloseDropdown(); end;

                    Groupbox:Resize();
                end;

                function Dropdown:SetDisabled(Disabled)
                    Dropdown.Disabled = Disabled;

                    if Tooltip then
                        Tooltip.Disabled = Disabled;
                    end

                    if Disabled then
                        Dropdown:CloseDropdown();
                    end

                    Dropdown:Display();
                    Dropdown:UpdateColors();
                end;

                function Dropdown:OpenDropdown()
                    if Dropdown.Disabled then
                        return;
                    end;

                    if Library.IsMobile then
                        Library.CanDrag = false;
                    end;

                    if Info.Searchable then
                        ItemList.Visible = false;
                        DropdownInnerSearch.Text = "";
                        DropdownInnerSearch.Visible = true;
                    end

                    ListOuter.Visible = true;
                    Library.OpenedFrames[ListOuter] = true;
                    DropdownArrow.Rotation = 180;

                    RecalculateListSize();
                end;

                function Dropdown:CloseDropdown()
                    if Library.IsMobile then            
                        Library.CanDrag = true;
                    end;

                    if Info.Searchable then
                        DropdownInnerSearch.Text = "";
                        DropdownInnerSearch.Visible = false;
                        ItemList.Visible = true;
                    end

                    ListOuter.Visible = false;
                    Library.OpenedFrames[ListOuter] = nil;
                    DropdownArrow.Rotation = 0;
                end;

                function Dropdown:OnChanged(Func)
                    Dropdown.Changed = Func;

                    if Dropdown.Disabled then
                        return;
                    end;

                    Library:SafeCallback(Func, Dropdown.Value);
                end;

                function Dropdown:SetValue(Val)
                    if Dropdown.Multi then
                        local nTable = {};

                        for Value, Bool in Val do
                            if table.find(Dropdown.Values, Value) then
                                nTable[Value] = true
                            end;
                        end;

                        Dropdown.Value = nTable;
                    else
                        if (not Val) then
                            Dropdown.Value = nil;
                        elseif table.find(Dropdown.Values, Val) then
                            Dropdown.Value = Val;
                        end;
                    end;

                    Dropdown:BuildDropdownList();

                    if not Dropdown.Disabled then
                        Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                        Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
                    end;
                end;

                function Dropdown:SetText(Text)
                    if typeof(Text) == "string" then
                        if Info.Compact then Info.Compact = false end;
                        Dropdown.Text = Text;

                        if DropdownLabel then DropdownLabel.Text = Dropdown.Text end;
                        Dropdown:Display();
                    end
                end;

                DropdownOuter.InputBegan:Connect(function(Input)
                    if Dropdown.Disabled then
                        return;
                    end;

                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                        if ListOuter.Visible then
                            Dropdown:CloseDropdown();
                        else
                            Dropdown:OpenDropdown();
                        end;
                    end;
                end);

                if Info.Searchable then
                    DropdownInnerSearch:GetPropertyChangedSignal("Text"):Connect(function()
                        Dropdown:BuildDropdownList()
                    end);
                end;

                shared.UserInputService.InputBegan:Connect(function(Input)
                    if Dropdown.Disabled then
                        return;
                    end;

                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                        if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                            or Mouse.Y < (AbsPos.Y - (20 * DPIScale) - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                            Dropdown:CloseDropdown();
                        end;
                    end;
                end);

                Dropdown:BuildDropdownList();
                Dropdown:Display();

                local Defaults = {}

                if typeof(Info.Default) == "string" then
                    local _Idx = table.find(Dropdown.Values, Info.Default)
                    if _Idx then
                        table.insert(Defaults, _Idx)
                    end
                elseif typeof(Info.Default) == 'table' then
                    for _, Value in Info.Default do
                        local _Idx = table.find(Dropdown.Values, Value)
                        if _Idx then
                            table.insert(Defaults, _Idx)
                        end
                    end
                elseif typeof(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
                    table.insert(Defaults, Info.Default)
                end

                if next(Defaults) then
                    for i = 1, #Defaults do
                        local Index = Defaults[i]
                        if Info.Multi then
                            Dropdown.Value[Dropdown.Values[Index]] = true
                        else
                            Dropdown.Value = Dropdown.Values[Index];
                        end

                        if (not Info.Multi) then break end
                    end

                    Dropdown:BuildDropdownList();
                    Dropdown:Display();
                end

                task.delay(0.1, Dropdown.UpdateColors, Dropdown)
                Groupbox:AddBlank(Info.BlankSize or 5, Dropdown.Visible);
                Groupbox:Resize();

                Options[Idx] = Dropdown;

                return Dropdown;
            end;

            function BaseGroupboxFuncs:AddDependencyBox()
                local Depbox = {
                    Dependencies = {};
                };

                local Groupbox = self;
                local Container = Groupbox.Container;

                local Holder = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(1, 0, 0, 0);
                    Visible = false;
                    Parent = Container;
                });

                local Frame = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(1, 0, 1, 0);
                    Visible = true;
                    Parent = Holder;
                });

                local Layout = Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Frame;
                });

                function Depbox:Resize()
                    Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y);
                    Groupbox:Resize();
                end;

                Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                    Depbox:Resize();
                end);

                Holder:GetPropertyChangedSignal('Visible'):Connect(function()
                    Depbox:Resize();
                end);

                function Depbox:Update()
                    for _, Dependency in Depbox.Dependencies do
                        local Elem = Dependency[1];
                        local Value = Dependency[2];

                        if if Elem.Multi then not table.find(Elem:GetActiveValues(), Value) else Elem.Value ~= Value then
                            Holder.Visible = false;
                            Depbox:Resize();
                            return;
                        end;
                    end;

                    Holder.Visible = true;
                    Depbox:Resize();
                end;

                function Depbox:SetupDependencies(Dependencies)
                    for _, Dependency in Dependencies do
                        assert(typeof(Dependency) == 'table', GetTranslation(Translations, "SetupDependencies: Dependency is not of type `table`."));
                        assert(Dependency[1], GetTranslation(Translations, "SetupDependencies: Dependency is missing element argument."));
                        assert(Dependency[2] ~= nil, GetTranslation(Translations, "SetupDependencies: Dependency is missing value argument."));
                    end;

                    Depbox.Dependencies = Dependencies;
                    Depbox:Update();
                end;

                Depbox.Container = Frame;

                setmetatable(Depbox, BaseGroupbox);

                table.insert(Library.DependencyBoxes, Depbox);

                return Depbox;
            end;

            BaseGroupbox.__index = BaseGroupboxFuncs;
            BaseGroupbox.__namecall = function(Table, Key, ...)
                return BaseGroupboxFuncs[Key](...);
            end;
        end;

        -- < Create other UI elements >
        do
            local WatermarkOuter = Library:Create('Frame', {
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.new(0, 100, 0, -25);
                Size = UDim2.new(0, 213, 0, 20);
                ZIndex = 200;
                Visible = false;
                Parent = ScreenGui;
            });

            local WatermarkInner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.AccentColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 201;
                Parent = WatermarkOuter;
            });

            Library:AddToRegistry(WatermarkInner, {
                BorderColor3 = 'AccentColor';
            });

            local InnerFrame = Library:Create('Frame', {
                BackgroundColor3 = Color3.new(1, 1, 1);
                BorderSizePixel = 0;
                Position = UDim2.new(0, 1, 0, 1);
                Size = UDim2.new(1, -2, 1, -2);
                ZIndex = 202;
                Parent = WatermarkInner;
            });

            local Gradient = Library:Create('UIGradient', {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                    ColorSequenceKeypoint.new(1, Library.MainColor),
                });
                Rotation = -90;
                Parent = InnerFrame;
            });

            Library:AddToRegistry(Gradient, {
                Color = function()
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                end
            });

            local WatermarkLabel = Library:CreateLabel({
                Position = UDim2.new(0, 5, 0, 0);
                Size = UDim2.new(1, -4, 1, 0);
                TextSize = 14;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 203;
                Parent = InnerFrame;
            });

            Library.Watermark = WatermarkOuter;
            Library.WatermarkText = WatermarkLabel;
            Library:MakeDraggable(Library.Watermark);

            local KeybindOuter = Library:Create('Frame', {
                AnchorPoint = Vector2.new(0, 0.5);
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.new(0, 10, 0.5, 0);
                Size = UDim2.new(0, 210, 0, 20);
                Visible = false;
                ZIndex = 100;
                Parent = ScreenGui;
            });

            local KeybindInner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 101;
                Parent = KeybindOuter;
            });

            Library:AddToRegistry(KeybindInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            }, true);

            local ColorFrame = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 102;
                Parent = KeybindInner;
            });

            Library:AddToRegistry(ColorFrame, {
                BackgroundColor3 = 'AccentColor';
            }, true);

            Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 20);
                Position = UDim2.fromOffset(5, 2),
                TextXAlignment = Enum.TextXAlignment.Left,

                Text = GetTranslation(Translations, 'Keybinds');
                ZIndex = 104;
                Parent = KeybindInner;
            });
            Library:MakeDraggable(KeybindOuter);

            local KeybindContainer = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 1, -20);
                Position = UDim2.new(0, 0, 0, 20);
                ZIndex = 1;
                Parent = KeybindInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = KeybindContainer;
            });

            Library:Create('UIPadding', {
                PaddingLeft = UDim.new(0, 5),
                Parent = KeybindContainer,
            })

            Library.KeybindFrame = KeybindOuter;
            Library.KeybindContainer = KeybindContainer;
            Library:MakeDraggable(KeybindOuter);
        end;

        function Library:SetWatermarkVisibility(Bool)
            Library.Watermark.Visible = Bool;
        end;

        function Library:SetWatermark(Text)
            local X, Y = Library:GetTextBounds(Text, Library.Font, 14);
            Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3);
            Library:SetWatermarkVisibility(true)

            Library.WatermarkText.Text = Text;
        end;

        function Library:SetNotifySide(Side: string)
            Library.NotifySide = Side;
        end;

        function Library:CreateWindow(...)
            local Arguments = { ... }
            local Config = {
                AnchorPoint = Vector2.zero;
                TabPadding = 1;
                MenuFadeTime = 0.2;
                NotifySide = 'TopRight';
                ShowCustomCursor = false;
                Position = UDim2.fromOffset(175, 50);
                Size = UDim2.fromOffset(550, 600);
                Center = true;
                Resizable = true;
                AlwaysOnTop = false;
            }

            if typeof(...) == 'table' then
                Config = ...;
            else
                Config.Title = Arguments[1]
                Config.AutoShow = Arguments[2] or false;
            end

            if typeof(Config.Title) ~= "string" then Config.Title = GetTranslation(Translations, 'No title') end
            if typeof(Config.TabPadding) ~= 'number' then Config.TabPadding = 1 end
            if typeof(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end
            if typeof(Config.NotifySide) ~= "string" then Library.NotifySide = 'TopRight' else Library.NotifySide = Config.NotifySide end
            if typeof(Config.ShowCustomCursor) ~= 'boolean' then Library.ShowCustomCursor = true else Library.ShowCustomCursor = Config.ShowCustomCursor end

            if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
            if typeof(Config.Size) ~= 'UDim2' then
                if Library.IsMobile then
                    local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                    local ViewportSizeYOffset = (ViewportSize and tonumber(ViewportSize.Y) or 600) - 35;

                    Config.Size = UDim2.fromOffset(550, math.clamp(ViewportSizeYOffset, 200, 600))
                else
                    Config.Size = UDim2.fromOffset(550, 600)
                end
            end

            if Config.TabPadding <= 0 then
                Config.TabPadding = 1
            end

            if Config.Center then
                -- Config.AnchorPoint = Vector2.new(0.5, 0.5)
                Config.Position = UDim2.new(0.5, -Config.Size.X.Offset/2, 0.5, -Config.Size.Y.Offset/2)
            end

            local Window = {
                Tabs = {};

                OriginalTitle = Config.Title; Title = Config.Title;
            };

            ScreenGui.OnTopOfCoreBlur = Config.AlwaysOnTop == true
            local Outer = Library:Create('Frame', {
                AnchorPoint = Config.AnchorPoint;
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderSizePixel = 0;
                Position = Config.Position;
                Size = Config.Size;
                Visible = false;
                ZIndex = 1;
                Parent = ScreenGui;
            });
            LibraryMainOuterFrame = Outer;
            Library:MakeDraggable(Outer, 25, true);

            if Config.Resizable then
                Library:MakeResizable(Outer, Library.MinSize);
            end

            local Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.AccentColor;
                BorderMode = Enum.BorderMode.Inset;
                Position = UDim2.new(0, 1, 0, 1);
                Size = UDim2.new(1, -2, 1, -2);
                ZIndex = 1;
                Parent = Outer;
            });

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'AccentColor';
            });

            local WindowLabel = Library:CreateLabel({
                Position = UDim2.new(0, 7, 0, 0);
                Size = UDim2.new(0, 0, 0, 25);
                Text = Config.Title or '';
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 1;
                Parent = Inner;
            });

            local MainSectionOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                Position = UDim2.new(0, 8, 0, 25);
                Size = UDim2.new(1, -16, 1, -33);
                ZIndex = 1;
                Parent = Inner;
            });

            Library:AddToRegistry(MainSectionOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local MainSectionInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                BorderMode = Enum.BorderMode.Inset;
                Position = UDim2.new(0, 0, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 1;
                Parent = MainSectionOuter;
            });

            Library:AddToRegistry(MainSectionInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

            local TabArea = Library:Create('ScrollingFrame', {
                ScrollingDirection = Enum.ScrollingDirection.X;
                CanvasSize = UDim2.new(0, 0, 2, 0);
                HorizontalScrollBarInset = Enum.ScrollBarInset.Always;
                AutomaticCanvasSize = Enum.AutomaticSize.XY;
                ScrollBarThickness = 0;
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 8 - Config.TabPadding, 0, 4);
                Size = UDim2.new(1, -10, 0, 26);
                ZIndex = 1;
                Parent = MainSectionInner;
            });

            local TabListLayout = Library:Create('UIListLayout', {
                Padding = UDim.new(0, Config.TabPadding);
                FillDirection = Enum.FillDirection.Horizontal;
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Parent = TabArea;
            });

            Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                Size = UDim2.new(0, 0, 0, 0);
                LayoutOrder = -1;
                BackgroundTransparency = 1;
                ZIndex = 1;
                Parent = TabArea;
            });
            Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                Size = UDim2.new(0, 0, 0, 0);
                LayoutOrder = 9999999;
                BackgroundTransparency = 1;
                ZIndex = 1;
                Parent = TabArea;
            });

            local TabContainer = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                Position = UDim2.new(0, 8, 0, 30);
                Size = UDim2.new(1, -16, 1, -38);
                ZIndex = 2;
                Parent = MainSectionInner;
            });
            
            local InnerVideoBackground = Library:Create('VideoFrame', {
                BackgroundColor3 = Library.MainColor;
                BorderMode = Enum.BorderMode.Inset;
                BorderSizePixel = 0;
                Position = UDim2.new(0, 1, 0, 1);
                Size = UDim2.new(1, -2, 1, -2);
                ZIndex = 2;
                Visible = false;
                Volume = 0;
                Looped = true;
                Parent = TabContainer;
            });
            Library.InnerVideoBackground = InnerVideoBackground;

            Library:AddToRegistry(TabContainer, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            function Window:SetWindowTitle(Title)
                if typeof(Title) == "string" then
                    Window.Title = Title;
                    WindowLabel.Text = Window.Title;
                end
            end;

            function Window:AddTab(Name)
                local Tab = {
                    Groupboxes = {};
                    Tabboxes = {};

                    OriginalName = Name; Name = Name;
                };

                local TabButtonWidth = Library:GetTextBounds(Tab.Name, Library.Font, 16);

                local TabButton = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    Size = UDim2.new(0, TabButtonWidth + 8 + 4, 0.85, 0);
                    ZIndex = 1;
                    Parent = TabArea;
                });

                Library:AddToRegistry(TabButton, {
                    BackgroundColor3 = 'BackgroundColor';
                    BorderColor3 = 'OutlineColor';
                });

                local TabButtonLabel = Library:CreateLabel({
                    Position = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(1, 0, 1, -1);
                    Text = Tab.Name;
                    ZIndex = 1;
                    Parent = TabButton;
                });

                local Blocker = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 1, 0);
                    Size = UDim2.new(1, 0, 0, 1);
                    BackgroundTransparency = 1;
                    ZIndex = 3;
                    Parent = TabButton;
                });

                Library:AddToRegistry(Blocker, {
                    BackgroundColor3 = 'MainColor';
                });

                local TabFrame = Library:Create('Frame', {
                    Name = 'TabFrame',
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    Visible = false;
                    ZIndex = 2;
                    Parent = TabContainer;
                });

                local TopBarLabelStroke
                local TopBarHighlight
                local TopBar, TopBarInner, TopBarLabel, TopBarTextLabel; do
                    TopBar = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Color3.fromRGB(248, 51, 51);
                        BorderMode = Enum.BorderMode.Inset;
                        Position = UDim2.new(0, 7, 0, 7);
                        Size = UDim2.new(1, -13, 0, 0);
                        ZIndex = 2;
                        Parent = TabFrame;
                        Visible = false;
                    });

                    TopBarInner = Library:Create('Frame', {
                        BackgroundColor3 = Color3.fromRGB(117, 22, 17);
                        BorderColor3 = Color3.new();
                        -- BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, -2, 1, -2);
                        Position = UDim2.new(0, 1, 0, 1);
                        ZIndex = 4;
                        Parent = TopBar;
                    });

                    TopBarHighlight = Library:Create('Frame', {
                        BackgroundColor3 = Color3.fromRGB(255, 75, 75);
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 2);
                        ZIndex = 5;
                        Parent = TopBarInner;
                    });

                    TopBarLabel = Library:Create('TextLabel', {
                        BackgroundTransparency = 1;
                        Font = Library.Font;
                        TextStrokeTransparency = 0;

                        Size = UDim2.new(1, 0, 0, 18);
                        Position = UDim2.new(0, 4, 0, 2);
                        TextSize = 14;
                        Text = GetTranslation(Translations, "Text");
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextColor3 = Color3.fromRGB(255, 55, 55);
                        ZIndex = 5;
                        Parent = TopBarInner;
                    });

                    TopBarLabelStroke = Library:ApplyTextStroke(TopBarLabel);
                    TopBarLabelStroke.Color = Color3.fromRGB(174, 3, 3);

                    TopBarTextLabel = Library:CreateLabel({
                        Position =  UDim2.new(0, 4, 0, 20);
                        Size = UDim2.new(1, -4, 0, 14);
                        TextSize = 14;
                        Text = GetTranslation(Translations, "Text");
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Top;
                        ZIndex = 5;
                        Parent = TopBarInner;
                    });
                    
                    Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 0, 5);
                        Visible = true;
                        ZIndex = 1;
                        Parent = TopBarInner;
                    });
                end
                
                local LeftSide = Library:Create('ScrollingFrame', {
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 8 - 1, 0, 8 - 1);
                    Size = UDim2.new(0.5, -12 + 2, 1, -14);
                    CanvasSize = UDim2.new(0, 0, 0, 0);
                    BottomImage = '';
                    TopImage = '';
                    ScrollBarThickness = 0;
                    ZIndex = 2;
                    Parent = TabFrame;
                });

                local RightSide = Library:Create('ScrollingFrame', {
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1);
                    Size = UDim2.new(0.5, -12 + 2, 1, -14);
                    CanvasSize = UDim2.new(0, 0, 0, 0);
                    BottomImage = '';
                    TopImage = '';
                    ScrollBarThickness = 0;
                    ZIndex = 2;
                    Parent = TabFrame;
                });

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 8);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    Parent = LeftSide;
                });

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 8);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    Parent = RightSide;
                });

                if Library.IsMobile then
                    local SidesValues = {
                        ["Left"] = tick(),
                        ["Right"] = tick(),
                    }

                    LeftSide:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                        Library.CanDrag = false;

                        local ChangeTick = tick();
                        SidesValues.Left = ChangeTick;
                        task.wait(0.15);

                        if SidesValues.Left == ChangeTick then
                            Library.CanDrag = true;
                        end
                    end);

                    RightSide:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                        Library.CanDrag = false;

                        local ChangeTick = tick();
                        SidesValues.Right = ChangeTick;
                        task.wait(0.15);
                        
                        if SidesValues.Right == ChangeTick then
                            Library.CanDrag = true;
                        end
                    end);
                end;

                for _, Side in { LeftSide, RightSide } do
                    Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                        Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y);
                    end);
                end;

                function Tab:Resize()
                    if TopBar.Visible == true then
                        local Size = 5;

                        for _, Element in TopBarInner:GetChildren() do
                            if (not Element:IsA('UIListLayout')) and Element.Visible then
                                if Element == TopBarTextLabel then
                                    Size = Size + Element.TextBounds.Y;    
                                    continue                     
                                end;
                                
                                Size = Size + Element.Size.Y.Offset;
                            end;
                        end;
                        
                        TopBar.Size = UDim2.new(1, -13, 0, Size);
                        Size = Size + 10;
                        
                        LeftSide.Position = UDim2.new(0, 8 - 1, 0, 8 - 1 + Size);
                        LeftSide.Size = UDim2.new(0.5, -12 + 2, 1, -14 - Size);
                
                        RightSide.Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1 + Size);
                        RightSide.Size = UDim2.new(0.5, -12 + 2, 1, -14 - Size);
                    else
                        LeftSide.Position = UDim2.new(0, 8 - 1, 0, 8 - 1);
                        LeftSide.Size = UDim2.new(0.5, -12 + 2, 1, -14);
                
                        RightSide.Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1);
                        RightSide.Size = UDim2.new(0.5, -12 + 2, 1, -14);
                    end;
                end;

                function Tab:UpdateWarningBox(Info)
                    if typeof(Info.Visible) == "boolean" then
                        TopBar.Visible = Info.Visible;
                        Tab:Resize();
                    end;

                    if typeof(Info.Title) == "string" then
                        TopBarLabel.Text = Info.Title;
                    end;

                    if typeof(Info.Text) == "string" then
                        TopBarTextLabel.Text = Info.Text;
                
                        local Y = select(2, Library:GetTextBounds(Info.Text, Library.Font, 14, Vector2.new(TopBarTextLabel.AbsoluteSize.X, math.huge)));
                        TopBarTextLabel.Size = UDim2.new(1, -4, 0, Y);

                        Tab:Resize();
                    end;

                    TopBar.BorderColor3 = Info.IsNormal == true and Color3.fromRGB(27, 42, 53) or Color3.fromRGB(248, 51, 51)
                    TopBarInner.BorderColor3 = Info.IsNormal == true and Library.OutlineColor or Color3.fromRGB(0, 0, 0)
                    TopBarInner.BackgroundColor3 = Info.IsNormal == true and Library.BackgroundColor or Color3.fromRGB(117, 22, 17)
                    TopBarHighlight.BackgroundColor3 = Info.IsNormal == true and Library.AccentColor or Color3.fromRGB(255, 75, 75)
                     
                    TopBarLabel.TextColor3 = Info.IsNormal == true and Library.FontColor or Color3.fromRGB(255, 55, 55)
                    TopBarLabelStroke.Color = Info.IsNormal == true and Library.Black or Color3.fromRGB(174, 3, 3)

                    if not Library.RegistryMap[TopBarInner] then Library:AddToRegistry(TopBarInner, {}) end
                    if not Library.RegistryMap[TopBarHighlight] then Library:AddToRegistry(TopBarHighlight, {}) end
                    if not Library.RegistryMap[TopBarLabel] then Library:AddToRegistry(TopBarLabel, {}) end
                    if not Library.RegistryMap[TopBarLabelStroke] then Library:AddToRegistry(TopBarLabelStroke, {}) end

                    Library.RegistryMap[TopBarInner].Properties.BorderColor3 = Info.IsNormal == true and "OutlineColor" or nil;
                    Library.RegistryMap[TopBarInner].Properties.BackgroundColor3 = Info.IsNormal == true and "BackgroundColor" or nil;
                    Library.RegistryMap[TopBarHighlight].Properties.BackgroundColor3 = Info.IsNormal == true and "AccentColor" or nil;

                    Library.RegistryMap[TopBarLabel].Properties.TextColor3 = Info.IsNormal == true and "FontColor" or nil;
                    Library.RegistryMap[TopBarLabelStroke].Properties.Color = Info.IsNormal == true and "Black" or nil;
                end;

                function Tab:ShowTab()
                    Library.ActiveTab = Name;
                    for _, Tab in Window.Tabs do
                        Tab:HideTab();
                    end;

                    Blocker.BackgroundTransparency = 0;
                    TabButton.BackgroundColor3 = Library.MainColor;
                    Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
                    TabFrame.Visible = true;

                    Tab:Resize();
                end;

                function Tab:HideTab()
                    Blocker.BackgroundTransparency = 1;
                    TabButton.BackgroundColor3 = Library.BackgroundColor;
                    Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
                    TabFrame.Visible = false;
                end;

                function Tab:SetLayoutOrder(Position)
                    TabButton.LayoutOrder = Position;
                    TabListLayout:ApplyLayout();
                end;

                function Tab:GetSides()
                    return { ["Left"] = LeftSide, ["Right"] = RightSide };
                end;

                function Tab:SetName(Name)
                    if typeof(Name) == "string" then
                        Tab.Name = Name;

                        local TabButtonWidth = Library:GetTextBounds(Tab.Name, Library.Font, 16);

                        TabButton.Size = UDim2.new(0, TabButtonWidth + 8 + 4, 0.85, 0);
                        TabButtonLabel.Text = Tab.Name;
                    end
                end;

                function Tab:AddGroupbox(Info)
                    local Groupbox = {};

                    local BoxOuter = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 0, 507 + 2);
                        ZIndex = 2;
                        Parent = Info.Side == 1 and LeftSide or RightSide;
                    });

                    Library:AddToRegistry(BoxOuter, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local BoxInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Color3.new(0, 0, 0);
                        -- BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, -2, 1, -2);
                        Position = UDim2.new(0, 1, 0, 1);
                        ZIndex = 4;
                        Parent = BoxOuter;
                    });

                    Library:AddToRegistry(BoxInner, {
                        BackgroundColor3 = 'BackgroundColor';
                    });

                    local Highlight = Library:Create('Frame', {
                        BackgroundColor3 = Library.AccentColor;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 2);
                        ZIndex = 5;
                        Parent = BoxInner;
                    });

                    Library:AddToRegistry(Highlight, {
                        BackgroundColor3 = 'AccentColor';
                    });

                    Library:CreateLabel({
                        Size = UDim2.new(1, 0, 0, 18);
                        Position = UDim2.new(0, 4, 0, 2);
                        TextSize = 14;
                        Text = Info.Name;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 5;
                        Parent = BoxInner;
                    });

                    local Container = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Position = UDim2.new(0, 4, 0, 20);
                        Size = UDim2.new(1, -4, 1, -20);
                        ZIndex = 1;
                        Parent = BoxInner;
                    });

                    Library:Create('UIListLayout', {
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = Container;
                    });

                    function Groupbox:Resize()
                        local Size = 0;

                        for _, Element in Groupbox.Container:GetChildren() do
                            if (not Element:IsA('UIListLayout')) and Element.Visible then
                                Size = Size + Element.Size.Y.Offset;
                            end;
                        end;

                        BoxOuter.Size = UDim2.new(1, 0, 0, (20 * DPIScale + Size) + 2 + 2);
                    end;

                    Groupbox.Container = Container;
                    setmetatable(Groupbox, BaseGroupbox);

                    Groupbox:AddBlank(3);
                    Groupbox:Resize();

                    Tab.Groupboxes[Info.Name] = Groupbox;

                    return Groupbox;
                end;

                function Tab:AddLeftGroupbox(Name)
                    return Tab:AddGroupbox({ Side = 1; Name = Name; });
                end;

                function Tab:AddRightGroupbox(Name)
                    return Tab:AddGroupbox({ Side = 2; Name = Name; });
                end;

                function Tab:AddTabbox(Info)
                    local Tabbox = {
                        Tabs = {};
                    };

                    local BoxOuter = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 0, 0);
                        ZIndex = 2;
                        Parent = Info.Side == 1 and LeftSide or RightSide;
                    });

                    Library:AddToRegistry(BoxOuter, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local BoxInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Color3.new(0, 0, 0);
                        -- BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, -2, 1, -2);
                        Position = UDim2.new(0, 1, 0, 1);
                        ZIndex = 4;
                        Parent = BoxOuter;
                    });

                    Library:AddToRegistry(BoxInner, {
                        BackgroundColor3 = 'BackgroundColor';
                    });

                    local Highlight = Library:Create('Frame', {
                        BackgroundColor3 = Library.AccentColor;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 2);
                        ZIndex = 10;
                        Parent = BoxInner;
                    });

                    Library:AddToRegistry(Highlight, {
                        BackgroundColor3 = 'AccentColor';
                    });

                    local TabboxButtons = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Position = UDim2.new(0, 0, 0, 1);
                        Size = UDim2.new(1, 0, 0, 18);
                        ZIndex = 5;
                        Parent = BoxInner;
                    });

                    Library:Create('UIListLayout', {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Left;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = TabboxButtons;
                    });

                    function Tabbox:AddTab(Name)
                        local Tab = {};

                        local Button = Library:Create('Frame', {
                            BackgroundColor3 = Library.MainColor;
                            BorderColor3 = Color3.new(0, 0, 0);
                            Size = UDim2.new(0.5, 0, 1, 0);
                            ZIndex = 6;
                            Parent = TabboxButtons;
                        });

                        Library:AddToRegistry(Button, {
                            BackgroundColor3 = 'MainColor';
                        });

                        Library:CreateLabel({
                            Size = UDim2.new(1, 0, 1, 0);
                            TextSize = 14;
                            Text = Name;
                            TextXAlignment = Enum.TextXAlignment.Center;
                            ZIndex = 7;
                            Parent = Button;
                            RichText = true;
                        });

                        local Block = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderSizePixel = 0;
                            Position = UDim2.new(0, 0, 1, 0);
                            Size = UDim2.new(1, 0, 0, 1);
                            Visible = false;
                            ZIndex = 9;
                            Parent = Button;
                        });

                        Library:AddToRegistry(Block, {
                            BackgroundColor3 = 'BackgroundColor';
                        });

                        local Container = Library:Create('Frame', {
                            BackgroundTransparency = 1;
                            Position = UDim2.new(0, 4, 0, 20);
                            Size = UDim2.new(1, -4, 1, -20);
                            ZIndex = 1;
                            Visible = false;
                            Parent = BoxInner;
                        });
                        Tab.Container = Container;

                        Library:Create('UIListLayout', {
                            FillDirection = Enum.FillDirection.Vertical;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            Parent = Container;
                        });

                        function Tab:Show()
                            for _, Tab in Tabbox.Tabs do
                                Tab:Hide();
                            end;

                            Container.Visible = true;
                            Block.Visible = true;

                            Button.BackgroundColor3 = Library.BackgroundColor;
                            Library.RegistryMap[Button].Properties.BackgroundColor3 = 'BackgroundColor';

                            Tab:Resize();
                        end;

                        function Tab:Hide()
                            Container.Visible = false;
                            Block.Visible = false;

                            Button.BackgroundColor3 = Library.MainColor;
                            Library.RegistryMap[Button].Properties.BackgroundColor3 = 'MainColor';
                        end;

                        function Tab:Resize()
                            local TabCount = 0;

                            for _, Tab in Tabbox.Tabs do
                                TabCount = TabCount + 1;
                            end;

                            for _, Button in TabboxButtons:GetChildren() do
                                if not Button:IsA('UIListLayout') then
                                    Button.Size = UDim2.new(1 / TabCount, 0, 1, 0);
                                end;
                            end;

                            if (not Container.Visible) then
                                return;
                            end;

                            local Size = 0;

                            for _, Element in Tab.Container:GetChildren() do
                                if (not Element:IsA('UIListLayout')) and Element.Visible then
                                    Size = Size + Element.Size.Y.Offset;
                                end;
                            end;

                            BoxOuter.Size = UDim2.new(1, 0, 0, (20 * DPIScale + Size) + 2 + 2);
                        end;

                        Button.InputBegan:Connect(function(Input)
                            if (Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()) or Input.UserInputType == Enum.UserInputType.Touch then
                                Tab:Show();
                                Tab:Resize();
                            end;
                        end)

                        Tabbox.Tabs[Name] = Tab;

                        setmetatable(Tab, BaseGroupbox);

                        Tab:AddBlank(3);
                        Tab:Resize();

                        -- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
                        if #TabboxButtons:GetChildren() == 2 then
                            Tab:Show();
                        end;

                        return Tab;
                    end;

                    Tab.Tabboxes[Info.Name or ''] = Tabbox;

                    return Tabbox;
                end;

                function Tab:AddLeftTabbox(Name)
                    return Tab:AddTabbox({ Name = Name, Side = 1; });
                end;

                function Tab:AddRightTabbox(Name)
                    return Tab:AddTabbox({ Name = Name, Side = 2; });
                end;

                TabButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Tab:ShowTab();
                    end;
                end);

                TopBar:GetPropertyChangedSignal("Visible"):Connect(function()
                    Tab:Resize();
                end);

                -- This was the first tab added, so we show it by default.
                Library.TotalTabs = Library.TotalTabs + 1;
                if Library.TotalTabs == 1 then
                    Tab:ShowTab();
                end;

                Window.Tabs[Name] = Tab;
                return Tab;
            end;

            local ModalElement = Library:Create('TextButton', {
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 0, 0, 0);
                Visible = true;
                Text = '';
                Modal = false;
                Parent = ScreenGui;
            });

            local TransparencyCache = {};
            local Toggled = false;
            local Fading = false;
            
            function Library:Toggle(Toggling)
                if typeof(Toggling) == "boolean" and Toggling == Toggled then return end;
                if Fading then return end;

                local FadeTime = Config.MenuFadeTime;
                Fading = true;
                Toggled = (not Toggled);
                Library.Toggled = Toggled;
                ModalElement.Modal = Toggled;

                if Toggled then
                    -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
                    Outer.Visible = true;

                    if DrawingLib.drawing_replaced ~= true and IsBadDrawingLib ~= true then
                        IsBadDrawingLib = not (pcall(function()
                            local Cursor = DrawingLib.new("Triangle")
                            Cursor.Thickness = 1
                            Cursor.Filled = true
                            Cursor.Visible = Library.ShowCustomCursor

                            local CursorOutline = DrawingLib.new("Triangle")
                            CursorOutline.Thickness = 1
                            CursorOutline.Filled = false
                            CursorOutline.Color = Color3.new(0, 0, 0)
                            CursorOutline.Visible = Library.ShowCustomCursor

                            local OldMouseIconState = shared.UserInputService.MouseIconEnabled
                            shared.RunService:UnbindFromRenderStep("LinoriaCursor")
                            shared.RunService:BindToRenderStep("LinoriaCursor", Enum.RenderPriority.Camera.Value - 1, function()
                                shared.UserInputService.MouseIconEnabled = not Library.ShowCustomCursor
                                local mPos = shared.UserInputService:GetMouseLocation()
                                local X, Y = mPos.X, mPos.Y
                                Cursor.Color = Library.AccentColor
                                Cursor.PointA = Vector2.new(X, Y)
                                Cursor.PointB = Vector2.new(X + 16, Y + 6)
                                Cursor.PointC = Vector2.new(X + 6, Y + 16)
                                Cursor.Visible = Library.ShowCustomCursor
                                CursorOutline.PointA = Cursor.PointA
                                CursorOutline.PointB = Cursor.PointB
                                CursorOutline.PointC = Cursor.PointC
                                CursorOutline.Visible = Library.ShowCustomCursor

                                if not Toggled or (not ScreenGui or not ScreenGui.Parent) then
                                    shared.UserInputService.MouseIconEnabled = OldMouseIconState
                                    if Cursor then Cursor:Destroy() end
                                    if CursorOutline then CursorOutline:Destroy() end
                                    shared.RunService:UnbindFromRenderStep("LinoriaCursor")
                                end
                            end)
                        end));
                    end
                end;

                for _, Option in Options do
                    task.spawn(function()
                        if Option.Type == 'Dropdown' then
                            Option:CloseDropdown();
                        elseif Option.Type == 'KeyPicker' then
                            Option:SetModePickerVisibility(false);
                        elseif Option.Type == 'ColorPicker' then
                            Option.ContextMenu:Hide();
                            Option:Hide();
                        end
                    end)
                end

                for _, Desc in Outer:GetDescendants() do
                    local Properties = {};

                    if Desc:IsA('ImageLabel') then
                        table.insert(Properties, 'ImageTransparency');
                        table.insert(Properties, 'BackgroundTransparency');
                    elseif Desc:IsA('TextLabel') or Desc:IsA('TextBox') then
                        table.insert(Properties, 'TextTransparency');
                    elseif Desc:IsA('Frame') or Desc:IsA('ScrollingFrame') then
                        table.insert(Properties, 'BackgroundTransparency');
                    elseif Desc:IsA('UIStroke') then
                        table.insert(Properties, 'Transparency');
                    end;

                    local Cache = TransparencyCache[Desc];

                    if (not Cache) then
                        Cache = {};
                        TransparencyCache[Desc] = Cache;
                    end;

                    for _, Prop in Properties do
                        if not Cache[Prop] then
                            Cache[Prop] = Desc[Prop];
                        end;

                        if Cache[Prop] == 1 then
                            continue;
                        end;

                        shared.TweenService:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play();
                    end;
                end;

                task.wait(FadeTime);
                Outer.Visible = Toggled;
                Fading = false;
            end

            Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input, Processed)
                if typeof(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
                    if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                        task.spawn(Library.Toggle)
                    end
                elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
                    task.spawn(Library.Toggle)
                end
            end));

            if Library.IsMobile then
                local ToggleUIOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0.008, 0, 0.018, 0);
                    Size = UDim2.new(0, 77, 0, 30);
                    ZIndex = 200;
                    Visible = true;
                    Parent = ScreenGui;
                });

                local ToggleUIInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.AccentColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 201;
                    Parent = ToggleUIOuter;
                });

                Library:AddToRegistry(ToggleUIInner, {
                    BorderColor3 = 'AccentColor';
                });

                local ToggleUIInnerFrame = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 1, 0, 1);
                    Size = UDim2.new(1, -2, 1, -2);
                    ZIndex = 202;
                    Parent = ToggleUIInner;
                });

                local ToggleUIGradient = Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                    Rotation = -90;
                    Parent = ToggleUIInnerFrame;
                });

                Library:AddToRegistry(ToggleUIGradient, {
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                            ColorSequenceKeypoint.new(1, Library.MainColor),
                        });
                    end
                });

                local ToggleUIButton = Library:Create('TextButton', {
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -4, 1, 0);
                    BackgroundTransparency = 1;
                    Font = Library.Font;
                    Text = GetTranslation(Translations, "Toggle UI");
                    TextColor3 = Library.FontColor;
                    TextSize = 14;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextStrokeTransparency = 0;
                    ZIndex = 203;
                    Parent = ToggleUIInnerFrame;
                });

                Library:MakeDraggableUsingParent(ToggleUIButton, ToggleUIOuter);

                ToggleUIButton.MouseButton1Down:Connect(function()
                    Library:Toggle()
                end)

                -- Lock
                local LockUIOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0.008, 0, 0.075, 0);
                    Size = UDim2.new(0, 77, 0, 30);
                    ZIndex = 200;
                    Visible = true;
                    Parent = ScreenGui;
                });

                local LockUIInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.AccentColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 201;
                    Parent = LockUIOuter;
                });

                Library:AddToRegistry(LockUIInner, {
                    BorderColor3 = 'AccentColor';
                });

                local LockUIInnerFrame = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 1, 0, 1);
                    Size = UDim2.new(1, -2, 1, -2);
                    ZIndex = 202;
                    Parent = LockUIInner;
                });

                local LockUIGradient = Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                    Rotation = -90;
                    Parent = LockUIInnerFrame;
                });

                Library:AddToRegistry(LockUIGradient, {
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                            ColorSequenceKeypoint.new(1, Library.MainColor),
                        });
                    end
                });

                local LockUIButton = Library:Create('TextButton', {
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -4, 1, 0);
                    BackgroundTransparency = 1;
                    Font = Library.Font;
                    Text = GetTranslation(Translations, "Lock UI");
                    TextColor3 = Library.FontColor;
                    TextSize = 14;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextStrokeTransparency = 0;
                    ZIndex = 203;
                    Parent = LockUIInnerFrame;
                });

                Library:MakeDraggableUsingParent(LockUIButton, LockUIOuter);
                
                LockUIButton.MouseButton1Down:Connect(function()
                    Library.CantDragForced = not Library.CantDragForced;
                    LockUIButton.Text = Library.CantDragForced and GetTranslation(Translations, "Unlock UI") or GetTranslation(Translations, "Lock UI");
                end)
            end;

            if Config.AutoShow then task.spawn(Library.Toggle) end

            Window.Holder = Outer;

            Library.Window = Window;
            return Window;
        end;

        local function OnPlayerChange()
            local PlayerList, ExcludedPlayerList = GetPlayers(false, true), GetPlayers(true, true);
            local StringPlayerList, StringExcludedPlayerList = GetPlayers(false, false), GetPlayers(true, false);

            for _, Value in Options do
                if Value.SetValues and Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
                    Value:SetValues(
                        if Value.ReturnInstanceInstead then
                            (if Value.ExcludeLocalPlayer then ExcludedPlayerList else PlayerList)
                        else
                            (if Value.ExcludeLocalPlayer then StringExcludedPlayerList else StringPlayerList)
                    );
                end;
            end;
        end;

        local function OnTeamChange()
            local TeamList = GetTeams(false);
            local StringTeamList = GetTeams(true);

            for _, Value in Options do
                if Value.SetValues and Value.Type == 'Dropdown' and Value.SpecialType == 'Team' then
                    Value:SetValues(if Value.ReturnInstanceInstead then TeamList else StringTeamList);
                end;
            end;
        end;

        Library:GiveSignal(shared.Players.PlayerAdded:Connect(OnPlayerChange));
        Library:GiveSignal(shared.Players.PlayerRemoving:Connect(OnPlayerChange));

        Library:GiveSignal(shared.Teams.ChildAdded:Connect(OnTeamChange));
        Library:GiveSignal(shared.Teams.ChildRemoved:Connect(OnTeamChange));

        return Library
    end,

    [49] = function(shared, wax, script, require)
        --// Source by mstudio45 //

        local httpService = shared.HttpService
        local isfolder, isfile, listfiles = isfolder, isfile, listfiles;

        local copyfunction = copyfunction or clonefunction

        if typeof(copyfunction) == "function" then
            -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

            local isfolder_copy = copyfunction(isfolder);
            local isfile_copy = copyfunction(isfile);
            local listfiles_copy = copyfunction(listfiles);

            local isfolder_success, isfolder_error = pcall(function()
                return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
            end);

            if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
                isfolder = function(folder)
                    local success, data = pcall(isfolder_copy, folder)
                    return (if success then data else false)
                end;

                isfile = function(file)
                    local success, data = pcall(isfile_copy, file)
                    return (if success then data else false)
                end;

                listfiles = function(folder)
                    local success, data = pcall(listfiles_copy, folder)
                    return (if success then data else {})
                end;
            end
        end

        local SaveManager = {} do
            SaveManager.Folder = 'LinoriaLibSettings'
            SaveManager.SubFolder = ''
            SaveManager.Ignore = {}
            SaveManager.Library = nil
            SaveManager.Parser = {
                Toggle = {
                    Save = function(idx, object)
                        return { type = 'Toggle', idx = idx, value = object.Value }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Toggles[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                Slider = {
                    Save = function(idx, object)
                        return { type = 'Slider', idx = idx, value = tostring(object.Value) }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                Dropdown = {
                    Save = function(idx, object)
                        return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                ColorPicker = {
                    Save = function(idx, object)
                        return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
                    end,
                    Load = function(idx, data)
                        if SaveManager.Library.Options[idx] then
                            SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                        end
                    end,
                },
                KeyPicker = {
                    Save = function(idx, object)
                        return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
                    end,
                    Load = function(idx, data)
                        if SaveManager.Library.Options[idx] then
                            SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode })
                        end
                    end,
                },
                Input = {
                    Save = function(idx, object)
                        return { type = 'Input', idx = idx, text = object.Value }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.text and type(data.text) == 'string' then
                            SaveManager.Library.Options[idx]:SetValue(data.text)
                        end
                    end,
                },
            }

            function SaveManager:SetLibrary(library)
                self.Library = library
            end

            function SaveManager:IgnoreThemeSettings()
                self:SetIgnoreIndexes({
                    "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
                    "ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
                    "VideoLink",
                })
            end

            --// Folders \\--
            function SaveManager:CheckSubFolder(createFolder)
                if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

                if createFolder == true then
                    if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                        makefolder(self.Folder .. "/settings/" .. self.SubFolder)
                    end
                end

                return true
            end

            function SaveManager:GetPaths()
                local paths = {}

                local parts = self.Folder:split('/')
                for idx = 1, #parts do
                    local path = table.concat(parts, '/', 1, idx)
                    if not table.find(paths, path) then paths[#paths + 1] = path end
                end

                paths[#paths + 1] = self.Folder .. '/themes'
                paths[#paths + 1] = self.Folder .. '/settings'

                if self:CheckSubFolder(false) then
                    local subFolder = self.Folder .. "/settings/" .. self.SubFolder
                    parts = subFolder:split('/')

                    for idx = 1, #parts do
                        local path = table.concat(parts, '/', 1, idx)
                        if not table.find(paths, path) then paths[#paths + 1] = path end
                    end
                end

                return paths
            end

            function SaveManager:BuildFolderTree()
                local paths = self:GetPaths()

                for i = 1, #paths do
                    local str = paths[i]
                    if isfolder(str) then continue end

                    makefolder(str)
                end
            end

            function SaveManager:CheckFolderTree()
                if isfolder(self.Folder) then return end
                SaveManager:BuildFolderTree()

                task.wait(0.1)
            end

            function SaveManager:SetIgnoreIndexes(list)
                for _, key in list do
                    self.Ignore[key] = true
                end
            end

            function SaveManager:SetFolder(folder)
                self.Folder = folder;
                self:BuildFolderTree()
            end

            function SaveManager:SetSubFolder(folder)
                self.SubFolder = folder;
                self:BuildFolderTree()
            end

            --// Save, Load, Delete, Refresh \\--
            function SaveManager:Save(name)
                if (not name) then
                    return false, 'no config file is selected'
                end
                SaveManager:CheckFolderTree()

                local fullPath = self.Folder .. '/settings/' .. name .. '.json'
                if SaveManager:CheckSubFolder(true) then
                    fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
                end

                local data = {
                    objects = {}
                }

                for idx, toggle in self.Library.Toggles do
                    if not toggle.Type then continue end
                    if not self.Parser[toggle.Type] then continue end
                    if self.Ignore[idx] then continue end

                    table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
                end

                for idx, option in self.Library.Options do
                    if not option.Type then continue end
                    if not self.Parser[option.Type] then continue end
                    if self.Ignore[idx] then continue end

                    table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
                end

                local success, encoded = pcall(httpService.JSONEncode, httpService, data)
                if not success then
                    return false, 'failed to encode data'
                end

                writefile(fullPath, encoded)
                return true
            end

            function SaveManager:Load(name)
                if (not name) then
                    return false, 'no config file is selected'
                end
                SaveManager:CheckFolderTree()

                local file = self.Folder .. '/settings/' .. name .. '.json'
                if SaveManager:CheckSubFolder(true) then
                    file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
                end

                if not isfile(file) then return false, 'invalid file' end

                local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
                if not success then return false, 'decode error' end

                for _, option in decoded.objects do
                    if not option.type then continue end
                    if not self.Parser[option.type] then continue end

                    task.spawn(self.Parser[option.type].Load, option.idx, option) -- task.spawn() so the config loading wont get stuck.
                end

                return true
            end

            function SaveManager:Delete(name)
                if (not name) then
                    return false, 'no config file is selected'
                end

                local file = self.Folder .. '/settings/' .. name .. '.json'
                if SaveManager:CheckSubFolder(true) then
                    file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. '.json'
                end

                if not isfile(file) then return false, 'invalid file' end

                local success = pcall(delfile, file)
                if not success then return false, 'delete file error' end

                return true
            end

            function SaveManager:RefreshConfigList()
                local success, data = pcall(function()
                    SaveManager:CheckFolderTree()

                    local list = {}
                    local out = {}

                    if SaveManager:CheckSubFolder(true) then
                        list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
                    else
                        list = listfiles(self.Folder .. "/settings")
                    end
                    if typeof(list) ~= "table" then list = {} end

                    for i = 1, #list do
                        local file = list[i]
                        if file:sub(-5) == '.json' then
                            -- i hate this but it has to be done ...

                            local pos = file:find('.json', 1, true)
                            local start = pos

                            local char = file:sub(pos, pos)
                            while char ~= '/' and char ~= '\\' and char ~= '' do
                                pos = pos - 1
                                char = file:sub(pos, pos)
                            end

                            if char == '/' or char == '\\' then
                                table.insert(out, file:sub(pos + 1, start - 1))
                            end
                        end
                    end

                    return out
                end)

                if (not success) then
                    if self.Library then
                        self.Library:Notify('Failed to load config list: ' .. tostring(data))
                    else
                        warn('Failed to load config list: ' .. tostring(data))
                    end

                    return {}
                end

                return data
            end

            --// Auto Load \\--
            function SaveManager:GetAutoloadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                if isfile(autoLoadPath) then
                    local successRead, name = pcall(readfile, autoLoadPath)
                    if not successRead then
                        return "none"
                    end

                    name = tostring(name)
                    return if name == "" then "none" else name
                end

                return "none"
            end

            function SaveManager:LoadAutoloadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                if not isfile(autoLoadPath) then return end
                local successRead, name = pcall(readfile, autoLoadPath)
                if not successRead then
                    return self.Library:Notify('Failed to load autoload config: write file error')
                end

                local success, err = self:Load(name)
                if not success then
                    return self.Library:Notify('Failed to load autoload config: ' .. err)
                end

                return self.Library:Notify(string.format('Auto loaded config %q', name))
            end

            function SaveManager:SaveAutoloadConfig(name)
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                local success = pcall(writefile, autoLoadPath, name)
                if not success then return false, 'write file error' end

                return true, ""
            end

            function SaveManager:DeleteAutoLoadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                local success = pcall(delfile, autoLoadPath)
                if not success then return false, 'delete file error' end

                return true, ""
            end

            --// GUI \\--
            function SaveManager:BuildConfigSection(tab)
                assert(self.Library, 'Must set SaveManager.Library')

                local section = tab:AddRightGroupbox('Configuration')

                section:AddInput('SaveManager_ConfigName',    { Text = 'Config name' })
                section:AddButton('Create config', function()
                    local name = self.Library.Options.SaveManager_ConfigName.Value

                    if name:gsub(' ', '') == '' then
                        return self.Library:Notify('Invalid config name (empty)', 2)
                    end

                    local success, err = self:Save(name)
                    if not success then
                        return self.Library:Notify('Failed to create config: ' .. err)
                    end

                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                    return self.Library:Notify(string.format('Created config %q', name))
                end)

                section:AddDivider()

                section:AddDropdown('SaveManager_ConfigList', { Text = 'Config list', Values = self:RefreshConfigList(), AllowNull = true })
                section:AddButton('Load config', function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Load(name)
                    if not success then
                        return self.Library:Notify('Failed to load config: ' .. err)
                    end

                    return self.Library:Notify(string.format('Loaded config %q', name))
                end)
                section:AddButton('Overwrite config', function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Save(name)
                    if not success then
                        return self.Library:Notify('Failed to overwrite config: ' .. err)
                    end

                    return self.Library:Notify(string.format('Overwrote config %q', name))
                end)

                section:AddButton('Delete config', function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        return self.Library:Notify('Failed to delete config: ' .. err)
                    end

                    self.Library:Notify(string.format('Deleted config %q', name))
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    return self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end)

                section:AddButton('Refresh list', function()
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end)

                local autoloadBtn = section:AddButton('Set as autoload')

                local resetAutoloadBtn = section:AddButton('Reset autoload')

                self.AutoloadLabel = section:AddLabel("Current autoload config: " .. self:GetAutoloadConfig(), true)

                autoloadBtn.Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:SaveAutoloadConfig(name)
                    if not success then
                        return self.Library:Notify('Failed to set autoload config: ' .. err)
                    end

                    self.AutoloadLabel:SetText('Current autoload config: ' .. name)
                    return self.Library:Notify(string.format('Set %q to auto load', name))
                end

                resetAutoloadBtn.Func = function()
                    local success, err = self:DeleteAutoLoadConfig()
                    if not success then
                        return self.Library:Notify('Failed to set autoload config: ' .. err)
                    end

                    self.AutoloadLabel:SetText('Current autoload config: none')
                    return self.Library:Notify('Set autoload to none')
                end

                -- self:LoadAutoloadConfig()
                self:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })
            end

            SaveManager:BuildFolderTree()
        end

        return SaveManager
    end,

    [50] = function(shared, wax, script, require)
        --// Source by mstudio45 //

        local httpService = shared.HttpService
        local httprequest = (syn and syn.request) or request or http_request or (http and http.request)
        local getassetfunc = getcustomasset or getsynasset
        local isfolder, isfile, listfiles = isfolder, isfile, listfiles;

        local copyfunction = copyfunction or clonefunction

        if typeof(copyfunction) == "function" then
            -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

            local isfolder_copy = copyfunction(isfolder);
            local isfile_copy = copyfunction(isfile);
            local listfiles_copy = copyfunction(listfiles);

            local isfolder_success, isfolder_error = pcall(function()
                return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
            end);

            if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
                isfolder = function(folder)
                    local success, data = pcall(isfolder_copy, folder)
                    return (if success then data else false)
                end;

                isfile = function(file)
                    local success, data = pcall(isfile_copy, file)
                    return (if success then data else false)
                end;

                listfiles = function(folder)
                    local success, data = pcall(listfiles_copy, folder)
                    return (if success then data else {})
                end;
            end
        end

        local ThemeManager = {} do
            ThemeManager.Folder = 'LinoriaLibSettings'
            -- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

            ThemeManager.Library = nil
            ThemeManager.BuiltInThemes = {
                ['Default']      = { 1,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}]]) },
                ["BBot"]         = { 2,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}]]) },
                ["Fatality"]     = { 3,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}]]) },
                ["Jester"]       = { 4,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
                ["Mint"]         = { 5,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
                ["Tokyo Night"]  = { 6,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}]]) },
                ["Ubuntu"]       = { 7,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}]]) },
                ["Quartz"]       = { 8,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}]]) },
                ["Nord"]         = { 9,  httpService:JSONDecode([[{"FontColor":"eceff4","MainColor":"3b4252","AccentColor":"88c0d0","BackgroundColor":"2e3440","OutlineColor":"4c566a"}]]) },
                ["Dracula"]      = { 10, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"44475a","AccentColor":"ff79c6","BackgroundColor":"282a36","OutlineColor":"6272a4"}]]) },
                ["Monokai"]      = { 11, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"272822","AccentColor":"f92672","BackgroundColor":"1e1f1c","OutlineColor":"49483e"}]]) },
                ["Gruvbox"]      = { 12, httpService:JSONDecode([[{"FontColor":"ebdbb2","MainColor":"3c3836","AccentColor":"fb4934","BackgroundColor":"282828","OutlineColor":"504945"}]]) },
                ["Solarized"]    = { 13, httpService:JSONDecode([[{"FontColor":"839496","MainColor":"073642","AccentColor":"cb4b16","BackgroundColor":"002b36","OutlineColor":"586e75"}]]) },
                ["Catppuccin"]   = { 14, httpService:JSONDecode([[{"FontColor":"d9e0ee","MainColor":"302d41","AccentColor":"f5c2e7","BackgroundColor":"1e1e2e","OutlineColor":"575268"}]]) },
                ["One Dark"]     = { 15, httpService:JSONDecode([[{"FontColor":"abb2bf","MainColor":"282c34","AccentColor":"c678dd","BackgroundColor":"21252b","OutlineColor":"5c6370"}]]) },
                ["Cyberpunk"]    = { 16, httpService:JSONDecode([[{"FontColor":"f9f9f9","MainColor":"262335","AccentColor":"00ff9f","BackgroundColor":"1a1a2e","OutlineColor":"413c5e"}]]) },
                ["Oceanic Next"] = { 17, httpService:JSONDecode([[{"FontColor":"d8dee9","MainColor":"1b2b34","AccentColor":"6699cc","BackgroundColor":"16232a","OutlineColor":"343d46"}]]) },
                ["Material"]     = { 18, httpService:JSONDecode([[{"FontColor":"eeffff","MainColor":"212121","AccentColor":"82aaff","BackgroundColor":"151515","OutlineColor":"424242"}]]) },
                ["GitHub Dark"]  = { 18, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"010409","AccentColor":"1f6feb","BackgroundColor":"0d1117","OutlineColor":"1f242b"}]]) },
            }

            local function ApplyBackgroundVideo(videoLink)
                if
                    typeof(videoLink) ~= "string" or
                    not (getassetfunc and writefile and readfile and isfile) or
                    not (ThemeManager.Library and ThemeManager.Library.InnerVideoBackground)
                then return; end;

                --// Variables \\--
                local videoInstance = ThemeManager.Library.InnerVideoBackground;
                local extension = videoLink:match(".*/(.-)?") or videoLink:match(".*/(.-)$"); extension = tostring(extension);
                local filename = string.sub(extension, 0, -6);
                local _, domain = videoLink:match("^(https?://)([^/]+)"); domain = tostring(domain); -- _ is protocol

                --// Check URL \\--
                if videoLink == "" then
                    videoInstance:Pause();
                    videoInstance.Video = "";
                    videoInstance.Visible = false;
                    return
                end
                if #extension > 5 and string.sub(extension, -5) ~= ".webm" then return; end;

                --// Fetch Video Data \\--
                local videoFile = ThemeManager.Folder .. "/themes/" .. string.sub(domain .. filename, 1, 249) .. ".webm";
                if not isfile(videoFile) then
                    local success, requestRes = pcall(httprequest, { Url = videoLink, Method = 'GET' })
                    if not (success and typeof(requestRes) == "table" and typeof(requestRes.Body) == "string") then return; end;

                    writefile(videoFile, requestRes.Body)
                end

                --// Play Video \\--
                videoInstance.Video = getassetfunc(videoFile);
                videoInstance.Visible = true;
                videoInstance:Play();
            end

            function ThemeManager:SetLibrary(library)
                self.Library = library
            end

            --// Folders \\--
            function ThemeManager:GetPaths()
                local paths = {}

                local parts = self.Folder:split('/')
                for idx = 1, #parts do
                    paths[#paths + 1] = table.concat(parts, '/', 1, idx)
                end

                paths[#paths + 1] = self.Folder .. '/themes'
                
                return paths
            end

            function ThemeManager:BuildFolderTree()
                local paths = self:GetPaths()

                for i = 1, #paths do
                    local str = paths[i]
                    if isfolder(str) then continue end
                    makefolder(str)
                end
            end

            function ThemeManager:CheckFolderTree()
                if isfolder(self.Folder) then return end
                self:BuildFolderTree()

                task.wait(0.1)
            end

            function ThemeManager:SetFolder(folder)
                self.Folder = folder;
                self:BuildFolderTree()
            end
            
            --// Apply, Update theme \\--
            function ThemeManager:ApplyTheme(theme)
                local customThemeData = self:GetCustomTheme(theme)
                local data = customThemeData or self.BuiltInThemes[theme]

                if not data then return end

                -- custom themes are just regular dictionaries instead of an array with { index, dictionary }
                if self.Library.InnerVideoBackground ~= nil then
                    self.Library.InnerVideoBackground.Visible = false
                end
                
                local scheme = data[2]
                for idx, col in customThemeData or scheme do
                    if idx == "VideoLink" then
                        self.Library[idx] = col
                        
                        if self.Library.Options[idx] then
                            self.Library.Options[idx]:SetValue(col)
                        end
                        
                        ApplyBackgroundVideo(col)
                    else
                        self.Library[idx] = Color3.fromHex(col)
                        
                        if self.Library.Options[idx] then
                            self.Library.Options[idx]:SetValueRGB(Color3.fromHex(col))
                        end
                    end
                end

                self:ThemeUpdate()
            end

            function ThemeManager:ThemeUpdate()
                -- This allows us to force apply themes without loading the themes tab :)
                if self.Library.InnerVideoBackground ~= nil then
                    self.Library.InnerVideoBackground.Visible = false
                end

                local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor", "VideoLink" }
                for i, field in options do
                    if self.Library.Options and self.Library.Options[field] then
                        self.Library[field] = self.Library.Options[field].Value

                        if field == "VideoLink" then
                            ApplyBackgroundVideo(self.Library.Options[field].Value)
                        end
                    end
                end

                self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
                self.Library:UpdateColorsUsingRegistry()
            end

            --// Get, Load, Save, Delete, Refresh \\--
            function ThemeManager:GetCustomTheme(file)
                local path = self.Folder .. '/themes/' .. file .. '.json'
                if not isfile(path) then
                    return nil
                end

                local data = readfile(path)
                local success, decoded = pcall(httpService.JSONDecode, httpService, data)
                
                if not success then
                    return nil
                end

                return decoded
            end

            function ThemeManager:LoadDefault()
                local theme = 'Default'
                local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

                local isDefault = true
                if content then
                    if self.BuiltInThemes[content] then
                        theme = content
                    elseif self:GetCustomTheme(content) then
                        theme = content
                        isDefault = false;
                    end
                elseif self.BuiltInThemes[self.DefaultTheme] then
                    theme = self.DefaultTheme
                end

                if isDefault then
                    self.Library.Options.ThemeManager_ThemeList:SetValue(theme)
                else
                    self:ApplyTheme(theme)
                end
            end

            function ThemeManager:SaveDefault(theme)
                writefile(self.Folder .. '/themes/default.txt', theme)
            end

            function ThemeManager:SaveCustomTheme(file)
                if file:gsub(' ', '') == '' then
                    return self.Library:Notify('Invalid file name for theme (empty)', 3)
                end

                local theme = {}
                local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor", "VideoLink" }

                for _, field in fields do
                    if field == "VideoLink" then
                        theme[field] = self.Library.Options[field].Value
                    else
                        theme[field] = self.Library.Options[field].Value:ToHex()
                    end
                end

                return writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
            end

            function ThemeManager:Delete(name)
                if (not name) then
                    return false, 'no config file is selected'
                end

                local file = self.Folder .. '/themes/' .. name .. '.json'
                if not isfile(file) then return false, 'invalid file' end

                local success = pcall(delfile, file)
                if not success then return false, 'delete file error' end
                
                return true
            end
            
            function ThemeManager:ReloadCustomThemes()
                local list = listfiles(self.Folder .. '/themes')

                local out = {}
                for i = 1, #list do
                    local file = list[i]
                    if file:sub(-5) == '.json' then
                        -- i hate this but it has to be done ...

                        local pos = file:find('.json', 1, true)
                        local start = pos

                        local char = file:sub(pos, pos)
                        while char ~= '/' and char ~= '\\' and char ~= '' do
                            pos = pos - 1
                            char = file:sub(pos, pos)
                        end

                        if char == '/' or char == '\\' then
                            table.insert(out, file:sub(pos + 1, start - 1))
                        end
                    end
                end

                return out
            end

            --// GUI \\--
            function ThemeManager:CreateThemeManager(groupbox)
                groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
                groupbox:AddLabel('Main color')    :AddColorPicker('MainColor', { Default = self.Library.MainColor });
                groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
                groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
                groupbox:AddLabel('Font color')    :AddColorPicker('FontColor', { Default = self.Library.FontColor });
                groupbox:AddInput('VideoLink', { Text = '.webm Video Background (Link)', Default = self.Library.VideoLink });
                
                local ThemesArray = {}
                for Name, Theme in self.BuiltInThemes do
                    table.insert(ThemesArray, Name)
                end

                table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

                groupbox:AddDivider()

                groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })
                groupbox:AddButton('Set as default', function()
                    self:SaveDefault(self.Library.Options.ThemeManager_ThemeList.Value)
                    self.Library:Notify(string.format('Set default theme to %q', self.Library.Options.ThemeManager_ThemeList.Value))
                end)

                self.Library.Options.ThemeManager_ThemeList:OnChanged(function()
                    self:ApplyTheme(self.Library.Options.ThemeManager_ThemeList.Value)
                end)

                groupbox:AddDivider()

                groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
                groupbox:AddButton('Create theme', function() 
                    self:SaveCustomTheme(self.Library.Options.ThemeManager_CustomThemeName.Value)

                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end)

                groupbox:AddDivider()

                groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
                groupbox:AddButton('Load theme', function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:ApplyTheme(name)
                    self.Library:Notify(string.format('Loaded theme %q', name))
                end)
                groupbox:AddButton('Overwrite theme', function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:SaveCustomTheme(name)
                    self.Library:Notify(string.format('Overwrote config %q', name))
                end)
                groupbox:AddButton('Delete theme', function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        return self.Library:Notify('Failed to delete theme: ' .. err)
                    end

                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                    return self.Library:Notify(string.format('Deleted theme %q', name))
                end)
                groupbox:AddButton('Refresh list', function()
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end)
                groupbox:AddButton('Set as default', function()
                    if self.Library.Options.ThemeManager_CustomThemeList.Value ~= nil and self.Library.Options.ThemeManager_CustomThemeList.Value ~= '' then
                        self:SaveDefault(self.Library.Options.ThemeManager_CustomThemeList.Value)
                        self.Library:Notify(string.format('Set default theme to %q', self.Library.Options.ThemeManager_CustomThemeList.Value))
                    end
                end)
                groupbox:AddButton('Reset default', function()
                    local success = pcall(delfile, self.Folder .. '/themes/default.txt')
                    if not success then 
                        return self.Library:Notify('Failed to reset default: delete file error')
                    end
                        
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                    return self.Library:Notify('Set default theme to nothing')
                end)

                self:LoadDefault()

                local function UpdateTheme() self:ThemeUpdate() end
                self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
                self.Library.Options.MainColor:OnChanged(UpdateTheme)
                self.Library.Options.AccentColor:OnChanged(UpdateTheme)
                self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
                self.Library.Options.FontColor:OnChanged(UpdateTheme)
            end

            function ThemeManager:CreateGroupBox(tab)
                assert(self.Library, 'Must set ThemeManager.Library first!')
                return tab:AddLeftGroupbox('Themes')
            end

            function ThemeManager:ApplyToTab(tab)
                assert(self.Library, 'Must set ThemeManager.Library first!')
                local groupbox = self:CreateGroupBox(tab)
                self:CreateThemeManager(groupbox)
            end

            function ThemeManager:ApplyToGroupbox(groupbox)
                assert(self.Library, 'Must set ThemeManager.Library first!')
                self:CreateThemeManager(groupbox)
            end

            ThemeManager:BuildFolderTree()
        end

        return ThemeManager
    end,

    [51] = function(shared, wax, script, require)
        --// Source by deividcomsono //

        local table_find, Vector2_new
            = table.find, Vector2.new

        local Lucide = {}

        local IconIndices = {"a-arrow-down","a-arrow-up","a-large-small","accessibility","activity","air-vent","airplay","alarm-clock","alarm-clock-check","alarm-clock-minus","alarm-clock-off","alarm-clock-plus","alarm-smoke","album","align-center","align-center-horizontal","align-center-vertical","align-end-horizontal","align-end-vertical","align-horizontal-distribute-center","align-horizontal-distribute-end","align-horizontal-distribute-start","align-horizontal-justify-center","align-horizontal-justify-end","align-horizontal-justify-start","align-horizontal-space-around","align-horizontal-space-between","align-justify","align-left","align-right","align-start-horizontal","align-start-vertical","align-vertical-distribute-center","align-vertical-distribute-end","align-vertical-distribute-start","align-vertical-justify-center","align-vertical-justify-end","align-vertical-justify-start","align-vertical-space-around","align-vertical-space-between","ambulance","ampersand","ampersands","amphora","anchor","angry","annoyed","antenna","anvil","aperture","app-window","app-window-mac","apple","archive","archive-restore","archive-x","armchair","arrow-big-down","arrow-big-down-dash","arrow-big-left","arrow-big-left-dash","arrow-big-right","arrow-big-right-dash","arrow-big-up","arrow-big-up-dash","arrow-down","arrow-down-0-1","arrow-down-1-0","arrow-down-a-z","arrow-down-from-line","arrow-down-left","arrow-down-narrow-wide","arrow-down-right","arrow-down-to-dot","arrow-down-to-line","arrow-down-up","arrow-down-wide-narrow","arrow-down-z-a","arrow-left","arrow-left-from-line","arrow-left-right","arrow-left-to-line","arrow-right","arrow-right-from-line","arrow-right-left","arrow-right-to-line","arrow-up","arrow-up-0-1","arrow-up-1-0","arrow-up-a-z","arrow-up-down","arrow-up-from-dot","arrow-up-from-line","arrow-up-left","arrow-up-narrow-wide","arrow-up-right","arrow-up-to-line","arrow-up-wide-narrow","arrow-up-z-a","arrows-up-from-line","asterisk","at-sign","atom","audio-lines","audio-waveform","award","axe","axis-3d","baby","backpack","badge","badge-alert","badge-cent","badge-check","badge-dollar-sign","badge-euro","badge-help","badge-indian-rupee","badge-info","badge-japanese-yen","badge-minus","badge-percent","badge-plus","badge-pound-sterling","badge-russian-ruble","badge-swiss-franc","badge-x","baggage-claim","ban","banana","bandage","banknote","barcode","baseline","bath","battery","battery-charging","battery-full","battery-low","battery-medium","battery-warning","beaker","bean","bean-off","bed","bed-double","bed-single","beef","beer","beer-off","bell","bell-dot","bell-electric","bell-minus","bell-off","bell-plus","bell-ring","between-horizontal-end","between-horizontal-start","between-vertical-end","between-vertical-start","biceps-flexed","bike","binary","binoculars","biohazard","bird","bitcoin","blend","blinds","blocks","bluetooth","bluetooth-connected","bluetooth-off","bluetooth-searching","bold","bolt","bomb","bone","book","book-a","book-audio","book-check","book-copy","book-dashed","book-down","book-headphones","book-heart","book-image","book-key","book-lock","book-marked","book-minus","book-open","book-open-check","book-open-text","book-plus","book-text","book-type","book-up","book-up-2","book-user","book-x","bookmark","bookmark-check","bookmark-minus","bookmark-plus","bookmark-x","boom-box","bot","bot-message-square","bot-off","box","boxes","braces","brackets","brain","brain-circuit","brain-cog","brick-wall","briefcase","briefcase-business","briefcase-conveyor-belt","briefcase-medical","bring-to-front","brush","bug","bug-off","bug-play","building","building-2","bus","bus-front","cable","cable-car","cake","cake-slice","calculator","calendar","calendar-1","calendar-arrow-down","calendar-arrow-up","calendar-check","calendar-check-2","calendar-clock","calendar-cog","calendar-days","calendar-fold","calendar-heart","calendar-minus","calendar-minus-2","calendar-off","calendar-plus","calendar-plus-2","calendar-range","calendar-search","calendar-sync","calendar-x","calendar-x-2","camera","camera-off","candy","candy-cane","candy-off","cannabis","captions","captions-off","car","car-front","car-taxi-front","caravan","carrot","case-lower","case-sensitive","case-upper","cassette-tape","cast","castle","cat","cctv","chart-area","chart-bar","chart-bar-big","chart-bar-decreasing","chart-bar-increasing","chart-bar-stacked","chart-candlestick","chart-column","chart-column-big","chart-column-decreasing","chart-column-increasing","chart-column-stacked","chart-gantt","chart-line","chart-network","chart-no-axes-column","chart-no-axes-column-decreasing","chart-no-axes-column-increasing","chart-no-axes-combined","chart-no-axes-gantt","chart-pie","chart-scatter","chart-spline","check","check-check","chef-hat","cherry","chevron-down","chevron-first","chevron-last","chevron-left","chevron-right","chevron-up","chevrons-down","chevrons-down-up","chevrons-left","chevrons-left-right","chevrons-left-right-ellipsis","chevrons-right","chevrons-right-left","chevrons-up","chevrons-up-down","chrome","church","cigarette","cigarette-off","circle","circle-alert","circle-arrow-down","circle-arrow-left","circle-arrow-out-down-left","circle-arrow-out-down-right","circle-arrow-out-up-left","circle-arrow-out-up-right","circle-arrow-right","circle-arrow-up","circle-check","circle-check-big","circle-chevron-down","circle-chevron-left","circle-chevron-right","circle-chevron-up","circle-dashed","circle-divide","circle-dollar-sign","circle-dot","circle-dot-dashed","circle-ellipsis","circle-equal","circle-fading-arrow-up","circle-fading-plus","circle-gauge","circle-help","circle-minus","circle-off","circle-parking","circle-parking-off","circle-pause","circle-percent","circle-play","circle-plus","circle-power","circle-slash","circle-slash-2","circle-stop","circle-user","circle-user-round","circle-x","circuit-board","citrus","clapperboard","clipboard","clipboard-check","clipboard-copy","clipboard-list","clipboard-minus","clipboard-paste","clipboard-pen","clipboard-pen-line","clipboard-plus","clipboard-type","clipboard-x","clock","clock-1","clock-10","clock-11","clock-12","clock-2","clock-3","clock-4","clock-5","clock-6","clock-7","clock-8","clock-9","clock-alert","clock-arrow-down","clock-arrow-up","cloud","cloud-alert","cloud-cog","cloud-download","cloud-drizzle","cloud-fog","cloud-hail","cloud-lightning","cloud-moon","cloud-moon-rain","cloud-off","cloud-rain","cloud-rain-wind","cloud-snow","cloud-sun","cloud-sun-rain","cloud-upload","cloudy","clover","club","code","code-xml","codepen","codesandbox","coffee","cog","coins","columns-2","columns-3","columns-4","combine","command","compass","component","computer","concierge-bell","cone","construction","contact","contact-round","container","contrast","cookie","cooking-pot","copy","copy-check","copy-minus","copy-plus","copy-slash","copy-x","copyleft","copyright","corner-down-left","corner-down-right","corner-left-down","corner-left-up","corner-right-down","corner-right-up","corner-up-left","corner-up-right","cpu","creative-commons","credit-card","croissant","crop","cross","crosshair","crown","cuboid","cup-soda","currency","cylinder","dam","database","database-backup","database-zap","delete","dessert","diameter","diamond","diamond-minus","diamond-percent","diamond-plus","dice-1","dice-2","dice-3","dice-4","dice-5","dice-6","dices","diff","disc","disc-2","disc-3","disc-album","divide","dna","dna-off","dock","dog","dollar-sign","donut","door-closed","door-open","dot","download","drafting-compass","drama","dribbble","drill","droplet","droplet-off","droplets","drum","drumstick","dumbbell","ear","ear-off","earth","earth-lock","eclipse","egg","egg-fried","egg-off","ellipsis","ellipsis-vertical","equal","equal-approximately","equal-not","eraser","ethernet-port","euro","expand","external-link","eye","eye-closed","eye-off","facebook","factory","fan","fast-forward","feather","fence","ferris-wheel","figma","file","file-archive","file-audio","file-audio-2","file-axis-3d","file-badge","file-badge-2","file-box","file-chart-column","file-chart-column-increasing","file-chart-line","file-chart-pie","file-check","file-check-2","file-clock","file-code","file-code-2","file-cog","file-diff","file-digit","file-down","file-heart","file-image","file-input","file-json","file-json-2","file-key","file-key-2","file-lock","file-lock-2","file-minus","file-minus-2","file-music","file-output","file-pen","file-pen-line","file-plus","file-plus-2","file-question","file-scan","file-search","file-search-2","file-sliders","file-spreadsheet","file-stack","file-symlink","file-terminal","file-text","file-type","file-type-2","file-up","file-user","file-video","file-video-2","file-volume","file-volume-2","file-warning","file-x","file-x-2","files","film","filter","filter-x","fingerprint","fire-extinguisher","fish","fish-off","fish-symbol","flag","flag-off","flag-triangle-left","flag-triangle-right","flame","flame-kindling","flashlight","flashlight-off","flask-conical","flask-conical-off","flask-round","flip-horizontal","flip-horizontal-2","flip-vertical","flip-vertical-2","flower","flower-2","focus","fold-horizontal","fold-vertical","folder","folder-archive","folder-check","folder-clock","folder-closed","folder-code","folder-cog","folder-dot","folder-down","folder-git","folder-git-2","folder-heart","folder-input","folder-kanban","folder-key","folder-lock","folder-minus","folder-open","folder-open-dot","folder-output","folder-pen","folder-plus","folder-root","folder-search","folder-search-2","folder-symlink","folder-sync","folder-tree","folder-up","folder-x","folders","footprints","forklift","forward","frame","framer","frown","fuel","fullscreen","gallery-horizontal","gallery-horizontal-end","gallery-thumbnails","gallery-vertical","gallery-vertical-end","gamepad","gamepad-2","gauge","gavel","gem","ghost","gift","git-branch","git-branch-plus","git-commit-horizontal","git-commit-vertical","git-compare","git-compare-arrows","git-fork","git-graph","git-merge","git-pull-request","git-pull-request-arrow","git-pull-request-closed","git-pull-request-create","git-pull-request-create-arrow","git-pull-request-draft","github","gitlab","glass-water","glasses","globe","globe-lock","goal","grab","graduation-cap","grape","grid-2x2","grid-2x2-check","grid-2x2-plus","grid-2x2-x","grid-3x3","grip","grip-horizontal","grip-vertical","group","guitar","ham","hammer","hand","hand-coins","hand-heart","hand-helping","hand-metal","hand-platter","handshake","hard-drive","hard-drive-download","hard-drive-upload","hard-hat","hash","haze","hdmi-port","heading","heading-1","heading-2","heading-3","heading-4","heading-5","heading-6","headphone-off","headphones","headset","heart","heart-crack","heart-handshake","heart-off","heart-pulse","heater","hexagon","highlighter","history","hop","hop-off","hospital","hotel","hourglass","house","house-plug","house-plus","ice-cream-bowl","ice-cream-cone","id-card","image","image-down","image-minus","image-off","image-play","image-plus","image-up","image-upscale","images","import","inbox","indent-decrease","indent-increase","indian-rupee","infinity","info","inspection-panel","instagram","italic","iteration-ccw","iteration-cw","japanese-yen","joystick","kanban","key","key-round","key-square","keyboard","keyboard-music","keyboard-off","lamp","lamp-ceiling","lamp-desk","lamp-floor","lamp-wall-down","lamp-wall-up","land-plot","landmark","languages","laptop","laptop-minimal","laptop-minimal-check","lasso","lasso-select","laugh","layers","layers-2","layout-dashboard","layout-grid","layout-list","layout-panel-left","layout-panel-top","layout-template","leaf","leafy-green","lectern","letter-text","library","library-big","life-buoy","ligature","lightbulb","lightbulb-off","link","link-2","link-2-off","linkedin","list","list-check","list-checks","list-collapse","list-end","list-filter","list-filter-plus","list-minus","list-music","list-ordered","list-plus","list-restart","list-start","list-todo","list-tree","list-video","list-x","loader","loader-circle","loader-pinwheel","locate","locate-fixed","locate-off","lock","lock-keyhole","lock-keyhole-open","lock-open","log-in","log-out","logs","lollipop","luggage","magnet","mail","mail-check","mail-minus","mail-open","mail-plus","mail-question","mail-search","mail-warning","mail-x","mailbox","mails","map","map-pin","map-pin-check","map-pin-check-inside","map-pin-house","map-pin-minus","map-pin-minus-inside","map-pin-off","map-pin-plus","map-pin-plus-inside","map-pin-x","map-pin-x-inside","map-pinned","martini","maximize","maximize-2","medal","megaphone","megaphone-off","meh","memory-stick","menu","merge","message-circle","message-circle-code","message-circle-dashed","message-circle-heart","message-circle-more","message-circle-off","message-circle-plus","message-circle-question","message-circle-reply","message-circle-warning","message-circle-x","message-square","message-square-code","message-square-dashed","message-square-diff","message-square-dot","message-square-heart","message-square-lock","message-square-more","message-square-off","message-square-plus","message-square-quote","message-square-reply","message-square-share","message-square-text","message-square-warning","message-square-x","messages-square","mic","mic-off","mic-vocal","microchip","microscope","microwave","milestone","milk","milk-off","minimize","minimize-2","minus","monitor","monitor-check","monitor-cog","monitor-dot","monitor-down","monitor-off","monitor-pause","monitor-play","monitor-smartphone","monitor-speaker","monitor-stop","monitor-up","monitor-x","moon","moon-star","mountain","mountain-snow","mouse","mouse-off","mouse-pointer","mouse-pointer-2","mouse-pointer-ban","mouse-pointer-click","move","move-3d","move-diagonal","move-diagonal-2","move-down","move-down-left","move-down-right","move-horizontal","move-left","move-right","move-up","move-up-left","move-up-right","move-vertical","music","music-2","music-3","music-4","navigation","navigation-2","navigation-2-off","navigation-off","network","newspaper","nfc","notebook","notebook-pen","notebook-tabs","notebook-text","notepad-text","notepad-text-dashed","nut","nut-off","octagon","octagon-alert","octagon-minus","octagon-pause","octagon-x","omega","option","orbit","origami","package","package-2","package-check","package-minus","package-open","package-plus","package-search","package-x","paint-bucket","paint-roller","paintbrush","paintbrush-vertical","palette","panel-bottom","panel-bottom-close","panel-bottom-dashed","panel-bottom-open","panel-left","panel-left-close","panel-left-dashed","panel-left-open","panel-right","panel-right-close","panel-right-dashed","panel-right-open","panel-top","panel-top-close","panel-top-dashed","panel-top-open","panels-left-bottom","panels-right-bottom","panels-top-left","paperclip","parentheses","parking-meter","party-popper","pause","paw-print","pc-case","pen","pen-line","pen-off","pen-tool","pencil","pencil-line","pencil-off","pencil-ruler","pentagon","percent","person-standing","philippine-peso","phone","phone-call","phone-forwarded","phone-incoming","phone-missed","phone-off","phone-outgoing","pi","piano","pickaxe","picture-in-picture","picture-in-picture-2","piggy-bank","pilcrow","pilcrow-left","pilcrow-right","pill","pill-bottle","pin","pin-off","pipette","pizza","plane","plane-landing","plane-takeoff","play","plug","plug-2","plug-zap","plus","pocket","pocket-knife","podcast","pointer","pointer-off","popcorn","popsicle","pound-sterling","power","power-off","presentation","printer","printer-check","projector","proportions","puzzle","pyramid","qr-code","quote","rabbit","radar","radiation","radical","radio","radio-receiver","radio-tower","radius","rail-symbol","rainbow","rat","ratio","receipt","receipt-cent","receipt-euro","receipt-indian-rupee","receipt-japanese-yen","receipt-pound-sterling","receipt-russian-ruble","receipt-swiss-franc","receipt-text","rectangle-ellipsis","rectangle-horizontal","rectangle-vertical","recycle","redo","redo-2","redo-dot","refresh-ccw","refresh-ccw-dot","refresh-cw","refresh-cw-off","refrigerator","regex","remove-formatting","repeat","repeat-1","repeat-2","replace","replace-all","reply","reply-all","rewind","ribbon","rocket","rocking-chair","roller-coaster","rotate-3d","rotate-ccw","rotate-ccw-square","rotate-cw","rotate-cw-square","route","route-off","router","rows-2","rows-3","rows-4","rss","ruler","russian-ruble","sailboat","salad","sandwich","satellite","satellite-dish","save","save-all","save-off","scale","scale-3d","scaling","scan","scan-barcode","scan-eye","scan-face","scan-heart","scan-line","scan-qr-code","scan-search","scan-text","school","scissors","scissors-line-dashed","screen-share","screen-share-off","scroll","scroll-text","search","search-check","search-code","search-slash","search-x","section","send","send-horizontal","send-to-back","separator-horizontal","separator-vertical","server","server-cog","server-crash","server-off","settings","settings-2","shapes","share","share-2","sheet","shell","shield","shield-alert","shield-ban","shield-check","shield-ellipsis","shield-half","shield-minus","shield-off","shield-plus","shield-question","shield-x","ship","ship-wheel","shirt","shopping-bag","shopping-basket","shopping-cart","shovel","shower-head","shrink","shrub","shuffle","sigma","signal","signal-high","signal-low","signal-medium","signal-zero","signature","signpost","signpost-big","siren","skip-back","skip-forward","skull","slack","slash","slice","sliders-horizontal","sliders-vertical","smartphone","smartphone-charging","smartphone-nfc","smile","smile-plus","snail","snowflake","sofa","soup","space","spade","sparkle","sparkles","speaker","speech","spell-check","spell-check-2","spline","split","spray-can","sprout","square","square-activity","square-arrow-down","square-arrow-down-left","square-arrow-down-right","square-arrow-left","square-arrow-out-down-left","square-arrow-out-down-right","square-arrow-out-up-left","square-arrow-out-up-right","square-arrow-right","square-arrow-up","square-arrow-up-left","square-arrow-up-right","square-asterisk","square-bottom-dashed-scissors","square-chart-gantt","square-check","square-check-big","square-chevron-down","square-chevron-left","square-chevron-right","square-chevron-up","square-code","square-dashed","square-dashed-bottom","square-dashed-bottom-code","square-dashed-kanban","square-dashed-mouse-pointer","square-divide","square-dot","square-equal","square-function","square-kanban","square-library","square-m","square-menu","square-minus","square-mouse-pointer","square-parking","square-parking-off","square-pen","square-percent","square-pi","square-pilcrow","square-play","square-plus","square-power","square-radical","square-scissors","square-sigma","square-slash","square-split-horizontal","square-split-vertical","square-square","square-stack","square-terminal","square-user","square-user-round","square-x","squircle","squirrel","stamp","star","star-half","star-off","step-back","step-forward","stethoscope","sticker","sticky-note","store","stretch-horizontal","stretch-vertical","strikethrough","subscript","sun","sun-dim","sun-medium","sun-moon","sun-snow","sunrise","sunset","superscript","swatch-book","swiss-franc","switch-camera","sword","swords","syringe","table","table-2","table-cells-merge","table-cells-split","table-columns-split","table-of-contents","table-properties","table-rows-split","tablet","tablet-smartphone","tablets","tag","tags","tally-1","tally-2","tally-3","tally-4","tally-5","tangent","target","telescope","tent","tent-tree","terminal","test-tube","test-tube-diagonal","test-tubes","text","text-cursor","text-cursor-input","text-quote","text-search","text-select","theater","thermometer","thermometer-snowflake","thermometer-sun","thumbs-down","thumbs-up","ticket","ticket-check","ticket-minus","ticket-percent","ticket-plus","ticket-slash","ticket-x","tickets","tickets-plane","timer","timer-off","timer-reset","toggle-left","toggle-right","toilet","tornado","torus","touchpad","touchpad-off","tower-control","toy-brick","tractor","traffic-cone","train-front","train-front-tunnel","train-track","tram-front","trash","trash-2","tree-deciduous","tree-palm","tree-pine","trees","trello","trending-down","trending-up","trending-up-down","triangle","triangle-alert","triangle-right","trophy","truck","turtle","tv","tv-minimal","tv-minimal-play","twitch","twitter","type","type-outline","umbrella","umbrella-off","underline","undo","undo-2","undo-dot","unfold-horizontal","unfold-vertical","ungroup","university","unlink","unlink-2","unplug","upload","usb","user","user-check","user-cog","user-minus","user-pen","user-plus","user-round","user-round-check","user-round-cog","user-round-minus","user-round-pen","user-round-plus","user-round-search","user-round-x","user-search","user-x","users","users-round","utensils","utensils-crossed","utility-pole","variable","vault","vegan","venetian-mask","vibrate","vibrate-off","video","video-off","videotape","view","voicemail","volleyball","volume","volume-1","volume-2","volume-off","volume-x","vote","wallet","wallet-cards","wallet-minimal","wallpaper","wand","wand-sparkles","warehouse","washing-machine","watch","waves","waves-ladder","waypoints","webcam","webhook","webhook-off","weight","wheat","wheat-off","whole-word","wifi","wifi-high","wifi-low","wifi-off","wifi-zero","wind","wind-arrow-down","wine","wine-off","workflow","worm","wrap-text","wrench","x","youtube","zap","zap-off","zoom-in","zoom-out"}

        local IconRegistry = {
            {49,0},{0,49},{74,0},{49,25},{0,74},{99,0},{74,25},{74,50},{49,50},{0,99},{124,0},{99,25},{49,75},{0,124},{99,50},{149,0},{124,25},{74,75},{49,100},{0,149},{174,0},{149,25},{124,50},{99,75},{74,100},{49,125},{0,174},{199,0},{174,25},{149,50},{124,75},{99,100},{74,125},{49,150},{0,199},{224,0},{199,25},{174,50},{149,75},{124,100},{99,125},{74,150},{49,175},{0,224},{249,0},{224,25},{199,50},{174,75},{149,100},{124,125},{74,175},{99,150},{49,200},{249,25},{0,249},{274,0},{224,50},{174,100},{199,75},{124,150},{149,125},{74,200},{99,175},{0,274},{49,225},{324,0},{299,0},{274,25},{249,50},{224,75},{199,100},{174,125},{149,150},{124,175},{99,200},{74,225},{49,250},{0,299},{224,100},{299,25},{274,50},{249,75},{124,200},{199,125},{174,150},{149,175},{149,200},{99,225},{74,250},{49,275},{0,324},{349,0},{324,25},{299,50},{274,75},{249,100},{224,125},{199,150},{174,175},{124,225},{99,250},{74,275},{49,300},{0,349},{374,0},{349,25},{324,50},{299,75},{274,100},{249,125},{224,175},{224,150},{199,175},{174,200},{149,225},{124,250},{99,275},{74,300},{49,325},{0,374},{399,0},{374,25},{349,50},{324,75},{299,100},{274,125},{249,150},{199,200},{174,225},{149,250},{124,275},{99,300},{74,325},{49,350},{0,399},{299,125},{424,0},{399,25},{374,50},{349,75},{324,100},{274,150},{224,200},{249,175},{149,275},{199,225},{174,250},{124,300},{74,350},{99,325},{349,100},{49,375},{0,424},{449,0},{424,25},{399,50},{374,75},{324,125},{299,150},{274,175},{249,200},{224,225},{199,250},{174,275},{149,300},{124,325},{99,350},{74,375},{49,400},{0,449},{474,0},{374,100},{449,25},{424,50},{399,75},{349,125},{324,150},{299,175},{274,200},{174,325},{249,225},{224,250},{199,275},{174,300},{149,325},{124,350},{99,375},{74,400},{49,425},{0,474},{499,0},{474,25},{449,50},{374,125},{424,75},{399,100},{349,150},{324,175},{299,200},{249,250},{274,225},{224,275},{199,300},{49,450},{149,350},{124,375},{99,400},{74,425},{0,499},{474,50},{524,0},{499,25},{449,75},{424,100},{399,125},{374,150},{299,225},{349,175},{324,200},{274,250},{174,350},{249,275},{224,300},{199,325},{149,375},{124,400},{49,475},{99,425},{74,450},{549,0},{0,524},{499,50},{524,25},{449,100},{474,75},{399,150},{424,125},{374,175},{424,150},{349,200},{324,225},{299,250},{249,300},{274,275},{224,325},{199,350},{174,375},{149,400},{124,425},{74,475},{99,450},{49,500},{574,0},{0,549},{549,25},{524,50},{499,75},{449,125},{474,100},{374,200},{399,175},{299,275},{349,225},{324,250},{274,300},{224,350},{249,325},{149,425},{199,375},{174,400},{124,450},{99,475},{74,500},{49,525},{0,574},{599,0},{574,25},{549,50},{524,75},{499,100},{474,125},{349,250},{449,150},{424,175},{399,200},{374,225},{324,275},{199,400},{299,300},{274,325},{249,350},{224,375},{174,425},{149,450},{124,475},{49,550},{99,500},{74,525},{0,599},{624,0},{599,25},{574,50},{549,75},{499,125},{524,100},{474,150},{449,175},{424,200},{399,225},{374,250},{349,275},{324,300},{299,325},{249,375},{274,350},{174,450},{199,425},{224,400},{124,500},{149,475},{74,550},{99,525},{49,575},{0,624},{624,25},{649,0},{249,425},{599,50},{574,75},{549,100},{524,125},{499,150},{474,175},{449,200},{424,225},{399,250},{349,300},{374,275},{324,325},{299,350},{274,375},{249,400},{224,425},{199,450},{174,475},{124,525},{149,500},{99,550},{74,575},{49,600},{0,649},{674,0},{649,25},{624,50},{599,75},{549,125},{574,100},{524,150},{499,175},{474,200},{449,225},{424,250},{374,300},{399,275},{349,325},{299,375},{324,350},{274,400},{224,450},{199,475},{174,500},{599,100},{149,525},{124,550},{99,575},{74,600},{49,625},{699,0},{0,674},{674,25},{649,50},{624,75},{199,500},{574,125},{549,150},{524,175},{499,200},{474,225},{449,250},{424,275},{399,300},{374,325},{349,350},{324,375},{299,400},{274,425},{249,450},{224,475},{499,225},{174,525},{149,550},{124,575},{99,600},{74,625},{49,650},{0,699},{699,25},{724,0},{674,50},{624,100},{649,75},{599,125},{549,175},{574,150},{524,200},{474,250},{449,275},{424,300},{374,350},{399,325},{349,375},{324,400},{299,425},{274,450},{249,475},{224,500},{199,525},{174,550},{149,575},{124,600},{99,625},{74,650},{49,675},{0,724},{749,0},{724,25},{674,75},{699,50},{649,100},{624,125},{599,150},{574,175},{424,325},{549,200},{524,225},{499,250},{474,275},{449,300},{399,350},{374,375},{349,400},{324,425},{299,450},{274,475},{249,500},{224,525},{199,550},{174,575},{149,600},{124,625},{99,650},{74,675},{49,700},{0,749},{774,0},{749,25},{724,50},{699,75},{674,100},{649,125},{624,150},{549,225},{599,175},{574,200},{524,250},{499,275},{474,300},{374,400},{449,325},{424,350},{399,375},{349,425},{324,450},{299,475},{274,500},{249,525},{224,550},{199,575},{174,600},{74,700},{149,625},{124,650},{99,675},{49,725},{799,0},{0,774},{774,25},{749,50},{724,75},{699,100},{674,125},{649,150},{624,175},{599,200},{574,225},{549,250},{524,275},{499,300},{449,350},{474,325},{424,375},{399,400},{374,425},{349,450},{299,500},{324,475},{249,550},{274,525},{224,575},{149,650},{199,600},{174,625},{99,700},{124,675},{0,799},{74,725},{49,750},{824,0},{799,25},{774,50},{749,75},{724,100},{649,175},{699,125},{674,150},{624,200},{599,225},{574,250},{549,275},{524,300},{499,325},{474,350},{449,375},{699,175},{424,400},{374,450},{399,425},{349,475},{299,525},{324,500},{274,550},{224,600},{249,575},{199,625},{174,650},{124,700},{149,675},{99,725},{49,775},{74,750},{0,824},{849,0},{824,25},{799,50},{774,75},{749,100},{724,125},{674,175},{699,150},{624,225},{649,200},{574,275},{599,250},{524,325},{549,300},{499,350},{474,375},{424,425},{449,400},{374,475},{399,450},{349,500},{324,525},{274,575},{299,550},{249,600},{224,625},{199,650},{174,675},{149,700},{124,725},{74,775},{99,750},{49,800},{0,849},{849,25},{874,0},{799,75},{824,50},{774,100},{724,150},{749,125},{674,200},{649,225},{599,275},{624,250},{574,300},{549,325},{474,400},{524,350},{499,375},{374,500},{449,425},{424,450},{399,475},{324,550},{349,525},{274,600},{299,575},{224,650},{249,625},{199,675},{149,725},{174,700},{99,775},{124,750},{49,825},{74,800},{0,874},{899,0},{874,25},{124,775},{849,50},{824,75},{799,100},{774,125},{749,150},{724,175},{699,200},{674,225},{624,275},{649,250},{599,300},{574,325},{549,350},{524,375},{499,400},{474,425},{424,475},{449,450},{399,500},{374,525},{349,550},{324,575},{274,625},{299,600},{249,650},{224,675},{199,700},{174,725},{149,750},{99,800},{74,825},{49,850},{0,899},{924,0},{899,25},{874,50},{849,75},{824,100},{774,150},{799,125},{749,175},{699,225},{724,200},{649,275},{674,250},{624,300},{599,325},{574,350},{549,375},{524,400},{474,450},{499,425},{449,475},{424,500},{374,550},{399,525},{349,575},{324,600},{299,625},{149,775},{274,650},{249,675},{199,725},{224,700},{174,750},{124,800},{99,825},{74,850},{49,875},{949,0},{0,924},{924,25},{899,50},{874,75},{849,100},{749,200},{824,125},{799,150},{774,175},{724,225},{649,300},{699,250},{674,275},{624,325},{599,350},{574,375},{549,400},{399,550},{524,425},{499,450},{474,475},{449,500},{424,525},{374,575},{299,650},{349,600},{324,625},{274,675},{249,700},{224,725},{199,750},{0,949},{174,775},{149,800},{124,825},{99,850},{74,875},{49,900},{974,0},{949,25},{924,50},{799,175},{899,75},{874,100},{849,125},{824,150},{774,200},{749,225},{724,250},{699,275},{649,325},{674,300},{624,350},{599,375},{574,400},{499,475},{549,425},{524,450},{474,500},{449,525},{424,550},{224,750},{399,575},{374,600},{349,625},{324,650},{299,675},{274,700},{249,725},{199,775},{174,800},{149,825},{124,850},{99,875},{74,900},{49,925},{0,974},{974,25},{949,50},{924,75},{899,100},{874,125},{849,150},{824,175},{799,200},{724,275},{774,225},{749,250},{649,350},{699,300},{674,325},{499,500},{624,375},{599,400},{574,425},{549,450},{524,475},{474,525},{449,550},{424,575},{349,650},{374,625},{399,600},{299,700},{324,675},{274,725},{224,775},{249,750},{199,800},{174,825},{149,850},{124,875},{99,900},{74,925},{49,950},{974,50},{949,75},{924,100},{874,150},{899,125},{849,175},{824,200},{774,250},{799,225},{699,325},{724,300},{749,275},{674,350},{249,775},{649,375},{624,400},{599,425},{574,450},{524,500},{549,475},{499,525},{474,550},{449,575},{424,600},{399,625},{374,650},{349,675},{324,700},{299,725},{274,750},{174,850},{224,800},{199,825},{99,925},{149,875},{124,900},{949,100},{49,975},{74,950},{974,75},{924,125},{899,150},{874,175},{849,200},{824,225},{799,250},{574,475},{774,275},{749,300},{724,325},{699,350},{674,375},{649,400},{624,425},{599,450},{549,500},{524,525},{199,850},{249,800},{474,575},{499,550},{449,600},{399,650},{424,625},{374,675},{324,725},{349,700},{274,775},{299,750},{224,825},{174,875},{124,925},{149,900},{99,950},{974,100},{74,975},{949,125},{924,150},{899,175},{874,200},{599,475},{849,225},{824,250},{799,275},{774,300},{749,325},{724,350},{699,375},{674,400},{649,425},{624,450},{199,875},{574,500},{549,525},{524,550},{499,575},{474,600},{449,625},{424,650},{399,675},{374,700},{349,725},{324,750},{299,775},{274,800},{249,825},{224,850},{174,900},{99,975},{149,925},{124,950},{974,125},{949,150},{924,175},{899,200},{849,250},{874,225},{799,300},{824,275},{774,325},{449,650},{749,350},{724,375},{699,400},{674,425},{649,450},{624,475},{599,500},{574,525},{549,550},{524,575},{499,600},{474,625},{399,700},{424,675},{349,750},{374,725},{199,900},{324,775},{224,875},{299,800},{274,825},{249,850},{724,400},{174,925},{124,975},{149,950},{924,200},{974,150},{949,175},{899,225},{874,250},{849,275},{774,350},{824,300},{799,325},{749,375},{624,500},{699,425},{674,450},{649,475},{524,600},{574,550},{599,525},{549,575},{499,625},{474,650},{449,675},{349,775},{424,700},{399,725},{374,750},{299,825},{324,800},{249,875},{274,850},{974,175},{224,900},{199,925},{174,950},{149,975},{949,200},{924,225},{899,250},{874,275},{674,475},{849,300},{824,325},{799,350},{774,375},{749,400},{724,425},{699,450},{649,500},{624,525},{574,575},{599,550},{549,600},{449,700},{524,625},{499,650},{474,675},{349,800},{424,725},{399,750},{374,775},{249,900},{324,825},{299,850},{274,875},{974,200},{224,925},{199,950},{174,975},{949,225},{924,250},{899,275},{874,300},{849,325},{824,350},{799,375},{774,400},{749,425},{724,450},{624,550},{699,475},{674,500},{649,525},{524,650},{599,575},{574,600},{549,625},{499,675},{474,700},{449,725},{424,750},{249,925},{399,775},{374,800},{349,825},{324,850},{299,875},{274,900},{224,950},{199,975},{974,225},{924,275},{949,250},{899,300},{824,375},{874,325},{849,350},{774,425},{799,400},{724,475},{749,450},{699,500},{674,525},{599,600},{649,550},{624,575},{574,625},{499,700},{549,650},{524,675},{474,725},{424,775},{449,750},{399,800},{349,850},{374,825},{324,875},{299,900},{274,925},{224,975},{249,950},{974,250},{924,300},{949,275},{899,325},{874,350},{849,375},{824,400},{799,425},{774,450},{749,475},{724,500},{699,525},{674,550},{599,625},{649,575},{624,600},{574,650},{549,675},{524,700},{499,725},{474,750},{249,975},{449,775},{424,800},{399,825},{374,850},{349,875},{324,900},{299,925},{274,950},{974,275},{949,300},{924,325},{899,350},{824,425},{874,375},{849,400},{774,475},{799,450},{724,525},{749,500},{699,550},{674,575},{649,600},{574,675},{624,625},{599,650},{524,725},{549,700},{474,775},{499,750},{449,800},{424,825},{399,850},{374,875},{349,900},{324,925},{274,975},{299,950},{949,325},{974,300},{899,375},{924,350},{874,400},{849,425},{824,450},{799,475},{774,500},{749,525},{724,550},{699,575},{674,600},{649,625},{599,675},{624,650},{524,750},{574,700},{549,725},{474,800},{499,775},{449,825},{924,375},{424,850},{399,875},{374,900},{349,925},{324,950},{299,975},{974,325},{949,350},{899,400},{849,450},{874,425},{799,500},{824,475},{749,550},{774,525},{624,675},{724,575},{699,600},{674,625},{649,650},{599,700},{524,775},{574,725},{549,750},{499,800},{474,825},{374,925},{449,850},{424,875},{399,900},{324,975},{349,950},{974,350},{924,400},{949,375},{899,425},{874,450},{599,725},{849,475},{824,500},{799,525},{774,550},{749,575},{724,600},{699,625},{674,650},{649,675},{624,700},{549,775},{574,750},{524,800},{499,825},{474,850},{449,875},{424,900},{399,925},{374,950},{349,975},{974,375},{949,400},{824,525},{924,425},{899,450},{874,475},{849,500},{799,550},{749,600},{774,575},{724,625},{699,650},{674,675},{649,700},{624,725},{599,750},{574,775},{549,800},{524,825},{449,900},{499,850},{474,875},{399,950},{424,925},{374,975},{974,400},{949,425},{924,450},{899,475},{874,500},{849,525},{824,550},{799,575},{774,600},{724,650},{749,625},{699,675},{674,700},{649,725},{624,750},{874,575},{599,775},{524,850},{574,800},{549,825},{499,875},{474,900},{449,925},{424,950},{399,975},{974,425},{899,500},{949,450},{924,475},{874,525},{849,550},{824,575},{774,625},{799,600},{749,650},{724,675},{699,700},{674,725},{649,750},{524,875},{599,800},{624,775},{574,825},{549,850},{499,900},{474,925},{449,950},{424,975},{974,450},{949,475},{924,500},{899,525},{874,550},{849,575},{799,625},{824,600},{774,650},{749,675},{724,700},{699,725},{674,750},{649,775},{624,800},{599,825},{48,48},{574,850},{549,875},{524,900},{499,925},{474,950},{449,975},{974,475},{924,525},{949,500},{899,550},{849,600},{824,625},{799,650},{724,725},{774,675},{749,700},{699,750},{674,775},{649,800},{624,825},{599,850},{574,875},{549,900},{524,925},{499,950},{474,975},{874,600},{974,500},{949,525},{924,550},{899,575},{849,625},{824,650},{799,675},{774,700},{749,725},{724,750},{699,775},{674,800},{649,825},{949,550},{624,850},{599,875},{574,900},{549,925},{524,950},{499,975},{974,525},{899,600},{924,575},{874,625},{849,650},{824,675},{799,700},{774,725},{749,750},{724,775},{699,800},{674,825},{649,850},{624,875},{574,925},{599,900},{549,950},{974,550},{524,975},{949,575},{799,725},{899,625},{924,600},{874,650},{849,675},{824,700},{774,750},{699,825},{749,775},{724,800},{674,850},{649,875},{924,625},{624,900},{599,925},{574,950},{549,975},{974,575},{949,600},{874,675},{899,650},{799,750},{849,700},{824,725},{774,775},{749,800},{724,825},{699,850},{674,875},{624,925},{649,900},{599,950},{574,975},{974,600},{949,625},{899,675},{924,650},{874,700},{849,725},{799,775},{824,750},{774,800},{749,825},{724,850},{699,875},{674,900},{649,925},{599,975},{624,950},{924,675},{974,625},{949,650},{899,700},{874,725},{849,750},{774,825},{799,800},{824,775},{749,850},{724,875},{674,925},{699,900},{624,975},{649,950},{974,650},{899,725},{949,675},{924,700},{874,750},{849,775},{824,800},{799,825},{749,875},{774,850},{724,900},{699,925},{674,950},{949,725},{649,975},{974,675},{949,700},{924,725},{899,750},{699,950},{874,775},{849,800},{824,825},{799,850},{774,875},{749,900},{724,925},{674,975},{974,700},{899,775},{924,750},{849,825},{874,800},{824,850},{799,875},{774,900},{749,925},{724,950},{974,725},{699,975},{924,775},{949,750},{899,800},{874,825},{849,850},{824,875},{974,750},{799,900},{774,925},{749,950},{724,975},{949,775},{874,850},{924,800},{899,825},{849,875},{799,925},{824,900},{774,950},{749,975},{974,775},{924,825},{949,800},{899,850},{874,875},{824,925},{849,900},{799,950},{974,800},{774,975},{949,825},{824,950},{924,850},{899,875},{874,900},{849,925},{974,825},{799,975},{924,875},{949,850},{899,900},{874,925},{849,950},{824,975},{974,850},{949,875},{899,925},{924,900},{874,950},{849,975}
        } :: {{number}}

        Lucide.Icons = IconIndices

        type Icon = {
            IconName: string,
            Id:       number,
            Url:      string,

            ImageRectSize:   Vector2,
            ImageRectOffset: Vector2,
        }

        function Lucide.GetAsset(Name: string): Icon?
            local IconIndex = table_find(IconIndices, Name)
            local Icon      = IconRegistry[(IconIndex :: any)]

            if not Icon then return end

            return {
                Id  = 103134660123798,
                Url = `rbxassetid://103134660123798`,

                IconName        = Name,
                ImageRectSize   = Vector2_new(24, 24),
                ImageRectOffset = Vector2_new(Icon[1], Icon[2]),
            }
        end

        return Lucide
    end,

    [53] = function(shared, wax, script, require)
        --// Source by deividcomsono //

        local table_insert, table_remove, table_find, table_sort, table_concat, task_delay, task_spawn, task_wait, string_lower, string_match, math_clamp, math_floor, math_min
            = table.insert, table.remove, table.find, table.sort, table.concat, task.delay, task.spawn, task.wait, string.lower, string.match, math.clamp, math.floor, math.min

        local Instance_new, Vector2_new, Vector2_zero, Color3_fromHex, Color3_fromHSV, Color3_fromRGB, UDim2_new, UDim2_fromScale, UDim2_fromOffset, UDim_new
            = Instance.new, Vector2.new, Vector2.zero, Color3.fromHex, Color3.fromHSV, Color3.fromRGB, UDim2.new, UDim2.fromScale, UDim2.fromOffset, UDim.new

        local pcall, randomstring, tostring, tonumber, typeof, select, Enum: typeof(Enum)
            = pcall, randomstring, tostring, tonumber, typeof, select, Enum

        local      Destroy,      GetPropertyChangedSignal
            = game.Destroy, game.GetPropertyChangedSignal

        local Disconnect, Once, Connect, Fire, Wait, ToHSV, Play;do
            local Signal = game.Close
            local Event  = Instance_new("BindableEvent")
            local Tween  = Instance_new("Tween")
            local Color3 = Color3.new()

            Fire = Event .Fire
            Once = Signal.Once
            Wait = Signal.Wait

            ToHSV = Color3.ToHSV
            Play  = Tween .Play

            Connect    = Signal.Connect
            Disconnect = Once(Signal, function() end).Disconnect

            Destroy(Event)
            Destroy(Tween)
        end

        local UserInputService = shared.UserInputService
        local TweenService     = shared.TweenService

        local TweenService_Create = TweenService.Create

        local LocalPlayer = shared.Speaker
        local Mouse = LocalPlayer:GetMouse()

        local Translations = wax.shared.Translations
        local GetTranslation = Translations.GetTranslation
        local PreRender = shared.RunService.PreRender

        local Labels  = {}
        local Buttons = {}
        local Toggles = {}
        local Options = {}

        local Library = (function()
            local rawset
                = rawset

            local Pass  = Enum.ContextActionResult.Pass
            local Sink  = Enum.ContextActionResult.Sink
            local Begin = Enum.UserInputState.Begin
            local High  = Enum.ContextActionPriority.High

            local Library = {
                LocalPlayer = LocalPlayer,
                DevicePlatform = nil,
                IsMobile = false,

                ScreenGui = nil,

                ActiveTab = nil,
                MenuKeyPicker = nil,
                Tabs = {},

                WindowFrames = {},

                KeybindFrame = nil,
                KeybindContainer = nil,
                KeybindToggles = {},

                Notifications = {},

                ToggleKeybind = nil, --/ Must be one keybind (moded)
                Toggle = nil,
                TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

                Toggled  = false,
                Unloaded = false,

                Labels  = Labels,
                Buttons = Buttons,
                Toggles = Toggles,
                Options = Options,

                NotifySide = "TopRight",
                ShowCustomCursor = true,
                ForceCheckbox = false,
                ShowToggleFrameInKeybinds = true,
                NotifyOnError = false,

                CantDragForced = false,

                Signals = {},
                UnloadSignals = {},

                MinSize = Vector2_new(480, 360),
                DPIScale = 1,
                CornerRadius = 4,

                IsLightTheme = false,
                Scheme = {
                    BackgroundColor = Color3_fromRGB(15, 15, 15),
                    MainColor = Color3_fromRGB(25, 25, 25),
                    AccentColor = Color3_fromRGB(125, 85, 255),
                    OutlineColor = Color3_fromRGB(40, 40, 40),
                    FontColor = Color3.new(1, 1, 1),
                    Font = Font.fromEnum(Enum.Font.BuilderSans),

                    Red = Color3_fromRGB(255, 50, 50),
                    Dark = Color3.new(0, 0, 0),
                    White = Color3.new(1, 1, 1),
                },

                Registry = {},
                DPIRegistry = {},
            }

            local Proxy = {
                ToggleKeybind = Enum.KeyCode.RightControl
            }

            local RealToggled = Library.Toggled

            local function Rebind(ToggleKeybind)
                if typeof(ToggleKeybind) ~= "EnumItem" then return end
                Proxy.ToggleKeybind = ToggleKeybind

                --// Context Action for keyboard inputs
                shared.Connect:BindAction(
                    "LibraryToggle",
                    function(_, InputState, InputObject: InputObject)
                        if InputState == Begin and InputObject.KeyCode == ToggleKeybind and not (Library.MenuKeyPicker and Library.MenuKeyPicker.Picking) then
                            RealToggled = not RealToggled

                            pcall(pcall, Library.Toggle, RealToggled)
                            return Sink
                        end

                        return Pass
                    end,
                    false,
                    High,
                    ToggleKeybind
                )
            end 

            Proxy.RebindMenuKey = Rebind

            --// InputBegan for mouse inputs
            shared.Connect:GiveSignal("LibraryToggle", Connect(shared.UserInputService.InputBegan, function(InputObject: InputObject)
                if InputObject.UserInputType == Proxy.ToggleKeybind and not (Library.MenuKeyPicker and Library.MenuKeyPicker.Picking) then
                    RealToggled = not RealToggled
                    pcall(pcall, Library.Toggle, RealToggled)
                end
            end))

            return setmetatable(Library, {
                __index = function(_, Key)
                    return Proxy[Key]
                end,

                __newindex = function(self, Key, Value)
                    if Key == "ToggleKeybind" then Rebind(Value) else rawset(self, Key, Value) end
                end
            })
        end)()

        local IsStudio = shared.RunService:IsStudio()

        if IsStudio then 
            if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
                Library.IsMobile = true
                Library.MinSize = Vector2_new(480, 240)
            else
                Library.IsMobile = false
                Library.MinSize = Vector2_new(480, 360)
            end
        else
            pcall(function()
                Library.DevicePlatform = UserInputService:GetPlatform()
            end)
            Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
            Library.MinSize = Library.IsMobile and Vector2_new(480, 240) or Vector2_new(480, 360)
        end

        local Templates = {
            --// UI \\-
            Frame = {
                BorderSizePixel = 0,
            },
            ImageLabel = {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
            },
            ImageButton = {
                AutoButtonColor = false,
                BorderSizePixel = 0,
            },
            ScrollingFrame = {
                BorderSizePixel = 0,
            },
            TextLabel = {
                BorderSizePixel = 0,
                FontFace = "Font",
                RichText = true,
                TextColor3 = "FontColor",
            },
            TextButton = {
                AutoButtonColor = false,
                BorderSizePixel = 0,
                FontFace = "Font",
                RichText = true,
                TextColor3 = "FontColor",
            },
            TextBox = {
                BorderSizePixel = 0,
                FontFace = "Font",
                PlaceholderColor3 = function()
                    local H, S, V = ToHSV(Library.Scheme.FontColor)
                    return Color3_fromHSV(H, S, V / 2)
                end,
                Text = "",
                TextColor3 = "FontColor",
            },
            UIListLayout = {
                SortOrder = Enum.SortOrder.LayoutOrder,
            },
            UIStroke = {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            },

            --// Library //
            Window = {
                Title = GetTranslation(Translations, "No Title"),
                Footer = GetTranslation(Translations, "No Footer"),
                Position = UDim2_fromScale(0.5, 0.5),
                Size = UDim2_fromOffset(720, 600),
                IconSize = UDim2_fromOffset(30, 30),
                AutoShow = true,
                Center = true,
                Resizable = true,
                CornerRadius = 4,
                NotifySide = "TopRight",
                ShowCustomCursor = true,
                Font = Enum.Font.Code,
                ToggleKeybind = Enum.KeyCode.RightControl,
                MobileButtonsSide = "Left",
                AlwaysOnTop = false,
            },
            Toggle = {
                Text = GetTranslation(Translations, "Toggle"),
                Default = false,

                Callback = function() end,
                Changed = function() end,

                Risky = false,
                Disabled = false,
                Visible = true,
            },
            Input = {
                Text = GetTranslation(Translations, "Input"),
                Default = "",
                Finished = false,
                Numeric = false,
                ClearTextOnFocus = true,
                Placeholder = "",
                AllowEmpty = true,
                EmptyReset = "---",

                Callback = function() end,
                Changed = function() end,

                Disabled = false,
                Visible = true,
            },
            Slider = {
                Text = GetTranslation(Translations, "Slider"),
                Default = 0,
                Min = 0,
                Max = 100,
                Rounding = 0,

                Prefix = "",
                Suffix = "",

                Callback = function() end,
                Changed = function() end,

                Disabled = false,
                Visible = true,
            },
            Dropdown = {
                Values = {},
                DisabledValues = {},
                Multi = false,
                MaxVisibleDropdownItems = 8,

                Callback = function() end,
                Changed = function() end,

                Disabled = false,
                Visible = true,
            },

            --// Addons \\-
            KeyPicker = {
                Text = GetTranslation(Translations, "KeyPicker"),
                Default = GetTranslation(Translations, "None"),
                Mode = "Toggle",
                Modes = { "Always", "Toggle", "Hold" },
                SyncToggleState = false,

                Callback = function() end,
                ChangedCallback = function() end,
                Changed = function() end,
                Clicked = function() end,
            },
            ColorPicker = {
                Default = Color3.new(1, 1, 1),

                Callback = function() end,
                Changed = function() end,
            },
        }

        local Places = {
            Bottom = { 0, 1 },
            Right = { 1, 0 },
        }
        local Sizes = {
            Left = { 0.5, 1 },
            Right = { 0.5, 1 },
        }

        --// Basic Functions //
        local function ApplyDPIScale(Dimension, ExtraOffset)
            if typeof(Dimension) == "UDim" then
                return UDim_new(Dimension.Scale, Dimension.Offset * Library.DPIScale)
            end

            if ExtraOffset then
                return UDim2_new(
                    Dimension.X.Scale,
                    (Dimension.X.Offset * Library.DPIScale) + (ExtraOffset[1] * Library.DPIScale),
                    Dimension.Y.Scale,
                    (Dimension.Y.Offset * Library.DPIScale) + (ExtraOffset[2] * Library.DPIScale)
                )
            end

            return UDim2_new(
                Dimension.X.Scale,
                Dimension.X.Offset * Library.DPIScale,
                Dimension.Y.Scale,
                Dimension.Y.Offset * Library.DPIScale
            )
        end

        local function ApplyTextScale(TextSize)
            return TextSize * Library.DPIScale
        end

        local function WaitForEvent(Event, Timeout, Condition)
            local Bindable = Instance_new("BindableEvent")
            local Connection = Once(Event, function(...)
                if not Condition or typeof(Condition) == "function" and Condition(...) then
                    Fire(Bindable, true)
                else
                    Fire(Bindable, false)
                end
            end)
            task_delay(Timeout, function()
                Disconnect(Connection)
                Fire(Bindable, false)
            end)
            return Wait(Bindable.Event)
        end

        local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
            return (
                Input.UserInputType == Enum.UserInputType.MouseButton1
                    or IncludeM2 and Input.UserInputType == Enum.UserInputType.MouseButton2
                    or Input.UserInputType == Enum.UserInputType.Touch
            ) and Input.UserInputState == Enum.UserInputState.Begin
        end

        local function IsHoverInput(Input: InputObject)
            return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
                and Input.UserInputState == Enum.UserInputState.Change
        end

        local function GetTableSize(Table: { [any]: any })
            local Size = 0

            for _ in Table do
                Size += 1
            end

            return Size
        end

        local function StopTween(Tween: TweenBase)
            if not (Tween and Tween.PlaybackState == Enum.PlaybackState.Playing) then
                return
            end

            Tween:Cancel()
        end

        local function Trim(Text: string)
            return string_match(Text, "^%s*(.-)%s*$")
        end

        local function GetPlayers(ExcludeLocalPlayer: boolean?)
            local PlayerList = shared.Players:GetPlayers()

            if ExcludeLocalPlayer then
                local Idx = table_find(PlayerList, LocalPlayer)
                if Idx then
                    table_remove(PlayerList, Idx)
                end
            end

            table_sort(PlayerList, function(Player1, Player2)
                return string_lower(Player1.Name) < string_lower(Player2.Name)
            end)

            return PlayerList
        end

        local function GetTeams()
            local TeamList = shared.Teams:GetTeams()

            table_sort(TeamList, function(Team1, Team2)
                return string_lower(Team1.Name) < string_lower(Team2.Name)
            end)

            return TeamList
        end

        function Library:UpdateKeybindFrame()
            if not Library.KeybindFrame then
                return
            end

            local XSize = 0
            for _, KeybindToggle in Library.KeybindToggles do
                if not KeybindToggle.Holder.Visible then
                    continue
                end

                local FullSize = KeybindToggle.Label.Size.X.Offset + KeybindToggle.Label.Position.X.Offset
                if FullSize > XSize then
                    XSize = FullSize
                end
            end

            Library.KeybindFrame.Size = UDim2_fromOffset(XSize + 18 * Library.DPIScale, 0)
        end

        function Library:AddToRegistry(Instance, Properties)
            Library.Registry[Instance] = Properties
        end

        function Library:RemoveFromRegistry(Instance)
            Library.Registry[Instance] = nil
        end

        function Library:UpdateColorsUsingRegistry()
            for Instance, Properties in Library.Registry do
                for Property, ColorIdx in Properties do
                    if typeof(ColorIdx) == "string" then
                        Instance[Property] = Library.Scheme[ColorIdx]
                    elseif typeof(ColorIdx) == "function" then
                        Instance[Property] = ColorIdx()
                    end
                end
            end
        end

        function Library:UpdateDPI(Instance, Properties)
            if not Library.DPIRegistry[Instance] then
                return
            end

            for Property, Value in Properties do
                Library.DPIRegistry[Instance][Property] = Value and Value or nil
            end
        end

        function Library:SetDPIScale(DPIScale: number)
            Library.DPIScale = DPIScale / 100
            Library.MinSize *= Library.DPIScale

            for Instance, Properties in Library.DPIRegistry do
                for Property, Value in Properties do
                    if Property == "DPIExclude" or Property == "DPIOffset" then
                        continue
                    elseif Property == "TextSize" then
                        Instance[Property] = ApplyTextScale(Value)
                    else
                        Instance[Property] = ApplyDPIScale(Value, Properties["DPIOffset"][Property])
                    end
                end
            end

            for _, Tab in Library.Tabs do
                if Tab.IsKeyTab then
                    continue
                end

                Tab:Resize(true)
                for _, Groupbox in Tab.Groupboxes do
                    Groupbox:Resize()
                end
                for _, Tabbox in Tab.Tabboxes do
                    for _, SubTab in Tabbox.Tabs do
                        SubTab:Resize()
                    end
                end
            end

            for _, Option in Options do
                if Option.Type == "Dropdown" then
                    Option:RecalculateListSize()
                elseif Option.Type == "KeyPicker" then
                    Option:Update()
                end
            end

            Library:UpdateKeybindFrame()
            for _, Notification in Library.Notifications do
                Notification:Resize()
            end
        end

        function Library:GiveSignal(Connection: RBXScriptConnection)
            table_insert(Library.Signals, Connection)
            return Connection
        end

        do
            local Icons = require("../Lucide")

            function Library:GetIcon(IconName: string)
                local Success, Icon = pcall(Icons.GetAsset, IconName)
                return Success and Icon
            end
        end

        function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
            if typeof(Table) ~= "table" then
                return Template
            end

            for k, v in Template do
                if typeof(v) == "table" then
                    Table[k] = Library:Validate(Table[k], v)
                elseif Table[k] == nil then
                    Table[k] = v
                end
            end

            return Table
        end

        --// Creator Functions //
        local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
            local ThemeProperties = Library.Registry[Instance] or {}
            local DPIProperties = Library.DPIRegistry[Instance] or {}

            local DPIExclude = DPIProperties["DPIExclude"] or Table["DPIExclude"] or {}
            local DPIOffset = DPIProperties["DPIOffset"] or Table["DPIOffset"] or {}

            for k, v in Table do
                if k == "DPIExclude" or k == "DPIOffset" then
                    continue
                elseif ThemeProperties[k] then
                    ThemeProperties[k] = nil
                elseif k ~= "Text" and (Library.Scheme[v] or typeof(v) == "function") then
                    -- me when Red in dropdowns break things (temp fix - or perm idk if deivid will do something about this)
                    ThemeProperties[k] = v
                    Instance[k] = Library.Scheme[v] or v()
                    continue
                end

                if not DPIExclude[k] then
                    if k == "Position" or k == "Size" or string_match(k, "Padding") then
                        DPIProperties[k] = v
                        v = ApplyDPIScale(v, DPIOffset[k])
                    elseif k == "TextSize" then
                        DPIProperties[k] = v
                        v = ApplyTextScale(v)
                    end
                end

                Instance[k] = v
            end

            if GetTableSize(ThemeProperties) > 0 then
                Library.Registry[Instance] = ThemeProperties
            end
            if GetTableSize(DPIProperties) > 0 then
                DPIProperties["DPIExclude"] = DPIExclude
                DPIProperties["DPIOffset"] = DPIOffset
                Library.DPIRegistry[Instance] = DPIProperties
            end
        end

        local function New(ClassName: string, Properties: { [string]: any }): any
            local Instance = Instance_new(ClassName)

            if Templates[ClassName] then
                FillInstance(Templates[ClassName], Instance)
            end
            FillInstance(Properties, Instance)

            if Properties["Parent"] and not Properties["ZIndex"] then
                pcall(function()
                    Instance.ZIndex = Properties.Parent.ZIndex
                end)
            end

            Instance.Name = randomstring()
            return Instance
        end

        --// Main Instances \\-
        local ParentUI;do
            local gethui
                = gethui

            function ParentUI(UI: Instance)
                if not pcall(function()
                    UI.Parent = gethui()
                end) then
                    UI.Parent = Library.LocalPlayer:WaitForChild("PlayerGui")
                end
            end
        end

        local ScreenGui = New("ScreenGui", {
            DisplayOrder = 1e7,
            ResetOnSpawn = false,
        })
        ParentUI(ScreenGui)
        Library.ScreenGui = ScreenGui
        Connect(ScreenGui.DescendantRemoving, function(Instance)
            Library:RemoveFromRegistry(Instance)
            Library.DPIRegistry[Instance] = nil
        end)

        local ModalElement = New("TextButton", {
            BackgroundTransparency = 1,
            Modal = false,
            Size = UDim2_fromScale(0, 0),
            Text = "",
            TextTransparency = 1,
            ZIndex = -999,
            Parent = ScreenGui,
        })

        --// Cursor
        local Cursor
        do
            Cursor = New("Frame", {
                AnchorPoint = Vector2_new(0.5, 0.5),
                BackgroundColor3 = "White",
                Size = UDim2_fromOffset(9, 1),
                Visible = false,
                ZIndex = 999,
                Parent = ScreenGui,
            })
            New("Frame", {
                AnchorPoint = Vector2_new(0.5, 0.5),
                BackgroundColor3 = "Dark",
                Position = UDim2_fromScale(0.5, 0.5),
                Size = UDim2_new(1, 2, 1, 2),
                ZIndex = 998,
                Parent = Cursor,
            })

            local CursorV = New("Frame", {
                AnchorPoint = Vector2_new(0.5, 0.5),
                BackgroundColor3 = "White",
                Position = UDim2_fromScale(0.5, 0.5),
                Size = UDim2_fromOffset(1, 9),
                Parent = Cursor,
            })
            New("Frame", {
                AnchorPoint = Vector2_new(0.5, 0.5),
                BackgroundColor3 = "Dark",
                Position = UDim2_fromScale(0.5, 0.5),
                Size = UDim2_new(1, 2, 1, 2),
                ZIndex = 998,
                Parent = CursorV,
            })
        end

        --// Notification
        local NotificationArea
        local NotificationList
        do
            NotificationArea = New("Frame", {
                AnchorPoint = Vector2_new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2_new(1, -6, 0, 6),
                Size = UDim2_new(0, 300, 1, -6),
                Parent = ScreenGui,
            })
            NotificationList = New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim_new(0, 6),
                Parent = NotificationArea,
            })
        end

        --// Lib Functions //
        function Library:GetBetterColor(Color: Color3, Add: number): Color3
            Add = Add * (Library.IsLightTheme and -4 or 2)
            return Color3_fromRGB(
                math_clamp(Color.R * 255 + Add, 0, 255),
                math_clamp(Color.G * 255 + Add, 0, 255),
                math_clamp(Color.B * 255 + Add, 0, 255)
            )
        end

        function Library:GetDarkerColor(Color: Color3): Color3
            local H, S, V = ToHSV(Color)
            return Color3_fromHSV(H, S, V / 2)
        end

        do
            local Font_fromEnum
                = Font.fromEnum

            local TextService = shared.TextService

            local TextService_GetTextBoundsAsync = TextService.GetTextBoundsAsync

            function Library:FixFont(Font: (EnumItem | Font)?): Font | any
                if typeof(Font) == "EnumItem" then
                    return Font_fromEnum(Font)
                end

                return Font
            end

            function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
                local Params = Instance_new("GetTextBoundsParams")
                Params.Text = Text
                Params.RichText = true
                Params.Font = Library:FixFont(Font)
                Params.Size = Size
                Params.Width = Width or shared.Camera.ViewportSize.X - 32

                local Bounds = TextService_GetTextBoundsAsync(TextService, Params)
                return Bounds.X, Bounds.Y
            end
        end

        function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
            local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
            return Mouse.X >= AbsPos.X
                and Mouse.X <= AbsPos.X + AbsSize.X
                and Mouse.Y >= AbsPos.Y
                and Mouse.Y <= AbsPos.Y + AbsSize.Y
        end

        do
            local coroutine_create, coroutine_resume, coroutine_close, string_gsub, math_ceil, TweenInfo_new
                = coroutine.create, coroutine.resume, coroutine.close, string.gsub, math.ceil, TweenInfo.new

            function Library:Notify(...)
                local Data = {}
                local Info = select(1, ...)

                if typeof(Info) == "table" then
                    Data.Title = tostring(Info.Title)
                    Data.Description = tostring(Info.Description)
                    Data.Time = Info.Time or 5
                    Data.SoundId = Info.SoundId
                    Data.Steps = Info.Steps
                else
                    Data.Description = tostring(Info)
                    Data.Time = select(2, ...) or 5
                    Data.SoundId = select(3, ...)
                end

                local FakeBackground = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2_fromScale(1, 0),
                    Visible = false,
                    Parent = NotificationArea,

                    DPIExclude = {
                        Size = true,
                    },
                })

                local NotifyDirection = string_lower(Library.NotifySide)
                local IsLeft = string_match(NotifyDirection, "left")
                local IsBottom = string_match(NotifyDirection, "bottom")

                local Background: Frame = Library:MakeOutline(FakeBackground, Library.CornerRadius, 5)
                Background.AutomaticSize = Enum.AutomaticSize.Y
                Background.Position = IsLeft and UDim2_new(-1, -6, IsBottom and 1 or 0, -2) or UDim2_new(1, 6, IsBottom and 1 or 0, -2)
                Background.Size = UDim2_fromScale(1, 0)
                Library:UpdateDPI(Background, {
                    Position = false,
                    Size = false,
                })

                local Holder = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    Position = UDim2_fromOffset(2, 2),
                    Size = UDim2_new(1, -4, 1, -4),
                    Parent = Background,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(0, Library.CornerRadius - 1),
                    Parent = Holder,
                })
                New("UIListLayout", {
                    Padding = UDim_new(0, 4),
                    Parent = Holder,
                })
                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 8),
                    PaddingLeft = UDim_new(0, 8),
                    PaddingRight = UDim_new(0, 8),
                    PaddingTop = UDim_new(0, 8),
                    Parent = Holder,
                })

                local Title
                local Desc
                local TitleX = 0
                local DescX = 0

                local TimerFill

                if Data.Title then
                    Title = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = Data.Title,
                        TextSize = 15,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        Parent = Holder,

                        DPIExclude = {
                            Size = true,
                        },
                    })
                end
                if Data.Description then
                    Desc = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = Data.Description,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        Parent = Holder,

                        DPIExclude = {
                            Size = true,
                        },
                    })
                end

                function Data:Resize()
                    if Title then
                        local X, Y = Library:GetTextBounds(
                            Title.Text,
                            Title.FontFace,
                            Title.TextSize,
                            NotificationArea.AbsoluteSize.X - (24 * Library.DPIScale)
                        )
                        Title.Size = UDim2_fromOffset(math_ceil(X), Y)
                        TitleX = X
                    end

                    if Desc then
                        local X, Y = Library:GetTextBounds(
                            Desc.Text,
                            Desc.FontFace,
                            Desc.TextSize,
                            NotificationArea.AbsoluteSize.X - (24 * Library.DPIScale)
                        )
                        Desc.Size = UDim2_fromOffset(math_ceil(X), Y)
                        DescX = X
                    end

                    FakeBackground.Size = UDim2_fromOffset((TitleX > DescX and TitleX or DescX) + (24 * Library.DPIScale), 0)
                end

                function Data:ChangeTitle(NewText)
                    if Title then
                        Data.Title = tostring(NewText)
                        Title.Text = Data.Title
                        Data:Resize()
                    end
                end

                function Data:ChangeDescription(NewText)
                    if Desc then
                        Data.Description = tostring(NewText)
                        Desc.Text = Data.Description
                        Data:Resize()
                    end
                end

                function Data:ChangeStep(NewStep)
                    if TimerFill and Data.Steps then
                        NewStep = math_clamp(NewStep or 0, 0, Data.Steps)
                        TimerFill.Size = UDim2_fromScale(NewStep / Data.Steps, 1)
                    end
                end

                Data:Resize()

                local TimerHolder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 7),
                    Visible = typeof(Data.Time) ~= "Instance" or typeof(Data.Steps) == "number",
                    Parent = Holder,
                })
                local TimerBar = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2_fromOffset(0, 3),
                    Size = UDim2_new(1, 0, 0, 2),
                    Parent = TimerHolder,
                })
                TimerFill = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    Size = UDim2_fromScale(1, 1),
                    Parent = TimerBar,
                })

                if typeof(Data.Time) == "Instance" then
                    TimerFill.Size = UDim2_fromScale(0, 1)
                end
                if Data.SoundId then
                    Destroy(New("Sound", {
                        SoundId = "rbxassetid://" .. string_gsub(tostring(Data.SoundId), "rbxassetid://", ""),
                        Volume = 3,
                        PlayOnRemove = true,
                        Parent = shared.SoundService,
                    }))
                end

                Library.Notifications[FakeBackground] = Data

                FakeBackground.Visible = true

                local ShowPosition = IsLeft and UDim2_new(0, -2, IsBottom and 1 or 0, -2) or UDim2_new(1, -2, IsBottom and 1 or 0, -2)
                local Tween: Tween = TweenService_Create(TweenService, Background, Library.NotifyTweenInfo, {
                    Position = ShowPosition,
                })
                Play(Tween)

                local Finished = false
                local Connection: RBXScriptConnection
                local Thread: thread

                local function OnFinihied()
                    if Finished then return end
                    Finished = true

                    StopTween(Tween)
                    pcall(coroutine_close, Thread)
                    pcall(Disconnect, Connection)

                    Play(TweenService_Create(TweenService, Background, Library.NotifyTweenInfo, {
                        Position = IsLeft and UDim2_new(-1, -6, IsBottom and 1 or 0, -2) or UDim2_new(1, 6, IsBottom and 1 or 0, -2),
                    }))
                    task_delay(Library.NotifyTweenInfo.Time, function()
                        Library.Notifications[FakeBackground] = Destroy(FakeBackground)
                    end)
                end

                Connection = Library:GiveSignal(Connect(Background.InputBegan, function(InputObject: InputObject)
                    if InputObject.UserInputType == Enum.UserInputType.MouseButton1 or InputObject.UserInputType == Enum.UserInputType.Touch then
                        OnFinihied()
                    end
                end))

                Thread = coroutine_create(function()
                    task_wait(Library.NotifyTweenInfo.Time)

                    if typeof(Data.Time) == "Instance" then
                        Wait(Data.Time.Destroying)
                    else
                        Play(TweenService_Create(TweenService, TimerFill, TweenInfo_new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            Size = UDim2_fromScale(0, 1),
                        }))
                        task_wait(Data.Time)
                    end

                    task_spawn(OnFinihied)
                end)

                coroutine_resume(Thread)
                return Data
            end
        end

        do
            local error, xpcall, string_find, debug_traceback, string_gsub, string_sub, task_defer
                = error, xpcall, string.find, debug.traceback, string.gsub, string.sub, task.defer

            function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
                if not (Func and typeof(Func) == "function") then
                    return
                end

                local Success, Response = xpcall(Func, function(Error)
                    local Traceback = string_gsub(debug_traceback(), "\n", " ")
                    local _, i = string_find(Traceback":%d+ ")
                    Traceback = string_gsub(string_sub(Traceback, i + 1), " :", ":")

                    task_defer(error, Error .. " - " .. Traceback)
                    if Library.NotifyOnError then
                        Library:Notify(Error)
                    end
                end, ...)

                return if Success then Response else nil
            end
        end

        function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
            local StartPos
            local FramePos
            local Dragging = false
            local Changed
            Connect(DragFrame.InputBegan, function(Input: InputObject)
                if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
                    return
                end

                StartPos = Input.Position
                FramePos = UI.Position
                Dragging = true

                Changed = Connect(Input.Changed, function()
                    if Input.UserInputState ~= Enum.UserInputState.End then
                        return
                    end

                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed = Disconnect(Changed)
                    end
                end)
            end)
            Library:GiveSignal(Connect(UserInputService.InputChanged, function(Input: InputObject)
                if
                    (not IgnoreToggled and not Library.Toggled)
                    or (IsMainWindow and Library.CantDragForced)
                    or not (ScreenGui and ScreenGui.Parent)
                then
                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed = Disconnect(Changed)
                    end

                    return
                end

                if Dragging and IsHoverInput(Input) then
                    local Delta = Input.Position - StartPos
                    UI.Position =
                        UDim2_new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
                end
            end))
        end

        function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
            local StartPos
            local FrameSize
            local Dragging = false
            local Changed
            local Inf = (1 / 0)

            Connect(DragFrame.InputBegan, function(Input: InputObject)
                if not IsClickInput(Input) then
                    return
                end

                StartPos = Input.Position
                FrameSize = UI.Size
                Dragging = true

                Changed = Connect(Input.Changed, function()
                    if Input.UserInputState ~= Enum.UserInputState.End then
                        return
                    end

                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed = Disconnect(Changed)
                    end
                end)
            end)
            Library:GiveSignal(Connect(UserInputService.InputChanged, function(Input: InputObject)
                if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
                    Dragging = false
                    if Changed and Changed.Connected then
                        Changed = Disconnect(Changed)
                    end

                    return
                end

                if Dragging and IsHoverInput(Input) then
                    local Delta = Input.Position - StartPos
                    UI.Size = UDim2_new(
                        FrameSize.X.Scale,
                        math_clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, Inf),
                        FrameSize.Y.Scale,
                        math_clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, Inf)
                    )
                    if Callback then
                        Library:SafeCallback(Callback)
                    end
                end
            end))
        end

        function Library:MakeCover(Holder: GuiObject, Place: string)
            local Pos = Places[Place] or { 0, 0 }
            local Size = Sizes[Place] or { 1, 0.5 }

            local Cover = New("Frame", {
                AnchorPoint = Vector2_new(Pos[1], Pos[2]),
                BackgroundColor3 = Holder.BackgroundColor3,
                Position = UDim2_fromScale(Pos[1], Pos[2]),
                Size = UDim2_fromScale(Size[1], Size[2]),
                Parent = Holder,
            })

            return Cover
        end

        function Library:MakeLine(Frame: GuiObject, Info)
            local Line = New("Frame", {
                AnchorPoint = Info.AnchorPoint or Vector2_zero,
                BackgroundColor3 = "OutlineColor",
                Position = Info.Position,
                Size = Info.Size,
                Parent = Frame,
            })

            return Line
        end

        function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
            local Holder = New("Frame", {
                BackgroundColor3 = "Dark",
                Position = UDim2_fromOffset(-2, -2),
                Size = UDim2_new(1, 4, 1, 4),
                ZIndex = ZIndex,
                Parent = Frame,
            })

            local Outline = New("Frame", {
                BackgroundColor3 = "OutlineColor",
                Position = UDim2_fromOffset(1, 1),
                Size = UDim2_new(1, -2, 1, -2),
                ZIndex = ZIndex,
                Parent = Holder,
            })

            if Corner and Corner > 0 then
                New("UICorner", {
                    CornerRadius = UDim_new(0, Corner + 1),
                    Parent = Holder,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(0, Corner),
                    Parent = Outline,
                })
            end

            return Holder
        end

        function Library:AddDraggableButton(Text: string, Func)
            local Table = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2_fromOffset(6, 6),
                TextSize = 16,
                ZIndex = 10,
                Parent = ScreenGui,

                DPIExclude = {
                    Position = true,
                },
            })
            New("UICorner", {
                CornerRadius = UDim_new(0, Library.CornerRadius - 1),
                Parent = Button,
            })
            Library:MakeOutline(Button, Library.CornerRadius, 9)

            Table.Button = Button
            Connect(Button.MouseButton1Click, function()
                Library:SafeCallback(Func, Table)
            end)
            Library:MakeDraggable(Button, Button, true)

            function Table:SetText(NewText: string)
                local X, Y = Library:GetTextBounds(NewText, Library.Scheme.Font, 16)

                Button.Text = NewText
                Button.Size = UDim2_fromOffset(X * Library.DPIScale * 2, Y * Library.DPIScale * 2)
                Library:UpdateDPI(Button, {
                    Size = UDim2_fromOffset(X * 2, Y * 2),
                })
            end
            Table:SetText(Text)

            return Table
        end

        function Library:AddDraggableMenu(Name: string)
            local Background = Library:MakeOutline(ScreenGui, Library.CornerRadius, 10)
            Background.AutomaticSize = Enum.AutomaticSize.Y
            Background.Position = UDim2_fromOffset(6, 6)
            Background.Size = UDim2_fromOffset(0, 0)
            Library:UpdateDPI(Background, {
                Position = false,
                Size = false,
            })

            local Holder = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2_fromOffset(2, 2),
                Size = UDim2_new(1, -4, 1, -4),
                Parent = Background,
            })
            New("UICorner", {
                CornerRadius = UDim_new(0, Library.CornerRadius - 1),
                Parent = Holder,
            })
            Library:MakeLine(Holder, {
                Position = UDim2_fromOffset(0, 34),
                Size = UDim2_new(1, 0, 0, 1),
            })

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2_new(1, 0, 0, 34),
                Text = Name,
                TextSize = 15,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim_new(0, 12),
                PaddingRight = UDim_new(0, 12),
                Parent = Label,
            })

            local Container = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2_fromOffset(0, 35),
                Size = UDim2_new(1, 0, 1, -35),
                Parent = Holder,
            })
            New("UIListLayout", {
                Padding = UDim_new(0, 7),
                Parent = Container,
            })
            New("UIPadding", {
                PaddingBottom = UDim_new(0, 7),
                PaddingLeft = UDim_new(0, 7),
                PaddingRight = UDim_new(0, 7),
                PaddingTop = UDim_new(0, 7),
                Parent = Container,
            })

            Library:MakeDraggable(Background, Label, true)
            return Background, Container
        end

        --// Context Menu //
        local CurrentMenu
        function Library:AddContextMenu(
            Holder: GuiObject,
            Size: any, --UDim2 | () -> (),
            Offset: any, --{ [number]: number } | () -> {},
            List: number?,
            ActiveCallback: any --(Active: boolean) -> ()?
        )
            local Menu
            if List then
                Menu = New("ScrollingFrame", {
                    AutomaticCanvasSize = List == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                    AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
                    BackgroundColor3 = "BackgroundColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                    CanvasSize = UDim2_fromOffset(0, 0),
                    ScrollBarImageColor3 = "OutlineColor",
                    ScrollBarThickness = List == 2 and 2 or 0,
                    Size = if typeof(Size) == "function" then Size() else Size,
                    TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                    Visible = false,
                    ZIndex = 10,
                    Parent = ScreenGui,

                    DPIExclude = {
                        Position = true,
                    },
                })
            else
                Menu = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Size = typeof(Size) == "function" and Size() or Size,
                    Visible = false,
                    ZIndex = 10,
                    Parent = ScreenGui,

                    DPIExclude = {
                        Position = true,
                    },
                })
            end

            local Table = {
                Active = false,
                Holder = Holder,
                Menu = Menu,
                List = nil,
                Signal = nil,

                Size = Size,
            }

            if List then
                Table.List = New("UIListLayout", {
                    Parent = Menu,
                })
            end

            function Table:Open()
                if CurrentMenu == Table then
                    return
                elseif CurrentMenu then
                    CurrentMenu:Close()
                end

                CurrentMenu = Table
                Table.Active = true

                if typeof(Offset) == "function" then
                    Menu.Position = UDim2_fromOffset(
                        math_floor(Holder.AbsolutePosition.X + Offset()[1]),
                        math_floor(Holder.AbsolutePosition.Y + Offset()[2])
                    )
                else
                    Menu.Position = UDim2_fromOffset(
                        math_floor(Holder.AbsolutePosition.X + Offset[1]),
                        math_floor(Holder.AbsolutePosition.Y + Offset[2])
                    )
                end
                if typeof(Table.Size) == "function" then
                    Menu.Size = Table.Size()
                else
                    Menu.Size = ApplyDPIScale(Table.Size)
                end
                if typeof(ActiveCallback) == "function" then
                    Library:SafeCallback(ActiveCallback, true)
                end

                Menu.Visible = true

                Table.Signal = Connect(GetPropertyChangedSignal(Holder, "AbsolutePosition"), function()
                    if typeof(Offset) == "function" then
                        Menu.Position = UDim2_fromOffset(
                            math_floor(Holder.AbsolutePosition.X + Offset()[1]),
                            math_floor(Holder.AbsolutePosition.Y + Offset()[2])
                        )
                    else
                        Menu.Position = UDim2_fromOffset(
                            math_floor(Holder.AbsolutePosition.X + Offset[1]),
                            math_floor(Holder.AbsolutePosition.Y + Offset[2])
                        )
                    end
                end)
            end

            function Table:Close()
                if CurrentMenu ~= Table then
                    return
                end
                Menu.Visible = false

                if Table.Signal then
                    Table.Signal = Disconnect(Table.Signal)
                end
                Table.Active = false
                CurrentMenu = nil
                if typeof(ActiveCallback) == "function" then
                    Library:SafeCallback(ActiveCallback, false)
                end
            end

            function Table:Toggle()
                if Table.Active then
                    Table:Close()
                else
                    Table:Open()
                end
            end

            function Table:SetSize(Size)
                Table.Size = Size
                Menu.Size = typeof(Size) == "function" and Size() or Size
            end

            return Table
        end

        Library:GiveSignal(Connect(UserInputService.InputBegan, function(Input: InputObject)
            if IsClickInput(Input, true) then
                local Location = Input.Position

                if
                    CurrentMenu
                    and not (
                        Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                            or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
                    )
                then
                    CurrentMenu:Close()
                end
            end
        end))

        --// Tooltip //
        local TooltipLabel = New("TextLabel", {
            BackgroundColor3 = "BackgroundColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            TextSize = 14,
            TextWrapped = true,
            Visible = false,
            ZIndex = 20,
            Parent = ScreenGui,
        });do
            local function UpdateLabel()
                local X, Y = Library:GetTextBounds(
                    TooltipLabel.Text,
                    TooltipLabel.FontFace,
                    TooltipLabel.TextSize,
                    shared.Camera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 4
                )

                TooltipLabel.Size = UDim2_fromOffset(X + 8 * Library.DPIScale, Y + 4 * Library.DPIScale)
                Library:UpdateDPI(TooltipLabel, {
                    Size = UDim2_fromOffset(X, Y),
                    DPIOffset = {
                        Size = { 8, 4 },
                    },
                })
            end

            Connect(GetPropertyChangedSignal(TooltipLabel, "AbsolutePosition"), UpdateLabel)

            local CurrentHoverInstance

            function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
                local TooltipTable = {
                    Disabled = false,
                    Hovering = false,
                    Signals = {},
                }

                local function DoHover()
                    if
                        CurrentHoverInstance == HoverInstance
                        or (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
                        or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
                        or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
                    then
                        return
                    end
                    CurrentHoverInstance = HoverInstance

                    TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
                    TooltipLabel.Visible = true

                    while
                        Library.Toggled
                        and Library:MouseIsOverFrame(HoverInstance, Mouse)
                        and not (CurrentMenu and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse))
                    do
                        TooltipLabel.Position = UDim2_fromOffset(
                            Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                            Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
                        )

                        Wait(PreRender)
                    end

                    TooltipLabel.Visible = false
                    CurrentHoverInstance = nil
                end

                table_insert(TooltipTable.Signals, Connect(HoverInstance.MouseEnter, DoHover))
                table_insert(TooltipTable.Signals, Connect(HoverInstance.MouseMoved, DoHover))
                table_insert(
                    TooltipTable.Signals, Connect(
                        HoverInstance.MouseLeave,
                        function()
                            if CurrentHoverInstance ~= HoverInstance then
                                return
                            end

                            TooltipLabel.Visible = false
                            CurrentHoverInstance = nil
                        end
                    )
                )

                function TooltipTable:Update()
                    Wait(PreRender)
                    task_spawn(UpdateLabel)
                end

                function TooltipTable:Destroy()
                    for Index = #TooltipTable.Signals, 1, -1 do
                        local Connection = table_remove(TooltipTable.Signals, Index)
                        Disconnect(Connection)
                    end

                    if CurrentHoverInstance == HoverInstance then
                        TooltipLabel.Visible = false
                        CurrentHoverInstance = nil
                    end
                end

                return TooltipTable
            end
        end

        function Library:OnUnload(Callback)
            table_insert(Library.UnloadSignals, Callback)
        end

        function Library:Unload()
            for Index = #Library.Signals, 1, -1 do
                local Connection = table_remove(Library.Signals, Index)
                Disconnect(Connection)
            end

            for _, Callback in Library.UnloadSignals do
                Library:SafeCallback(Callback)
            end

            Library.Unloaded = true
            Destroy(ScreenGui)
        end

        local CheckIcon = Library:GetIcon("check")
        local ArrowIcon = Library:GetIcon("chevron-up")
        local ResizeIcon = Library:GetIcon("move-diagonal-2")
        local KeyIcon = Library:GetIcon("key")

        local BaseAddons = {}
        do
            local string_format 
                = string.format

            local Funcs = {}

            function Funcs:AddKeyPicker(Idx, Info)
                Info = Library:Validate(Info, Templates.KeyPicker)

                local ParentObj = self
                local ToggleLabel = ParentObj.TextLabel

                local KeyPicker = {
                    Text = Info.Text,
                    Value = Info.Default,
                    Toggled = false,
                    Mode = Info.Mode,
                    SyncToggleState = Info.SyncToggleState,

                    Callback = Info.Callback,
                    ChangedCallback = Info.ChangedCallback,
                    Changed = Info.Changed,
                    Clicked = Info.Clicked,

                    Type = "KeyPicker",
                    Picking = false
                }

                if Info.IsMenuKeyPicker then
                    Library.MenuKeyPicker = KeyPicker
                end

                if KeyPicker.SyncToggleState then
                    Info.Modes = { "Toggle" }
                    Info.Mode = "Toggle"
                end

                local Picker = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Size = UDim2_fromOffset(18, 18),
                    Text = KeyPicker.Value,
                    TextSize = 14,
                    Parent = ToggleLabel,
                })

                local AntiMove: TextBox = New("TextBox", {
                    Active = false,
                    Text = "",
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    Size = UDim2_fromScale(1, 1),
                    ClearTextOnFocus = true,
                    Parent = Picker,
                    ZIndex = -999
                })

                Connect(GetPropertyChangedSignal(AntiMove, "Text"), function()
                    AntiMove.Text = ""
                end)

                Connect(AntiMove.Focused, function()
                    if KeyPicker.Picking ~= true then
                        AntiMove:ReleaseFocus()
                    end
                end)

                Connect(AntiMove.FocusLost, function()
                    if KeyPicker.Picking == true then
                        AntiMove:CaptureFocus()
                    end
                end)

                local KeybindsToggle = {
                    Normal = KeyPicker.Mode ~= "Toggle",
                }

                do
                    local Holder = New("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 16),
                        Text = "",
                        Visible = not Info.NoUI,
                        Parent = Library.KeybindContainer,
                    })

                    local Label = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2_fromScale(1, 1),
                        Text = "",
                        TextSize = 14,
                        TextTransparency = 0.5,
                        Parent = Holder,

                        DPIExclude = {
                            Size = true,
                        },
                    })

                    local Checkbox = New("Frame", {
                        BackgroundColor3 = "MainColor",
                        Size = UDim2_fromOffset(14, 14),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Parent = Holder,
                    })
                    New("UICorner", {
                        CornerRadius = UDim_new(0, Library.CornerRadius / 2),
                        Parent = Checkbox,
                    })
                    New("UIStroke", {
                        Color = "OutlineColor",
                        Parent = Checkbox,
                    })

                    local CheckImage = New("ImageLabel", {
                        Image = CheckIcon and CheckIcon.Url or "",
                        ImageColor3 = "FontColor",
                        ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2_zero,
                        ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2_zero,
                        ImageTransparency = 1,
                        Position = UDim2_fromOffset(2, 2),
                        Size = UDim2_new(1, -4, 1, -4),
                        Parent = Checkbox,
                    })

                    function KeybindsToggle:Display(State)
                        Label.TextTransparency = State and 0 or 0.5
                        CheckImage.ImageTransparency = State and 0 or 1
                    end

                    function KeybindsToggle:SetText(Text)
                        local X = Library:GetTextBounds(Text, Label.FontFace, Label.TextSize)
                        Label.Text = Text
                        Label.Size = UDim2_new(0, X, 1, 0)
                    end

                    function KeybindsToggle:SetVisibility(Visibility)
                        Holder.Visible = Visibility
                    end

                    function KeybindsToggle:SetNormal(Normal)
                        KeybindsToggle.Normal = Normal

                        Holder.Active = not Normal
                        Label.Position = Normal and UDim2_fromOffset(0, 0) or UDim2_fromOffset(22 * Library.DPIScale, 0)
                        Checkbox.Visible = not Normal
                    end

                    function KeyPicker:DoClick()
                        if ParentObj.Type == "Toggle" and KeyPicker.SyncToggleState then
                            ParentObj:SetValue(KeyPicker.Toggled)
                        end

                        Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
                        Library:SafeCallback(KeyPicker.Changed, KeyPicker.Toggled)
                    end

                    Connect(Holder.MouseButton1Click, function()
                        if KeybindsToggle.Normal then
                            return
                        end

                        KeyPicker.Toggled = not KeyPicker.Toggled
                        KeyPicker:DoClick()
                    end)

                    KeybindsToggle.Holder = Holder
                    KeybindsToggle.Label = Label
                    KeybindsToggle.Checkbox = Checkbox
                    KeybindsToggle.Loaded = true
                    table_insert(Library.KeybindToggles, KeybindsToggle)
                end

                local MenuTable = Library:AddContextMenu(Picker, UDim2_fromOffset(62, 0), function()
                    return { Picker.AbsoluteSize.X + 1.5, 0.5 }
                end, 1)
                KeyPicker.Menu = MenuTable

                local ModeButtons = {}
                for _, Mode in Info.Modes do
                    local ModeButton = {}

                    local Button = New("TextButton", {
                        BackgroundColor3 = "MainColor",
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 21),
                        Text = Mode,
                        TextSize = 14,
                        TextTransparency = 0.5,
                        Parent = MenuTable.Menu,
                    })

                    function ModeButton:Select()
                        for _, Button in ModeButtons do
                            Button:Deselect()
                        end

                        KeyPicker.Mode = Mode

                        Button.BackgroundTransparency = 0
                        Button.TextTransparency = 0

                        MenuTable:Close()
                    end

                    function ModeButton:Deselect()
                        KeyPicker.Mode = nil

                        Button.BackgroundTransparency = 1
                        Button.TextTransparency = 0.5
                    end

                    Connect(Button.MouseButton1Click, function()
                        ModeButton:Select()
                    end)

                    if KeyPicker.Mode == Mode then
                        ModeButton:Select()
                    end

                    ModeButtons[Mode] = ModeButton
                end

                function KeyPicker:Display()
                    if Library.Unloaded or KeyPicker.Picking then 
                        return 
                    end

                    local X, Y =
                        Library:GetTextBounds(KeyPicker.Value, Picker.FontFace, Picker.TextSize, ToggleLabel.AbsoluteSize.X)
                    Picker.Text = KeyPicker.Value
                    Picker.Size = UDim2_fromOffset(X + 9 * Library.DPIScale, Y + 4 * Library.DPIScale)
                end

                function KeyPicker:Update()
                    KeyPicker:Display()

                    if Info.NoUI then
                        return
                    end

                    if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                        KeybindsToggle:SetVisibility(false)
                        return
                    end

                    local State = KeyPicker:GetState()
                    local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

                    if KeybindsToggle.Loaded then
                        if ShowToggle then
                            KeybindsToggle:SetNormal(false)
                        else
                            KeybindsToggle:SetNormal(true)
                        end

                        KeybindsToggle:SetText(string_format("[%s] %s (%s)", KeyPicker.Value, KeyPicker.Text, GetTranslation(Translations, KeyPicker.Mode)))
                        KeybindsToggle:SetVisibility(true)
                        KeybindsToggle:Display(State)
                    end

                    Library:UpdateKeybindFrame()
                end

                function KeyPicker:GetState()
                    if KeyPicker.Mode == "Always" then
                        return true
                    elseif KeyPicker.Mode == "Hold" then
                        local Key = KeyPicker.Value
                        if Key == GetTranslation(Translations, "None") then
                            return false
                        end

                        if Key == GetTranslation(Translations, "MB1") or Key == GetTranslation(Translations, "MB2") or Key == GetTranslation(Translations, "MB3") then
                            return Key == GetTranslation(Translations, "MB1") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                                or Key == GetTranslation(Translations, "MB2") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                                or Key == GetTranslation(Translations, "MB3") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
                        end

                        return UserInputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value])
                            and not UserInputService:GetFocusedTextBox()
                    else
                        return KeyPicker.Toggled
                    end
                end

                function KeyPicker:OnChanged(Func)
                    KeyPicker.Changed = Func
                end

                function KeyPicker:OnClick(Func)
                    KeyPicker.Clicked = Func
                end

                function KeyPicker:SetValue(Data)
                    local Key, Mode = Data[1], Data[2]

                    KeyPicker.Value = Key
                    if ModeButtons[Mode] then
                        ModeButtons[Mode]:Select()
                    end

                    KeyPicker:Update()
                end

                function KeyPicker:SetText(Text)
                    KeybindsToggle:SetText(Text)
                    KeyPicker:Update()
                end

                Connect(Picker.MouseButton1Click, function()
                    if KeyPicker.Picking then
                        return
                    end

                    KeyPicker.Picking = true
                    AntiMove:CaptureFocus()

                    Picker.Text = "..."
                    Picker.Size = UDim2_fromOffset(29 * Library.DPIScale, 18 * Library.DPIScale)

                    local Input = Wait(UserInputService.InputBegan)
                    local Key = GetTranslation(Translations, "Unknown")

                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = Input.KeyCode == Enum.KeyCode.Escape and GetTranslation(Translations, "None") or Input.KeyCode.Name
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Key = GetTranslation(Translations, "MB1")
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Key = GetTranslation(Translations, "MB2")
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton3 then
                        Key = GetTranslation(Translations, "MB3")
                    end

                    KeyPicker.Value = Key

                    Library:SafeCallback(
                        KeyPicker.ChangedCallback,
                        Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
                    )
                    Library:SafeCallback(
                        KeyPicker.Changed,
                        Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
                    )

                    Wait(PreRender)
                    KeyPicker.Picking = false
                    AntiMove:ReleaseFocus()

                    KeyPicker:Update()
                end)
                Connect(Picker.MouseButton2Click, MenuTable.Toggle)

                do
                    local function CheckInput(Input, CheckAlways)
                        return (
                            CheckAlways and KeyPicker.Mode == "Always"
                            or KeyPicker.Value == GetTranslation(Translations, "Unknown")
                            or KeyPicker.Value == GetTranslation(Translations, "None")
                            or KeyPicker.Picking
                            or UserInputService:GetFocusedTextBox()
                        )
                    end

                    Library:GiveSignal(Connect(UserInputService.InputBegan, function(Input: InputObject)
                        if CheckInput(Input, true) then
                            return
                        end

                        if KeyPicker.Mode == "Toggle" then
                            local Key = KeyPicker.Value

                            if Key == GetTranslation(Translations, "MB1") or Key == GetTranslation(Translations, "MB2") or Key == GetTranslation(Translations, "MB3") then
                                if
                                    Key == GetTranslation(Translations, "MB1") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                                    or Key == GetTranslation(Translations, "MB2") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                                    or Key == GetTranslation(Translations, "MB3") and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
                                then
                                    KeyPicker.Toggled = not KeyPicker.Toggled
                                    KeyPicker:DoClick()
                                end
                            elseif Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key then
                                KeyPicker.Toggled = not KeyPicker.Toggled
                                KeyPicker:DoClick()
                            end
                        end

                        KeyPicker:Update()
                    end))

                    Library:GiveSignal(Connect(UserInputService.InputEnded, function(Input)
                        if CheckInput(Input) then
                            return
                        end

                        KeyPicker:Update()
                    end))
                end

                KeyPicker:Update()

                if ParentObj.Addons then
                    table_insert(ParentObj.Addons, KeyPicker)
                end

                Options[Idx] = KeyPicker

                return self
            end

            local HueSequenceTable = {}
            for Hue = 0, 1, 0.1 do
                table_insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3_fromHSV(Hue, 1, 1)))
            end
            function Funcs:AddColorPicker(Idx, Info)
                Info = Library:Validate(Info, Templates.ColorPicker)

                local ParentObj = self
                local ToggleLabel = ParentObj.TextLabel

                local ColorPicker = {
                    Value = Info.Default,
                    Transparency = Info.Transparency or 0,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Type = "ColorPicker",
                }
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ToHSV(ColorPicker.Value)

                local Holder = New("TextButton", {
                    BackgroundColor3 = ColorPicker.Value,
                    BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
                    BorderSizePixel = 1,
                    Size = UDim2_fromOffset(18, 18),
                    Text = "",
                    Parent = ToggleLabel,
                })

                local HolderTransparency = New("ImageLabel", {
                    Image = "rbxassetid://139785960036434",
                    ImageTransparency = (1 - ColorPicker.Transparency),
                    ScaleType = Enum.ScaleType.Tile,
                    Size = UDim2_fromScale(1, 1),
                    TileSize = UDim2_fromOffset(9, 9),
                    Parent = Holder,
                })

                --// Color Menu //
                local ColorMenu = Library:AddContextMenu(
                    Holder,
                    UDim2_fromOffset(Info.Transparency and 256 or 234, 0),
                    function()
                        return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
                    end,
                    1
                )
                ColorMenu.List.Padding = UDim_new(0, 8)
                ColorPicker.ColorMenu = ColorMenu

                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 6),
                    PaddingLeft = UDim_new(0, 6),
                    PaddingRight = UDim_new(0, 6),
                    PaddingTop = UDim_new(0, 6),
                    Parent = ColorMenu.Menu,
                })

                if typeof(Info.Title) == "string" then
                    New("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 8),
                        Text = Info.Title,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = ColorMenu.Menu,
                    })
                end

                local ColorHolder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 200),
                    Parent = ColorMenu.Menu,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim_new(0, 6),
                    Parent = ColorHolder,
                })

                --// Sat Map
                local SatVipMap = New("ImageButton", {
                    BackgroundColor3 = ColorPicker.Value,
                    Image = "rbxassetid://4155801252",
                    Size = UDim2_fromOffset(200, 200),
                    Parent = ColorHolder,
                })

                local SatVibCursor = New("Frame", {
                    AnchorPoint = Vector2_new(0.5, 0.5),
                    BackgroundColor3 = "White",
                    Size = UDim2_fromOffset(6, 6),
                    Parent = SatVipMap,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(1, 0),
                    Parent = SatVibCursor,
                })
                New("UIStroke", {
                    Color = "Dark",
                    Parent = SatVibCursor,
                })

                --// Hue
                local HueSelector = New("TextButton", {
                    Size = UDim2_fromOffset(16, 200),
                    Text = "",
                    Parent = ColorHolder,
                })
                New("UIGradient", {
                    Color = ColorSequence.new(HueSequenceTable),
                    Rotation = 90,
                    Parent = HueSelector,
                })

                local HueCursor = New("Frame", {
                    AnchorPoint = Vector2_new(0.5, 0.5),
                    BackgroundColor3 = "White",
                    BorderColor3 = "Dark",
                    BorderSizePixel = 1,
                    Position = UDim2_fromScale(0.5, ColorPicker.Hue),
                    Size = UDim2_new(1, 2, 0, 1),
                    Parent = HueSelector,
                })

                --// Alpha
                local TransparencySelector, TransparencyColor, TransparencyCursor
                if Info.Transparency then
                    TransparencySelector = New("ImageButton", {
                        Image = "rbxassetid://139785960036434",
                        ScaleType = Enum.ScaleType.Tile,
                        Size = UDim2_fromOffset(16, 200),
                        TileSize = UDim2_fromOffset(8, 8),
                        Parent = ColorHolder,
                    })

                    TransparencyColor = New("Frame", {
                        BackgroundColor3 = ColorPicker.Value,
                        Size = UDim2_fromScale(1, 1),
                        Parent = TransparencySelector,
                    })
                    New("UIGradient", {
                        Rotation = 90,
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                        Parent = TransparencyColor,
                    })

                    TransparencyCursor = New("Frame", {
                        AnchorPoint = Vector2_new(0.5, 0.5),
                        BackgroundColor3 = "White",
                        BorderColor3 = "Dark",
                        BorderSizePixel = 1,
                        Position = UDim2_fromScale(0.5, ColorPicker.Transparency),
                        Size = UDim2_new(1, 2, 0, 1),
                        Parent = TransparencySelector,
                    })
                end

                local InfoHolder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 20),
                    Parent = ColorMenu.Menu,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim_new(0, 8),
                    Parent = InfoHolder,
                })

                local HueBox = New("TextBox", {
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    ClearTextOnFocus = false,
                    Size = UDim2_fromScale(1, 1),
                    Text = "#??????",
                    TextSize = 14,
                    Parent = InfoHolder,
                })

                local RgbBox = New("TextBox", {
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    ClearTextOnFocus = false,
                    Size = UDim2_fromScale(1, 1),
                    Text = "?, ?, ?",
                    TextSize = 14,
                    Parent = InfoHolder,
                })

                --// Functions //
                function ColorPicker:SetHSVFromRGB(Color)
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ToHSV(Color)
                end

                function ColorPicker:Display()
                    if Library.Unloaded then 
                        return 
                    end

                    ColorPicker.Value = Color3_fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

                    Holder.BackgroundColor3 = ColorPicker.Value
                    Holder.BorderColor3 = Library:GetDarkerColor(ColorPicker.Value)
                    HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

                    SatVipMap.BackgroundColor3 = Color3_fromHSV(ColorPicker.Hue, 1, 1)
                    if TransparencyColor then
                        TransparencyColor.BackgroundColor3 = ColorPicker.Value
                    end

                    SatVibCursor.Position = UDim2_fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
                    HueCursor.Position = UDim2_fromScale(0.5, ColorPicker.Hue)
                    if TransparencyCursor then
                        TransparencyCursor.Position = UDim2_fromScale(0.5, ColorPicker.Transparency)
                    end

                    HueBox.Text = "#" .. ColorPicker.Value:ToHex()
                    RgbBox.Text = table_concat({
                        math_floor(ColorPicker.Value.R * 255),
                        math_floor(ColorPicker.Value.G * 255),
                        math_floor(ColorPicker.Value.B * 255),
                    }, ", ")
                end

                function ColorPicker:Update()
                    ColorPicker:Display()

                    Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
                    Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
                end

                function ColorPicker:OnChanged(Func)
                    ColorPicker.Changed = Func
                end

                function ColorPicker:SetValue(HSV, Transparency)
                    local Color = Color3_fromHSV(HSV[1], HSV[2], HSV[3])

                    ColorPicker.Transparency = Info.Transparency and Transparency or 0
                    ColorPicker:SetHSVFromRGB(Color)
                    ColorPicker:Display()
                end

                function ColorPicker:SetValueRGB(Color, Transparency)
                    ColorPicker.Transparency = Info.Transparency and Transparency or 0
                    ColorPicker:SetHSVFromRGB(Color)
                    ColorPicker:Display()
                end

                --// Context Menu //
                local ContextMenu = Library:AddContextMenu(Holder, UDim2_fromOffset(93, 0), function()
                    return { Holder.AbsoluteSize.X + 1.5, 0.5 }
                end, 1)
                ColorPicker.ContextMenu = ContextMenu
                do
                    local toclipboard
                        = toclipboard

                    local function CreateButton(Text, Func)
                        local Button = New("TextButton", {
                            BackgroundTransparency = 1,
                            Size = UDim2_new(1, 0, 0, 21),
                            Text = Text,
                            TextSize = 14,
                            Parent = ContextMenu.Menu,
                        })

                        Connect(Button.MouseButton1Click, function()
                            Library:SafeCallback(Func)
                            ContextMenu:Close()
                        end)
                    end

                    CreateButton(GetTranslation(Translations, "Copy color"), function()
                        Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
                    end)

                    CreateButton(GetTranslation(Translations, "Paste color"), function()
                        ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
                    end)

                    CreateButton(GetTranslation(Translations, "Copy Hex"), function()
                        toclipboard(tostring(ColorPicker.Value:ToHex()))
                    end)
                    CreateButton(GetTranslation(Translations, "Copy RGB"), function()
                        toclipboard(table_concat({
                            math_floor(ColorPicker.Value.R * 255),
                            math_floor(ColorPicker.Value.G * 255),
                            math_floor(ColorPicker.Value.B * 255),
                        }, ", "))
                    end)
                end

                --// End //
                Connect(Holder.MouseButton1Click, ColorMenu.Toggle)
                Connect(Holder.MouseButton2Click, ContextMenu.Toggle)

                Connect(SatVipMap.MouseButton1Down, function()
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                        local MinX = SatVipMap.AbsolutePosition.X
                        local MaxX = MinX + SatVipMap.AbsoluteSize.X
                        local LocationX = math_clamp(Mouse.X, MinX, MaxX)

                        local MinY = SatVipMap.AbsolutePosition.Y
                        local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                        local LocationY = math_clamp(Mouse.Y, MinY, MaxY)

                        local OldSat = ColorPicker.Sat
                        local OldVib = ColorPicker.Vib
                        ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                        ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                        if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                            ColorPicker:Update()
                        end

                        Wait(PreRender)
                    end
                end)
                Connect(HueSelector.MouseButton1Down, function()
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                        local Min = HueSelector.AbsolutePosition.Y
                        local Max = Min + HueSelector.AbsoluteSize.Y
                        local Location = math_clamp(Mouse.Y, Min, Max)

                        local OldHue = ColorPicker.Hue
                        ColorPicker.Hue = (Location - Min) / (Max - Min)

                        if ColorPicker.Hue ~= OldHue then
                            ColorPicker:Update()
                        end

                        Wait(PreRender)
                    end
                end)
                if TransparencySelector then
                    Connect(TransparencySelector.MouseButton1Down, function()
                        while
                            UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch)
                        do
                            local Min = TransparencySelector.AbsolutePosition.Y
                            local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                            local Location = math_clamp(Mouse.Y, Min, Max)

                            local OldTransparency = ColorPicker.Transparency
                            ColorPicker.Transparency = (Location - Min) / (Max - Min)

                            if ColorPicker.Transparency ~= OldTransparency then
                                ColorPicker:Update()
                            end

                            Wait(PreRender)
                        end
                    end)
                end

                Connect(HueBox.FocusLost, function(Enter)
                    if not Enter then
                        return
                    end

                    local Success, Color = pcall(Color3_fromHex, HueBox.Text)
                    if Success and typeof(Color) == "Color3" then
                        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ToHSV(Color)
                    end

                    ColorPicker:Update()
                end)
                Connect(RgbBox.FocusLost, function(Enter)
                    if not Enter then
                        return
                    end

                    local R, G, B = string_match(RgbBox.Text, "(%d+),%s*(%d+),%s*(%d+)")
                    if R and G and B then
                        ColorPicker:SetHSVFromRGB(Color3_fromRGB(R, G, B))
                    end

                    ColorPicker:Update()
                end)

                ColorPicker:Display()

                if ParentObj.Addons then
                    table_insert(ParentObj.Addons, ColorPicker)
                end

                Options[Idx] = ColorPicker

                return self
            end

            BaseAddons.__index = Funcs
            BaseAddons.__namecall = function(_, Key, ...)
                return Funcs[Key](...)
            end
        end

        local BaseGroupbox = {}
        do
            local table_clear, string_sub, next
                = table.clear, string.sub, next

            local Funcs = {}

            function Funcs:AddDivider()
                local Groupbox = self
                local Container = Groupbox.Container

                local Holder = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Size = UDim2_new(1, 0, 0, 2),
                    Parent = Container,
                })

                Groupbox:Resize()

                table_insert(Groupbox.Elements, {
                    Holder = Holder,
                    Type = "Divider",
                })
            end

            function Funcs:AddLabel(...)
                local Data = {}

                local First = select(1, ...)
                local Second = select(2, ...)

                if typeof(First) == "table" or typeof(Second) == "table" then
                    local Params = typeof(First) == "table" and First or Second

                    Data.Text = Params.Text or ""
                    Data.DoesWrap = Params.DoesWrap or false
                    Data.Size = Params.Size or 14
                    Data.Visible = Params.Visible or true
                    Data.Idx = typeof(Second) == "table" and First or nil
                else
                    Data.Text = First or ""
                    Data.DoesWrap = Second or false
                    Data.Size = 14
                    Data.Visible = true
                    Data.Idx = select(3, ...) or nil
                end

                local Groupbox = self
                local Container = Groupbox.Container

                local Label = {
                    Text = Data.Text,
                    DoesWrap = Data.DoesWrap,

                    Visible = Data.Visible,
                    Type = "Label",

                    EventListener = nil
                }

                local TextLabel: TextLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 18),
                    Text = Label.Text,
                    TextSize = Data.Size,
                    TextWrapped = Label.DoesWrap,
                    TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
                    Parent = Container,
                })

                Connect(TextLabel.InputEnded, function(InputObject: InputObject)
                    if InputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and InputObject.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    if Label.EventListener then
                        Label.EventListener()
                    end
                end)

                function Label:BindClickEventListener(Callback: () -> ())
                    Label.EventListener = Callback
                end

                function Label:SetVisible(Visible: boolean)
                    Label.Visible = Visible

                    TextLabel.Visible = Label.Visible
                    Groupbox:Resize()
                end

                function Label:SetText(Text: string)
                    Label.Text = Text
                    TextLabel.Text = Text

                    if Label.DoesWrap then
                        local _, Y =
                            Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                        TextLabel.Size = UDim2_new(1, 0, 0, Y + 4 * Library.DPIScale)
                    end

                    Groupbox:Resize()
                end

                if Label.DoesWrap then
                    local _, Y =
                        Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                    TextLabel.Size = UDim2_new(1, 0, 0, Y + 4 * Library.DPIScale)
                else
                    New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        Padding = UDim_new(0, 6),
                        Parent = TextLabel,
                    })
                end

                if Data.DoesWrap then
                    local Last = TextLabel.AbsoluteSize

                    Connect(GetPropertyChangedSignal(TextLabel, "AbsoluteSize"), function()
                        if TextLabel.AbsoluteSize == Last then
                            return
                        end

                        local _, Y =
                            Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                        TextLabel.Size = UDim2_new(1, 0, 0, Y + 4 * Library.DPIScale)

                        Last = TextLabel.AbsoluteSize
                        Groupbox:Resize()
                    end)
                end

                Groupbox:Resize()

                Label.TextLabel = TextLabel
                Label.Container = Container
                if not Data.DoesWrap then
                    setmetatable(Label, BaseAddons)
                end

                Label.Holder = TextLabel
                table_insert(Groupbox.Elements, Label)

                if Data.Idx then
                    Labels[Data.Idx] = Label
                else
                    table_insert(Labels, Label)
                end

                return Label
            end

            function Funcs:AddButton(...)
                local function GetInfo(...)
                    local Info = {}

                    local First = select(1, ...)
                    local Second = select(2, ...)

                    if typeof(First) == "table" or typeof(Second) == "table" then
                        local Params = typeof(First) == "table" and First or Second

                        Info.Text = Params.Text or ""
                        Info.Func = Params.Func or function() end
                        Info.DoubleClick = Params.DoubleClick

                        Info.Tooltip = Params.Tooltip
                        Info.DisabledTooltip = Params.DisabledTooltip

                        Info.Risky = Params.Risky or false
                        Info.Disabled = Params.Disabled or false
                        Info.Visible = Params.Visible or true
                        Info.Idx = typeof(Second) == "table" and First or nil
                    else
                        Info.Text = First or ""
                        Info.Func = Second or function() end
                        Info.DoubleClick = false

                        Info.Tooltip = nil
                        Info.DisabledTooltip = nil

                        Info.Risky = false
                        Info.Disabled = false
                        Info.Visible = true
                        Info.Idx = select(3, ...) or nil
                    end

                    return Info
                end
                local Info = GetInfo(...)

                local Groupbox = self
                local Container = Groupbox.Container

                local Button = {
                    Text = Info.Text,
                    Func = Info.Func,
                    DoubleClick = Info.DoubleClick,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Risky = Info.Risky,
                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Tween = nil,
                    Type = "Button",
                }

                local Holder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 21),
                    Parent = Container,
                })

                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim_new(0, 9),
                    Parent = Holder,
                })

                local function CreateButton(Button)
                    local Base = New("TextButton", {
                        Active = not Button.Disabled,
                        BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                        Size = UDim2_fromScale(1, 1),
                        Text = Button.Text,
                        TextSize = 14,
                        TextTransparency = 0.4,
                        Visible = Button.Visible,
                        Parent = Holder,
                    })

                    local Stroke = New("UIStroke", {
                        Color = "OutlineColor",
                        Transparency = Button.Disabled and 0.5 or 0,
                        Parent = Base,
                    })

                    return Base, Stroke
                end

                local function InitEvents(Button)
                    Connect(Button.Base.MouseEnter, function()
                        if Button.Disabled then
                            return
                        end

                        Button.Tween = TweenService_Create(TweenService, Button.Base, Library.TweenInfo, {
                            TextTransparency = 0,
                        })
                        Play(Button.Tween)
                    end)
                    Connect(Button.Base.MouseLeave, function()
                        if Button.Disabled then
                            return
                        end

                        Button.Tween = TweenService_Create(TweenService, Button.Base, Library.TweenInfo, {
                            TextTransparency = 0.4,
                        })
                        Play(Button.Tween)
                    end)

                    Connect(Button.Base.MouseButton1Click, function()
                        if Button.Disabled or Button.Locked then
                            return
                        end

                        if Button.DoubleClick then
                            Button.Locked = true

                            Button.Base.Text = GetTranslation(Translations, "Are you sure?")
                            Button.Base.TextColor3 = Library.Scheme.AccentColor
                            Library.Registry[Button.Base].TextColor3 = "AccentColor"

                            local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                            Button.Base.Text = Button.Text
                            Button.Base.TextColor3 = Button.Risky and Library.Scheme.Red or Library.Scheme.FontColor
                            Library.Registry[Button.Base].TextColor3 = Button.Risky and "Red" or "FontColor"

                            if Clicked then
                                Library:SafeCallback(Button.Func)
                            end

                            Wait(PreRender) --// Mouse Button fires without waiting (i hate roblox)
                            Button.Locked = false
                            return
                        end

                        Library:SafeCallback(Button.Func)
                    end)
                end

                Button.Base, Button.Stroke = CreateButton(Button)
                InitEvents(Button)

                function Button:AddButton(...)
                    local Info = GetInfo(...)

                    local SubButton = {
                        Text = Info.Text,
                        Func = Info.Func,
                        DoubleClick = Info.DoubleClick,

                        Tooltip = Info.Tooltip,
                        DisabledTooltip = Info.DisabledTooltip,
                        TooltipTable = nil,

                        Risky = Info.Risky,
                        Disabled = Info.Disabled,
                        Visible = Info.Visible,

                        Tween = nil,
                        Type = "SubButton",
                    }

                    Button.SubButton = SubButton
                    SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
                    InitEvents(SubButton)

                    function SubButton:UpdateColors()
                        if Library.Unloaded then 
                            return
                        end

                        StopTween(SubButton.Tween)

                        SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor
                            or Library.Scheme.MainColor
                        SubButton.Base.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                        SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                        Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                            or "MainColor"
                    end

                    function SubButton:SetDisabled(Disabled: boolean)
                        SubButton.Disabled = Disabled

                        if SubButton.TooltipTable then
                            SubButton.TooltipTable.Disabled = SubButton.Disabled
                        end

                        SubButton.Base.Active = not SubButton.Disabled
                        SubButton:UpdateColors()
                    end

                    function SubButton:SetVisible(Visible: boolean)
                        SubButton.Visible = Visible

                        SubButton.Base.Visible = SubButton.Visible
                        Groupbox:Resize()
                    end

                    function SubButton:SetText(Text: string)
                        SubButton.Text = Text
                        SubButton.Base.Text = Text
                    end

                    if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                        SubButton.TooltipTable =
                            Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                        SubButton.TooltipTable.Disabled = SubButton.Disabled
                    end

                    if SubButton.Risky then
                        SubButton.Base.TextColor3 = Library.Scheme.Red
                        Library.Registry[SubButton.Base].TextColor3 = "Red"
                    end

                    SubButton:UpdateColors()

                    if Info.Idx then
                        Buttons[Info.Idx] = SubButton
                    else
                        table_insert(Buttons, SubButton)
                    end

                    return SubButton
                end

                function Button:UpdateColors()
                    if Library.Unloaded then 
                        return
                    end

                    StopTween(Button.Tween)

                    Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor
                        or Library.Scheme.MainColor
                    Button.Base.TextTransparency = Button.Disabled and 0.8 or 0.4
                    Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

                    Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
                end

                function Button:SetDisabled(Disabled: boolean)
                    Button.Disabled = Disabled

                    if Button.TooltipTable then
                        Button.TooltipTable.Disabled = Button.Disabled
                    end

                    Button.Base.Active = not Button.Disabled
                    Button:UpdateColors()
                end

                function Button:SetVisible(Visible: boolean)
                    Button.Visible = Visible

                    Holder.Visible = Button.Visible
                    Groupbox:Resize()
                end

                function Button:SetText(Text: string)
                    Button.Text = Text
                    Button.Base.Text = Text
                end

                if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
                    Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
                    Button.TooltipTable.Disabled = Button.Disabled
                end

                if Button.Risky then
                    Button.Base.TextColor3 = Library.Scheme.Red
                    Library.Registry[Button.Base].TextColor3 = "Red"
                end

                Button:UpdateColors()
                Groupbox:Resize()

                Button.Holder = Holder
                table_insert(Groupbox.Elements, Button)

                if Info.Idx then
                    Buttons[Info.Idx] = Button
                else
                    table_insert(Buttons, Button)
                end

                return Button
            end

            function Funcs:AddCheckbox(Idx, Info)
                Info = Library:Validate(Info, Templates.Toggle)

                local Groupbox = self
                local Container = Groupbox.Container

                local Toggle = {
                    Text = Info.Text,
                    Value = Info.Default,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Risky = Info.Risky,
                    Disabled = Info.Disabled,
                    Visible = Info.Visible,
                    Addons = {},

                    Type = "Toggle",
                }

                local Button = New("TextButton", {
                    Active = not Toggle.Disabled,
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 18),
                    Text = "",
                    Visible = Toggle.Visible,
                    Parent = Container,
                })

                local Label = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2_fromOffset(26, 0),
                    Size = UDim2_new(1, -26, 1, 0),
                    Text = Toggle.Text,
                    TextSize = 14,
                    TextTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button,
                })

                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim_new(0, 6),
                    Parent = Label,
                })

                local Checkbox = New("Frame", {
                    BackgroundColor3 = "MainColor",
                    Size = UDim2_fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = Button,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })

                local CheckboxStroke = New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Checkbox,
                })

                local CheckImage = New("ImageLabel", {
                    Image = CheckIcon and CheckIcon.Url or "",
                    ImageColor3 = "FontColor",
                    ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2_zero,
                    ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2_zero,
                    ImageTransparency = 1,
                    Position = UDim2_fromOffset(2, 2),
                    Size = UDim2_new(1, -4, 1, -4),
                    Parent = Checkbox,
                })

                function Toggle:UpdateColors()
                    Toggle:Display()
                end

                function Toggle:Display()
                    if Library.Unloaded then
                        return
                    end

                    CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

                    if Toggle.Disabled then
                        Label.TextTransparency = 0.8
                        CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                        Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                        Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                        return
                    end

                    Play(TweenService_Create(TweenService, Label, Library.TweenInfo, {
                        TextTransparency = Toggle.Value and 0 or 0.4,
                    }))
                    Play(TweenService_Create(TweenService, CheckImage, Library.TweenInfo, {
                        ImageTransparency = Toggle.Value and 0 or 1,
                    }))

                    Checkbox.BackgroundColor3 = Library.Scheme.MainColor
                    Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
                end

                function Toggle:OnChanged(Func)
                    Toggle.Changed = Func
                end

                function Toggle:SetValue(Value)
                    if Value == Toggle.Value or Toggle.Disabled then
                        return
                    end

                    Toggle.Value = Value
                    Toggle:Display()

                    for _, Addon in Toggle.Addons do
                        if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                            Addon.Toggled = Toggle.Value
                            Addon:Update()
                        end
                    end

                    Library:SafeCallback(Toggle.Callback, Toggle.Value)
                    Library:SafeCallback(Toggle.Changed, Toggle.Value)

                    if Toggle.TooltipTable then
                        Toggle.TooltipTable:Update()
                    end
                end

                function Toggle:SetDisabled(Disabled: boolean)
                    Toggle.Disabled = Disabled

                    if Toggle.TooltipTable then
                        Toggle.TooltipTable.Disabled = Toggle.Disabled
                    end

                    for _, Addon in Toggle.Addons do
                        if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                            Addon:Update()
                        end
                    end

                    Button.Active = not Toggle.Disabled
                    Toggle:Display()
                end

                function Toggle:SetVisible(Visible: boolean)
                    Toggle.Visible = Visible

                    Button.Visible = Toggle.Visible
                    Groupbox:Resize()
                end

                function Toggle:SetText(Text: string)
                    Toggle.Text = Text
                    Label.Text = Text
                end

                Connect(Button.MouseButton1Click, function()
                    if Toggle.Disabled then
                        return
                    end

                    Toggle:SetValue(not Toggle.Value)
                end)

                if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
                    Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
                    Toggle.TooltipTable.Disabled = Toggle.Disabled
                end

                if Toggle.Risky then
                    Label.TextColor3 = Library.Scheme.Red
                    Library.Registry[Label].TextColor3 = "Red"
                end

                Toggle:Display()
                Groupbox:Resize()

                Toggle.TextLabel = Label
                Toggle.Container = Container
                setmetatable(Toggle, BaseAddons)

                Toggle.Holder = Button
                table_insert(Groupbox.Elements, Toggle)

                Toggles[Idx] = Toggle

                return Toggle
            end

            function Funcs:AddToggle(Idx, Info)
                if Library.ForceCheckbox then
                    return Funcs.AddCheckbox(self, Idx, Info)
                end

                Info = Library:Validate(Info, Templates.Toggle)

                local Groupbox = self
                local Container = Groupbox.Container

                local Toggle = {
                    Text = Info.Text,
                    Value = Info.Default,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Risky = Info.Risky,
                    Disabled = Info.Disabled,
                    Visible = Info.Visible,
                    Addons = {},

                    Type = "Toggle",
                }

                local Button = New("TextButton", {
                    Active = not Toggle.Disabled,
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 18),
                    Text = "",
                    Visible = Toggle.Visible,
                    Parent = Container,
                })

                local Label = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, -40, 1, 0),
                    Text = Toggle.Text,
                    TextSize = 14,
                    TextTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button,
                })

                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDim_new(0, 6),
                    Parent = Label,
                })

                local Switch = New("Frame", {
                    AnchorPoint = Vector2_new(1, 0),
                    BackgroundColor3 = "MainColor",
                    Position = UDim2_fromScale(1, 0),
                    Size = UDim2_fromOffset(32, 18),
                    Parent = Button,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(1, 0),
                    Parent = Switch,
                })
                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 2),
                    PaddingLeft = UDim_new(0, 2),
                    PaddingRight = UDim_new(0, 2),
                    PaddingTop = UDim_new(0, 2),
                    Parent = Switch,
                })
                local SwitchStroke = New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Switch,
                })

                local Ball = New("Frame", {
                    BackgroundColor3 = "FontColor",
                    Size = UDim2_fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = Switch,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(1, 0),
                    Parent = Ball,
                })

                function Toggle:UpdateColors()
                    Toggle:Display()
                end

                function Toggle:Display()
                    if Library.Unloaded then
                        return
                    end

                    local Offset = Toggle.Value and 1 or 0

                    Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
                    SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

                    Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
                    SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

                    Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
                    Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

                    if Toggle.Disabled then
                        Label.TextTransparency = 0.8
                        Ball.AnchorPoint = Vector2_new(Offset, 0)
                        Ball.Position = UDim2_fromScale(Offset, 0)

                        Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                        Library.Registry[Ball].BackgroundColor3 = function()
                            return Library:GetDarkerColor(Library.Scheme.FontColor)
                        end

                        return
                    end

                    Play(TweenService_Create(TweenService, Label, Library.TweenInfo, {
                        TextTransparency = Toggle.Value and 0 or 0.4,
                    }))
                    Play(TweenService_Create(TweenService, Ball, Library.TweenInfo, {
                        AnchorPoint = Vector2_new(Offset, 0),
                        Position = UDim2_fromScale(Offset, 0),
                    }))

                    Ball.BackgroundColor3 = Library.Scheme.FontColor
                    Library.Registry[Ball].BackgroundColor3 = "FontColor"
                end

                function Toggle:OnChanged(Func)
                    Toggle.Changed = Func
                end

                function Toggle:SetValue(Value)
                    if Toggle.Value == Value or Toggle.Disabled then
                        return
                    end

                    Toggle.Value = Value
                    Toggle:Display()

                    for _, Addon in Toggle.Addons do
                        if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                            Addon.Toggled = Toggle.Value
                            Addon:Update()
                        end
                    end

                    Library:SafeCallback(Toggle.Callback, Toggle.Value)
                    Library:SafeCallback(Toggle.Changed, Toggle.Value)

                    if Toggle.TooltipTable then
                        Toggle.TooltipTable:Update()
                    end
                end

                function Toggle:SetDisabled(Disabled: boolean)
                    Toggle.Disabled = Disabled

                    if Toggle.TooltipTable then
                        Toggle.TooltipTable.Disabled = Toggle.Disabled
                    end

                    for _, Addon in Toggle.Addons do
                        if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                            Addon:Update()
                        end
                    end

                    Button.Active = not Toggle.Disabled
                    Toggle:Display()
                end

                function Toggle:SetVisible(Visible: boolean)
                    Toggle.Visible = Visible

                    Button.Visible = Toggle.Visible
                    Groupbox:Resize()
                end

                function Toggle:SetText(Text: string)
                    Toggle.Text = Text
                    Label.Text = Text
                end

                Connect(Button.MouseButton1Click, function()
                    if Toggle.Disabled then
                        return
                    end

                    Toggle:SetValue(not Toggle.Value)
                end)

                if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
                    Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
                    Toggle.TooltipTable.Disabled = Toggle.Disabled
                end

                if Toggle.Risky then
                    Label.TextColor3 = Library.Scheme.Red
                    Library.Registry[Label].TextColor3 = "Red"
                end

                Toggle:Display()
                Groupbox:Resize()

                Toggle.TextLabel = Label
                Toggle.Container = Container
                setmetatable(Toggle, BaseAddons)

                Toggle.Holder = Button
                table_insert(Groupbox.Elements, Toggle)

                Toggles[Idx] = Toggle

                return Toggle
            end

            function Funcs:AddInput(Idx, Info)
                Info = Library:Validate(Info, Templates.Input)

                local Groupbox = self
                local Container = Groupbox.Container

                local Input = {
                    Text = Info.Text,
                    Value = Info.Default,
                    Finished = Info.Finished,
                    Numeric = Info.Numeric,
                    ClearTextOnFocus = Info.ClearTextOnFocus,
                    Placeholder = Info.Placeholder,
                    AllowEmpty = Info.AllowEmpty,
                    EmptyReset = Info.EmptyReset,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Type = "Input",
                }

                local Holder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 39),
                    Visible = Input.Visible,
                    Parent = Container,
                })

                local Label = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 14),
                    Text = Input.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                local Box = New("TextBox", {
                    AnchorPoint = Vector2_new(0, 1),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
                    PlaceholderText = Input.Placeholder,
                    Position = UDim2_fromScale(0, 1),
                    Size = UDim2_new(1, 0, 0, 21),
                    Text = Input.Value,
                    TextEditable = not Input.Disabled,
                    TextScaled = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 3),
                    PaddingLeft = UDim_new(0, 8),
                    PaddingRight = UDim_new(0, 8),
                    PaddingTop = UDim_new(0, 4),
                    Parent = Box,
                })

                function Input:UpdateColors()
                    if Library.Unloaded then
                        return
                    end

                    Label.TextTransparency = Input.Disabled and 0.8 or 0
                    Box.TextTransparency = Input.Disabled and 0.8 or 0
                end

                function Input:OnChanged(Func)
                    Input.Changed = Func
                end

                function Input:SetValue(Text)
                    if not Input.AllowEmpty and Trim(Text) == "" then
                        Text = Input.EmptyReset
                    end

                    if Info.MaxLength and #Text > Info.MaxLength then
                        Text = string_sub(Text, 1, Info.MaxLength)
                    end

                    if Input.Numeric then
                        if #Text > 0 and not tonumber(Text) then
                            Text = Input.Value
                        end
                    end

                    Input.Value = Text
                    Box.Text = Text

                    if not Input.Disabled then
                        Library:SafeCallback(Input.Callback, Input.Value)
                        Library:SafeCallback(Input.Changed, Input.Value)
                    end
                end

                function Input:SetDisabled(Disabled: boolean)
                    Input.Disabled = Disabled

                    if Input.TooltipTable then
                        Input.TooltipTable.Disabled = Input.Disabled
                    end

                    Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
                    Box.TextEditable = not Input.Disabled
                    Input:UpdateColors()
                end

                function Input:SetVisible(Visible: boolean)
                    Input.Visible = Visible

                    Holder.Visible = Input.Visible
                    Groupbox:Resize()
                end

                function Input:SetText(Text: string)
                    Input.Text = Text
                    Label.Text = Text
                end

                if Input.Finished then
                    Connect(Box.FocusLost, function(Enter)
                        if not Enter then
                            return
                        end

                        Input:SetValue(Box.Text)
                    end)
                else
                    Connect(GetPropertyChangedSignal(Box, "Text"), function()
                        Input:SetValue(Box.Text)
                    end)
                end

                if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
                    Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
                    Input.TooltipTable.Disabled = Input.Disabled
                end

                Groupbox:Resize()

                Input.Holder = Holder
                table_insert(Groupbox.Elements, Input)

                Options[Idx] = Input

                return Input
            end

            function Funcs:AddSlider(Idx, Info)
                Info = Library:Validate(Info, Templates.Slider)

                local Groupbox = self
                local Container = Groupbox.Container

                local Slider = {
                    Text = Info.Text,
                    Value = Info.Default,
                    Min = Info.Min,
                    Max = Info.Max,

                    Prefix = Info.Prefix,
                    Suffix = Info.Suffix,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Type = "Slider",
                }

                local Holder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, Info.Compact and 13 or 31),
                    Visible = Slider.Visible,
                    Parent = Container,
                })

                local SliderLabel
                if not Info.Compact then
                    SliderLabel = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 14),
                        Text = Slider.Text,
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Holder,
                    })
                end

                local Bar = New("TextButton", {
                    Active = not Slider.Disabled,
                    AnchorPoint = Vector2_new(0, 1),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2_fromScale(0, 1),
                    Size = UDim2_new(1, 0, 0, 13),
                    Text = "",
                    Parent = Holder,
                })

                local DisplayLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_fromScale(1, 1),
                    Text = "",
                    TextSize = 14,
                    ZIndex = 2,
                    Parent = Bar,
                })
                New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                    Color = "Dark",
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Parent = DisplayLabel,
                })

                local Fill = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    Size = UDim2_fromScale(0.5, 1),
                    Parent = Bar,

                    DPIExclude = {
                        Size = true,
                    },
                })

                function Slider:UpdateColors()
                    if Library.Unloaded then
                        return
                    end

                    if SliderLabel then
                        SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
                    end
                    DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

                    Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
                    Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
                end

                function Slider:Display()
                    if Library.Unloaded then
                        return
                    end

                    if Info.Compact then
                        DisplayLabel.Text = string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                    elseif Info.HideMax then
                        DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                    else
                        DisplayLabel.Text = string.format(
                            "%s%s%s/%s%s%s",
                            Slider.Prefix,
                            Slider.Value,
                            Slider.Suffix,
                            Slider.Prefix,
                            Slider.Max,
                            Slider.Suffix
                        )
                    end

                    local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                    Fill.Size = UDim2_fromScale(X, 1)
                end

                function Slider:OnChanged(Func)
                    Slider.Changed = Func
                end

                local function Round(Value)
                    if Info.Rounding == 0 then
                        return math_floor(Value)
                    end

                    return tonumber(string.format("%." .. Info.Rounding .. "f", Value))
                end

                function Slider:SetMax(Value)
                    assert(Value > Slider.Min, GetTranslation(Translations, "Max value cannot be less than the current min value."))

                    Slider.Value = math_clamp(Slider.Value, Slider.Min, Value)
                    Slider.Max = Value
                    Slider:Display()
                end

                function Slider:SetMin(Value)
                    assert(Value < Slider.Max, GetTranslation(Translations, "Min value cannot be greater than the current max value."))

                    Slider.Value = math_clamp(Slider.Value, Value, Slider.Max)
                    Slider.Min = Value
                    Slider:Display()
                end

                function Slider:SetValue(Str)
                    if Slider.Disabled then
                        return
                    end

                    local Num = tonumber(Str)
                    if not Num then
                        return
                    end

                    Num = math_clamp(Num, Slider.Min, Slider.Max)

                    Slider.Value = Num
                    Slider:Display()

                    Library:SafeCallback(Slider.Callback, Slider.Value)
                    Library:SafeCallback(Slider.Changed, Slider.Value)
                end

                function Slider:SetDisabled(Disabled: boolean)
                    Slider.Disabled = Disabled

                    if Slider.TooltipTable then
                        Slider.TooltipTable.Disabled = Slider.Disabled
                    end

                    Bar.Active = not Slider.Disabled
                    Slider:UpdateColors()
                end

                function Slider:SetVisible(Visible: boolean)
                    Slider.Visible = Visible

                    Holder.Visible = Slider.Visible
                    Groupbox:Resize()
                end

                function Slider:SetText(Text: string)
                    Slider.Text = Text
                    if SliderLabel then
                        SliderLabel.Text = Text
                        return
                    end
                    Slider:Display()
                end

                function Slider:SetPrefix(Prefix: string)
                    Slider.Prefix = Prefix
                    Slider:Display()
                end

                function Slider:SetSuffix(Suffix: string)
                    Slider.Suffix = Suffix
                    Slider:Display()
                end

                Connect(Bar.MouseButton1Down, function()
                    if Slider.Disabled then
                        return
                    end

                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = false
                    end

                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                        local Location = Mouse.X
                        local Scale = math_clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                        local OldValue = Slider.Value
                        Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale))

                        Slider:Display()
                        if Slider.Value ~= OldValue then
                            Library:SafeCallback(Slider.Callback, Slider.Value)
                            Library:SafeCallback(Slider.Changed, Slider.Value)
                        end

                        Wait(PreRender)
                    end

                    for _, Side in Library.ActiveTab.Sides do
                        Side.ScrollingEnabled = true
                    end
                end)

                if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
                    Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
                    Slider.TooltipTable.Disabled = Slider.Disabled
                end

                Slider:UpdateColors()
                Slider:Display()
                Groupbox:Resize()

                Slider.Holder = Holder
                table_insert(Groupbox.Elements, Slider)

                Options[Idx] = Slider

                return Slider
            end

            function Funcs:AddDropdown(Idx, Info)
                Info = Library:Validate(Info, Templates.Dropdown)

                local Groupbox = self
                local Container = Groupbox.Container

                if Info.SpecialType == "Player" then
                    Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
                    Info.AllowNull = true
                elseif Info.SpecialType == "Team" then
                    Info.Values = GetTeams()
                    Info.AllowNull = true
                end
                local Dropdown = {
                    Text = typeof(Info.Text) == "string" and Info.Text or nil,
                    Value = Info.Multi and {} or nil,
                    Values = Info.Values,
                    DisabledValues = Info.DisabledValues,

                    SpecialType = Info.SpecialType,
                    ExcludeLocalPlayer = Info.ExcludeLocalPlayer,

                    Tooltip = Info.Tooltip,
                    DisabledTooltip = Info.DisabledTooltip,
                    TooltipTable = nil,

                    Callback = Info.Callback,
                    Changed = Info.Changed,

                    Disabled = Info.Disabled,
                    Visible = Info.Visible,

                    Type = "Dropdown",
                }

                local Holder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, Dropdown.Text and 39 or 21),
                    Visible = Dropdown.Visible,
                    Parent = Container,
                })

                local Label = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 14),
                    Text = Dropdown.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = not not Info.Text,
                    Parent = Holder,
                })

                local Display = New("TextButton", {
                    Active = not Dropdown.Disabled,
                    AnchorPoint = Vector2_new(0, 1),
                    BackgroundColor3 = "MainColor",
                    BorderColor3 = "OutlineColor",
                    BorderSizePixel = 1,
                    Position = UDim2_fromScale(0, 1),
                    Size = UDim2_new(1, 0, 0, 21),
                    Text = "---",
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Holder,
                })

                New("UIPadding", {
                    PaddingLeft = UDim_new(0, 8),
                    PaddingRight = UDim_new(0, 4),
                    Parent = Display,
                })

                local ArrowImage = New("ImageLabel", {
                    AnchorPoint = Vector2_new(1, 0.5),
                    Image = ArrowIcon and ArrowIcon.Url or "",
                    ImageColor3 = "FontColor",
                    ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2_zero,
                    ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2_zero,
                    ImageTransparency = 0.5,
                    Position = UDim2_fromScale(1, 0.5),
                    Size = UDim2_fromOffset(16, 16),
                    Parent = Display,
                })

                local SearchBox
                if Info.Searchable then
                    SearchBox = New("TextBox", {
                        BackgroundTransparency = 1,
                        PlaceholderText = GetTranslation(Translations, "Search..."),
                        Position = UDim2_fromOffset(-8, 0),
                        Size = UDim2_new(1, -12, 1, 0),
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = false,
                        Parent = Display,
                    })
                    New("UIPadding", {
                        PaddingLeft = UDim_new(0, 8),
                        Parent = SearchBox,
                    })
                end

                local MenuTable = Library:AddContextMenu(
                    Display,
                    function()
                        return UDim2_fromOffset(Display.AbsoluteSize.X, 0)
                    end,
                    function()
                        return { 0.5, Display.AbsoluteSize.Y + 1.5 }
                    end,
                    2,
                    function(Active: boolean)
                        Display.TextTransparency = (Active and SearchBox) and 1 or 0
                        ArrowImage.ImageTransparency = Active and 0 or 0.5
                        ArrowImage.Rotation = Active and 180 or 0
                        if SearchBox then
                            SearchBox.Text = ""
                            SearchBox.Visible = Active
                        end
                    end
                )
                Dropdown.Menu = MenuTable
                Library:UpdateDPI(MenuTable.Menu, {
                    Position = false,
                    Size = false,
                })

                function Dropdown:RecalculateListSize(Count)
                    local Y = math_clamp(
                        (Count or GetTableSize(Dropdown.Values)) * (21 * Library.DPIScale),
                        0,
                        Info.MaxVisibleDropdownItems * (21 * Library.DPIScale)
                    )

                    MenuTable:SetSize(function()
                        return UDim2_fromOffset(Display.AbsoluteSize.X, Y)
                    end)
                end

                function Dropdown:UpdateColors()
                    if Library.Unloaded then
                        return
                    end

                    Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
                    Display.TextTransparency = Dropdown.Disabled and 0.8 or 0
                    ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
                end

                function Dropdown:Display()
                    if Library.Unloaded then
                        return
                    end

                    local Str = ""

                    if Info.Multi then
                        for _, Value in Dropdown.Values do
                            if Dropdown.Value[Value] then
                                Str = Str
                                    .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(Value)) or tostring(Value))
                                    .. ", "
                            end
                        end

                        Str = string_sub(Str, 1, #Str - 2)
                    else
                        Str = Dropdown.Value and tostring(Dropdown.Value) or ""
                        if Str ~= "" and Info.FormatDisplayValue then
                            Str = tostring(Info.FormatDisplayValue(Str))
                        end
                    end

                    if #Str > 25 then
                        Str = string_sub(Str, 1, 22) .. "..."
                    end

                    Display.Text = (Str == "" and "---" or Str)
                end

                function Dropdown:OnChanged(Func)
                    Dropdown.Changed = Func
                end

                function Dropdown:GetActiveValues()
                    if Info.Multi then
                        local Table = {}

                        for Value in Dropdown.Value do
                            table_insert(Table, Value)
                        end

                        return Table
                    end

                    return Dropdown.Value and 1 or 0
                end

                local Buttons = {}
                function Dropdown:BuildDropdownList()
                    local Values = Dropdown.Values
                    local DisabledValues = Dropdown.DisabledValues

                    for Button in Buttons do
                        Destroy(Button)
                    end
                    table_clear(Buttons)

                    local Count = 0
                    for _, Value in Values do
                        if SearchBox and not string_match(string_lower(tostring(Value)), string_lower(SearchBox.Text)) then
                            continue
                        end

                        Count += 1
                        local IsDisabled = table_find(DisabledValues, Value)
                        local Table = {}

                        local Button = New("TextButton", {
                            BackgroundColor3 = "MainColor",
                            BackgroundTransparency = 1,
                            LayoutOrder = IsDisabled and 1 or 0,
                            Size = UDim2_new(1, 0, 0, 21),
                            Text = tostring(Value),
                            TextSize = 14,
                            TextTransparency = 0.5,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = MenuTable.Menu,
                        })
                        New("UIPadding", {
                            PaddingLeft = UDim_new(0, 7),
                            PaddingRight = UDim_new(0, 7),
                            Parent = Button,
                        })

                        local Selected
                        if Info.Multi then
                            Selected = Dropdown.Value[Value]
                        else
                            Selected = Dropdown.Value == Value
                        end

                        function Table:UpdateButton()
                            if Info.Multi then
                                Selected = Dropdown.Value[Value]
                            else
                                Selected = Dropdown.Value == Value
                            end

                            Button.BackgroundTransparency = Selected and 0 or 1
                            Button.TextTransparency = IsDisabled and 0.8 or Selected and 0 or 0.5
                        end

                        if not IsDisabled then
                            Connect(Button.MouseButton1Click, function()
                                local Try = not Selected

                                if not (Dropdown:GetActiveValues() == 1 and not Try and not Info.AllowNull) then
                                    Selected = Try
                                    if Info.Multi then
                                        Dropdown.Value[Value] = Selected and true or nil
                                    else
                                        Dropdown.Value = Selected and Value or nil
                                    end

                                    for _, OtherButton in Buttons do
                                        OtherButton:UpdateButton()
                                    end
                                end

                                Table:UpdateButton()
                                Dropdown:Display()

                                Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                                Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
                            end)
                        end

                        Table:UpdateButton()
                        Dropdown:Display()

                        Buttons[Button] = Table
                    end

                    Dropdown:RecalculateListSize(Count)
                end

                function Dropdown:SetValue(Value)
                    if Info.Multi then
                        local Table = {}

                        for Val, Active in Value or {} do
                            if Active and table_find(Dropdown.Values, Val) then
                                Table[Val] = true
                            end
                        end

                        Dropdown.Value = Table
                    else
                        if table_find(Dropdown.Values, Value) then
                            Dropdown.Value = Value
                        elseif not Value then
                            Dropdown.Value = nil
                        end
                    end

                    Dropdown:Display()
                    for _, Button in Buttons do
                        Button:UpdateButton()
                    end

                    if not Dropdown.Disabled then
                        Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                        Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
                    end
                end

                function Dropdown:SetValues(Values)
                    Dropdown.Values = Values
                    Dropdown:BuildDropdownList()
                end

                function Dropdown:AddValues(Values)
                    if typeof(Values) == "table" then
                        for _, val in Values do
                            table_insert(Dropdown.Values, val)
                        end
                    elseif typeof(Values) == "string" then
                        table_insert(Dropdown.Values, Values)
                    else
                        return
                    end

                    Dropdown:BuildDropdownList()
                end

                function Dropdown:SetDisabledValues(DisabledValues)
                    Dropdown.DisabledValues = DisabledValues
                    Dropdown:BuildDropdownList()
                end

                function Dropdown:AddDisabledValues(DisabledValues)
                    if typeof(DisabledValues) == "table" then
                        for _, val in DisabledValues do
                            table_insert(Dropdown.DisabledValues, val)
                        end
                    elseif typeof(DisabledValues) == "string" then
                        table_insert(Dropdown.DisabledValues, DisabledValues)
                    else
                        return
                    end

                    Dropdown:BuildDropdownList()
                end

                function Dropdown:SetDisabled(Disabled: boolean)
                    Dropdown.Disabled = Disabled

                    if Dropdown.TooltipTable then
                        Dropdown.TooltipTable.Disabled = Dropdown.Disabled
                    end

                    MenuTable:Close()
                    Display.Active = not Dropdown.Disabled
                    Dropdown:UpdateColors()
                end

                function Dropdown:SetVisible(Visible: boolean)
                    Dropdown.Visible = Visible

                    Holder.Visible = Dropdown.Visible
                    Groupbox:Resize()
                end

                function Dropdown:SetText(Text: string)
                    Dropdown.Text = Text
                    Holder.Size = UDim2_new(1, 0, 0, (Text and 39 or 21) * Library.DPIScale)

                    Label.Text = Text and Text or ""
                    Label.Visible = not not Text
                end

                Connect(Display.MouseButton1Click, function()
                    if Dropdown.Disabled then
                        return
                    end

                    MenuTable:Toggle()
                end)

                if SearchBox then
                    Connect(GetPropertyChangedSignal(SearchBox, "Text"), Dropdown.BuildDropdownList)
                end

                local Defaults = {}
                if typeof(Info.Default) == "string" then
                    local Index = table_find(Dropdown.Values, Info.Default)
                    if Index then
                        table_insert(Defaults, Index)
                    end
                elseif typeof(Info.Default) == "table" then
                    for _, Value in Info.Default do
                        local Index = table_find(Dropdown.Values, Value)
                        if Index then
                            table_insert(Defaults, Index)
                        end
                    end
                elseif Dropdown.Values[Info.Default] ~= nil then
                    table_insert(Defaults, Info.Default)
                end
                if next(Defaults) then
                    for i = 1, #Defaults do
                        local Index = Defaults[i]
                        if Info.Multi then
                            Dropdown.Value[Dropdown.Values[Index]] = true
                        else
                            Dropdown.Value = Dropdown.Values[Index]
                        end

                        if not Info.Multi then
                            break
                        end
                    end
                end

                if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
                    Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, Display)
                    Dropdown.TooltipTable.Disabled = Dropdown.Disabled
                end

                Dropdown:UpdateColors()
                Dropdown:Display()
                Dropdown:BuildDropdownList()
                Groupbox:Resize()

                Dropdown.Holder = Holder
                table_insert(Groupbox.Elements, Dropdown)

                Options[Idx] = Dropdown

                return Dropdown
            end

            BaseGroupbox.__index = Funcs
            BaseGroupbox.__namecall = function(_, Key, ...)
                return Funcs[Key](...)
            end
        end

        do
            local Font_fromEnum
                = Font.fromEnum

            function Library:SetFont(FontFace: Font | EnumItem)
                if typeof(FontFace) == "EnumItem" then
                    FontFace = Font_fromEnum(FontFace)
                end

                Library.Scheme.Font = FontFace
                Library:UpdateColorsUsingRegistry()
            end
        end

        do
            local string_find
                = string.find

            local Left   = Enum.HorizontalAlignment.Left
            local Right  = Enum.HorizontalAlignment.Right
            local Top    = Enum.VerticalAlignment.Top
            local Bottom = Enum.VerticalAlignment.Bottom

            local AllowedSides = {
                "topleft",
                "topright",
                "bottomleft",
                "bottomright"
            }

            function Library:SetNotifySide(Side: string)
                local LowerSide = string_lower(Side)
                if table_find(AllowedSides, LowerSide) == nil then return end

                Library.NotifySide = Side

                local IsLeft = string_find(LowerSide, "left")
                local IsTop  = string_find(LowerSide, "top")

                NotificationArea.AnchorPoint = Vector2_new(IsLeft and 0 or 1, IsTop  and 0 or 1)
                NotificationArea.Position    = UDim2_new  (IsLeft and 0 or 1, IsLeft and 6 or -6, IsTop and 0 or 1, IsTop and 6 or -6)
                NotificationList.HorizontalAlignment = IsLeft and Left or Right
                NotificationList.VerticalAlignment   = IsTop  and Top  or Bottom
            end
        end

        function Library:CreateWindow(WindowInfo)
            WindowInfo = Library:Validate(WindowInfo, Templates.Window)
            ScreenGui.OnTopOfCoreBlur = WindowInfo.AlwaysOnTop == true

            local ViewportSize: Vector2 = shared.Camera.ViewportSize
            if IsStudio and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
                repeat
                    ViewportSize = shared.Camera.ViewportSize
                    task_wait()
                until ViewportSize.X > 5 and ViewportSize.Y > 5
            end

            local MaxX = ViewportSize.X - 64
            local MaxY = ViewportSize.Y - 64

            Library.MinSize = Vector2_new(math_min(Library.MinSize.X, MaxX), math_min(Library.MinSize.Y, MaxY))
            WindowInfo.Size = UDim2_fromOffset(
                math_clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
                math_clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
            )
            WindowInfo.Font = Library:FixFont(WindowInfo.Font)
            if WindowInfo.Font then Library.Scheme.Font = WindowInfo.Font end

            Library.CornerRadius = WindowInfo.CornerRadius
            Library:SetNotifySide(WindowInfo.NotifySide)
            Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
            Library.ToggleKeybind = WindowInfo.ToggleKeybind

            local MainFrame
            local SearchBox
            local ResizeButton
            local Tabs
            local Container
            do
                Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu(GetTranslation(Translations, "Keybinds"))
                Library.KeybindFrame.AnchorPoint = Vector2_new(0, 0.5)
                Library.KeybindFrame.Position = UDim2_new(0, 6, 0.5, 0)
                Library.KeybindFrame.Visible = false
                Library:UpdateDPI(Library.KeybindFrame, {
                    Position = false,
                    Size = false,
                })

                MainFrame = New("Frame", {
                    BackgroundColor3 = function()
                        return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
                    end,
                    AnchorPoint = Vector2_new(0.5, 0.5),
                    Position = WindowInfo.Position,
                    Size = WindowInfo.Size,
                    Visible = false,
                    Parent = ScreenGui,

                    DPIExclude = {
                        Position = true,
                    },
                })
                New("UICorner", {
                    CornerRadius = UDim_new(0, WindowInfo.CornerRadius - 1),
                    Parent = MainFrame,
                })
                do
                    local Lines = {
                        {
                            Position = UDim2_fromOffset(0, 48),
                            Size = UDim2_new(1, 0, 0, 1),
                        },
                        {
                            Position = UDim2_fromScale(0.3, 0),
                            Size = UDim2_new(0, 1, 1, -21),
                        },
                        {
                            AnchorPoint = Vector2_new(0, 1),
                            Position = UDim2_new(0, 0, 1, -20),
                            Size = UDim2_new(1, 0, 0, 1),
                        },
                    }
                    for _, Info in Lines do
                        Library:MakeLine(MainFrame, Info)
                    end
                    Library:MakeOutline(MainFrame, WindowInfo.CornerRadius, 0)
                end

                if WindowInfo.Center then
                    -- MainFrame.Position = UDim2_new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
                    MainFrame.Position = UDim2_new(0.5, -MainFrame.Size.X, 0.5, -MainFrame.Size.Y)
                end

                --// Top Bar \\-
                local TopBar = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(1, 0, 0, 48),
                    Parent = MainFrame,
                })
                Library:MakeDraggable(MainFrame, TopBar, false, true)

                --// Title
                local TitleHolder = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2_fromScale(0.3, 1),
                    Parent = TopBar,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim_new(0, 6),
                    Parent = TitleHolder,
                })

                if WindowInfo.Icon then
                    New("ImageLabel", {
                        Image = tonumber(WindowInfo.Icon) and "rbxassetid://" .. WindowInfo.Icon or WindowInfo.Icon,
                        Size = WindowInfo.IconSize,
                        Parent = TitleHolder,
                    })
                end

                local X = Library:GetTextBounds(
                    WindowInfo.Title,
                    Library.Scheme.Font,
                    20,
                    TitleHolder.AbsoluteSize.X - (WindowInfo.Icon and WindowInfo.IconSize.X.Offset + 6 or 0) - 12
                )
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_new(0, X, 1, 0),
                    Text = WindowInfo.Title,
                    TextSize = 20,
                    Parent = TitleHolder,
                })

                --// Search Box
                SearchBox = New("TextBox", {
                    AnchorPoint = Vector2_new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    PlaceholderText = GetTranslation(Translations, "Search"),
                    Position = UDim2_new(0.3, 8, 0.5, 0),
                    Size = UDim2_new(0.7, -57, 1, -16),
                    TextScaled = true,
                    ClearTextOnFocus = false,
                    Parent = TopBar,
                })
                New("UICorner", {
                    CornerRadius = UDim_new(0, WindowInfo.CornerRadius),
                    Parent = SearchBox,
                })
                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 8),
                    PaddingLeft = UDim_new(0, 8),
                    PaddingRight = UDim_new(0, 8),
                    PaddingTop = UDim_new(0, 8),
                    Parent = SearchBox,
                })
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = SearchBox,
                })

                local SearchIcon = Library:GetIcon("search")
                if SearchIcon then
                    New("ImageLabel", {
                        Image = SearchIcon.Url,
                        ImageColor3 = "FontColor",
                        ImageRectOffset = SearchIcon.ImageRectOffset,
                        ImageRectSize = SearchIcon.ImageRectSize,
                        ImageTransparency = 0.5,
                        Size = UDim2_fromScale(1, 1),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Parent = SearchBox,
                    })
                end

                local MoveIcon = Library:GetIcon("move")
                if MoveIcon then
                    New("ImageLabel", {
                        AnchorPoint = Vector2_new(1, 0.5),
                        Image = MoveIcon.Url,
                        ImageColor3 = "OutlineColor",
                        ImageRectOffset = MoveIcon.ImageRectOffset,
                        ImageRectSize = MoveIcon.ImageRectSize,
                        Position = UDim2_new(1, -10, 0.5, 0),
                        Size = UDim2_fromOffset(28, 28),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Parent = TopBar,
                    })
                end

                --// Bottom Bar //
                local BottomBar = New("Frame", {
                    AnchorPoint = Vector2_new(0, 1),
                    BackgroundColor3 = function()
                        return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
                    end,
                    Position = UDim2_fromScale(0, 1),
                    Size = UDim2_new(1, 0, 0, 20),
                    Parent = MainFrame,
                })
                do
                    local Cover = Library:MakeCover(BottomBar, "Top")
                    Library:AddToRegistry(Cover, {
                        BackgroundColor3 = function()
                            return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
                        end,
                    })
                end
                New("UICorner", {
                    CornerRadius = UDim_new(0, WindowInfo.CornerRadius - 1),
                    Parent = BottomBar,
                })

                --// Footer
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2_fromScale(1, 1),
                    Text = WindowInfo.Footer,
                    TextSize = 14,
                    TextTransparency = 0.5,
                    Parent = BottomBar,
                })

                --// Resize Button
                if WindowInfo.Resizable then
                    ResizeButton = New("TextButton", {
                        AnchorPoint = Vector2_new(1, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2_fromScale(1, 0),
                        Size = UDim2_fromScale(1, 1),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Text = "",
                        Parent = BottomBar,
                    })

                    Library:MakeResizable(MainFrame, ResizeButton, function()
                        for _, Tab in Library.Tabs do
                            Tab:Resize(true)
                        end
                    end)
                end

                New("ImageLabel", {
                    Image = ResizeIcon and ResizeIcon.Url or "",
                    ImageColor3 = "FontColor",
                    ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2_zero,
                    ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2_zero,
                    ImageTransparency = 0.5,
                    Position = UDim2_fromOffset(2, 2),
                    Size = UDim2_new(1, -4, 1, -4),
                    Parent = ResizeButton,
                })

                --// Tabs //
                Tabs = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = "BackgroundColor",
                    CanvasSize = UDim2_fromScale(0, 0),
                    Position = UDim2_fromOffset(0, 49),
                    ScrollBarThickness = 0,
                    Size = UDim2_new(0.3, 0, 1, -70),
                    Parent = MainFrame,
                })

                New("UIListLayout", {
                    Parent = Tabs,
                })

                --// Container //
                Container = New("Frame", {
                    AnchorPoint = Vector2_new(1, 0),
                    BackgroundColor3 = function()
                        return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
                    end,
                    Position = UDim2_new(1, 0, 0, 49),
                    Size = UDim2_new(0.7, -1, 1, -70),
                    Parent = MainFrame,
                })

                New("UIPadding", {
                    PaddingBottom = UDim_new(0, 0),
                    PaddingLeft = UDim_new(0, 6),
                    PaddingRight = UDim_new(0, 6),
                    PaddingTop = UDim_new(0, 0),
                    Parent = Container,
                })
            end

            --// Window Table //
            local Window = {}

            function Window:AddTab(Name: string, Icon)
                local TabButton: TextButton
                local TabLabel
                local TabIcon

                local TabContainer
                local TabLeft
                local TabRight

                local WarningBox
                local WarningTitle
                local WarningText
                local WarningStroke

                Icon = Library:GetIcon(Icon)
                do
                    TabButton = New("TextButton", {
                        BackgroundColor3 = "MainColor",
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 40),
                        Text = "",
                        Parent = Tabs,
                    })

                    New("UIPadding", {
                        PaddingBottom = UDim_new(0, 11),
                        PaddingLeft = UDim_new(0, 12),
                        PaddingRight = UDim_new(0, 12),
                        PaddingTop = UDim_new(0, 11),
                        Parent = TabButton,
                    })

                    TabLabel = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2_fromOffset(30, 0),
                        Size = UDim2_new(1, -30, 1, 0),
                        Text = Name,
                        TextSize = 16,
                        TextTransparency = 0.5,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = TabButton,
                    })

                    if Icon then
                        TabIcon = New("ImageLabel", {
                            Image = Icon.Url,
                            ImageColor3 = "AccentColor",
                            ImageRectOffset = Icon.ImageRectOffset,
                            ImageRectSize = Icon.ImageRectSize,
                            ImageTransparency = 0.5,
                            Size = UDim2_fromScale(1, 1),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Parent = TabButton,
                        })
                    end

                    --// Tab Container //
                    TabContainer = New("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2_fromScale(1, 1),
                        Visible = false,
                        Parent = Container,
                    })

                    TabLeft = New("ScrollingFrame", {
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2_fromScale(0, 0),
                        ScrollBarThickness = 0,
                        Parent = TabContainer,
                    })
                    New("UIListLayout", {
                        Padding = UDim_new(0, 6),
                        Parent = TabLeft,
                    })
                    do
                        New("Frame", {
                            BackgroundTransparency = 1,
                            LayoutOrder = -1,
                            Parent = TabLeft,
                        })
                        New("Frame", {
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Parent = TabLeft,
                        })

                        TabLeft.Size = UDim2_new(0, math_floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, 0)
                        Library:UpdateDPI(TabLeft, { Size = TabLeft.Size })
                    end

                    TabRight = New("ScrollingFrame", {
                        AnchorPoint = Vector2_new(1, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2_fromScale(0, 0),
                        Position = UDim2_fromScale(1, 0),
                        ScrollBarThickness = 0,
                        Parent = TabContainer,
                    })
                    New("UIListLayout", {
                        Padding = UDim_new(0, 6),
                        Parent = TabRight,
                    })
                    do
                        New("Frame", {
                            BackgroundTransparency = 1,
                            LayoutOrder = -1,
                            Parent = TabRight,
                        })
                        New("Frame", {
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Parent = TabRight,
                        })

                        TabRight.Size = UDim2_new(0, math_floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, 0)
                        Library:UpdateDPI(TabRight, { Size = TabRight.Size })
                    end

                    WarningBox = New("Frame", {
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Color3_fromRGB(127, 0, 0),
                        BorderColor3 = Color3_fromRGB(255, 50, 50),
                        BorderMode = Enum.BorderMode.Inset,
                        BorderSizePixel = 1,
                        Position = UDim2_fromOffset(0, 6),
                        Size = UDim2_fromScale(1, 0),
                        Visible = false,
                        Parent = TabContainer,
                    })
                    New("UIPadding", {
                        PaddingBottom = UDim_new(0, 4),
                        PaddingLeft = UDim_new(0, 6),
                        PaddingRight = UDim_new(0, 6),
                        PaddingTop = UDim_new(0, 4),
                        Parent = WarningBox,
                    })

                    WarningTitle = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 14),
                        Text = "",
                        TextColor3 = Color3_fromRGB(255, 50, 50),
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = WarningBox,
                    })
                    WarningStroke = New("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = Color3_fromRGB(169, 0, 0),
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Parent = WarningTitle,
                    })

                    WarningText = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2_fromOffset(0, 16),
                        Size = UDim2_fromScale(1, 0),
                        Text = "",
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        Parent = WarningBox,
                    })
                    New("UIStroke", {
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                        Color = "Dark",
                        LineJoinMode = Enum.LineJoinMode.Miter,
                        Parent = WarningText,
                    })
                end

                --// Tab Table //
                local Tab = {
                    Groupboxes = {},
                    Tabboxes = {},
                    Sides = {
                        TabLeft,
                        TabRight,
                    },
                }

                function Tab:UpdateWarningBox(Info)
                    if typeof(Info.Visible) == "boolean" then
                        WarningBox.Visible = Info.Visible
                        Tab:Resize()
                    end

                    if typeof(Info.Title) == "string" then
                        WarningTitle.Text = Info.Title
                    end

                    if typeof(Info.Text) == "string" then
                        local _, Y = Library:GetTextBounds(
                            Info.Text,
                            Library.Scheme.Font,
                            WarningText.TextSize,
                            WarningText.AbsoluteSize.X
                        )

                        WarningText.Size = UDim2_new(1, 0, 0, Y)
                        WarningText.Text = Info.Text
                        Library:UpdateDPI(WarningText, { Size = WarningText.Size })
                        Tab:Resize()
                    end

                    WarningBox.BackgroundColor3 = Info.IsNormal == true and Library.Scheme.BackgroundColor or Color3_fromRGB(127, 0, 0)
                    WarningBox.BorderColor3 = Info.IsNormal == true and Library.Scheme.OutlineColor or Color3_fromRGB(255, 50, 50)
                    WarningTitle.TextColor3 = Info.IsNormal == true and Library.Scheme.FontColor or Color3_fromRGB(255, 50, 50)
                    WarningStroke.Color = Info.IsNormal == true and Library.Scheme.OutlineColor or Color3_fromRGB(169, 0, 0)

                    if not Library.Registry[WarningBox] then Library:AddToRegistry(WarningBox, {}) end
                    if not Library.Registry[WarningTitle] then Library:AddToRegistry(WarningTitle, {}) end
                    if not Library.Registry[WarningStroke] then Library:AddToRegistry(WarningStroke, {}) end

                    Library.Registry[WarningBox].BackgroundColor3 = function()
                        return Info.IsNormal == true and Library.Scheme.BackgroundColor or Color3_fromRGB(127, 0, 0)
                    end

                    Library.Registry[WarningBox].BorderColor3 = function()
                        return Info.IsNormal == true and Library.Scheme.OutlineColor or Color3_fromRGB(255, 50, 50)
                    end

                    Library.Registry[WarningTitle].TextColor3 = function()
                        return Info.IsNormal == true and Library.Scheme.FontColor or Color3_fromRGB(255, 50, 50)
                    end

                    Library.Registry[WarningStroke].Color = function()
                        return Info.IsNormal == true and Library.Scheme.OutlineColor or Color3_fromRGB(169, 0, 0)
                    end
                end

                function Tab:Resize(ResizeWarningBox: boolean?)
                    if ResizeWarningBox then
                        local _, Y = Library:GetTextBounds(
                            WarningText.Text,
                            Library.Scheme.Font,
                            WarningText.TextSize,
                            WarningText.AbsoluteSize.X
                        )

                        WarningText.Size = UDim2_new(1, 0, 0, Y)
                        Library:UpdateDPI(WarningText, { Size = WarningText.Size })
                    end

                    local Offset = WarningBox.Visible and WarningBox.AbsoluteSize.Y + 6 or 0
                    for _, Side in Tab.Sides do
                        Side.Position = UDim2_new(Side.Position.X.Scale, 0, 0, Offset)
                        Side.Size = UDim2_new(0, math_floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, -Offset)
                        Library:UpdateDPI(Side, {
                            Position = Side.Position,
                            Size = Side.Size,
                        })
                    end
                end

                function Tab:AddGroupbox(Info)
                    local Background = Library:MakeOutline(Info.Side == 1 and TabLeft or TabRight, WindowInfo.CornerRadius)
                    Background.Size = UDim2_fromScale(1, 0)
                    Library:UpdateDPI(Background, {
                        Size = false,
                    })

                    local GroupboxHolder
                    local GroupboxLabel

                    local GroupboxContainer
                    local GroupboxList

                    do
                        GroupboxHolder = New("Frame", {
                            BackgroundColor3 = "BackgroundColor",
                            Position = UDim2_fromOffset(2, 2),
                            Size = UDim2_new(1, -4, 1, -4),
                            Parent = Background,
                        })
                        New("UICorner", {
                            CornerRadius = UDim_new(0, WindowInfo.CornerRadius - 1),
                            Parent = GroupboxHolder,
                        })
                        Library:MakeLine(GroupboxHolder, {
                            Position = UDim2_fromOffset(0, 34),
                            Size = UDim2_new(1, 0, 0, 1),
                        })

                        GroupboxLabel = New("TextLabel", {
                            BackgroundTransparency = 1,
                            Size = UDim2_new(1, 0, 0, 34),
                            Text = Info.Name,
                            TextSize = 15,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = GroupboxHolder,
                        })
                        New("UIPadding", {
                            PaddingLeft = UDim_new(0, 12),
                            PaddingRight = UDim_new(0, 12),
                            Parent = GroupboxLabel,
                        })

                        GroupboxContainer = New("Frame", {
                            BackgroundTransparency = 1,
                            Position = UDim2_fromOffset(0, 35),
                            Size = UDim2_new(1, 0, 1, -35),
                            Parent = GroupboxHolder,
                        })

                        GroupboxList = New("UIListLayout", {
                            Padding = UDim_new(0, 8),
                            Parent = GroupboxContainer,
                        })
                        New("UIPadding", {
                            PaddingBottom = UDim_new(0, 7),
                            PaddingLeft = UDim_new(0, 7),
                            PaddingRight = UDim_new(0, 7),
                            PaddingTop = UDim_new(0, 7),
                            Parent = GroupboxContainer,
                        })
                    end

                    local Groupbox = {
                        Holder = Background,
                        Container = GroupboxContainer,
                        Elements = {},
                    }

                    function Groupbox:Resize()
                        Background.Size = UDim2_new(1, 0, 0, GroupboxList.AbsoluteContentSize.Y + 53 * Library.DPIScale)
                    end

                    setmetatable(Groupbox, BaseGroupbox)

                    Groupbox:Resize()
                    Tab.Groupboxes[Info.Name] = Groupbox

                    return Groupbox
                end

                function Tab:AddLeftGroupbox(Name)
                    return Tab:AddGroupbox({ Side = 1, Name = Name })
                end

                function Tab:AddRightGroupbox(Name)
                    return Tab:AddGroupbox({ Side = 2, Name = Name })
                end

                function Tab:AddTabbox(Info)
                    local Background = Library:MakeOutline(Info.Side == 1 and TabLeft or TabRight, WindowInfo.CornerRadius)
                    Background.Size = UDim2_fromScale(1, 0)
                    Library:UpdateDPI(Background, {
                        Size = false,
                    })

                    local TabboxHolder
                    local TabboxButtons

                    do
                        TabboxHolder = New("Frame", {
                            BackgroundColor3 = "BackgroundColor",
                            Position = UDim2_fromOffset(2, 2),
                            Size = UDim2_new(1, -4, 1, -4),
                            Parent = Background,
                        })
                        New("UICorner", {
                            CornerRadius = UDim_new(0, WindowInfo.CornerRadius - 1),
                            Parent = TabboxHolder,
                        })

                        TabboxButtons = New("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2_new(1, 0, 0, 34),
                            Parent = TabboxHolder,
                        })
                        New("UIListLayout", {
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            Parent = TabboxButtons,
                        })
                    end

                    local Tabbox = {
                        ActiveTab = nil,

                        Holder = Background,
                        Tabs = {},
                    }

                    function Tabbox:AddTab(Name)
                        local Button = New("TextButton", {
                            BackgroundColor3 = "MainColor",
                            BackgroundTransparency = 0,
                            Size = UDim2_fromOffset(0, 34),
                            Text = Name,
                            TextSize = 15,
                            TextTransparency = 0.5,
                            Parent = TabboxButtons,
                        })

                        local Line = Library:MakeLine(Button, {
                            AnchorPoint = Vector2_new(0, 1),
                            Position = UDim2_new(0, 0, 1, 1),
                            Size = UDim2_new(1, 0, 0, 1),
                        })

                        local Container = New("Frame", {
                            BackgroundTransparency = 1,
                            Position = UDim2_fromOffset(0, 35),
                            Size = UDim2_new(1, 0, 1, -35),
                            Visible = false,
                            Parent = TabboxHolder,
                        })
                        local List = New("UIListLayout", {
                            Padding = UDim_new(0, 8),
                            Parent = Container,
                        })
                        New("UIPadding", {
                            PaddingBottom = UDim_new(0, 7),
                            PaddingLeft = UDim_new(0, 7),
                            PaddingRight = UDim_new(0, 7),
                            PaddingTop = UDim_new(0, 7),
                            Parent = Container,
                        })

                        local Tab = {
                            ButtonHolder = Button,
                            Container = Container,

                            Elements = {},
                        }

                        function Tab:Show()
                            if Tabbox.ActiveTab then
                                Tabbox.ActiveTab:Hide()
                            end

                            Button.BackgroundTransparency = 1
                            Button.TextTransparency = 0
                            Line.Visible = false

                            Container.Visible = true

                            Tabbox.ActiveTab = Tab
                            Tab:Resize()
                        end

                        function Tab:Hide()
                            Button.BackgroundTransparency = 0
                            Button.TextTransparency = 0.5
                            Line.Visible = true
                            Container.Visible = false

                            Tabbox.ActiveTab = nil
                        end

                        function Tab:Resize()
                            if Tabbox.ActiveTab ~= Tab then
                                return
                            end
                            Background.Size = UDim2_new(1, 0, 0, List.AbsoluteContentSize.Y + 53 * Library.DPIScale)
                        end

                        --// Execution //
                        if not Tabbox.ActiveTab then
                            Tab:Show()
                        end

                        Connect(Button.MouseButton1Click, Tab.Show)

                        setmetatable(Tab, BaseGroupbox)

                        Tabbox.Tabs[Name] = Tab

                        return Tab
                    end

                    if Info.Name then
                        Tab.Tabboxes[Info.Name] = Tabbox
                    else
                        table_insert(Tab.Tabboxes, Tabbox)
                    end

                    return Tabbox
                end

                function Tab:AddLeftTabbox(Name)
                    return Tab:AddTabbox({ Side = 1, Name = Name })
                end

                function Tab:AddRightTabbox(Name)
                    return Tab:AddTabbox({ Side = 2, Name = Name })
                end

                function Tab:Hover(Hovering)
                    if Library.ActiveTab == Tab then
                        return
                    end

                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = Hovering and 0.25 or 0.5,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = Hovering and 0.25 or 0.5,
                        }))
                    end
                end

                function Tab:Show()
                    if Library.ActiveTab then
                        Library.ActiveTab:Hide()
                    end

                    Play(TweenService_Create(TweenService, TabButton, Library.TweenInfo, {
                        BackgroundTransparency = 0,
                    }))
                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = 0,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = 0,
                        }))
                    end
                    TabContainer.Visible = true

                    Library.ActiveTab = Tab
                end

                function Tab:Hide()
                    Play(TweenService_Create(TweenService, TabButton, Library.TweenInfo, {
                        BackgroundTransparency = 1,
                    }))
                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = 0.5,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = 0.5,
                        }))
                    end
                    TabContainer.Visible = false

                    Library.ActiveTab = nil
                end

                --// Execution //
                if not Library.ActiveTab then
                    Tab:Show()
                end

                Connect(TabButton.MouseEnter, function()
                    Tab:Hover(true)
                end)
                Connect(TabButton.MouseLeave, function()
                    Tab:Hover(false)
                end)
                Connect(TabButton.MouseButton1Click, Tab.Show)

                Library.Tabs[Name] = Tab

                return Tab
            end

            function Window:AddKeyTab(Name)
                local TabButton: TextButton
                local TabLabel
                local TabIcon

                local TabContainer

                do
                    TabButton = New("TextButton", {
                        BackgroundColor3 = "MainColor",
                        BackgroundTransparency = 1,
                        Size = UDim2_new(1, 0, 0, 40),
                        Text = "",
                        Parent = Tabs,
                    })
                    New("UIPadding", {
                        PaddingBottom = UDim_new(0, 11),
                        PaddingLeft = UDim_new(0, 12),
                        PaddingRight = UDim_new(0, 12),
                        PaddingTop = UDim_new(0, 11),
                        Parent = TabButton,
                    })

                    TabLabel = New("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2_fromOffset(30, 0),
                        Size = UDim2_new(1, -30, 1, 0),
                        Text = Name,
                        TextSize = 16,
                        TextTransparency = 0.5,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = TabButton,
                    })

                    if KeyIcon then
                        TabIcon = New("ImageLabel", {
                            Image = KeyIcon.Url,
                            ImageColor3 = "AccentColor",
                            ImageRectOffset = KeyIcon.ImageRectOffset,
                            ImageRectSize = KeyIcon.ImageRectSize,
                            ImageTransparency = 0.5,
                            Size = UDim2_fromScale(1, 1),
                            SizeConstraint = Enum.SizeConstraint.RelativeYY,
                            Parent = TabButton,
                        })
                    end

                    --// Tab Container //
                    TabContainer = New("ScrollingFrame", {
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2_fromScale(0, 0),
                        ScrollBarThickness = 0,
                        Size = UDim2_fromScale(1, 1),
                        Visible = false,
                        Parent = Container,
                    })
                    New("UIListLayout", {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim_new(0, 8),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Parent = TabContainer,
                    })
                    New("UIPadding", {
                        PaddingLeft = UDim_new(0, 1),
                        PaddingRight = UDim_new(0, 1),
                        Parent = TabContainer,
                    })
                end

                --// Tab Table //
                local Tab = {
                    Elements = {},
                    IsKeyTab = true,
                }

                function Tab:AddKeyBox(...)
                    local Data = {}

                    local First = select(1, ...)

                    if typeof(First) == "function" then
                        Data.Callback = First
                    else
                        Data.ExpectedKey = First
                        Data.Callback = select(2, ...)
                    end

                    local Holder = New("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2_new(0.75, 0, 0, 21),
                        Parent = TabContainer,
                    })

                    local Box = New("TextBox", {
                        BackgroundColor3 = "MainColor",
                        BorderColor3 = "OutlineColor",
                        BorderSizePixel = 1,
                        PlaceholderText = GetTranslation(Translations, "Key"),
                        Size = UDim2_new(1, -71, 1, 0),
                        TextSize = 14,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Holder,
                    })
                    New("UIPadding", {
                        PaddingLeft = UDim_new(0, 8),
                        PaddingRight = UDim_new(0, 8),
                        Parent = Box,
                    })

                    local Button = New("TextButton", {
                        AnchorPoint = Vector2_new(1, 0),
                        BackgroundColor3 = "MainColor",
                        BorderColor3 = "OutlineColor",
                        BorderSizePixel = 1,
                        Position = UDim2_fromScale(1, 0),
                        Size = UDim2_new(0, 63, 1, 0),
                        Text = GetTranslation(Translations, "Execute"),
                        TextSize = 14,
                        Parent = Holder,
                    })

                    Connect(Button.MouseButton1Click, function()
                        if Data.ExpectedKey and Box.Text ~= Data.ExpectedKey then
                            Data.Callback(false, Box.Text)
                            return
                        end

                        Data.Callback(true, Box.Text)
                    end)
                end

                function Tab:Resize() end

                function Tab:Hover(Hovering)
                    if Library.ActiveTab == Tab then
                        return
                    end

                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = Hovering and 0.25 or 0.5,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = Hovering and 0.25 or 0.5,
                        }))
                    end
                end

                function Tab:Show()
                    if Library.ActiveTab then
                        Library.ActiveTab:Hide()
                    end

                    Play(TweenService_Create(TweenService, TabButton, Library.TweenInfo, {
                        BackgroundTransparency = 0,
                    }))
                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = 0,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = 0,
                        }))
                    end
                    TabContainer.Visible = true

                    Library.ActiveTab = Tab
                end

                function Tab:Hide()
                    Play(TweenService_Create(TweenService, TabButton, Library.TweenInfo, {
                        BackgroundTransparency = 1,
                    }))
                    Play(TweenService_Create(TweenService, TabLabel, Library.TweenInfo, {
                        TextTransparency = 0.5,
                    }))
                    if TabIcon then
                        Play(TweenService_Create(TweenService, TabIcon, Library.TweenInfo, {
                            ImageTransparency = 0.5,
                        }))
                    end
                    TabContainer.Visible = false

                    Library.ActiveTab = nil
                end

                --// Execution //
                if not Library.ActiveTab then
                    Tab:Show()
                end

                Connect(TabButton.MouseEnter, function()
                    Tab:Hover(true)
                end)
                Connect(TabButton.MouseLeave, function()
                    Tab:Hover(false)
                end)
                Connect(TabButton.MouseButton1Click, Tab.Show)

                Tab.Container = TabContainer
                setmetatable(Tab, BaseGroupbox)

                Library.Tabs[Name] = Tab

                return Tab
            end

            function Library:Toggle(Value: boolean?)
                if typeof(Value) == "boolean" then
                    if Value == Library.Toggle then return end
                    Library.Toggled = Value
                else
                    Library.Toggled = not Library.Toggled
                end

                MainFrame.Visible = Library.Toggled
                ModalElement.Modal = Library.Toggled

                if Library.Toggled and not Library.IsMobile then
                    local OldMouseIconEnabled = UserInputService.MouseIconEnabled

                    shared.Connect:UnbindRenderStep("ShowCursor")
                    shared.Connect:BindRenderStep("ShowCursor", Enum.RenderPriority.Last.Value, function()
                        UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                        Cursor.Position = UDim2_fromOffset(Mouse.X, Mouse.Y)
                        Cursor.Visible = Library.ShowCustomCursor

                        if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                            UserInputService.MouseIconEnabled = OldMouseIconEnabled
                            Cursor.Visible = false
                            shared.Connect:UnbindRenderStep("ShowCursor")
                        end
                    end)
                elseif not Library.Toggled then
                    TooltipLabel.Visible = false
                    for _, Option in Library.Options do
                        if Option.Type == "ColorPicker" then
                            Option.ColorMenu:Close()
                            Option.ContextMenu:Close()
                        elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                            Option.Menu:Close()
                        end
                    end
                end
            end

            if WindowInfo.AutoShow then
                task_spawn(Library.Toggle)
            end

            if Library.IsMobile then
                local ToggleButton = Library:AddDraggableButton(GetTranslation(Translations, "Toggle"), function()
                    Library:Toggle()
                end)

                local LockButton = Library:AddDraggableButton(GetTranslation(Translations, "Lock"), function(self)
                    Library.CantDragForced = not Library.CantDragForced
                    self:SetText(Library.CantDragForced and GetTranslation(Translations, "Unlock") or GetTranslation(Translations, "Lock"))
                end)

                if WindowInfo.MobileButtonsSide == "Right" then
                    ToggleButton.Button.Position = UDim2_new(1, -6, 0, 6)
                    ToggleButton.Button.AnchorPoint = Vector2_new(1, 0)

                    LockButton.Button.Position = UDim2_new(1, -6, 0, 46)
                    LockButton.Button.AnchorPoint = Vector2_new(1, 0)
                else
                    LockButton.Button.Position = UDim2_fromOffset(6, 46)
                end
            end

            --// Execution //
            local LastTab
            Connect(GetPropertyChangedSignal(SearchBox, "Text"), function()
                --// Reset Elements Visibility in Last Tab Searched
                if LastTab then
                    for _, Groupbox in LastTab.Groupboxes do
                        for _, ElementInfo in Groupbox.Elements do
                            ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible
                                or true

                            if ElementInfo.SubButton then
                                ElementInfo.Base.Visible = ElementInfo.Visible
                                ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                            end
                        end

                        Groupbox:Resize()
                        Groupbox.Holder.Visible = true
                    end

                    for _, Tabbox in LastTab.Tabboxes do
                        for _, Tab in Tabbox.Tabs do
                            for _, ElementInfo in Tab.Elements do
                                ElementInfo.Holder.Visible = typeof(ElementInfo.Visible) == "boolean" and ElementInfo.Visible
                                    or true

                                if ElementInfo.SubButton then
                                    ElementInfo.Base.Visible = ElementInfo.Visible
                                    ElementInfo.SubButton.Base.Visible = ElementInfo.SubButton.Visible
                                end
                            end

                            Tab.ButtonHolder.Visible = true
                        end

                        Tabbox.ActiveTab:Resize()
                        Tabbox.Holder.Visible = true
                    end
                end

                --// Cancel Search if Search Text is empty
                local Search = string_lower(SearchBox.Text)
                if Trim(Search) == "" or not Library.ActiveTab or Library.ActiveTab.IsKeyTab then
                    LastTab = nil
                    return
                end

                --// Loop through Groupboxes to get Elements Info
                for _, Groupbox in Library.ActiveTab.Groupboxes do
                    local VisibleElements = 0

                    for _, ElementInfo in Groupbox.Elements do
                        if ElementInfo.Type == "Divider" then
                            ElementInfo.Holder.Visible = false
                            continue
                        elseif ElementInfo.SubButton then
                            --// Check if any of the Buttons Name matches with Search
                            local Visible = false

                            --// Check if Search matches Element's Name and if Element is Visible
                            if string_match(string_lower(ElementInfo.Text), Search) and ElementInfo.Visible then
                                Visible = true
                            else
                                ElementInfo.Base.Visible = false
                            end
                            if string_match(string_lower(ElementInfo.SubButton.Text), Search) and ElementInfo.SubButton.Visible then
                                Visible = true
                            else
                                ElementInfo.SubButton.Base.Visible = false
                            end
                            ElementInfo.Holder.Visible = Visible
                            if Visible then
                                VisibleElements += 1
                            end

                            continue
                        end

                        --// Check if Search matches Element's Name and if Element is Visible
                        if ElementInfo.Text and string_match(string_lower(ElementInfo.Text), Search) and ElementInfo.Visible then
                            ElementInfo.Holder.Visible = true
                            VisibleElements += 1
                        else
                            ElementInfo.Holder.Visible = false
                        end
                    end

                    --// Update Groupbox Size and Visibility if found any element
                    if VisibleElements > 0 then
                        Groupbox:Resize()
                    end
                    Groupbox.Holder.Visible = VisibleElements > 0
                end

                for _, Tabbox in Library.ActiveTab.Tabboxes do
                    local VisibleTabs = 0
                    local VisibleElements = {}

                    for _, Tab in Tabbox.Tabs do
                        VisibleElements[Tab] = 0

                        for _, ElementInfo in Tab.Elements do
                            if ElementInfo.Type == "Divider" then
                                ElementInfo.Holder.Visible = false
                                continue
                            elseif ElementInfo.SubButton then
                                --// Check if any of the Buttons Name matches with Search
                                local Visible = false

                                --// Check if Search matches Element's Name and if Element is Visible
                                if string_match(string_lower(ElementInfo.Text), Search) and ElementInfo.Visible then
                                    Visible = true
                                else
                                    ElementInfo.Base.Visible = false
                                end
                                if string_match(string_lower(ElementInfo.SubButton.Text), Search) and ElementInfo.SubButton.Visible then
                                    Visible = true
                                else
                                    ElementInfo.SubButton.Base.Visible = false
                                end
                                ElementInfo.Holder.Visible = Visible
                                if Visible then
                                    VisibleElements[Tab] += 1
                                end

                                continue
                            end

                            --// Check if Search matches Element's Name and if Element is Visible
                            if string_match(string_lower(ElementInfo.Text), Search) and ElementInfo.Visible then
                                ElementInfo.Holder.Visible = true
                                VisibleElements[Tab] += 1
                            else
                                ElementInfo.Holder.Visible = false
                            end
                        end
                    end

                    for Tab, Visible in VisibleElements do
                        Tab.ButtonHolder.Visible = Visible > 0
                        if Visible > 0 then
                            VisibleTabs += 1

                            if Tabbox.ActiveTab == Tab then
                                Tab:Resize()
                            elseif VisibleElements[Tabbox.ActiveTab] == 0 then
                                Tab:Show()
                            end
                        end
                    end

                    --// Update Tabbox Visibility if any visible
                    Tabbox.Holder.Visible = VisibleTabs > 0
                end

                --// Set Last Tab to Current One
                LastTab = Library.ActiveTab
            end)

            table_insert(Library.WindowFrames, MainFrame)
            return Window
        end

        local function OnPlayerChange()
            local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)

            for _, Dropdown in Options do
                if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
                    Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
                end
            end
        end
        local function OnTeamChange()
            local TeamList = GetTeams()

            for _, Dropdown in Options do
                if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
                    Dropdown:SetValues(TeamList)
                end
            end
        end

        Library:GiveSignal(Connect(shared.Players.PlayerAdded, OnPlayerChange))
        Library:GiveSignal(Connect(shared.Players.PlayerRemoving, OnPlayerChange))

        Library:GiveSignal(Connect(shared.Teams.ChildAdded, OnTeamChange))
        Library:GiveSignal(Connect(shared.Teams.ChildRemoved, OnTeamChange))

        return Library
    end,

    [54] = function(shared, wax, script, require)
        --// Source by deividcomsono //

        local httpService = shared.HttpService
        local Translations = wax.shared.Translations
        local GetTranslation = Translations.GetTranslation
        local isfolder, isfile, listfiles = isfolder, isfile, listfiles

        local copyfunction = copyfunction or clonefunction

        if typeof(copyfunction) == "function" then
            -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

            local isfolder_copy = copyfunction(isfolder)
            local isfile_copy = copyfunction(isfile)
            local listfiles_copy = copyfunction(listfiles)

            local isfolder_success, isfolder_error = pcall(function()
                return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
            end)

            if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
                isfolder = function(folder)
                    local success, data = pcall(isfolder_copy, folder)
                    return (if success then data else false)
                end

                isfile = function(file)
                    local success, data = pcall(isfile_copy, file)
                    return (if success then data else false)
                end

                listfiles = function(folder)
                    local success, data = pcall(listfiles_copy, folder)
                    return (if success then data else {})
                end
            end
        end

        local SaveManager = {} do
            SaveManager.Folder = "ObsidianLibSettings"
            SaveManager.SubFolder = ""
            SaveManager.Ignore = {}
            SaveManager.Library = nil
            SaveManager.Parser = {
                Toggle = {
                    Save = function(idx, object)
                        return { type = "Toggle", idx = idx, value = object.Value }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Toggles[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                Slider = {
                    Save = function(idx, object)
                        return { type = "Slider", idx = idx, value = tostring(object.Value) }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                Dropdown = {
                    Save = function(idx, object)
                        return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.value then
                            object:SetValue(data.value)
                        end
                    end,
                },
                ColorPicker = {
                    Save = function(idx, object)
                        return { type = "ColorPicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
                    end,
                    Load = function(idx, data)
                        if SaveManager.Library.Options[idx] then
                            SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                        end
                    end,
                },
                KeyPicker = {
                    Save = function(idx, object)
                        return { type = "KeyPicker", idx = idx, mode = object.Mode, key = object.Value }
                    end,
                    Load = function(idx, data)
                        if SaveManager.Library.Options[idx] then
                            SaveManager.Library.Options[idx]:SetValue({ data.key, data.mode })
                        end
                    end,
                },
                Input = {
                    Save = function(idx, object)
                        return { type = "Input", idx = idx, text = object.Value }
                    end,
                    Load = function(idx, data)
                        local object = SaveManager.Library.Options[idx]
                        if object and object.Value ~= data.text and type(data.text) == "string" then
                            SaveManager.Library.Options[idx]:SetValue(data.text)
                        end
                    end,
                },
            }

            function SaveManager:SetLibrary(library)
                self.Library = library
            end

            function SaveManager:IgnoreThemeSettings()
                self:SetIgnoreIndexes({
                    "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", -- themes
                    "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName", -- themes
                })
            end

            --// Folders \\--
            function SaveManager:CheckSubFolder(createFolder)
                if typeof(self.SubFolder) ~= "string" or self.SubFolder == "" then return false end

                if createFolder == true then
                    if not isfolder(self.Folder .. "/settings/" .. self.SubFolder) then
                        makefolder(self.Folder .. "/settings/" .. self.SubFolder)
                    end
                end

                return true
            end

            function SaveManager:GetPaths()
                local paths = {}

                local parts = self.Folder:split("/")
                for idx = 1, #parts do
                    local path = table.concat(parts, "/", 1, idx)
                    if not table.find(paths, path) then paths[#paths + 1] = path end
                end

                paths[#paths + 1] = self.Folder .. "/themes"
                paths[#paths + 1] = self.Folder .. "/settings"

                if self:CheckSubFolder(false) then
                    local subFolder = self.Folder .. "/settings/" .. self.SubFolder
                    parts = subFolder:split("/")

                    for idx = 1, #parts do
                        local path = table.concat(parts, "/", 1, idx)
                        if not table.find(paths, path) then paths[#paths + 1] = path end
                    end
                end

                return paths
            end

            function SaveManager:BuildFolderTree()
                local paths = self:GetPaths()

                for i = 1, #paths do
                    local str = paths[i]
                    if isfolder(str) then continue end

                    makefolder(str)
                end
            end

            function SaveManager:CheckFolderTree()
                if isfolder(self.Folder) then return end
                SaveManager:BuildFolderTree()

                task.wait(0.1)
            end

            function SaveManager:SetIgnoreIndexes(list)
                for _, key in list do
                    self.Ignore[key] = true
                end
            end

            function SaveManager:SetFolder(folder)
                self.Folder = folder
                self:BuildFolderTree()
            end

            function SaveManager:SetSubFolder(folder)
                self.SubFolder = folder
                self:BuildFolderTree()
            end

            --// Save, Load, Delete, Refresh \\--
            function SaveManager:Save(name)
                if (not name) then
                    return false, GetTranslation(Translations, "no config file is selected")
                end
                SaveManager:CheckFolderTree()

                local fullPath = self.Folder .. "/settings/" .. name .. ".json"
                if SaveManager:CheckSubFolder(true) then
                    fullPath = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
                end

                local data = {
                    objects = {}
                }

                for idx, toggle in self.Library.Toggles do
                    if not toggle.Type then continue end
                    if not self.Parser[toggle.Type] then continue end
                    if self.Ignore[idx] then continue end

                    table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
                end

                for idx, option in self.Library.Options do
                    if not option.Type then continue end
                    if not self.Parser[option.Type] then continue end
                    if self.Ignore[idx] then continue end

                    table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
                end

                local success, encoded = pcall(httpService.JSONEncode, httpService, data)
                if not success then
                    return false, GetTranslation(Translations, "failed to encode data")
                end

                writefile(fullPath, encoded)
                return true
            end

            function SaveManager:Load(name)
                if (not name) then
                    return false, GetTranslation(Translations, "no config file is selected")
                end
                SaveManager:CheckFolderTree()

                local file = self.Folder .. "/settings/" .. name .. ".json"
                if SaveManager:CheckSubFolder(true) then
                    file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
                end

                if not isfile(file) then return false, GetTranslation(Translations, "invalid file") end

                local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
                if not success then return false, GetTranslation(Translations, "decode error") end

                for _, option in decoded.objects do
                    if not option.type then continue end
                    if not self.Parser[option.type] then continue end

                    task.spawn(self.Parser[option.type].Load, option.idx, option) -- task.spawn() so the config loading wont get stuck.
                end

                return true
            end

            function SaveManager:Delete(name)
                if (not name) then
                    return false, GetTranslation(Translations, "no config file is selected")
                end

                local file = self.Folder .. "/settings/" .. name .. ".json"
                if SaveManager:CheckSubFolder(true) then
                    file = self.Folder .. "/settings/" .. self.SubFolder .. "/" .. name .. ".json"
                end

                if not isfile(file) then return false, GetTranslation(Translations, "invalid file") end

                local success = pcall(delfile, file)
                if not success then return false, GetTranslation(Translations, "delete file error") end

                return true
            end

            function SaveManager:RefreshConfigList()
                local success, data = pcall(function()
                    SaveManager:CheckFolderTree()

                    local list = {}
                    local out = {}

                    if SaveManager:CheckSubFolder(true) then
                        list = listfiles(self.Folder .. "/settings/" .. self.SubFolder)
                    else
                        list = listfiles(self.Folder .. "/settings")
                    end
                    if typeof(list) ~= "table" then list = {} end

                    for i = 1, #list do
                        local file = list[i]
                        if file:sub(-5) == ".json" then
                            -- i hate this but it has to be done ...

                            local pos = file:find(".json", 1, true)
                            local start = pos

                            local char = file:sub(pos, pos)
                            while char ~= "/" and char ~= "\\" and char ~= "" do
                                pos = pos - 1
                                char = file:sub(pos, pos)
                            end

                            if char == "/" or char == "\\" then
                                table.insert(out, file:sub(pos + 1, start - 1))
                            end
                        end
                    end

                    return out
                end)

                if (not success) then
                    if self.Library then
                        self.Library:Notify(GetTranslation(Translations, "Failed to load config list: ") .. tostring(data))
                    else
                        warn(GetTranslation(Translations, "Failed to load config list: ") .. tostring(data))
                    end

                    return {}
                end

                return data
            end

            --// Auto Load \\--
            function SaveManager:GetAutoloadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                if isfile(autoLoadPath) then
                    local successRead, name = pcall(readfile, autoLoadPath)
                    if not successRead then
                        return "none"
                    end

                    name = tostring(name)
                    return if name == "" then "none" else name
                end

                return "none"
            end

            function SaveManager:LoadAutoloadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                if isfile(autoLoadPath) then
                    local successRead, name = pcall(readfile, autoLoadPath)
                    if not successRead then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to load autoload config: write file error"))
                    end

                    local success, err = self:Load(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to load autoload config: ") .. err)
                    end

                    return self.Library:Notify(string.format(GetTranslation(Translations, "Auto loaded config %q"), name))
                end
                return
            end

            function SaveManager:SaveAutoloadConfig(name)
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                local success = pcall(writefile, autoLoadPath, name)
                if not success then return false, GetTranslation(Translations, "write file error") end

                return true, ""
            end

            function SaveManager:DeleteAutoLoadConfig()
                SaveManager:CheckFolderTree()

                local autoLoadPath = self.Folder .. "/settings/autoload.txt"
                if SaveManager:CheckSubFolder(true) then
                    autoLoadPath = self.Folder .. "/settings/" .. self.SubFolder .. "/autoload.txt"
                end

                local success = pcall(delfile, autoLoadPath)
                if not success then return false, GetTranslation(Translations, "delete file error") end

                return true, ""
            end

            --// GUI \\--
            function SaveManager:BuildConfigSection(tab)
                assert(self.Library, "Must set SaveManager.Library")

                local section = tab:AddRightGroupbox(GetTranslation(Translations, "Configuration"))

                section:AddInput("SaveManager_ConfigName",     { Text = GetTranslation(Translations, "Config name") })
                section:AddButton(GetTranslation(Translations, "Create config"), function()
                    local name = self.Library.Options.SaveManager_ConfigName.Value

                    if name:gsub(" ", "") == "" then
                        return self.Library:Notify(GetTranslation(Translations, "Invalid config name (empty)"), 2)
                    end

                    local success, err = self:Save(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to create config: ") .. err)
                    end

                    self.Library:Notify(string.format(GetTranslation(Translations, "Created config %q"), name))

                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                    return
                end)

                section:AddDivider()

                section:AddDropdown("SaveManager_ConfigList", { Text = GetTranslation(Translations, "Config list"), Values = self:RefreshConfigList(), AllowNull = true })
                section:AddButton(GetTranslation(Translations, "Load config"), function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Load(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to load config: ") .. err)
                    end

                    return self.Library:Notify(string.format(GetTranslation(Translations, "Loaded config %q"), name))
                end)
                section:AddButton(GetTranslation(Translations, "Overwrite config"), function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Save(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to overwrite config: ") .. err)
                    end

                    return self.Library:Notify(string.format(GetTranslation(Translations, "Overwrote config %q"), name))
                end)

                section:AddButton(GetTranslation(Translations, "Delete config"), function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to delete config: ") .. err)
                    end

                    self.Library:Notify(string.format(GetTranslation(Translations, "Deleted config %q"), name))
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                    return
                end)

                section:AddButton(GetTranslation(Translations, "Refresh list"), function()
                    self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                    self.Library.Options.SaveManager_ConfigList:SetValue(nil)
                end)

                local autoloadBtn = section:AddButton(GetTranslation(Translations, "Set as autoload"))

                local resetAutoloadBtn = section:AddButton(GetTranslation(Translations, "Reset autoload"))

                self.AutoloadLabel = section:AddLabel(GetTranslation(Translations, "Current autoload config: ") .. self:GetAutoloadConfig(), true)

                autoloadBtn.Func = function()
                    local name = self.Library.Options.SaveManager_ConfigList.Value

                    local success, err = self:SaveAutoloadConfig(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to set autoload config: ") .. err)
                    end

                    self.AutoloadLabel:SetText(GetTranslation(Translations, "Current autoload config: ") .. name)
                    return self.Library:Notify(string.format(GetTranslation(Translations, "Set %q to auto load"), name))
                end

                resetAutoloadBtn.Func = function()
                    local success, err = self:DeleteAutoLoadConfig()
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to set autoload config: ") .. err)
                    end

                    self.AutoloadLabel:SetText(GetTranslation(Translations, "Current autoload config: none"))
                    return self.Library:Notify(GetTranslation(Translations, "Set autoload to none"))
                end

                -- self:LoadAutoloadConfig()
                self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
            end

            SaveManager:BuildFolderTree()
        end

        return SaveManager
    end,

    [55] = function(shared, wax, script, require)
        --// Source by deividcomsono //

        local httpService = shared.HttpService
        local Translations = wax.shared.Translations
        local GetTranslation = Translations.GetTranslation
        local isfolder, isfile, listfiles = isfolder, isfile, listfiles

        local copyfunction = copyfunction or clonefunction

        if typeof(copyfunction) == "function" then
            -- Fix is_____ functions for shitsploits, those functions should never error, only return a boolean.

            local isfolder_copy = copyfunction(isfolder)
            local isfile_copy = copyfunction(isfile)
            local listfiles_copy = copyfunction(listfiles)

            local isfolder_success, isfolder_error = pcall(function()
                return isfolder_copy("test" .. tostring(math.random(1000000, 9999999)))
            end)

            if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
                isfolder = function(folder)
                    local success, data = pcall(isfolder_copy, folder)
                    return (if success then data else false)
                end

                isfile = function(file)
                    local success, data = pcall(isfile_copy, file)
                    return (if success then data else false)
                end

                listfiles = function(folder)
                    local success, data = pcall(listfiles_copy, folder)
                    return (if success then data else {})
                end
            end
        end

        local ThemeManager = {} do
            ThemeManager.Folder = "ObsidianLibSettings"
            -- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

            ThemeManager.Library = nil
            ThemeManager.BuiltInThemes = {
                ["Default"]      = { 1,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191919","AccentColor":"7d55ff","BackgroundColor":"0f0f0f","OutlineColor":"282828"}]]) },
                ["BBot"]         = { 2,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}]]) },
                ["Fatality"]     = { 3,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}]]) },
                ["Jester"]       = { 4,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
                ["Mint"]         = { 5,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}]]) },
                ["Tokyo Night"]  = { 6,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}]]) },
                ["Ubuntu"]       = { 7,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}]]) },
                ["Quartz"]       = { 8,  httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}]]) },
                ["Nord"]         = { 9,  httpService:JSONDecode([[{"FontColor":"eceff4","MainColor":"3b4252","AccentColor":"88c0d0","BackgroundColor":"2e3440","OutlineColor":"4c566a"}]]) },
                ["Dracula"]      = { 10, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"44475a","AccentColor":"ff79c6","BackgroundColor":"282a36","OutlineColor":"6272a4"}]]) },
                ["Monokai"]      = { 11, httpService:JSONDecode([[{"FontColor":"f8f8f2","MainColor":"272822","AccentColor":"f92672","BackgroundColor":"1e1f1c","OutlineColor":"49483e"}]]) },
                ["Gruvbox"]      = { 12, httpService:JSONDecode([[{"FontColor":"ebdbb2","MainColor":"3c3836","AccentColor":"fb4934","BackgroundColor":"282828","OutlineColor":"504945"}]]) },
                ["Solarized"]    = { 13, httpService:JSONDecode([[{"FontColor":"839496","MainColor":"073642","AccentColor":"cb4b16","BackgroundColor":"002b36","OutlineColor":"586e75"}]]) },
                ["Catppuccin"]   = { 14, httpService:JSONDecode([[{"FontColor":"d9e0ee","MainColor":"302d41","AccentColor":"f5c2e7","BackgroundColor":"1e1e2e","OutlineColor":"575268"}]]) },
                ["One Dark"]     = { 15, httpService:JSONDecode([[{"FontColor":"abb2bf","MainColor":"282c34","AccentColor":"c678dd","BackgroundColor":"21252b","OutlineColor":"5c6370"}]]) },
                ["Cyberpunk"]    = { 16, httpService:JSONDecode([[{"FontColor":"f9f9f9","MainColor":"262335","AccentColor":"00ff9f","BackgroundColor":"1a1a2e","OutlineColor":"413c5e"}]]) },
                ["Oceanic Next"] = { 17, httpService:JSONDecode([[{"FontColor":"d8dee9","MainColor":"1b2b34","AccentColor":"6699cc","BackgroundColor":"16232a","OutlineColor":"343d46"}]]) },
                ["Material"]     = { 18, httpService:JSONDecode([[{"FontColor":"eeffff","MainColor":"212121","AccentColor":"82aaff","BackgroundColor":"151515","OutlineColor":"424242"}]]) },
                ["GitHub Dark"]  = { 18, httpService:JSONDecode([[{"FontColor":"ffffff","MainColor":"0d1117","AccentColor":"1f6feb","BackgroundColor":"010409","OutlineColor":"1f242b"}]]) }
            }

            function ThemeManager:SetLibrary(library)
                self.Library = library
            end

            --// Folders \\--
            function ThemeManager:GetPaths()
                local paths = {}

                local parts = self.Folder:split("/")
                for idx = 1, #parts do
                    paths[#paths + 1] = table.concat(parts, "/", 1, idx)
                end

                paths[#paths + 1] = self.Folder .. "/themes"

                return paths
            end

            function ThemeManager:BuildFolderTree()
                local paths = self:GetPaths()

                for i = 1, #paths do
                    local str = paths[i]
                    if isfolder(str) then continue end
                    makefolder(str)
                end
            end

            function ThemeManager:CheckFolderTree()
                if isfolder(self.Folder) then return end
                self:BuildFolderTree()

                task.wait(0.1)
            end

            function ThemeManager:SetFolder(folder)
                self.Folder = folder
                self:BuildFolderTree()
            end

            --// Apply, Update theme \\--
            function ThemeManager:ApplyTheme(theme)
                local customThemeData = self:GetCustomTheme(theme)
                local data = customThemeData or self.BuiltInThemes[theme]

                if not data then return end

                local scheme = data[2]
                for idx, val in customThemeData or scheme do
                    if idx == "VideoLink" then
                        continue
                    elseif idx == "FontFace" then
                        self.Library:SetFont(Enum.Font[val])
                        wax.shared.FirstFont = Enum.Font[val]

                        if self.Library.Options[idx] then
                            self.Library.Options[idx]:SetValue(val)
                        end
                    else
                        self.Library.Scheme[idx] = Color3.fromHex(val)

                        if self.Library.Options[idx] then
                            self.Library.Options[idx]:SetValueRGB(Color3.fromHex(val))
                        end
                    end
                end

                self:ThemeUpdate()
            end

            function ThemeManager:ThemeUpdate()
                local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
                for i, field in options do
                    if self.Library.Options and self.Library.Options[field] then
                        self.Library.Scheme[field] = self.Library.Options[field].Value
                    end
                end

                self.Library:UpdateColorsUsingRegistry()
            end

            --// Get, Load, Save, Delete, Refresh \\--
            function ThemeManager:GetCustomTheme(file)
                local path = self.Folder .. "/themes/" .. file .. ".json"
                if not isfile(path) then
                    return nil
                end

                local data = readfile(path)
                local success, decoded = pcall(httpService.JSONDecode, httpService, data)

                if not success then
                    return nil
                end

                return decoded
            end

            function ThemeManager:LoadDefault()
                local theme = "GitHub Dark"
                local content = isfile(self.Folder .. "/themes/default.txt") and readfile(self.Folder .. "/themes/default.txt")

                local isDefault = true
                if content then
                    if self.BuiltInThemes[content] then
                        theme = content
                    elseif self:GetCustomTheme(content) then
                        theme = content
                        isDefault = false
                    end
                elseif self.BuiltInThemes[self.DefaultTheme] then
                    theme = self.DefaultTheme
                end

                if isDefault then
                    self.Library.Options.ThemeManager_ThemeList:SetValue(theme)
                else
                    self:ApplyTheme(theme)
                end
            end

            function ThemeManager:SaveDefault(theme)
                writefile(self.Folder .. "/themes/default.txt", theme)
            end

            function ThemeManager:SaveCustomTheme(file)
                if file:gsub(" ", "") == "" then
                    return self.Library:Notify(GetTranslation(Translations, "Invalid file name for theme (empty)"), 3)
                end

                local theme = {}
                local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

                for _, field in fields do
                    theme[field] = self.Library.Options[field].Value:ToHex()
                end
                theme["FontFace"] = self.Library.Options["FontFace"].Value

                writefile(self.Folder .. "/themes/" .. file .. ".json", httpService:JSONEncode(theme))
                return
            end

            function ThemeManager:Delete(name)
                if (not name) then
                    return false, GetTranslation(Translations, "no config file is selected")
                end

                local file = self.Folder .. "/themes/" .. name .. ".json"
                if not isfile(file) then return false, GetTranslation(Translations, "invalid file") end

                local success = pcall(delfile, file)
                if not success then return false, GetTranslation(Translations, "delete file error") end

                return true
            end

            function ThemeManager:ReloadCustomThemes()
                local list = listfiles(self.Folder .. "/themes")

                local out = {}
                for i = 1, #list do
                    local file = list[i]
                    if file:sub(-5) == ".json" then
                        -- i hate this but it has to be done ...

                        local pos = file:find(".json", 1, true)
                        local start = pos

                        local char = file:sub(pos, pos)
                        while char ~= "/" and char ~= "\\" and char ~= "" do
                            pos = pos - 1
                            char = file:sub(pos, pos)
                        end

                        if char == "/" or char == "\\" then
                            table.insert(out, file:sub(pos + 1, start - 1))
                        end
                    end
                end

                return out
            end

            --// GUI \\--
            function ThemeManager:CreateThemeManager(groupbox)
                groupbox:AddLabel(GetTranslation(Translations, "Background color")):AddColorPicker("BackgroundColor", { Default = self.Library.Scheme.BackgroundColor })
                groupbox:AddLabel(GetTranslation(Translations, "Main color")):AddColorPicker("MainColor", { Default = self.Library.Scheme.MainColor })
                groupbox:AddLabel(GetTranslation(Translations, "Accent color")):AddColorPicker("AccentColor", { Default = self.Library.Scheme.AccentColor })
                groupbox:AddLabel(GetTranslation(Translations, "Outline color")):AddColorPicker("OutlineColor", { Default = self.Library.Scheme.OutlineColor })
                groupbox:AddLabel(GetTranslation(Translations, "Font color")):AddColorPicker("FontColor", { Default = self.Library.Scheme.FontColor })
                groupbox:AddDropdown("FontFace", {
                    Text = GetTranslation(Translations, "Font Face"),
                    Default = "BuilderSans",
                    Values = {"BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans"}
                })

                local ThemesArray = {}
                for Name, Theme in self.BuiltInThemes do
                    table.insert(ThemesArray, Name)
                end

                table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

                groupbox:AddDivider()

                groupbox:AddDropdown("ThemeManager_ThemeList", { Text = GetTranslation(Translations, "Theme list"), Values = ThemesArray, Default = 1 })
                groupbox:AddButton(GetTranslation(Translations, "Set as default"), function()
                    self:SaveDefault(self.Library.Options.ThemeManager_ThemeList.Value)
                    self.Library:Notify(string.format(GetTranslation(Translations, "Set default theme to %q"), self.Library.Options.ThemeManager_ThemeList.Value))
                end)

                self.Library.Options.ThemeManager_ThemeList:OnChanged(function()
                    self:ApplyTheme(self.Library.Options.ThemeManager_ThemeList.Value)
                end)

                groupbox:AddDivider()

                groupbox:AddInput("ThemeManager_CustomThemeName", { Text = GetTranslation(Translations, "Custom theme name") })
                groupbox:AddButton(GetTranslation(Translations, "Create theme"), function()
                    self:SaveCustomTheme(self.Library.Options.ThemeManager_CustomThemeName.Value)

                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end)

                groupbox:AddDivider()

                groupbox:AddDropdown("ThemeManager_CustomThemeList", { Text = GetTranslation(Translations, "Custom themes"), Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
                groupbox:AddButton(GetTranslation(Translations, "Load theme"), function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:ApplyTheme(name)
                    self.Library:Notify(string.format(GetTranslation(Translations, "Loaded theme %q"), name))
                end)
                groupbox:AddButton(GetTranslation(Translations, "Overwrite theme"), function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    self:SaveCustomTheme(name)
                    self.Library:Notify(string.format(GetTranslation(Translations, "Overwrote config %q"), name))
                end)
                groupbox:AddButton(GetTranslation(Translations, "Delete theme"), function()
                    local name = self.Library.Options.ThemeManager_CustomThemeList.Value

                    local success, err = self:Delete(name)
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to delete theme: ") .. err)
                    end

                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                    return self.Library:Notify(string.format(GetTranslation(Translations, "Deleted theme %q"), name))
                end)
                groupbox:AddButton(GetTranslation(Translations, "Refresh list"), function()
                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                end)
                groupbox:AddButton(GetTranslation(Translations, "Set as default"), function()
                    if self.Library.Options.ThemeManager_CustomThemeList.Value ~= nil and self.Library.Options.ThemeManager_CustomThemeList.Value ~= "" then
                        self:SaveDefault(self.Library.Options.ThemeManager_CustomThemeList.Value)
                        self.Library:Notify(string.format(GetTranslation(Translations, "Set default theme to %q"), self.Library.Options.ThemeManager_CustomThemeList.Value))
                    end
                end)
                groupbox:AddButton(GetTranslation(Translations, "Reset default"), function()
                    local success = pcall(delfile, self.Folder .. "/themes/default.txt")
                    if not success then
                        return self.Library:Notify(GetTranslation(Translations, "Failed to reset default: delete file error"))
                    end

                    self.Library.Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                    self.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
                    return self.Library:Notify(GetTranslation(Translations, "Set default theme to nothing"))
                end)

                local function UpdateTheme() self:ThemeUpdate() end
                self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
                self.Library.Options.MainColor:OnChanged(UpdateTheme)
                self.Library.Options.AccentColor:OnChanged(UpdateTheme)
                self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
                self.Library.Options.FontColor:OnChanged(UpdateTheme)
                self.Library.Options.FontFace:OnChanged(function(Value)
                    self.Library:SetFont(Enum.Font[Value])
                    self.Library:UpdateColorsUsingRegistry()
                end)
            end

            function ThemeManager:CreateGroupBox(tab)
                assert(self.Library, GetTranslation(Translations, "Must set ThemeManager.Library first!"))
                return tab:AddLeftGroupbox(GetTranslation(Translations, "Themes"))
            end

            function ThemeManager:ApplyToTab(tab)
                assert(self.Library, GetTranslation(Translations, "Must set ThemeManager.Library first!"))
                local groupbox = self:CreateGroupBox(tab)
                self:CreateThemeManager(groupbox)
            end

            function ThemeManager:ApplyToGroupbox(groupbox)
                assert(self.Library, GetTranslation(Translations, "Must set ThemeManager.Library first!"))
                self:CreateThemeManager(groupbox)
            end

            ThemeManager:BuildFolderTree()
        end

        return ThemeManager
    end,

    [56] = function(shared, wax, script, require)
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
    end,

    [57] = function(shared, wax, script, require)
        return {}
    end,

    [58] = function(shared, wax, script, require)
        --// Source by mstudio45 //

        local Instance_new, Vector2_new, Vector3_new, Color3_new, Path2DControlPoint_new, UDim2_new, UDim2_fromOffset, CFrame_new, CFrame_Angles
            = Instance.new, Vector2.new, Vector3.new, Color3.new, Path2DControlPoint.new, UDim2.new, UDim2.fromOffset, CFrame.new, CFrame.Angles

        local table_clone, table_find, table_remove, table_clear, coroutine_resume, coroutine_create, coroutine_yield, coroutine_close
            = table.clone, table.find, table.remove, table.clear, coroutine.resume, coroutine.create, coroutine.yield, coroutine.close

        local math_rad, math_cos, math_atan2, math_deg, math_sin, math_floor, string_match, string_format
            = math.rad, math.cos, math.atan2, math.deg, math.sin, math.floor, string.match, string.format

        local randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof
            = randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof

        local      IsA,      Destroy,                                 Disconnect: (RBXScriptConnection) -> nil
            = game.IsA, game.Destroy, game.Close:Once(function() end).Disconnect

        local UserInputService = shared.UserInputService
        local GetMouseLocation = UserInputService.GetMouseLocation

        local _VERSION = "2.0.2";

        type TracerESPSettings = {
            Enabled: boolean,

            Color: Color3?,
            Thickness: number?,
            Transparency: number?,
            From: Vector2 | "Top" | "Bottom" | "Center" | "Mouse",

            To: Vector2?,
        }

        type ArrowESPSettings = {
            Enabled: boolean,

            Color: Color3?,
            CenterOffset: number?,
        }

        type ESPSettings = {
            Name: string?,

            Model: Object,
            TextModel: Object?,

            Visible: boolean?,
            Color: Color3?,
            MaxDistance: number?,

            StudsOffset: Vector3?,
            TextSize: number?,

            ESPType: "Text" | "SphereAdornment" | "CylinderAdornment" | "Adornment" | "SelectionBox" | "Highlight",
            Thickness: number?,
            Transparency: number?,

            SurfaceColor: Color3?,
            BorderColor: Color3?,

            FillColor: Color3?,
            OutlineColor: Color3?,

            FillTransparency: number?,
            OutlineTransparency: number?,

            Tracer: TracerESPSettings?,
            Arrow: ArrowESPSettings?,

            OnDestroy: BindableEvent?,
            OnDestroyFunc: (() -> nil)?,

            ModelRoot: Instance?,
        }

        --// Variables //
        local tablefreeze = function<T>(provided_table: T & {}): any
            local proxy = {}
            local data = table_clone(provided_table)

            local mt = {
                __index = function(table, key)
                    return data[key]
                end,

                __newindex = function(table, key, value)
                    -- nope --
                end
            }

            return setmetatable(proxy, mt) :: any
        end

        --// Functions //
        local GetPivot = (function()
            local CFrame_identity
                = CFrame.identity

            local GetPivot = Instance_new("Part").GetPivot

            return function(Instance: Bone | Attachment | Camera | PVInstance | any): CFrame
                if IsA(Instance, "Bone") then
                    return Instance.TransformedWorldCFrame
                elseif IsA(Instance, "Attachment") then
                    return Instance.WorldCFrame
                elseif IsA(Instance, "Camera") then
                    return Instance.CFrame
                elseif IsA(Instance, "PVInstance") then
                    return GetPivot(Instance :: PVInstance)
                end

                return CFrame_identity
            end
        end)()

        --// Instances //
        local InstancesLib = {
            Create = function(instanceType, properties): Instance
                assert(typeof(instanceType) == "string", "Argument #1 must be a string.")
                assert(typeof(properties) == "table", "Argument #2 must be a table.")

                local instance = Instance_new(instanceType)
                instance.Name = randomstring()

                for name, val in properties do
                    if name == "Parent" then
                        continue --/ Parenting is expensive, do last.
                    end

                    (instance :: any)[name] = val
                end

                instance["Parent"] = properties["Parent"]

                return instance :: typeof(instance)
            end,

            TryGetProperty = function(instance: Instance | Object?, propertyName): any
                assert(typeof(instance) == "Instance", "Argument #1 must be an Instance.")
                assert(typeof(propertyName) == "string", "Argument #2 must be a string.")

                local success, property = pcall(function()
                    return (instance :: any)[propertyName]
                end)

                return if success then property else nil;
            end,

            FindPrimaryPart = function(instance): any | Instance
                if typeof(instance) ~= "Instance" then
                    return nil
                end

                local Primary = "PrimaryPart"

                return (IsA(instance, "Model") and instance[Primary] or nil)
                    or instance:FindFirstChildWhichIsA("BasePart")
                    or instance:FindFirstChildWhichIsA("UnionOperation")
                    or instance;
            end,

            DistanceFrom = function(inst, from): number
                if not (inst and from) then
                    return 9e9;
                end

                local position = if typeof(inst) == "Instance" then GetPivot(inst).Position else inst;
                local fromPosition = if typeof(from) == "Instance" then GetPivot(from).Position else from;

                return (fromPosition - position).Magnitude;
            end
        }

        --// GUI //
        local ActiveFolder = InstancesLib.Create("Folder", {})

        local StorageFolder = InstancesLib.Create("Folder", {})

        local MainGUI = InstancesLib.Create("ScreenGui", {
            Parent = gethui(),
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ClipToDeviceSafeArea = false,
            OnTopOfCoreBlur = true,
            DisplayOrder = 1e6
        })

        local BillboardGUI = InstancesLib.Create("ScreenGui", {
            Parent = gethui(),
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ClipToDeviceSafeArea = false,
            OnTopOfCoreBlur = true,
            DisplayOrder = 1e6
        })

        --// Library //
        local Library = {
            Destroyed = false,

            --// Storages
            ActiveFolder = ActiveFolder,
            StorageFolder = StorageFolder,
            MainGUI = MainGUI,
            BillboardGUI = BillboardGUI,
            ESP = {},
            Connections = {} :: { RBXScriptConnection },

            --// Global Config
            GlobalConfig = {
                IgnoreCharacter = false,
                Rainbow = false,

                Billboards = true,
                Highlighters = true,
                Distance = true,
                Tracers = true,
                Arrows = true,

                Font = wax.shared.FirstFont or Enum.Font.SourceSans
            },

            --// Rainbow Variables
            RainbowSpeed = 0.4,
            RainbowColor = Color3_new()
        }

        --// Player Variables //
        local character: Model
        local rootPart: Part?
        local Camera: Camera = shared.Camera

        local WorldToViewportPoint = Camera.WorldToViewportPoint

        local function UpdatePlayerVariables(newCharacter: any, force: boolean?)
            if force ~= true and Library.GlobalConfig.IgnoreCharacter == true then
                return
            end

            character = newCharacter or shared.Players.LocalPlayer.Character or shared.Players.LocalPlayer.CharacterAdded:Wait();
            rootPart = (
                character:WaitForChild("HumanoidRootPart", 2.5)
                or character:WaitForChild("UpperTorso", 2.5)
                or character:WaitForChild("Torso", 2.5)
                or character.PrimaryPart
                or character:WaitForChild("Head", 2.5)
            ) :: Part;
        end
        task.spawn(UpdatePlayerVariables, nil, true);

        --// Library Functions //
        local PublicESPDestroy

        function Library:Clear()
            if Library.Destroyed == true then
                return
            end

            for _, ESP in Library.ESP do
                if not ESP then continue end

                if not PublicESPDestroy then
                    PublicESPDestroy = (ESP :: any).Destroy
                end
                PublicESPDestroy(ESP)
            end
        end

        function Library:Destroy()
            if Library.Destroyed == true then
                return
            end

            Library.Destroyed = true;
            Library:Clear();

            Destroy(ActiveFolder);
            Destroy(StorageFolder);
            Destroy(MainGUI);
            Destroy(BillboardGUI);

            --// Clear connections
            for _, connection in Library.Connections do
                if not connection.Connected then
                    continue
                end

                Disconnect(connection)
            end

            table_clear(Library)
        end

        --// Type Checks //
        local AllowedTracerFrom = {
            Top = true,
            Bottom = true,
            Center = true,
            Mouse = true,
        }

        local AllowedESPType = {
            Text = true,
            Sphereadornment = true,
            Cylinderadornment = true,
            Adornment = true,
            Selectionbox = true,
            Highlight = true,
        }

        --// ESP Instances //
        local function TracerCreate(espSettings: TracerESPSettings, instanceName: string?)
            if Library.Destroyed == true then
                return
            end

            if not espSettings or espSettings.Enabled ~= true then
                return
            end

            --// Fix Settings
            espSettings.Color = typeof(espSettings.Color) == "Color3" and espSettings.Color or Color3_new()
            espSettings.Thickness = typeof(espSettings.Thickness) == "number" and espSettings.Thickness or 2
            espSettings.Transparency = typeof(espSettings.Transparency) == "number" and espSettings.Transparency or 0
            espSettings.From = typeof(espSettings.From) == "string" and espSettings.From or "Bottom"
            if AllowedTracerFrom[espSettings.From] == nil then
                espSettings.From = "Bottom"
            end

            --// Create Path2D
            local Path2D = (InstancesLib.Create("Path2D", {
                Parent = MainGUI,
                Name = if typeof(instanceName) == "string" then instanceName else "Tracer",
                Closed = true,

                --// Settings
                Color3 = espSettings.Color,
                Thickness = espSettings.Thickness,
                Transparency = espSettings.Transparency,
            }) :: Path2D)

            local SetControlPoints = Path2D.SetControlPoints

            local function UpdateTracer(from: Vector2, to: Vector2)
                SetControlPoints(Path2D, {
                    Path2DControlPoint_new(UDim2_fromOffset(from.X, from.Y)),
                    Path2DControlPoint_new(UDim2_fromOffset(to.X, to.Y))
                })
            end

            --// Data Table
            local data = {
                From = if typeof(espSettings.From) == "Vector2" then espSettings.From else Vector2_new(0, 0),
                To = if typeof(espSettings.To) == "Vector2" then espSettings.To else Vector2_new(0, 0),

                Visible = true,
                Color3 = espSettings.Color,
                Thickness = espSettings.Thickness,
                Transparency = espSettings.Transparency,
            }
            UpdateTracer((data.From :: Vector2), (data.To :: Vector2));

            --// Tracer Metatable
            local proxy = {}
            local Tracer = {
                __newindex = function(table, key, value)
                    if not Path2D then
                        return
                    end

                    if key == "From" then
                        assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                        UpdateTracer(value, (data.To :: Vector2))

                    elseif key == "To" then
                        assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                        UpdateTracer((data.From :: Vector2), value)

                    elseif key == "Transparency" or key == "Thickness" then
                        assert(typeof(value) == "number", tostring(key) .. "; expected number, got " .. typeof(value));
                        (Path2D :: any)[key] = value

                    elseif key == "Color3" then
                        assert(typeof(value) == "Color3", tostring(key) .. "; expected Color3, got " .. typeof(value));
                        (Path2D :: any).Color3 = value

                    elseif key == "Visible" then
                        assert(typeof(value) == "boolean", tostring(key) .. "; expected boolean, got " .. typeof(value))

                        Path2D.Parent = if value then MainGUI else StorageFolder;
                    end

                    data[key] = value
                end,

                __index = function(table, key)
                    if not Path2D then
                        return nil
                    end

                    if key == "Destroy" or key == "Delete" then
                        return (function()
                            SetControlPoints(Path2D, {});
                            Path2D = Destroy(Path2D);
                        end) :: any
                    end

                    return (data :: any)[key]
                end,
            }

            return setmetatable(proxy, Tracer)
        end

        function Library:Add(espSettings: ESPSettings)
            if Library.Destroyed == true then
                return
            end

            assert(typeof(espSettings) == "table", "espSettings; expected table, got " .. typeof(espSettings))
            assert(
                typeof(espSettings.Model) == "Instance",
                "espSettings.Model; expected Instance, got " .. typeof(espSettings.Model)
            )

            --// Fix ESPType
            if not espSettings.ESPType then
                espSettings.ESPType = "Highlight"
            end
            assert(
                typeof(espSettings.ESPType) == "string",
                "espSettings.ESPType; expected string, got " .. typeof(espSettings.ESPType)
            )

            assert(AllowedESPType[espSettings.ESPType] == true, "espSettings.ESPType; invalid ESPType")

            --// Fix Settings
            local Name = "Name"

            espSettings.Name = if typeof(espSettings.Name) == "string" then espSettings[Name] else (espSettings.Model :: any)[Name];
            espSettings.TextModel = if typeof(espSettings.TextModel) == "Instance" then espSettings.TextModel else espSettings.Model;

            espSettings.Visible = if typeof(espSettings.Visible) == "boolean" then espSettings.Visible else true;
            espSettings.Color = if typeof(espSettings.Color) == "Color3" then espSettings.Color else Color3_new();
            espSettings.MaxDistance = if typeof(espSettings.MaxDistance) == "number" then espSettings.MaxDistance else 5000;

            espSettings.StudsOffset = if typeof(espSettings.StudsOffset) == "Vector3" then espSettings.StudsOffset else Vector3_new();
            espSettings.TextSize = if typeof(espSettings.TextSize) == "number" then espSettings.TextSize else 16;

            espSettings.Thickness = if typeof(espSettings.Thickness) == "number" then espSettings.Thickness else 0.1;
            espSettings.Transparency = if typeof(espSettings.Transparency) == "number" then espSettings.Transparency else 0.65;

            espSettings.SurfaceColor = if typeof(espSettings.SurfaceColor) == "Color3" then espSettings.SurfaceColor else Color3_new();
            espSettings.BorderColor = if typeof(espSettings.BorderColor) == "Color3" then espSettings.BorderColor else Color3_new();

            espSettings.FillColor = if typeof(espSettings.FillColor) == "Color3" then espSettings.FillColor else Color3_new();
            espSettings.OutlineColor = if typeof(espSettings.OutlineColor) == "Color3" then espSettings.OutlineColor else Color3_new(1, 1, 1);

            espSettings.FillTransparency = if typeof(espSettings.FillTransparency) == "number" then espSettings.FillTransparency else 0.65;
            espSettings.OutlineTransparency = if typeof(espSettings.OutlineTransparency) == "number" then espSettings.OutlineTransparency else 0;

            espSettings.Tracer = if typeof(espSettings.Tracer) == "table" then espSettings.Tracer else { Enabled = false, From = "Bottom" };
            espSettings.Arrow = if typeof(espSettings.Arrow) == "table" then espSettings.Arrow else { Enabled = false };

            --// ESP Data //
            local ESP = {
                Index = randomstring(),
                OriginalSettings = tablefreeze(espSettings),
                CurrentSettings = espSettings,

                Hidden = false,
                Deleted = false,
                Connections = {} :: { RBXScriptConnection },
                RenderThread = nil :: thread?
            } :: table

            --// Create Billboard
            local Billboard = (InstancesLib.Create("BillboardGui", {
                Parent = BillboardGUI,
                Name = ESP.Index,

                Enabled = true,
                ResetOnSpawn = false,
                AlwaysOnTop = true,
                Size = UDim2_new(0, 200, 0, 50),

                --// Settings
                Adornee = ESP.CurrentSettings.TextModel or ESP.CurrentSettings.Model,
                StudsOffset = ESP.CurrentSettings.StudsOffset or Vector3_new(),
            }) :: BillboardGui)

            local BillboardText = (InstancesLib.Create("TextLabel", {
                Parent = Billboard,

                Size = UDim2_new(0, 200, 0, 50),
                Font = Library.GlobalConfig.Font,
                TextWrap = true,
                TextWrapped = true,
                RichText = true,
                TextStrokeTransparency = 0,
                BackgroundTransparency = 1,

                --// Settings
                Text = ESP.CurrentSettings.Name,
                TextColor3 = ESP.CurrentSettings.Color or Color3_new(),
                TextSize = ESP.CurrentSettings.TextSize or 16,
            }) :: TextLabel)

            InstancesLib.Create("UIStroke", {
                Parent = BillboardText
            })

            --// Create Highlighter
            local Highlighter: any, IsAdornment = nil, not not string_match(ESP.OriginalSettings.ESPType, "Adornment")

            if IsAdornment then
                local _, ModelSize
                if ESP.CurrentSettings.Model:IsA("Model") then
                    _, ModelSize = ESP.CurrentSettings.Model:GetBoundingBox()
                elseif ESP.CurrentSettings.Model:IsA("BasePart") then
                    ModelSize = ESP.CurrentSettings.Model.Size
                elseif not InstancesLib.TryGetProperty(ESP.CurrentSettings.Model, "Size") then
                    local prim = InstancesLib.FindPrimaryPart(ESP.CurrentSettings.Model)
                    if not InstancesLib.TryGetProperty(prim, "Size") then
                        espSettings.ESPType = "Highlight"
                        return Library:Add(espSettings)
                    end

                    ModelSize = prim.Size
                end

                if ESP.OriginalSettings.ESPType == "Sphereadornment" then
                    Highlighter = InstancesLib.Create("SphereHandleAdornment", {
                        Parent = ActiveFolder,
                        Name = ESP.Index,

                        Adornee = ESP.CurrentSettings.Model,

                        AlwaysOnTop = true,
                        ZIndex = 10,

                        Radius = ModelSize.X * 1.085,
                        CFrame = CFrame_new() * CFrame_Angles(math_rad(90), 0, 0),

                        --// Settings
                        Color3 = ESP.CurrentSettings.Color or Color3_new(),
                        Transparency = ESP.CurrentSettings.Transparency or 0.65,
                    })
                elseif ESP.OriginalSettings.ESPType == "Cylinderadornment" then
                    Highlighter = InstancesLib.Create("CylinderHandleAdornment", {
                        Parent = ActiveFolder,
                        Name = ESP.Index,

                        Adornee = ESP.CurrentSettings.Model,

                        AlwaysOnTop = true,
                        ZIndex = 10,

                        Height = ModelSize.Y * 2,
                        Radius = ModelSize.X * 1.085,
                        CFrame = CFrame_new() * CFrame_Angles(math_rad(90), 0, 0),

                        --// Settings
                        Color3 = ESP.CurrentSettings.Color or Color3_new(),
                        Transparency = ESP.CurrentSettings.Transparency or 0.65,
                    })
                else
                    Highlighter = InstancesLib.Create("BoxHandleAdornment", {
                        Parent = ActiveFolder,
                        Name = ESP.Index,

                        Adornee = ESP.CurrentSettings.Model,

                        AlwaysOnTop = true,
                        ZIndex = 10,

                        Size = ModelSize,

                        --// Settings
                        Color3 = ESP.CurrentSettings.Color or Color3_new(),
                        Transparency = ESP.CurrentSettings.Transparency or 0.65,
                    })
                end
            elseif ESP.OriginalSettings.ESPType == "Selectionbox" then
                Highlighter = InstancesLib.Create("SelectionBox", {
                    Parent = ActiveFolder,
                    Name = ESP.Index,

                    Adornee = ESP.CurrentSettings.Model,

                    Color3 = ESP.CurrentSettings.BorderColor or Color3_new(),
                    LineThickness = ESP.CurrentSettings.Thickness or 0.1,

                    SurfaceColor3 = ESP.CurrentSettings.SurfaceColor or Color3_new(),
                    SurfaceTransparency = ESP.CurrentSettings.Transparency or 0.65,
                })
            elseif ESP.OriginalSettings.ESPType == "Highlight" then
                Highlighter = InstancesLib.Create("Highlight", {
                    Parent = ActiveFolder,
                    Name = ESP.Index,

                    Adornee = ESP.CurrentSettings.Model,

                    --// Settings
                    FillColor = ESP.CurrentSettings.FillColor or Color3_new(),
                    OutlineColor = ESP.CurrentSettings.OutlineColor or Color3_new(1, 1, 1),

                    FillTransparency = ESP.CurrentSettings.FillTransparency or 0.65,
                    OutlineTransparency = ESP.CurrentSettings.OutlineTransparency or 0,
                })
            end

            --// Create Tracer and Arrow
            local TracerData = ESP.CurrentSettings.Tracer :: TracerESPSettings?
            local Tracer = if typeof(TracerData) == "table" then TracerCreate((TracerData :: TracerESPSettings), ESP.Index) else nil;

            local ArrowData = ESP.CurrentSettings.Arrow :: ArrowESPSettings?
            local Arrow = nil :: ImageLabel?;

            if typeof(ArrowData) == "table" then
                Arrow = (InstancesLib.Create("ImageLabel", {
                    Parent = MainGUI,
                    Name = ESP.Index,

                    Size = UDim2_new(0, 48, 0, 48),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,

                    AnchorPoint = Vector2_new(0.5, 0.5),

                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,

                    Image = "http://www.roblox.com/asset/?id=16368985219",
                    ImageColor3 = ESP.CurrentSettings.Color or Color3_new(),
                }) :: ImageLabel);

                (ArrowData :: table).CenterOffset = if typeof((ArrowData :: table).CenterOffset) == "number" then (ArrowData :: table).CenterOffset else 300;
            end

            --// Setup Delete Handler
            function ESP:Destroy()
                if self.Deleted == true then
                    return;
                end

                self.Deleted = true

                if self.RenderThread then
                    pcall(coroutine.close, self.RenderThread)
                end

                if table_find(Library.ESP, self.Index) then
                    table_remove(Library.ESP, table_find(Library.ESP, self.Index))
                end

                Library.ESP[self.Index] = nil

                --// Delete ESP Instances
                if Billboard then Destroy(Billboard) end
                if Highlighter then Destroy(Highlighter) end
                if Tracer then Destroy(Tracer) end
                if Arrow then Destroy(Arrow) end

                --// Clear connections
                for _, connection in self.Connections do
                    if not connection.Connected then
                        continue
                    end

                    Disconnect(connection)
                end

                table_clear(self.Connections)

                --// OnDestroy
                if self.OriginalSettings.OnDestroy then
                    pcall(self.OriginalSettings.OnDestroy.Fire, self.OriginalSettings.OnDestroy)
                end

                if self.OriginalSettings.OnDestroyFunc then
                    pcall(self.OriginalSettings.OnDestroyFunc)
                end
            end

            --// Setup Update Handler
            local function Show(forceShow: boolean?)
                if not (ESP and ESP.Deleted ~= true) then return end
                if forceShow ~= true and not ESP.Hidden then
                    return
                end

                ESP.Hidden = false;

                --// Apply to Instances
                Billboard.Enabled = true;

                if Highlighter then
                    Highlighter.Adornee = ESP.CurrentSettings.Model;
                    Highlighter.Parent = ActiveFolder;
                end

                if Tracer then
                    Tracer.Visible = true;
                end

                if Arrow then
                    Arrow.Visible = true;
                end
            end

            local function Hide(forceHide: boolean?)
                if not (ESP and ESP.Deleted ~= true) then return end
                if forceHide ~= true and ESP.Hidden then
                    return
                end

                ESP.Hidden = true

                --// Apply to Instances
                Billboard.Enabled = false;

                if Highlighter then
                    Highlighter.Adornee = nil;
                    Highlighter.Parent = StorageFolder;
                end

                if Tracer then
                    Tracer.Visible = false;
                end

                if Arrow then
                    Arrow.Visible = false;
                end
            end

            function ESP:Show(force: boolean?)
                ESP.CurrentSettings.Visible = true
                Show(force);
            end

            function ESP:Hide(force: boolean?)
                if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then return end

                ESP.CurrentSettings.Visible = false
                Hide(force);
            end

            function ESP:ToggleVisibility(force: boolean?)
                ESP.CurrentSettings.Visible = not ESP.CurrentSettings.Visible
                if ESP.CurrentSettings.Visible then
                    Show(force);
                else
                    Hide(force);
                end
            end

            function ESP:Render()
                if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then return end
                if
                    ESP.CurrentSettings.Visible == false or
                    not Camera or
                    (if Library.GlobalConfig.IgnoreCharacter == true then false else not rootPart)
                then
                    Hide()
                    return
                end

                --// Check Distance
                if not ESP.CurrentSettings.ModelRoot then
                    ESP.CurrentSettings.ModelRoot = InstancesLib.FindPrimaryPart(ESP.CurrentSettings.Model)
                end

                local ModelRoot = ESP.CurrentSettings.ModelRoot :: Instance
                local screenPos, isOnScreen = WorldToViewportPoint(
                    Camera,
                    GetPivot(ModelRoot or ESP.CurrentSettings.Model).Position
                )

                local distanceFromPlayer = InstancesLib.DistanceFrom(
                    (ModelRoot or ESP.CurrentSettings.Model),
                    (if Library.GlobalConfig.IgnoreCharacter == true then (Camera or rootPart) else rootPart)
                )

                if distanceFromPlayer > (ESP.CurrentSettings.MaxDistance :: number) then
                    Hide()
                    return
                end

                --// Update Arrow (only requires distance check) //
                if Arrow then
                    local ArrowData = ESP.CurrentSettings.Arrow :: ArrowESPSettings
                    Arrow.Visible = Library.GlobalConfig.Arrows == true and ArrowData.Enabled == true and (isOnScreen ~= true)

                    if Arrow.Visible then
                        local screenSize = Camera.ViewportSize
                        local centerPos = screenSize / 2

                        --[[use aspect to make oval circle
                        local aspectRatioX = screenSize.X / screenSize.Y;
                        local aspectRatioY = screenSize.Y / screenSize.X;
                        local arrowPosPixel = Vector2_new(
                            arrowTable.ArrowInstance.Position.X.Scale,
                            arrowTable.ArrowInstance.Position.Y.Scale
                        ) * 1000;]]
                        local partPos = Vector2_new(screenPos.X, screenPos.Y)

                        local IsInverted = screenPos.Z <= 0
                        local invert = (IsInverted and -1 or 1)

                        local direction = (partPos - centerPos)
                        local arctan = math_atan2(direction.Y, direction.X)
                        local angle = math_deg(arctan) + 90
                        local distance = ((ArrowData.CenterOffset :: number) * 0.001) * screenSize.Y

                        Arrow.Rotation = angle + 180 * (IsInverted and 0 or 1)
                        Arrow.Position = UDim2_new(
                            0,
                            centerPos.X + (distance * math_cos(arctan) * invert),
                            0,
                            centerPos.Y + (distance * math_sin(arctan) * invert)
                        )
                        Arrow.ImageColor3 =
                            (if Library.GlobalConfig.Rainbow then Library.RainbowColor else ArrowData.Color :: Color3);
                    end
                end

                if isOnScreen == false then
                    Hide()
                    return
                else Show() end

                --// Update Tracer //
                if Tracer then
                    local TracerData = ESP.CurrentSettings.Tracer :: TracerESPSettings
                    Tracer.Visible = Library.GlobalConfig.Tracers == true and TracerData.Enabled == true;

                    if Tracer.Visible then
                        if TracerData.From == "Mouse" then
                            local mousePos = GetMouseLocation(UserInputService)
                            Tracer.From = Vector2_new(mousePos.X, mousePos.Y)
                        elseif TracerData.From == "Top" then
                            Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, 0)
                        elseif TracerData.From == "Center" then
                            Tracer.From = Camera.ViewportSize / 2
                        else
                            Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        Tracer.To = Vector2_new(screenPos.X, screenPos.Y)

                        Tracer.Transparency = TracerData.Transparency
                        Tracer.Thickness = TracerData.Thickness
                        Tracer.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor
                            or TracerData.Color
                    end
                end

                --// Update Billboard //
                if Billboard then
                    Billboard.Enabled = Library.GlobalConfig.Billboards == true;

                    if Billboard.Enabled then
                        if Library.GlobalConfig.Distance then
                            local Name, TextSize = ESP.CurrentSettings.Name, ESP.CurrentSettings.TextSize
                            BillboardText.Text = string_format(
                                '%s\n<font size="%d">[%s]</font>',
                                Name,
                                TextSize - 3,
                                tostring(math_floor(distanceFromPlayer))
                            )
                        else
                            BillboardText.Text = ESP.CurrentSettings.Name
                        end

                        BillboardText.Font = Library.GlobalConfig.Font
                        BillboardText.TextColor3 =
                            if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.Color;
                        BillboardText.TextSize = ESP.CurrentSettings.TextSize
                    end
                end

                --// Update Highlighter //
                if Highlighter then
                    Highlighter.Parent = if Library.GlobalConfig.Highlighters == true then ActiveFolder else StorageFolder;
                    Highlighter.Adornee = if Library.GlobalConfig.Highlighters == true then ESP.CurrentSettings.Model else nil;

                    if Highlighter.Adornee then
                        if IsAdornment then
                            Highlighter.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor or ESP.CurrentSettings.Color
                            Highlighter.Transparency = ESP.CurrentSettings.Transparency

                        elseif ESP.OriginalSettings.ESPType == "Selectionbox" then
                            Highlighter.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor or ESP.CurrentSettings.Color
                            Highlighter.LineThickness = ESP.CurrentSettings.Thickness

                            Highlighter.SurfaceColor3 = ESP.CurrentSettings.SurfaceColor
                            Highlighter.SurfaceTransparency = ESP.CurrentSettings.Transparency

                        else
                            Highlighter.FillColor =
                                if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.FillColor;
                            Highlighter.OutlineColor =
                                if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.OutlineColor;

                            Highlighter.FillTransparency = ESP.CurrentSettings.FillTransparency
                            Highlighter.OutlineTransparency = ESP.CurrentSettings.OutlineTransparency
                        end
                    end
                end
            end

            if not ESP.OriginalSettings.Visible then
                Hide()
            end

            ESP.RenderThread = coroutine_create(function()
                local Render = ESP.Render

                while true do
                    pcall(Render, ESP)
                    coroutine_yield()
                end
            end)

            coroutine_resume(ESP.RenderThread)

            Library.ESP[ESP.Index] = ESP
            return ESP
        end

        --// Update Player Variables //
        table.insert(Library.Connections, shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            Camera = shared.Workspace.CurrentCamera;
        end))
        table.insert(Library.Connections, shared.Speaker.CharacterAdded:Connect(UpdatePlayerVariables))

        --// Rainbow Handler //
        table.insert(Library.Connections, shared.RunService.PreRender:Connect(function()
            Library.RainbowColor = getrainbowcolor(Library.RainbowSpeed)
        end))

        --// Main Handler //
        table.insert(Library.Connections, shared.RunService.PreRender:Connect(function()
            for Index, ESP in Library.ESP do
                if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then
                    if ESP and ESP.RenderThread then
                        pcall(coroutine_close, ESP.RenderThread)
                    end

                    Library.ESP[Index] = nil
                    continue
                end

                if not ESP.CurrentSettings.Model or not ESP.CurrentSettings.Model.Parent then
                    if not PublicESPDestroy then
                        PublicESPDestroy = ESP.Destroy
                    end

                    PublicESPDestroy(ESP)
                    continue
                end

                pcall(coroutine_resume, ESP.RenderThread)
            end
        end))

        return Library
    end,

    [59] = function(shared, wax, script, require)
        --[[
        Source: https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
        Credit: 7GrandDadPGN
        ||Thank you NOVEIGMA, I successfully used it on Aimbot! ^^||
        --]]

        local math_pow, math_abs, math_sqrt, math_acos, math_cos, math_pi, Vector3_new, table_insert, table_sort
            = math.pow, math.abs, math.sqrt, math.acos, math.cos, math.pi, Vector3.new, table.insert, table.sort

        local Workspace = shared.Workspace
        local Raycast   = Workspace.Raycast

        local function IsZero(Value)
            return (Value > -1e-9) and (Value < 1e-9)
        end

        local function CubeRoot(Value)
            return (Value > 0) and math_pow(Value, 1/3) or -math_pow(math_abs(Value), 1/3)
        end

        local function SolveQuadratic(Coeff0: number, Coeff1: number, Coeff2: number): (number?, number?)
            local Root1, Root2
            local NormalizedP  = Coeff1 / (2 * Coeff0)
            local NormalizedQ  = Coeff2 / Coeff0
            local Discriminant = NormalizedP * NormalizedP - NormalizedQ

            if IsZero(Discriminant) then
                return -NormalizedP
            elseif Discriminant < 0 then
                return
            else --/ if (Discriminant > 0) then
                local SqrtDiscriminant = math_sqrt(Discriminant)
                Root1 =  SqrtDiscriminant - NormalizedP
                Root2 = -SqrtDiscriminant - NormalizedP

                return Root1, Root2
            end
        end

        local function SolveCubic(Coeff0: number, Coeff1: number, Coeff2: number, Coeff3: number): (number, number?, number?)
            local Root1, Root2, Root3, RootCount

            local NormalizedA = Coeff1 / Coeff0
            local NormalizedB = Coeff2 / Coeff0
            local NormalizedC = Coeff3 / Coeff0

            local SquaredA = NormalizedA * NormalizedA

            local IntermediateP = (1/3) * (- (1/3) * SquaredA + NormalizedB)
            local IntermediateQ = 0.5 * ((2/27) * NormalizedA * SquaredA - (1/3) * NormalizedA * NormalizedB + NormalizedC)

            local CubedP = IntermediateP * IntermediateP * IntermediateP
            local Discriminant = IntermediateQ * IntermediateQ + CubedP

            if IsZero(Discriminant) then
                if IsZero(IntermediateQ) then --/ One triple solution
                    Root1 = 0
                    RootCount = 1
                else --/ One single and one double solution
                    local CubeRootTerm = CubeRoot(-IntermediateQ)

                    Root1 = 2 * CubeRootTerm
                    Root2 = -CubeRootTerm
                    RootCount = 2
                end
            elseif Discriminant < 0 then --/ Casus irreducibilis: three real solutions
                local AnglePhi = (1/3) * math_acos(-IntermediateQ / math_sqrt(-CubedP))
                local TrigScale = 2 * math_sqrt(-IntermediateP)

                Root1 =  TrigScale * math_cos(AnglePhi)
                Root2 = -TrigScale * math_cos(AnglePhi + math_pi/3)
                Root3 = -TrigScale * math_cos(AnglePhi - math_pi/3)

                RootCount = 3
            else --/ One real solution
                local SqrtDiscriminant = math_sqrt(Discriminant)
                local CubeRootU =  CubeRoot(SqrtDiscriminant - IntermediateQ)
                local CubeRootV = -CubeRoot(SqrtDiscriminant + IntermediateQ)

                Root1 = CubeRootU + CubeRootV
                RootCount = 1
            end

            local Adjustment = (1/3) * NormalizedA

            if RootCount > 0 then Root1 -= Adjustment end
            if RootCount > 1 then Root2 -= Adjustment end
            if RootCount > 2 then Root3 -= Adjustment end

            return Root1, Root2, Root3
        end

        local function SolveQuartic(Coeff0: number, Coeff1: number, Coeff2: number, Coeff3: number, Coeff4: number)
            local Roots, Coefficients = {} :: any, {}
            local IntermediateZ, SqrtU, SqrtV, Adjustment, RootCount

            local NormalizedA = Coeff1 / Coeff0
            local NormalizedB = Coeff2 / Coeff0
            local NormalizedC = Coeff3 / Coeff0
            local NormalizedD = Coeff4 / Coeff0

            local SquaredA = NormalizedA * NormalizedA

            local QuarticP = -0.375 * SquaredA + NormalizedB
            local QuarticQ =  0.125 * SquaredA * NormalizedA - 0.5 * NormalizedA * NormalizedB + NormalizedC
            local QuarticR = (
                -(3/256) * SquaredA * SquaredA +
                0.0625 * SquaredA * NormalizedB -
                0.25 * NormalizedA * NormalizedC +
                NormalizedD
            )

            if IsZero(QuarticR) then
                Coefficients[3] = QuarticQ
                Coefficients[2] = QuarticP
                Coefficients[1] = 0
                Coefficients[0] = 1

                local CubicResults = {SolveCubic(Coefficients[0], Coefficients[1], Coefficients[2], Coefficients[3])}
                RootCount = #CubicResults
                Roots[1], Roots[2], Roots[3] = CubicResults[1], CubicResults[2], CubicResults[3]
            else
                Coefficients[3] = 0.5 * QuarticR * QuarticP - 0.125 * QuarticQ * QuarticQ
                Coefficients[2] = -QuarticR
                Coefficients[1] = -0.5 * QuarticP
                Coefficients[0] = 1

                Roots[1], Roots[2], Roots[3] = SolveCubic(Coefficients[0], Coefficients[1], Coefficients[2], Coefficients[3])
                IntermediateZ = Roots[1]

                local UTerm = IntermediateZ * IntermediateZ - QuarticR
                local VTerm = 2 * IntermediateZ - QuarticP

                SqrtU = if (UTerm > 0) then math_sqrt(UTerm) else (if IsZero(UTerm) then 0 else nil)
                SqrtV = if (VTerm > 0) then math_sqrt(VTerm) else (if IsZero(VTerm) then 0 else nil)

                if SqrtU and SqrtV then
                    Coefficients[2] = IntermediateZ - SqrtU
                    Coefficients[1] = (QuarticQ < 0) and -SqrtV or SqrtV
                    Coefficients[0] = 1

                    local QuadResults = {SolveQuadratic(Coefficients[0], Coefficients[1], Coefficients[2])}

                    RootCount = #QuadResults
                    Roots[1], Roots[2] = QuadResults[1], QuadResults[2]

                    Coefficients[2] = IntermediateZ + SqrtU
                    Coefficients[1] = (QuarticQ < 0) and SqrtV or -SqrtV

                    if RootCount == 0 or RootCount == 1 or RootCount == 2 then
                        QuadResults = {SolveQuadratic(Coefficients[0], Coefficients[1], Coefficients[2])}
                        RootCount += #QuadResults
                    end

                    if RootCount == 0 then
                        Roots[1], Roots[2] = QuadResults[1], QuadResults[2]
                    elseif RootCount == 1 then
                        Roots[2], Roots[3] = QuadResults[1], QuadResults[2]
                    elseif RootCount == 2 then
                        Roots[3], Roots[4] = QuadResults[1], QuadResults[2]
                    end
                end
            end
            Adjustment = 0.25 * NormalizedA

            for Index = 1, RootCount do
                Roots[Index] -= Adjustment
            end
            return Roots
        end

        local function SolveTrajectory(
            Origin:          Vector3,
            ProjectileSpeed: number,
            Gravity:         number?,
            PickLongest:     boolean,
            TargetPosition:  Vector3,
            TargetVelocity:  Vector3,
            PlayerGravity:   number?,
            PlayerHeight:    number?,
            RaycastParams:   RaycastParams?
        ): Vector3?
            local Displacement = TargetPosition - Origin
            local TargetVelX, TargetVelY, TargetVelZ = TargetVelocity.X, TargetVelocity.Y, TargetVelocity.Z
            local DispX, DispY, DispZ = Displacement.X, Displacement.Y, Displacement.Z
            local GravityFactor = -0.5 * (Gravity or Workspace.Gravity)

            --/ Attempt gravity calculation, may return to it in the future.
            if math_abs(TargetVelY) > 0.01 and PlayerGravity and PlayerGravity > 0 and PlayerHeight then
                local EstimatedTime = Displacement.Magnitude / ProjectileSpeed
                TargetVelY -= 0.5 * PlayerGravity * EstimatedTime

                local VelocityStep  = TargetVelocity * 0.016
                local RaycastResult = Raycast(Workspace, TargetPosition, Vector3_new(
                    VelocityStep.X,
                    (TargetVelY * EstimatedTime) - PlayerHeight, VelocityStep.Z
                ), RaycastParams)

                if RaycastResult then
                    local NewTarget = RaycastResult.Position + Vector3_new(0, PlayerHeight, 0)

                    EstimatedTime -= math_sqrt(((TargetPosition - NewTarget).Magnitude * 2) / PlayerGravity)
                    TargetPosition = NewTarget
                    DispY = (TargetPosition - Origin).Y
                    TargetVelY = 0
                end
            end

            local SolutionRoots = SolveQuartic(
                GravityFactor * GravityFactor,
                -2 * TargetVelY * GravityFactor,
                TargetVelY^2 - 2 * DispY * GravityFactor - ProjectileSpeed^2 + TargetVelX^2 + TargetVelZ^2,
                2 * DispY * TargetVelY + 2 * DispX * TargetVelX + 2 * DispZ * TargetVelZ,
                DispY^2 + DispX^2 + DispZ^2
            )

            if SolutionRoots then
                local PositiveRoots = {}

                for _, Root in SolutionRoots do --/ Filter out the negative roots
                    if Root > 0 then table_insert(PositiveRoots, Root) end
                end

                if #PositiveRoots > 0 then
                    table_sort(PositiveRoots)

                    local Time = PositiveRoots[if PickLongest then #PositiveRoots else 1]

                    local DeltaX = (DispX + TargetVelX * Time) / Time
                    local DeltaY = (DispY + TargetVelY * Time - GravityFactor * Time^2) / Time
                    local DeltaZ = (DispZ + TargetVelZ * Time) / Time

                    return Origin + Vector3_new(DeltaX, DeltaY, DeltaZ)
                end
            elseif Gravity == 0 then
                local Time = Displacement.Magnitude / ProjectileSpeed

                local DeltaX = (DispX + TargetVelX * Time) / Time
                local DeltaY = (DispY + TargetVelY * Time - GravityFactor * Time^2) / Time
                local DeltaZ = (DispZ + TargetVelZ * Time) / Time

                return Origin + Vector3_new(DeltaX, DeltaY, DeltaZ)
            end
            return nil
        end

        return {SolveTrajectory = SolveTrajectory}
    end,

    [60] = function(shared, wax, script, require)
        local pcall, game,      GetService
            = pcall, game, game.GetService

        local Services = {}

        local cloneref = cloneref or clonereference or function(Object: Instance)
            return Object
        end

        function Services:GetServices(Table: {string})
            for _, Name in Table do
                local Success, Service = pcall(cloneref, GetService(game, Name))
                shared[Name] = if Success then Service else nil
            end
        end

        return Services
    end,

    [62] = function(shared, wax, script, require)
        --[[
        Rewrite 2

        Including:
        + Fov
        + Aimbot
        + SilentAim
        --]]

        --// Setting Up //
        local Shared = {
            Enabled         = false :: boolean,

            TargetPlayers   = true  :: boolean,
            TargetNpcs      = false :: boolean,

            TeamCheck       = true  :: boolean,
            AliveCheck      = true  :: boolean,
            FilterCheck     = true  :: boolean,
            ForceFieldCheck = true  :: boolean,
            WallCheck       = true  :: boolean,
            OnScreenCheck   = false :: boolean,

            FilteredPlayers = {}    :: {Player},

            Prediction      = {
                Enabled     = false :: boolean,
                PickLongest = false :: boolean,

                Speed       = 1000  :: number
            },

            MaxDistance     = 1000  :: number,
            MinDistance     = 0     :: number,

            HitChance       = 100   :: number,
            HeadshotChance  = 100   :: number,

            TargetPriority   = "PlayerFirst" :: "PlayerFirst" | "NpcFirst",
            TeamCheckMethod  = "TeamColor" :: "TeamColor" | "Team",
            WallCheckMethod  = "CheckCanCollide" :: "CheckCanCollide" | "IgnoreCanCollide",
            PlayerFilterMode = "Blacklist" :: "Blacklist" | "Whitelist"
        }

        local Workspace = shared.Workspace :: Workspace & WorldRoot
        local Camera    = shared.Camera    :: Camera
        local Players   = shared.Players   :: Players
        local Speaker   = shared.Speaker   :: Player

        local Character = Speaker.Character

        shared.Connect:GiveSignal("AimbotCameraChanged", Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            Camera = Workspace.CurrentCamera
        end))

        shared.Connect:GiveSignal("AimbotSpeakerChanged", Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
            Speaker = Players.LocalPlayer
        end))

        local SpeakerPosition;do
            local      WaitForChild,      FindFirstChildOfClass,      GetPropertyChangedSignal
                = game.WaitForChild, game.FindFirstChildOfClass, game.GetPropertyChangedSignal

            local Disconnect, Connect;do
                local Signal     = game.Close :: RBXScriptSignal
                local Connection = Signal:Once(function() end)

                Disconnect = Connection.Disconnect
                Connect    = Signal.Connect
            end

            local PositionChanged

            local function SetUpPositionMonitor(Character: Model?)
                if PositionChanged then Disconnect(PositionChanged) end
                if not Character then return end

                local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
                local RootPart = Humanoid and Humanoid.RootPart or WaitForChild(Character, "HumanoidRootPart")

                PositionChanged = Connect(GetPropertyChangedSignal(RootPart, "Position"), function()
                    SpeakerPosition = RootPart.Position
                end)
            end

            shared.Connect:GiveSignal("AimbotCharacterChanged1", Speaker:GetPropertyChangedSignal("Character"):Connect(function()
                Character = Speaker.Character
                SetUpPositionMonitor(Character)
            end))
        end

        local _Target: BasePart?

        local Prediction = require("../Prediction")
        local Entities   = require("../Entities")

        local Fov

        --// Helper Functions //
        local GetMousePosition: () -> Vector2,

              IsValid:     <T>(Object: Instance, Parent: Instance?) -> false | (Instance),

              IsTeammate:     (Player: Player) -> boolean,
              IsDead:         (Player: Player | Model, IsNpc: boolean | nil) -> boolean,
              IsFiltered:     (Player: Player) -> boolean,
              NotVulnerable:  (Player: Player | Model, IsNpc: boolean | nil) -> boolean,

              CommonChecks:   (Player: Player | Model, IsNpc: boolean | nil) -> boolean,

              IsOffScreen:    (Target: Vector3) -> boolean,
              IsObscured:     (Origin: Vector3,       Direction: Vector3, ...any & Instance) -> boolean,
              IsOutOfRange:   (Origin: Vector3 | nil, Target:    Vector3) -> boolean,

              GetPriorities:  () -> ("Players" | "Npcs" | nil, "Players" | "Npcs" | nil),
              GetHitPart:     (Head: BasePart?, RootPart: BasePart?) -> nil | BasePart,
              EasyGetHitPart: (Head: BasePart?, RootPart: BasePart?, Origin: Vector3?)  -> nil | BasePart,

              Predict: <T>(
                  Origin:   Vector3,
                  Target:   BasePart,
                  Humanoid: Humanoid?,
                  RootPart: BasePart?,

                  RaycastParams:        RaycastParams?,
                  AlwaysReturnsVector3: boolean | nil
              ) -> Vector3

        do
            --// Is Valid
            local typeof,      IsDescendantOf
                = typeof, game.IsDescendantOf

            local iscached = (if wax.shared.ExecutorSupport.iscached then
                cache.iscached
            else function(Object: Instance): boolean return true end) :: (Object: Instance) -> boolean

            function IsValid(Object: Instance, Parent: Instance?): false | Instance
                return if (
                    iscached(Object) and typeof(Object) == "Instance" and IsDescendantOf(Object :: Instance, Parent or Workspace)
                ) then Object else false
            end

            --// Is Teammate
            local Teams    = shared.Teams :: Teams
            local GetTeams = Teams.GetTeams

            function IsTeammate(Player: Player): boolean
                if not Shared.TeamCheck then return false end
                if #GetTeams(Teams) < 2 then return false end

                local Key = Shared.TeamCheckMethod
                return (Player :: any)[Key] == (Speaker :: any)[Key]
            end

            --// Is Dead
            local Players_ = Entities.Players
            local Npcs_    = Entities.Npcs

            function IsDead(Player: Player | Model, IsNpc: boolean | nil): boolean
                if not Shared.AliveCheck then return false end

                if IsNpc then
                    return if Npcs_[Player :: Model] then not Npcs_[Player :: Model].Alive else true
                end
                return if Players_[Player :: Player] then not Players_[Player :: Player].Alive else true
            end

            --// Is Filtered
            local table_find
                = table.find

            local FilteredPlayers = Shared.FilteredPlayers

            function IsFiltered(Player: Player): boolean
                return Shared.FilterCheck and (Shared.PlayerFilterMode == "Blacklist") == (table_find(FilteredPlayers, Player) ~= nil)
            end

            --// Not Vulnerable
            function NotVulnerable(Player: Player | Model, IsNpc: boolean | nil): boolean
                if not Shared.ForceFieldCheck then return false end

                if IsNpc then
                    return if Npcs_[Player :: Model] then Npcs_[Player :: Model].ForceField ~= nil else false
                end
                return if Players_[Player :: Player] then Players_[Player :: Player].ForceField ~= nil else false
            end

            --// Common Checks
            function CommonChecks(Player: Player | Model, IsNpc: boolean | nil): boolean
                return (
                    (not IsNpc and IsFiltered(Player :: Player)) or
                    (not IsNpc and IsTeammate(Player :: Player)) or
                    IsDead(Player, IsNpc) or
                    NotVulnerable(Player, IsNpc)
                )
            end

            --// Is Off Screen
            local WorldToViewportPoint = Camera.WorldToViewportPoint

            function IsOffScreen(Target: Vector3): boolean
                if not Shared.OnScreenCheck then return false end

                local _, IsOnScreen = WorldToViewportPoint(Camera, Target)
                return not IsOnScreen
            end

            --// Is Obscured
            local      IsA, RaycastParams_new
                = game.IsA, RaycastParams.new

            local Exclude = Enum.RaycastFilterType.Exclude
            local Raycast = Workspace.Raycast

            function IsObscured(Origin: Vector3, Direction: Vector3, ...: any): boolean
                if not Shared.WallCheck then return false end

                local RaycastParam = RaycastParams_new()
                RaycastParam.FilterDescendantsInstances = {..., Character :: any}
                RaycastParam.FilterType = Exclude

                local RaycastResult = Raycast(Workspace, Origin, Direction, RaycastParam)
                local HitPart = RaycastResult and RaycastResult.Instance
                if not HitPart then return false end

                return if Shared.WallCheckMethod == "CheckCanCollide" and IsA(HitPart, "BasePart") then (HitPart :: BasePart).CanCollide else false
            end

            --// Is Out of Range
            local Vector2_new, math_pi, math_cos, math_sin
                = Vector2.new, math.pi, math.cos, math.sin

            local function Vector3ToVector2(Vector3: Vector3): Vector2
                return Vector2_new(Vector3.X, Vector3.Y)
            end

            local function CrossProduct2D(Position1: Vector2, Position2: Vector2, Position3: Vector2): number
                return (Position2.X - Position1.X) * (Position3.Y - Position1.Y) - (Position2.Y - Position1.Y) * (Position3.X - Position1.X)
            end

            --/ Helper function, make IsOutOfRange more accurate in polygon fov
            local function IsPointInRegularPolygon(
                Point:    Vector2,
                Center:   Vector2,
                Radius:   number,
                NumSides: number
            ): boolean
                if NumSides < 3 then return false end

                local Vertices       = {}
                local AngleIncrement = (2 * math_pi) / NumSides
                local StartAngle     = math_pi / 2

                for Index = 0, NumSides - 1 do
                    local Angle = StartAngle + (Index * AngleIncrement)

                    Vertices[Index + 1] = Vector2_new(
                        Center.X + Radius * math_cos(Angle),
                        Center.Y + Radius * math_sin(Angle)
                    )
                end

                local FirstCrossProductSign: number?

                for Index = 1, NumSides do
                    local Position1 = Vertices[Index]
                    local Position2 = Vertices[(Index % NumSides) + 1]

                    local CrossProduct = CrossProduct2D(Position1, Position2, Point)

                    if not FirstCrossProductSign then
                        FirstCrossProductSign = CrossProduct > 0 and 1 or (CrossProduct < 0 and -1 or 0)
                    else
                        local CurrentSign = CrossProduct > 0 and 1 or (CrossProduct < 0 and -1 or 0)
                        if CurrentSign ~= 0 and FirstCrossProductSign ~= 0 and CurrentSign ~= FirstCrossProductSign then
                            return false
                        end
                    end
                end

                return true
            end

            function IsOutOfRange(Origin: Vector3 | nil, Target: Vector3): boolean
                local IsWithinFov = true

                if Fov.Enabled then
                    IsWithinFov = false

                    local ScreenPosition, IsOnScreen = WorldToViewportPoint(Camera, Target)
                    if IsOnScreen then
                        local Position2D = Vector3ToVector2(ScreenPosition)
                        local NumSides   = Fov.NumSides
                        local Magnitude  = (Position2D - Fov.Position).Magnitude

                        if Fov.Polygon and NumSides < 30 then
                            IsWithinFov = IsPointInRegularPolygon(Position2D, Fov.Position, Fov.Radius, NumSides)
                        else
                            IsWithinFov = Magnitude < Fov.Radius
                        end
                    end
                end

                local Distance      = (Origin or SpeakerPosition - Target).Magnitude
                local IsWithinRange = Distance >= Shared.MinDistance and Distance <= Shared.MaxDistance

                return not (IsWithinFov and IsWithinRange)
            end

            --// Get Priorities
            function GetPriorities(): ("Players" | "Npcs" | nil, "Players" | "Npcs" | nil)
                local        TargetPlayers,        TargetNpcs
                    = Shared.TargetPlayers, Shared.TargetNpcs

                if TargetPlayers and TargetNpcs then
                    if Shared.TargetPriority == "PlayerFirst" then
                        return "Players", "Npcs"
                    end
                    return "Npcs", "Players"
                elseif TargetPlayers then
                    return "Players"
                elseif TargetNpcs then
                    return "Npcs"
                end

                return
            end

            --// Get HitPart
            local Random     = Random.new()
            local NextNumber = Random.NextNumber

            function GetHitPart(Head: BasePart?, RootPart: BasePart?): nil | BasePart
                local HitChance      = Shared.HitChance
                local HeadshotChance = Shared.HeadshotChance

                return (
                    if NextNumber(Random, 0, 100) > HitChance      and HitChance      < 100 then nil else
                    if NextNumber(Random, 0, 100) > HeadshotChance and HeadshotChance < 100 then RootPart else Head
                )
            end

            --// Easy Get HitPart
            local unpack
                = unpack

            function EasyGetHitPart(
                Head:     BasePart?,
                RootPart: BasePart?,
                Origin:   Vector3?,

                WallCheckExclude: {BasePart}?
            ): nil | BasePart
                local HitPart = GetHitPart(Head, RootPart)
                if not HitPart then return end

                local Position = HitPart.Position
                if IsOutOfRange(Origin, Position) then return end
                if IsOffScreen(Position) then return end
                if IsObscured(
                    Position,
                    (Origin or SpeakerPosition) - Position,
                    HitPart,
                    if WallCheckExclude then unpack(WallCheckExclude) else nil
                ) then return end

                return HitPart
            end

            --// Predict
            local SolveTrajectory = Prediction.SolveTrajectory
            local UniversalPlayer = require("Player")

            local R6 = Enum.HumanoidRigType.R6

            local BackupRaycastParams = RaycastParams_new()
            BackupRaycastParams.FilterType = Exclude
            BackupRaycastParams.FilterDescendantsInstances = {Character :: any}

            shared.Connect:GiveSignal("AimbotCharacterChanged2", Speaker:GetPropertyChangedSignal("Character"):Connect(function()
                BackupRaycastParams.FilterDescendantsInstances = {Speaker.Character :: any}
            end))

            function Predict(
                Origin:   Vector3,
                Target:   BasePart,
                Humanoid: Humanoid?,
                RootPart: BasePart?,

                RaycastParams:        RaycastParams?,
                AlwaysReturnsVector3: boolean | nil
            ): Vector3?
                if not Shared.Prediction.Enabled then return Origin end

                local DefaultGravity = UniversalPlayer.Gravity.Default
                local PlayerHeight   = 0

                if Humanoid then
                    PlayerHeight += Humanoid.HipHeight + (Humanoid.RigType == R6 and 2 or 0)
                end

                if RootPart then
                    PlayerHeight += RootPart.Size.Y / 2
                end

                local Solution = SolveTrajectory(
                    Origin,
                    Shared.Prediction.Speed,
                    nil,
                    Shared.Prediction.PickLongest,
                    Target.Position,
                    Target.AssemblyLinearVelocity,
                    DefaultGravity,
                    PlayerHeight,
                    RaycastParams or BackupRaycastParams
                )

                return Solution or if AlwaysReturnsVector3 then Origin else nil
            end
        end

        --// Fov //
        Fov = {
            Replaced = not wax.shared.ExecutorSupport.Drawing :: boolean,

            Enabled  = false :: boolean,
            Visible  = true  :: boolean,

            Polygon  = true  :: boolean,

            Filled   = false :: boolean,
            Radius   = 150   :: number,
            NumSides = 60    :: number,

            FollowMouse = true :: boolean,
            Position    = (Camera.ViewportSize / 2) :: Vector2,

            Circle = {
                Object       = nil   :: (CircleDrawing | UIStroke)?,
                Rainbow      = false :: boolean,

                RainbowSpeed = 0.4 :: number,
                Transparency = 0.6 :: number,
                Thickness    = 3   :: number,

                Color        = Color3.fromHex("1f6feb") :: Color3,

                LockedColor  = {
                    Enabled  = true :: boolean,
                    Color    = Color3.new(1, 0, 0)
                }
            },

            Outline = {
                Object       = nil   :: (CircleDrawing | UIStroke)?,
                Rainbow      = false :: boolean,

                RainbowSpeed = 0.4 :: number,
                Transparency = 0.6 :: number,
                Thickness    = 2   :: number,

                Color        = Color3.fromHex("0d1117") :: Color3,
            }
        };do
            local getrainbowcolor
                = getrainbowcolor

            local UserInputService = shared.UserInputService :: UserInputService
            local GetMouseLocation = UserInputService.GetMouseLocation
            local MouseEnabled     = UserInputService.MouseEnabled

            shared.Connect:GiveSignal("AimbotMouseEnabledChanged1", UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function()
                MouseEnabled = UserInputService.MouseEnabled
            end))

            function GetMousePosition()
                if Fov.FollowMouse and MouseEnabled then
                    return GetMouseLocation(UserInputService)
                end
                return Camera.ViewportSize / 2
            end

            if not Fov.Replaced then
                Fov.Outline.Object = Drawing.new("Circle")
                Fov.Circle .Object = Drawing.new("Circle")

                local Circle  = Fov.Circle.Object  :: CircleDrawing
                local Outline = Fov.Outline.Object :: CircleDrawing

                shared.Connect:GiveSignal("AimbotFovUpdate", shared.RunService.PreRender:Connect(function()
                    --/ Upvalues -> local values
                    local Fov, Circle, Outline
                        = Fov, Circle, Outline

                    local Visible  = Fov.Enabled and Fov.Visible
                    local Position = GetMousePosition()

                    Fov.Position = Position

                    local CircleThickness = Fov.Circle.Thickness

                    --/ Circle
                    Circle.Color        = (
                        Fov.Circle.Rainbow and getrainbowcolor(Fov.Circle.RainbowSpeed) or
                        _Target and Fov.Circle.LockedColor.Enabled and Fov.Circle.LockedColor.Color or
                        Fov.Circle.Color
                    )
                    Circle.Filled       = Fov.Filled
                    Circle.NumSides     = Fov.NumSides
                    Circle.Position     = Position
                    Circle.Radius       = Fov.Radius
                    Circle.Thickness    = CircleThickness
                    Circle.Transparency = 1 - Fov.Circle.Transparency
                    Circle.Visible      = Visible

                    --/ Outline
                    Outline.Color        = Fov.Outline.Rainbow and getrainbowcolor(Fov.Outline.RainbowSpeed) or Fov.Outline.Color
                    Outline.Filled       = false
                    Outline.NumSides     = Fov.NumSides
                    Outline.Position     = Position
                    Outline.Radius       = Fov.Radius
                    Outline.Thickness    = Fov.Outline.Thickness + CircleThickness
                    Outline.Transparency = 1 - Fov.Outline.Transparency
                    Outline.Visible      = Visible
                end))

                wax.AddOnUnload(Circle .Remove, Circle)
                wax.AddOnUnload(Outline.Remove, Outline)
            else
                local Instance_new, randomstring, UDim2_fromOffset
                    = Instance.new, randomstring, UDim2.fromOffset

                local function New(ClassName: string, Properties: table): Instance
                    local Instance = Instance_new(ClassName)

                    for Key, Value in Properties do
                        if Key == "Parent" then continue end
                        (Instance :: any)[Key] = Value
                    end

                    Instance.Name   = randomstring()
                    Instance.Parent = Properties.Parent
                    Properties = nil :: any

                    return Instance
                end

                local ScreenGui = New("ScreenGui", {
                    DisplayOrder = 1e8,
                    IgnoreGuiInset = true,
                    Parent = gethui()
                }) :: ScreenGui

                pcall(function()
                    ScreenGui.OnTopOfCoreBlur = true
                end)

                local CircleFrame = New("Frame", {
                    Visible = false,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = ScreenGui
                }) :: Frame

                local Circle = New("UIStroke", {Parent = CircleFrame}) :: UIStroke

                New("UICorner", {
                    CornerRadius = UDim.new(0.5, 0),
                    Parent = CircleFrame
                })

                local OutlineFrame = CircleFrame:Clone()
                local Outline      = OutlineFrame:FindFirstChildOfClass("UIStroke") :: UIStroke

                shared.Connect:GiveSignal("AimbotFovUpdate", shared.RunService.PreRender:Connect(function()
                    --/ Upvalues -> local values
                    local Fov, CircleFrame, OutlineFrame, Circle, Outline
                        = Fov, CircleFrame, OutlineFrame, Circle, Outline

                    local Visible  = Fov.Enabled and Fov.Visible
                    local Position = GetMousePosition()

                    Fov.Position = Position

                    local Diameter         = Fov.Radius * 2
                    local CircleThickness  = Fov.Circle.Thickness
                    local OutlineThickness = CircleThickness + Fov.Outline.Thickness
                    local OutlineOffset    = OutlineThickness / 2
                    local UDim2_Position   = UDim2_fromOffset(Position.X, Position.Y)

                    local CircleColor  = (
                        Fov.Circle.Rainbow and getrainbowcolor(Fov.Circle.RainbowSpeed) or
                        _Target and Fov.Circle.LockedColor.Enabled and Fov.Circle.LockedColor.Color or
                        Fov.Circle.Color
                    )

                    --/ CircleFrame
                    CircleFrame.Position = UDim2_Position
                    CircleFrame.Size     = UDim2_fromOffset(Diameter, Diameter)
                    CircleFrame.Visible  = Visible

                    CircleFrame.BackgroundColor3 = CircleColor
                    CircleFrame.BackgroundTransparency = Fov.Filled and 0 or 1

                    --/ OutlineFrame
                    OutlineFrame.Position = UDim2_Position
                    OutlineFrame.Size     = UDim2_fromOffset(Diameter - OutlineOffset, Diameter - OutlineOffset)
                    OutlineFrame.Visible  = Visible

                    --/ Circle
                    Circle.Color        = CircleColor
                    Circle.Thickness    = Fov.Circle.Thickness
                    Circle.Transparency = Fov.Circle.Transparency

                    --/ Outline
                    Outline.Color        = Fov.Outline.Rainbow and getrainbowcolor(Fov.Outline.RainbowSpeed) or Fov.Outline.Color
                    Outline.Thickness    = OutlineThickness
                    Outline.Transparency = Fov.Outline.Transparency
                end))

                wax.AddOnUnload(function()
                    ScreenGui:Destroy() --/ Don't use (ScreenGui.Destroy, ScreenGui)
                end)
                ScreenGui = nil :: any
            end
        end

        local Aimbot = {
            Method      = "Mouse" :: "Mouse" | "Camera",
            Smoothness  = 0.5     :: number
        } :: {[string]: any};do
            local mousemoverel, Vector2_new, CFrame_lookAt, task_cancel, task_spawn, task_defer
                = mousemoverel, Vector2.new, CFrame.lookAt, task.cancel, task.spawn, task.defer

            local AimbotEnabled = false

            local Players_ = Entities.Players
            local Npcs_    = Entities.Npcs

            local WorldToViewportPoint = Camera.WorldToViewportPoint

            local Connect = shared.Connect

            local UserInputService = shared.UserInputService :: UserInputService
            local MouseEnabled     = UserInputService.MouseEnabled

            Connect:GiveSignal("AimbotMouseEnabledChanged2", UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function()
                MouseEnabled = UserInputService.MouseEnabled
            end))

            --// Helper Functions
            local function Vector3ToVector2(Vector3: Vector3): Vector2
                return Vector2_new(Vector3.X, Vector3.Y)
            end

            local function DivideVector2(Vector2: Vector2): (number, number)
                return Vector2.X, Vector2.Y
            end

            local Humanoid: Humanoid?
            local RootPart: BasePart?

            local function GetTarget(): (BasePart?, Humanoid?)
                local Target: BasePart?

                --/ Upvalues -> local values
                local CommonChecks   = CommonChecks
                local EasyGetHitPart = EasyGetHitPart
                local First, Second  = GetPriorities()

                local function FromPlayers(
                    --/ Local values -> upvalues -> params
                    CommonChecks:  (Player) -> boolean,
                    EasyGetHitPart: (BasePart?, BasePart?) -> nil | BasePart
                )
                    for Player, PlayerStore in Players_ do
                        if CommonChecks(Player) then continue end

                        local RootPart_ = PlayerStore.RootPart
                        local HitPart   = EasyGetHitPart(PlayerStore.Head, RootPart_)

                        if not HitPart then continue end

                        Target   = HitPart
                        Humanoid = PlayerStore.Humanoid
                        RootPart = RootPart_
                        break
                    end

                    return
                end

                local function FromNpcs(
                    CommonChecks:  (Model, boolean) -> boolean,
                    EasyGetHitPart: (BasePart?, BasePart?) -> nil | BasePart
                )
                    for Npc, NpcStore in Npcs_ do
                        if CommonChecks(Npc, true) then continue end

                        local RootPart_ = NpcStore.RootPart
                        local HitPart   = EasyGetHitPart(NpcStore.Head, RootPart_)

                        if not HitPart then continue end

                        Target   = HitPart
                        Humanoid = NpcStore.Humanoid
                        RootPart = RootPart_
                        break
                    end

                    return
                end

                if First == "Players" then
                    FromPlayers(CommonChecks, EasyGetHitPart)

                    if not Target and Second == "Npcs" then
                        FromNpcs(CommonChecks, EasyGetHitPart)
                    end
                elseif First == "Npcs" then
                    FromNpcs(CommonChecks, EasyGetHitPart)

                    if not Target and Second == "Players" then
                        FromPlayers(CommonChecks, EasyGetHitPart)
                    end
                end

                return Target
            end

            --// Main Logics //
            local Support_mousemoverel = wax.shared.ExecutorSupport.mousemoverel

            local EasingLibrary = wax.shared.EasingLibrary
            local CancelTween   = EasingLibrary.RunningTween
            local Ease          = EasingLibrary.Ease

            local function Move(LockedVector: Vector3)
                if Aimbot.Method == "Mouse" and MouseEnabled and Support_mousemoverel then
                    local LockedPosition = WorldToViewportPoint(Camera, LockedVector)
                    local FlatPosition   = Vector3ToVector2(LockedPosition)
                    local MousePosition  = GetMousePosition()

                    mousemoverel(DivideVector2(FlatPosition - MousePosition))
                else
                    local NewCFrame = CFrame_lookAt(Camera.CFrame.Position, LockedVector)

                    if Aimbot.Smoothness > 0 then
                        Ease(EasingLibrary, Camera, "CFrame", NewCFrame, "Aimbot", Aimbot.Smoothness)
                    else
                        Camera.CFrame = NewCFrame
                    end
                end
            end

            local AimbotKeybind = wax.shared.UiManager.Options.AimbotKeybind
            local GetState      = AimbotKeybind.GetState

            local StepThread: thread?

            local function CancelLock()
                if StepThread then StepThread = task_cancel(StepThread) end
                _Target = CancelTween(EasingLibrary, "Aimbot")
            end

            Aimbot.Start = function(Enabled: boolean)
                AimbotEnabled = Enabled
                CancelLock()

                Connect[`{Enabled and "B" or "Unb"}indRenderStep`](Connect, "StepAimbot", 200, function()
                    if not GetState(AimbotKeybind) then return CancelLock() end

                    StepThread = task_spawn(function()
                        if not (Shared.Enabled and AimbotEnabled) then return end

                        if _Target and IsValid(_Target) then
                            if (
                                IsOutOfRange(nil, _Target.Position) or
                                IsOffScreen(_Target.Position) or
                                IsObscured(_Target.Position, SpeakerPosition - _Target.Position, _Target)
                            ) then
                                return task_defer(CancelLock)
                            end

                            return Move(Predict(_Target.Position, _Target, Humanoid, RootPart, nil, true))
                        end

                        CancelTween(EasingLibrary, "Aimbot")
                        _Target = GetTarget()
                        if not _Target then return end

                        Move(Predict(_Target.Position, _Target, Humanoid, RootPart, nil, true))
                    end)
                end)
            end
        end

        --// SilentAim //
        local SilentAim = {
            WallBang = false :: boolean,

            Hooks  = {
                FindPartOnRay               = true :: boolean,
                FindPartOnRayWithWhitelist  = true :: boolean,
                FindPartOnRayWithIgnoreList = true :: boolean,

                Ray     = true :: boolean,
                Raycast = true :: boolean,

                ScreenPointToRay   = true :: boolean,
                ViewportPointToRay = true :: boolean
            }
        };if (
            wax.shared.ExecutorSupport.getcallingscript and
            wax.shared.ExecutorSupport.checkcaller and (
                wax.shared.ExecutorSupport.hookfunction or (
                    wax.shared.ExecutorSupport.hookmetamethod and
                    wax.shared.ExecutorSupport.getnamecallmethod
                )
            )
        ) then
            local RaycastParams_new
                = RaycastParams.new

            local Players_ = Entities.Players
            local Npcs_    = Entities.Npcs

            local Humanoid: Humanoid?
            local RootPart: BasePart?

            local ProjectileRaycastParams = RaycastParams_new()

            --// Helper Functions
            local function GetTarget(Origin: Vector3, WallCheckExclude: {BasePart}?): (BasePart | nil, Vector3)
                local Target: BasePart?

                local CommonChecks   = CommonChecks
                local EasyGetHitPart = EasyGetHitPart
                local First, Second  = GetPriorities()

                local function FromPlayers(
                    --/ Local values -> upvalues -> params | upvalues -> params
                    Origin:         Vector3,
                    WallCheckExclude: {BasePart}?,
                    CommonChecks:    (Player) -> boolean,
                    EasyGetHitPart:   (
                        BasePart?,
                        BasePart?,
                        Origin: Vector3?,
                        WallCheckExclude: {BasePart}?
                    ) -> nil | BasePart
                )
                    for Player, PlayerStore in Players_ do
                        if CommonChecks(Player) then continue end

                        local RootPart_ = PlayerStore.RootPart
                        local HitPart   = EasyGetHitPart(PlayerStore.Head, RootPart_, Origin, WallCheckExclude)

                        if not HitPart then continue end

                        Target   = HitPart
                        Humanoid = PlayerStore.Humanoid
                        RootPart = RootPart_

                        ProjectileRaycastParams.FilterDescendantsInstances = {PlayerStore.Character :: any}
                        ProjectileRaycastParams.CollisionGroup = HitPart.CollisionGroup
                        break
                    end

                    return
                end

                local function FromNpcs(
                    Origin:         Vector3,
                    WallCheckExclude: {BasePart}?,
                    CommonChecks:    (Model, boolean) -> boolean,
                    EasyGetHitPart:   (
                        BasePart?,
                        BasePart?,
                        Origin: Vector3?,
                        WallCheckExclude: {BasePart}?
                    ) -> nil | BasePart
                )
                    for Npc, NpcStore in Npcs_ do
                        if CommonChecks(Npc, true) then continue end

                        local RootPart_ = NpcStore.RootPart
                        local HitPart   = EasyGetHitPart(NpcStore.Head, RootPart_, Origin, WallCheckExclude)

                        if not HitPart then continue end

                        Target   = HitPart
                        Humanoid = NpcStore.Humanoid
                        RootPart = RootPart_

                        ProjectileRaycastParams.FilterDescendantsInstances = {Npc}
                        ProjectileRaycastParams.CollisionGroup = HitPart.CollisionGroup
                        break
                    end
                end

                if First == "Players" then
                    FromPlayers(Origin, WallCheckExclude, CommonChecks, EasyGetHitPart)

                    if not Target and Second == "Npcs" then
                        FromNpcs(Origin, WallCheckExclude, CommonChecks, EasyGetHitPart)
                    end
                elseif First == "Npcs" then
                    FromNpcs(Origin, WallCheckExclude, CommonChecks, EasyGetHitPart)

                    if not Target and Second == "Players" then
                        FromPlayers(Origin, WallCheckExclude, CommonChecks, EasyGetHitPart)
                    end
                end

                return Target, Origin
            end

            local Hooks = {};do --// Hooks
                local typeof, Ray_new, CFrame_lookAt, Vector3_zero
                    = typeof, Ray.new, CFrame.lookAt, Vector3.zero

                local GetClosestPointOnSurface;do
                    local Part = Instance.new("Part")
                    GetClosestPointOnSurface = Part.GetClosestPointOnSurface
                    Part:Destroy()
                end

                local Include = Enum.RaycastFilterType.Include

                local function EasyPredict(Origin: Vector3, Target: BasePart)
                    return Predict(
                        Origin,
                        Target,
                        Humanoid,
                        RootPart,

                        ProjectileRaycastParams
                    )
                end

                local function FindPartOnRay(Arguments: {any}): nil | array
                    local Filtered = Arguments[2]

                    local Target: BasePart | nil, Origin: Vector3 = GetTarget(Arguments[1], (
                        if typeof(Filtered) == "Instance" then {Filtered}
                        else if typeof(Filtered) == "table" then Filtered
                        else nil
                    ))

                    if not Target then return end
                    if SilentAim.WallBang then
                        return {
                            Target,
                            Target.Position,
                            GetClosestPointOnSurface(Target, Origin)
                        } :: array
                    end

                    local EndPoint = CFrame_lookAt(Origin, Target.Position).LookVector * Arguments[1].Direction.Magnitude
                    if Shared.Prediction.Enabled then
                        EndPoint = EasyPredict(Origin, Target)
                    end

                    Arguments[1] = Ray_new(Origin, EndPoint)
                    return
                end

                local function Ray(Arguments: {any}): nil
                    local Target: BasePart | nil, Origin = GetTarget(Arguments[1])
                    if not Target then return end

                    local EndPoint = Target.Position
                    if Shared.Prediction.Enabled then
                        EndPoint = EasyPredict(Origin, Target) or EndPoint
                    end

                    Arguments[2] = CFrame_lookAt(Origin, EndPoint).LookVector * Arguments[2].Magnitude
                    return
                end

                local function Raycast(Arguments: {any}): nil
                    local Target: BasePart | nil, Origin = GetTarget(Arguments[1])
                    if not Target then return end

                    local EndPoint = Target.Position
                    if Shared.Prediction.Enabled then
                        EndPoint = EasyPredict(Origin, Target) or EndPoint
                    end

                    if SilentAim.WallBang then
                        local RaycastParams = RaycastParams_new()
                        RaycastParams.FilterType = Include
                        RaycastParams.FilterDescendantsInstances = {Target}

                        Arguments[3] = RaycastParams
                    end

                    Arguments[2] = CFrame_lookAt(Origin, EndPoint).LookVector * Arguments[2].Magnitude
                    return
                end

                local function ScreenPointToRay(Arguments: {any}): nil | array
                    local Target: BasePart | nil, Origin = GetTarget(Camera.CFrame.Position)
                    if not Target then return end

                    local Direction = CFrame_lookAt(Origin, Target.Position)
                    if Shared.Prediction.Enabled then
                        local Solution = EasyPredict(Origin, Target)
                        Direction = Solution and CFrame_lookAt(Origin, Solution) or Direction
                    end

                    return {Ray_new(
                        Origin + (Arguments[3] and Direction.LookVector * Arguments[3] or Vector3_zero),
                        Direction.LookVector
                    )}
                end

                Hooks.FindPartOnRay               = FindPartOnRay
                Hooks.FindPartOnRayWithWhitelist  = FindPartOnRay
                Hooks.FindPartOnRayWithIgnoreList = FindPartOnRay

                Hooks.Ray     = Ray
                Hooks.Raycast = Raycast

                Hooks.ScreenPointToRay   = ScreenPointToRay
                Hooks.ViewportPointToRay = ScreenPointToRay
            end

            --// Main Logics
            local hookfunction, hookmetamethod, getnamecallmethod, getcallingscript, checkcaller
                = hookfunction, hookmetamethod, getnamecallmethod, getcallingscript, checkcaller

            local Old = {} :: {
                __namecall: (self: Object, ...any) -> any,

                FindPartOnRay:               (self: WorldRoot, ...any) -> any,
                FindPartOnRayWithWhitelist:  (self: WorldRoot, ...any) -> any,
                FindPartOnRayWithIgnoreList: (self: WorldRoot, ...any) -> any,

                Ray:     (Origin: Vector3,   Direction: Vector3) -> Ray,
                Raycast: (self:     WorldRoot, Origin:  Vector3, Direction: Vector3, RaycastParams) -> RaycastResult,

                ScreenPointToRay:   (self: Camera, number, number, Depth: number) -> Ray,
                ViewportPointToRay: (self: Camera, number, number, Depth: number) -> Ray
            }

            local Support_hookfunction = wax.shared.ExecutorSupport.hookfunction
            local Support_hookmetamethod = (
                wax.shared.ExecutorSupport.hookmetamethod and
                wax.shared.ExecutorSupport.getnamecallmethod
            )

            local function GetHook(Function: Function, Method: 
                "FindPartOnRay" |
                "FindPartOnRayWithWhitelist" |
                "FindPartOnRayWithIgnoreList" |

                "Ray" |
                "Raycast" |

                "ScreenPointToRay" |
                "ViewportPointToRay"
            , Custom: Function?): Function
                local checkcaller, getcallingscript, unpack
                    = checkcaller, getcallingscript, unpack

                local Hook  = Hooks[Method]
                local Hooks = SilentAim.Hooks

                return hookfunction(Function, Custom or function(self: Instance, ...: any): any
                    if checkcaller() then return Old[Method](...)
                    elseif not Hooks[Method] then return Old[Method](...) end

                    local Calling = getcallingscript()
                    if Calling then
                        for _, Name in {
                            "ControlModule",
                            "ControlScript"
                        } do
                            if Calling.Name == Name then return Old[Method](...) end
                        end
                    end

                    local Arguments = {...}
                    local Result    = Hook(Arguments)

                    return if Result then unpack(Result) else Old[Method](self, Arguments)
                end)
            end

            local FunctionAndMethods = {
                [Workspace.FindPartOnRay :: any]        = "FindPartOnRay",
                [Workspace.FindPartOnRayWithWhitelist]  = "FindPartOnRayWithWhitelist",
                [Workspace.FindPartOnRayWithIgnoreList] = "FindPartOnRayWithIgnoreList",

                [Ray.new]           = "Ray",
                [Workspace.Raycast] = "Raycast",

                [Camera.ScreenPointToRay]   = "ScreenPointToRay",
                [Camera.ViewportPointToRay] = "ViewportPointToRay"
            }

            SilentAim.Start = function(Enabled: boolean)
                --// __namecall Hooking
                if Support_hookmetamethod then
                    if Enabled then
                        local getnamecallmethod, getcallingscript, unpack
                            = getnamecallmethod, getcallingscript, unpack

                        local Hooks  = SilentAim.Hooks
                        local Hooks_ = Hooks

                        Old.__namecall = hookmetamethod(game, "__namecall", function(self: Object, ...: any) 
                            local Method = getnamecallmethod()

                            if not Hooks[Method] then return Old.__namecall(self, ...)
                            elseif checkcaller() then return Old.__namecall(self, ...) end

                            local Calling = getcallingscript()
                            if Calling then
                                for _, Name in {
                                    "ControlModule",
                                    "ControlScript"
                                } do
                                    if Calling.Name == Name then return Old.__namecall(self, ...) end
                                end
                            end

                            local Arguments = {...}
                            local Result    = Hooks_[Method](Arguments)

                            return if Result then unpack(Result) else Old.__namecall(self, unpack(Arguments))
                        end)
                    else
                        hookmetamethod(game, "__namecall", Old.__namecall)
                        Old.__namecall = nil :: any
                    end
                end

                --// Function Hooking
                if Support_hookfunction then
                    if Enabled then
                        for Function, Method in FunctionAndMethods do
                            if Method == "Ray" then
                                local checkcaller, getcallingscript
                                    = checkcaller, getcallingscript

                                local Hook  = Hooks.Ray
                                local Hooks = SilentAim.Hooks

                                Old.Ray = GetHook(Function, Method, function(Origin: Vector3, Direction: Vector3): Ray
                                    if checkcaller() then return Old.Ray(Origin, Direction)
                                    elseif not Hooks.Ray then return Old.Ray(Origin, Direction) end

                                    local Calling = getcallingscript()
                                    if Calling then
                                        for _, Name in {
                                            "ControlModule",
                                            "ControlScript"
                                        } do
                                            if Calling.Name == Name then return Old.Ray(Origin, Direction) end
                                        end
                                    end

                                    local Arguments = {Origin, Direction}
                                    Hook(Arguments)

                                    return Old.Ray(unpack(Arguments))
                                end)
                            else
                                Old[Method] = GetHook(Function, Method :: any)
                            end
                        end
                    else
                        for Function, Method in FunctionAndMethods do
                            hookfunction(Function, Old[Method])
                            Old[Method] = nil :: any
                        end
                    end
                end
            end
        end

        --// Finalize //
        local AimbotModule = {
            Fov       = Fov,
            Shared    = Shared,
            Aimbot    = Aimbot,
            SilentAim = SilentAim
        };do  --// Bundle Table and Usage Functions
            local Mode = "SilentAim" :: "Aimbot" | "SilentAim"

            local function Toggle(Enabled: boolean, LastMode: ("Aimbot" | "SilentAim")?)
                Shared.Enabled = Enabled
                _Target = nil

                if LastMode then
                    AimbotModule[LastMode].Start(false)
                end
                AimbotModule[Mode].Start(Enabled)
            end

            local function SetMode(NewMode: "Aimbot" | "SilentAim")
                local LastMode = Mode
                Mode = NewMode

                _Target = nil
                Toggle(Shared.Enabled, LastMode :: "Aimbot" | "SilentAim")
            end

            AimbotModule.Toggle  = Toggle
            AimbotModule.SetMode = SetMode

            return AimbotModule
        end
    end,

    [63] = function(shared, wax, script, require)
        require("../LiteralBlank")

        if wax.shared.ExecutorSupport.require then
            local OriginControlModule = shared.Speaker:WaitForChild("PlayerScripts", 3):WaitForChild("PlayerModule", 3):WaitForChild("ControlModule", 3)

            if OriginControlModule then
                return wax.require(OriginControlModule)
            end
        end

        local ControlModule = {
            GamepadMoveVector    = Vector3.new(),
            ThumbstickMoveVector = Vector3.new(),
            ThumbstickRadius     = 15,
            TouchInput           = nil :: InputObject?,
            TouchStartPosition   = nil :: Vector3?
        };do
            local Vector3_new, math_min
                = Vector3.new, math.min

            local self      = ControlModule
            local Service   = shared.UserInputService :: UserInputService
            local IsKeyDown = Service.IsKeyDown

            local W, A, S, D, Up, Down, Gamepad1, Thumbstick1;do
                local KeyCode = Enum.KeyCode

                W = KeyCode.W
                A = KeyCode.A
                S = KeyCode.S
                D = KeyCode.D

                Up   = KeyCode.Up
                Down = KeyCode.Down

                Thumbstick1 = KeyCode.Thumbstick1
                Gamepad1    = Enum.UserInputType.Gamepad1
            end

            function self:GetMoveVector(): Vector3
                local X, Z = 0, 0

                if IsKeyDown(Service, W) then Z -= 1 end
                if IsKeyDown(Service, A) then X -= 1 end
                if IsKeyDown(Service, S) then Z += 1 end
                if IsKeyDown(Service, D) then X += 1 end

                if IsKeyDown(Service, Up  ) then Z -= 1 end
                if IsKeyDown(Service, Down) then Z += 1 end

                return Vector3_new(X, 0, Z) + self.ThumbstickMoveVector + self.GamepadMoveVector
            end

            shared.Connect:GiveSignal("ControlModuleInputChanged", Service.InputChanged:Connect(function(Input: InputObject, Processed: boolean)
                if Processed then return end

                if Input.UserInputType == Gamepad1 and Input.KeyCode == Thumbstick1 then
                    self.GamepadMoveVector = Vector3_new(Input.Position.X, 0, -Input.Position.Y)
                end
            end))

            shared.Connect:GiveSignal("ControlModuleTouchStarted", Service.TouchStarted:Connect(function(Input: InputObject)
                self.TouchInput = Input
                self.TouchStartPosition = Input.Position
            end))

            shared.Connect:GiveSignal("ControlModuleTouchMoved", Service.TouchMoved:Connect(function(Input: InputObject)
                if Input ~= self.TouchInput then return end

                if not (self.TouchStartPosition and Input.Position) then return end

                local MoveDirection    = (Input.Position - self.TouchStartPosition).Unit
                local Distance         = math_min((Input.Position - self.TouchStartPosition).Magnitude, self.ThumbstickRadius)
                local AdjustedDistance = Distance / self.ThumbstickRadius

                self.ThumbstickMoveVector = Vector3_new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Y * AdjustedDistance)
            end))

            shared.Connect:GiveSignal("ControlModuleTouchEnded", Service.TouchEnded:Connect(function(Input: InputObject)
                if Input ~= self.TouchInput then return end

                self.ThumbstickMoveVector = Vector3_new()
                self.TouchInput = nil
            end))
        end

        return ControlModule
    end,

    [64] = function(shared, wax, script, require)
        local Instance_new, randomstring, table_clear, Vector3_new, typeof, Enum: typeof(Enum)
            = Instance.new, randomstring, table.clear, Vector3.new, typeof, Enum

        local      GetPropertyChangedSignal
            = game.GetPropertyChangedSignal

        local Connect, Dot, Lerp;do
            local Signal = game.Close
            local Vector = Vector3_new()

            Connect = Signal.Connect

            Dot  = Vector.Dot
            Lerp = Vector.Lerp
        end

        local FreeCamera = {
            Enabled = false,
            MaxSpeed = 50,
            Acceleration = 12.5,
            MouseWheelSensitivity = 1
        }

        local Enabled = false

        local Workspace = shared.Workspace :: Workspace
        local Camera    = shared.Camera    :: Camera

        shared.Connect:GiveSignal("FreeCameraCameraChanged", Connect(GetPropertyChangedSignal(Workspace, "CurrentCamera"), function()
            Camera = Workspace.CurrentCamera
        end))

        --// Instances //
        local function New(ClassName: string, Properties: Instance | {[string]: any}): Instance
            local Instance = Instance_new(ClassName)

            if typeof(Properties) == "table" then
                for Property, Value in (Properties :: table) do
                    if Property == "Parent" then continue end
                    (Instance :: any)[Property] = Value
                end

                Instance.Parent = Properties.Parent
                Properties = table_clear((Properties :: table))
            else
                Instance.Parent = (Properties :: Instance)
            end

            Instance.Name = randomstring()
            return Instance
        end

        local TargetVelocity = Vector3_new()

        local ModalElement, RootPart, LinearVelocity, WorldAttachment;do
            local ScreenGui = New("ScreenGui", gethui())

            ModalElement = New("TextButton", {
                Parent = ScreenGui,
                TextTransparency = 1,
                BackgroundTransparency = 1,
                Text = "",
                Visible = true,
                Modal = false
            }) :: TextButton

            RootPart = New("Part", {
                Parent = Workspace,
                Size = Vector3_new(0.5, 0.5, 0.5),
                Transparency = 1,
                CanCollide = false,
                CanTouch = false,
                CanQuery = false,
                Anchored = true,
            }) :: Part

            LinearVelocity = New("LinearVelocity", {
                Parent = RootPart,
                MaxForce = (1 / 0),
                VectorVelocity = TargetVelocity,
                VelocityConstraintMode = Enum.VelocityConstraintMode.Vector,
                RelativeTo = Enum.ActuatorRelativeTo.World,
                Attachment0 = New("Attachment", RootPart)
            }) :: LinearVelocity

            WorldAttachment = New("Attachment", Workspace.Terrain) :: Attachment

            New("AlignOrientation", {
                Parent = RootPart,
                MaxTorque = (1 / 0),
                Responsiveness = 200,
                Attachment0 = New("Attachment", RootPart),
                Attachment1 = WorldAttachment
            })

            wax.AddOnUnload(ScreenGui.Destroy, ScreenGui)
            wax.AddOnUnload(RootPart.Destroy, RootPart)
            wax.AddOnUnload(WorldAttachment.Destroy, WorldAttachment)
        end

        --// Player Variables //
        local PlayerVariables = {};do
            local Connections = {}

            local function BindVariableMonitor(Name: string, Where: Instance, Moded: any)
                local ConnectId = randomstring()
                PlayerVariables[Name] = (Where :: any)[Name]

                Connections[ConnectId] = Connect(GetPropertyChangedSignal(Where, Name), function()
                    local CurrentValue = (Where :: any)[Name]

                    if CurrentValue ~= Moded then
                        PlayerVariables[Name] = CurrentValue
                    end
                end)

                wax.AddOnUnload(Connections[ConnectId].Disconnect, Connections[ConnectId])
            end

            BindVariableMonitor("CameraMaxZoomDistance", shared.Speaker, 0.5)
            BindVariableMonitor("CameraMinZoomDistance", shared.Speaker, 0.5)
            BindVariableMonitor("CameraMode", shared.Speaker, Enum.CameraMode.LockFirstPerson)
        end

        --// Controls //
        local BoostSpeed = 1

        local GamePad  = {
            ButtonL2 = false :: boolean, --/ Move down
            ButtonR2 = false :: boolean, --/ Move up
        }

        local Keyboard = {
            W = false :: boolean,
            A = false :: boolean,
            S = false :: boolean,
            D = false :: boolean,

            Up   = false :: boolean,
            Down = false :: boolean,

            Q = false :: boolean,
            E = false :: boolean,

            LeftShift   = false :: boolean,
            LeftControl = false :: boolean,
            Space       = false :: boolean
        }

        local Controls = {
            UpKeyBindings = {
                E = true,
                ButtonR2 = true,

                Space = false
            },

            DownKeyBindings = {
                Q = true,
                ButtonL2 = true,

                LeftShift   = false,
                LeftControl = false,
            }
        };do
            local math_min, math_max
                = math.min, math.max

            local Pass = Enum.ContextActionResult.Pass
            local Sink = Enum.ContextActionResult.Sink

            local Begin  = Enum.UserInputState.Begin
            local Change = Enum.UserInputState.Change

            local MouseWheel = Enum.UserInputType.MouseWheel

            local GamepadMoveVector    = Vector3_new()
            local ThumbstickMoveVector = Vector3_new()
            local ThumbstickRadius     = 15
            local TouchStartPosition   = nil :: Vector3?
            local TouchInput           = nil :: InputObject?

            function Controls.GetMoveVector(): Vector3
                local X, Z = 0, 0

                if Keyboard.W then Z -= 1 end
                if Keyboard.A then X -= 1 end
                if Keyboard.S then Z += 1 end
                if Keyboard.D then X += 1 end

                if Keyboard.Up   then Z -= 1 end
                if Keyboard.Down then Z += 1 end

                return Vector3_new(X, 0, Z) + GamepadMoveVector + ThumbstickMoveVector
            end

            shared.Connect:GiveSignal("FreeCameraControlsTouchStarted", Connect(shared.UserInputService.TouchStarted, function(Input: InputObject)
                TouchInput = Input
                TouchStartPosition = Input.Position
            end))

            shared.Connect:GiveSignal("FreeCameraControlsTouchMoved", Connect(shared.UserInputService.TouchMoved, function(Input: InputObject)
                if Input ~= TouchInput then return end

                local MoveDirection    = (Input.Position - (TouchStartPosition :: any)).Unit
                local Distance         = math_min((Input.Position - (TouchStartPosition :: any)).Magnitude, ThumbstickRadius)
                local AdjustedDistance = Distance / ThumbstickRadius

                ThumbstickMoveVector = Vector3_new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Z * AdjustedDistance)
            end))

            shared.Connect:GiveSignal("FreeCameraControlsTouchEnded", Connect(shared.UserInputService.TouchEnded, function(Input: InputObject)
                if Input ~= TouchInput then return end

                ThumbstickMoveVector = Vector3_new()
                TouchInput = nil
            end))

            shared.Connect:GiveSignal("FreeCameraControlsMouseWheel", Connect(shared.UserInputService.InputChanged, function(Input: InputObject, Proccessed: boolean)
                if Proccessed or Input.UserInputType ~= MouseWheel then return end

                BoostSpeed += Input.Position.Z * (FreeCamera.MouseWheelSensitivity / 10)
                BoostSpeed  = math_max(0.5, math_min(BoostSpeed, 2))
            end))

            shared.Connect:BindAction(
                "FreeCameraControlsGamepad",
                function(_, State: Enum.UserInputState, Input: InputObject)
                    GamepadMoveVector = Vector3_new(Input.Position.X, 0, -Input.Position.Y)
                    return if Enabled then Sink else Pass
                end,
                false,
                Enum.ContextActionPriority.High,
                Enum.UserInputType.Gamepad1, Enum.KeyCode.Thumbstick1
            )

            shared.Connect:BindAction(
                "FreeCameraControlsGamepadUpDown",
                function(_, State: Enum.UserInputState, Input: InputObject)
                    GamePad[Input.KeyCode.Name] = State == Begin or State == Change
                    return if Enabled then Sink else Pass
                end,
                false,
                Enum.ContextActionPriority.High,
                Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2
            )

            shared.Connect:BindAction(
                "FreeCameraControlsKeyboard",
                function(_, State: Enum.UserInputState, Input: InputObject)
                    Keyboard[Input.KeyCode.Name] = State == Begin or State == Change
                    return if Enabled then Sink else Pass
                end,
                false,
                Enum.ContextActionPriority.High,
                Enum.KeyCode.W , Enum.KeyCode.A   , Enum.KeyCode.S, Enum.KeyCode.D,
                Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Q, Enum.KeyCode.E,
                Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Space
            )
        end

        --// Main Logic //
        local GetMoveVector = Controls.GetMoveVector

        local IsUp, IsDown = false, false

        local function StepRootPart(DeltaTime: number)
            if not Enabled then return end

            local MoveVector = GetMoveVector()

            local LookVector  = Camera.CFrame.LookVector
            local RightVector = Camera.CFrame.RightVector
            local UpVector    = Camera.CFrame.UpVector

            local Forward = LookVector - UpVector * Dot(LookVector, UpVector)
            if Forward.Magnitude > 1e-3 then
                Forward = Forward.Unit
            else
                Forward = (LookVector - Vector3_new(0, 1, 0) * LookVector.Y).Unit
            end

            local Right = RightVector - UpVector * Dot(RightVector, UpVector)
            if Right.Magnitude > 1e-3 then
                Right = Right.Unit
            end

            local MoveDirection = Forward * (-MoveVector.Z) + Right * MoveVector.X

            if IsUp   then MoveDirection += UpVector end
            if IsDown then MoveDirection -= UpVector end

            if MoveDirection.Magnitude > 1e-3 then
                MoveDirection = MoveDirection.Unit
            end

            TargetVelocity = Lerp(TargetVelocity, MoveDirection * FreeCamera.MaxSpeed * BoostSpeed, DeltaTime * FreeCamera.Acceleration)
            LinearVelocity.VectorVelocity = TargetVelocity

            WorldAttachment.CFrame = Camera.CFrame
        end

        local LockFirstPerson = Enum.CameraMode.LockFirstPerson

        local UniversalVisual = require("Visual")

        local function FindUpDown(Direction: "Up" | "Down")
            for Key, IsEnabled in Controls[`{Direction}KeyBindings`] do
                if not IsEnabled then continue end
                if Keyboard[Key] or GamePad[Key] then return true end
            end

            return false
        end

        local function StartFreeCamera(Value: boolean)
            if Enabled == Value then return end

            Enabled            = Value
            FreeCamera.Enabled = Value
            ModalElement.Modal = Value

            if Value then
                TargetVelocity = Vector3_new()
                BoostSpeed = 1

                UniversalVisual.MaxZoom.Stopped = Value
                UniversalVisual.MinZoom.Stopped = Value

                shared.Connect:GiveSignal("StepFreeCamera", Connect(shared.RunService.PreRender, function(DeltaTime: number)
                    shared.Speaker.CameraMinZoomDistance = 0.5
                    shared.Speaker.CameraMaxZoomDistance = 0.5
                    shared.Speaker.CameraMode = LockFirstPerson

                    IsUp   = FindUpDown("Up")
                    IsDown = FindUpDown("Down")

                    StepRootPart(DeltaTime)
                end))
            else
                shared.Connect:GiveSignal("StepFreeCamera", Connect(shared.RunService.PreRender, function()
                    RootPart.CFrame = Camera.CFrame
                end))

                shared.Speaker.CameraMode = PlayerVariables.CameraMode
                shared.Speaker.CameraMaxZoomDistance = PlayerVariables.CameraMaxZoomDistance
                shared.Speaker.CameraMinZoomDistance = (PlayerVariables.CameraMinZoomDistance + PlayerVariables.CameraMaxZoomDistance) / 2
                shared.Speaker.CameraMinZoomDistance = PlayerVariables.CameraMinZoomDistance

                UniversalVisual.MaxZoom.Stopped = Value
                UniversalVisual.MinZoom.Stopped = Value
            end
        end

        FreeCamera.Start = StartFreeCamera
        FreeCamera.Controls = Controls

        return FreeCamera
    end,

    [65] = function(shared, wax, script, require)
        local Universal = {}

        do
            local pcall, getconnections
                = pcall, getconnections

            Universal.AntiAFK = {
                Enabled = false,
                Support = wax.shared.ExecutorSupport.getconnections :: boolean,

                Idled   = shared.Speaker.Idled :: RBXScriptSignal,

                Start = function(Enabled: boolean)
                    local self   = Universal.AntiAFK
                    self.Enabled = Enabled

                    if not self.Support then return end

                    local Connections = getconnections(self.Idled)
                    local CallValue   = Enabled and "Disable" or "Enable"

                    for _, Connection: any in Connections do
                        pcall(Connection[CallValue], Connection)
                    end
                end
            }
        end

        do
            local      GetFullName, checkcaller, getcallingscript, getnamecallmethod, hookfunction, hookmetamethod, warn
                = game.GetFullName, checkcaller, getcallingscript, getnamecallmethod, hookfunction, hookmetamethod, warn

            local ExecutorName = identifyexecutor()

            local function FormatCaller(Calling: (Instance | string)?, IsExecutor: boolean, Message: string?): string
                if typeof(Calling) ~= "Instance" then
                    Calling = if IsExecutor then `{ExecutorName} LocalScript` else "Unknown"
                else
                    Calling = if not Calling.Parent then `[nil].{Calling.Name}` else GetFullName(Calling)
                end

                return `[MFeee~ New] Prevented a kick! Calling script: "{Calling}", Message: "{Message}"`
            end

            Universal.AntiKick = {
                Enabled  = false,
                Support1 = wax.shared.ExecutorSupport.hookfunction      :: boolean,
                Support2 = wax.shared.ExecutorSupport.hookmetamethod    :: boolean,
                Support3 = wax.shared.ExecutorSupport.checkcaller       :: boolean,
                Support4 = wax.shared.ExecutorSupport.getcallingscript  :: boolean,
                Support5 = wax.shared.ExecutorSupport.getnamecallmethod :: boolean,

                Kick = shared.Speaker.Kick :: (self: any, Message: string) -> nil,

                OldFunction = nil :: ((self: any, Message: string?) -> any) | nil,
                OldNameCall = nil :: ((self: any, any) -> (...any)) | nil,

                Start = function(Enabled: boolean)
                    local self   = Universal.AntiKick
                    self.Enabled = Enabled

                    local CanFormat = self.Support3 and self.Support4

                    if self.Support1 then
                        if Enabled then
                            self.OldFunction = hookfunction(self.Kick, function(self: any, Message: string?)
                                if CanFormat then
                                    local IsExecutor = checkcaller()
                                    local Calling    = getcallingscript()

                                    warn(FormatCaller(Calling, IsExecutor, Message))
                                end
                            end) :: ((self: any, Message: string?) -> any) | nil
                        elseif self.OldFunction then
                            hookfunction(self.Kick, self.OldFunction)
                            self.OldFunction = nil
                        end
                    end

                    if self.Support2 and self.Support5 then
                        if Enabled then
                            local Speaker = shared.Speaker
                            local OldNameCall: typeof(self.OldNameCall)

                            self.OldNameCall = hookmetamethod(game, "__namecall", function(self: any, ...: any)
                                if self ~= Speaker or getnamecallmethod() ~= "Kick" then
                                    return (OldNameCall or self.OldNameCall)(self, ...)
                                end

                                if CanFormat then
                                    local IsExecutor = checkcaller()
                                    local Calling = getcallingscript()

                                    warn(FormatCaller(Calling, IsExecutor, ...))
                                end
                            end) :: ((self: any, any) -> (...any)) | nil

                            OldNameCall = self.OldNameCall
                        elseif self.OldNameCall then
                            hookmetamethod(game, "__namecall", self.OldNameCall)
                            self.OldNameCall = nil
                        end
                    end
                end
            }
        end

        return Universal
    end,

    [66] = function(shared, wax, script, require)
        local pcall, table_clear, Instance_new, task_wait, PhysicalProperties_new, Vector3_new, CFrame_lookAt, RaycastParams_new
            = pcall, table.clear, Instance.new, task.wait, PhysicalProperties.new, Vector3.new, CFrame.lookAt, RaycastParams.new

        local      IsA,      Destroy,      GetPropertyChangedSignal,      GetDescendants,                CharacterAdded
            = game.IsA, game.Destroy, game.GetPropertyChangedSignal, game.GetDescendants, shared.Speaker.CharacterAdded

        local      FindFirstChild,      FindFirstChildOfClass,      WaitForChild
            = game.FindFirstChild, game.FindFirstChildOfClass, game.WaitForChild

        local Custom, Track, Scriptable, Vector, World, Wait, Connect, Once, Dot, VectorLerp, CFrameLerp, TranslateBy;do
            local Model      = Instance_new("Model")
            local Signal     = game.Close :: RBXScriptSignal
            local Vector3    = Vector3_new()
            local CFrame     = CFrame.new()
            local CameraType = Enum.CameraType

            TranslateBy = Model.TranslateBy

            Custom     = CameraType.Custom
            Track      = CameraType.Track
            Scriptable = CameraType.Scriptable

            Vector = Enum.VelocityConstraintMode.Vector
            World  = Enum.ActuatorRelativeTo.World

            Wait    = Signal.Wait
            Connect = Signal.Connect
            Once    = Signal.Once

            Dot = Vector3.Dot

            VectorLerp = Vector3.Lerp
            CFrameLerp = CFrame.Lerp

            Destroy(Model)
        end

        local Universal = {}

        local Inf = (1 / 0)
        local Nan = (0 / 0)

        local Toggles = wax.shared.UiManager.Library.Toggles

        local ControlModule = require("../Universal/ControlModule")
        local GetMoveVector = ControlModule.GetMoveVector

        local _Connect = shared.Connect
        local GiveSignal = _Connect.GiveSignal
        local DisconnectSignal = _Connect.DisconnectSignal

        local Workspace = shared.Workspace
        local Raycast   = Workspace.Raycast

        local function GetCharacter()
            return shared.Speaker.Character or Wait(CharacterAdded)
        end

        local function GetHumanoid(Character: Model)
            return Character and FindFirstChildOfClass(Character, "Humanoid")
        end

        local function WaitHumanoid(Character: Model)
            return Character and WaitForChild(Character, "Humanoid")
        end

        local function WaitRootPart(Character: Model)
            return Character and WaitForChild(Character, "HumanoidRootPart")
        end

        local TempCharacter = shared.Speaker.Character
        local TempHumanoid  = GetHumanoid(TempCharacter)

        type Template<T> = {
            Enabled: boolean,
            Stopped: boolean,

            Default: (nil & T)?,
            Moded:   (nil & T)?,
        }

        local function GenerateOverride<T>(
            IsHumanoid: boolean,  Property: string,
            Default: (nil & T)?,  Moded: (nil & T)?, Object: any
        )
            local ChangedSignal  = `{Property}ChangedSignal`
            local _CharacterAdded = if IsHumanoid then `{Property}CharacterAdded` else nil

            local Generated = {
                Enabled = false,
                Stopped = false,

                Default = Default,
                Moded   = Moded or Default
            }

            function Generated.Override(Enabled: boolean)
                local self   = Generated
                self.Enabled = Enabled

                if Enabled then
                    if IsHumanoid then
                        local Humanoid = WaitHumanoid(GetCharacter())

                        local function ConnectChanged()
                            GiveSignal(_Connect, ChangedSignal, Connect(GetPropertyChangedSignal(Humanoid, Property), function()
                                if self.Stopped then return end

                                local CurrentValue = Humanoid[Property]
                                if CurrentValue ~= self.Moded then
                                    self.Default = CurrentValue
                                end

                                Humanoid[Property] = self.Moded
                            end))
                        end

                        ConnectChanged()

                        GiveSignal(_Connect, _CharacterAdded, Connect(CharacterAdded, function(NewCharacter)
                            Humanoid = WaitHumanoid(NewCharacter)

                            ConnectChanged()

                            self.Default   = Humanoid[Property]
                            Humanoid[Property] = self.Moded
                        end))

                        self.Default   = Humanoid[Property]
                        Humanoid[Property] = self.Moded
                    else
                        GiveSignal(_Connect, ChangedSignal, Connect(GetPropertyChangedSignal(Object, Property), function()
                            if self.Stopped then return end

                            local CurrentValue = Object[Property]
                            if CurrentValue ~= self.Moded then
                                self.Default = self.Moded
                            end

                            Object[Property] = self.Moded
                        end))

                        self.Default = Object[Property]
                        Object[Property] = self.Moded
                    end
                else
                    DisconnectSignal(_Connect, ChangedSignal)

                    if IsHumanoid then
                        DisconnectSignal(_Connect, _CharacterAdded)
                        pcall(function()
                            shared.Speaker.Character.Humanoid[Property] = self.Default
                        end)
                    else
                        pcall(function()
                            Object[Property] = self.Default
                        end)
                    end
                end
            end

            function Generated.SetValue(Value: T)
                local self = Generated
                self.Moded = (Value :: any)

                if not self.Enabled then return end

                pcall(function()
                    if IsHumanoid then
                        GetHumanoid(shared.Speaker.Character)[Property] = Value
                    elseif Object then
                        Object[Property] = Value
                    end
                end)
            end

            return Generated
        end

        Universal.WalkSpeed  = GenerateOverride(
            true,
            "WalkSpeed",
            TempHumanoid and TempHumanoid.WalkSpeed or 16
        )

        Universal.JumpHeight = GenerateOverride(
            true,
            "JumpHeight",
            TempHumanoid and TempHumanoid.JumpHeight or 7.2
        )

        Universal.JumpPower  = GenerateOverride(
            true,
            "JumpPower",
            TempHumanoid and TempHumanoid.JumpPower or 50
        )

        Universal.Gravity    = GenerateOverride(
            false,
            "Gravity",
            Workspace.Gravity,
            nil,
            Workspace
        )

        Universal.NoAcceleration = {
            Enabled        = false,
            DefaultPhysics = nil,

            Override = function(Enabled: boolean)
                local self   = Universal.NoAcceleration
                self.Enabled = Enabled

                if Enabled then
                    local RootPart = WaitRootPart(GetCharacter())
                    local Moded

                    self.DefaultPhysics = RootPart.CustomPhysicalProperties or RootPart.CurrentPhysicalProperties or PhysicalProperties_new(0.7, 0.3, 0.5, 1, 1)

                    local function Change()
                        Moded = PhysicalProperties_new(
                            100,
                            self.DefaultPhysics.Friction,
                            self.DefaultPhysics.Elasticity,
                            self.DefaultPhysics.FrictionWeight,
                            self.DefaultPhysics.ElasticityWeight
                        )
                        return Moded
                    end

                    GiveSignal(_Connect, "NoAcceleration", Connect(GetPropertyChangedSignal(RootPart, "CustomPhysicalProperties"), function()
                        local CurrentValue = RootPart.CustomPhysicalProperties
                        if CurrentValue ~= Moded then
                            self.DefaultPhysics = CurrentValue
                        end

                        RootPart.CustomPhysicalProperties = Change()
                    end))

                    RootPart.CustomPhysicalProperties = Change()
                else
                    DisconnectSignal(_Connect, "NoAcceleration")
                    pcall(function()
                        shared.Speaker.Character.HumanoidRootPart.CustomPhysicalProperties = self.DefaultPhysics
                    end)
                end
            end
        }

        Universal.AntiVoidFall = {
            Enabled = false,
            Default = Workspace.FallenPartsDestroyHeight,

            Override = function(Enabled: boolean)
                local self   = Universal.AntiVoidFall
                self.Enabled = Enabled

                if Enabled then
                    GiveSignal(_Connect, "AntiVoidFall", Connect(GetPropertyChangedSignal(Workspace, "FallenPartsDestroyHeight"), function()
                        local CurrentValue = Workspace.FallenPartsDestroyHeight
                        --// NaN check
                        if CurrentValue ~= CurrentValue then return end

                        self.Default = CurrentValue
                        Workspace.FallenPartsDestroyHeight = Nan
                    end))

                    self.Default = Workspace.FallenPartsDestroyHeight
                    Workspace.FallenPartsDestroyHeight = Nan
                else
                    DisconnectSignal(_Connect, "AntiVoidFall")
                    Workspace.FallenPartsDestroyHeight = self.Default
                end
            end
        }

        Universal.SpeedBoost = {
            Enabled    = false,
            BoostSpeed = 0,

            Override = function(Enabled: boolean)
                local self   = Universal.SpeedBoost
                self.Enabled = Enabled

                if Enabled then
                    GiveSignal(_Connect, "SpeedBoost", Connect(shared.RunService.Heartbeat, function(DeltaTime)
                        local Character = shared.Speaker.Character
                        local Humanoid  = GetHumanoid(Character)
                        if not Humanoid then return end

                        TranslateBy(Character, Humanoid.MoveDirection * self.BoostSpeed * DeltaTime)
                    end))
                else
                    DisconnectSignal(_Connect, "SpeedBoost")
                end
            end
        }

        Universal.Noclip = {
            CharacterEnabled = false,
            VehicleEnabled   = false,

            CharacterNoclipedParts = {},
            VehicleNoclipedParts   = {},

            CharacterNoclip = function(Enabled: boolean)
                local self = Universal.Noclip
                self.CharacterEnabled = Enabled

                if Enabled then
                    return GiveSignal(_Connect, "NoclipPreSimulation", Connect(shared.RunService.PreSimulation, function()
                        local Character = shared.Speaker.Character
                        if not Character then return end

                        for _, Part: BasePart in GetDescendants(Character) do
                            if not (IsA(Part, "BasePart") and Part.CanCollide) then continue end

                            Part.CanCollide = false
                            self.CharacterNoclipedParts[Part] = true
                        end
                    end))
                else
                    DisconnectSignal(_Connect, "NoclipPreSimulation")

                    local function Clip()
                        for Part: BasePart in self.CharacterNoclipedParts do
                            if not IsA(Part, "BasePart") then continue end
                            Part.CanCollide = true
                        end

                        table_clear(self.CharacterNoclipedParts)
                    end

                    local Character = shared.Speaker.Character
                    local RootPart  = Character and FindFirstChild(Character, "HumanoidRootPart")
                    if not RootPart then return Clip() end

                    local RaycastParams = RaycastParams_new()
                    RaycastParams.FilterDescendantsInstances = {Character}

                    local RootSize = (RootPart :: Part).Size / 2

                    local Directions = {
                        Vector3_new( RootSize.X, 0, 0),
                        Vector3_new(-RootSize.X, 0, 0),
                        Vector3_new(0,  RootSize.Y, 0),
                        Vector3_new(0, -RootSize.Y, 0),
                        Vector3_new(0, 0,  RootSize.Z),
                        Vector3_new(0, 0, -RootSize.Z)
                    }

                    for _, Direction in Directions do
                        local RaycastResult = Raycast(Workspace, RootPart.Position, Direction, RaycastParams)
                        if not RaycastResult then continue end

                        local HitPart = RaycastResult.Instance
                        if HitPart and HitPart.CanCollide then
                            return table_clear(self.CharacterNoclipedParts)
                        end
                    end

                    return Clip()
                end
            end,

            VehicleNoclip = function(Enabled: boolean)
                local self = Universal.Noclip
                self.VehicleEnabled = Enabled

                if Enabled then
                    GiveSignal(_Connect, "VehicleNoclipPreSimulation", Connect(shared.RunService.PreSimulation, function()
                        local Humanoid = GetHumanoid(shared.Speaker.Character)
                        if not Humanoid then return end

                        local VehicleSeat = Humanoid.SeatPart
                        if not (VehicleSeat and IsA(VehicleSeat, "VehicleSeat")) then return end

                        local VehicleModel = VehicleSeat.Parent
                        while not IsA(VehicleModel, "Model") do
                            VehicleModel = VehicleModel.Parent
                        end

                        for _, Part in GetDescendants(VehicleModel) do
                            if not (IsA(Part, "BasePart") and Part.CanCollide) then continue end

                            Part.CanCollide = false
                            self.VehicleNoclipedParts[Part] = true
                        end
                    end))
                else
                    DisconnectSignal(_Connect, "VehicleNoclipPreSimulation")

                    for Part in self.VehicleNoclipedParts do
                        if not IsA(Part, "BasePart") then continue end
                        Part.CanCollide = true
                    end

                    table_clear(self.VehicleNoclipedParts)
                end
            end
        }

        Universal.NoTouch = {
            --// No touch can prevent 99% of touch damage/detection.
            --// Such as obby lava blocks, trap hitboxes...
            --// But it broke some game mechanics like door opening, etc.
            Enabled        = false,
            NoTouchedParts = {},

            Start = function(Enabled: boolean)
                local self = Universal.NoTouch
                self.Enabled = Enabled

                if Enabled then
                    GiveSignal(_Connect, "NoTouchPreSimulation", Connect(shared.RunService.PreSimulation, function()
                        local Character = shared.Speaker.Character
                        if not Character then return end

                        for _, Part in GetDescendants(Character) do
                            if not (IsA(Part, "BasePart") and Part.CanTouch) then continue end
                            if self.NoTouchedParts[Part] then continue end

                            Part.CanTouch = false
                            self.NoTouchedParts[Part] = true
                        end
                    end))
                else
                    DisconnectSignal(_Connect, "NoTouchPreSimulation")

                    for Part in self.NoTouchedParts do
                        if not IsA(Part, "BasePart") then continue end
                        Part.CanTouch = true
                    end

                    table_clear(self.NoTouchedParts)
                end
            end
        }

        Universal.Fly = {
            Enabled = false :: boolean,

            StopFlyOnDied = false :: boolean,

            UseGyro      = true  :: boolean,
            UseUpVector  = true  :: boolean,
            LookToCamera = true  :: boolean,
            FixCamera    = false :: boolean,

            FlySpeed        = 32  :: number,
            GyroSensitivity = 500 :: number,

            ConstraintsAcceleration   = 9.375 :: number,
            ConstraintsMaxSpeed       = 32    :: number,
            ConstraintsTurnSpeed      = 7.5   :: number,
            ConstraintsResponsiveness = 100   :: number,

            PreCameraType = shared.Camera.CameraType :: Enum.CameraType,

            FlyMode   = "SmartFly" :: "SmartFly" | "StandFly" | "SitFly" | "VehicleFly",
            FlyMethod = "Constraints" :: "Constraints" | "BodyMovers",

            UpKeyBinding   = Enum.KeyCode.E :: Enum.KeyCode | Enum.UserInputType,
            DownKeyBinding = Enum.KeyCode.Q :: Enum.KeyCode | Enum.UserInputType,

            IsUp   = false :: boolean,
            IsDown = false :: boolean,

            HandleHumanoidState = function(self, Humanoid: Humanoid)
                if     self.FlyMode == "SmartFly" then
                    Humanoid.PlatformStand = not Humanoid.Sit
                elseif self.FlyMode == "StandFly" then
                    Humanoid.PlatformStand = true
                elseif self.FlyMode == "SitFly" then
                    Humanoid.Sit = true
                elseif self.FlyMode == "VehicleFly" then
                    Humanoid.Sit = Humanoid.SeatPart ~= nil
                    Humanoid.PlatformStand = false
                end
            end,

            EndProgress = function(self)
                pcall(function()
                    local Humanoid: Humanoid = shared.Speaker.Character.Humanoid
                    Humanoid.PlatformStand = false
                    Humanoid.Sit = Humanoid.SeatPart ~= nil
                end)

                pcall(function()
                    shared.Camera.CameraType = (self.PreCameraType or Custom) :: Enum.CameraType
                end)
            end,

            HandleCamera = function(self)
                pcall(function()
                    if not self.FixCamera and self.PreCameraType ~= Scriptable then
                        shared.Camera.CameraType = Track
                    elseif self.FixCamera then
                        shared.Camera.CameraType = self.PreCameraType
                    end
                end)
            end,

            OnDied = function(self, Method)
                if self.StopFlyOnDied then
                    Toggles.Fly:SetValue(false)
                else
                    self[Method].Start(self, false)
                    Once(CharacterAdded, function()
                        self[Method].Start(self, true)
                    end)
                end
            end,

            BodyMovers = {
                Enabled = false,

                BodyVelocity = nil,
                BodyGyro     = nil,

                Start = function(self, Enabled: boolean)
                    self.BodyMovers.Enabled = Enabled

                    if self.Constraints.Enabled and Enabled then
                        self.Constraints.Start(self, false)
                        task_wait()
                    end

                    if Enabled then
                        local Character = GetCharacter()
                        local Humanoid  = WaitHumanoid(Character)
                        local RootPart  = Humanoid.RootPart
                        if not RootPart then
                            RootPart = WaitRootPart(Character)
                        end

                        if not (self.Enabled or self.BodyMovers.Enabled) then return end

                        self.BodyMovers.BodyVelocity          = Instance_new("BodyVelocity")
                        self.BodyMovers.BodyVelocity.Name     = "EPIc_VELOCITY"
                        self.BodyMovers.BodyVelocity.MaxForce = Vector3_new(Inf, Inf, Inf)
                        self.BodyMovers.BodyVelocity.Velocity = Vector3_new()
                        self.BodyMovers.BodyVelocity.Parent   = RootPart

                        if self.UseGyro then
                            self.BodyMovers.BodyGyro           = Instance_new("BodyGyro")
                            self.BodyMovers.BodyGyro.Name      = "EPIc_VELOCITY"
                            self.BodyMovers.BodyGyro.P         = 9e4
                            self.BodyMovers.BodyGyro.MaxTorque = Vector3_new(Inf, Inf, Inf)
                            self.BodyMovers.BodyGyro.CFrame    = shared.Camera.CFrame
                            self.BodyMovers.BodyGyro.Parent    = RootPart
                        end

                        self.PreCameraType = shared.Camera.CameraType

                        GiveSignal(_Connect, "BodyMoversFly", Connect(shared.RunService.PreSimulation, function()
                            if not Humanoid or Humanoid.Health <= 0 then return end
                            if not (self.Enabled or self.BodyMovers.Enabled) then return end

                            self:HandleHumanoidState(Humanoid)

                            local MoveVector = GetMoveVector(ControlModule)
                            local Velocity   = -((shared.Camera.CFrame.LookVector * MoveVector.Z) - (shared.Camera.CFrame.RightVector * MoveVector.X))

                            local UpVector = self.UseUpVector and shared.Camera.CFrame.UpVector or Vector3_new(0, 1, 0)

                            if self.IsUp   then Velocity += UpVector end
                            if self.IsDown then Velocity -= UpVector end

                            self.BodyMovers.BodyVelocity.Velocity = Velocity * self.FlySpeed

                            self:HandleCamera()

                            if self.UseGyro then
                                self.BodyMovers.BodyGyro.D      = self.GyroSensitivity
                                self.BodyMovers.BodyGyro.CFrame = shared.Camera.CFrame
                            end
                        end))

                        GiveSignal(_Connect, "BodyMoversFlyDied", Humanoid.Died:Once(function()
                            self:OnDied("BodyMovers")
                        end))
                    else
                        DisconnectSignal(_Connect, "BodyMoversFly")
                        DisconnectSignal(_Connect, "BodyMoversFlyDied")

                        pcall(function()
                            Destroy(self.BodyMovers.BodyVelocity)
                            Destroy(self.BodyMovers.BodyGyro)
                        end)

                        self:EndProgress()
                    end
                end
            },

            Constraints = {
                Enabled = false,

                LinearVelocity        = nil :: Instance?,
                AlignOrientation      = nil :: Instance?,
                AttachmentVelocity    = nil :: Instance?,
                AttachmentOrientation = nil :: Instance?,
                AttachmentWorld       = nil :: Instance?,

                TargetVelocity = Vector3_new(),
                TargetCFrame   = nil  :: CFrame?,

                Start = function(self, Enabled: boolean)
                    self.Constraints.Enabled = Enabled

                    if self.BodyMovers.Enabled and Enabled then
                        self.BodyMovers.Start(self, false)
                        task_wait()
                    end

                    if Enabled then
                        local Character = GetCharacter()
                        local Humanoid  = WaitHumanoid(Character)
                        local RootPart  = Humanoid.RootPart
                        if not RootPart then
                            RootPart = WaitRootPart(Character)
                        end

                        if not (self.Enabled or self.Constraints.Enabled) then return end

                        self.Constraints.TargetVelocity = Vector3_new()
                        self.Constraints.TargetCFrame   = RootPart.CFrame :: CFrame

                        self.Constraints.LinearVelocity        = Instance_new("LinearVelocity", RootPart)
                        self.Constraints.AlignOrientation      = Instance_new("AlignOrientation", RootPart)
                        self.Constraints.AttachmentVelocity    = Instance_new("Attachment", RootPart)
                        self.Constraints.AttachmentOrientation = Instance_new("Attachment", RootPart)
                        self.Constraints.AttachmentWorld       = Instance_new("Attachment", Workspace.Terrain)

                        self.Constraints.LinearVelocity.MaxForce               = Inf
                        self.Constraints.LinearVelocity.VectorVelocity         = self.Constraints.TargetVelocity
                        self.Constraints.LinearVelocity.VelocityConstraintMode = Vector
                        self.Constraints.LinearVelocity.RelativeTo             = World
                        self.Constraints.LinearVelocity.Attachment0            = self.Constraints.AttachmentVelocity

                        self.Constraints.AlignOrientation.MaxTorque      = Inf
                        self.Constraints.AlignOrientation.Responsiveness = self.ConstraintsResponsiveness
                        self.Constraints.AlignOrientation.Attachment0    = self.Constraints.AttachmentOrientation
                        self.Constraints.AlignOrientation.Attachment1    = self.Constraints.AttachmentWorld

                        self.PreCameraType = shared.Camera.CameraType

                        GiveSignal(_Connect, "ConstraintsFly", Connect(shared.RunService.Heartbeat, function(DeltaTime: number)
                            if not Humanoid or Humanoid.Health <= 0 then return end
                            if not (self.Enabled or self.Constraints.Enabled) then return end

                            local MoveVector    = GetMoveVector(ControlModule) :: Vector3
                            local MoveDirection = Vector3_new()

                            self:HandleHumanoidState(Humanoid)

                            local LookVector  = shared.Camera.CFrame.LookVector  :: Vector3
                            local RightVector = shared.Camera.CFrame.RightVector :: Vector3
                            local UpVector    = (self.UseUpVector and shared.Camera.CFrame.UpVector or Vector3_new(0, 1, 0)) :: Vector3

                            local Forward = LookVector - UpVector * Dot(LookVector, UpVector)
                            if Forward.Magnitude > 1e-3 then
                                Forward = Forward.Unit
                            else
                                Forward = (LookVector - Vector3_new(0, 1, 0) * LookVector.Y).Unit
                            end

                            local Right = RightVector - UpVector * Dot(RightVector, UpVector)
                            if Right.Magnitude > 1e-3 then
                                Right = Right.Unit
                            end

                            MoveDirection = Forward * (-MoveVector.Z) + Right * MoveVector.X

                            if self.IsUp   then MoveDirection += UpVector end
                            if self.IsDown then MoveDirection -= UpVector end

                            if MoveDirection.Magnitude > 1e-3 then
                                MoveDirection = MoveDirection.Unit
                            end

                            self.Constraints.TargetVelocity = VectorLerp(self.Constraints.TargetVelocity, MoveDirection * self.ConstraintsMaxSpeed, DeltaTime * self.ConstraintsAcceleration)

                            self.Constraints.LinearVelocity  .VectorVelocity = self.Constraints.TargetVelocity
                            self.Constraints.AlignOrientation.Responsiveness = self.ConstraintsResponsiveness

                            self:HandleCamera()

                            if self.LookToCamera then
                                self.Constraints.AttachmentWorld.CFrame = shared.Camera.CFrame
                            elseif self.Constraints.TargetVelocity.Magnitude > 1 then
                                local FlatVelocity = Vector3_new(self.Constraints.TargetVelocity.X, 0, self.Constraints.TargetVelocity.Z)

                                if FlatVelocity.Magnitude > 1 then
                                    local TargetLook = CFrame_lookAt(RootPart.Position, RootPart.Position + FlatVelocity)
                                    self.Constraints.TargetCFrame = CFrameLerp(self.Constraints.TargetCFrame, TargetLook, DeltaTime * self.ConstraintsTurnSpeed)

                                    self.Constraints.AttachmentWorld.CFrame = self.Constraints.TargetCFrame
                                end
                            end
                        end))

                        GiveSignal(_Connect, "ConstraintsFlyDied", Humanoid.Died:Once(function()
                            self:OnDied("Constraints")
                        end))
                    else
                        DisconnectSignal(_Connect, "ConstraintsFly")
                        DisconnectSignal(_Connect, "ConstraintsFlyDied")

                        pcall(function()
                            Destroy(self.Constraints.LinearVelocity)
                            Destroy(self.Constraints.AlignOrientation)
                            Destroy(self.Constraints.AttachmentVelocity)
                            Destroy(self.Constraints.AttachmentOrientation)
                            Destroy(self.Constraints.AttachmentWorld)
                        end)

                        self:EndProgress()
                    end
                end
            },

            StartFly = function(Enabled: boolean)
                local self   = Universal.Fly
                self.Enabled = Enabled

                self[self.FlyMethod].Start(self, Enabled)
            end,

            BindKey = function(Key: Enum.KeyCode | Enum.UserInputType, Direction: "Up" | "Down")
                local self  = Universal.Fly

                if Direction == "Up" then
                    self.UpKeyBinding   = Key
                    self.IsUp   = false
                else
                    self.DownKeyBinding = Key
                    self.IsDown = false
                end
            end
        }

        do
            local self = Universal.Fly

            GiveSignal(_Connect, "InputBeganFly", Connect(shared.UserInputService.InputBegan, function(Input, Processed)
                if Processed then
                elseif self.UpKeyBinding   == Input.UserInputType or self.UpKeyBinding   == Input.KeyCode then
                    self.IsUp   = true
                elseif self.DownKeyBinding == Input.UserInputType or self.DownKeyBinding == Input.KeyCode then
                    self.IsDown = true
                end
            end))

            GiveSignal(_Connect, "InputEndedFly", Connect(shared.UserInputService.InputEnded, function(Input)
                if     self.UpKeyBinding   == Input.UserInputType or self.UpKeyBinding   == Input.KeyCode then
                    self.IsUp   = false
                elseif self.DownKeyBinding == Input.UserInputType or self.DownKeyBinding == Input.KeyCode then
                    self.IsDown = false
                end
            end))
        end

        return Universal
    end,

    [67] = function(shared, wax, script, require)
        local PromptController = {
            Instances        = {},
            HoldDuration     = {},

            MaxActivationDistance = {},
            RequiresLineOfSight   = {},

            HoldDurationEnabled          = false,
            MaxActivationDistanceEnabled = false,
            RequiresLineOfSightEnabled   = false,

            Multiplier = 1
        }

        --// Local Caches //
        local type, randomstring
            = type, randomstring

        local shared_Connect
            = shared.Connect

        local GiveSignal       = shared_Connect.GiveSignal
        local DisconnectSignal = shared_Connect.DisconnectSignal

        local      IsA,      GetPropertyChangedSignal
            = game.IsA, game.GetPropertyChangedSignal

        local Once, Connect;do
            local Signal = game.Close

            Once    = Signal.Once
            Connect = Signal.Connect
        end

        --// Init //
        local function InsertPrompt(Instance: ProximityPrompt)
            if not IsA(Instance, "ProximityPrompt") then return end

            local self = PromptController

            self.Instances   [Instance] = randomstring()
            self.HoldDuration[Instance] = Instance.HoldDuration

            self.MaxActivationDistance[Instance] = Instance.MaxActivationDistance
            self.RequiresLineOfSight  [Instance] = Instance.RequiresLineOfSight

            GiveSignal(shared_Connect, Instance, Once(Instance.Destroying, function()
                self.Instances   [Instance] = nil
                self.HoldDuration[Instance] = nil

                self.MaxActivationDistance[Instance] = nil
                self.RequiresLineOfSight  [Instance] = nil
            end))
        end

        for _, Descendant in shared.Workspace:GetDescendants() do
            InsertPrompt(Descendant)
        end

        GiveSignal(shared_Connect, "OnPromptAdded", Connect(shared.Workspace.DescendantAdded, InsertPrompt))

        --// Main Logic //
        local function ModTemplate(Property: string, Expected: boolean | number, IsMultiple: boolean?)
            local self = PromptController

            for Prompt: any, Id in self.Instances do
                if self[`{Property}Enabled`] then
                    local Value = if type(Expected) == "boolean" then Expected else (Expected * (IsMultiple and self[Property][Prompt]) or 1)

                    GiveSignal(shared_Connect, `{Property}-{Id}`, Connect(GetPropertyChangedSignal(Prompt, Property), function()
                        Prompt[Property] = Value
                    end))
                    Prompt[Property] = Value
                else
                    DisconnectSignal(shared_Connect, `{Property}-{Id}`)
                    Prompt[Property] = self[Property][Prompt]
                end
            end
        end

        function PromptController.InstantInteract(Enabled: boolean)
            local self = PromptController
            self.HoldDurationEnabled = Enabled

            ModTemplate("HoldDuration", 0)
        end

        function PromptController.DistanceMultiplier(Enabled: boolean)
            local self = PromptController
            self.MaxActivationDistanceEnabled = Enabled

            ModTemplate("MaxActivationDistance", self.Multiplier, true)
        end

        function PromptController.SetMultiplier(Multiplier: number)
            local self = PromptController
            self.Multiplier = Multiplier

            ModTemplate("MaxActivationDistance", self.Multiplier, true)
        end

        function PromptController.PromptNoclip(Enabled: boolean)
            local self = PromptController
            self.RequiresLineOfSightEnabled = Enabled

            ModTemplate("RequiresLineOfSight", false)
        end

        return PromptController
    end,

    [68] = function(shared, wax, script, require)
        local randomstring
            = randomstring

        local      GetPropertyChangedSignal
            = game.GetPropertyChangedSignal

        local Connect;do
            local Signal = game.Close

            Connect = Signal.Connect
        end

        local Universal = {}

        local EasingLibrary = wax.shared.EasingLibrary
        local RunningTween  = EasingLibrary.RunningTween
        local Ease = EasingLibrary.Ease

        local _Connect = shared.Connect
        local GiveSignal = _Connect.GiveSignal
        local DisconnectSignal = _Connect.DisconnectSignal

        type Template<T> = {
            Enabled: boolean,
            Stopped: boolean,

            Default: (nil & T)?,
            Moded:   (nil & T)?,
        }

        local function GenerateFor<T>(Object: Instance, Property: string, Default: (nil & T)?, Moded: (nil & T)?): Template<T>
            local EaseIndex     = randomstring()
            local ChangedSignal = `{Property}ChangedSignal`

            local Generated = {
                Enabled = false,
                Stopped = false,

                Default = Default or (Object :: any)[Property],
                Moded   = Moded   or (Object :: any)[Property]
            }

            function Generated.Start(Enabled: boolean)
                local self   = Generated
                self.Enabled = Enabled

                if Enabled then
                    Ease(EasingLibrary, Object, Property, self.Moded, EaseIndex)

                    GiveSignal(_Connect, ChangedSignal, Connect(GetPropertyChangedSignal(Object, Property), function()
                        if self.Stopped then return end

                        local CurrentValue = (Object :: any)[Property]
                        if CurrentValue ~= self.Moded then
                            self.Default = CurrentValue
                        end

                        if not RunningTween[EaseIndex] then
                            (Object :: any)[Property] = self.Moded
                        end
                    end))
                else
                    DisconnectSignal(ChangedSignal)
                    Ease(EasingLibrary, Object, Property, self.Default, EaseIndex)
                end
            end

            function Generated.SetValue(Value: T)
                local self = Generated
                self.Moded = (Value :: any)

                if not self.Enabled then return end
                Ease(EasingLibrary, Object, Property, Value, EaseIndex)
            end

            return Generated
        end

        Universal.FOV     = GenerateFor(shared.Camera , "FieldOfView")
        Universal.MaxZoom = GenerateFor(shared.Speaker, "CameraMaxZoomDistance")
        Universal.MinZoom = GenerateFor(shared.Speaker, "CameraMinZoomDistance")

        return Universal
    end
} :: {[number]: () -> (...any)} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        4,
        {
            "MFeee~ New"
        },
        {
            {
                3,
                1,
                {
                    "Places"
                },
                {
                    {
                        32,
                        1,
                        {
                            "Utils"
                        },
                        {
                            {
                                33,
                                1,
                                {
                                    "The Foundation"
                                },
                                {
                                    {
                                        36,
                                        1,
                                        {
                                            "Lobby"
                                        },
                                        {
                                            {
                                                37,
                                                2,
                                                {
                                                    "AntiCheatBypass"
                                                }
                                            }
                                        }
                                    },
                                    {
                                        34,
                                        1,
                                        {
                                            "Game"
                                        },
                                        {
                                            {
                                                35,
                                                2,
                                                {
                                                    "Exploits"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        4,
                        1,
                        {
                            "Loader"
                        },
                        {
                            {
                                5,
                                1,
                                {
                                    "The Foundation"
                                },
                                {
                                    {
                                        7,
                                        2,
                                        {
                                            "Lobby"
                                        }
                                    },
                                    {
                                        6,
                                        2,
                                        {
                                            "Game"
                                        }
                                    }
                                }
                            },
                            {
                                8,
                                2,
                                {
                                    "Universal"
                                }
                            }
                        }
                    },
                    {
                        9,
                        1,
                        {
                            "Tabs"
                        },
                        {
                            {
                                10,
                                1,
                                {
                                    "The Foundation"
                                },
                                {
                                    {
                                        11,
                                        1,
                                        {
                                            "Game"
                                        },
                                        {
                                            {
                                                14,
                                                2,
                                                {
                                                    "3.Visual"
                                                }
                                            },
                                            {
                                                16,
                                                2,
                                                {
                                                    "5.Exploits"
                                                }
                                            },
                                            {
                                                17,
                                                2,
                                                {
                                                    "6.Trolls"
                                                }
                                            },
                                            {
                                                12,
                                                2,
                                                {
                                                    "1.Main"
                                                }
                                            },
                                            {
                                                13,
                                                2,
                                                {
                                                    "2.Player"
                                                }
                                            },
                                            {
                                                15,
                                                2,
                                                {
                                                    "4.ESP"
                                                }
                                            }
                                        }
                                    },
                                    {
                                        18,
                                        1,
                                        {
                                            "Lobby"
                                        },
                                        {
                                            {
                                                22,
                                                2,
                                                {
                                                    "4.ESP"
                                                }
                                            },
                                            {
                                                21,
                                                2,
                                                {
                                                    "3.Visual"
                                                }
                                            },
                                            {
                                                20,
                                                2,
                                                {
                                                    "2.Player"
                                                }
                                            },
                                            {
                                                19,
                                                2,
                                                {
                                                    "1.Main"
                                                }
                                            },
                                            {
                                                24,
                                                2,
                                                {
                                                    "6.Trolls"
                                                }
                                            },
                                            {
                                                23,
                                                2,
                                                {
                                                    "5.Exploits"
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                25,
                                1,
                                {
                                    "Universal"
                                },
                                {
                                    {
                                        27,
                                        2,
                                        {
                                            "2.Player"
                                        }
                                    },
                                    {
                                        26,
                                        2,
                                        {
                                            "1.Main"
                                        }
                                    },
                                    {
                                        28,
                                        2,
                                        {
                                            "3.Visual"
                                        }
                                    },
                                    {
                                        30,
                                        2,
                                        {
                                            "5.Exploits"
                                        }
                                    },
                                    {
                                        29,
                                        2,
                                        {
                                            "4.ESP"
                                        }
                                    },
                                    {
                                        31,
                                        2,
                                        {
                                            "6.Trolls"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            },
            {
                39,
                1,
                {
                    "Utils"
                },
                {
                    {
                        43,
                        2,
                        {
                            "Entities"
                        }
                    },
                    {
                        40,
                        2,
                        {
                            "ArtEmoji"
                        }
                    },
                    {
                        58,
                        2,
                        {
                            "MSESP"
                        }
                    },
                    {
                        44,
                        2,
                        {
                            "ExecutorSupport"
                        }
                    },
                    {
                        42,
                        2,
                        {
                            "EasingLibrary"
                        }
                    },
                    {
                        57,
                        2,
                        {
                            "LiteralBlank"
                        }
                    },
                    {
                        46,
                        1,
                        {
                            "Gui"
                        },
                        {
                            {
                                52,
                                1,
                                {
                                    "Obsidian"
                                },
                                {
                                    {
                                        54,
                                        2,
                                        {
                                            "SaveManager"
                                        }
                                    },
                                    {
                                        55,
                                        2,
                                        {
                                            "ThemeManager"
                                        }
                                    },
                                    {
                                        53,
                                        2,
                                        {
                                            "Library"
                                        }
                                    }
                                }
                            },
                            {
                                56,
                                2,
                                {
                                    "UIManager"
                                }
                            },
                            {
                                47,
                                1,
                                {
                                    "Linoria"
                                },
                                {
                                    {
                                        48,
                                        2,
                                        {
                                            "Library"
                                        }
                                    },
                                    {
                                        50,
                                        2,
                                        {
                                            "ThemeManager"
                                        }
                                    },
                                    {
                                        49,
                                        2,
                                        {
                                            "SaveManager"
                                        }
                                    }
                                }
                            },
                            {
                                51,
                                2,
                                {
                                    "Lucide"
                                }
                            }
                        }
                    },
                    {
                        41,
                        2,
                        {
                            "Connect"
                        }
                    },
                    {
                        61,
                        1,
                        {
                            "Universal"
                        },
                        {
                            {
                                65,
                                2,
                                {
                                    "MISC"
                                }
                            },
                            {
                                62,
                                2,
                                {
                                    "Aimbot"
                                }
                            },
                            {
                                63,
                                2,
                                {
                                    "ControlModule"
                                }
                            },
                            {
                                68,
                                2,
                                {
                                    "Visual"
                                }
                            },
                            {
                                67,
                                2,
                                {
                                    "Prompt"
                                }
                            },
                            {
                                66,
                                2,
                                {
                                    "Player"
                                }
                            },
                            {
                                64,
                                2,
                                {
                                    "FreeCamera"
                                }
                            }
                        }
                    },
                    {
                        60,
                        2,
                        {
                            "Services"
                        }
                    },
                    {
                        59,
                        2,
                        {
                            "Prediction"
                        }
                    },
                    {
                        45,
                        2,
                        {
                            "FileHelper"
                        }
                    }
                }
            },
            {
                38,
                2,
                {
                    "Translations"
                }
            },
            {
                2,
                2,
                {
                    "Mappings"
                }
            }
        }
    }
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "MFeee~ New"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring
    = string, task, setmetatable, error, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring

if not require then require = function(...) return nil end;end

local shared: {[any]: any} = shared

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- Will be used later for getting flattened globals
local ImportGlobals: (number) -> (table, table, Function)

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {} :: any

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
        return
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
        return
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        return InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local function OnError()
        local Title = "Error Loading!"
        local Text  = "Would you like to unload?"

        local Bindable = Instance.new("BindableFunction")
        function Bindable.OnInvoke(Choice)
            if Choice ~= "Yes" then return end

            pcall(pcall, SharedEnvironment.Unload)

            getgenv().MFeeeLoaded  = false
            getgenv().MFeeeLoading = false
        end

        print(`[{EnvName}] {Title} {Text}`)

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = Title,
            Text     = Text,
            Button1  = "Yes",
            Button2  = "No",
            Duration = (1 / 0),
            Callback = Bindable
        })
    end

    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(err)
        err = tostring(err)
        local VirtualFullName = scriptRef:GetFullName()

        -- Create a new error stack and process each line
        local newStack = {}
        for line in string_gmatch(err, "[^\n]+") do
            -- Look for error info lines with line numbers
            local filePath, lineNum, message = string_match(line, "^([^:]+):(%d+): (.+)$")

            if filePath and lineNum and message then
                -- Replace file path with virtual file path
                table_insert(newStack, VirtualFullName .. ":" .. lineNum .. ": " .. message)
            else
                -- Not a regular error line, keep as is
                table_insert(newStack, line)
            end
        end

        -- Join the processed error stack
        return table.concat(newStack, "\n")
    end

    -- Modify xpcall usage
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = xpcall(Closure, function(msg)
            return FormatError(debug.traceback(msg, 2))
        end, shared, ImportGlobals(scriptRef))

        if not RunSuccess then
            Defer(OnError)
            error(ErrorMessage, 0) -- Use level 0 to directly throw the fully formatted error
        end
        return
    else
        -- Module script logic
        local PCallReturn
        local RunSuccess, ErrorMessage = xpcall(function()
            PCallReturn = {Closure(shared, ImportGlobals(scriptRef))}
        end, function(msg)
            return FormatError(debug.traceback(msg, 2))
        end)

        if not RunSuccess then
            Defer(OnError)
            error(ErrorMessage, 0)
        end

        if ScriptClassName == "ModuleScript" then
            StoredModuleValues[scriptRef] = PCallReturn
        end

        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {xpcall(f, function(msg)
            return debug.traceback(msg, 2)
        end, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    local Global_wax = {
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = SharedEnvironment,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    }

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    if PathMatch == ".." then
                        CurrentRefPointer = CurrentRefPointer.Parent
                        if not CurrentRefPointer then
                            error("Virtual script path \"" .. module .. "\" not found - attempt to go above root", 2)
                        end
                    else
                        local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                        if not ResultRef then
                            local CurrentRefParent = CurrentRefPointer.Parent
                            if CurrentRefParent then
                                ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                            end
                        end

                        if ResultRef then
                            CurrentRefPointer = ResultRef
                        elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                            error("Virtual script path \"" .. module .. "\" not found", 2)
                        end
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end
