local Utils = {}

local Support = wax.shared.ExecutorSupport
local UiManager = wax.shared.UiManager
local Translations = wax.shared.Translations

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
            Title = Translations:GetTranslation("Beat The Prision"),
            Description = Translations:GetTranslation("You need to beat Room 149 first!")
        })
    else
        shared.ReplicatedStorage.Events.ThePrision.FinishedTerminal:FireServer()
        UiManager:Notify({
            Title = Translations:GetTranslation("Beat The Prision"),
            Description = Translations:GetTranslation("You have beaten the prision!")
        })
    end
end

Utils.BeatFigureRooms = {
    Beating = false,

    Beat = function()
        local self = Utils.BeatFigureRooms

        if self.Beating then
            UiManager:Notify({
                Title = Translations:GetTranslation("Beat Figure Rooms"),
                Description = Translations:GetTranslation("You are already beating the rooms!")
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
                Title = Translations:GetTranslation("Beat Figure Rooms"),
                Description = Translations:GetTranslation("You are not in the right room! Please come to Room 194 first!")
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
            Title = Translations:GetTranslation("Beat Figure Rooms"),
            Description = Translations:GetTranslation("You have beaten the figure rooms!")
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
                Title = Translations:GetTranslation("Cutscene Started!"),
                Description = Translations:GetTranslation("Cutscene: %s"):format(EventName)
            })

            if EventName == "Watcher Trapped" then
                if not Support.require then
                    wax.shared.TempStorage.SkippedWarn = Instance.new("Part")

                    UiManager:Notify({
                        Title = Translations:GetTranslation("Skipped Warn"),
                        Description = Translations:GetTranslation("You might get stuck cause your executor doesn't support 'require' function, please click 'Beat The Prision' button in the 'Exploit' tab to finish it."),
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
