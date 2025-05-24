--[[
Rewrite 2

Including:
+ Fov
+ Aimbot
+ SilentAim
--]]

local table_find, RaycastParams_new
    = table.find, RaycastParams.new

local      IsA
    = game.IsA

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

local Workspace = shared.Workspace :: Workspace
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

    shared.Connect:GiveSignal("AimbotCharacterChanged", Speaker:GetPropertyChangedSignal("Character"):Connect(function()
        Character = Speaker.Character
        SetUpPositionMonitor(Character)
    end))
end

local _Target: BasePart?

local Raycast = Workspace.Raycast

local Prediction = require("../Prediction")
local Entities   = require("../Entities")

local Fov

--// Helper Functions //
local GetMousePosition: () -> Vector2,

      TeamChecker:       (Player: Player) -> boolean,
      AliveChecker:      (Player: Player | Model, IsNpc: boolean | nil) -> boolean,
      FilterChecker:     (Player: Player) -> boolean,
      ForceFieldChecker: (Player: Player | Model, IsNpc: boolean | nil) -> boolean,
      CommonChecker:     (Player: Player | Model, IsNpc: boolean | nil) -> boolean,

      OnScreenChecker:   (Target:   Vector3) -> boolean,
      WallChecker:       (Original: Vector3,       Direction: Vector3, ...any & Instance) -> boolean,
      DistanceChecker:   (Original: Vector3 | nil, Target:    Vector3) -> boolean,

      GetPriorities:     () -> ("Players" | "Npcs" | nil, "Players" | "Npcs" | nil),
      GetHitPart:        (Head: BasePart?, RootPart: BasePart?)  -> nil | BasePart,
      EasyGetHitPart:    (Head: BasePart?, RootPart: BasePart?)  -> nil | BasePart,

      Predict:           (
          Original: Vector3,
          Target:   BasePart,
          Humanoid: Humanoid?,

          RaycastParams: RaycastParams?
      ) -> Vector3

do
    --// Team Checker
    local Teams    = shared.Teams :: Teams
    local GetTeams = Teams.GetTeams

    function TeamChecker(Player: Player): boolean
        if not Shared.TeamCheck then return false end
        if #GetTeams(Teams) < 2 then return false end

        local Key = Shared.TeamCheckMethod
        return (Player :: any)[Key] == (Speaker :: any)[Key]
    end

    --// Alive Checker
    local Players_ = Entities.Players
    local Npcs_    = Entities.Npcs

    function AliveChecker(Player: Player | Model, IsNpc: boolean | nil): boolean
        if not Shared.AliveCheck then return false end

        if IsNpc then
            return if Npcs_[Player :: Model] then not Npcs_[Player :: Model].Alive else true
        end
        return if Players_[Player :: Player] then not Players_[Player :: Player].Alive else true
    end

    --// Filter Checker
    local FilteredPlayers = Shared.FilteredPlayers

    function FilterChecker(Player: Player): boolean
        return Shared.FilterCheck and (Shared.PlayerFilterMode == "Blacklist") == (table_find(FilteredPlayers, Player) ~= nil)
    end

    --// ForceField Checker
    function ForceFieldChecker(Player: Player | Model, IsNpc: boolean | nil): boolean
        if not Shared.ForceFieldCheck then return false end

        if IsNpc then
            return if Npcs_[Player :: Model] then Npcs_[Player :: Model].ForceField ~= nil else false
        end
        return if Players_[Player :: Player] then Players_[Player :: Player].ForceField ~= nil else false
    end

    --// Common Checker
    function CommonChecker(Player: Player | Model, IsNpc: boolean | nil): boolean
        return (
            (not IsNpc and TeamChecker(Player :: Player)) or
            AliveChecker(Player, IsNpc) or
            (not IsNpc and ForceFieldChecker(Player :: Player)) or
            ForceFieldChecker(Player, IsNpc)
        )
    end

    --// On Screen Checker
    local WorldToViewportPoint = Camera.WorldToViewportPoint

    function OnScreenChecker(Target: Vector3): boolean
        if not Shared.OnScreenCheck then return false end

        local _, IsOnScreen = WorldToViewportPoint(Camera, Target)
        return IsOnScreen
    end

    --// Wall Checker
    local Exclude = Enum.RaycastFilterType.Exclude

    function WallChecker(Original: Vector3, Direction: Vector3, ...: any & Instance): boolean
        if not Shared.WallCheck then return false end

        local RaycastParam = RaycastParams_new()
        RaycastParam.FilterDescendantsInstances = {..., Character :: any}
        RaycastParam.FilterType = Exclude

        local RaycastResult = Raycast(Workspace, Original, Direction, RaycastParam)
        local HitPart = RaycastResult and RaycastResult.Instance
        if not HitPart then return false end

        return if Shared.WallCheckMethod == "CheckCanCollide" and IsA(HitPart, "BasePart") then (HitPart :: BasePart).CanCollide else false
    end

    --// Distance Checker
    local Vector2_new, math_pi, math_cos, math_sin
        = Vector2.new, math.pi, math.cos, math.sin

    local function Vector3ToVector2(Vector3: Vector3): Vector2
        return Vector2_new(Vector3.X, Vector3.Y)
    end

    local function CrossProduct2D(Position1: Vector2, Position2: Vector2, Position3: Vector2): number
        return (Position2.X - Position1.X) * (Position3.Y - Position1.Y) - (Position2.Y - Position1.Y) * (Position3.X - Position1.X)
    end

    --/ Helper function, make DistanceChecker more accurate in "triangle" fov
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

    function DistanceChecker(Original: Vector3 | nil, Target: Vector3): boolean
        if Fov.Enabled then
            local ScreenPosition, IsOnScreen = WorldToViewportPoint(Camera, Target)
            if not IsOnScreen then return true end

            local Position2D = Vector3ToVector2(ScreenPosition)
            local NumSides   = Fov.NumSides

            if Fov.PRPCheck then
                return if NumSides > 30 then
                    (Position2D - Fov.Position).Magnitude > Fov.Radius
                else not IsPointInRegularPolygon(Position2D, Fov.Position, Fov.Radius, Fov.NumSides)
            else
                return (Position2D - Fov.Position).Magnitude > Fov.Radius
            end
        end

        local Distance = (Original or SpeakerPosition - Target).Magnitude
        return not (Distance >= Shared.MinDistance and Distance <= Shared.MaxDistance)
    end

    --// Get Priority
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
            if NextNumber(Random, 0, 100) > HitChance and HitChance < 100 then nil else
            if NextNumber(Random, 0, 100) > HeadshotChance and HeadshotChance < 100 then RootPart else Head
        )
    end

    --// Easy Get HitPart
    function EasyGetHitPart(Head: BasePart?, RootPart: BasePart?): nil | BasePart
        local HitPart = GetHitPart(Head, RootPart)
        if not HitPart then return end

        local Position = HitPart.Position
        if DistanceChecker(nil, Position) then return end
        if OnScreenChecker(Position) then return end
        if WallChecker(Position, SpeakerPosition - Position, HitPart) then return end

        return HitPart 
    end

    --// Predict
    local SolveTrajectory = Prediction.SolveTrajectory
    local UniversalPlayer = require("Player")

    function Predict(
        Original: Vector3,
        Target:   BasePart,
        Humanoid: Humanoid?,

        RaycastParams: RaycastParams?
    ): Vector3
        if not Shared.Prediction.Enabled then return Original end

        local DefaultGravity = UniversalPlayer.Gravity.Default
        local PlayerHeight   = Humanoid and Humanoid.HipHeight or 2

        local Solution = SolveTrajectory(
            Original,
            Shared.Prediction.Speed,
            nil,
            Shared.Prediction.PickLongest,
            Target.Position,
            Target.AssemblyLinearVelocity,
            DefaultGravity,
            PlayerHeight,
            RaycastParams
        )

        return Solution or Original
    end
end

--// Fov //
Fov = {
    Replaced = not wax.shared.ExecutorSupport.Drawing :: boolean,

    Enabled  = false :: boolean,
    Visible  = true  :: boolean,

    PRPCheck = true :: boolean,

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
    local mousemoverel, Vector2_new, CFrame_lookAt, task_cancel, task_spawn
        = mousemoverel, Vector2.new, CFrame.lookAt, task.cancel, task.spawn

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

    local function GetTarget(): (BasePart?, Humanoid?)
        local Target:   BasePart?

        local CommonChecker = CommonChecker
        local First, Second = GetPriorities()

        local function FromPlayers(CommonChecker:(Player) -> boolean): BasePart?
            for Player, PlayerStore in Players_ do
                if CommonChecker(Player) then continue end

                local HitPart = EasyGetHitPart(PlayerStore.Head, PlayerStore.RootPart)
                if HitPart then return HitPart, PlayerStore.Humanoid end
            end

            return
        end

        local function FromNpcs(CommonChecker: (Model, boolean) -> boolean): BasePart?
            for Npc, NpcStore in Npcs_ do
                if CommonChecker(Npc, true) then continue end

                local HitPart = EasyGetHitPart(NpcStore.Head, NpcStore.RootPart)
                if HitPart then return HitPart, NpcStore.Humanoid end
            end

            return
        end

        if First == "Players" then
            Target, Humanoid = FromPlayers(CommonChecker)

            if not Target and Second == "Npcs" then
                Target, Humanoid = FromNpcs(CommonChecker)
            end
        elseif First == "Npcs" then
            Target, Humanoid = FromNpcs(CommonChecker)

            if not Target and Second == "Players" then
                Target, Humanoid = FromPlayers(CommonChecker)
            end
        end

        return Target, Humanoid
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

    local AimbotKey = wax.shared.UiManager.Options.AimbotKey
    local GetState  = AimbotKey.GetState

    local StepThread: thread?

    local function CancelLock()
        if StepThread then StepThread = task_cancel(StepThread) end
        _Target = CancelTween(EasingLibrary, "Aimbot")
    end

    Aimbot.Start = function(Enabled: boolean)
        AimbotEnabled = Enabled

        Connect[`{Enabled and "B" or "Unb"}indRenderStep`](Connect, "StepAimbot", 200, function()
            if not GetState(AimbotKey) then
                CancelLock()
                return
            end

            StepThread = task_spawn(function()
                if not (Shared.Enabled and AimbotEnabled) then return end

                if _Target then
                    if (
                        DistanceChecker(nil, _Target.Position) or
                        OnScreenChecker(_Target.Position) or
                        WallChecker(_Target.Position, SpeakerPosition - _Target.Position, _Target)
                    ) then
                        return CancelLock()
                    end

                    return Move(Predict(_Target.Position, _Target, Humanoid))
                end

                CancelLock()
                _Target, Humanoid = GetTarget()
                if not _Target then return end

                Move(Predict(_Target.Position, _Target, Humanoid))
            end)
        end)
    end
end

--// Finalize //
local AimbotModule = {}

do  --// Bundle Table and Usage Functions
    local Mode = "SilentAim" :: "Aimbot" | "SilentAim"

    local function Toggle(Enabled: boolean)
        Shared.Enabled = Enabled

        
    end

    local function SetMode(Mode: "Aimbot" | "SilentAim")
        Mode = Mode
    end
end
