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

            if CurrentValue == CurrentValue and CurrentValue ~= Moded then
                PlayerVariables[Name] = CurrentValue
            end
        end)

        wax.AddOnUnload(Connections[ConnectId].Disconnect, Connections[ConnectId])
    end

    BindVariableMonitor("CameraMaxZoomDistance", shared.Speaker, 0.5)
    BindVariableMonitor("CameraMinZoomDistance", shared.Speaker, 0.5)
    BindVariableMonitor("CameraMode", shared.Speaker, Enum.CameraMode.LockFirstPerson)
    BindVariableMonitor("CameraSubject", shared.Camera.CameraSubject, RootPart)
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
            shared.Camera.CameraSubject = RootPart

            IsUp   = FindUpDown("Up")
            IsDown = FindUpDown("Down")

            StepRootPart(DeltaTime)
        end))
    else
        shared.Connect:GiveSignal("StepFreeCamera", Connect(shared.RunService.PreRender, function()
            RootPart.CFrame = Camera.CFrame
        end))

        shared.Speaker.CameraSubject = PlayerVariables.CameraSubject
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
