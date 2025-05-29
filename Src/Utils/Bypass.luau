local type, debug_info, unpack, string_find, checkcaller
    = type, debug.info, unpack, string.find, checkcaller

wax.shared.BypassedMethod = nil

if not wax.shared.ExecutorSupport.hookfunction then
    return {}
end

local Old_debug_info

if wax.shared.ExecutorSupport.getgc then
    xpcall(function(
        type:       typeof(type),
        debug_info: typeof(debug.info)
    )
        for _, Grabage in getgc(true) do
            if type(Grabage) ~= "table" then continue end

            local Detected = Grabage.Detected
            if not Detected or type(Detected) ~= "function" or debug_info(Detected, "s") ~= ".Core.Anti" then
                continue
            end

            wax.shared.BypassedMethod = "Adonis"

            Old_debug_info = hookfunction(debug_info, function(
                FunctionOrLevel: number | Function,
                ...: any
            )
                if FunctionOrLevel == Detected and not checkcaller() then
                    repeat until not task.wait(9e9)
                end

                return Old_debug_info(FunctionOrLevel, ...)
            end)
        end
    end, function()
        wax.shared.BypassedMethod = nil
    end, type, debug_info)
end

if wax.shared.BypassedMethod then
    return {}
end

wax.shared.BypassedMethod = "Universal"

local Metamethods = {};do
    xpcall(function()
        local _ = game.________
    end, function()
        Metamethods.index = debug_info(2, "f")
    end)

    xpcall(function()
        game:________()
    end, function()
        Metamethods.namecall = debug_info(2, "f")
    end)

    xpcall(function()
        game.________ = ""
    end, function()
        Metamethods.newindex = debug_info(2, "f")
    end)
end

Old_debug_info = hookfunction(debug_info, function(
    FunctionOrLevel: number | Function,
    ...: any
)
    if checkcaller() then
        return Old_debug_info(FunctionOrLevel, ...)
    end

    local Result = {Old_debug_info(FunctionOrLevel, ...)}

    if Metamethods[Old_debug_info(FunctionOrLevel, "f")] then
        local Source = string_find(..., "s")
        local Arity  = string_find(..., "a")
        local Name   = string_find(..., "n")
        local Line   = string_find(..., "l")

        for Index in Result do
            if Index == Source then
                Result[Index] = "[C]"
            elseif Index == Arity then
                Result[Index] = 0
            elseif Index == Name then
                Result[Index] = ""
            elseif Index == Line then
                Result[Index] = -1
            end
        end
    end

    return unpack(Result)
end)

return {}
