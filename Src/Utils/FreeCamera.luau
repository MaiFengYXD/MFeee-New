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

        return shared.Connection:BindAction("FreecamToggle", HandleActivationInput, false, FreeCamera.ToggleInputPriority, FreecamMacroKb[#FreecamMacroKb])
    end

    FreeCamera.RebindKeys(FreeCamera.FreecamMacroKb)
end
