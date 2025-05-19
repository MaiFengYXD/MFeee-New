--[[
Rewrite 2

Including:
+ Fov
+ Aimbot
+ SilentAim
--]]

local Shared = {
    Enabled         = false :: boolean,

    TeamCheck       = true  :: boolean,
    AliveCheck      = true  :: boolean,
    FilterCheck     = true  :: boolean,
    WallCheck       = true  :: boolean,
    ForceFieldCheck = true  :: boolean,

    FilteredPlayers = {} :: array,

    TeamCheckMethod  = "TeamColor" :: "TeamColor" | "Team",
    WallCheckMethod  = "GetPartsObscuringTarget" :: "GetPartsObscuringTarget" | "Raycast",
    PlayerFilterMode = "Blacklist" :: "Blacklist" | "Whitelist"
}

local Workspace = shared.Workspace :: Workspace
local Camera    = shared.Camera    :: Camera

shared.Connect:GiveSignal("AimbotCameraChanged", Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end))

local Prediction = require("../Prediction")
local Entities   = require("../Entities")

local GetMousePosition: () -> Vector2,
      TeamChecker:   (Player:   Player)   -> boolean,
      FilterChecker: (Player:   Player)   -> boolean,
      WallChecker:   (Original: Vector3?) -> boolean

do
    
end

local Fov = {
    Replaced = not wax.shared.ExecutorSupport.Drawing :: boolean,

    Enabled = false :: boolean,
    Visible = true  :: boolean,

    Filled   = false :: boolean,
    Radius   = 150   :: number,
    NumSides = 60    :: number,

    FollowMouse = true :: boolean,
    Position    = Vector2.new() :: Vector2,

    Circle = {
        Object  = nil   :: (CircleDrawing | UIStroke)?,
        Rainbow = false :: boolean,

        RainbowSpeed = 0.4 :: number,
        Transparency = 0.6 :: number,
        Thickness    = 3   :: number,

        Color = Color3.fromHex("1f6feb") :: Color3,
    },

    Outline = {
        Object  = nil   :: (CircleDrawing | UIStroke)?,
        Rainbow = false :: boolean,

        RainbowSpeed = 0.4 :: number,
        Transparency = 0.6 :: number,
        Thickness    = 2   :: number,

        Color = Color3.fromHex("0d1117") :: Color3,
    }
};do
    local getrainbowcolor
        = getrainbowcolor

    local UserInputService = shared.UserInputSerivce :: UserInputService
    local GetMouseLocation = UserInputService.GetMouseLocation

    function GetMousePosition()
        if Fov.FollowMouse and UserInputService.MouseEnabled then
            return GetMouseLocation(UserInputService)
        end
        return Camera.ViewportSize / 2
    end

    if Fov.Replaced then
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
            Circle.Color        = Fov.Circle.Rainbow and getrainbowcolor(Fov.Circle.RainbowSpeed) or Fov.Circle.Color
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

        wax.shared.AddOnUnload(Circle .Remove, Circle)
        wax.shared.AddOnUnload(Outline.Remove, Outline)
    else
        local Instance_new, randomstring, UDim2_fromOffset
            = Instance.new, randomstring, UDim2.fromOffset

        local function Vector2ToUDim2(Vector2: Vector2): UDim2
            return UDim2_fromOffset(Vector2.X, Vector2.Y)
        end

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
            local UDim2_Position   = Vector2ToUDim2(Position)

            local CircleColor  = Fov.Circle.Rainbow and getrainbowcolor(Fov.Circle.RainbowSpeed) or Fov.Circle.Color

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

        wax.shared.AddOnUnload(function()
            ScreenGui:Destroy() --/ Don't use (ScreenGui.Destroy, ScreenGui)
        end)
        ScreenGui = nil :: any
    end
end
