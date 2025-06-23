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

local Toggles = wax.shared.UIManager.Library.Toggles

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
                        if CurrentValue == CurrentValue and CurrentValue ~= self.Moded then
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
                    if CurrentValue == CurrentValue and CurrentValue ~= self.Moded then
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
                if CurrentValue == CurrentValue and CurrentValue ~= Moded then
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
                if CurrentValue == CurrentValue and CurrentValue ~= CurrentValue then return end

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
