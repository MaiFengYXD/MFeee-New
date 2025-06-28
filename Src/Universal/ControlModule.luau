if shared.ExecutorSupport.require then
    local OriginControlModule = shared.Speaker:WaitForChild("PlayerScripts", 3):WaitForChild("PlayerModule", 3):WaitForChild("ControlModule", 3)

    if OriginControlModule then
        return wax.require(OriginControlModule)
    end
end

local ControlModule = {
    GamepadMoveVector    = Vector3.new(),
    ThumbstickMoveVector = Vector3.new(),
    ThumbstickRadius     = 15,
    TouchInput           = nil :: InputObject?,
    TouchStartPosition   = nil :: Vector3?
};do
    local Vector3_new, math_min
        = Vector3.new, math.min

    local self      = ControlModule
    local Service   = shared.UserInputService :: UserInputService
    local IsKeyDown = Service.IsKeyDown

    local W, A, S, D, Up, Down, Gamepad1, Thumbstick1;do
        local KeyCode = Enum.KeyCode

        W = KeyCode.W
        A = KeyCode.A
        S = KeyCode.S
        D = KeyCode.D

        Up   = KeyCode.Up
        Down = KeyCode.Down

        Thumbstick1 = KeyCode.Thumbstick1
        Gamepad1    = Enum.UserInputType.Gamepad1
    end

    function self:GetMoveVector(): Vector3
        local X, Z = 0, 0

        if IsKeyDown(Service, W) then Z -= 1 end
        if IsKeyDown(Service, A) then X -= 1 end
        if IsKeyDown(Service, S) then Z += 1 end
        if IsKeyDown(Service, D) then X += 1 end

        if IsKeyDown(Service, Up  ) then Z -= 1 end
        if IsKeyDown(Service, Down) then Z += 1 end

        return Vector3_new(X, 0, Z) + self.ThumbstickMoveVector + self.GamepadMoveVector
    end

    shared.Connect:GiveSignal("ControlModuleInputChanged", Service.InputChanged:Connect(function(Input: InputObject, Processed: boolean)
        if Processed then return end

        if Input.UserInputType == Gamepad1 and Input.KeyCode == Thumbstick1 then
            self.GamepadMoveVector = Vector3_new(Input.Position.X, 0, -Input.Position.Y)
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
        local Distance         = math_min((Input.Position - self.TouchStartPosition).Magnitude, self.ThumbstickRadius)
        local AdjustedDistance = Distance / self.ThumbstickRadius

        self.ThumbstickMoveVector = Vector3_new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Y * AdjustedDistance)
    end))

    shared.Connect:GiveSignal("ControlModuleTouchEnded", Service.TouchEnded:Connect(function(Input: InputObject)
        if Input ~= self.TouchInput then return end

        self.ThumbstickMoveVector = Vector3_new()
        self.TouchInput = nil
    end))
end

return ControlModule
