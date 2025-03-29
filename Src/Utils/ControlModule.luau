if wax.shared.ExecutorSupport.require then
    return require(shared.Speaker:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end

local ControlModule = {
    GamepadMoveVector = Vector3.new(),
    ThumbstickMoveVector = Vector3.new(),
    ThumbstickRadius = 15,
    TouchInput = nil,
    TouchStartPosition = nil
}

function ControlModule:GetMoveVector(): Vector3
    local X, Z = 0, 0

    if shared.UserInputService:IsKeyDown(Enum.KeyCode.W) then Z -= 1 end
    if shared.UserInputService:IsKeyDown(Enum.KeyCode.S) then Z += 1 end
    if shared.UserInputService:IsKeyDown(Enum.KeyCode.A) then X -= 1 end
    if shared.UserInputService:IsKeyDown(Enum.KeyCode.D) then X += 1 end

    if shared.UserInputService:IsKeyDown(Enum.KeyCode.Up) then Z -= 1 end
    if shared.UserInputService:IsKeyDown(Enum.KeyCode.Down) then Z += 1 end

    return Vector3.new(X, 0, Z) + ControlModule.ThumbstickMoveVector + ControlModule.GamepadMoveVector
end

shared.Connection:GiveSignal("ControlModuleInputChanged", shared.UserInputService.InputChanged:Connect(function(Input, Processed)
    if Processed then return end

    if Input.UserInputType == Enum.UserInputType.Gamepad1 and Input.KeyCode == Enum.KeyCode.Thumbstick1 then
        ControlModule.GamepadMoveVector = Vector3.new(Input.Position.X, 0, -Input.Position.Y)
    end
end))

shared.Connection:GiveSignal("ControlModuleTouchStarted", shared.UserInputService.TouchStarted:Connect(function(Input)
    ControlModule.TouchInput = Input
    ControlModule.TouchStartPosition = Input.Position
end))

shared.Connection:GiveSignal("ControlModuleTouchMoved", shared.UserInputService.TouchMoved:Connect(function(Input)
    if Input ~= ControlModule.TouchInput then return end

    if not (ControlModule.TouchStartPosition and Input.Position) then return end

    local MoveDirection = (Input.Position - ControlModule.TouchStartPosition).Unit
    local Distance = math.min((Input.Position - ControlModule.TouchStartPosition).Magnitude, ControlModule.ThumbstickRadius)
    local AdjustedDistance = Distance / ControlModule.ThumbstickRadius

    ControlModule.ThumbstickMoveVector = Vector3.new(MoveDirection.X * AdjustedDistance, 0, MoveDirection.Y * AdjustedDistance)
end))

shared.Connection:GiveSignal("ControlModuleTouchEnded", shared.UserInputService.TouchEnded:Connect(function(Input)
    if Input ~= ControlModule.TouchInput then return end

    ControlModule.ThumbstickMoveVector = Vector3.new()
    ControlModule.TouchInput = nil
end))

return ControlModule
