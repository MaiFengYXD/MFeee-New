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

    function GetMousePosition(): Vector2
        return if Fov.FollowMouse and MouseEnabled then
            GetMouseLocation(UserInputService)
        else Camera.ViewportSize / 2
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

    local AimbotKeybind = wax.shared.UIManager.Options.AimbotKeybind
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
