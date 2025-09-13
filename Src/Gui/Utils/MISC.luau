local type, string_gsub, debug_traceback, string_find, string_sub, task_spawn, table_clone, UDim2_fromOffset
    = type, string.gsub, debug.traceback, string.find, string.sub, task.spawn, table.clone, UDim2.fromOffset

local Camera = shared.Camera

shared.Connect.CommonSignals.CameraChanged(function(NewCamera: Camera)
    Camera = NewCamera
end)

local MISC = {};do
    function MISC.SafeCallback(Callback: Function?, ...: any): (boolean, ...any)
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

    function MISC.Validate(Input: table, Template: table): table
        local Output = table_clone(Template)

        for Key, Value in Input do
            if type(Value) ~= type(Template[Key]) then continue end
            Output[Key] = Value
        end

        return Output
    end

    function MISC.IsOutOfBounds(Object: GuiObject): boolean
        local ViewportSize = Camera.ViewportSize

        local AbsoluteSize     = Object.AbsoluteSize
        local AbsolutePosition = Object.AbsolutePosition

        local AbsolutePositionX = AbsolutePosition.X
        local AbsolutePositionY = AbsolutePosition.Y

        return (
            AbsolutePositionX < 0 or
            AbsolutePositionY < 0 or
            (AbsolutePositionX + AbsoluteSize.X) > ViewportSize.X or
            (AbsolutePositionY + AbsoluteSize.Y) > ViewportSize.Y
        )  
    end

    function MISC.UDim2ToOffset(UDim2: UDim2, AbsoluteSize: Vector2): UDim2
        return UDim2_fromOffset(
            UDim2.X.Scale * AbsoluteSize.X + UDim2.X.Offset,
            UDim2.Y.Scale * AbsoluteSize.Y + UDim2.Y.Offset
        )
    end
end

return MISC
