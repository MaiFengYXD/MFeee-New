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
