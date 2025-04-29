local Vector3new
    = Vector3.new

local mathmin
    = math.min

local OriginControlModule = shared.Speaker:WaitForChild("PlayerScripts", 3):WaitForChild("PlayerModule", 3):WaitForChild("ControlModule", 3)

if OriginControlModule and wax.shared.ExecutorSupport.require then
    return require(OriginControlModule)
end

local ControlModule = {
    GamepadMoveVector    = Vector3new(),
    ThumbstickMoveVector = Vector3new(),
    ThumbstickRadius   = 15,
    TouchInput         = nil,
    TouchStartPosition = nil
};do
    local self      = ControlModule
    local Service   = shared.UserInputService :: UserInputService
    local IsKeyDown = Service.IsKeyDown

    function self:GetMoveVector(): Vector3
        local X, Z = 0, 0

        if IsKeyDown(Service, Enum.KeyCode.W) then Z -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.S) then Z += 1 end
        if IsKeyDown(Service, Enum.KeyCode.A) then X -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.D) then X += 1 end

        if IsKeyDown(Service, Enum.KeyCode.Up  ) then Z -= 1 end
        if IsKeyDown(Service, Enum.KeyCode.Down) then Z += 1 end

        return Vector3new(X, 0, Z) + self.ThumbstickMoveVector + self.GamepadMoveVector
    end

    shared.Connection:GiveSignal("ControlModuleInputChanged", Service.InputChanged:Connect(function(Input: InputObject, Processed: boolean)
        if Processed then return end

        if Input.UserInputType == Enum.UserInputType.Gamepad1 and Input.KeyCode == Enum.KeyCode.Thumbstick1 then
            self.GamepadMoveVector = Vector3new(Input.Position.X, 0, -Input.Position.Y)
        end
    end))

    shared.Connection:GiveSignal("ControlModuleTouchStarted", Service.TouchStarted:Connect(function(Input: InputObject)
        self.TouchInput = Input
        self.TouchStartPosition = Input.Position
    end))

    shared.Connection:GiveSignal("ControlModuleTouchMoved", Service.TouchMoved:Connect(function(Input: InputObject)
        if Input ~= self.TouchInput then return end

        if not (self.TouchStartPosition and Input.Position) then return end

        local MoveDirection    = (Input.Position - self.TouchStartPosition).Unit
        local Distance         = mathmin((Input.Position - self.TouchStartPosition).Magnitude, self.ThumbstickRadius)
        local AdjustedDistance = Distance / self.ThumbstickRadius

        self.ThumbstickMoveVector = Vector3new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Y * AdjustedDistance)
    end))

    shared.Connection:GiveSignal("ControlModuleTouchEnded", Service.TouchEnded:Connect(function(Input: InputObject)
        if Input ~= self.TouchInput then return end

        self.ThumbstickMoveVector = Vector3new()
        self.TouchInput = nil
    end))
end

return ControlModule
