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
[+] Build   | 1

[~] This script was bundled by Wax, and is NOT intended to be modified directly.
[~] View the source code in the 'Src' folder at https://github.com/MaiFengYXD/MFeee-New.
[~] Join my Discord channel: https://discord.gg/YBQUd8X8PK.

--]]

local shared = shared :: {[any]: any}

-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local __waximport

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()
local wax, _, require = __waximport(1)

return (function()

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

if getgenv().MFeeeLoaded  then Notify("Loading Stopped!", "Error: Already loaded.");return end
if getgenv().MFeeeLoading then Notify("Loading Stopped!", "Error: Loading.")       ;return end

getgenv().MFeeeLoading = true
getgenv().MFeeeLoaded  = false

task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
    "rbxassetid://103134660123798",
    "rbxassetid://77335290652571",
    "rbxassetid://4590662766",
    "rbxassetid://4590657391"
})

if not game:IsLoaded() then game.Loaded:Wait() end

--// Start to Load //
wax.shared.TempStorage = {}

task.spawn(pcall, function()
    wax.shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

shared.Camera = shared.Workspace.CurrentCamera

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

shared.Connect     = require("Utils/Connect")
shared.ToClipboard = type(shared.ToClipboard) == "function" and shared.ToClipboard or function(...) end

wax.shared.AllowedLanguages = {
    ["am"] = "አማርኛ",
    ["ar"] = "العربية",
    ["az"] = "Azərbaycan dili",
    ["de"] = "Deutsch",
    ["en"] = "English",
    ["es"] = "Español",
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

wax.shared.Translations  = require("Translations")
wax.shared.EasingLibrary = require("Utils/EasingLibrary")
wax.shared.NpcHandler    = require("Utils/Universal/NPCHandler")

shared.Connect:GiveSignal("CameraChangedSignal" , shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera  = shared.Workspace.CurrentCamera
end))

shared.Connect:GiveSignal("SpeakerChangedSignal", shared.Players  :GetPropertyChangedSignal("LocalPlayer"  ):Connect(function()
    shared.Speaker = shared.Players  .LocalPlayer
end))

--// Loader //
wax.shared.ScriptVersion = "Build 1"

wax.shared.Icons     = require("Utils/Gui/Lucide")
wax.shared.UiManager = require("Utils/Gui/UIManager")
wax.shared.Window    = wax.shared.UiManager:CreateWindow()

require(`Places/Loader/{wax.shared.ScriptFolder}`)

getgenv().MFeeeLoaded  = true
getgenv().MFeeeLoading = false

task.spawn(pcall, function()
    local Version   = game:HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/.version")
    assert(Version ~= wax.shared.ScriptVersion)

    wax.shared.UiManager:Notify({
        Title       = wax.shared.Translations:GetTranslation("Version Mismatch"),
        Description = wax.shared.Translations:GetTranslation("The script version is outdated, please update it!"),
    })
end)

end)() end,
    function()
local _, _, _ = __waximport(2)

return (function()

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

end)() end,
    [6] = function()
local _, _, _ = __waximport(6)

return (function()


end)() end,
    [7] = function()
local _, _, _ = __waximport(7)

return (function()


end)() end,
    [8] = function()
local _, _, _ = __waximport(8)

return (function()


end)() end,
    [12] = function()
local _, _, _ = __waximport(12)

return (function()


end)() end,
    [13] = function()
local _, _, _ = __waximport(13)

return (function()


end)() end,
    [14] = function()
local _, _, _ = __waximport(14)

return (function()


end)() end,
    [15] = function()
local _, _, _ = __waximport(15)

return (function()


end)() end,
    [16] = function()
local _, _, _ = __waximport(16)

return (function()


end)() end,
    [17] = function()
local _, _, _ = __waximport(17)

return (function()


end)() end,
    [19] = function()
local _, _, _ = __waximport(19)

return (function()


end)() end,
    [20] = function()
local _, _, _ = __waximport(20)

return (function()


end)() end,
    [21] = function()
local _, _, _ = __waximport(21)

return (function()


end)() end,
    [22] = function()
local _, _, _ = __waximport(22)

return (function()


end)() end,
    [23] = function()
local _, _, _ = __waximport(23)

return (function()


end)() end,
    [24] = function()
local _, _, _ = __waximport(24)

return (function()


end)() end,
    [26] = function()
local _, _, _ = __waximport(26)

return (function()


end)() end,
    [27] = function()
local _, _, _ = __waximport(27)

return (function()


end)() end,
    [28] = function()
local _, _, _ = __waximport(28)

return (function()


end)() end,
    [29] = function()
local _, _, _ = __waximport(29)

return (function()


end)() end,
    [30] = function()
local _, _, _ = __waximport(30)

return (function()


end)() end,
    [31] = function()
local _, _, _ = __waximport(31)

return (function()


end)() end,
    [35] = function()
local _, _, _ = __waximport(35)

return (function()

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
end)() end,
    [37] = function()
local _, _, _ = __waximport(37)

return (function()


end)() end,
    [38] = function()
local wax, _, _ = __waximport(38)

return (function()

local Translations = {}

local Language = wax.shared.Language

if Language ~= "en" then
    local task_wait
        = task.wait

    local Success, Result
    local Elasped = 0

    local Thread = coroutine.create(function()
        Success, Result = pcall(function()
            local UrlContent = game:HttpGet(`https://raw.githubusercontent.com/MaiFengYXD/Translations/refs/heads/main/Translations/{Language}.json`)
            assert(UrlContent:find("{"), "Translations raw page error or HttpGet problem, please report it!")

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

function Translations:GetTranslation(Key: string): string
    return self[Language] and self[Language][Key] or Key
end

function Translations:FromTranslation(Value: string): string?
    return self.Reverse[Value]
end

return Translations

end)() end,
    [40] = function()
local wax, _, _ = __waximport(40)

return (function()

local Random = Random.new()

print(({
--// https://patorjk.com/software/taag
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
})[Random:NextInteger(1, 18)])

--// Festivals and Emojis //
local Year = tonumber(os.date("%Y"))
local Easter, Mother, Father

local function Calculate(First: number, Second: number, Month: number)
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
    Mother = Calculate(8, 14, 5)
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
}

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

return EmojiList[os.date("%m %d")]

end)() end,
    [41] = function()
local _, _, _ = __waximport(41)

return (function()

local table_clear
    = table.clear

local ConnectionManager = {}

local Connections       = {}
local RenderConnections = {}
local ActionConnections = {}

type Priority = {Value: number} | number

function ConnectionManager:GiveSignal(
    Index: string?,
    Signal: RBXScriptSignal | RBXScriptConnection
): RBXScriptConnection
    Connections[Index] = Connections[Index] and Connections[Index]:Disconnect() or Signal
    return Connections[Index]
end

function ConnectionManager:BindRenderStep(
    Index:     string?,
    Priority:  Priority,
    Function: (number) -> nil
): RBXScriptConnection
    if type(Priority) ~= "number" then Priority = Priority.Value;end

    shared.RunService:UnbindFromRenderStep(Index)
    shared.RunService:BindToRenderStep(Index, Priority, Function)

    RenderConnections[Index] = Function
    return RenderConnections[Index]
end

function ConnectionManager:BindAction(
    Index:     string?,
    Function: (any) -> nil,
    TouchIcon: boolean?,
    Priority:  Priority,
    ...:       EnumItem
): RBXScriptConnection
    local Enums = {...}
    local IsNormal = false

    if not Priority then IsNormal = true
    elseif type(Priority) ~= "number" then Priority = Priority.Value end

    shared.ContextActionService:UnbindAction(Index)

    if IsNormal then
        shared.ContextActionService:BindAction(Index, Function, TouchIcon, unpack(Enums))
    else
        shared.ContextActionService:BindActionAtPriority(Index, Function, TouchIcon, Priority, unpack(Enums))
    end

    ActionConnections[Index] = Function
    return table_clear(Enums) or ActionConnections[Index]
end

function ConnectionManager:DisconnectSignal(Index: string?)
    Connections[Index] = Connections[Index] and Connections[Index]:Disconnect()
end

function ConnectionManager:UnbindRenderStep(Index: string?)
    RenderConnections[Index] = shared.RunService:UnbindFromRenderStep(Index)
end

function ConnectionManager:UnbindAction(Index: string?)
    ActionConnections[Index] = shared.ContextActionService:UnbindAction(Index)
end

return ConnectionManager

end)() end,
    [42] = function()
local _, _, _ = __waximport(42)

return (function()

local TweenInfo_new, table_clear, type
    = TweenInfo.new, table.clear, type

local        TweenService
    = shared.TweenService

local              Create
    = TweenService.Create

local Play, Cancel;do
    local Tween = Instance.new("Tween")

    Play   = Tween.Play
    Cancel = Tween.Cancel

    Tween:Destroy()
end

local EasingLibrary = {
    RunningTween = {},

    EasingModes = {
        --// Polynomial
        ["Linear"   ] = Enum.EasingStyle.Linear,
        ["Quadratic"] = Enum.EasingStyle.Quad,
        ["Cubic"    ] = Enum.EasingStyle.Cubic,
        ["Quartic"  ] = Enum.EasingStyle.Quart,
        ["Quintic"  ] = Enum.EasingStyle.Quint,

        --// Trigonometric
        ["Circular"] = Enum.EasingStyle.Circular,
        ["Sine"    ] = Enum.EasingStyle.Sine,

        --// Exponential
        ["Exponential"] = Enum.EasingStyle.Exponential,

        --// Special
        ["Back"   ] = Enum.EasingStyle.Back,
        ["Elastic"] = Enum.EasingStyle.Elastic,
        ["Bounce" ] = Enum.EasingStyle.Bounce
    },

    EasingDirections = {
        ["In"   ] = Enum.EasingDirection.In,
        ["Out"  ] = Enum.EasingDirection.Out,
        ["InOut"] = Enum.EasingDirection.InOut
    },

    EasingMode      = "Quartic" :: "None" | string?,
    EasingDirection = "Out",
    EasingDuration  = 1,
}

type StoredTween = {
    Tween:       Tween | TweenBase,
    OnCompleted: RBXScriptConnection
}

function EasingLibrary:CancelTween(Index: string)
    if not self.RunningTween[Index] then return end
    Cancel(self.RunningTween[Index].Tween) --/ OnCompleted will automatically clean the RunningTween
end

function EasingLibrary:PlayTween(Tween: Tween | TweenBase, Index: string): StoredTween
    self.RunningTween[Index] = self:CancelTween(Index) or {
        Tween = Tween,

        OnCompleted = Tween.Completed:Once(function()
            self.RunningTween[Index] = table_clear(self.RunningTween[Index])
        end)
    } :: StoredTween

    Play(Tween)

    return self.RunningTween[Index]
end

function EasingLibrary:Ease(
    Target:    Instance,
    Property:  string | {[number]: string},
    EndValue:  any,
    Index:     string,
    Duration:  number?,
    Mode:      string?,
    Direction: string?
): StoredTween?
    if self.EasingMode == "None" then
        Target[Property] = EndValue
        return
    end

    local TweenInfo = TweenInfo_new(
        Duration  or self.EasingDuration or 1,
        Mode      or self.EasingModes[self.EasingMode] or Enum.EasingStyle.Quart,
        Direction or self.EasingDirections[self.EasingDirection] or Enum.EasingDirection.Out
    )
    local Goal = if type(Property) == "table" then Property else {[Property] = EndValue}

    return self:PlayTween(Create(TweenService, Target, TweenInfo, Goal), Index)
end

return EasingLibrary

end)() end,
    [43] = function()
local _, _, require = __waximport(43)

return (function()

local assert:<T>(T, string?) -> T
    = assert

local task_wait, string_find, Instance_new, table_find, pcall, print
    = task.wait, string.find, Instance.new, table.find, pcall, print

local      IsA
    = game.IsA

--// Prepare Environment //
local ExecutorSupport = {}
local Fixable         = {
    "fireproximityprompt",
    "firetouchinterest",
    "randomstring"
}

local function Test(Name: string, Function: (...any) -> (...any))
    local CanBeFixed = table_find(Fixable, Name)

    local Support, Message = pcall(Function)
    ExecutorSupport[Name]  = if CanBeFixed then true else Support

    if string_find(Message, "attempt to call a nil value") then
        Message = `{Name} doesn't exist`
    end

    if not Support and CanBeFixed then
        Message ..= ", but it can be fixed"
    end

    print(Support and `✅ [{Name}]` or `{CanBeFixed and "⚠️" or "❌"} [{Name}] {Message}`)
end

--// File System //

--// Folders
local function FolderTest(Assert: string?)
    makefolder("MFeee-New.test")
    assert(isfolder("MFeee-New.test"), Assert or "Failed to create a folder")
end

Test("makefolder", FolderTest)

Test("isfolder", function()
    FolderTest("Failed to check if folder exists")
end)

Test("delfolder", function()
    FolderTest()
    delfolder ("MFeee-New.test")
    assert(isfolder("MFeee-New.test") == false, "Failed to delete a folder")
end)

--// Files
local function FileTest(Assert: string?)
    makefolder("MFeee-New.test")
    writefile ("MFeee-New.test/Hello.txt", "Hello, World!")
    assert(isfile("MFeee-New.test/Hello.txt"), Assert or "Failed to create a file")
end

Test("writefile", FileTest)

Test("isfile", function()
    FileTest("Failed to check if file exists")
end)

Test("readfile", function()
    FileTest()
    assert(readfile("MFeee-New.test/Hello.txt") == "Hello, World!", "Failed to read a file")
end)

Test("appendfile", function()
    FileTest()
    appendfile("MFeee-New.test/Hello.txt", "\nHello, World!")
    assert(readfile("MFeee-New.test/Hello.txt") == "Hello, World!\nHello, World!", "Failed to append to a file")
end)

Test("delfile", function()
    FileTest()
    delfile("MFeee-New.test/Hello.txt")
    assert(isfile("MFeee-New.test/Hello.txt") == false, "Failed to delete a file")
end)

--// Metatables and Hooks //
Test("hookmetamethod", function()
    local Object = setmetatable({}, {
        __index  = function()
            return "Hello,"
        end
    })

    local Reference = hookmetamethod(Object, "__index", function()
        return " World!"
    end)

    assert(Object.Hi   == " World!"  , "Failed to hook metamethod")
    assert(Reference() == "Hello,"   , "Failed to get old metamethod reference")
    assert(Object.Hi   ~= Reference(), "hooked metamethod should not be equal to the original")

    hookmetamethod(Object, "__index", Reference)
    assert(Object.Hi == "Hello,", "Failed to restore the original metamethod")
end)

Test("getnamecallmethod", function()
    assert(pcall(function() game:Hi() end) or getnamecallmethod() == "Hi", "Failed to get a namecall method")
end)

Test("hookfunction", function()
    local function Original()
        return "Hello,"
    end

    local Reference = hookfunction(Original, function()
        return " World!"
    end)

    assert(Original()  == " World!", "Failed to hook function")
    assert(Reference() == "Hello," , "Failed to get old function reference")
    assert(Original    ~= Reference, "hooked function should not be equal to the original")

    hookfunction(Original, Reference)
    assert(Original() == "Hello,", "Failed to restore the original function") 
end)

Test("getcallingscript", function()
    assert(getcallingscript() == nil, "Calling script test should return nil cause this script isn't a instance")
end)

Test("checkcaller", function()
    assert(checkcaller() == true, "Check caller test should return true cause we are in the main thread")
end)

--// Instances //
Test("fireproximityprompt", function()
    assert(type(fireproximityprompt) == "function", "attempt to call a nil value")
    local Prompt = Instance_new("ProximityPrompt")

    Prompt.Triggered:Once(function()
        Prompt = Prompt:Destroy()
    end)

    assert(pcall(fireproximityprompt, Prompt) and task_wait(0.1) and Prompt == nil, "Failed to fire a ProximityPrompt")
end)

Test("firetouchinterest", function()
    shared.FireTouch = firetouchinterest or firetouchtransmitter
    assert(type(shared.FireTouch) == "function", "attempt to call a nil value")

    local Part1 = Instance_new("Part")
    local Part2 = Instance_new("Part")

    Part2.Touched:Once(function()
        Part1 = Part1:Destroy()
        Part2 = Part2:Destroy()
    end)

    assert(pcall(shared.FireTouch, Part1, Part2, 0) and task_wait(0.1) and not (Part1 and Part2), "Failed to fire the 'TouchInterest'")
end)

Test("getconnections", function()
    shared.GetConnections = getconnections or get_signal_cons
    assert(type(shared.GetConnections) == "function", "attempt to call a nil value")

    local Types = {
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

    local Signal = Instance_new("BindableEvent")
    Signal.Event:Once(function() end)

    local Connection = shared.GetConnections(Signal.Event)[1]
    for Key, Type in Types do
        assert(Connection[Key] ~= nil, `Did not return a table with a '{Key}' field`)
        assert(type(Connection[Key]) == Type, `'{Key}' field is not a {Type}`)
    end
end)

Test("require", function()
    local require: (Instance) -> any
        = getgenv().require

    assert(type(require) == "function", "attempt to call a nil value")

    local ModuleScript

    for _, Object in game:GetDescendants() do
        --// I did this because it was really quick on test
        if not IsA(Object, "ModuleScript") then continue end
        if require(Object) == nil then continue end

        ModuleScript = Object
        break
    end

    assert(ModuleScript, "Failed to find a ModuleScript")
end)

Test("gethui", function()
    assert(IsA(gethui(), "CoreGui"), "Failed to get CoreGui")
end)

Test("protectgui", function()
    shared.ProtectGui = protectgui or syn and syn.protect_gui
    assert(type(shared.ProtectGui) == "function", "attempt to call a nil value")

    local Gui = Instance_new("ScreenGui")
    shared.ProtectGui(Gui)

    Gui.Parent = shared.Workspace
    for _, Object in shared.Workspace:GetChildren() do
        assert(Object == Gui, "Failed to protect GUI")
    end

    Gui:Destroy()
end)

--// Miscellaneous //
Test("queue_on_teleport", function()
    shared.QueueTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport
    assert(type(shared.QueueTeleport) == "function", "Seems like queue_on_teleport doesn't exist")
end)

Test("toclipboard", function()
    shared.ToClipboard = (
        toclipboard or setclipboard or write_clipboard or setrbxclipboard or
        syn and syn.write_clipboard or Clipboard and Clipboard.set
    )
    assert(type(shared.ToClipboard) == "function", "Seems like toclipboard doesn't exist")
end)

Test("Drawing", function()
    local Draw = Drawing.new("Circle")
    Draw.Visible = false

    assert(pcall(Draw.Remove, Draw), "Drawing API is incomplete")
end)

Test("randomstring", function()
    local String = randomstring(99)
    assert(type(String) == "string" and #String == 99, "Failed to generate a random string")
end)

--// Fixes //
local Global = getgenv()

if not ExecutorSupport.fireproximityprompt then
    local Inf = (1 / 0)

    function Global.fireproximityprompt(Prompt: ProximityPrompt, Distance: number | nil)
        local PreDuration = Prompt.HoldDuration
        local PreDistance = Prompt.MaxActivationDistance
        local PreNoclip   = Prompt.RequiresLineOfSight

        Prompt.HoldDuration = 0
        Prompt.MaxActivationDistance = Distance or Inf
        Prompt.RequiresLineOfSight   = false

        Prompt.Triggered:Once(function()
            Prompt:InputHoldEnd()

            Prompt.HoldDuration          = PreDuration
            Prompt.MaxActivationDistance = PreDistance
            Prompt.RequiresLineOfSight   = PreNoclip
        end)

        Prompt:InputHoldBegin()
    end
end

if not ExecutorSupport.firetouchinterest then
    local PreTouch1 = {}
    local PreTouch2 = {}

    local PreCollided1 = {}
    local PreCollided2 = {}

    local PreTransparency1 = {}
    local PreTransparency2 = {}

    local PrePositions = {}

    local function Touch1(Part1: BasePart, Part2: BasePart)
        PreTouch1[Part1] = Part1.CanTouch
        PreTouch2[Part2] = Part2.CanTouch

        PreCollided1[Part1] = Part1.CanCollide
        PreCollided2[Part2] = Part2.CanCollide

        PreTransparency1[Part1] = Part1.Transparency
        PreTransparency2[Part2] = Part2.Transparency

        PrePositions[Part2] = Part2.Position

        Part1.CanTouch = true
        Part2.CanTouch = true

        Part1.CanCollide = false
        Part2.CanCollide = false

        Part1.Transparency = 1
        Part2.Transparency = 1

        Part2.Position = Part1.Position
    end

    local function Touch0(Part1: BasePart, Part2: BasePart)
        Part2.Touched:Once(function()
            Part1.CanTouch = PreTouch1[Part1]
            Part2.CanTouch = PreTouch2[Part2]

            Part1.CanCollide = PreCollided1[Part1]
            Part2.CanCollide = PreCollided2[Part2]

            Part1.Transparency = PreTransparency1[Part1]
            Part2.Transparency = PreTransparency2[Part2]

            Part2.Position = PrePositions[Part2]

            PreTouch1[Part1] = nil
            PreTouch2[Part2] = nil

            PreCollided1[Part1] = nil
            PreCollided2[Part2] = nil

            PreTransparency1[Part1] = nil
            PreTransparency2[Part2] = nil

            PrePositions[Part2] = nil
        end)

        Touch1(Part1, Part2)
    end

    function Global.firetouchinterest(Part1: BasePart, Part2: BasePart, Touching: number)
        if     Touching == 1 then
            Touch1(Part1, Part2)
        elseif Touching == 0 then
            Touch0(Part1, Part2)
        end
    end

    shared.FireTouch = Global.firetouchinterest
end

if not ExecutorSupport.randomstring then
    local stringchar
        = string.char

    local Random      = Random.new()
    local NextInteger = Random.NextInteger

    function Global.randomstring(Length: number | nil): string
        local String = ""

        for _ = 1, Length or 16 do
            String ..= stringchar(NextInteger(Random, 33, 126))
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

--[[ CoreGui Detection Bypass:

```luau
while true do
    local CoreGui = game:GetService("CoreGui") --/ Get CoreGui strong reference
    local Dummy   = {} :: any

    local MetaTable = setmetatable({}, {
        --// Set as weak table so Lua garbage collection can collect it without any strong references
        __mode = "kv"
    })

    --// Add these two variables to the weak table as weak references in the weak table
    MetaTable[1] = CoreGui
    MetaTable[2] = Dummy

    --// Clean up the two strong references so Lua can collect CoreGui on the next garbage collection
    CoreGui = nil
    Dummy   = nil

    while MetaTable[2] do
        --// Waiting for Lua garbage collection
        task.wait()
    end

    if MetaTable[1] then
        --// CoreGui reference exists, and an object uses CoreGui (most likely an exploit)
        game:GetService("Players").LocalPlayer:Kick()
    end
end
```
Creator can use the above code to detect CoreGui exploits.

So let's use a hook to make GetService("CoreGui") and game.CoreGui return nil or error every time.

--]]

type Object = Instance | DataModel

if ExecutorSupport.gethui then
    --// gethui can bypass this detection
    shared.CoreGui = gethui()
elseif ExecutorSupport.checkcaller then
    local game, checkcaller, error
        = game, checkcaller, error

    local OldIndex, OldNameCall, OldFunction

    local ErrorMessage = "The current thread cannot access 'CoreGui' (lacking capability Plugin)"

    if ExecutorSupport.hookmetamethod then
        OldIndex = hookmetamethod(game, "__index", function(self: Object, Key: string): (...any)
            if self == game and Key == "CoreGui" and not checkcaller() then
                return error(ErrorMessage, 2)
            end

            return OldIndex(self, Key)
        end)

        if ExecutorSupport.getnamecallmethod then
            local getnamecallmethod
                = getnamecallmethod

            OldNameCall = hookmetamethod(game, "__namecall", function(self: Object, ...: any): (...any)
                if self == game and getnamecallmethod() == "GetService" and ... == "CoreGui" and not checkcaller() then
                    return if pcall(OldNameCall, self, ...) then nil else error(ErrorMessage, 2)
                end

                return OldNameCall(self, ...)
            end)
        end
    end

    if ExecutorSupport.hookfunction then
        OldFunction = hookfunction(game.GetService, function(self: Object, ServiceName: string): (...any)
            if not checkcaller() and ServiceName == "CoreGui" then
                return if pcall(OldFunction, self, ServiceName) then nil else error(ErrorMessage, 2)
            end

            return OldFunction(self, ServiceName)
        end)
    end

    require("Services"):GetServices({"CoreGui"})
end

--// Summary //
local FileSystem = {
    "makefolder",
    "isfolder",
    "delfolder",
    "writefile",
    "isfile",
    "readfile",
    "appendfile",
    "delfile"
}

local FileSystemSupport = 0

for _, Function in FileSystem do
    FileSystemSupport += ExecutorSupport[Function] and 1 or 0
end

ExecutorSupport.SupportFileSystem = FileSystemSupport == #FileSystem

return ExecutorSupport

end)() end,
    [44] = function()
local wax, _, _ = __waximport(44)

return (function()

local string_find, string_match, string_sub
    = string.find, string.match, string.sub

local makefolder, writefile, isfile, readfile
    = makefolder, writefile, isfile, readfile

local FileHelper = {}

function FileHelper:CheckAPI()
    return not wax.shared.ExecutorSupport.SupportFileSystem
end

function FileHelper:CreateParentFolder(FilePath: string): string?
    if self:CheckAPI() then return nil end

    local Slash      = string_find(FilePath, "[^/]+$", 1, true)
    local FolderPath = if Slash then string_sub(FilePath, 1, Slash - 2) else FilePath

    makefolder(FolderPath)
    return FolderPath
end

function FileHelper:CreateFolder(Path: string): string?
    if self:CheckAPI() then return nil end

    makefolder(Path)
    return Path
end

function FileHelper:CheckFile(Path: string, Fallback: string, Targets: any): string
    if self:CheckAPI() then return Fallback end
    self:CreateParentFolder(Path)

    local function Return()
        writefile(Path, Fallback)
        return Fallback
    end

    if isfile(Path) then
        local Content    = readfile(Path)
        local TargetType = type(Targets)

        if TargetType == "table" then
            for _, Target in Targets do
                if Content ~= Target then return Return() end
            end
        elseif TargetType == "number" then
            if type(tonumber(Content)) ~= TargetType then return Return() end
        end

        return Content
    end

    return Return()
end

function FileHelper:WriteFile(Path: string, Content: string, DontOverwrite: boolean?): string?
    if self:CheckAPI() then return nil end
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

end)() end,
    [47] = function()
local wax, _, _ = __waximport(47)

return (function()

--// Source by mstudio45 //

local randomstring
    = randomstring;

local PreRender = shared.RunService.PreRender;
local LocalPlayer = shared.Speaker;
local Mouse = LocalPlayer:GetMouse();

local Translations = wax.shared.Translations;
local GetTranslation = Translations.GetTranslation

local DrawingLib = wax.shared.ExecutorSupport.Drawing and Drawing or { drawing_replaced = true };
local ProtectGui = wax.shared.ExecutorSupport.protectgui and shared.ProtectGui or function(Gui: GuiObject)
    Gui.Archivable = false;
end;
local GetHUI = wax.shared.ExecutorSupport.gethui and gethui or function()
    return shared.CoreGui;
end;

local IsBadDrawingLib = false;

local ScreenGui = Instance.new('ScreenGui');
pcall(ProtectGui, ScreenGui);

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.DisplayOrder = 1e7;
ScreenGui.ResetOnSpawn = false;

local Parented = pcall(function() ScreenGui.Parent = GetHUI(); end);
if not Parented then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end;

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
        end, warn);
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

    local NotifyOuter = Library:Create('Frame', {
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

    function Data:Resize()
        XSize, YSize = Library:GetTextBounds(NotifyLabel.Text, Library.Font, 14);
        YSize = YSize + 7
    
        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize * DPIScale + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);
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

    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize * DPIScale + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);

    task.spawn(function()
        if typeof(Data.Time) == "Instance" then
            Data.Time.Destroying:Wait();
        else
            task.wait(Data.Time or 5);
        end

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
        task.wait(0.4);
        NotifyOuter:Destroy();
    end);

    return Data
end;

function Library:SafeCallback(Func, ...)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local run = function(func, ...)
        local Success, Response = pcall(func, ...)
        if Success then
            return Response
        end
    
        local Traceback = debug.traceback():gsub("\n", " ")
        local _, i = Traceback:find(":%d+ ")
        Traceback = Traceback:sub(i + 1):gsub(" :", ":")
    
        task.defer(error, Response .. " - " .. Traceback)
        if Library.NotifyOnError then
            return Library:Notify(Response)
        end
        return
    end;

    task.spawn(run, Func, ...);
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

end)() end,
    [48] = function()
local _, _, _ = __waximport(48)

return (function()

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

end)() end,
    [49] = function()
local _, _, _ = __waximport(49)

return (function()

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

end)() end,
    [50] = function()
local _, _, _ = __waximport(50)

return (function()

--// Source by deividcomsono //

local Lucide = {}

local Icons = {{"a-arrow-down","a-arrow-up","a-large-small","accessibility","activity","air-vent","airplay","alarm-clock","alarm-clock-check","alarm-clock-minus","alarm-clock-off","alarm-clock-plus","alarm-smoke","album","align-center","align-center-horizontal","align-center-vertical","align-end-horizontal","align-end-vertical","align-horizontal-distribute-center","align-horizontal-distribute-end","align-horizontal-distribute-start","align-horizontal-justify-center","align-horizontal-justify-end","align-horizontal-justify-start","align-horizontal-space-around","align-horizontal-space-between","align-justify","align-left","align-right","align-start-horizontal","align-start-vertical","align-vertical-distribute-center","align-vertical-distribute-end","align-vertical-distribute-start","align-vertical-justify-center","align-vertical-justify-end","align-vertical-justify-start","align-vertical-space-around","align-vertical-space-between","ambulance","ampersand","ampersands","amphora","anchor","angry","annoyed","antenna","anvil","aperture","app-window","app-window-mac","apple","archive","archive-restore","archive-x","armchair","arrow-big-down","arrow-big-down-dash","arrow-big-left","arrow-big-left-dash","arrow-big-right","arrow-big-right-dash","arrow-big-up","arrow-big-up-dash","arrow-down","arrow-down-0-1","arrow-down-1-0","arrow-down-a-z","arrow-down-from-line","arrow-down-left","arrow-down-narrow-wide","arrow-down-right","arrow-down-to-dot","arrow-down-to-line","arrow-down-up","arrow-down-wide-narrow","arrow-down-z-a","arrow-left","arrow-left-from-line","arrow-left-right","arrow-left-to-line","arrow-right","arrow-right-from-line","arrow-right-left","arrow-right-to-line","arrow-up","arrow-up-0-1","arrow-up-1-0","arrow-up-a-z","arrow-up-down","arrow-up-from-dot","arrow-up-from-line","arrow-up-left","arrow-up-narrow-wide","arrow-up-right","arrow-up-to-line","arrow-up-wide-narrow","arrow-up-z-a","arrows-up-from-line","asterisk","at-sign","atom","audio-lines","audio-waveform","award","axe","axis-3d","baby","backpack","badge","badge-alert","badge-cent","badge-check","badge-dollar-sign","badge-euro","badge-help","badge-indian-rupee","badge-info","badge-japanese-yen","badge-minus","badge-percent","badge-plus","badge-pound-sterling","badge-russian-ruble","badge-swiss-franc","badge-x","baggage-claim","ban","banana","bandage","banknote","barcode","baseline","bath","battery","battery-charging","battery-full","battery-low","battery-medium","battery-warning","beaker","bean","bean-off","bed","bed-double","bed-single","beef","beer","beer-off","bell","bell-dot","bell-electric","bell-minus","bell-off","bell-plus","bell-ring","between-horizontal-end","between-horizontal-start","between-vertical-end","between-vertical-start","biceps-flexed","bike","binary","binoculars","biohazard","bird","bitcoin","blend","blinds","blocks","bluetooth","bluetooth-connected","bluetooth-off","bluetooth-searching","bold","bolt","bomb","bone","book","book-a","book-audio","book-check","book-copy","book-dashed","book-down","book-headphones","book-heart","book-image","book-key","book-lock","book-marked","book-minus","book-open","book-open-check","book-open-text","book-plus","book-text","book-type","book-up","book-up-2","book-user","book-x","bookmark","bookmark-check","bookmark-minus","bookmark-plus","bookmark-x","boom-box","bot","bot-message-square","bot-off","box","boxes","braces","brackets","brain","brain-circuit","brain-cog","brick-wall","briefcase","briefcase-business","briefcase-conveyor-belt","briefcase-medical","bring-to-front","brush","bug","bug-off","bug-play","building","building-2","bus","bus-front","cable","cable-car","cake","cake-slice","calculator","calendar","calendar-1","calendar-arrow-down","calendar-arrow-up","calendar-check","calendar-check-2","calendar-clock","calendar-cog","calendar-days","calendar-fold","calendar-heart","calendar-minus","calendar-minus-2","calendar-off","calendar-plus","calendar-plus-2","calendar-range","calendar-search","calendar-sync","calendar-x","calendar-x-2","camera","camera-off","candy","candy-cane","candy-off","cannabis","captions","captions-off","car","car-front","car-taxi-front","caravan","carrot","case-lower","case-sensitive","case-upper","cassette-tape","cast","castle","cat","cctv","chart-area","chart-bar","chart-bar-big","chart-bar-decreasing","chart-bar-increasing","chart-bar-stacked","chart-candlestick","chart-column","chart-column-big","chart-column-decreasing","chart-column-increasing","chart-column-stacked","chart-gantt","chart-line","chart-network","chart-no-axes-column","chart-no-axes-column-decreasing","chart-no-axes-column-increasing","chart-no-axes-combined","chart-no-axes-gantt","chart-pie","chart-scatter","chart-spline","check","check-check","chef-hat","cherry","chevron-down","chevron-first","chevron-last","chevron-left","chevron-right","chevron-up","chevrons-down","chevrons-down-up","chevrons-left","chevrons-left-right","chevrons-left-right-ellipsis","chevrons-right","chevrons-right-left","chevrons-up","chevrons-up-down","chrome","church","cigarette","cigarette-off","circle","circle-alert","circle-arrow-down","circle-arrow-left","circle-arrow-out-down-left","circle-arrow-out-down-right","circle-arrow-out-up-left","circle-arrow-out-up-right","circle-arrow-right","circle-arrow-up","circle-check","circle-check-big","circle-chevron-down","circle-chevron-left","circle-chevron-right","circle-chevron-up","circle-dashed","circle-divide","circle-dollar-sign","circle-dot","circle-dot-dashed","circle-ellipsis","circle-equal","circle-fading-arrow-up","circle-fading-plus","circle-gauge","circle-help","circle-minus","circle-off","circle-parking","circle-parking-off","circle-pause","circle-percent","circle-play","circle-plus","circle-power","circle-slash","circle-slash-2","circle-stop","circle-user","circle-user-round","circle-x","circuit-board","citrus","clapperboard","clipboard","clipboard-check","clipboard-copy","clipboard-list","clipboard-minus","clipboard-paste","clipboard-pen","clipboard-pen-line","clipboard-plus","clipboard-type","clipboard-x","clock","clock-1","clock-10","clock-11","clock-12","clock-2","clock-3","clock-4","clock-5","clock-6","clock-7","clock-8","clock-9","clock-alert","clock-arrow-down","clock-arrow-up","cloud","cloud-alert","cloud-cog","cloud-download","cloud-drizzle","cloud-fog","cloud-hail","cloud-lightning","cloud-moon","cloud-moon-rain","cloud-off","cloud-rain","cloud-rain-wind","cloud-snow","cloud-sun","cloud-sun-rain","cloud-upload","cloudy","clover","club","code","code-xml","codepen","codesandbox","coffee","cog","coins","columns-2","columns-3","columns-4","combine","command","compass","component","computer","concierge-bell","cone","construction","contact","contact-round","container","contrast","cookie","cooking-pot","copy","copy-check","copy-minus","copy-plus","copy-slash","copy-x","copyleft","copyright","corner-down-left","corner-down-right","corner-left-down","corner-left-up","corner-right-down","corner-right-up","corner-up-left","corner-up-right","cpu","creative-commons","credit-card","croissant","crop","cross","crosshair","crown","cuboid","cup-soda","currency","cylinder","dam","database","database-backup","database-zap","delete","dessert","diameter","diamond","diamond-minus","diamond-percent","diamond-plus","dice-1","dice-2","dice-3","dice-4","dice-5","dice-6","dices","diff","disc","disc-2","disc-3","disc-album","divide","dna","dna-off","dock","dog","dollar-sign","donut","door-closed","door-open","dot","download","drafting-compass","drama","dribbble","drill","droplet","droplet-off","droplets","drum","drumstick","dumbbell","ear","ear-off","earth","earth-lock","eclipse","egg","egg-fried","egg-off","ellipsis","ellipsis-vertical","equal","equal-approximately","equal-not","eraser","ethernet-port","euro","expand","external-link","eye","eye-closed","eye-off","facebook","factory","fan","fast-forward","feather","fence","ferris-wheel","figma","file","file-archive","file-audio","file-audio-2","file-axis-3d","file-badge","file-badge-2","file-box","file-chart-column","file-chart-column-increasing","file-chart-line","file-chart-pie","file-check","file-check-2","file-clock","file-code","file-code-2","file-cog","file-diff","file-digit","file-down","file-heart","file-image","file-input","file-json","file-json-2","file-key","file-key-2","file-lock","file-lock-2","file-minus","file-minus-2","file-music","file-output","file-pen","file-pen-line","file-plus","file-plus-2","file-question","file-scan","file-search","file-search-2","file-sliders","file-spreadsheet","file-stack","file-symlink","file-terminal","file-text","file-type","file-type-2","file-up","file-user","file-video","file-video-2","file-volume","file-volume-2","file-warning","file-x","file-x-2","files","film","filter","filter-x","fingerprint","fire-extinguisher","fish","fish-off","fish-symbol","flag","flag-off","flag-triangle-left","flag-triangle-right","flame","flame-kindling","flashlight","flashlight-off","flask-conical","flask-conical-off","flask-round","flip-horizontal","flip-horizontal-2","flip-vertical","flip-vertical-2","flower","flower-2","focus","fold-horizontal","fold-vertical","folder","folder-archive","folder-check","folder-clock","folder-closed","folder-code","folder-cog","folder-dot","folder-down","folder-git","folder-git-2","folder-heart","folder-input","folder-kanban","folder-key","folder-lock","folder-minus","folder-open","folder-open-dot","folder-output","folder-pen","folder-plus","folder-root","folder-search","folder-search-2","folder-symlink","folder-sync","folder-tree","folder-up","folder-x","folders","footprints","forklift","forward","frame","framer","frown","fuel","fullscreen","gallery-horizontal","gallery-horizontal-end","gallery-thumbnails","gallery-vertical","gallery-vertical-end","gamepad","gamepad-2","gauge","gavel","gem","ghost","gift","git-branch","git-branch-plus","git-commit-horizontal","git-commit-vertical","git-compare","git-compare-arrows","git-fork","git-graph","git-merge","git-pull-request","git-pull-request-arrow","git-pull-request-closed","git-pull-request-create","git-pull-request-create-arrow","git-pull-request-draft","github","gitlab","glass-water","glasses","globe","globe-lock","goal","grab","graduation-cap","grape","grid-2x2","grid-2x2-check","grid-2x2-plus","grid-2x2-x","grid-3x3","grip","grip-horizontal","grip-vertical","group","guitar","ham","hammer","hand","hand-coins","hand-heart","hand-helping","hand-metal","hand-platter","handshake","hard-drive","hard-drive-download","hard-drive-upload","hard-hat","hash","haze","hdmi-port","heading","heading-1","heading-2","heading-3","heading-4","heading-5","heading-6","headphone-off","headphones","headset","heart","heart-crack","heart-handshake","heart-off","heart-pulse","heater","hexagon","highlighter","history","hop","hop-off","hospital","hotel","hourglass","house","house-plug","house-plus","ice-cream-bowl","ice-cream-cone","id-card","image","image-down","image-minus","image-off","image-play","image-plus","image-up","image-upscale","images","import","inbox","indent-decrease","indent-increase","indian-rupee","infinity","info","inspection-panel","instagram","italic","iteration-ccw","iteration-cw","japanese-yen","joystick","kanban","key","key-round","key-square","keyboard","keyboard-music","keyboard-off","lamp","lamp-ceiling","lamp-desk","lamp-floor","lamp-wall-down","lamp-wall-up","land-plot","landmark","languages","laptop","laptop-minimal","laptop-minimal-check","lasso","lasso-select","laugh","layers","layers-2","layout-dashboard","layout-grid","layout-list","layout-panel-left","layout-panel-top","layout-template","leaf","leafy-green","lectern","letter-text","library","library-big","life-buoy","ligature","lightbulb","lightbulb-off","link","link-2","link-2-off","linkedin","list","list-check","list-checks","list-collapse","list-end","list-filter","list-filter-plus","list-minus","list-music","list-ordered","list-plus","list-restart","list-start","list-todo","list-tree","list-video","list-x","loader","loader-circle","loader-pinwheel","locate","locate-fixed","locate-off","lock","lock-keyhole","lock-keyhole-open","lock-open","log-in","log-out","logs","lollipop","luggage","magnet","mail","mail-check","mail-minus","mail-open","mail-plus","mail-question","mail-search","mail-warning","mail-x","mailbox","mails","map","map-pin","map-pin-check","map-pin-check-inside","map-pin-house","map-pin-minus","map-pin-minus-inside","map-pin-off","map-pin-plus","map-pin-plus-inside","map-pin-x","map-pin-x-inside","map-pinned","martini","maximize","maximize-2","medal","megaphone","megaphone-off","meh","memory-stick","menu","merge","message-circle","message-circle-code","message-circle-dashed","message-circle-heart","message-circle-more","message-circle-off","message-circle-plus","message-circle-question","message-circle-reply","message-circle-warning","message-circle-x","message-square","message-square-code","message-square-dashed","message-square-diff","message-square-dot","message-square-heart","message-square-lock","message-square-more","message-square-off","message-square-plus","message-square-quote","message-square-reply","message-square-share","message-square-text","message-square-warning","message-square-x","messages-square","mic","mic-off","mic-vocal","microchip","microscope","microwave","milestone","milk","milk-off","minimize","minimize-2","minus","monitor","monitor-check","monitor-cog","monitor-dot","monitor-down","monitor-off","monitor-pause","monitor-play","monitor-smartphone","monitor-speaker","monitor-stop","monitor-up","monitor-x","moon","moon-star","mountain","mountain-snow","mouse","mouse-off","mouse-pointer","mouse-pointer-2","mouse-pointer-ban","mouse-pointer-click","move","move-3d","move-diagonal","move-diagonal-2","move-down","move-down-left","move-down-right","move-horizontal","move-left","move-right","move-up","move-up-left","move-up-right","move-vertical","music","music-2","music-3","music-4","navigation","navigation-2","navigation-2-off","navigation-off","network","newspaper","nfc","notebook","notebook-pen","notebook-tabs","notebook-text","notepad-text","notepad-text-dashed","nut","nut-off","octagon","octagon-alert","octagon-minus","octagon-pause","octagon-x","omega","option","orbit","origami","package","package-2","package-check","package-minus","package-open","package-plus","package-search","package-x","paint-bucket","paint-roller","paintbrush","paintbrush-vertical","palette","panel-bottom","panel-bottom-close","panel-bottom-dashed","panel-bottom-open","panel-left","panel-left-close","panel-left-dashed","panel-left-open","panel-right","panel-right-close","panel-right-dashed","panel-right-open","panel-top","panel-top-close","panel-top-dashed","panel-top-open","panels-left-bottom","panels-right-bottom","panels-top-left","paperclip","parentheses","parking-meter","party-popper","pause","paw-print","pc-case","pen","pen-line","pen-off","pen-tool","pencil","pencil-line","pencil-off","pencil-ruler","pentagon","percent","person-standing","philippine-peso","phone","phone-call","phone-forwarded","phone-incoming","phone-missed","phone-off","phone-outgoing","pi","piano","pickaxe","picture-in-picture","picture-in-picture-2","piggy-bank","pilcrow","pilcrow-left","pilcrow-right","pill","pill-bottle","pin","pin-off","pipette","pizza","plane","plane-landing","plane-takeoff","play","plug","plug-2","plug-zap","plus","pocket","pocket-knife","podcast","pointer","pointer-off","popcorn","popsicle","pound-sterling","power","power-off","presentation","printer","printer-check","projector","proportions","puzzle","pyramid","qr-code","quote","rabbit","radar","radiation","radical","radio","radio-receiver","radio-tower","radius","rail-symbol","rainbow","rat","ratio","receipt","receipt-cent","receipt-euro","receipt-indian-rupee","receipt-japanese-yen","receipt-pound-sterling","receipt-russian-ruble","receipt-swiss-franc","receipt-text","rectangle-ellipsis","rectangle-horizontal","rectangle-vertical","recycle","redo","redo-2","redo-dot","refresh-ccw","refresh-ccw-dot","refresh-cw","refresh-cw-off","refrigerator","regex","remove-formatting","repeat","repeat-1","repeat-2","replace","replace-all","reply","reply-all","rewind","ribbon","rocket","rocking-chair","roller-coaster","rotate-3d","rotate-ccw","rotate-ccw-square","rotate-cw","rotate-cw-square","route","route-off","router","rows-2","rows-3","rows-4","rss","ruler","russian-ruble","sailboat","salad","sandwich","satellite","satellite-dish","save","save-all","save-off","scale","scale-3d","scaling","scan","scan-barcode","scan-eye","scan-face","scan-heart","scan-line","scan-qr-code","scan-search","scan-text","school","scissors","scissors-line-dashed","screen-share","screen-share-off","scroll","scroll-text","search","search-check","search-code","search-slash","search-x","section","send","send-horizontal","send-to-back","separator-horizontal","separator-vertical","server","server-cog","server-crash","server-off","settings","settings-2","shapes","share","share-2","sheet","shell","shield","shield-alert","shield-ban","shield-check","shield-ellipsis","shield-half","shield-minus","shield-off","shield-plus","shield-question","shield-x","ship","ship-wheel","shirt","shopping-bag","shopping-basket","shopping-cart","shovel","shower-head","shrink","shrub","shuffle","sigma","signal","signal-high","signal-low","signal-medium","signal-zero","signature","signpost","signpost-big","siren","skip-back","skip-forward","skull","slack","slash","slice","sliders-horizontal","sliders-vertical","smartphone","smartphone-charging","smartphone-nfc","smile","smile-plus","snail","snowflake","sofa","soup","space","spade","sparkle","sparkles","speaker","speech","spell-check","spell-check-2","spline","split","spray-can","sprout","square","square-activity","square-arrow-down","square-arrow-down-left","square-arrow-down-right","square-arrow-left","square-arrow-out-down-left","square-arrow-out-down-right","square-arrow-out-up-left","square-arrow-out-up-right","square-arrow-right","square-arrow-up","square-arrow-up-left","square-arrow-up-right","square-asterisk","square-bottom-dashed-scissors","square-chart-gantt","square-check","square-check-big","square-chevron-down","square-chevron-left","square-chevron-right","square-chevron-up","square-code","square-dashed","square-dashed-bottom","square-dashed-bottom-code","square-dashed-kanban","square-dashed-mouse-pointer","square-divide","square-dot","square-equal","square-function","square-kanban","square-library","square-m","square-menu","square-minus","square-mouse-pointer","square-parking","square-parking-off","square-pen","square-percent","square-pi","square-pilcrow","square-play","square-plus","square-power","square-radical","square-scissors","square-sigma","square-slash","square-split-horizontal","square-split-vertical","square-square","square-stack","square-terminal","square-user","square-user-round","square-x","squircle","squirrel","stamp","star","star-half","star-off","step-back","step-forward","stethoscope","sticker","sticky-note","store","stretch-horizontal","stretch-vertical","strikethrough","subscript","sun","sun-dim","sun-medium","sun-moon","sun-snow","sunrise","sunset","superscript","swatch-book","swiss-franc","switch-camera","sword","swords","syringe","table","table-2","table-cells-merge","table-cells-split","table-columns-split","table-of-contents","table-properties","table-rows-split","tablet","tablet-smartphone","tablets","tag","tags","tally-1","tally-2","tally-3","tally-4","tally-5","tangent","target","telescope","tent","tent-tree","terminal","test-tube","test-tube-diagonal","test-tubes","text","text-cursor","text-cursor-input","text-quote","text-search","text-select","theater","thermometer","thermometer-snowflake","thermometer-sun","thumbs-down","thumbs-up","ticket","ticket-check","ticket-minus","ticket-percent","ticket-plus","ticket-slash","ticket-x","tickets","tickets-plane","timer","timer-off","timer-reset","toggle-left","toggle-right","toilet","tornado","torus","touchpad","touchpad-off","tower-control","toy-brick","tractor","traffic-cone","train-front","train-front-tunnel","train-track","tram-front","trash","trash-2","tree-deciduous","tree-palm","tree-pine","trees","trello","trending-down","trending-up","trending-up-down","triangle","triangle-alert","triangle-right","trophy","truck","turtle","tv","tv-minimal","tv-minimal-play","twitch","twitter","type","type-outline","umbrella","umbrella-off","underline","undo","undo-2","undo-dot","unfold-horizontal","unfold-vertical","ungroup","university","unlink","unlink-2","unplug","upload","usb","user","user-check","user-cog","user-minus","user-pen","user-plus","user-round","user-round-check","user-round-cog","user-round-minus","user-round-pen","user-round-plus","user-round-search","user-round-x","user-search","user-x","users","users-round","utensils","utensils-crossed","utility-pole","variable","vault","vegan","venetian-mask","vibrate","vibrate-off","video","video-off","videotape","view","voicemail","volleyball","volume","volume-1","volume-2","volume-off","volume-x","vote","wallet","wallet-cards","wallet-minimal","wallpaper","wand","wand-sparkles","warehouse","washing-machine","watch","waves","waves-ladder","waypoints","webcam","webhook","webhook-off","weight","wheat","wheat-off","whole-word","wifi","wifi-high","wifi-low","wifi-off","wifi-zero","wind","wind-arrow-down","wine","wine-off","workflow","worm","wrap-text","wrench","x","youtube","zap","zap-off","zoom-in","zoom-out"},{"103134660123798"},{[48]={{1,{24,24},{49,0}},{1,{24,24},{0,49}},{1,{24,24},{74,0}},{1,{24,24},{49,25}},{1,{24,24},{0,74}},{1,{24,24},{99,0}},{1,{24,24},{74,25}},{1,{24,24},{74,50}},{1,{24,24},{49,50}},{1,{24,24},{0,99}},{1,{24,24},{124,0}},{1,{24,24},{99,25}},{1,{24,24},{49,75}},{1,{24,24},{0,124}},{1,{24,24},{99,50}},{1,{24,24},{149,0}},{1,{24,24},{124,25}},{1,{24,24},{74,75}},{1,{24,24},{49,100}},{1,{24,24},{0,149}},{1,{24,24},{174,0}},{1,{24,24},{149,25}},{1,{24,24},{124,50}},{1,{24,24},{99,75}},{1,{24,24},{74,100}},{1,{24,24},{49,125}},{1,{24,24},{0,174}},{1,{24,24},{199,0}},{1,{24,24},{174,25}},{1,{24,24},{149,50}},{1,{24,24},{124,75}},{1,{24,24},{99,100}},{1,{24,24},{74,125}},{1,{24,24},{49,150}},{1,{24,24},{0,199}},{1,{24,24},{224,0}},{1,{24,24},{199,25}},{1,{24,24},{174,50}},{1,{24,24},{149,75}},{1,{24,24},{124,100}},{1,{24,24},{99,125}},{1,{24,24},{74,150}},{1,{24,24},{49,175}},{1,{24,24},{0,224}},{1,{24,24},{249,0}},{1,{24,24},{224,25}},{1,{24,24},{199,50}},{1,{24,24},{174,75}},{1,{24,24},{149,100}},{1,{24,24},{124,125}},{1,{24,24},{74,175}},{1,{24,24},{99,150}},{1,{24,24},{49,200}},{1,{24,24},{249,25}},{1,{24,24},{0,249}},{1,{24,24},{274,0}},{1,{24,24},{224,50}},{1,{24,24},{174,100}},{1,{24,24},{199,75}},{1,{24,24},{124,150}},{1,{24,24},{149,125}},{1,{24,24},{74,200}},{1,{24,24},{99,175}},{1,{24,24},{0,274}},{1,{24,24},{49,225}},{1,{24,24},{324,0}},{1,{24,24},{299,0}},{1,{24,24},{274,25}},{1,{24,24},{249,50}},{1,{24,24},{224,75}},{1,{24,24},{199,100}},{1,{24,24},{174,125}},{1,{24,24},{149,150}},{1,{24,24},{124,175}},{1,{24,24},{99,200}},{1,{24,24},{74,225}},{1,{24,24},{49,250}},{1,{24,24},{0,299}},{1,{24,24},{224,100}},{1,{24,24},{299,25}},{1,{24,24},{274,50}},{1,{24,24},{249,75}},{1,{24,24},{124,200}},{1,{24,24},{199,125}},{1,{24,24},{174,150}},{1,{24,24},{149,175}},{1,{24,24},{149,200}},{1,{24,24},{99,225}},{1,{24,24},{74,250}},{1,{24,24},{49,275}},{1,{24,24},{0,324}},{1,{24,24},{349,0}},{1,{24,24},{324,25}},{1,{24,24},{299,50}},{1,{24,24},{274,75}},{1,{24,24},{249,100}},{1,{24,24},{224,125}},{1,{24,24},{199,150}},{1,{24,24},{174,175}},{1,{24,24},{124,225}},{1,{24,24},{99,250}},{1,{24,24},{74,275}},{1,{24,24},{49,300}},{1,{24,24},{0,349}},{1,{24,24},{374,0}},{1,{24,24},{349,25}},{1,{24,24},{324,50}},{1,{24,24},{299,75}},{1,{24,24},{274,100}},{1,{24,24},{249,125}},{1,{24,24},{224,175}},{1,{24,24},{224,150}},{1,{24,24},{199,175}},{1,{24,24},{174,200}},{1,{24,24},{149,225}},{1,{24,24},{124,250}},{1,{24,24},{99,275}},{1,{24,24},{74,300}},{1,{24,24},{49,325}},{1,{24,24},{0,374}},{1,{24,24},{399,0}},{1,{24,24},{374,25}},{1,{24,24},{349,50}},{1,{24,24},{324,75}},{1,{24,24},{299,100}},{1,{24,24},{274,125}},{1,{24,24},{249,150}},{1,{24,24},{199,200}},{1,{24,24},{174,225}},{1,{24,24},{149,250}},{1,{24,24},{124,275}},{1,{24,24},{99,300}},{1,{24,24},{74,325}},{1,{24,24},{49,350}},{1,{24,24},{0,399}},{1,{24,24},{299,125}},{1,{24,24},{424,0}},{1,{24,24},{399,25}},{1,{24,24},{374,50}},{1,{24,24},{349,75}},{1,{24,24},{324,100}},{1,{24,24},{274,150}},{1,{24,24},{224,200}},{1,{24,24},{249,175}},{1,{24,24},{149,275}},{1,{24,24},{199,225}},{1,{24,24},{174,250}},{1,{24,24},{124,300}},{1,{24,24},{74,350}},{1,{24,24},{99,325}},{1,{24,24},{349,100}},{1,{24,24},{49,375}},{1,{24,24},{0,424}},{1,{24,24},{449,0}},{1,{24,24},{424,25}},{1,{24,24},{399,50}},{1,{24,24},{374,75}},{1,{24,24},{324,125}},{1,{24,24},{299,150}},{1,{24,24},{274,175}},{1,{24,24},{249,200}},{1,{24,24},{224,225}},{1,{24,24},{199,250}},{1,{24,24},{174,275}},{1,{24,24},{149,300}},{1,{24,24},{124,325}},{1,{24,24},{99,350}},{1,{24,24},{74,375}},{1,{24,24},{49,400}},{1,{24,24},{0,449}},{1,{24,24},{474,0}},{1,{24,24},{374,100}},{1,{24,24},{449,25}},{1,{24,24},{424,50}},{1,{24,24},{399,75}},{1,{24,24},{349,125}},{1,{24,24},{324,150}},{1,{24,24},{299,175}},{1,{24,24},{274,200}},{1,{24,24},{174,325}},{1,{24,24},{249,225}},{1,{24,24},{224,250}},{1,{24,24},{199,275}},{1,{24,24},{174,300}},{1,{24,24},{149,325}},{1,{24,24},{124,350}},{1,{24,24},{99,375}},{1,{24,24},{74,400}},{1,{24,24},{49,425}},{1,{24,24},{0,474}},{1,{24,24},{499,0}},{1,{24,24},{474,25}},{1,{24,24},{449,50}},{1,{24,24},{374,125}},{1,{24,24},{424,75}},{1,{24,24},{399,100}},{1,{24,24},{349,150}},{1,{24,24},{324,175}},{1,{24,24},{299,200}},{1,{24,24},{249,250}},{1,{24,24},{274,225}},{1,{24,24},{224,275}},{1,{24,24},{199,300}},{1,{24,24},{49,450}},{1,{24,24},{149,350}},{1,{24,24},{124,375}},{1,{24,24},{99,400}},{1,{24,24},{74,425}},{1,{24,24},{0,499}},{1,{24,24},{474,50}},{1,{24,24},{524,0}},{1,{24,24},{499,25}},{1,{24,24},{449,75}},{1,{24,24},{424,100}},{1,{24,24},{399,125}},{1,{24,24},{374,150}},{1,{24,24},{299,225}},{1,{24,24},{349,175}},{1,{24,24},{324,200}},{1,{24,24},{274,250}},{1,{24,24},{174,350}},{1,{24,24},{249,275}},{1,{24,24},{224,300}},{1,{24,24},{199,325}},{1,{24,24},{149,375}},{1,{24,24},{124,400}},{1,{24,24},{49,475}},{1,{24,24},{99,425}},{1,{24,24},{74,450}},{1,{24,24},{549,0}},{1,{24,24},{0,524}},{1,{24,24},{499,50}},{1,{24,24},{524,25}},{1,{24,24},{449,100}},{1,{24,24},{474,75}},{1,{24,24},{399,150}},{1,{24,24},{424,125}},{1,{24,24},{374,175}},{1,{24,24},{424,150}},{1,{24,24},{349,200}},{1,{24,24},{324,225}},{1,{24,24},{299,250}},{1,{24,24},{249,300}},{1,{24,24},{274,275}},{1,{24,24},{224,325}},{1,{24,24},{199,350}},{1,{24,24},{174,375}},{1,{24,24},{149,400}},{1,{24,24},{124,425}},{1,{24,24},{74,475}},{1,{24,24},{99,450}},{1,{24,24},{49,500}},{1,{24,24},{574,0}},{1,{24,24},{0,549}},{1,{24,24},{549,25}},{1,{24,24},{524,50}},{1,{24,24},{499,75}},{1,{24,24},{449,125}},{1,{24,24},{474,100}},{1,{24,24},{374,200}},{1,{24,24},{399,175}},{1,{24,24},{299,275}},{1,{24,24},{349,225}},{1,{24,24},{324,250}},{1,{24,24},{274,300}},{1,{24,24},{224,350}},{1,{24,24},{249,325}},{1,{24,24},{149,425}},{1,{24,24},{199,375}},{1,{24,24},{174,400}},{1,{24,24},{124,450}},{1,{24,24},{99,475}},{1,{24,24},{74,500}},{1,{24,24},{49,525}},{1,{24,24},{0,574}},{1,{24,24},{599,0}},{1,{24,24},{574,25}},{1,{24,24},{549,50}},{1,{24,24},{524,75}},{1,{24,24},{499,100}},{1,{24,24},{474,125}},{1,{24,24},{349,250}},{1,{24,24},{449,150}},{1,{24,24},{424,175}},{1,{24,24},{399,200}},{1,{24,24},{374,225}},{1,{24,24},{324,275}},{1,{24,24},{199,400}},{1,{24,24},{299,300}},{1,{24,24},{274,325}},{1,{24,24},{249,350}},{1,{24,24},{224,375}},{1,{24,24},{174,425}},{1,{24,24},{149,450}},{1,{24,24},{124,475}},{1,{24,24},{49,550}},{1,{24,24},{99,500}},{1,{24,24},{74,525}},{1,{24,24},{0,599}},{1,{24,24},{624,0}},{1,{24,24},{599,25}},{1,{24,24},{574,50}},{1,{24,24},{549,75}},{1,{24,24},{499,125}},{1,{24,24},{524,100}},{1,{24,24},{474,150}},{1,{24,24},{449,175}},{1,{24,24},{424,200}},{1,{24,24},{399,225}},{1,{24,24},{374,250}},{1,{24,24},{349,275}},{1,{24,24},{324,300}},{1,{24,24},{299,325}},{1,{24,24},{249,375}},{1,{24,24},{274,350}},{1,{24,24},{174,450}},{1,{24,24},{199,425}},{1,{24,24},{224,400}},{1,{24,24},{124,500}},{1,{24,24},{149,475}},{1,{24,24},{74,550}},{1,{24,24},{99,525}},{1,{24,24},{49,575}},{1,{24,24},{0,624}},{1,{24,24},{624,25}},{1,{24,24},{649,0}},{1,{24,24},{249,425}},{1,{24,24},{599,50}},{1,{24,24},{574,75}},{1,{24,24},{549,100}},{1,{24,24},{524,125}},{1,{24,24},{499,150}},{1,{24,24},{474,175}},{1,{24,24},{449,200}},{1,{24,24},{424,225}},{1,{24,24},{399,250}},{1,{24,24},{349,300}},{1,{24,24},{374,275}},{1,{24,24},{324,325}},{1,{24,24},{299,350}},{1,{24,24},{274,375}},{1,{24,24},{249,400}},{1,{24,24},{224,425}},{1,{24,24},{199,450}},{1,{24,24},{174,475}},{1,{24,24},{124,525}},{1,{24,24},{149,500}},{1,{24,24},{99,550}},{1,{24,24},{74,575}},{1,{24,24},{49,600}},{1,{24,24},{0,649}},{1,{24,24},{674,0}},{1,{24,24},{649,25}},{1,{24,24},{624,50}},{1,{24,24},{599,75}},{1,{24,24},{549,125}},{1,{24,24},{574,100}},{1,{24,24},{524,150}},{1,{24,24},{499,175}},{1,{24,24},{474,200}},{1,{24,24},{449,225}},{1,{24,24},{424,250}},{1,{24,24},{374,300}},{1,{24,24},{399,275}},{1,{24,24},{349,325}},{1,{24,24},{299,375}},{1,{24,24},{324,350}},{1,{24,24},{274,400}},{1,{24,24},{224,450}},{1,{24,24},{199,475}},{1,{24,24},{174,500}},{1,{24,24},{599,100}},{1,{24,24},{149,525}},{1,{24,24},{124,550}},{1,{24,24},{99,575}},{1,{24,24},{74,600}},{1,{24,24},{49,625}},{1,{24,24},{699,0}},{1,{24,24},{0,674}},{1,{24,24},{674,25}},{1,{24,24},{649,50}},{1,{24,24},{624,75}},{1,{24,24},{199,500}},{1,{24,24},{574,125}},{1,{24,24},{549,150}},{1,{24,24},{524,175}},{1,{24,24},{499,200}},{1,{24,24},{474,225}},{1,{24,24},{449,250}},{1,{24,24},{424,275}},{1,{24,24},{399,300}},{1,{24,24},{374,325}},{1,{24,24},{349,350}},{1,{24,24},{324,375}},{1,{24,24},{299,400}},{1,{24,24},{274,425}},{1,{24,24},{249,450}},{1,{24,24},{224,475}},{1,{24,24},{499,225}},{1,{24,24},{174,525}},{1,{24,24},{149,550}},{1,{24,24},{124,575}},{1,{24,24},{99,600}},{1,{24,24},{74,625}},{1,{24,24},{49,650}},{1,{24,24},{0,699}},{1,{24,24},{699,25}},{1,{24,24},{724,0}},{1,{24,24},{674,50}},{1,{24,24},{624,100}},{1,{24,24},{649,75}},{1,{24,24},{599,125}},{1,{24,24},{549,175}},{1,{24,24},{574,150}},{1,{24,24},{524,200}},{1,{24,24},{474,250}},{1,{24,24},{449,275}},{1,{24,24},{424,300}},{1,{24,24},{374,350}},{1,{24,24},{399,325}},{1,{24,24},{349,375}},{1,{24,24},{324,400}},{1,{24,24},{299,425}},{1,{24,24},{274,450}},{1,{24,24},{249,475}},{1,{24,24},{224,500}},{1,{24,24},{199,525}},{1,{24,24},{174,550}},{1,{24,24},{149,575}},{1,{24,24},{124,600}},{1,{24,24},{99,625}},{1,{24,24},{74,650}},{1,{24,24},{49,675}},{1,{24,24},{0,724}},{1,{24,24},{749,0}},{1,{24,24},{724,25}},{1,{24,24},{674,75}},{1,{24,24},{699,50}},{1,{24,24},{649,100}},{1,{24,24},{624,125}},{1,{24,24},{599,150}},{1,{24,24},{574,175}},{1,{24,24},{424,325}},{1,{24,24},{549,200}},{1,{24,24},{524,225}},{1,{24,24},{499,250}},{1,{24,24},{474,275}},{1,{24,24},{449,300}},{1,{24,24},{399,350}},{1,{24,24},{374,375}},{1,{24,24},{349,400}},{1,{24,24},{324,425}},{1,{24,24},{299,450}},{1,{24,24},{274,475}},{1,{24,24},{249,500}},{1,{24,24},{224,525}},{1,{24,24},{199,550}},{1,{24,24},{174,575}},{1,{24,24},{149,600}},{1,{24,24},{124,625}},{1,{24,24},{99,650}},{1,{24,24},{74,675}},{1,{24,24},{49,700}},{1,{24,24},{0,749}},{1,{24,24},{774,0}},{1,{24,24},{749,25}},{1,{24,24},{724,50}},{1,{24,24},{699,75}},{1,{24,24},{674,100}},{1,{24,24},{649,125}},{1,{24,24},{624,150}},{1,{24,24},{549,225}},{1,{24,24},{599,175}},{1,{24,24},{574,200}},{1,{24,24},{524,250}},{1,{24,24},{499,275}},{1,{24,24},{474,300}},{1,{24,24},{374,400}},{1,{24,24},{449,325}},{1,{24,24},{424,350}},{1,{24,24},{399,375}},{1,{24,24},{349,425}},{1,{24,24},{324,450}},{1,{24,24},{299,475}},{1,{24,24},{274,500}},{1,{24,24},{249,525}},{1,{24,24},{224,550}},{1,{24,24},{199,575}},{1,{24,24},{174,600}},{1,{24,24},{74,700}},{1,{24,24},{149,625}},{1,{24,24},{124,650}},{1,{24,24},{99,675}},{1,{24,24},{49,725}},{1,{24,24},{799,0}},{1,{24,24},{0,774}},{1,{24,24},{774,25}},{1,{24,24},{749,50}},{1,{24,24},{724,75}},{1,{24,24},{699,100}},{1,{24,24},{674,125}},{1,{24,24},{649,150}},{1,{24,24},{624,175}},{1,{24,24},{599,200}},{1,{24,24},{574,225}},{1,{24,24},{549,250}},{1,{24,24},{524,275}},{1,{24,24},{499,300}},{1,{24,24},{449,350}},{1,{24,24},{474,325}},{1,{24,24},{424,375}},{1,{24,24},{399,400}},{1,{24,24},{374,425}},{1,{24,24},{349,450}},{1,{24,24},{299,500}},{1,{24,24},{324,475}},{1,{24,24},{249,550}},{1,{24,24},{274,525}},{1,{24,24},{224,575}},{1,{24,24},{149,650}},{1,{24,24},{199,600}},{1,{24,24},{174,625}},{1,{24,24},{99,700}},{1,{24,24},{124,675}},{1,{24,24},{0,799}},{1,{24,24},{74,725}},{1,{24,24},{49,750}},{1,{24,24},{824,0}},{1,{24,24},{799,25}},{1,{24,24},{774,50}},{1,{24,24},{749,75}},{1,{24,24},{724,100}},{1,{24,24},{649,175}},{1,{24,24},{699,125}},{1,{24,24},{674,150}},{1,{24,24},{624,200}},{1,{24,24},{599,225}},{1,{24,24},{574,250}},{1,{24,24},{549,275}},{1,{24,24},{524,300}},{1,{24,24},{499,325}},{1,{24,24},{474,350}},{1,{24,24},{449,375}},{1,{24,24},{699,175}},{1,{24,24},{424,400}},{1,{24,24},{374,450}},{1,{24,24},{399,425}},{1,{24,24},{349,475}},{1,{24,24},{299,525}},{1,{24,24},{324,500}},{1,{24,24},{274,550}},{1,{24,24},{224,600}},{1,{24,24},{249,575}},{1,{24,24},{199,625}},{1,{24,24},{174,650}},{1,{24,24},{124,700}},{1,{24,24},{149,675}},{1,{24,24},{99,725}},{1,{24,24},{49,775}},{1,{24,24},{74,750}},{1,{24,24},{0,824}},{1,{24,24},{849,0}},{1,{24,24},{824,25}},{1,{24,24},{799,50}},{1,{24,24},{774,75}},{1,{24,24},{749,100}},{1,{24,24},{724,125}},{1,{24,24},{674,175}},{1,{24,24},{699,150}},{1,{24,24},{624,225}},{1,{24,24},{649,200}},{1,{24,24},{574,275}},{1,{24,24},{599,250}},{1,{24,24},{524,325}},{1,{24,24},{549,300}},{1,{24,24},{499,350}},{1,{24,24},{474,375}},{1,{24,24},{424,425}},{1,{24,24},{449,400}},{1,{24,24},{374,475}},{1,{24,24},{399,450}},{1,{24,24},{349,500}},{1,{24,24},{324,525}},{1,{24,24},{274,575}},{1,{24,24},{299,550}},{1,{24,24},{249,600}},{1,{24,24},{224,625}},{1,{24,24},{199,650}},{1,{24,24},{174,675}},{1,{24,24},{149,700}},{1,{24,24},{124,725}},{1,{24,24},{74,775}},{1,{24,24},{99,750}},{1,{24,24},{49,800}},{1,{24,24},{0,849}},{1,{24,24},{849,25}},{1,{24,24},{874,0}},{1,{24,24},{799,75}},{1,{24,24},{824,50}},{1,{24,24},{774,100}},{1,{24,24},{724,150}},{1,{24,24},{749,125}},{1,{24,24},{674,200}},{1,{24,24},{649,225}},{1,{24,24},{599,275}},{1,{24,24},{624,250}},{1,{24,24},{574,300}},{1,{24,24},{549,325}},{1,{24,24},{474,400}},{1,{24,24},{524,350}},{1,{24,24},{499,375}},{1,{24,24},{374,500}},{1,{24,24},{449,425}},{1,{24,24},{424,450}},{1,{24,24},{399,475}},{1,{24,24},{324,550}},{1,{24,24},{349,525}},{1,{24,24},{274,600}},{1,{24,24},{299,575}},{1,{24,24},{224,650}},{1,{24,24},{249,625}},{1,{24,24},{199,675}},{1,{24,24},{149,725}},{1,{24,24},{174,700}},{1,{24,24},{99,775}},{1,{24,24},{124,750}},{1,{24,24},{49,825}},{1,{24,24},{74,800}},{1,{24,24},{0,874}},{1,{24,24},{899,0}},{1,{24,24},{874,25}},{1,{24,24},{124,775}},{1,{24,24},{849,50}},{1,{24,24},{824,75}},{1,{24,24},{799,100}},{1,{24,24},{774,125}},{1,{24,24},{749,150}},{1,{24,24},{724,175}},{1,{24,24},{699,200}},{1,{24,24},{674,225}},{1,{24,24},{624,275}},{1,{24,24},{649,250}},{1,{24,24},{599,300}},{1,{24,24},{574,325}},{1,{24,24},{549,350}},{1,{24,24},{524,375}},{1,{24,24},{499,400}},{1,{24,24},{474,425}},{1,{24,24},{424,475}},{1,{24,24},{449,450}},{1,{24,24},{399,500}},{1,{24,24},{374,525}},{1,{24,24},{349,550}},{1,{24,24},{324,575}},{1,{24,24},{274,625}},{1,{24,24},{299,600}},{1,{24,24},{249,650}},{1,{24,24},{224,675}},{1,{24,24},{199,700}},{1,{24,24},{174,725}},{1,{24,24},{149,750}},{1,{24,24},{99,800}},{1,{24,24},{74,825}},{1,{24,24},{49,850}},{1,{24,24},{0,899}},{1,{24,24},{924,0}},{1,{24,24},{899,25}},{1,{24,24},{874,50}},{1,{24,24},{849,75}},{1,{24,24},{824,100}},{1,{24,24},{774,150}},{1,{24,24},{799,125}},{1,{24,24},{749,175}},{1,{24,24},{699,225}},{1,{24,24},{724,200}},{1,{24,24},{649,275}},{1,{24,24},{674,250}},{1,{24,24},{624,300}},{1,{24,24},{599,325}},{1,{24,24},{574,350}},{1,{24,24},{549,375}},{1,{24,24},{524,400}},{1,{24,24},{474,450}},{1,{24,24},{499,425}},{1,{24,24},{449,475}},{1,{24,24},{424,500}},{1,{24,24},{374,550}},{1,{24,24},{399,525}},{1,{24,24},{349,575}},{1,{24,24},{324,600}},{1,{24,24},{299,625}},{1,{24,24},{149,775}},{1,{24,24},{274,650}},{1,{24,24},{249,675}},{1,{24,24},{199,725}},{1,{24,24},{224,700}},{1,{24,24},{174,750}},{1,{24,24},{124,800}},{1,{24,24},{99,825}},{1,{24,24},{74,850}},{1,{24,24},{49,875}},{1,{24,24},{949,0}},{1,{24,24},{0,924}},{1,{24,24},{924,25}},{1,{24,24},{899,50}},{1,{24,24},{874,75}},{1,{24,24},{849,100}},{1,{24,24},{749,200}},{1,{24,24},{824,125}},{1,{24,24},{799,150}},{1,{24,24},{774,175}},{1,{24,24},{724,225}},{1,{24,24},{649,300}},{1,{24,24},{699,250}},{1,{24,24},{674,275}},{1,{24,24},{624,325}},{1,{24,24},{599,350}},{1,{24,24},{574,375}},{1,{24,24},{549,400}},{1,{24,24},{399,550}},{1,{24,24},{524,425}},{1,{24,24},{499,450}},{1,{24,24},{474,475}},{1,{24,24},{449,500}},{1,{24,24},{424,525}},{1,{24,24},{374,575}},{1,{24,24},{299,650}},{1,{24,24},{349,600}},{1,{24,24},{324,625}},{1,{24,24},{274,675}},{1,{24,24},{249,700}},{1,{24,24},{224,725}},{1,{24,24},{199,750}},{1,{24,24},{0,949}},{1,{24,24},{174,775}},{1,{24,24},{149,800}},{1,{24,24},{124,825}},{1,{24,24},{99,850}},{1,{24,24},{74,875}},{1,{24,24},{49,900}},{1,{24,24},{974,0}},{1,{24,24},{949,25}},{1,{24,24},{924,50}},{1,{24,24},{799,175}},{1,{24,24},{899,75}},{1,{24,24},{874,100}},{1,{24,24},{849,125}},{1,{24,24},{824,150}},{1,{24,24},{774,200}},{1,{24,24},{749,225}},{1,{24,24},{724,250}},{1,{24,24},{699,275}},{1,{24,24},{649,325}},{1,{24,24},{674,300}},{1,{24,24},{624,350}},{1,{24,24},{599,375}},{1,{24,24},{574,400}},{1,{24,24},{499,475}},{1,{24,24},{549,425}},{1,{24,24},{524,450}},{1,{24,24},{474,500}},{1,{24,24},{449,525}},{1,{24,24},{424,550}},{1,{24,24},{224,750}},{1,{24,24},{399,575}},{1,{24,24},{374,600}},{1,{24,24},{349,625}},{1,{24,24},{324,650}},{1,{24,24},{299,675}},{1,{24,24},{274,700}},{1,{24,24},{249,725}},{1,{24,24},{199,775}},{1,{24,24},{174,800}},{1,{24,24},{149,825}},{1,{24,24},{124,850}},{1,{24,24},{99,875}},{1,{24,24},{74,900}},{1,{24,24},{49,925}},{1,{24,24},{0,974}},{1,{24,24},{974,25}},{1,{24,24},{949,50}},{1,{24,24},{924,75}},{1,{24,24},{899,100}},{1,{24,24},{874,125}},{1,{24,24},{849,150}},{1,{24,24},{824,175}},{1,{24,24},{799,200}},{1,{24,24},{724,275}},{1,{24,24},{774,225}},{1,{24,24},{749,250}},{1,{24,24},{649,350}},{1,{24,24},{699,300}},{1,{24,24},{674,325}},{1,{24,24},{499,500}},{1,{24,24},{624,375}},{1,{24,24},{599,400}},{1,{24,24},{574,425}},{1,{24,24},{549,450}},{1,{24,24},{524,475}},{1,{24,24},{474,525}},{1,{24,24},{449,550}},{1,{24,24},{424,575}},{1,{24,24},{349,650}},{1,{24,24},{374,625}},{1,{24,24},{399,600}},{1,{24,24},{299,700}},{1,{24,24},{324,675}},{1,{24,24},{274,725}},{1,{24,24},{224,775}},{1,{24,24},{249,750}},{1,{24,24},{199,800}},{1,{24,24},{174,825}},{1,{24,24},{149,850}},{1,{24,24},{124,875}},{1,{24,24},{99,900}},{1,{24,24},{74,925}},{1,{24,24},{49,950}},{1,{24,24},{974,50}},{1,{24,24},{949,75}},{1,{24,24},{924,100}},{1,{24,24},{874,150}},{1,{24,24},{899,125}},{1,{24,24},{849,175}},{1,{24,24},{824,200}},{1,{24,24},{774,250}},{1,{24,24},{799,225}},{1,{24,24},{699,325}},{1,{24,24},{724,300}},{1,{24,24},{749,275}},{1,{24,24},{674,350}},{1,{24,24},{249,775}},{1,{24,24},{649,375}},{1,{24,24},{624,400}},{1,{24,24},{599,425}},{1,{24,24},{574,450}},{1,{24,24},{524,500}},{1,{24,24},{549,475}},{1,{24,24},{499,525}},{1,{24,24},{474,550}},{1,{24,24},{449,575}},{1,{24,24},{424,600}},{1,{24,24},{399,625}},{1,{24,24},{374,650}},{1,{24,24},{349,675}},{1,{24,24},{324,700}},{1,{24,24},{299,725}},{1,{24,24},{274,750}},{1,{24,24},{174,850}},{1,{24,24},{224,800}},{1,{24,24},{199,825}},{1,{24,24},{99,925}},{1,{24,24},{149,875}},{1,{24,24},{124,900}},{1,{24,24},{949,100}},{1,{24,24},{49,975}},{1,{24,24},{74,950}},{1,{24,24},{974,75}},{1,{24,24},{924,125}},{1,{24,24},{899,150}},{1,{24,24},{874,175}},{1,{24,24},{849,200}},{1,{24,24},{824,225}},{1,{24,24},{799,250}},{1,{24,24},{574,475}},{1,{24,24},{774,275}},{1,{24,24},{749,300}},{1,{24,24},{724,325}},{1,{24,24},{699,350}},{1,{24,24},{674,375}},{1,{24,24},{649,400}},{1,{24,24},{624,425}},{1,{24,24},{599,450}},{1,{24,24},{549,500}},{1,{24,24},{524,525}},{1,{24,24},{199,850}},{1,{24,24},{249,800}},{1,{24,24},{474,575}},{1,{24,24},{499,550}},{1,{24,24},{449,600}},{1,{24,24},{399,650}},{1,{24,24},{424,625}},{1,{24,24},{374,675}},{1,{24,24},{324,725}},{1,{24,24},{349,700}},{1,{24,24},{274,775}},{1,{24,24},{299,750}},{1,{24,24},{224,825}},{1,{24,24},{174,875}},{1,{24,24},{124,925}},{1,{24,24},{149,900}},{1,{24,24},{99,950}},{1,{24,24},{974,100}},{1,{24,24},{74,975}},{1,{24,24},{949,125}},{1,{24,24},{924,150}},{1,{24,24},{899,175}},{1,{24,24},{874,200}},{1,{24,24},{599,475}},{1,{24,24},{849,225}},{1,{24,24},{824,250}},{1,{24,24},{799,275}},{1,{24,24},{774,300}},{1,{24,24},{749,325}},{1,{24,24},{724,350}},{1,{24,24},{699,375}},{1,{24,24},{674,400}},{1,{24,24},{649,425}},{1,{24,24},{624,450}},{1,{24,24},{199,875}},{1,{24,24},{574,500}},{1,{24,24},{549,525}},{1,{24,24},{524,550}},{1,{24,24},{499,575}},{1,{24,24},{474,600}},{1,{24,24},{449,625}},{1,{24,24},{424,650}},{1,{24,24},{399,675}},{1,{24,24},{374,700}},{1,{24,24},{349,725}},{1,{24,24},{324,750}},{1,{24,24},{299,775}},{1,{24,24},{274,800}},{1,{24,24},{249,825}},{1,{24,24},{224,850}},{1,{24,24},{174,900}},{1,{24,24},{99,975}},{1,{24,24},{149,925}},{1,{24,24},{124,950}},{1,{24,24},{974,125}},{1,{24,24},{949,150}},{1,{24,24},{924,175}},{1,{24,24},{899,200}},{1,{24,24},{849,250}},{1,{24,24},{874,225}},{1,{24,24},{799,300}},{1,{24,24},{824,275}},{1,{24,24},{774,325}},{1,{24,24},{449,650}},{1,{24,24},{749,350}},{1,{24,24},{724,375}},{1,{24,24},{699,400}},{1,{24,24},{674,425}},{1,{24,24},{649,450}},{1,{24,24},{624,475}},{1,{24,24},{599,500}},{1,{24,24},{574,525}},{1,{24,24},{549,550}},{1,{24,24},{524,575}},{1,{24,24},{499,600}},{1,{24,24},{474,625}},{1,{24,24},{399,700}},{1,{24,24},{424,675}},{1,{24,24},{349,750}},{1,{24,24},{374,725}},{1,{24,24},{199,900}},{1,{24,24},{324,775}},{1,{24,24},{224,875}},{1,{24,24},{299,800}},{1,{24,24},{274,825}},{1,{24,24},{249,850}},{1,{24,24},{724,400}},{1,{24,24},{174,925}},{1,{24,24},{124,975}},{1,{24,24},{149,950}},{1,{24,24},{924,200}},{1,{24,24},{974,150}},{1,{24,24},{949,175}},{1,{24,24},{899,225}},{1,{24,24},{874,250}},{1,{24,24},{849,275}},{1,{24,24},{774,350}},{1,{24,24},{824,300}},{1,{24,24},{799,325}},{1,{24,24},{749,375}},{1,{24,24},{624,500}},{1,{24,24},{699,425}},{1,{24,24},{674,450}},{1,{24,24},{649,475}},{1,{24,24},{524,600}},{1,{24,24},{574,550}},{1,{24,24},{599,525}},{1,{24,24},{549,575}},{1,{24,24},{499,625}},{1,{24,24},{474,650}},{1,{24,24},{449,675}},{1,{24,24},{349,775}},{1,{24,24},{424,700}},{1,{24,24},{399,725}},{1,{24,24},{374,750}},{1,{24,24},{299,825}},{1,{24,24},{324,800}},{1,{24,24},{249,875}},{1,{24,24},{274,850}},{1,{24,24},{974,175}},{1,{24,24},{224,900}},{1,{24,24},{199,925}},{1,{24,24},{174,950}},{1,{24,24},{149,975}},{1,{24,24},{949,200}},{1,{24,24},{924,225}},{1,{24,24},{899,250}},{1,{24,24},{874,275}},{1,{24,24},{674,475}},{1,{24,24},{849,300}},{1,{24,24},{824,325}},{1,{24,24},{799,350}},{1,{24,24},{774,375}},{1,{24,24},{749,400}},{1,{24,24},{724,425}},{1,{24,24},{699,450}},{1,{24,24},{649,500}},{1,{24,24},{624,525}},{1,{24,24},{574,575}},{1,{24,24},{599,550}},{1,{24,24},{549,600}},{1,{24,24},{449,700}},{1,{24,24},{524,625}},{1,{24,24},{499,650}},{1,{24,24},{474,675}},{1,{24,24},{349,800}},{1,{24,24},{424,725}},{1,{24,24},{399,750}},{1,{24,24},{374,775}},{1,{24,24},{249,900}},{1,{24,24},{324,825}},{1,{24,24},{299,850}},{1,{24,24},{274,875}},{1,{24,24},{974,200}},{1,{24,24},{224,925}},{1,{24,24},{199,950}},{1,{24,24},{174,975}},{1,{24,24},{949,225}},{1,{24,24},{924,250}},{1,{24,24},{899,275}},{1,{24,24},{874,300}},{1,{24,24},{849,325}},{1,{24,24},{824,350}},{1,{24,24},{799,375}},{1,{24,24},{774,400}},{1,{24,24},{749,425}},{1,{24,24},{724,450}},{1,{24,24},{624,550}},{1,{24,24},{699,475}},{1,{24,24},{674,500}},{1,{24,24},{649,525}},{1,{24,24},{524,650}},{1,{24,24},{599,575}},{1,{24,24},{574,600}},{1,{24,24},{549,625}},{1,{24,24},{499,675}},{1,{24,24},{474,700}},{1,{24,24},{449,725}},{1,{24,24},{424,750}},{1,{24,24},{249,925}},{1,{24,24},{399,775}},{1,{24,24},{374,800}},{1,{24,24},{349,825}},{1,{24,24},{324,850}},{1,{24,24},{299,875}},{1,{24,24},{274,900}},{1,{24,24},{224,950}},{1,{24,24},{199,975}},{1,{24,24},{974,225}},{1,{24,24},{924,275}},{1,{24,24},{949,250}},{1,{24,24},{899,300}},{1,{24,24},{824,375}},{1,{24,24},{874,325}},{1,{24,24},{849,350}},{1,{24,24},{774,425}},{1,{24,24},{799,400}},{1,{24,24},{724,475}},{1,{24,24},{749,450}},{1,{24,24},{699,500}},{1,{24,24},{674,525}},{1,{24,24},{599,600}},{1,{24,24},{649,550}},{1,{24,24},{624,575}},{1,{24,24},{574,625}},{1,{24,24},{499,700}},{1,{24,24},{549,650}},{1,{24,24},{524,675}},{1,{24,24},{474,725}},{1,{24,24},{424,775}},{1,{24,24},{449,750}},{1,{24,24},{399,800}},{1,{24,24},{349,850}},{1,{24,24},{374,825}},{1,{24,24},{324,875}},{1,{24,24},{299,900}},{1,{24,24},{274,925}},{1,{24,24},{224,975}},{1,{24,24},{249,950}},{1,{24,24},{974,250}},{1,{24,24},{924,300}},{1,{24,24},{949,275}},{1,{24,24},{899,325}},{1,{24,24},{874,350}},{1,{24,24},{849,375}},{1,{24,24},{824,400}},{1,{24,24},{799,425}},{1,{24,24},{774,450}},{1,{24,24},{749,475}},{1,{24,24},{724,500}},{1,{24,24},{699,525}},{1,{24,24},{674,550}},{1,{24,24},{599,625}},{1,{24,24},{649,575}},{1,{24,24},{624,600}},{1,{24,24},{574,650}},{1,{24,24},{549,675}},{1,{24,24},{524,700}},{1,{24,24},{499,725}},{1,{24,24},{474,750}},{1,{24,24},{249,975}},{1,{24,24},{449,775}},{1,{24,24},{424,800}},{1,{24,24},{399,825}},{1,{24,24},{374,850}},{1,{24,24},{349,875}},{1,{24,24},{324,900}},{1,{24,24},{299,925}},{1,{24,24},{274,950}},{1,{24,24},{974,275}},{1,{24,24},{949,300}},{1,{24,24},{924,325}},{1,{24,24},{899,350}},{1,{24,24},{824,425}},{1,{24,24},{874,375}},{1,{24,24},{849,400}},{1,{24,24},{774,475}},{1,{24,24},{799,450}},{1,{24,24},{724,525}},{1,{24,24},{749,500}},{1,{24,24},{699,550}},{1,{24,24},{674,575}},{1,{24,24},{649,600}},{1,{24,24},{574,675}},{1,{24,24},{624,625}},{1,{24,24},{599,650}},{1,{24,24},{524,725}},{1,{24,24},{549,700}},{1,{24,24},{474,775}},{1,{24,24},{499,750}},{1,{24,24},{449,800}},{1,{24,24},{424,825}},{1,{24,24},{399,850}},{1,{24,24},{374,875}},{1,{24,24},{349,900}},{1,{24,24},{324,925}},{1,{24,24},{274,975}},{1,{24,24},{299,950}},{1,{24,24},{949,325}},{1,{24,24},{974,300}},{1,{24,24},{899,375}},{1,{24,24},{924,350}},{1,{24,24},{874,400}},{1,{24,24},{849,425}},{1,{24,24},{824,450}},{1,{24,24},{799,475}},{1,{24,24},{774,500}},{1,{24,24},{749,525}},{1,{24,24},{724,550}},{1,{24,24},{699,575}},{1,{24,24},{674,600}},{1,{24,24},{649,625}},{1,{24,24},{599,675}},{1,{24,24},{624,650}},{1,{24,24},{524,750}},{1,{24,24},{574,700}},{1,{24,24},{549,725}},{1,{24,24},{474,800}},{1,{24,24},{499,775}},{1,{24,24},{449,825}},{1,{24,24},{924,375}},{1,{24,24},{424,850}},{1,{24,24},{399,875}},{1,{24,24},{374,900}},{1,{24,24},{349,925}},{1,{24,24},{324,950}},{1,{24,24},{299,975}},{1,{24,24},{974,325}},{1,{24,24},{949,350}},{1,{24,24},{899,400}},{1,{24,24},{849,450}},{1,{24,24},{874,425}},{1,{24,24},{799,500}},{1,{24,24},{824,475}},{1,{24,24},{749,550}},{1,{24,24},{774,525}},{1,{24,24},{624,675}},{1,{24,24},{724,575}},{1,{24,24},{699,600}},{1,{24,24},{674,625}},{1,{24,24},{649,650}},{1,{24,24},{599,700}},{1,{24,24},{524,775}},{1,{24,24},{574,725}},{1,{24,24},{549,750}},{1,{24,24},{499,800}},{1,{24,24},{474,825}},{1,{24,24},{374,925}},{1,{24,24},{449,850}},{1,{24,24},{424,875}},{1,{24,24},{399,900}},{1,{24,24},{324,975}},{1,{24,24},{349,950}},{1,{24,24},{974,350}},{1,{24,24},{924,400}},{1,{24,24},{949,375}},{1,{24,24},{899,425}},{1,{24,24},{874,450}},{1,{24,24},{599,725}},{1,{24,24},{849,475}},{1,{24,24},{824,500}},{1,{24,24},{799,525}},{1,{24,24},{774,550}},{1,{24,24},{749,575}},{1,{24,24},{724,600}},{1,{24,24},{699,625}},{1,{24,24},{674,650}},{1,{24,24},{649,675}},{1,{24,24},{624,700}},{1,{24,24},{549,775}},{1,{24,24},{574,750}},{1,{24,24},{524,800}},{1,{24,24},{499,825}},{1,{24,24},{474,850}},{1,{24,24},{449,875}},{1,{24,24},{424,900}},{1,{24,24},{399,925}},{1,{24,24},{374,950}},{1,{24,24},{349,975}},{1,{24,24},{974,375}},{1,{24,24},{949,400}},{1,{24,24},{824,525}},{1,{24,24},{924,425}},{1,{24,24},{899,450}},{1,{24,24},{874,475}},{1,{24,24},{849,500}},{1,{24,24},{799,550}},{1,{24,24},{749,600}},{1,{24,24},{774,575}},{1,{24,24},{724,625}},{1,{24,24},{699,650}},{1,{24,24},{674,675}},{1,{24,24},{649,700}},{1,{24,24},{624,725}},{1,{24,24},{599,750}},{1,{24,24},{574,775}},{1,{24,24},{549,800}},{1,{24,24},{524,825}},{1,{24,24},{449,900}},{1,{24,24},{499,850}},{1,{24,24},{474,875}},{1,{24,24},{399,950}},{1,{24,24},{424,925}},{1,{24,24},{374,975}},{1,{24,24},{974,400}},{1,{24,24},{949,425}},{1,{24,24},{924,450}},{1,{24,24},{899,475}},{1,{24,24},{874,500}},{1,{24,24},{849,525}},{1,{24,24},{824,550}},{1,{24,24},{799,575}},{1,{24,24},{774,600}},{1,{24,24},{724,650}},{1,{24,24},{749,625}},{1,{24,24},{699,675}},{1,{24,24},{674,700}},{1,{24,24},{649,725}},{1,{24,24},{624,750}},{1,{24,24},{874,575}},{1,{24,24},{599,775}},{1,{24,24},{524,850}},{1,{24,24},{574,800}},{1,{24,24},{549,825}},{1,{24,24},{499,875}},{1,{24,24},{474,900}},{1,{24,24},{449,925}},{1,{24,24},{424,950}},{1,{24,24},{399,975}},{1,{24,24},{974,425}},{1,{24,24},{899,500}},{1,{24,24},{949,450}},{1,{24,24},{924,475}},{1,{24,24},{874,525}},{1,{24,24},{849,550}},{1,{24,24},{824,575}},{1,{24,24},{774,625}},{1,{24,24},{799,600}},{1,{24,24},{749,650}},{1,{24,24},{724,675}},{1,{24,24},{699,700}},{1,{24,24},{674,725}},{1,{24,24},{649,750}},{1,{24,24},{524,875}},{1,{24,24},{599,800}},{1,{24,24},{624,775}},{1,{24,24},{574,825}},{1,{24,24},{549,850}},{1,{24,24},{499,900}},{1,{24,24},{474,925}},{1,{24,24},{449,950}},{1,{24,24},{424,975}},{1,{24,24},{974,450}},{1,{24,24},{949,475}},{1,{24,24},{924,500}},{1,{24,24},{899,525}},{1,{24,24},{874,550}},{1,{24,24},{849,575}},{1,{24,24},{799,625}},{1,{24,24},{824,600}},{1,{24,24},{774,650}},{1,{24,24},{749,675}},{1,{24,24},{724,700}},{1,{24,24},{699,725}},{1,{24,24},{674,750}},{1,{24,24},{649,775}},{1,{24,24},{624,800}},{1,{24,24},{599,825}},{1,{48,48},{0,0}},{1,{24,24},{574,850}},{1,{24,24},{549,875}},{1,{24,24},{524,900}},{1,{24,24},{499,925}},{1,{24,24},{474,950}},{1,{24,24},{449,975}},{1,{24,24},{974,475}},{1,{24,24},{924,525}},{1,{24,24},{949,500}},{1,{24,24},{899,550}},{1,{24,24},{849,600}},{1,{24,24},{824,625}},{1,{24,24},{799,650}},{1,{24,24},{724,725}},{1,{24,24},{774,675}},{1,{24,24},{749,700}},{1,{24,24},{699,750}},{1,{24,24},{674,775}},{1,{24,24},{649,800}},{1,{24,24},{624,825}},{1,{24,24},{599,850}},{1,{24,24},{574,875}},{1,{24,24},{549,900}},{1,{24,24},{524,925}},{1,{24,24},{499,950}},{1,{24,24},{474,975}},{1,{24,24},{874,600}},{1,{24,24},{974,500}},{1,{24,24},{949,525}},{1,{24,24},{924,550}},{1,{24,24},{899,575}},{1,{24,24},{849,625}},{1,{24,24},{824,650}},{1,{24,24},{799,675}},{1,{24,24},{774,700}},{1,{24,24},{749,725}},{1,{24,24},{724,750}},{1,{24,24},{699,775}},{1,{24,24},{674,800}},{1,{24,24},{649,825}},{1,{24,24},{949,550}},{1,{24,24},{624,850}},{1,{24,24},{599,875}},{1,{24,24},{574,900}},{1,{24,24},{549,925}},{1,{24,24},{524,950}},{1,{24,24},{499,975}},{1,{24,24},{974,525}},{1,{24,24},{899,600}},{1,{24,24},{924,575}},{1,{24,24},{874,625}},{1,{24,24},{849,650}},{1,{24,24},{824,675}},{1,{24,24},{799,700}},{1,{24,24},{774,725}},{1,{24,24},{749,750}},{1,{24,24},{724,775}},{1,{24,24},{699,800}},{1,{24,24},{674,825}},{1,{24,24},{649,850}},{1,{24,24},{624,875}},{1,{24,24},{574,925}},{1,{24,24},{599,900}},{1,{24,24},{549,950}},{1,{24,24},{974,550}},{1,{24,24},{524,975}},{1,{24,24},{949,575}},{1,{24,24},{799,725}},{1,{24,24},{899,625}},{1,{24,24},{924,600}},{1,{24,24},{874,650}},{1,{24,24},{849,675}},{1,{24,24},{824,700}},{1,{24,24},{774,750}},{1,{24,24},{699,825}},{1,{24,24},{749,775}},{1,{24,24},{724,800}},{1,{24,24},{674,850}},{1,{24,24},{649,875}},{1,{24,24},{924,625}},{1,{24,24},{624,900}},{1,{24,24},{599,925}},{1,{24,24},{574,950}},{1,{24,24},{549,975}},{1,{24,24},{974,575}},{1,{24,24},{949,600}},{1,{24,24},{874,675}},{1,{24,24},{899,650}},{1,{24,24},{799,750}},{1,{24,24},{849,700}},{1,{24,24},{824,725}},{1,{24,24},{774,775}},{1,{24,24},{749,800}},{1,{24,24},{724,825}},{1,{24,24},{699,850}},{1,{24,24},{674,875}},{1,{24,24},{624,925}},{1,{24,24},{649,900}},{1,{24,24},{599,950}},{1,{24,24},{574,975}},{1,{24,24},{974,600}},{1,{24,24},{949,625}},{1,{24,24},{899,675}},{1,{24,24},{924,650}},{1,{24,24},{874,700}},{1,{24,24},{849,725}},{1,{24,24},{799,775}},{1,{24,24},{824,750}},{1,{24,24},{774,800}},{1,{24,24},{749,825}},{1,{24,24},{724,850}},{1,{24,24},{699,875}},{1,{24,24},{674,900}},{1,{24,24},{649,925}},{1,{24,24},{599,975}},{1,{24,24},{624,950}},{1,{24,24},{924,675}},{1,{24,24},{974,625}},{1,{24,24},{949,650}},{1,{24,24},{899,700}},{1,{24,24},{874,725}},{1,{24,24},{849,750}},{1,{24,24},{774,825}},{1,{24,24},{799,800}},{1,{24,24},{824,775}},{1,{24,24},{749,850}},{1,{24,24},{724,875}},{1,{24,24},{674,925}},{1,{24,24},{699,900}},{1,{24,24},{624,975}},{1,{24,24},{649,950}},{1,{24,24},{974,650}},{1,{24,24},{899,725}},{1,{24,24},{949,675}},{1,{24,24},{924,700}},{1,{24,24},{874,750}},{1,{24,24},{849,775}},{1,{24,24},{824,800}},{1,{24,24},{799,825}},{1,{24,24},{749,875}},{1,{24,24},{774,850}},{1,{24,24},{724,900}},{1,{24,24},{699,925}},{1,{24,24},{674,950}},{1,{24,24},{949,725}},{1,{24,24},{649,975}},{1,{24,24},{974,675}},{1,{24,24},{949,700}},{1,{24,24},{924,725}},{1,{24,24},{899,750}},{1,{24,24},{699,950}},{1,{24,24},{874,775}},{1,{24,24},{849,800}},{1,{24,24},{824,825}},{1,{24,24},{799,850}},{1,{24,24},{774,875}},{1,{24,24},{749,900}},{1,{24,24},{724,925}},{1,{24,24},{674,975}},{1,{24,24},{974,700}},{1,{24,24},{899,775}},{1,{24,24},{924,750}},{1,{24,24},{849,825}},{1,{24,24},{874,800}},{1,{24,24},{824,850}},{1,{24,24},{799,875}},{1,{24,24},{774,900}},{1,{24,24},{749,925}},{1,{24,24},{724,950}},{1,{24,24},{974,725}},{1,{24,24},{699,975}},{1,{24,24},{924,775}},{1,{24,24},{949,750}},{1,{24,24},{899,800}},{1,{24,24},{874,825}},{1,{24,24},{849,850}},{1,{24,24},{824,875}},{1,{24,24},{974,750}},{1,{24,24},{799,900}},{1,{24,24},{774,925}},{1,{24,24},{749,950}},{1,{24,24},{724,975}},{1,{24,24},{949,775}},{1,{24,24},{874,850}},{1,{24,24},{924,800}},{1,{24,24},{899,825}},{1,{24,24},{849,875}},{1,{24,24},{799,925}},{1,{24,24},{824,900}},{1,{24,24},{774,950}},{1,{24,24},{749,975}},{1,{24,24},{974,775}},{1,{24,24},{924,825}},{1,{24,24},{949,800}},{1,{24,24},{899,850}},{1,{24,24},{874,875}},{1,{24,24},{824,925}},{1,{24,24},{849,900}},{1,{24,24},{799,950}},{1,{24,24},{974,800}},{1,{24,24},{774,975}},{1,{24,24},{949,825}},{1,{24,24},{824,950}},{1,{24,24},{924,850}},{1,{24,24},{899,875}},{1,{24,24},{874,900}},{1,{24,24},{849,925}},{1,{24,24},{974,825}},{1,{24,24},{799,975}},{1,{24,24},{924,875}},{1,{24,24},{949,850}},{1,{24,24},{899,900}},{1,{24,24},{874,925}},{1,{24,24},{849,950}},{1,{24,24},{824,975}},{1,{24,24},{974,850}},{1,{24,24},{949,875}},{1,{24,24},{899,925}},{1,{24,24},{924,900}},{1,{24,24},{874,950}},{1,{24,24},{849,975}}}}}

local IconIndices: {string} = Icons[1]
local IdIndices:   {string} = Icons[2]

local IconRegistry: {[number]: {number | {number}}} = Icons[3]

Lucide.Icons = IconIndices

type Icon = {
    IconName: string,
    Id:       number,
    Url:      string,

    ImageRectSize:   Vector2,
    ImageRectOffset: Vector2,
}

function Lucide.GetAsset(Name: string): (Icon)?
    local Size = 48

    local IconIndex = table.find(IconIndices, Name)
    if not IconIndex then return end

    local CurrentDifference = (1 / 0)
    local CurrentSize       = Size

    for RegistrySize in IconRegistry do
        local Difference = Size - RegistrySize
        Difference       = Difference > 0 and Difference or -Difference

        if Difference < CurrentDifference then
            CurrentDifference = Difference
            CurrentSize       = RegistrySize
        end
    end

    local Icon = IconRegistry[CurrentSize][IconIndex]
    if not Icon then return end

    return {
        Id  = tonumber(IdIndices[Icon[1]]),
        Url = "rbxassetid://" .. IdIndices[Icon[1]],

        IconName        = Name,
        ImageRectSize   = Vector2.new(Icon[2][1], Icon[2][2]),
        ImageRectOffset = Vector2.new(Icon[3][1], Icon[3][2]),
    }
end

return Lucide

end)() end,
    [52] = function()
local wax, _, _ = __waximport(52)

return (function()

--// Source by deividcomsono //

local randomstring
    = randomstring

local SetClipboard = setclipboard or nil
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GetHUi = gethui or function() 
    return shared.CoreGui
end

local LocalPlayer = shared.Speaker
local Mouse = LocalPlayer:GetMouse()

local Translations = wax.shared.Translations
local GetTranslation = Translations.GetTranslation
local PreRender = shared.RunService.PreRender

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}

local Library = {
    LocalPlayer = LocalPlayer,
    DevicePlatform = nil,
    IsMobile = false,

    ScreenGui = nil,

    ActiveTab = nil,
    Tabs = {},

    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},

    Notifications = {},

    ToggleKeybind = Enum.KeyCode.RightControl,
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    Toggled = false,
    Unloaded = false,

    Labels = Labels,
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

    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 4,

    IsLightTheme = false,
    Scheme = {
        BackgroundColor = Color3.fromRGB(15, 15, 15),
        MainColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(125, 85, 255),
        OutlineColor = Color3.fromRGB(40, 40, 40),
        FontColor = Color3.new(1, 1, 1),
        Font = Font.fromEnum(Enum.Font.BuilderSans),

        Red = Color3.fromRGB(255, 50, 50),
        Dark = Color3.new(0, 0, 0),
        White = Color3.new(1, 1, 1),
    },

    Registry = {},
    DPIRegistry = {},
}

if shared.RunService:IsStudio() then 
    if shared.UserInputService.TouchEnabled and not shared.UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.MinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.MinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = shared.UserInputService:GetPlatform()
    end)
    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
    Library.MinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
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
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
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
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(720, 600),
        IconSize = UDim2.fromOffset(30, 30),
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
        return UDim.new(Dimension.Scale, Dimension.Offset * Library.DPIScale)
    end

    if ExtraOffset then
        return UDim2.new(
            Dimension.X.Scale,
            (Dimension.X.Offset * Library.DPIScale) + (ExtraOffset[1] * Library.DPIScale),
            Dimension.Y.Scale,
            (Dimension.Y.Offset * Library.DPIScale) + (ExtraOffset[2] * Library.DPIScale)
        )
    end

    return UDim2.new(
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
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)
    return Bindable.Event:Wait()
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
    return Text:match("^%s*(.-)%s*$")
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = shared.Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = shared.Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
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

    Library.KeybindFrame.Size = UDim2.fromOffset(XSize + 18 * Library.DPIScale, 0)
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
    table.insert(Library.Signals, Connection)
    return Connection
end

function Library:GetIcon(IconName: string)
    local Success, Icon = pcall(wax.shared.Icons.GetAsset, IconName)
    return Success and Icon
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
            if k == "Position" or k == "Size" or k:match("Padding") then
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
    local Instance = Instance.new(ClassName)
    Instance.Name = randomstring()

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end

--// Main Instances \\-
local function ParentUI(UI: Instance)
    pcall(ProtectGui, UI);

    if not pcall(function()
            UI.Parent = GetHUi()
        end) then
        UI.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local ScreenGui = New("ScreenGui", {
    DisplayOrder = 1e7,
    ResetOnSpawn = false,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui
ScreenGui.DescendantRemoving:Connect(function(Instance)
    Library:RemoveFromRegistry(Instance)
    Library.DPIRegistry[Instance] = nil
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})

--// Cursor
local Cursor
do
    Cursor = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "White",
        Size = UDim2.fromOffset(9, 1),
        Visible = false,
        ZIndex = 999,
        Parent = ScreenGui,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "Dark",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 998,
        Parent = Cursor,
    })

    local CursorV = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "White",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(1, 9),
        Parent = Cursor,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = "Dark",
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 2, 1, 2),
        ZIndex = 998,
        Parent = CursorV,
    })
end

--// Notification
local NotificationArea
local NotificationList
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        Parent = ScreenGui,
    })
    NotificationList = New("UIListLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 6),
        Parent = NotificationArea,
    })
end

--// Lib Functions //
function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size
    Params.Width = Width or workspace.CurrentCamera.ViewportSize.X - 32

    local Bounds = shared.TextService:GetTextBoundsAsync(Params)
    return Bounds.X, Bounds.Y
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

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
        Size = UDim2.fromScale(1, 0),
        Visible = false,
        Parent = NotificationArea,

        DPIExclude = {
            Size = true,
        },
    })

    local NotifyDirection = Library.NotifySide:lower()
    local IsLeft = NotifyDirection:match("left")
    local IsBottom = NotifyDirection:match("bottom")

    local Background = Library:MakeOutline(FakeBackground, Library.CornerRadius, 5)
    Background.AutomaticSize = Enum.AutomaticSize.Y
    Background.Position = IsLeft and UDim2.new(-1, -6, IsBottom and 1 or 0, -2) or UDim2.new(1, 6, IsBottom and 1 or 0, -2)
    Background.Size = UDim2.fromScale(1, 0)
    Library:UpdateDPI(Background, {
        Position = false,
        Size = false,
    })

    local Holder = New("Frame", {
        BackgroundColor3 = "MainColor",
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.new(1, -4, 1, -4),
        Parent = Background,
    })
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius - 1),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
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
            Title.Size = UDim2.fromOffset(math.ceil(X), Y)
            TitleX = X
        end

        if Desc then
            local X, Y = Library:GetTextBounds(
                Desc.Text,
                Desc.FontFace,
                Desc.TextSize,
                NotificationArea.AbsoluteSize.X - (24 * Library.DPIScale)
            )
            Desc.Size = UDim2.fromOffset(math.ceil(X), Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset((TitleX > DescX and TitleX or DescX) + (24 * Library.DPIScale), 0)
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
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    Data:Resize()

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = typeof(Data.Time) ~= "Instance" or typeof(Data.Steps) == "number",
        Parent = Holder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        New("Sound", {
            SoundId = "rbxassetid://" .. tostring(Data.SoundId):gsub("rbxassetid://", ""),
            Volume = 3,
            PlayOnRemove = true,
            Parent = shared.SoundService,
        }):Destroy()
    end

    Library.Notifications[FakeBackground] = Data

    FakeBackground.Visible = true

    local ShowPosition = IsLeft and UDim2.new(0, -2, IsBottom and 1 or 0, -2) or UDim2.new(1, -2, IsBottom and 1 or 0, -2)
    shared.TweenService:Create(Background, Library.NotifyTweenInfo, {
        Position = ShowPosition,
    }):Play()

    task.delay(Library.NotifyTweenInfo.Time, function()
        if typeof(Data.Time) == "Instance" then
            Data.Time.Destroying:Wait()
        else
            shared.TweenService:Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                Size = UDim2.fromScale(0, 1),
            }):Play()
            task.wait(Data.Time)
        end

        shared.TweenService:Create(Background, Library.NotifyTweenInfo, {
            Position = IsLeft and UDim2.new(-1, -6, IsBottom and 1 or 0, -2) or UDim2.new(1, 6, IsBottom and 1 or 0, -2),
        }):Play()
        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end)

    return Data
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Success, Response = pcall(Func, ...)
    if Success then
        return Response
    end

    local Traceback = debug.traceback():gsub("\n", " ")
    local _, i = Traceback:find(":%d+ ")
    Traceback = Traceback:sub(i + 1):gsub(" :", ":")

    task.defer(error, Response .. " - " .. Traceback)
    if Library.NotifyOnError then
        Library:Notify(Response)
    end
    return
end

function Library:MakeDraggable(UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)
    Library:GiveSignal(shared.UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Position =
                UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end))
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)
    Library:GiveSignal(shared.UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
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
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
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
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder
end

function Library:AddDraggableButton(Text: string, Func)
    local Table = {}

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 10,
        Parent = ScreenGui,

        DPIExclude = {
            Position = true,
        },
    })
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius - 1),
        Parent = Button,
    })
    Library:MakeOutline(Button, Library.CornerRadius, 9)

    Table.Button = Button
    Button.MouseButton1Click:Connect(function()
        Library:SafeCallback(Func, Table)
    end)
    Library:MakeDraggable(Button, Button, true)

    function Table:SetText(NewText: string)
        local X, Y = Library:GetTextBounds(NewText, Library.Scheme.Font, 16)

        Button.Text = NewText
        Button.Size = UDim2.fromOffset(X * Library.DPIScale * 2, Y * Library.DPIScale * 2)
        Library:UpdateDPI(Button, {
            Size = UDim2.fromOffset(X * 2, Y * 2),
        })
    end
    Table:SetText(Text)

    return Table
end

function Library:AddDraggableMenu(Name: string)
    local Background = Library:MakeOutline(ScreenGui, Library.CornerRadius, 10)
    Background.AutomaticSize = Enum.AutomaticSize.Y
    Background.Position = UDim2.fromOffset(6, 6)
    Background.Size = UDim2.fromOffset(0, 0)
    Library:UpdateDPI(Background, {
        Position = false,
        Size = false,
    })

    local Holder = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.new(1, -4, 1, -4),
        Parent = Background,
    })
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius - 1),
        Parent = Holder,
    })
    Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Background, Label, true)
    return Background, Container
end

--// Context Menu //
local CurrentMenu
function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?
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
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
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
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
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

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
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
            Table.Signal:Disconnect()
            Table.Signal = nil
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

Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input: InputObject)
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
})
TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    local X, Y = Library:GetTextBounds(
        TooltipLabel.Text,
        TooltipLabel.FontFace,
        TooltipLabel.TextSize,
        workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 4
    )

    TooltipLabel.Size = UDim2.fromOffset(X + 8 * Library.DPIScale, Y + 4 * Library.DPIScale)
    Library:UpdateDPI(TooltipLabel, {
        Size = UDim2.fromOffset(X, Y),
        DPIOffset = {
            Size = { 8, 4 },
        },
    })
end)

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
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + (Library.ShowCustomCursor and 8 or 14),
                Mouse.Y + (Library.ShowCustomCursor and 8 or 12)
            )

            PreRender:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    table.insert(TooltipTable.Signals, HoverInstance.MouseEnter:Connect(DoHover))
    table.insert(TooltipTable.Signals, HoverInstance.MouseMoved:Connect(DoHover))
    table.insert(
        TooltipTable.Signals,
        HoverInstance.MouseLeave:Connect(function()
            if CurrentHoverInstance ~= HoverInstance then
                return
            end

            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
        end)
    )

    function TooltipTable:Destroy()
        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            Connection:Disconnect()
        end

        if CurrentHoverInstance == HoverInstance then
            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
        end
    end

    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

function Library:Unload()
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)
        Connection:Disconnect()
    end

    for _, Callback in Library.UnloadSignals do
        Library:SafeCallback(Callback)
    end

    Library.Unloaded = true
    ScreenGui:Destroy()
    shared.UiLibrary = nil
end

local CheckIcon = Library:GetIcon("check")
local ArrowIcon = Library:GetIcon("chevron-up")
local ResizeIcon = Library:GetIcon("move-diagonal-2")
local KeyIcon = Library:GetIcon("key")

local BaseAddons = {}
do
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
        }

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle" }
            Info.Mode = "Toggle"
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Size = UDim2.fromOffset(18, 18),
            Text = KeyPicker.Value,
            TextSize = 14,
            Parent = ToggleLabel,
        })

        local KeybindsToggle = {
            Normal = KeyPicker.Mode ~= "Toggle",
        }
        do
            local Holder = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
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
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Checkbox,
            })
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = New("ImageLabel", {
                Image = CheckIcon and CheckIcon.Url or "",
                ImageColor3 = "FontColor",
                ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
                ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })

            function KeybindsToggle:Display(State)
                Label.TextTransparency = State and 0 or 0.5
                CheckImage.ImageTransparency = State and 0 or 1
            end

            function KeybindsToggle:SetText(Text)
                local X = Library:GetTextBounds(Text, Label.FontFace, Label.TextSize)
                Label.Text = Text
                Label.Size = UDim2.new(0, X, 1, 0)
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                Holder.Active = not Normal
                Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22 * Library.DPIScale, 0)
                Checkbox.Visible = not Normal
            end

            function KeyPicker:DoClick()
                if ParentObj.Type == "Toggle" and KeyPicker.SyncToggleState then
                    ParentObj:SetValue(KeyPicker.Toggled)
                end

                Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
                Library:SafeCallback(KeyPicker.Changed, KeyPicker.Toggled)
            end

            Holder.MouseButton1Click:Connect(function()
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
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
        end, 1)
        KeyPicker.Menu = MenuTable

        local ModeButtons = {}
        for _, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
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

            Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end)

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        function KeyPicker:Display()
            if Library.Unloaded then 
                return 
            end

            local X, Y =
                Library:GetTextBounds(KeyPicker.Value, Picker.FontFace, Picker.TextSize, ToggleLabel.AbsoluteSize.X)
            Picker.Text = KeyPicker.Value
            Picker.Size = UDim2.fromOffset(X + 9 * Library.DPIScale, Y + 4 * Library.DPIScale)
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

                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.Value, KeyPicker.Text, GetTranslation(Translations, KeyPicker.Mode)))
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

                if Key == GetTranslation(Translations, "MB1") or Key == GetTranslation(Translations, "MB2") then
                    return Key == GetTranslation(Translations, "MB1") and shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        or Key == GetTranslation(Translations, "MB2") and shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                end

                return shared.UserInputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value])
                    and not shared.UserInputService:GetFocusedTextBox()
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

        local Picking = false
        Picker.MouseButton1Click:Connect(function()
            if Picking then
                return
            end

            Picking = true

            Picker.Text = "..."
            Picker.Size = UDim2.fromOffset(29 * Library.DPIScale, 18 * Library.DPIScale)

            local Input = shared.UserInputService.InputBegan:Wait()
            local Key = GetTranslation(Translations, "Unknown")

            if Input.UserInputType == Enum.UserInputType.Keyboard then
                Key = Input.KeyCode == Enum.KeyCode.Escape and GetTranslation(Translations, "None") or Input.KeyCode.Name
            elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Key = GetTranslation(Translations, "MB1")
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                Key = GetTranslation(Translations, "MB2")
            end

            KeyPicker.Value = Key
            KeyPicker:Update()

            Library:SafeCallback(
                KeyPicker.ChangedCallback,
                Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
            )
            Library:SafeCallback(
                KeyPicker.Changed,
                Input.KeyCode == Enum.KeyCode.Unknown and Input.UserInputType or Input.KeyCode
            )

            PreRender:Wait()
            Picking = false
        end)
        Picker.MouseButton2Click:Connect(MenuTable.Toggle)

        Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input: InputObject)
            if
                KeyPicker.Mode == "Always"
                or KeyPicker.Value == GetTranslation(Translations, "Unknown")
                or KeyPicker.Value == GetTranslation(Translations, "None")
                or Picking
                or shared.UserInputService:GetFocusedTextBox()
            then
                return
            end

            if KeyPicker.Mode == "Toggle" then
                local Key = KeyPicker.Value

                if Key == GetTranslation(Translations, "MB1") or Key == GetTranslation(Translations, "MB2") then
                    if
                        Key == GetTranslation(Translations, "MB1") and shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        or Key == GetTranslation(Translations, "MB2") and shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
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

        Library:GiveSignal(shared.UserInputService.InputEnded:Connect(function()
            if
                KeyPicker.Value == GetTranslation(Translations, "Unknown")
                or KeyPicker.Value == GetTranslation(Translations, "None")
                or Picking
                or shared.UserInputService:GetFocusedTextBox()
            then
                return
            end

            KeyPicker:Update()
        end))

        KeyPicker:Update()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        Options[Idx] = KeyPicker

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
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
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
            BorderSizePixel = 1,
            Size = UDim2.fromOffset(18, 18),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderTransparency = New("ImageLabel", {
            Image = "rbxassetid://139785960036434",
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Size = UDim2.fromScale(1, 1),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        --// Color Menu //
        local ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(Info.Transparency and 256 or 234, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1
        )
        ColorMenu.List.Padding = UDim.new(0, 8)
        ColorPicker.ColorMenu = ColorMenu

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ColorMenu.Menu,
        })

        if typeof(Info.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = Info.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ColorMenu.Menu,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 200),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        --// Sat Map
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = "rbxassetid://4155801252",
            Size = UDim2.fromOffset(200, 200),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "White",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "Dark",
            Parent = SatVibCursor,
        })

        --// Hue
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(16, 200),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "White",
            BorderColor3 = "Dark",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        --// Alpha
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = "rbxassetid://139785960036434",
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(16, 200),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
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
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "White",
                BorderColor3 = "Dark",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        --// Functions //
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then 
                return 
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            Holder.BackgroundColor3 = ColorPicker.Value
            Holder.BorderColor3 = Library:GetDarkerColor(ColorPicker.Value)
            HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
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
            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

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
        local ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
        end, 1)
        ColorPicker.ContextMenu = ContextMenu
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                Button.MouseButton1Click:Connect(function()
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

            if SetClipboard then
                CreateButton(GetTranslation(Translations, "Copy Hex"), function()
                    SetClipboard(tostring(ColorPicker.Value:ToHex()))
                end)
                CreateButton(GetTranslation(Translations, "Copy RGB"), function()
                    SetClipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        --// End //
        Holder.MouseButton1Click:Connect(ColorMenu.Toggle)
        Holder.MouseButton2Click:Connect(ContextMenu.Toggle)

        SatVipMap.MouseButton1Down:Connect(function()
            while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                local MinX = SatVipMap.AbsolutePosition.X
                local MaxX = MinX + SatVipMap.AbsoluteSize.X
                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                local MinY = SatVipMap.AbsolutePosition.Y
                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                local OldSat = ColorPicker.Sat
                local OldVib = ColorPicker.Vib
                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                    ColorPicker:Update()
                end

                PreRender:Wait()
            end
        end)
        HueSelector.MouseButton1Down:Connect(function()
            while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                local Min = HueSelector.AbsolutePosition.Y
                local Max = Min + HueSelector.AbsoluteSize.Y
                local Location = math.clamp(Mouse.Y, Min, Max)

                local OldHue = ColorPicker.Hue
                ColorPicker.Hue = (Location - Min) / (Max - Min)

                if ColorPicker.Hue ~= OldHue then
                    ColorPicker:Update()
                end

                PreRender:Wait()
            end
        end)
        if TransparencySelector then
            TransparencySelector.MouseButton1Down:Connect(function()
                while
                    shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch)
                do
                    local Min = TransparencySelector.AbsolutePosition.Y
                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldTransparency = ColorPicker.Transparency
                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

                    if ColorPicker.Transparency ~= OldTransparency then
                        ColorPicker:Update()
                    end

                    PreRender:Wait()
                end
            end)
        end

        HueBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
            if Success and typeof(Color) == "Color3" then
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            ColorPicker:Update()
        end)
        RgbBox.FocusLost:Connect(function(Enter)
            if not Enter then
                return
            end

            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if R and G and B then
                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
            end

            ColorPicker:Update()
        end)

        ColorPicker:Display()

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, ColorPicker)
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
    local Funcs = {}

    function Funcs:AddDivider()
        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Size = UDim2.new(1, 0, 0, 2),
            Parent = Container,
        })

        Groupbox:Resize()

        table.insert(Groupbox.Elements, {
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
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Groupbox.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
            Parent = Container,
        })

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
                TextLabel.Size = UDim2.new(1, 0, 0, Y + 4 * Library.DPIScale)
            end

            Groupbox:Resize()
        end

        if Label.DoesWrap then
            local _, Y =
                Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4 * Library.DPIScale)
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        if Data.DoesWrap then
            local Last = TextLabel.AbsoluteSize

            TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                local _, Y =
                    Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X)
                TextLabel.Size = UDim2.new(1, 0, 0, Y + 4 * Library.DPIScale)

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
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
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
            Size = UDim2.new(1, 0, 0, 21),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 9),
            Parent = Holder,
        })

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                Size = UDim2.fromScale(1, 1),
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
            Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = shared.TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()
            end)
            Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = shared.TweenService:Create(Button.Base, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()
            end)

            Button.Base.MouseButton1Click:Connect(function()
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

                    PreRender:Wait() --// Mouse Button fires without waiting (i hate roblox)
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
                table.insert(Buttons, SubButton)
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
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            Buttons[Info.Idx] = Button
        else
            table.insert(Buttons, Button)
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
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Checkbox,
        })

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = New("ImageLabel", {
            Image = CheckIcon and CheckIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = CheckIcon and CheckIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
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

            shared.TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            shared.TweenService:Create(CheckImage, Library.TweenInfo, {
                ImageTransparency = Toggle.Value and 0 or 1,
            }):Play()

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
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

        Button.MouseButton1Click:Connect(function()
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
        table.insert(Groupbox.Elements, Toggle)

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
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(32, 18),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
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
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            shared.TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            shared.TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:SetValue(Value)
            if Toggle.Disabled then
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

        Button.MouseButton1Click:Connect(function()
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
        table.insert(Groupbox.Elements, Toggle)

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
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
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
                Text = Text:sub(1, Info.MaxLength)
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
            Box.FocusLost:Connect(function(Enter)
                if not Enter then
                    return
                end

                Input:SetValue(Box.Text)
            end)
        else
            Box:GetPropertyChangedSignal("Text"):Connect(function()
                Input:SetValue(Box.Text)
            end)
        end

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        table.insert(Groupbox.Elements, Input)

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
            Size = UDim2.new(1, 0, 0, Info.Compact and 13 or 31),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 13),
            Text = "",
            Parent = Holder,
        })

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
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
            Size = UDim2.fromScale(0.5, 1),
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
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        local function Round(Value)
            if Info.Rounding == 0 then
                return math.floor(Value)
            end

            return tonumber(string.format("%." .. Info.Rounding .. "f", Value))
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, GetTranslation(Translations, "Max value cannot be less than the current min value."))

            Slider.Value = math.clamp(Slider.Value, Slider.Min, Value)
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, GetTranslation(Translations, "Min value cannot be greater than the current max value."))

            Slider.Value = math.clamp(Slider.Value, Value, Slider.Max)
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

            Num = math.clamp(Num, Slider.Min, Slider.Max)

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

        Bar.MouseButton1Down:Connect(function()
            if Slider.Disabled then
                return
            end

            for _, Side in Library.ActiveTab.Sides do
                Side.ScrollingEnabled = false
            end

            while shared.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                local Location = Mouse.X
                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                local OldValue = Slider.Value
                Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale))

                Slider:Display()
                if Slider.Value ~= OldValue then
                    Library:SafeCallback(Slider.Callback, Slider.Value)
                    Library:SafeCallback(Slider.Changed, Slider.Value)
                end

                PreRender:Wait()
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
        table.insert(Groupbox.Elements, Slider)

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
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            Parent = Holder,
        })

        local Display = New("TextButton", {
            Active = not Dropdown.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = Display,
        })

        local ArrowImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            Image = ArrowIcon and ArrowIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = ArrowIcon and ArrowIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ArrowIcon and ArrowIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = Display,
        })

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = GetTranslation(Translations, "Search..."),
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = Display,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })
        end

        local MenuTable = Library:AddContextMenu(
            Display,
            function()
                return UDim2.fromOffset(Display.AbsoluteSize.X, 0)
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
            local Y = math.clamp(
                (Count or GetTableSize(Dropdown.Values)) * (21 * Library.DPIScale),
                0,
                Info.MaxVisibleDropdownItems * (21 * Library.DPIScale)
            )

            MenuTable:SetSize(function()
                return UDim2.fromOffset(Display.AbsoluteSize.X, Y)
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

                Str = Str:sub(1, #Str - 2)
            else
                Str = Dropdown.Value and tostring(Dropdown.Value) or ""
                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            if #Str > 25 then
                Str = Str:sub(1, 22) .. "..."
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
                    table.insert(Table, Value)
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
                Button:Destroy()
            end
            table.clear(Buttons)

            local Count = 0
            for _, Value in Values do
                if SearchBox and not tostring(Value):lower():match(SearchBox.Text:lower()) then
                    continue
                end

                Count += 1
                local IsDisabled = table.find(DisabledValues, Value)
                local Table = {}

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = IsDisabled and 1 or 0,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = tostring(Value),
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = MenuTable.Menu,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
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
                    Button.MouseButton1Click:Connect(function()
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
                    if Active and table.find(Dropdown.Values, Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if table.find(Dropdown.Values, Value) then
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
                    table.insert(Dropdown.Values, val)
                end
            elseif typeof(Values) == "string" then
                table.insert(Dropdown.Values, Values)
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
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
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
            Holder.Size = UDim2.new(1, 0, 0, (Text and 39 or 21) * Library.DPIScale)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
        end

        Display.MouseButton1Click:Connect(function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end)

        if SearchBox then
            SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList)
        end

        local Defaults = {}
        if typeof(Info.Default) == "string" then
            local Index = table.find(Dropdown.Values, Info.Default)
            if Index then
                table.insert(Defaults, Index)
            end
        elseif typeof(Info.Default) == "table" then
            for _, Value in Info.Default do
                local Index = table.find(Dropdown.Values, Value)
                if Index then
                    table.insert(Defaults, Index)
                end
            end
        elseif Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
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
        table.insert(Groupbox.Elements, Dropdown)

        Options[Idx] = Dropdown

        return Dropdown
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

function Library:SetFont(FontFace: Font | EnumItem)
    if typeof(FontFace) == "EnumItem" then
        FontFace = Font.new(FontFace.Name)
    end

    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()
end

function Library:SetNotifySide(Side: string)
    Library.NotifySide = Side

    if Side:lower() == "topleft" then
        NotificationArea.AnchorPoint = Vector2.new(0, 0)
        NotificationArea.Position = UDim2.fromOffset(6, 6)
        NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        NotificationList.VerticalAlignment = Enum.VerticalAlignment.Top
    elseif Side:lower() == "topright" then
        NotificationArea.AnchorPoint = Vector2.new(1, 0)
        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
        NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        NotificationList.VerticalAlignment = Enum.VerticalAlignment.Top
    elseif Side:lower() == "bottomleft" then
        NotificationArea.AnchorPoint = Vector2.new(0, 1)
        NotificationArea.Position = UDim2.new(0, 6, 1, -6)
        NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        NotificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    elseif Side:lower() == "bottomright" then
        NotificationArea.AnchorPoint = Vector2.new(1, 1)
        NotificationArea.Position = UDim2.new(1, -6, 1, -6)
        NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        NotificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    ScreenGui.OnTopOfCoreBlur = WindowInfo.AlwaysOnTop == true

    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if shared.RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.MinSize = Vector2.new(math.min(Library.MinSize.X, MaxX), math.min(Library.MinSize.Y, MaxY))
    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.new(WindowInfo.Font.Name)
    end

    Library.CornerRadius = WindowInfo.CornerRadius
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.ShowCustomCursor = WindowInfo.ShowCustomCursor
    Library.Scheme.Font = WindowInfo.Font
    Library.ToggleKeybind = WindowInfo.ToggleKeybind

    local MainFrame
    local SearchBox
    local ResizeButton
    local Tabs
    local Container
    do
        Library.KeybindFrame, Library.KeybindContainer = Library:AddDraggableMenu(GetTranslation(Translations, "Keybinds"))
        Library.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        Library.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        Library.KeybindFrame.Visible = false
        Library:UpdateDPI(Library.KeybindFrame, {
            Position = false,
            Size = false,
        })

        MainFrame = New("Frame", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,

            DPIExclude = {
                Position = true,
            },
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
            Parent = MainFrame,
        })
        do
            local Lines = {
                {
                    Position = UDim2.fromOffset(0, 48),
                    Size = UDim2.new(1, 0, 0, 1),
                },
                {
                    Position = UDim2.fromScale(0.3, 0),
                    Size = UDim2.new(0, 1, 1, -21),
                },
                {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, -20),
                    Size = UDim2.new(1, 0, 0, 1),
                },
            }
            for _, Info in Lines do
                Library:MakeLine(MainFrame, Info)
            end
            Library:MakeOutline(MainFrame, WindowInfo.CornerRadius, 0)
        end

        if WindowInfo.Center then
            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        --// Top Bar \\-
        local TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true)

        --// Title
        local TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.3, 1),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
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
            Size = UDim2.new(0, X, 1, 0),
            Text = WindowInfo.Title,
            TextSize = 20,
            Parent = TitleHolder,
        })

        --// Search Box
        SearchBox = New("TextBox", {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = "MainColor",
            PlaceholderText = GetTranslation(Translations, "Search"),
            Position = UDim2.new(0.3, 8, 0.5, 0),
            Size = UDim2.new(0.7, -57, 1, -16),
            TextScaled = true,
            Parent = TopBar,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = SearchBox,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
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
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
        end

        local MoveIcon = Library:GetIcon("move")
        if MoveIcon then
            New("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Image = MoveIcon.Url,
                ImageColor3 = "OutlineColor",
                ImageRectOffset = MoveIcon.ImageRectOffset,
                ImageRectSize = MoveIcon.ImageRectSize,
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(28, 28),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = TopBar,
            })
        end

        --// Bottom Bar //
        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
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
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
            Parent = BottomBar,
        })

        --// Footer
        New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        --// Resize Button
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.fromScale(1, 1),
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
            ImageRectOffset = ResizeIcon and ResizeIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = ResizeIcon and ResizeIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = ResizeButton,
        })

        --// Tabs //
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarThickness = 0,
            Size = UDim2.new(0.3, 0, 1, -70),
            Parent = MainFrame,
        })

        New("UIListLayout", {
            Parent = Tabs,
        })

        --// Container //
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(0.7, -1, 1, -70),
            Parent = MainFrame,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 0),
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
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })

            New("UIPadding", {
                PaddingBottom = UDim.new(0, 11),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
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
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            --// Tab Container //
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            TabLeft = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
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

                TabLeft.Size = UDim2.new(0, math.floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, 0)
                Library:UpdateDPI(TabLeft, { Size = TabLeft.Size })
            end

            TabRight = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarThickness = 0,
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
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

                TabRight.Size = UDim2.new(0, math.floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, 0)
                Library:UpdateDPI(TabRight, { Size = TabRight.Size })
            end

            WarningBox = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(127, 0, 0),
                BorderColor3 = Color3.fromRGB(255, 50, 50),
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 1,
                Position = UDim2.fromOffset(0, 6),
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBox,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBox,
            })
            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.fromScale(1, 0),
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

                WarningText.Size = UDim2.new(1, 0, 0, Y)
                WarningText.Text = Info.Text
                Library:UpdateDPI(WarningText, { Size = WarningText.Size })
                Tab:Resize()
            end

            WarningBox.BackgroundColor3 = Info.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
            WarningBox.BorderColor3 = Info.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
            WarningTitle.TextColor3 = Info.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
            WarningStroke.Color = Info.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)

            if not Library.Registry[WarningBox] then Library:AddToRegistry(WarningBox, {}) end
            if not Library.Registry[WarningTitle] then Library:AddToRegistry(WarningTitle, {}) end
            if not Library.Registry[WarningStroke] then Library:AddToRegistry(WarningStroke, {}) end

            Library.Registry[WarningBox].BackgroundColor3 = function()
                return Info.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
            end

            Library.Registry[WarningBox].BorderColor3 = function()
                return Info.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningTitle].TextColor3 = function()
                return Info.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
            end

            Library.Registry[WarningStroke].Color = function()
                return Info.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
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

                WarningText.Size = UDim2.new(1, 0, 0, Y)
                Library:UpdateDPI(WarningText, { Size = WarningText.Size })
            end

            local Offset = WarningBox.Visible and WarningBox.AbsoluteSize.Y + 6 or 0
            for _, Side in Tab.Sides do
                Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
                Side.Size = UDim2.new(0, math.floor(TabContainer.AbsoluteSize.X / 2) - 3, 1, -Offset)
                Library:UpdateDPI(Side, {
                    Position = Side.Position,
                    Size = Side.Size,
                })
            end
        end

        function Tab:AddGroupbox(Info)
            local Background = Library:MakeOutline(Info.Side == 1 and TabLeft or TabRight, WindowInfo.CornerRadius)
            Background.Size = UDim2.fromScale(1, 0)
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
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Parent = Background,
                })
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
                    Parent = GroupboxHolder,
                })
                Library:MakeLine(GroupboxHolder, {
                    Position = UDim2.fromOffset(0, 34),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                GroupboxLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Text = Info.Name,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    Parent = GroupboxLabel,
                })

                GroupboxContainer = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox = {
                Holder = Background,
                Container = GroupboxContainer,
                Elements = {},
            }

            function Groupbox:Resize()
                Background.Size = UDim2.new(1, 0, 0, GroupboxList.AbsoluteContentSize.Y + 53 * Library.DPIScale)
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
            Background.Size = UDim2.fromScale(1, 0)
            Library:UpdateDPI(Background, {
                Size = false,
            })

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Parent = Background,
                })
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius - 1),
                    Parent = TabboxHolder,
                })

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
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
                    Size = UDim2.fromOffset(0, 34),
                    Text = Name,
                    TextSize = 15,
                    TextTransparency = 0.5,
                    Parent = TabboxButtons,
                })

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 35),
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
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
                    Background.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 53 * Library.DPIScale)
                end

                --// Execution //
                if not Tabbox.ActiveTab then
                    Tab:Show()
                end

                Button.MouseButton1Click:Connect(Tab.Show)

                setmetatable(Tab, BaseGroupbox)

                Tabbox.Tabs[Name] = Tab

                return Tab
            end

            if Info.Name then
                Tab.Tabboxes[Info.Name] = Tabbox
            else
                table.insert(Tab.Tabboxes, Tabbox)
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

            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            shared.TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()
            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end
            TabContainer.Visible = true

            Library.ActiveTab = Tab
        end

        function Tab:Hide()
            shared.TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()
            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end
            TabContainer.Visible = false

            Library.ActiveTab = nil
        end

        --// Execution //
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

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
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                Parent = Tabs,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 11),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 11),
                Parent = TabButton,
            })

            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
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
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Parent = TabButton,
                })
            end

            --// Tab Container //
            TabContainer = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarThickness = 0,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })
            New("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = TabContainer,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
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
                Size = UDim2.new(0.75, 0, 0, 21),
                Parent = TabContainer,
            })

            local Box = New("TextBox", {
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                PlaceholderText = GetTranslation(Translations, "Key"),
                Size = UDim2.new(1, -71, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Box,
            })

            local Button = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 63, 1, 0),
                Text = GetTranslation(Translations, "Execute"),
                TextSize = 14,
                Parent = Holder,
            })

            Button.MouseButton1Click:Connect(function()
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

            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            shared.TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()
            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end
            TabContainer.Visible = true

            Library.ActiveTab = Tab
        end

        function Tab:Hide()
            shared.TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()
            shared.TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()
            if TabIcon then
                shared.TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end
            TabContainer.Visible = false

            Library.ActiveTab = nil
        end

        --// Execution //
        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Tab.Container = TabContainer
        setmetatable(Tab, BaseGroupbox)

        Library.Tabs[Name] = Tab

        return Tab
    end

    function Library:Toggle(Value: boolean?)
        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        MainFrame.Visible = Library.Toggled
        ModalElement.Modal = Library.Toggled

        if Library.Toggled and not Library.IsMobile then
            local OldMouseIconEnabled = shared.UserInputService.MouseIconEnabled

            shared.RunService:UnbindFromRenderStep("ShowCursor")
            shared.RunService:BindToRenderStep("ShowCursor", Enum.RenderPriority.Last.Value, function()
                shared.UserInputService.MouseIconEnabled = not Library.ShowCustomCursor

                Cursor.Position = UDim2.fromOffset(Mouse.X, Mouse.Y)
                Cursor.Visible = Library.ShowCustomCursor

                if not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                    shared.UserInputService.MouseIconEnabled = OldMouseIconEnabled
                    Cursor.Visible = false
                    shared.RunService:UnbindFromRenderStep("ShowCursor")
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
        task.spawn(Library.Toggle)
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
            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)
            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)

            LockButton.Button.Position = UDim2.new(1, -6, 0, 46)
            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
        else
            LockButton.Button.Position = UDim2.fromOffset(6, 46)
        end
    end

    --// Execution //
    local LastTab
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
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
        local Search = SearchBox.Text:lower()
        if Trim(Search) == "" or Library.ActiveTab.IsKeyTab then
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
                    if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                        Visible = true
                    else
                        ElementInfo.Base.Visible = false
                    end
                    if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
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
                if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
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
                        if ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
                            Visible = true
                        else
                            ElementInfo.Base.Visible = false
                        end
                        if ElementInfo.SubButton.Text:lower():match(Search) and ElementInfo.SubButton.Visible then
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
                    if ElementInfo.Text and ElementInfo.Text:lower():match(Search) and ElementInfo.Visible then
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

    Library:GiveSignal(shared.UserInputService.InputBegan:Connect(function(Input: InputObject)
        if shared.UserInputService:GetFocusedTextBox() then
            return
        end

        if (
            typeof(Library.ToggleKeybind) == "table"
            and Library.ToggleKeybind.Type == "KeyPicker"
            and Input.KeyCode.Name == Library.ToggleKeybind.Value
        )
        or Input.KeyCode == Library.ToggleKeybind
        then
            Library.Toggle()
        end
    end))

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

Library:GiveSignal(shared.Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(shared.Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(shared.Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(shared.Teams.ChildRemoved:Connect(OnTeamChange))

return Library


end)() end,
    [53] = function()
local wax, _, _ = __waximport(53)

return (function()

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

end)() end,
    [54] = function()
local wax, _, _ = __waximport(54)

return (function()

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
            Default = "Code",
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

        self:LoadDefault()

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

end)() end,
    [55] = function()
local wax, _, require = __waximport(55)

return (function()

local table_insert, table_find, task_spawn, string_format, tostring, tonumber, select, pcall
    = table.insert, table.find, task.spawn, string.format, tostring, tonumber, select, pcall

local UiManager = {}

local ExecutorSupport = wax.shared.ExecutorSupport
local FileHelper      = wax.shared.FileHelper
local Translations    = wax.shared.Translations
local EasingLibrary   = wax.shared.EasingLibrary

local WriteFile       = FileHelper.WriteFile
local GetTranslation  = Translations.GetTranslation
local FromTranslation = Translations.FromTranslation

local WindowStyle   = FileHelper:CheckFile("MFeee-New/WindowStyle.txt"  , "Obsidian" , {"Obsidian", "Linoria"})
local NotifySound   = FileHelper:CheckFile("MFeee-New/NotifySound.txt"  , WindowStyle, {"Obsidian", "Linoria"})
local NotifySide    = FileHelper:CheckFile("MFeee-New/NotifySide.txt"   , "TopRight" , {"TopLeft" , "TopRight", "BottomLeft", "BottomRight"})
local ForceCheckbox = FileHelper:CheckFile("MFeee-New/ForceCheckbox.txt", "false", {"false", "true"}) == "true"
local CustomCursor  = FileHelper:CheckFile("MFeee-New/CustomCursor.txt" , "false", {"false", "true"}) == "true"
local KeybindFrame  = FileHelper:CheckFile("MFeee-New/KeybindFrame.txt" , "false", {"false", "true"}) == "true"
local AlwaysOnTop   = FileHelper:CheckFile("MFeee-New/AlwaysOnTop.txt"  , "false", {"false", "true"}) == "true"
local UiCorner      = FileHelper:CheckFile("MFeee-New/UICorner.txt", 5, 5)
local DPIScale      = FileHelper:CheckFile("MFeee-New/DPIScale.txt", 1, 1)
local Clicked       = FileHelper:CheckFile("MFeee-New/Clicked.txt" , 0, 0)

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

    local Library = UiManager.Library
    local Notify  = Library.Notify

    function UiManager:Notify(...)
        Notify(Library, ...)

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
        return nil
    end)()
end

function UiManager:CreateMainTab()
    local UniversalMISC = require("../Universal/MISC")

    --// Main Tab //
    self.MainTab = self.Window:AddTab(GetTranslation(Translations, "Main"), "home")

    --// General Groupbox (Left)
    self.MainTabGeneralGroup = self.MainTab:AddLeftGroupbox(GetTranslation(Translations, "General"))

    self.MainTabGeneralGroup:AddToggle("AntiAFK", {
        Text = GetTranslation(Translations, "Anti AFK"),
        Disabled = not ExecutorSupport.getconnections,
        Default = false
    })

    self.MainTabGeneralGroup:AddToggle("AntiKick", {
        Text = GetTranslation(Translations, "Anti Kick (Client)"),
        Disabled = not (ExecutorSupport.hookfunction and ExecutorSupport.hookmetamethod),
        Default  = false
    })

    --// General Groupbox OnChanged
    self.Toggles.AntiAFK:OnChanged(UniversalMISC.AntiAFK.Start)

    self.Toggles.AntiKick:OnChanged(UniversalMISC.AntiKick.Start)

    --// Other Groupbox (Right)
    self.MainTabOtherGroup = self.MainTab:AddRightGroupbox(GetTranslation(Translations, "Other"))

    do
        self.ClickTimesLabel = self.MainTabOtherGroup:AddLabel(string_format(GetTranslation(Translations, "You clicked %d times"), Clicked))

        local SetText = self.ClickTimesLabel.SetText
        local ClickMultiplier = 1

        self.MainTabOtherGroup:AddButton(GetTranslation(Translations, "Click Me!"), function()
            Clicked += ClickMultiplier
            SetText(self.ClickTimesLabel, string_format(GetTranslation(Translations, "You clicked %d times"), Clicked))
            WriteFile(FileHelper, "MFeee-New/Clicked.txt", tostring(Clicked))
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
                self:Notify(string_format(GetTranslation(Translations, "You lost %d clicks"), Clicked))
                Clicked = 0
                SetText(self.ClickTimesLabel, string_format(GetTranslation(Translations, "You clicked %d times"), Clicked))
                WriteFile(FileHelper, "MFeee-New/Clicked.txt", tostring(Clicked))
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
            Text    = GetTranslation(Translations, "Easing Mode"),
            Values  = EasingModes,
            Default = "Quartic"
        })

        self.MainTabOtherGroup:AddDropdown("EasingDirection", {
            Text = GetTranslation(Translations, "Easing Direction"),
            Values = {
                "In",
                "Out",
                "InOut"
            },
            Default = "Out"
        })

        self.MainTabOtherGroup:AddSlider("EasingDuration", {
            Text = GetTranslation(Translations, "Easing Duration"),
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
    self.PlayerTab = self.Window:AddTab(GetTranslation(Translations, "Player"), "user")

    --// Left Tab Box
    self.PlayerLeftTabBox = self.PlayerTab:AddLeftTabbox()

    --// Player Overrides Tab
    self.PlayerLeftTabBoxOverridesTab = self.PlayerLeftTabBox:AddTab(GetTranslation(Translations, "Overrides"))

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
            Text = GetTranslation(Translations, "WalkSpeed Override"),
            Default = false
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
            Text = GetTranslation(Translations, "JumpHeight Override"),
            Default = false
        })

        self.PlayerLeftTabBoxOverridesTab:AddSlider("JumpHeight", {
            Text = GetTranslation(Translations, "JumpHeight"),
            Default = TempJumpHeight,
            Min = 0,
            Max = 100,
            Suffix = TempJumpHeight > 1 and "studs" or "stud",
            Compact = true,
            HideMax = true
        })
    end

    self.PlayerLeftTabBoxOverridesTab:AddToggle("GravityOverride", {
        Text = GetTranslation(Translations, "Gravity Override"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("Gravity", {
        Text = GetTranslation(Translations, "Gravity"),
        Default = shared.Workspace.Gravity,
        Min = 0,
        Max = 1000,
        Suffix = shared.Workspace.Gravity > 1 and "studs/s²" or "stud/s²",
        Compact = true,
        HideMax = true
    })

    self.PlayerLeftTabBoxOverridesTab:AddDivider()

    self.PlayerLeftTabBoxOverridesTab:AddToggle("NoAcceleration", {
        Text = GetTranslation(Translations, "No Acceleration"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("AntiRobloxVoid", {
        Text = GetTranslation(Translations, "Anti Roblox Void"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddToggle("SpeedBoost", {
        Text = GetTranslation(Translations, "Speed Boost"),
        Default = false
    })

    self.PlayerLeftTabBoxOverridesTab:AddSlider("BoostSpeed", {
        Text = GetTranslation(Translations, "Boost Speed"),
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
        Text = GetTranslation(Translations, "Noclip"),
        Default = false
    })
    :AddKeyPicker("NoclipKeybind", {
        Text = GetTranslation(Translations, "Noclip"),
        Default = "N",
        Mode = "Toggle",
        SyncToggleState = true
    })

    self.PlayerLeftTabBoxOverridesTab
    :AddToggle("VehicleNoclip", {
        Text = GetTranslation(Translations, "Vehicle Noclip"),
        Default = false
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
    self.MiscTab = self.Window:AddTab(GetTranslation(Translations, "Misc"), "boxes")

    --// Roblox Groupbox (Left)
    self.MiscTabRobloxGroup = self.MiscTab:AddLeftGroupbox("Roblox")

    do
        local Toggles = {}

        Toggles.EnableReset = self.MiscTabRobloxGroup:AddToggle("EnableReset", {
            Text = GetTranslation(Translations, "Enable Reset"),
            Default = shared.StarterGui:GetCore("ResetButtonCallback")
        })

        Toggles.EnablePlayerList = self.MiscTabRobloxGroup:AddToggle("EnablePlayerList", {
            Text = GetTranslation(Translations, "Enable Player List"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)
        })

        Toggles.EnableHealth = self.MiscTabRobloxGroup:AddToggle("EnableHealth", {
            Text = GetTranslation(Translations, "Enable Health Bar"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
        })

        Toggles.EnableBackpack = self.MiscTabRobloxGroup:AddToggle("EnableBackpack", {
            Text = GetTranslation(Translations, "Enable Backpack"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
        })

        Toggles.EnableChat = self.MiscTabRobloxGroup:AddToggle("EnableChat", {
            Text = GetTranslation(Translations, "Enable Chat"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat)
        })

        Toggles.EnableEmotesMenu = self.MiscTabRobloxGroup:AddToggle("EnableEmotesMenu", {
            Text = GetTranslation(Translations, "Enable Emotes Menu"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
        })

        Toggles.EnableSelfView = self.MiscTabRobloxGroup:AddToggle("EnableSelfView", {
            Text = GetTranslation(Translations, "Enable Self View"),
            Tooltip = GetTranslation(Translations, "Avatar \"selfie\" (with facial capture enabled)"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView)
        })

        Toggles.EnableCapture = self.MiscTabRobloxGroup:AddToggle("EnableCapture", {
            Text = GetTranslation(Translations, "Enable Capture Button"),
            Default = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Captures)
        })

        self.MiscTabRobloxGroup:AddDivider()

        self.MiscTabRobloxGroup:AddToggle("DevConsole", {
            Text = GetTranslation(Translations, "Dev Console"),
            Default = shared.StarterGui:GetCore("DevConsoleVisible")
        })

        Toggles.AvatarContextMenu = self.MiscTabRobloxGroup:AddToggle("AvatarContextMenu", {
            Text = GetTranslation(Translations, "Avatar Context Menu"),
            Tooltip = GetTranslation(Translations, "Left-clicking on a player's avatar will pop up a context menu, and stop you from moving\n(which players who enjoy Natural Disaster Survival should be very familiar with)"),
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
    wax.shared.DecompilerGroup = self.MiscTab:AddRightGroupbox(GetTranslation(Translations, "Decompiler"))
    self.DecompilerGroup = wax.shared.DecompilerGroup

    local StatusText = GetTranslation(Translations, "Status")
    self.DecompilerInfo = self.DecompilerGroup:AddLabel({
        Text     = `{StatusText}: {GetTranslation(Translations, "Idle")}`,
        DoesWrap = true
    })

    self.DecompilerGroup:AddToggle("ToggleDecompilation", {
        Text    = GetTranslation(Translations, "Decompile"),
        Default = Decompiler.Running
    })

    self.DecompilerGroup:AddToggle("ToggleDecompilationState", {
        Text    = GetTranslation(Translations, "Pause"),
        Default = Decompiler.Paused
    })

    self.DecompilerGroup:AddDivider()

    self.DecompilerGroup:AddToggle("DecompilerOverwrite", {
        Text = GetTranslation(Translations, "Overwrite"),
        Tooltip = GetTranslation(Translations, "Overwrite existing files"),
        Default = Decompiler.Overwrite
    })

    self.DecompilerGroup:AddToggle("DecompilerDebugMode", {
        Text = GetTranslation(Translations, "Debug Mode"),
        Tooltip = GetTranslation(Translations, "Print a bunch of logs"),
        Default = Decompiler.DebugMode
    })

    self.DecompilerGroup:AddDropdown("DecompileClasses", {
        Text = GetTranslation(Translations, "Classes"),
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
        Text = GetTranslation(Translations, "Extension"),
        Default = Decompiler.Extension,
        EmptyReset = ".luau",
        Placeholder = ".luau",
        ClearTextOnFocus = false
    })

    self.DecompilerGroup:AddInput("DecompilerSaveFolder", {
        Text = GetTranslation(Translations, "Save Folder"),
        Default = Decompiler.SaveFolder,
        EmptyReset = "MFeee-New/Decompiled Scripts",
        Placeholder = "MFeee-New/Decompiled Scripts",
        ClearTextOnFocus = false
    })

    --// Decompiler Groupbox OnChanged
    self.Toggles.ToggleDecompilation:OnChanged(function(Enabled)
        local self = Decompiler

        local Message, Success = self:ToggleDecompilation(Enabled)
        self:Notify(Message)

        if Success then
            if self.Running then
                self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Decompiling")}`)
                
                self.WaitingThread = coroutine.create(function()
                    local Info = coroutine.yield()

                    self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Finished Decompiling")}\n{GetTranslation(Translations, "Time Used")}: {Info.TotalTime}ms\n{GetTranslation(Translations, "Decompiled")}: {Info.Scripts}{GetTranslation(Translations, "Scripts")}\n{GetTranslation(Translations, "Total Size")}: {Info.Bytes}bytes`)
                    self:Notify(GetTranslation(Translations, "Finished Decompiling"))
                end)
            else
                self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Idle")}`)
            end
        end

        shared.Connect:GiveSignal("DecompilationInfo", self.InfoInstance:GetPropertyChangedSignal("Value"):Connect(function()
            if not self.Running then
                shared.Connect:DisconnectSignal("DecompilationInfo")
                return
            end

            self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Decompiled")} {self.InfoInstance.Value}/{self.TotalScripts} {GetTranslation(Translations, "Scripts")}`)
        end))
    end)

    self.Toggles.ToggleDecompilationState:OnChanged(function(Enabled)
        local self = Decompiler

        local Message, Success = self:TogglePaused(Enabled)
        self:Notify(Message)

        if Success then
            if self.Paused then
                self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Paused")}`)
            else
                self.DecompilerInfo:SetText(`{StatusText}: {GetTranslation(Translations, "Decompiling")}`)
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
    self.SettingsTab = self.Window:AddTab(GetTranslation(Translations, "Settings"), "settings")

    --// Menu Groupbox (Left)
    self.SettingsTabMenuGroup = self.SettingsTab:AddLeftGroupbox(GetTranslation(Translations, "Menu"))

    self.SettingsTabMenuGroup:AddToggle("OpenKeybindMenu", {
        Text = GetTranslation(Translations, "Open Keybind Menu"),
        Default = self.Library.KeybindFrame.Visible
    })

    self.SettingsTabMenuGroup:AddToggle("ShowCustomCursor", {
        Text = GetTranslation(Translations, "Show Custom Cursor"),
        Default = CustomCursor
    })

    self.SettingsTabMenuGroup:AddToggle("ForceCheckbox", {
        Text = GetTranslation(Translations, "Force Checkbox"),
        Default = ForceCheckbox
    })

    self.SettingsTabMenuGroup:AddLabel(GetTranslation(Translations, "Open Menu Key")):AddKeyPicker("OpenMenu", {
        Default = "RightControl",
        Mode = "Toggle",
        NoUI = true
    })

    self.SettingsTabMenuGroup:AddDivider()

    self.SettingsTabMenuGroup:AddButton({
        Text = GetTranslation(Translations, "Unload"),
        DoubleClick = true,
        Func = wax.shared.OnUnload
    })

    --// Theme Groupbox
    self.SettingsTabThemeGroup = self.SettingsTab:AddRightGroupbox(GetTranslation(Translations, "Theme"))

    self.ThemeManager:CreateThemeManager(self.SettingsTabUiGroup)

    --// Menu Groupbox OnChanged
    self.Toggles.OpenKeybindMenu:OnChanged(function(Enabled)
        KeybindFrame = Enabled
        self.Library.KeybindFrame.Visible = Enabled

        WriteFile(FileHelper, "MFeee-New/KeybindFrame.txt", tostring(Enabled))
    end)

    self.Toggles.ShowCustomCursor:OnChanged(function(Enabled)
        CustomCursor = Enabled
        self.Library.ShowCustomCursor = Enabled

        WriteFile(FileHelper, "MFeee-New/CustomCursor.txt", tostring(Enabled))
    end)

    self.Toggles.ForceCheckbox:OnChanged(function(Enabled)
        ForceCheckbox = Enabled
        self.Library.ForceCheckbox = Enabled

        WriteFile(FileHelper, "MFeee-New/ForceCheckbox.txt", tostring(Enabled))
    end)

    self.Library.ToggleKeybind = self.Options.OpenMenu

    --// UI Groupbox (Right)
    self.SettingsTabUiGroup = self.SettingsTab:AddRightGroupbox(GetTranslation(Translations, "UI"))

    self.SettingsTabUiGroup:AddToggle("AlwaysOnTop", {
        Text = GetTranslation(Translations, "Always On Top"),
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
            Text    = GetTranslation(Translations, "Change Language"),
            Values  = NativeLanguage.Name,
            Default = wax.shared.AllowedLanguages[wax.shared.Language]
        })

        self.Options.ChangeLanguage:OnChanged(function(Language)
            local Index = table_find(NativeLanguage.Tag, Language)
            if not Index then return end

            WriteFile(FileHelper, "MFeee-New/Language.txt", NativeLanguage[Index])
            self:Notify(GetTranslation(Translations, "Restart to Apply"))
        end)
    end

    self.SettingsTabUiGroup:AddDropdown("WindowStyle", {
        Text = GetTranslation(Translations, "Window Style"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = GetTranslation(Translations, WindowStyle)
    })

    self.SettingsTabUiGroup:AddSlider("DPIScale", {
        Text = GetTranslation(Translations, "DPI Scale"),
        Default = DPIScale,
        Min = 50,
        Max = 200,
        Suffix = "%"
    })

    self.SettingsTabUiGroup:AddSlider("UICorner", {
        Text = GetTranslation(Translations, "UI Corner"),
        Tooltip = GetTranslation(Translations, "Restart to Apply"),
        Default = UiCorner,
        Min = 0,
        Max = 10,
        Suffix = "px"
    })

    self.SettingsTabUiGroup:AddDivider()

    self.SettingsTabUiGroup:AddDropdown("NotifySide", {
        Text = GetTranslation(Translations, "Notify Side"),
        Values = {
            GetTranslation(Translations, "Top Left"),
            GetTranslation(Translations, "Top Right"),
            GetTranslation(Translations, "Bottom Left"),
            GetTranslation(Translations, "Bottom Right")
        },
        Default = GetTranslation(Translations, NotifySide)
    })

    self.SettingsTabUiGroup:AddDropdown("NotifySound", {
        Text = GetTranslation(Translations, "Notify Sound"),
        Values = {
            "Obsidian",
            "Linoria"
        },
        Default = GetTranslation(Translations, NotifySound)
    })

    self.SettingsTabUiGroup:AddInput("NotifySoundID", {
        Text = GetTranslation(Translations, "Notify Sound ID"),
        Default = "",
        EmptyReset = "",
        Placeholder = tostring(DefaultSoundID),
        ClearTextOnFocus = false
    })

    self.SettingsTabUiGroup:AddSlider("NotifyVolume", {
        Text = GetTranslation(Translations, "Notify Volume"),
        Default = 200,
        Min = 0,
        Max = 1000,
        Suffix = "%"
    })

    do
        local TestNotify = GetTranslation(Translations, "Test Notify")

        self.SettingsTabUiGroup:AddButton(TestNotify, function()
            self:Notify({
                Title = TestNotify,
                Description = TestNotify,
                Duration = 3
            })
        end)
    end

    self.SaveManager:BuildConfigSetction(self.SettingsTab)

    --// UI Groupbox OnChanged
    self.Toggles.AlwaysOnTop:OnChanged(function(Enabled)
        AlwaysOnTop = Enabled
        self.Library.ScreenGui.OnTopOfCoreBlur = Enabled

        WriteFile(FileHelper, "MFeee-New/AlwaysOnTop.txt", tostring(Enabled))
    end)

    self.Options.WindowStyle:OnChanged(function(Style)
        WriteFile(FileHelper, "MFeee-New/WindowStyle.txt", Style == "Obsidian" and "Obsidian" or "Linoria")
        self:Notify(GetTranslation(Translations, "Restart to Apply"))
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
            WriteFile(FileHelper, "MFeee-New/DPIScale.txt", Scale)
        end)
    end

    self.Options.UICorner:OnChanged(function(Corner)
        WriteFile(FileHelper, "MFeee-New/UICorner.txt", tostring(Corner))
        self:Notify(GetTranslation(Translations, "Restart to Apply"))
    end)

    self.Options.NotifySide:OnChanged(function(Side)
        Side = FromTranslation(Translations, Side)
        if not Side then return end

        WriteFile(FileHelper, "MFeee-New/NotifySide.txt", Side)
        self.Library:SetNotifySide(Side)
    end)

    self.Options.NotifySound:OnChanged(function(Sound)
        local SoundID = Sound == "Obsidian" and 4590662766 or 4590657391
        self.NotifySoundID = `rbxassetid://{SoundID}`

        WriteFile(FileHelper, "MFeee-New/NotifySound.txt", Sound)
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
    self.InfoTab = self.Window:AddTab(GetTranslation(Translations, "Info"), "info")

    --// Developers Groupbox (Left)
    self.InfoTabDevelopersGroup = self.InfoTab:AddLeftGroupbox(GetTranslation(Translations, "Developers"))

    self.InfoTabDevelopersGroup:AddLabel({
        Text = `[<font color="#1f6feb">MaiFengYXD</font>] {GetTranslation(Translations, "Owner, developer")}`,
        DoesWrap = true
    })

    --// Credits Groupbox (Left)
    self.InfoTabCreditsGroup = self.InfoTab:AddRightGroupbox(GetTranslation(Translations, "Credits"))

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">upio</font>] {GetTranslation(Translations, "Teaches me how to use wax")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">mspaint</font>] {GetTranslation(Translations, "Gives me inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">GitHub Copilot</font>] {GetTranslation(Translations, "Helps complete code")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">Google Gemini</font>] {GetTranslation(Translations, "Helps translate (English)")}`,
        DoesWrap = true
    })

    self.InfoTabCreditsGroup:AddLabel({
        Text = `[<font color="#1f6feb">{GetTranslation(Translations, "And you!")}</font>] {GetTranslation(Translations, "For using my script!")}`,
        DoesWrap = true
    })

    --// Spechial Thanks Groupbox (Left)
    self.InfoTabThanksGroup = self.InfoTab:AddLeftGroupbox(GetTranslation(Translations, "Special Thanks"))

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">latte-soft</font>] {GetTranslation(Translations, "Wax bundler")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">deividcomsono</font>] {GetTranslation(Translations, "Obsidian UI Library")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">mstudio45</font>] {GetTranslation(Translations, "Linoria UI Library and ESP Library")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">Exunys</font>] {GetTranslation(Translations, "Aimbot Inspiration")}`,
        DoesWrap = true
    })

    self.InfoTabThanksGroup:AddLabel({
        Text = `[<font color="#1f6feb">7GrandDadPGN</font>] {GetTranslation(Translations, "SilentAim Inspiration")}`,
        DoesWrap = true
    })

    --// About Game Groupbox (Right)
    self.InfoTabAboutGameGroup = self.InfoTab:AddRightGroupbox(GetTranslation(Translations, "About Game"))

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
            SetText(PlayedLabel, string_format(GetTranslation(Translations, "You Played: %s"), Time))
        end))

        shared.Connect:GiveSignal("TimeRunningLabel", shared.RunService.PreRender:Connect(function()
            local Time = ConvertTime(elapsedTime())
            SetText(TimeRunningLabel, string_format(GetTranslation(Translations, "Time Running: %s"), Time))
        end))

        task_spawn(function()
            repeat task_wait() until wax.shared.GameName
            SetText(GameNameLabel, string_format(GetTranslation(Translations, "Game Name: %s"), wax.shared.GameName))
        end)
    end

    do
        local PlaceId = tostring(game.PlaceId)

        self.InfoTabAboutGameGroup:AddButton({
            Text = string_format(GetTranslation(Translations, "Place Id: %s"), PlaceId),
            Func = function()
                shared.ToClipboard(PlaceId)
                self:Notify(GetTranslation(Translations, "Place Id Copied"))
            end
        })
    end

    --// Links Groupbox (Right)
    self.InfoTabLinksGroup = self.InfoTab:AddRightGroupbox(GetTranslation(Translations, "Links"))

    self.InfoTabLinksGroup
    :AddButton({
        Text = GetTranslation(Translations, "Discord"),
        Func = function()
            shared.ToClipboard("https://discord.gg/YBQUd8X8PK")
            self:Notify(GetTranslation(Translations, "Discord Server Link Copied"))
        end
    })
    :AddButton({
        Text = GetTranslation(Translations, "GitHub"),
        Func = function()
            shared.ToClipboard("https://github.com/MaiFengYXD")
            self:Notify(GetTranslation(Translations, "GitHub Link Copied"))
        end
    })

    return self.MiscTab, self.InfoTab
end

UiManager.SaveManager:SetLibrary  (UiManager.Library)
UiManager.SaveManager:SetFolder   ("MFeee-New")
UiManager.SaveManager:SetSubFolder(wax.shared.ScriptFolder)

UiManager.ThemeManager:SetLibrary (UiManager.Library)
UiManager.ThemeManager:SetFolder  ("MFeee-New")

return UiManager

end)() end,
    [56] = function()
local _, _, _ = __waximport(56)

return (function()

return {}

end)() end,
    [57] = function()
local wax, _, _ = __waximport(57)

return (function()

--// Source by mstudio45 //

local Instance_new, Vector2_new, Vector3_new, Color3_new, Path2DControlPoint_new, UDim2_new, UDim2_fromOffset, CFrame_new, CFrame_Angles
    = Instance.new, Vector2.new, Vector3.new, Color3.new, Path2DControlPoint.new, UDim2.new, UDim2.fromOffset, CFrame.new, CFrame.Angles

local table_clone, table_find, table_remove, table_clear, coroutine_resume, coroutine_create, coroutine_yield, coroutine_close
    = table.clone, table.find, table.remove, table.clear, coroutine.resume, coroutine.create, coroutine.yield, coroutine.close

local math_rad, math_cos, math_atan2, math_deg, math_sin, math_floor, string_match, string_format
    = math.rad, math.cos, math.atan2, math.deg, math.sin, math.floor, string.match, string.format

local randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof
    = randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof

local Disconnect = (game.Close:Once()).Disconnect

local      IsA,      Destroy
    = game.IsA, game.Destroy

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

--// Executor Variables //
local gethui = wax.shared.ExecutorSupport.gethui and gethui or (function() return shared.CoreGui end);
local HiddenUi = gethui();

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

    return function(Instance: Instance | any): CFrame
        if IsA(Instance, "Bone") then
            return Instance.TransformedWorldCFrame
        elseif IsA(Instance, "Attachment") then
            return Instance.WorldCFrame
        elseif IsA(Instance, "Camera") then
            return Instance.CFrame
        elseif IsA(Instance, "PVInstance") then
            return GetPivot(Instance)
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

            instance[name] = val
        end

        instance["Parent"] = properties["Parent"]

        return instance
    end,

    TryGetProperty = function(instance, propertyName): any
        assert(typeof(instance) == "Instance", "Argument #1 must be an Instance.")
        assert(typeof(propertyName) == "string", "Argument #2 must be a string.")

        local success, property = pcall(function()
            return instance[propertyName]
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
    Parent = HiddenUi,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ClipToDeviceSafeArea = false,
    OnTopOfCoreBlur = true,
    DisplayOrder = 1e6
})

local BillboardGUI = InstancesLib.Create("ScreenGui", {
    Parent = HiddenUi,
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
    Connections = {},

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

local function worldToViewport(...)
    if Camera == nil then
        return Vector2_new(0, 0), false
    end

    return Camera:WorldToViewportPoint(...)
end

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
            PublicESPDestroy = ESP.Destroy
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

    table_clear(Library.Connections)
    Library = setmetatable({}, {})
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
    local Path2D = InstancesLib.Create("Path2D", {
        Parent = MainGUI,
        Name = if typeof(instanceName) == "string" then instanceName else "Tracer",
        Closed = true,

        --// Settings
        Color3 = espSettings.Color,
        Thickness = espSettings.Thickness,
        Transparency = espSettings.Transparency,
    })

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
    UpdateTracer(data.From, data.To);

    --// Tracer Metatable
    local proxy = {}
    local Tracer = {
        __newindex = function(table, key, value)
            if not Path2D then
                return
            end

            if key == "From" then
                assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                UpdateTracer(value, data.To)

            elseif key == "To" then
                assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                UpdateTracer(data.From, value)

            elseif key == "Transparency" or key == "Thickness" then
                assert(typeof(value) == "number", tostring(key) .. "; expected number, got " .. typeof(value))
                Path2D[key] = value

            elseif key == "Color3" then
                assert(typeof(value) == "Color3", tostring(key) .. "; expected Color3, got " .. typeof(value))
                Path2D.Color3 = value

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
                return function()
                    SetControlPoints(Path2D, {});
                    Path2D = Destroy(Path2D);
                end
            end

            return data[key]
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

    espSettings.Name = if typeof(espSettings.Name) == "string" then espSettings[Name] else espSettings.Model[Name];
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
    }

    --// Create Billboard
    local Billboard = InstancesLib.Create("BillboardGui", {
        Parent = BillboardGUI,
        Name = ESP.Index,

        Enabled = true,
        ResetOnSpawn = false,
        AlwaysOnTop = true,
        Size = UDim2_new(0, 200, 0, 50),

        --// Settings
        Adornee = ESP.CurrentSettings.TextModel or ESP.CurrentSettings.Model,
        StudsOffset = ESP.CurrentSettings.StudsOffset or Vector3_new(),
    })

    local BillboardText = InstancesLib.Create("TextLabel", {
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
    })

    InstancesLib.Create("UIStroke", {
        Parent = BillboardText
    })

    --// Create Highlighter
    local Highlighter, IsAdornment = nil, not not string_match(ESP.OriginalSettings.ESPType, "Adornment")

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
    local Tracer = if typeof(TracerData) == "table" then TracerCreate(TracerData, ESP.Index) else nil;

    local ArrowData = ESP.CurrentSettings.Arrow :: ArrowESPSettings?
    local Arrow = nil;

    if typeof(ArrowData) == "table" then
        Arrow = InstancesLib.Create("ImageLabel", {
            Parent = MainGUI,
            Name = ESP.Index,

            Size = UDim2_new(0, 48, 0, 48),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,

            AnchorPoint = Vector2_new(0.5, 0.5),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image = "http://www.roblox.com/asset/?id=16368985219",
            ImageColor3 = ESP.CurrentSettings.Color or Color3_new(),
        });

        ArrowData.CenterOffset = if typeof(ArrowData.CenterOffset) == "number" then ArrowData.CenterOffset else 300;
    end

    --// Setup Delete Handler
    function ESP:Destroy()
        if ESP.Deleted == true then
            return;
        end

        ESP.Deleted = true

        if ESP.RenderThread then
            pcall(coroutine.close, ESP.RenderThread)
        end

        if table_find(Library.ESP, ESP.Index) then
            table_remove(Library.ESP, table_find(Library.ESP, ESP.Index))
        end

        Library.ESP[ESP.Index] = nil

        --// Delete ESP Instances
        if Billboard then Destroy(Billboard) end
        if Highlighter then Destroy(Highlighter) end
        if Tracer then Destroy(Tracer) end
        if Arrow then Destroy(Arrow) end

        --// Clear connections
        for _, connection in ESP.Connections do
            if not connection.Connected then
                continue
            end

            Disconnect(connection)
        end

        table_clear(ESP.Connections)

        --// OnDestroy
        if ESP.OriginalSettings.OnDestroy then
            pcall(ESP.OriginalSettings.OnDestroy.Fire, ESP.OriginalSettings.OnDestroy)
        end

        if ESP.OriginalSettings.OnDestroyFunc then
            pcall(ESP.OriginalSettings.OnDestroyFunc)
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
        local screenPos, isOnScreen = worldToViewport(
            GetPivot(ModelRoot or ESP.CurrentSettings.Model).Position
        )

        local distanceFromPlayer = InstancesLib.DistanceFrom(
            (ModelRoot or ESP.CurrentSettings.Model),
            (if Library.GlobalConfig.IgnoreCharacter == true then (Camera or rootPart) else rootPart)
        )

        if distanceFromPlayer > ESP.CurrentSettings.MaxDistance then
            Hide()
            return
        end

        --// Update Arrow (only requires distance check) //
        if Arrow then
            Arrow.Visible = Library.GlobalConfig.Arrows == true and ArrowData.Enabled == true and (isOnScreen ~= true)

            if Arrow.Visible then
                local screenSize = Camera.ViewportSize
                local centerPos = Vector2_new(screenSize.X / 2, screenSize.Y / 2)

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
                local distance = (ArrowData.CenterOffset * 0.001) * screenSize.Y

                Arrow.Rotation = angle + 180 * (IsInverted and 0 or 1)
                Arrow.Position = UDim2_new(
                    0,
                    centerPos.X + (distance * math_cos(arctan) * invert),
                    0,
                    centerPos.Y + (distance * math_sin(arctan) * invert)
                )
                Arrow.ImageColor3 =
                    if Library.GlobalConfig.Rainbow then Library.RainbowColor else ArrowData.Color;
            end
        end

        if isOnScreen == false then
            Hide()
            return
        else Show() end

        --// Update Tracer //
        if Tracer then
            local TracerData = ESP.CurrentSettings.Tracer :: TracerESPSettings?
            Tracer.Visible = Library.GlobalConfig.Tracers == true and TracerData.Enabled == true;

            if Tracer.Visible then
                if TracerData.From == "Mouse" then
                    local mousePos = GetMouseLocation(UserInputService)
                    Tracer.From = Vector2_new(mousePos.X, mousePos.Y)
                elseif TracerData.From == "Top" then
                    Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, 0)
                elseif TracerData.From == "Center" then
                    Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
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

end)() end,
    [58] = function()
local _, _, _ = __waximport(58)

return (function()

--[[
Source: https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
Thank you NOVEIGMA, I successfully used it on Aimbot! ^^
--]]

local math_pow, math_abs, math_sqrt, math_acos, math_cos, math_pi
    = math.pow, math.abs, math.sqrt, math.acos, math.cos, math.pi

local unpack, Vector3_new, table_insert
    = unpack, Vector3.new, table.insert

local Workspace = shared.Workspace
local Raycast   = Workspace.Raycast

local Prediction = {}

local function IsZero(Value)
    return (Value > -1e-9) and (Value < 1e-9)
end

local function CubeRoot(Value)
    return (Value > 0) and math_pow(Value, 1/3) or -math_pow(math_abs(Value), 1/3)
end

local function SolveQuadratic(Coeff0, Coeff1, Coeff2)
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

local function SolveCubic(Coeff0, Coeff1, Coeff2, Coeff3)
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

function Prediction.SolveQuartic(Coeff0, Coeff1, Coeff2, Coeff3, Coeff4)
    local Roots, Coefficients = {}, {}
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

function Prediction.SolveTrajectory(
    Origin         : Vector3, ProjectileSpeed : number, Gravity        : number,
    TargetPosition : Vector3, TargetVelocity  : Vector3,
    PlayerGravity  : number?, PlayerHeight    : number?, RaycastParams : RaycastParams?
)
    local Displacement = TargetPosition - Origin
    local TargetVelX, TargetVelY, TargetVelZ = TargetVelocity.X, TargetVelocity.Y, TargetVelocity.Z
    local DispX, DispY, DispZ = Displacement.X, Displacement.Y, Displacement.Z
    local GravityFactor = -0.5 * Gravity

    --/ Attempt gravity calculation, may return to it in the future.
    if math_abs(TargetVelY) > 0.01 and PlayerGravity and PlayerGravity > 0 then
        local EstimatedTime = Displacement.Magnitude / ProjectileSpeed
        TargetVelY -= 0.5 * PlayerGravity * EstimatedTime

        local VelocityStep = TargetVelocity * 0.016
        local RayResult = Raycast(Workspace, TargetPosition, Vector3_new(
            VelocityStep.X,
            (TargetVelY * EstimatedTime) - PlayerHeight, VelocityStep.Z),
            RaycastParams
        )

        if RayResult then
            local NewTarget = RayResult.Position + Vector3_new(0, PlayerHeight, 0)

            EstimatedTime -= math_sqrt(((TargetPosition - NewTarget).Magnitude * 2) / PlayerGravity)
            TargetPosition = NewTarget
            DispY = (TargetPosition - Origin).Y
            TargetVelY = 0
        end
    end

    local QuarticCoeffs = {
        GravityFactor * GravityFactor,
        -2 * TargetVelY * GravityFactor,
        TargetVelY^2 - 2 * DispY * GravityFactor - ProjectileSpeed^2 + TargetVelX^2 + TargetVelZ^2,
        2 * DispY * TargetVelY + 2 * DispX * TargetVelX + 2 * DispZ * TargetVelZ,
        DispY^2 + DispX^2 + DispZ^2
    }

    local SolutionRoots = Prediction.SolveQuartic(unpack(QuarticCoeffs))

    if SolutionRoots then
        local PositiveRoots = {}

        for _, Root in SolutionRoots do --/ Filter out the negative roots
            if Root > 0 then table_insert(PositiveRoots, Root) end
        end

        if #PositiveRoots > 0 then
            local Time = PositiveRoots[1]

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

return Prediction

end)() end,
    [59] = function()
local _, _, _ = __waximport(59)

return (function()

local game, GetService
    = game, game.GetService

local Services = {}
local Cloneref = cloneref or function(...) return ... end

function Services:GetServices(Table)
    for _, Name in Table do
        local Success, Service = pcall(Cloneref, GetService(game, Name))
        shared[Name] = if Success then Service else nil
    end
end

return Services

end)() end,
    [61] = function()
local wax, _, require = __waximport(61)

return (function()

local getcallingscript, checkcaller, mousemoverel, unpack, warn, tostring, pcall, getrainbowcolor
    = getcallingscript, checkcaller, mousemoverel, unpack, warn, tostring, pcall, getrainbowcolor

local Vector2_new, CFrame_new, CFrame_lookAt, RaycastParams_new, Ray_new, Vector3_zero
    = Vector2.new, CFrame.new, CFrame.lookAt, RaycastParams.new, Ray.new, Vector3.zero

local      FindFirstChild,      FindFirstChildOfClass,      GetDescendants,      IsA
    = game.FindFirstChild, game.FindFirstChildOfClass, game.GetDescendants, game.IsA

local table_insert, table_sort, table_clear, table_find, os_clock
    = table.insert, table.sort, table.clear, table.find, os.clock

local Aimbot = {
    Enabled = false,
    Method  = "SilentAim" :: "SilentAim" | "Aimbot",
    Modules = {},

    Shared = {
        TeamCheck  = true,
        AliveCheck = true,
        WallCheck  = false,

        ForceFieldCheck = true,

        TargetPlayers = true,
        TargetNpcs    = true,

        Locked = nil,

        TeamCheckBasedOn = "TeamColor" :: "TeamColor" | "Team" ,
        BlacklistMode    = "Blacklist" :: "Blacklist" | "Whitelist",

        HitChance      = 100,
        HeadshotChance = 100,
        MaxDistance    = 2000,

        Blacklist = {},
        Projectile = {
            Enabled = false,
            Library = require("../Prediction"),

            Speed   = 1000,
            Gravity = shared.Workspace.Gravity
        }
    },

    Fov = {
        Circle = nil,

        Enabled = false,
        Visible = true,

        Rainbow   = false,
        Filled    = false,
        FromMouse = true,

        Radius       = 150,
        Thickness    = 2,
        NumSides     = 60,
        Transparency = 0.35,
        RainbowSpeed = 0.4,

        Color       = Color3.new(1, 1, 1),
        LockedColor = Color3.new(1, 0, 0),

        Outline = {
            Circle  = nil,
            Visible = true,

            Thickness    = 1,
            Transparency = 0.35,

            Color = Color3.new(0, 0, 0)
        }
    }
}

local Random: Random = Random.new()
local NextNumber     = Random.NextNumber

local WorldToViewportPoint = shared.Camera.WorldToViewportPoint
local GetPlayers    = shared.Players.GetPlayers
local Raycast = shared.Workspace.Raycast

local EasingLibrary = wax.shared.EasingLibrary
local NpcHandler    = wax.shared.NpcHandler
local UiManager     = wax.shared.UiManager

local Options = UiManager.Library.Options

local function GetMousePosition()
    if shared.UserInputService.TouchEnabled or not Aimbot.Fov.FromMouse then
        return shared.Camera.ViewportSize / 2
    end
    return shared.UserInputService:GetMouseLocation()
end

--// Fov //
if wax.shared.ExecutorSupport.Drawing then
    local self = Aimbot.Fov

    self.Circle         = Drawing.new("Circle")
    self.Outline.Circle = Drawing.new("Circle")

    self.Circle.Visible         = false
    self.Outline.Circle.Visible = false

    shared.Connect:GiveSignal("AimbotCircleUpdate", shared.RunService.PreRender:Connect(function()
        local CirclePotistion = GetMousePosition()
        local RainbowColor    = self.Rainbow and getrainbowcolor(self.RainbowSpeed)
        local CircleVisible   = Aimbot.Enabled and self.Enabled and self.Visible

        --// Update Circle
        self.Circle.Visible      = CircleVisible
        self.Circle.Position     = CirclePotistion
        self.Circle.Color        = RainbowColor or Aimbot.Shared.Locked and self.LockedColor or self.Color
        self.Circle.Radius       = self.Radius
        self.Circle.Thickness    = self.Thickness
        self.Circle.NumSides     = self.NumSides
        self.Circle.Filled       = self.Filled
        self.Circle.Transparency = 1 - self.Transparency

        --// Update Outline
        self.Outline.Circle.Visible      = CircleVisible and self.Outline.Visible
        self.Outline.Circle.Position     = CirclePotistion
        self.Outline.Circle.Color        = RainbowColor or self.Outline.Color
        self.Outline.Circle.Radius       = self.Radius + self.Outline.Thickness / 2
        self.Outline.Circle.Thickness    = self.Outline.Thickness
        self.Outline.Circle.NumSides     = self.NumSides
        self.Outline.Circle.Filled       = false
        self.Outline.Circle.Transparency = 1 - self.Outline.Transparency
    end))
end

--// Shared Functions //
Aimbot.Shared.WallChecker = function(Origin: Vector3, Position: Vector3, IgonreObjects: Array): RaycastResult?
    local RaycastParams = RaycastParams_new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParams.FilterDescendantsInstances = IgonreObjects

    return Raycast(shared.Workspace, Origin, (Position - Origin), RaycastParams)
end

Aimbot.Shared.FindRoot = function(Character: Model): BasePart | any
    if not Character then return end
    return (
        FindFirstChild(Character, "HumanoidRootPart") or
        FindFirstChild(Character, "UpperTorso") or
        FindFirstChild(Character, "Torso")
    )
end

Aimbot.Shared.CheckCondition = function(Character: Model): boolean
    local Shared = Aimbot.Shared

    local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")
    if not Humanoid or Shared.AliveCheck and Humanoid.Health <= 0 then return true end

    local RootPart = Shared.FindRoot(Character)
    if not RootPart then return true end

    if Shared.ForceFieldCheck and FindFirstChildOfClass(Character, "ForceField") then return true end
    return false
end

Aimbot.Shared.FastSolve = function(Origin: Vector3, TargetPart: BasePart, Params: RaycastParams?)
    local Projectile = Aimbot.Shared.Projectile
    return Projectile.Library.SolveTrajectory(
        Origin,
        Projectile.Speed,
        Projectile.Gravity,
        TargetPart.Position,
        TargetPart.AssemblyLinearVelocity,
        nil,
        nil,
        Params
    )
end

--// Old Aimbot //
Aimbot.Modules.Aimbot = {
    Running = false,

    LockMethod = "CFrame" :: "CFrame" | "mousemoverel",
    LockPart = nil,

    Sensitivity = 3.5, --/ Mouse move speed
    Smoothness  = 0, --/ Tween duration

    OldMouseSensitivity = shared.UserInputService.MouseDeltaSensitivity,

    CancelLock = function(self)
        if self.LockPart then
            shared.UserInputService.MouseDeltaSensitivity = self.OldMouseSensitivity
        end
        self.LockPart = nil

        Aimbot.Shared.Locked = nil
        EasingLibrary:CancelTween("AimbotTween")
    end,

    GetTarget = function(self)
        local Fov    = Aimbot.Fov
        local Shared = Aimbot.Shared

        local RequiredDistance = Fov.Enabled and Fov.Radius or Shared.MaxDistance

        local function OnIteration(Character: Model, Player: Player?)
            if Shared.CheckCondition(Character) then return end
            local RootPart = Shared.FindRoot(Character)

            local HitChance = NextNumber(Random, 0, 100)
            if HitChance > Shared.HitChance then return end

            local Head           = FindFirstChild(Character, "Head")
            local TargetPart     = NextNumber(Random, 0, 100) <= Shared.HeadshotChance and Head or RootPart
            local TargetPosition = TargetPart.Position

            self.LockPart = TargetPart

            if Shared.WallCheck then
                local Ignored       = {}
                local SelfCharacter = shared.Speaker.Character
                if not SelfCharacter then return end

                local SelfRoot     = Shared.FindRoot(SelfCharacter)
                local SelfPosition = SelfRoot and SelfRoot.Position or SelfCharacter:GetPivot()

                for _, Part in GetDescendants(Character) do
                    if Part == TargetPart or not IsA(Part, "BasePart") then continue end
                    table_insert(Ignored, Part)
                end

                for _, Part in GetDescendants(SelfCharacter) do
                    if not IsA(Part, "BasePart") then continue end
                    table_insert(Ignored, Part)
                end

                if Shared.WallChecker(SelfPosition, TargetPosition, Ignored) then return end
            end

            local Vector, OnScreen, Distance = WorldToViewportPoint(shared.Camera, TargetPosition)

            Vector   = Vector2_new(Vector.X, Vector.Y)
            Distance = (GetMousePosition() - Vector).Magnitude

            if Distance > RequiredDistance or not OnScreen then return end
            Shared.Locked = Player
        end

        if not Shared.Locked then
            if Shared.TargetPlayers then
                for _, Player in GetPlayers(shared.Players) do
                    if Shared.Locked then break end
                    if Player == shared.Speaker then continue end

                    if (Shared.BlacklistMode == "Blacklist") == (table_find(Shared.Blacklist, Player.Name) ~= nil) then continue end
                    if Shared.TeamCheck and Player[Shared.TeamCheckBasedOn] == shared.Speaker[Shared.TeamCheckBasedOn] then continue end

                    local Character = Player.Character
                    OnIteration(Character, Player)
                end
            end

            if not Shared.Locked and Shared.TargetNpcs then
                for _, Npc in NpcHandler.Npcs do
                    OnIteration(Npc, Npc)
                end
            end
        else
            local Character = IsA(Shared.Locked, "Model") and Shared.Locked or Shared.Locked.Character
            local Humanoid  = Character and FindFirstChildOfClass(Character, "Humanoid")
            if not Humanoid or Humanoid.Health <= 0 then
                self:CancelLock()
                return
            end

            local PartPosition = self.LockPart.Position
            local Vector       = WorldToViewportPoint(shared.Camera, PartPosition)
            local Distance     = (GetMousePosition() - Vector2_new(Vector.X, Vector.Y)).Magnitude

            if Distance > RequiredDistance then
                self:CancelLock()
                return
            end
        end
    end
};do
    local self = Aimbot.Modules.Aimbot
    local function OnStep()
        self.Running = Options.AimbotKeyPicker:GetState()

        if Aimbot.Method ~= "Aimbot" or not (self.Running and Aimbot.Enabled) then
            self:CancelLock()
            return
        end

        pcall(self.GetTarget, self)
        if not (Aimbot.Shared.Locked and self.LockPart) then return end

        shared.UserInputService.MouseDeltaSensitivity = 0

        local AimPosition = self.LockPart.Position
        local LookCFrame  = CFrame_new(shared.Camera.CFrame.Position, AimPosition)

        if self.LockMethod == "mousemoverel" then
            local TargetVector = WorldToViewportPoint(shared.Camera, AimPosition)
            mousemoverel(
                (TargetVector.X - GetMousePosition().X) / self.Sensitivity,
                (TargetVector.Y - GetMousePosition().Y) / self.Sensitivity
            )
        elseif self.Smoothness > 0 then
            EasingLibrary:Ease(shared.Camera, "CFrame", LookCFrame, "AimbotTween", self.Smoothness) 
        else
            shared.Camera.CFrame = LookCFrame
        end
    end

    shared.Connect:GiveSignal("AimbotStep", shared.RunService.PreRender:Connect(function()
        pcall(OnStep)
    end))
end

--// Modern Aimbot //
Aimbot.Modules.SilentAim = {
    Running  = false,
    Wallbang = false,

    OldRay      = nil,
    OldNameCall = nil,

    Hooks = {},

    EnabledHooks = {
        FindPartOnRay = true,
        FindPartOnRayWithIgnoreList = true,
        FindPartOnRayWithWhitelist  = true,
        ViewportPointToRay = true,
        ScreenPointToRay   = true,
        Raycast = true,
        Ray     = true
    },

    ProjectileParams = RaycastParams_new(),
    WallbangParams   = RaycastParams_new(),

    LastGet = os_clock(),

    GetEntity = function(self, Settings: {Origin: Vector3, Part: string}): Instance?
        local Fov    = Aimbot.Fov
        local Shared = Aimbot.Shared

        local SelfCharacter = shared.Speaker.Character
        if not SelfCharacter then return nil end

        local SelfRoot      = Shared.FindRoot(SelfCharacter)
        local SelfPosition  = SelfRoot and SelfRoot.Position or SelfCharacter:GetPivot().Position

        local RequiredDistance    = Fov.Enabled and Fov.Radius or Shared.MaxDistance
        local LocationCheckOrigin = Fov.Enabled and GetMousePosition() or SelfPosition

        local SortingTable = {}
        local BestEntity: Instance? = nil

        local function ProcessTarget(Target: any)
            local Character = IsA(Target, "Player") and Target.Character or Target
            if Shared.CheckCondition(Character) then return end

            local TargetRoot = Shared.FindRoot(Character)
            if not TargetRoot then return end

            if IsA(Target, "Player") then
                if (Shared.BlacklistMode == "Blacklist") == (table_find(Shared.Blacklist, Target.Name) ~= nil) then return end
                if Shared.TeamCheck and Target[Shared.TeamCheckBasedOn] == shared.Speaker[Shared.TeamCheckBasedOn] then return end
            end

            local FoundPart    = FindFirstChild(Character, Settings.Part) or TargetRoot
            local PartPosition = FoundPart.Position

            local Magnitude : number
            local IsOnScreen: boolean = true

            if Fov.Enabled then
                local ScreenPosition, OnScreen = WorldToViewportPoint(shared.Camera, PartPosition)
                if not OnScreen then IsOnScreen = false;return end
                Magnitude = (LocationCheckOrigin - Vector2_new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
            else
                Magnitude = (SelfPosition - PartPosition).Magnitude
            end

            if Magnitude <= RequiredDistance and IsOnScreen then
                table_insert(SortingTable, {
                    Entity    = Target,
                    Magnitude = Magnitude,
                    Part      = FoundPart
                })
            end
        end

        if Shared.TargetPlayers then
            for _, Player in GetPlayers(shared.Players) do
                if Player == shared.Speaker then continue end
                ProcessTarget(Player)
            end
        end

        if Shared.TargetNpcs then
            for _, Npc in NpcHandler.Npcs do
                ProcessTarget(Npc)
            end
        end

        table_sort(SortingTable, function(A, B)
            return A.Magnitude < B.Magnitude
        end)

        for _, Data in SortingTable do
            local TargetCharacter = IsA(Data.Entity, "Player") and Data.Entity.Character or Data.Entity
            local TargetPart = Data.Part

            if Shared.WallCheck and not self.Wallbang then
                local Ignored = {SelfCharacter}
                for _, Part in GetDescendants(TargetCharacter) do
                    if IsA(Part, "BasePart") then
                       table_insert(Ignored, Part)
                    end
                end
                if Shared.WallChecker(SelfPosition, TargetPart.Position, Ignored) then continue end
            end

            BestEntity = Data.Entity
            break
        end

        table_clear(SortingTable)
        return BestEntity
    end,

    GetTarget = function(self, Origin: Vector3): (Instance?, BasePart?, Vector3?)
        local Shared = Aimbot.Shared
        if NextNumber(Random, 1, 100) > Shared.HitChance then return end

        local TargetPartName = NextNumber(Random, 1, 100) <= Shared.HeadshotChance and "Head" or "HumanoidRootPart"
        local Entity = self:GetEntity({
            Origin = Origin,
            Part   = TargetPartName
        })

        if not Entity then Shared.Locked = nil; end

        local Character = IsA(Entity, "Player") and Entity.Character or Entity
        local TargetPartInstance = Character and FindFirstChild(Character, TargetPartName) or Shared.FindRoot(Character)

        if not TargetPartInstance then return end

        if Shared.Projectile.Enabled then
            self.ProjectileParams.FilterType     = Enum.RaycastFilterType.Exclude
            self.ProjectileParams.CollisionGroup = TargetPartInstance.CollisionGroup

            self.ProjectileParams.FilterDescendantsInstances = {shared.Speaker.Character, Character}
        end

        Shared.Locked = Entity
        self.LastGet = os_clock()

        return Entity, TargetPartInstance, Origin
    end
};do
    local self   = Aimbot.Modules.SilentAim
    local Shared = Aimbot.Shared

    self.Hooks.ScreenPointToRay = function(Arguments)
        if not (
            self.EnabledHooks.ScreenPointToRay or
            self.EnabledHooks.ViewportPointToRay
        ) then return nil end

        local Entity, TargetPart, Origin = self:GetTarget(shared.Camera.CFrame.Position)
        if not Entity or not TargetPart or not Origin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(Origin, TargetPart, self.ProjectileParams)
            AimPosition = PredictedAimVector or TargetPart.Position
        end

        local LookDirection = CFrame_lookAt(Origin, AimPosition)

        local RayOriginOffset = Arguments[3] and LookDirection.LookVector * Arguments[3] or Vector3_zero
        return {Ray_new(Origin + RayOriginOffset, LookDirection.LookVector)}
    end

    self.Hooks.FindPartOnRay = function(Arguments)
        if not (
            self.EnabledHooks.FindPartOnRayWithIgnoreList or
            self.EnabledHooks.FindPartOnRayWithWhitelist or
            self.EnabledHooks.FindPartOnRay
        ) then return nil end

        local OriginalRay: Ray = Arguments[1]
        local Entity, TargetPart, Origin = self:GetTarget(OriginalRay.Origin)
        if not Entity or not TargetPart or not Origin then return nil end

        if self.Wallbang then
            return {TargetPart, TargetPart.Position, TargetPart.Position, TargetPart.Material}
        end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(Origin, TargetPart, self.ProjectileParams)
            if PredictedAimVector then
                AimPosition = PredictedAimVector
            end
        end

        local LookDirection = CFrame_lookAt(Origin, AimPosition)
        Arguments[1]        = Ray_new(Origin, LookDirection.LookVector * OriginalRay.Direction.Magnitude)
        return nil
    end

    self.Hooks.Raycast = function(Arguments)
        if not self.EnabledHooks.Raycast then return nil end

        local Origin:          Vector3 = Arguments[1]
        local DirectionVector: Vector3 = Arguments[2]
        local Params:    RaycastParams = Arguments[3]

        local Entity, TargetPart, TargetOrigin = self:GetTarget(Origin)
        if not Entity or not TargetPart or not TargetOrigin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(TargetOrigin, TargetPart, self.ProjectileParams)
            AimPosition = PredictedAimVector or TargetPart.Position
        end

        local LookDirection = CFrame_lookAt(TargetOrigin, AimPosition)
        Arguments[2]        = LookDirection.LookVector * DirectionVector.Magnitude

        if self.Wallbang then
            self.WallbangParams.FilterType = Enum.RaycastFilterType.Include
            self.WallbangParams.FilterDescendantsInstances = {TargetPart}

            Arguments[3] = self.WallbangParams
        else
            if not Params then Params = RaycastParams_new() end

            local IgnoreList = Params.FilterDescendantsInstances or {}
            local Character  = IsA(Entity, "Player") and Entity.Character or Entity

            table_insert(IgnoreList, shared.Speaker.Character)
            table_insert(IgnoreList, Character)

            Params.FilterType = Enum.RaycastFilterType.Exclude
            Params.FilterDescendantsInstances = IgnoreList

            Arguments[3] = Params
        end
        return nil
    end

    self.Hooks.Ray = function(Arguments)
        if not self.EnabledHooks.Ray then return nil end

        local Origin:    Vector3 = Arguments[1]
        local Direction: Vector3 = Arguments[2]

        local Entity, TargetPart, TargetOrigin = self:GetTarget(Origin)
        if not Entity or not TargetPart or not TargetOrigin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(TargetOrigin, TargetPart, self.ProjectileParams)
            if PredictedAimVector then
                AimPosition = PredictedAimVector
            end
        end

        local LookDirection = CFrame_lookAt(TargetOrigin, AimPosition)
        Arguments[2]        = LookDirection.LookVector * Direction.Magnitude
        return nil
    end

    self.Hooks.FindPartOnRayWithIgnoreList = self.Hooks.FindPartOnRay
    self.Hooks.FindPartOnRayWithWhitelist  = self.Hooks.FindPartOnRay
    self.Hooks.ViewportPointToRay          = self.Hooks.ScreenPointToRay

    self.Start = function(Enabled: boolean)
        self.Running = Enabled
        if Enabled then
            if (
                wax.shared.ExecutorSupport.hookmetamethod and
                wax.shared.ExecutorSupport.getnamecallmethod and
                not self.OldNameCall
            ) then
                self.OldNameCall = hookmetamethod(game, "__namecall", function(Object, ...)
                    local MethodName = getnamecallmethod()
                    if not (
                        not checkcaller() and
                        Aimbot.Enabled and 
                        Aimbot.Method == "SilentAim" and
                        wax.shared.ExecutorSupport.checkcaller and
                        self.EnabledHooks[MethodName] and
                        self.Hooks[MethodName]
                    ) then
                        return self.OldNameCall(Object, ...)
                    end

                    if wax.shared.ExecutorSupport.getcallingscript then
                        local CallingScript = getcallingscript()
                        if table_find({"ControlScript", "ControlModule"}, tostring(CallingScript)) then
                            return self.OldNameCall(Object, ...)
                        end
                    end

                    local Args = {...}
                    local Hook = self.Hooks[MethodName]
                    local Result

                    local Success, Error = pcall(function()
                        Result = Hook(Args)
                    end)

                    if not Success then
                        warn(`[SilentAim Hook Error] {MethodName}: "{Error}"`)
                        return self.OldNameCall(Object, unpack(Args))
                    end

                    if Result then
                        return unpack(Result)
                    else
                        return self.OldNameCall(Object, unpack(Args))
                    end
                end)
            end

            if (wax.shared.ExecutorSupport.hookfunction and not self.OldRay) then
                self.OldRay = hookfunction(Ray_new, function(Origin, Direction)
                    if not (
                        not checkcaller() and
                        Aimbot.Enabled and
                        Aimbot.Method == "SilentAim" and
                        self.EnabledHooks.Ray and
                        wax.shared.ExecutorSupport.checkcaller
                    ) then
                        return self.OldRay(Origin, Direction)
                    end

                    if wax.shared.ExecutorSupport.getcallingscript then
                        local CallingScript = getcallingscript()
                        if table_find({"ControlScript", "ControlModule"}, tostring(CallingScript)) then
                            return self.OldRay(Origin, Direction)
                        end
                    end

                    local Args = {Origin, Direction}
                    local Success, Error = pcall(self.Hooks.Ray, Args)

                    if not Success then
                        warn(`[SilentAim Hook Error] Ray.new: "{Error}"`)
                        return self.OldRay(Origin, Direction)
                    end

                    return self.OldRay(unpack(Args))
                end)
            end
        else
            if self.OldNameCall and wax.shared.ExecutorSupport.hookmetamethod then
                pcall(hookmetamethod, game, "__namecall", self.OldNameCall)
            end

            if self.OldRay and wax.shared.ExecutorSupport.hookfunction then
                pcall(hookfunction, Ray_new, self.OldRay)
            end

            self.OldNameCall = nil
            self.OldRay = nil

            Aimbot.Shared.Locked = nil
        end
    end

    shared.Connect:GiveSignal("LastGetDetection", shared.RunService.Heartbeat:Connect(function()
        if os_clock() - self.LastGet > 0.2 and Aimbot.Method == "SilentAim" and self.Running then
            Shared.Locked = nil
        end
    end))
end

Aimbot.Toggle = function(Enabled: boolean)

end

return Aimbot

end)() end,
    [62] = function()
local wax, _, require = __waximport(62)

return (function()

--// Source by mspaint //

require("../LiteralBlank")

local Vector3new,  mathmin
    = Vector3.new, math.min

if wax.shared.ExecutorSupport.require then
    local OriginControlModule = shared.Speaker:WaitForChild("PlayerScripts", 3):WaitForChild("PlayerModule", 3):WaitForChild("ControlModule", 3)

    if OriginControlModule then
        return getgenv().require(OriginControlModule)
    end
end

local ControlModule = {
    Replaced = true,

    GamepadMoveVector    = Vector3new(),
    ThumbstickMoveVector = Vector3new(),
    ThumbstickRadius   = 15,
    TouchInput         = nil,
    TouchStartPosition = nil
};do
    local self      = ControlModule
    local Service   = shared.UserInputService :: UserInputService
    local IsKeyDown = Service.IsKeyDown

    function self:GetMoveVector(): Vector3
        local X, Z = 0, 0

        if IsKeyDown(Service, Enum.KeyCode.W) then Z -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.S) then Z += 1 end
        if IsKeyDown(Service, Enum.KeyCode.A) then X -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.D) then X += 1 end

        if IsKeyDown(Service, Enum.KeyCode.Up  ) then Z -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.Down) then Z += 1 end

        return Vector3new(X, 0, Z) + self.ThumbstickMoveVector + self.GamepadMoveVector
    end

    shared.Connect:GiveSignal("ControlModuleInputChanged", Service.InputChanged:Connect(function(Input: InputObject, Processed: boolean)
        if Processed then return end

        if Input.UserInputType == Enum.UserInputType.Gamepad1 and Input.KeyCode == Enum.KeyCode.Thumbstick1 then
            self.GamepadMoveVector = Vector3new(Input.Position.X, 0, -Input.Position.Y)
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
        local Distance         = mathmin((Input.Position - self.TouchStartPosition).Magnitude, self.ThumbstickRadius)
        local AdjustedDistance = Distance / self.ThumbstickRadius

        self.ThumbstickMoveVector = Vector3new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Y * AdjustedDistance)
    end))

    shared.Connect:GiveSignal("ControlModuleTouchEnded", Service.TouchEnded:Connect(function(Input: InputObject)
        if Input ~= self.TouchInput then return end

        self.ThumbstickMoveVector = Vector3new()
        self.TouchInput = nil
    end))
end

return ControlModule

end)() end,
    [63] = function()
local _, _, _ = __waximport(63)

return (function()

--// Source by Roblox Studio? //

local FreeCamera = {
    ToggleInputPriority = Enum.ContextActionPriority.Low.Value,
    InputPriority       = Enum.ContextActionPriority.High.Value,
    FreecamMacroKb      = {Enum.KeyCode.P},
}

local Pi    = math.pi
local Abs   = math.abs
local Clamp = math.clamp
local Exp   = math.exp
local Rad   = math.rad
local Sign  = math.sign
local Sqrt  = math.sqrt
local Tan   = math.tan

local GameSettings = UserSettings().GameSettings

local NavGain = Vector3.new(1, 1, 1) * 64
local PanGain = Vector2.new(0.75, 1) * 8
local FovGain = 300

local PitchLimit = Rad(90)

local VelStiffness = 5.0
local PanStiffness = 5.0
local FovStiffness = 5.0

local Spring = {};do
    Spring.__index = Spring

    function Spring.new(Freq, Position)
        local self = setmetatable({}, Spring)
        self.F = Freq
        self.P = Position
        self.V = Position * 0
        return self
    end

    function Spring:Update(DeltaTime, Goal)
        local F  = self.F * 2 * Pi
        local P0 = self.P
        local V0 = self.V

        local Offset = Goal - P0
        local Decay = Exp(-F * DeltaTime)

        local P1 = Goal + (V0 * DeltaTime - Offset * (F * DeltaTime + 1)) * Decay
        local V1 = (F * DeltaTime * (Offset * F - V0) + V0) * Decay

        self.P = P1
        self.V = V1

        return P1
    end

    function Spring:Reset(Position)
        self.P = Position
        self.V = Position * 0
    end
end

local CameraPos = Vector3.new()
local CameraRot = Vector2.new()
local CameraFov = 0

local VelSpring = Spring.new(VelStiffness, Vector3.new())
local PanSpring = Spring.new(PanStiffness, Vector2.new())
local FovSpring = Spring.new(FovStiffness, 0)

local Input = {};do
    local ThumbstickCurve;do
        local KCurvature = 2.0
        local KDeadzone = 0.15

        local function FCurve(X)
            return (Exp(KCurvature * X) - 1) / (Exp(KCurvature) - 1)
        end

        local function FDeadzone(X)
            return FCurve((X - KDeadzone) / (1 - KDeadzone))
        end

        function ThumbstickCurve(X)
            return Sign(X) * Clamp(FDeadzone(Abs(X)), 0, 1)
        end
    end

    local Gamepad = {
        ButtonX = 0,
        ButtonY = 0,
        DPadDown = 0,
        DPadUp = 0,
        ButtonL2 = 0,
        ButtonR2 = 0,
        Thumbstick1 = Vector2.new(),
        Thumbstick2 = Vector2.new(),
    }

    local Keyboard = {
        W = 0,
        A = 0,
        S = 0,
        D = 0,
        E = 0,
        Q = 0,
        U = 0,
        H = 0,
        J = 0,
        K = 0,
        I = 0,
        Y = 0,
        Up = 0,
        Down = 0,
        LeftShift = 0,
        RightShift = 0,
    }

    local Mouse = {
        Delta = Vector2.new(),
        MouseWheel = 0,
    }

    local NavGamepadSpeed  = Vector3.new(1, 1, 1)
    local NavKeyboardSpeed = Vector3.new(1, 1, 1)
    local PanMouseSpeed    = Vector2.new(1, 1) * (Pi/64)
    local PanGamepadSpeed  = Vector2.new(1, 1) * (Pi/8)
    local FovWheelSpeed    = 1.0
    local FovGamepadSpeed  = 0.25
    local NavAdjSpeed      = 0.75
    local NavShiftMul      = 0.25

    local NavSpeed = 1

    function Input.Vel(DeltaTime)
        NavSpeed = Clamp(NavSpeed + DeltaTime * (Keyboard.Up - Keyboard.Down) * NavAdjSpeed, 0.01, 4)

        local KGamepad = Vector3.new(
            ThumbstickCurve(Gamepad.Thumbstick1.X),
            ThumbstickCurve(Gamepad.ButtonR2) - ThumbstickCurve(Gamepad.ButtonL2),
            ThumbstickCurve(-Gamepad.Thumbstick1.Y)
        ) * NavGamepadSpeed

        local KKeyboard = Vector3.new(
            Keyboard.D - Keyboard.A + Keyboard.K - Keyboard.H,
            Keyboard.E - Keyboard.Q + Keyboard.I - Keyboard.Y,
            Keyboard.S - Keyboard.W + Keyboard.J - Keyboard.U
        ) * NavKeyboardSpeed

        local Shift = shared.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or shared.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

        return (KGamepad + KKeyboard)*(NavSpeed*(Shift and NavShiftMul or 1))
    end

    function Input.Pan(DeltaTime)
        local KGamepad = Vector2.new(
            ThumbstickCurve(Gamepad.Thumbstick2.Y),
            ThumbstickCurve(-Gamepad.Thumbstick2.X)
        ) * PanGamepadSpeed
        local KMouse = Mouse.Delta * PanMouseSpeed
        Mouse.Delta = Vector2.new()
        return KGamepad + KMouse
    end

    function Input.Fov(DeltaTime)
        local KGamepad = (Gamepad.ButtonX - Gamepad.ButtonY) * FovGamepadSpeed
        local KMouse = Mouse.MouseWheel * FovWheelSpeed
        Mouse.MouseWheel = 0
        return KGamepad + KMouse
    end

    do
        local function Keypress(Action, State, InputObject)
            Keyboard[InputObject.KeyCode.Name] = State == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Sink
        end

        local function GpButton(Action, State, InputObject)
            Gamepad[InputObject.KeyCode.Name] = State == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Sink
        end

        local function MousePan(Action, State, InputObject)
            local Delta = InputObject.Delta
            Mouse.Delta = Vector2.new(-Delta.y, -Delta.x)
            return Enum.ContextActionResult.Sink
        end

        local function Thumb(Action, State, InputObject)
            Gamepad[InputObject.KeyCode.Name] = InputObject.Position
            return Enum.ContextActionResult.Sink
        end

        local function Trigger(Action, State, InputObject)
            Gamepad[InputObject.KeyCode.Name] = InputObject.Position.z
            return Enum.ContextActionResult.Sink
        end

        local function MouseWheel(Action, State, InputObject)
            Mouse[InputObject.UserInputType.Name] = -InputObject.Position.z
            return Enum.ContextActionResult.Sink
        end

        local function Zero(Table)
            for Key, Value in Table do
                Table[Key] = Value * 0
            end
        end

        function Input.StartCapture()
            local InputPriority = FreeCamera.InputPriority
            local function Bind(Index, Function, ...)
                shared.ContextActionService:BindActionAtPriority(Index, Function, false, InputPriority, ...)
            end

            Bind("FreecamKeyboard", Keypress,
                Enum.KeyCode.W,  Enum.KeyCode.U,
                Enum.KeyCode.A,  Enum.KeyCode.H,
                Enum.KeyCode.S,  Enum.KeyCode.J,
                Enum.KeyCode.D,  Enum.KeyCode.K,
                Enum.KeyCode.E,  Enum.KeyCode.I,
                Enum.KeyCode.Q,  Enum.KeyCode.Y,
                Enum.KeyCode.Up, Enum.KeyCode.Down
            )
            Bind("FreecamMousePan",          MousePan,   Enum.UserInputType.MouseMovement)
            Bind("FreecamMouseWheel",        MouseWheel, Enum.UserInputType.MouseWheel)
            Bind("FreecamGamepadButton",     GpButton,   Enum.KeyCode.ButtonX,     Enum.KeyCode.ButtonY)
            Bind("FreecamGamepadTrigger",    Trigger,    Enum.KeyCode.ButtonR2,    Enum.KeyCode.ButtonL2)
            Bind("FreecamGamepadThumbstick", Thumb,      Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
        end

        function Input.StopCapture()
            local function Unbind(Index)
                shared.ContextActionService:UnbindAction(Index)
            end

            NavSpeed = 1
            Zero(Gamepad)
            Zero(Keyboard)
            Zero(Mouse)

            Unbind("FreecamKeyboard")
            Unbind("FreecamMousePan")
            Unbind("FreecamMouseWheel")
            Unbind("FreecamGamepadButton")
            Unbind("FreecamGamepadTrigger")
            Unbind("FreecamGamepadThumbstick")
        end
    end
end

local function StepFreecam(DeltaTime)
    local Vel = VelSpring:Update(DeltaTime, Input.Vel(DeltaTime))
    local Pan = PanSpring:Update(DeltaTime, Input.Pan(DeltaTime))
    local Fov = FovSpring:Update(DeltaTime, Input.Fov(DeltaTime))

    local ZoomFactor = Sqrt(Tan(Rad(70 / 2)) / Tan(Rad(CameraFov / 2)))

    CameraFov = Clamp(CameraFov + Fov * FovGain * (DeltaTime / ZoomFactor), 1, 120)
    CameraRot = CameraRot + Pan * PanGain * (DeltaTime / ZoomFactor)
    CameraRot = Vector2.new(Clamp(CameraRot.x, -PitchLimit, PitchLimit), CameraRot.y % (2 * Pi))

    local CameraCFrame = (
        CFrame.new(CameraPos) *
        CFrame.new(Vel * NavGain * DeltaTime) *
        CFrame.fromOrientation(CameraRot.x, CameraRot.y, 0)
    )
    CameraPos = CameraCFrame.p

    shared.Camera.CFrame      = CameraCFrame
    shared.Camera.Focus       = CameraCFrame
    shared.Camera.FieldOfView = CameraFov
end

local function CheckMouseLockAvailability()
    local DevAllowsMouseLock          = shared.Players.shared.Speaker.DevEnableMouseLock
    local DevMovementModeIsScriptable = shared.Players.shared.Speaker.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
    local UserHasMouseLockModeEnabled = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
    local UserHasClickToMoveEnabled   = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

    return DevAllowsMouseLock and UserHasMouseLockModeEnabled and not UserHasClickToMoveEnabled and not DevMovementModeIsScriptable
end

local PlayerState = {};do
    local MouseBehavior
    local MouseIconEnabled
    local CameraType
    local CameraFocus
    local CameraCFrame
    local CameraFieldOfView
    local ScreenGuis = {}
    local CoreGuis = {
        Backpack = true,
        Chat = true,
        Health = true,
        PlayerList = true,
    }
    local SetCores = {
        BadgesNotificationsActive = true,
        PointsNotificationsActive = true,
    }

    function PlayerState.Push()
        for Name in CoreGuis do
            CoreGuis[Name] = shared.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[Name])
            shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[Name], false)
        end
        for Name in SetCores do
            SetCores[Name] = shared.StarterGui:GetCore(Name)
            shared.StarterGui:SetCore(Name, false)
        end
        local PlayerGui = shared.Speaker:FindFirstChildOfClass("PlayerGui")
        if PlayerGui then
            for _, Gui in PlayerGui:GetChildren() do
                if Gui:IsA("ScreenGui") and Gui.Enabled then
                    ScreenGuis[#ScreenGuis + 1] = Gui
                    Gui.Enabled = false
                end
            end
        end

        CameraFieldOfView = shared.Camera.FieldOfView

        CameraType = shared.Camera.CameraType
        shared.Camera.CameraType = Enum.CameraType.Custom

        CameraCFrame = shared.Camera.CFrame
        CameraFocus = shared.Camera.Focus

        MouseIconEnabled = shared.UserInputService.MouseIconEnabled
        shared.UserInputService.MouseIconEnabled = false

        if CheckMouseLockAvailability() then
            MouseBehavior = Enum.MouseBehavior.Default
        else
            MouseBehavior = shared.UserInputService.MouseBehavior
        end
        shared.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end

    function PlayerState.Pop()
        for Name, IsEnabled in CoreGuis do
            shared.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[Name], IsEnabled)
        end
        for Name, IsEnabled in SetCores do
            shared.StarterGui:SetCore(Name, IsEnabled)
        end
        for _, Gui in ScreenGuis do
            if Gui.Parent then
                Gui.Enabled = true
            end
        end

        shared.Camera.FieldOfView = CameraFieldOfView
        CameraFieldOfView = nil

        shared.Camera.CameraType = CameraType
        CameraType = nil

        shared.Camera.CFrame = CameraCFrame
        CameraCFrame = nil

        shared.Camera.Focus = CameraFocus
        CameraFocus = nil

        shared.UserInputService.MouseIconEnabled = MouseIconEnabled
        MouseIconEnabled = nil

        shared.UserInputService.MouseBehavior = MouseBehavior
        MouseBehavior = nil
    end
end

local function StartFreecam()
    local CameraCFrame = shared.Camera.CFrame
    CameraRot = Vector2.new(CameraCFrame:toEulerAnglesYXZ())
    CameraPos = CameraCFrame.p
    CameraFov = shared.Camera.FieldOfView

    VelSpring:Reset(Vector3.new())
    PanSpring:Reset(Vector2.new())
    FovSpring:Reset(0)

    PlayerState.Push()
    shared.RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
    Input.StartCapture()
end

local function StopFreecam()
    Input.StopCapture()
    shared.RunService:UnbindFromRenderStep("Freecam")
    PlayerState.Pop()
end

do
    local Enabled = false

    local function ToggleFreecam()
        if Enabled then
            StopFreecam()
        else
            StartFreecam()
        end
        Enabled = not Enabled
    end

    local function CheckMacro(Macro)
        for Index = 1, #Macro - 1 do
            if not shared.UserInputService:IsKeyDown(Macro[Index]) then
                return
            end
        end
        ToggleFreecam()
    end

    local function HandleActivationInput(Action, State, InputObject)
        local FreecamMacroKb = FreeCamera.FreecamMacroKb
        if State == Enum.UserInputState.Begin then
            if InputObject.KeyCode == FreecamMacroKb[#FreecamMacroKb] then
                CheckMacro(FreecamMacroKb)
            end
        end
        return Enum.ContextActionResult.Pass
    end

    function FreeCamera.RebindKeys(FreecamMacroKb)
        if type(FreecamMacroKb) ~= "table" then
            return warn("FreecamMacroKb must be a table.")
        end

        for Index = 1, #FreecamMacroKb do
            if typeof(FreecamMacroKb[Index]) ~= "EnumItem" then
                return warn("FreecamMacroKb must be a table of Enum.KeyCode.")
            end
        end

        return shared.Connect:BindAction("FreecamToggle", HandleActivationInput, false, FreeCamera.ToggleInputPriority, FreecamMacroKb[#FreecamMacroKb])
    end

    FreeCamera.RebindKeys(FreeCamera.FreecamMacroKb)
end

end)() end,
    [64] = function()
local wax, _, _ = __waximport(64)

return (function()

local Universal = {}

local Support = wax.shared.ExecutorSupport

Universal.AntiAFK = {
    Enabled = false,
    
    Start = function(Enabled: boolean)
        local self = Universal.AntiAFK
        self.Enabled = Enabled

        if not Support.getconnections then return end

        for _, Connection in shared.GetConnections(shared.Speaker.Idled) do
            pcall(Connection[Enabled and "Enable" or "Disable"], Connection)
        end
    end
}

Universal.AntiKick = {
    Enabled = false,
    
    OldFunction = nil,
    OldIndex = nil,
    OldNameCall = nil,

    Start = function(Enabled: boolean)
        local self = Universal.AntiKick
        self.Enabled = Enabled

        if Enabled then
            if Support.hookfunction then
                self.OldFunction = hookfunction(shared.Speaker.Kick, function(...) end)
            end

            if Support.hookmetamethod then
                self.OldIndex = hookmetamethod(game, "__index", function(self, Key)
                    if self ~= shared.Speaker and Key:lower() ~= "kick" then
                        return self.OldIndex(self, Key)
                    end
                    return
                end)

                if Support.getnamecallmethod then
                    self.OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
                        if getnamecallmethod():lower() ~= "kick" then
                            return self.OldNameCall(self, ...)
                        end
                        return
                    end)
                end
            end
        else
            if self.OldFunction then
                hookfunction(shared.Speaker.Kick, self.OldFunction)
            end

            if self.OldIndex then
                hookmetamethod(shared.Speaker, "__index", self.OldIndex)
            end

            if self.OldNameCall then
                hookmetamethod(shared.Speaker, "__namecall", self.OldNameCall)
            end
        end
    end
}

return Universal

end)() end,
    [65] = function()
local _, _, _ = __waximport(65)

return (function()

local NPCHandler = {
    Npcs = {}
}

function NPCHandler:Init(Npc: Model)
    table.insert(self.Npcs, Npc)
    local Id = `{Npc}AncestryChanged`

    local function Disconnect()
        table.remove(self.Npcs, table.find(self.Npcs, Npc))
        shared.Connect:DisconnectSignal(Id)
        shared.Connect:DisconnectSignal(Npc)
    end

    shared.Connect:GiveSignal(Npc, Npc.Destroying:Once(Disconnect))

    shared.Connect:GiveSignal(Id, Npc.AncestryChanged:Connect(function(_, Parent: Instance?)
        if typeof(Parent) ~= "Instance" or not Parent:IsDescendantOf(shared.Workspace) then
            Disconnect()
        end
    end))
end

--// Find Npcs in the Workspace //
local function Handle(Object: Instance)
    if not Object:IsA("Humanoid") then return end

    local Parent = Object.Parent :: Model?
    if shared.Players:GetPlayerFromCharacter(Parent) then return end

    NPCHandler:Init(Parent)
end

for _, Object in shared.Workspace:GetDescendants() do
    Handle(Object)
end

shared.Connect:GiveSignal("NpcDescendantsAdded", shared.Workspace.DescendantAdded:Connect(Handle))

return NPCHandler

end)() end,
    [66] = function()
local wax, _, require = __waximport(66)

return (function()

local Universal = {}

local TempCharacter = shared.Speaker.Character
local TempHumanoid  = TempCharacter and TempCharacter:FindFirstChildOfClass("Humanoid")

local Inf     = (1 / 0)
local Toggles = wax.shared.UiManager.Library.Toggles

local ControlModule = require("../Universal/ControlModule")

Universal.WalkSpeed = {
    Enabled = false,

    DefaultSpeed = TempHumanoid and TempHumanoid.WalkSpeed or 16,
    ModedSpeed   = TempHumanoid and TempHumanoid.WalkSpeed or 16,

    Override = function(Enabled: boolean)
        local self   = Universal.WalkSpeed
        self.Enabled = Enabled

        if Enabled then
            local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
            local Humanoid  = Character:WaitForChild("Humanoid")
            
            self.DefaultSpeed  = Humanoid.WalkSpeed
            Humanoid.WalkSpeed = self.ModedSpeed

            shared.Connect:GiveSignal("WalkSpeedChangeSignal", Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                Humanoid.WalkSpeed = self.ModedSpeed
            end))

            shared.Connect:GiveSignal("WalkSpeedCharacterAdded", shared.Speaker.CharacterAdded:Connect(function(NewCharacter)
                Humanoid = NewCharacter:WaitForChild("Humanoid")

                self.DefaultSpeed  = Humanoid.WalkSpeed
                Humanoid.WalkSpeed = self.ModedSpeed

                shared.Connect:GiveSignal("WalkSpeedChangeSignal", Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    Humanoid.WalkSpeed = self.ModedSpeed
                end))
            end))
        else
            shared.Connect:DisconnectSignal("WalkSpeedChangeSignal")
            shared.Connect:DisconnectSignal("WalkSpeedCharacterAdded")

            pcall(function()
                shared.Speaker.Character.Humanoid.WalkSpeed = self.DefaultSpeed
            end)
        end
    end,

    SetSpeed = function(Speed: number)
        local self      = Universal.WalkSpeed
        self.ModedSpeed = Speed

        if self.Enabled then
            pcall(function()
                shared.Speaker.Character.Humanoid.WalkSpeed = Speed
            end)
        end
    end
}

Universal.JumpHeight = {
    Enabled = false,

    DefaultHeight = TempHumanoid and TempHumanoid.JumpHeight or 7.2,
    ModedHeight   = TempHumanoid and TempHumanoid.JumpHeight or 7.2,

    Override = function(Enabled: boolean)
        local self   = Universal.JumpHeight
        self.Enabled = Enabled

        if Enabled then
            local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
            local Humanoid  = Character:WaitForChild("Humanoid")

            self.DefaultHeight = Humanoid.JumpHeight
            Humanoid.JumpHeight = self.ModedHeight

            shared.Connect:GiveSignal("JumpHeightChangeSignal", Humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
                Humanoid.JumpHeight = self.ModedHeight
            end))

            shared.Connect:GiveSignal("JumpHeightCharacterAdded", shared.Speaker.CharacterAdded:Connect(function(NewCharacter)
                Humanoid = NewCharacter:WaitForChild("Humanoid")

                self.DefaultHeight = Humanoid.JumpHeight
                Humanoid.JumpHeight = self.ModedHeight

                shared.Connect:GiveSignal("JumpHeightChangeSignal", Humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
                    Humanoid.JumpHeight = self.ModedHeight
                end))
            end))
        else
            shared.Connect:DisconnectSignal("JumpHeightChangeSignal")
            shared.Connect:DisconnectSignal("JumpHeightCharacterAdded")

            pcall(function()
                shared.Speaker.Character.Humanoid.JumpHeight = self.DefaultHeight
            end)
        end
    end,

    SetHeight = function(Height: number)
        local self       = Universal.JumpHeight
        self.ModedHeight = Height

        if self.Enabled then
            pcall(function()
                shared.Speaker.Character.Humanoid.JumpHeight = Height
            end)
        end
    end
}

Universal.Gravity = {
    Enabled = false,

    DefaultGravity = shared.Workspace.Gravity,
    ModedGravity   = shared.Workspace.Gravity,

    Override = function(Enabled: boolean)
        local self   = Universal.Gravity
        self.Enabled = Enabled

        if Enabled then
            self.DefaultGravity      = shared.Workspace.Gravity
            shared.Workspace.Gravity = self.ModedGravity

            shared.Connect:GiveSignal("GravityChangeSignal", shared.Workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
                shared.Workspace.Gravity = self.ModedGravity
            end))
        else
            shared.Connect:DisconnectSignal("GravityChangeSignal")
            shared.Workspace.Gravity = self.DefaultGravity
        end
    end,

    SetGravity = function(Gravity: number)
        local self        = Universal.Gravity
        self.ModedGravity = Gravity

        if self.Enabled then
            shared.Workspace.Gravity = Gravity
        end
    end
}

Universal.NoAcceleration = {
    Enabled = false,

    DefaultPhysics = nil,

    Start = function(Enabled: boolean)
        local self   = Universal.NoAcceleration
        self.Enabled = Enabled

        if Enabled then
            local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
            local RootPart  = Character:WaitForChild("HumanoidRootPart")

            self.DefaultPhysics = RootPart.CustomPhysicalProperties or RootPart.CurrentPhysicalProperties or PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)

            local function Change()
                RootPart.CustomPhysicalProperties = PhysicalProperties.new(
                    100,
                    self.DefaultPhysics.Friction,
                    self.DefaultPhysics.Elasticity,
                    self.DefaultPhysics.FrictionWeight,
                    self.DefaultPhysics.ElasticityWeight
                )
            end
            Change()

            shared.Connect:GiveSignal("NoAcceleration", RootPart:GetPropertyChangedSignal("CustomPhysicalProperties"):Connect(Change))
        else
            shared.Connect:DisconnectSignal("NoAcceleration")
            pcall(function()
                shared.Speaker.Character.HumanoidRootPart.CustomPhysicalProperties = self.DefaultPhysics
            end)
        end
    end
}

Universal.AntiVoid = {
    Enabled = false,

    DefaultDestroyHeight = shared.Workspace.FallenPartsDestroyHeight,

    Start = function(Enabled: boolean)
        local self   = Universal.AntiVoid
        self.Enabled = Enabled

        if Enabled then
            self.DefaultDestroyHeight = shared.Workspace.FallenPartsDestroyHeight
            shared.Workspace.FallenPartsDestroyHeight = (0 / 0)

            shared.Connect:GiveSignal("AntiVoid", shared.Workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
                shared.Workspace.FallenPartsDestroyHeight = (0 / 0)
            end))
        else
            shared.Connect:DisconnectSignal("AntiVoid")
            shared.Workspace.FallenPartsDestroyHeight = self.DefaultDestroyHeight
        end
    end
}

Universal.SpeedBoost = {
    Enabled = false,
    Speed   = 0,

    Start = function(Enabled: boolean)
        local self   = Universal.SpeedBoost
        self.Enabled = Enabled

        if Enabled then
            shared.Connect:GiveSignal("SpeedBoost", shared.RunService.Heartbeat:Connect(function(DeltaTime)
                local Character = shared.Speaker.Character
                local Humanoid  = Character and Character:FindFirstChildOfClass("Humanoid")
                if not Humanoid then return end

                Character:TranslateBy(Humanoid.MoveDirection * self.Speed * DeltaTime)
            end))
        else
            shared.Connect:DisconnectSignal("SpeedBoost")
        end
    end
}

Universal.Noclip = {
    CharacterEnabled = false,
    VehicleEnabled   = false,

    CharacterIgnoredParts = {},

    CharacterNoclipedParts = {},
    VehicleNoclipedParts   = {},

    CharacterNoclip = function(Enabled: boolean)
        local self = Universal.Noclip
        self.CharacterEnabled = Enabled

        if Enabled then
            shared.Connect:GiveSignal("NoclipPreSimulation", shared.RunService.PreSimulation:Connect(function()
                if not shared.Speaker.Character then return end

                for _, Part in shared.Speaker.Character:GetDescendants() do
                    if self.CharacterIgnoredParts[Part] then
                        if self.CharacterNoclipedParts[Part] then
                            Part.CanCollide = true
                            self.CharacterNoclipedParts[Part] = nil
                        end

                        continue
                    end

                    if not (Part:IsA("BasePart") and Part.CanCollide) then continue end

                    Part.CanCollide = false
                    self.CharacterNoclipedParts[Part] = true
                end
            end))
        else
            shared.Connect:DisconnectSignal("NoclipPreSimulation")

            local Character = shared.Speaker.Character
            local RootPart  = Character and Character:FindFirstChild("HumanoidRootPart")

            if not RootPart then
                for Part in self.CharacterNoclipedParts do
                    if not Part:IsA("BasePart") then continue end
                    Part.CanCollide = true
                end
                return
            end

            --// Inside wall check
            local LastPosition    = RootPart.Position
            local CurrentPosition = task.wait() and not self.CharacterEnabled and RootPart.Position or LastPosition
            local Direction       = LastPosition - CurrentPosition

            if (Direction).Magnitude <= 1e-3 then return end

            local RaycastParams      = RaycastParams.new()
            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams.FilterDescendantsInstances = {Character}

            local Result = shared.Workspace:Raycast(LastPosition, Direction, RaycastParams)
            if not Result then return end

            if Result.Instance.CanCollide then
                table.clear(self.CharacterNoclipedParts)
                return
            end

            table.clear(self.CharacterNoclipedParts)
        end
    end,

    VehicleNoclip = function(Enabled: boolean)
        local self = Universal.Noclip
        self.VehicleEnabled = Enabled

        if Enabled then
            shared.Connect:GiveSignal("VehicleNoclipPreSimulation", shared.RunService.PreSimulation:Connect(function()
                local Character = shared.Speaker.Character
                local Humanoid  = Character and Character:FindFirstChildOfClass("Humanoid")
                if not Humanoid then return end

                local VehicleSeat = Humanoid.SeatPart
                if not (VehicleSeat and VehicleSeat:IsA("VehicleSeat")) then return end

                local VehicleModel = VehicleSeat.Parent
                while not VehicleModel:IsA("Model") do
                    VehicleModel = VehicleModel.Parent
                end

                for _, Part in VehicleModel:GetDescendants() do
                    if not (Part:IsA("BasePart") and Part.CanCollide) then continue end

                    Part.CanCollide = false
                    self.VehicleNoclipedParts[Part] = true
                end
            end))
        else
            shared.Connect:DisconnectSignal("VehicleNoclipPreSimulation")

            for Part in self.VehicleNoclipedParts do
                if not Part:IsA("BasePart") then continue end
                Part.CanCollide = true
            end

            table.clear(self.VehicleNoclipedParts)
        end
    end
}

Universal.NoTouch = {
    --// No touch can prevent 99% of touch damage/detection.
    --// Such as obby lava blocks, trap hitboxes...
    --// But it broke some game mechanics like door opening, etc.
    Enabled = false,

    NoTouchedParts = {},

    Start = function(Enabled: boolean)
        local self = Universal.NoTouch
        self.Enabled = Enabled

        if Enabled then
            shared.Connect:GiveSignal("NoTouchStepped", shared.RunService.PreSimulation:Connect(function()
                if not shared.Speaker.Character then return end

                for _, Part in shared.Speaker.Character:GetDescendants() do
                    if not (Part:IsA("BasePart") and Part.CanTouch) then continue end

                    if not self.NoTouchedParts[Part] then
                        Part.CanTouch = false
                        self.NoTouchedParts[Part] = true
                    end
                end
            end))
        else
            shared.Connect:DisconnectSignal("NoTouchStepped")

            for Part in self.NoTouchedParts do
                if not Part:IsA("BasePart") then continue end
                Part.CanTouch = true
            end

            table.clear(self.NoTouchedParts)
        end
    end
}

Universal.Fly = {
    Enabled = false,

    StopFlyOnDied = false,

    UseGyro      = true,
    UseUpVector  = true,
    LookToCamera = true,

    FlySpeed        = 32,
    GyroSensitivity = 500,

    ConstraintsAcceleration   = 9.375,
    ConstraintsMaxSpeed       = 32,
    ConstraintsTurnSpeed      = 7.5,
    ConstraintsResponsiveness = 100,

    PreCameraType = shared.Camera.CameraType,

    FlyMode   = "SmartFly" :: "SmartFly" | "StandFly" | "SitFly" | "VehicleFly",
    FlyMethod = "Constraints" :: "Constraints" | "BodyMovers",

    UpKeyBinding   = Enum.KeyCode.E :: Enum.KeyCode | Enum.UserInputType,
    DownKeyBinding = Enum.KeyCode.Q :: Enum.KeyCode | Enum.UserInputType,

    IsUp   = false,
    IsDown = false,

    HandleHumanoidState = function(self, Humanoid: Humanoid)
        if self.FlyMode == "SmartFly" then
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
            local Humanoid = shared.Speaker.Character.Humanoid
            Humanoid.PlatformStand = false
            Humanoid.Sit = Humanoid.SeatPart ~= nil
        end)

        pcall(function()
            shared.Camera.CameraType = self.PreCameraType or Enum.CameraType.Custom
        end)
    end,

    HandleCamera = function(self)
        pcall(function()
            if self.PreCameraType ~= Enum.CameraType.Scriptable then
                shared.Camera.CameraType = Enum.CameraType.Track
            end
        end)
    end,

    OnDied = function(self, Method)
        if self.StopFlyOnDied then
            Toggles.Fly:SetValue(false)
        else
            self[Method].Start(self, false)
            shared.Speaker.CharacterAdded:Once(function()
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
                task.wait()
            end
            self.PreCameraType = shared.Camera.CameraType

            if Enabled then
                local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
                local Humanoid  = Character:WaitForChild("Humanoid")
                local RootPart  = Humanoid.RootPart
                if not RootPart then
                    RootPart = Character:WaitForChild("HumanoidRootPart")
                end

                if not (self.Enabled or self.BodyMovers.Enabled) then return end

                self.BodyMovers.BodyVelocity          = Instance.new("BodyVelocity")
                self.BodyMovers.BodyVelocity.Name     = "EPIc_VELOCITY"
                self.BodyMovers.BodyVelocity.MaxForce = Vector3.new(Inf, Inf, Inf)
                self.BodyMovers.BodyVelocity.Velocity = Vector3.new()
                self.BodyMovers.BodyVelocity.Parent   = RootPart

                if self.UseGyro then
                    self.BodyMovers.BodyGyro           = Instance.new("BodyGyro")
                    self.BodyMovers.BodyGyro.Name      = "EPIc_VELOCITY"
                    self.BodyMovers.BodyGyro.P         = 9e4
                    self.BodyMovers.BodyGyro.MaxTorque = Vector3.new(Inf, Inf, Inf)
                    self.BodyMovers.BodyGyro.CFrame    = shared.Camera.CFrame
                    self.BodyMovers.BodyGyro.Parent    = RootPart
                end

                shared.Connect:GiveSignal("BodyMoversFly", shared.RunService.PreSimulation:Connect(function()
                    if not Humanoid or Humanoid.Health <= 0 then return end
                    if not (self.Enabled or self.BodyMovers.Enabled) then return end

                    self:HandleHumanoidState(Humanoid)

                    local MoveVector = ControlModule:GetMoveVector()
                    local Velocity   = -((shared.Camera.CFrame.LookVector * MoveVector.Z) - (shared.Camera.CFrame.RightVector * MoveVector.X))

                    local UpVector = self.UseUpVector and shared.Camera.CFrame.UpVector or Vector3.new(0, 1, 0)

                    if self.IsUp   then Velocity += UpVector end
                    if self.IsDown then Velocity -= UpVector end

                    self.BodyMovers.BodyVelocity.Velocity = Velocity * self.FlySpeed

                    if self.UseGyro then
                        self.BodyMovers.BodyGyro.D      = self.GyroSensitivity
                        self.BodyMovers.BodyGyro.CFrame = shared.Camera.CFrame
                    end

                    self:HandleCamera()
                end))

                shared.Connect:GiveSignal("BodyMoversFlyDied", Humanoid.Died:Once(function()
                    self:OnDied("BodyMovers")
                end))
            else
                shared.Connect:DisconnectSignal("BodyMoversFly")
                shared.Connect:DisconnectSignal("BodyMoversFlyDied")

                pcall(function()
                    self.BodyMovers.BodyVelocity:Destroy()
                    self.BodyMovers.BodyGyro:Destroy()
                end)

                self:EndProgress()
            end
        end
    },

    Constraints = {
        Enabled = false,

        LinearVelocity        = nil,
        AlignOrientation      = nil,
        AttachmentVelocity    = nil,
        AttachmentOrientation = nil,
        AttachmentWorld       = nil,

        TargetVelocity = Vector3.new(),
        TargetCFrame   = nil,

        Start = function(self, Enabled: boolean)
            self.Constraints.Enabled = Enabled

            if self.BodyMovers.Enabled and Enabled then
                self.BodyMovers.Start(self, false)
                task.wait()
            end
            self.PreCameraType = shared.Camera.CameraType

            if Enabled then
                local Character = shared.Speaker.Character or shared.Speaker.CharacterAdded:Wait()
                local Humanoid  = Character:WaitForChild("Humanoid")
                local RootPart  = Humanoid.RootPart
                if not RootPart then
                    RootPart = Character:WaitForChild("HumanoidRootPart")
                end

                if not (self.Enabled or self.Constraints.Enabled) then return end

                self.Constraints.TargetVelocity = Vector3.new()
                self.Constraints.TargetCFrame   = RootPart.CFrame

                self.Constraints.LinearVelocity        = Instance.new("LinearVelocity", RootPart)
                self.Constraints.AlignOrientation      = Instance.new("AlignOrientation", RootPart)
                self.Constraints.AttachmentVelocity    = Instance.new("Attachment", RootPart)
                self.Constraints.AttachmentOrientation = Instance.new("Attachment", RootPart)
                self.Constraints.AttachmentWorld       = Instance.new("Attachment", shared.Workspace.Terrain)

                self.Constraints.LinearVelocity.MaxForce               = Inf
                self.Constraints.LinearVelocity.VectorVelocity         = self.Constraints.TargetVelocity
                self.Constraints.LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                self.Constraints.LinearVelocity.RelativeTo             = Enum.ActuatorRelativeTo.World
                self.Constraints.LinearVelocity.Attachment0            = self.Constraints.AttachmentVelocity

                self.Constraints.AlignOrientation.MaxTorque      = Inf
                self.Constraints.AlignOrientation.Responsiveness = self.ConstraintsResponsiveness
                self.Constraints.AlignOrientation.Attachment0    = self.Constraints.AttachmentOrientation
                self.Constraints.AlignOrientation.Attachment1    = self.Constraints.AttachmentWorld

                shared.Connect:GiveSignal("ConstraintsFly", shared.RunService.Heartbeat:Connect(function(DeltaTime)
                    if not Humanoid or Humanoid.Health <= 0 then return end
                    if not (self.Enabled or self.Constraints.Enabled) then return end

                    local MoveVector    = ControlModule:GetMoveVector()
                    local MoveDirection = Vector3.new()

                    self:HandleHumanoidState(Humanoid)

                    local LookVector  = shared.Camera.CFrame.LookVector
                    local RightVector = shared.Camera.CFrame.RightVector
                    local UpVector    = self.UseUpVector and shared.Camera.CFrame.UpVector or Vector3.new(0, 1, 0)

                    local Forward = LookVector - UpVector * LookVector:Dot(UpVector)
                    if Forward.Magnitude > 1e-3 then
                        Forward = Forward.Unit
                    else
                        Forward = (LookVector - Vector3.new(0, 1, 0) * LookVector.Y).Unit
                    end

                    local Right = RightVector - UpVector * RightVector:Dot(UpVector)
                    if Right.Magnitude > 1e-3 then
                        Right = Right.Unit
                    end

                    MoveDirection = Forward * (-MoveVector.Z) + Right * MoveVector.X

                    if self.IsUp   then MoveDirection += UpVector end
                    if self.IsDown then MoveDirection -= UpVector end

                    if MoveDirection.Magnitude > 1e-3 then
                        MoveDirection = MoveDirection.Unit
                    end

                    self.Constraints.TargetVelocity = self.Constraints.TargetVelocity:Lerp(MoveDirection * self.ConstraintsMaxSpeed, DeltaTime * self.ConstraintsAcceleration)

                    self.Constraints.LinearVelocity.VectorVelocity   = self.Constraints.TargetVelocity
                    self.Constraints.AlignOrientation.Responsiveness = self.ConstraintsResponsiveness

                    if self.LookToCamera then
                        self.Constraints.AttachmentWorld.CFrame = shared.Camera.CFrame
                        self:HandleCamera()
                    elseif self.Constraints.TargetVelocity.Magnitude > 1 then
                        local FlatVelocity = Vector3.new(self.Constraints.TargetVelocity.X, 0, self.Constraints.TargetVelocity.Z)

                        if FlatVelocity.Magnitude > 1 then
                            local TargetLook = CFrame.lookAt(RootPart.Position, RootPart.Position + FlatVelocity)
                            self.Constraints.TargetCFrame = self.Constraints.TargetCFrame:Lerp(TargetLook, DeltaTime * self.ConstraintsTurnSpeed)

                            self.Constraints.AttachmentWorld.CFrame = self.Constraints.TargetCFrame
                        end
                    end
                end))

                shared.Connect:GiveSignal("ConstraintsFlyDied", Humanoid.Died:Once(function()
                    self:OnDied("Constraints")
                end))
            else
                shared.Connect:DisconnectSignal("ConstraintsFly")
                shared.Connect:DisconnectSignal("ConstraintsFlyDied")

                pcall(function()
                    self.Constraints.LinearVelocity:Destroy()
                    self.Constraints.AlignOrientation:Destroy()
                    self.Constraints.AttachmentVelocity:Destroy()
                    self.Constraints.AttachmentOrientation:Destroy()
                    self.Constraints.AttachmentWorld:Destroy()
                end)

                self:EndProgress()
            end
        end
    },

    StartFly = function(Enabled: boolean)
        local self = Universal.Fly
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

shared.Connect:GiveSignal("InputBeganFly", shared.UserInputService.InputBegan:Connect(function(Input, Processed)
    local self = Universal.Fly

    if Processed then
    elseif self.UpKeyBinding   == Input.UserInputType or self.UpKeyBinding   == Input.KeyCode then
           self.IsUp   = true
    elseif self.DownKeyBinding == Input.UserInputType or self.DownKeyBinding == Input.KeyCode then
           self.IsDown = true
    end
end))

shared.Connect:GiveSignal("InputEndedFly", shared.UserInputService.InputEnded:Connect(function(Input)
    local self  = Universal.Fly

    if     self.UpKeyBinding   == Input.UserInputType or self.UpKeyBinding   == Input.KeyCode then
           self.IsUp   = false
    elseif self.DownKeyBinding == Input.UserInputType or self.DownKeyBinding == Input.KeyCode then
           self.IsDown = false
    end
end))

return Universal

end)() end,
    [67] = function()
local _, _, _ = __waximport(67)

return (function()

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

local      IsA,         PropertyChanged
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

--[[ @private ]]
function PromptController:_ModTemplate(Property: string, Expected: boolean | number, IsMultiple: boolean?)
    for Prompt, Id in self.Instances do
        if self[`{Property}Enabled`] then
            local Value = if type(Expected) == "boolean" then Expected else (Expected * (IsMultiple and self[Property][Prompt]) or 1)

            GiveSignal(shared_Connect, `{Property}-{Id}`, Connect(PropertyChanged(Prompt, Property), function()
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

    self:_ModTemplate("HoldDuration", 0)
end

function PromptController.DistanceMultiplier(Enabled: boolean)
    local self = PromptController
    self.MaxActivationDistanceEnabled = Enabled

    self:_ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.SetMultiplier(Multiplier: number)
    local self = PromptController
    self.Multiplier = Multiplier

    self:_ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.PromptNoclip(Enabled: boolean)
    local self = PromptController
    self.RequiresLineOfSightEnabled = Enabled

    self:_ModTemplate("RequiresLineOfSight", false)
end

return PromptController

end)() end,
    [68] = function()
local wax, _, _ = __waximport(68)

return (function()

local Universal = {}

local EasingLibrary = wax.shared.EasingLibrary

Universal.FOV = {
    Enabled = false,

    DefaultFOV = shared.Camera.FieldOfView,
    ModedFOV = shared.Camera.FieldOfView,

    Start = function(Enabled: boolean)
        local self = Universal.FOV
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Camera, "FieldOfView", self.ModedFOV, "FOV")

            shared.Connect:GiveSignal("FOV", shared.Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                if not EasingLibrary.RunningTween.FOV then
                    shared.Camera.FieldOfView = self.ModedFOV
                end
            end))
        else
            shared.Connect:DisconnectSignal("FOV")
            EasingLibrary:Ease(shared.Camera, "FieldOfView", self.DefaultFOV, "FOV")
        end
    end,

    SetFOV = function(FOV: number)
        local self = Universal.FOV
        self.ModedFOV = FOV

        if self.Enabled then
            EasingLibrary:Ease(shared.Camera, "FieldOfView", FOV, "FOV")
        end
    end
}

Universal.MaxZoom = {
    Enabled = false,

    DefaultZoom = shared.Speaker.CameraMaxZoomDistance,
    ModedZoom = shared.Speaker.CameraMaxZoomDistance,

    Start = function(Enabled: boolean)
        local self = Universal.MaxZoom
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", self.ModedZoom, "MaxZoom")

            shared.Connect:GiveSignal("MaxZoom", shared.Speaker:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
                if not EasingLibrary.RunningTween.MaxZoom then
                    shared.Speaker.CameraMaxZoomDistance = self.ModedZoom
                end
            end))
        else
            shared.Connect:DisconnectSignal("MaxZoom")
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", self.DefaultZoom, "MaxZoom")
        end
    end,

    SetZoom = function(Zoom: number)
        local self = Universal.MaxZoom
        self.ModedZoom = Zoom

        if self.Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", Zoom, "MaxZoom")
        end
    end
}

Universal.MinZoom = {
    Enabled = false,

    DefaultZoom = shared.Speaker.CameraMinZoomDistance,
    ModedZoom = shared.Speaker.CameraMinZoomDistance,

    Start = function(Enabled: boolean)
        local self = Universal.MinZoom
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", self.ModedZoom, "MinZoom")

            shared.Connect:GiveSignal("MinZoom", shared.Speaker:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
                if not EasingLibrary.RunningTween.MinZoom then
                    shared.Speaker.CameraMinZoomDistance = self.ModedZoom
                end
            end))
        else
            shared.Connect:DisconnectSignal("MinZoom")
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", self.DefaultZoom, "MinZoom")
        end
    end,

    SetZoom = function(Zoom: number)
        local self = Universal.MinZoom
        self.ModedZoom = Zoom

        if self.Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", Zoom, "MinZoom")
        end
    end
}

return Universal

end)() end
} -- [RefId] = Closure

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
                2,
                2,
                {
                    "Mappings"
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
                                    },
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
                                8,
                                2,
                                {
                                    "Universal"
                                }
                            },
                            {
                                5,
                                1,
                                {
                                    "The Foundation"
                                },
                                {
                                    {
                                        6,
                                        2,
                                        {
                                            "Game"
                                        }
                                    },
                                    {
                                        7,
                                        2,
                                        {
                                            "Lobby"
                                        }
                                    }
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
                                25,
                                1,
                                {
                                    "Universal"
                                },
                                {
                                    {
                                        31,
                                        2,
                                        {
                                            "6.Trolls"
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
                                        29,
                                        2,
                                        {
                                            "4.ESP"
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
                                        26,
                                        2,
                                        {
                                            "1.Main"
                                        }
                                    },
                                    {
                                        27,
                                        2,
                                        {
                                            "2.Players"
                                        }
                                    }
                                }
                            },
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
                                                15,
                                                2,
                                                {
                                                    "4.ESP"
                                                }
                                            },
                                            {
                                                13,
                                                2,
                                                {
                                                    "2.Players"
                                                }
                                            },
                                            {
                                                12,
                                                2,
                                                {
                                                    "1.Main"
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
                                                19,
                                                2,
                                                {
                                                    "1.Main"
                                                }
                                            },
                                            {
                                                20,
                                                2,
                                                {
                                                    "2.Players"
                                                }
                                            },
                                            {
                                                22,
                                                2,
                                                {
                                                    "4.ESP"
                                                }
                                            },
                                            {
                                                23,
                                                2,
                                                {
                                                    "5.Exploits"
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
                                                24,
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
                        59,
                        2,
                        {
                            "Services"
                        }
                    },
                    {
                        56,
                        2,
                        {
                            "LiteralBlank"
                        }
                    },
                    {
                        45,
                        1,
                        {
                            "Gui"
                        },
                        {
                            {
                                51,
                                1,
                                {
                                    "Obsidian"
                                },
                                {
                                    {
                                        54,
                                        2,
                                        {
                                            "ThemeManager"
                                        }
                                    },
                                    {
                                        52,
                                        2,
                                        {
                                            "Library"
                                        }
                                    },
                                    {
                                        53,
                                        2,
                                        {
                                            "SaveManager"
                                        }
                                    }
                                }
                            },
                            {
                                50,
                                2,
                                {
                                    "Lucide"
                                }
                            },
                            {
                                55,
                                2,
                                {
                                    "UiManager"
                                }
                            },
                            {
                                46,
                                1,
                                {
                                    "Linoria"
                                },
                                {
                                    {
                                        48,
                                        2,
                                        {
                                            "SaveManager"
                                        }
                                    },
                                    {
                                        49,
                                        2,
                                        {
                                            "ThemeManager"
                                        }
                                    },
                                    {
                                        47,
                                        2,
                                        {
                                            "Library"
                                        }
                                    }
                                }
                            }
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
                        44,
                        2,
                        {
                            "FileHelper"
                        }
                    },
                    {
                        57,
                        2,
                        {
                            "MSESP"
                        }
                    },
                    {
                        60,
                        1,
                        {
                            "Universal"
                        },
                        {
                            {
                                66,
                                2,
                                {
                                    "Player"
                                }
                            },
                            {
                                61,
                                2,
                                {
                                    "Aimbot"
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
                                63,
                                2,
                                {
                                    "FreeCamera"
                                }
                            },
                            {
                                62,
                                2,
                                {
                                    "ControlModule"
                                }
                            },
                            {
                                65,
                                2,
                                {
                                    "NPCHandler"
                                }
                            },
                            {
                                64,
                                2,
                                {
                                    "MISC"
                                }
                            }
                        }
                    },
                    {
                        58,
                        2,
                        {
                            "Prediction"
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
                        41,
                        2,
                        {
                            "Connect"
                        }
                    },
                    {
                        43,
                        2,
                        {
                            "ExecutorSupport"
                        }
                    }
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
local SharedEnvironment = {}

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
        end)

        if not RunSuccess then
            error(ErrorMessage, 0) -- Use level 0 to directly throw the fully formatted error
        end
        return
    else
        -- Module script logic
        local PCallReturn
        local RunSuccess, ErrorMessage = xpcall(function()
            PCallReturn = {Closure()}
        end, function(msg)
            return FormatError(debug.traceback(msg, 2))
        end)

        if not RunSuccess then
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
function __waximport(refId)
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

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

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
