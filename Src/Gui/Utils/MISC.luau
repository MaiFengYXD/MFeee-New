local type, string_gsub, debug_traceback, string_find, string_sub, task_spawn
    = type, string.gsub, debug.traceback, string.find, string.sub, task.spawn

local Camera = shared.Camera

shared.Connect.CommonSignals.CameraChanged(function(NewCamera: Camera)
    Camera = NewCamera
end)

local function SafeCallback(Callback: Function?, ...: any): (boolean, ...any)
    if not Callback or type(Callback) ~= "function" then
        return false, "No function provided"
    end

    return xpcall(Callback, function(Error: string)
        local Traceback = string_gsub(debug_traceback(), "\n", " ")
        local _, Index  = string_find(Traceback, ":%d+ ")

        Error ..= ` - {string_gsub(string_sub(Traceback, (Index or 0) + 1), " :", ":")}`
        task_spawn(error, Error)

        return Error
    end, ...)
end

local function IsOutOfBounds(Object: GuiObject): boolean
    local ViewportSize = Camera.ViewportSize

    local AbsoluteSize     = Object.AbsoluteSize
    local AbsolutePosition = Object.AbsolutePosition

    local AbsolutePositionX = AbsolutePosition.X
    local AbsolutePositionY = AbsolutePosition.Y

    return (
        AbsolutePositionX < 0 or
        (AbsolutePositionX + AbsoluteSize.X) > ViewportSize.X or
        AbsolutePositionY < 0 or
        (AbsolutePositionY + AbsoluteSize.Y) > ViewportSize.Y
    )  
end

return {
    SafeCallback  = SafeCallback,
    IsOutOfBounds = IsOutOfBounds
}
