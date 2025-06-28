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
