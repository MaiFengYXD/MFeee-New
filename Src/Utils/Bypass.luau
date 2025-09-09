local debug_info, checkcaller, xpcall
    = debug.info, checkcaller, xpcall

shared.BypassedMethod = nil

if not (
    shared.ExecutorSupport.hookfunction and
    shared.ExecutorSupport.checkcaller
) then
    return {}
end

local Old_debug_info

if shared.ExecutorSupport.getgc then
    xpcall(function(
        type:        typeof(type),
        rawget:      typeof(rawget),
        debug_info:  typeof(debug.info),
        checkcaller: typeof(checkcaller)
    )
        for _, Garbage: table in getgc(true) do
            if type(Garbage) ~= "table" then continue end

            local Detected = rawget(Garbage, "Detected") :: (string, string, boolean) -> boolean

            if not Detected or (
                type(Detected) ~= "function" or
                debug_info(Detected, "s") ~= ".Client.Core.Anti"
            ) then continue end

            shared.BypassedMethod = "Adonis"

            Old_debug_info = hookfunction(debug_info, function(...)
                if not checkcaller() and Old_debug_info(..., "f") == debug_info then
                    repeat until not task.wait(9e9)
                end

                return Old_debug_info(...)
            end)
        end
    end, function()
        shared.BypassedMethod = nil
    end, type, rawget, debug_info, checkcaller)
end

if shared.BypassedMethod then
    return {}
end

--[[
--/ Default a anti-hook bypass
xpcall(function(
    xpcall:      typeof(xpcall),
    debug_info:  typeof(debug.info),
    checkcaller: typeof(checkcaller),
    string_find: typeof(string.find),
    unpack:      typeof(unpack)
)
    local Metamethods = {};do
        local function GetMetamethod(Function)
            xpcall(Function, function()
                Metamethods[debug_info(2, "f")] = true
            end)
        end

        GetMetamethod(function()
            local _ = game.________
        end)

        GetMetamethod(function()
            game.________ = 123
        end)

        GetMetamethod(function()
            game:________()
        end)

        GetMetamethod(function()
            local _ = (Enum :: any).Axis.________
        end)

        GetMetamethod(function()
            (Enum :: any).Axis:________()
        end)
    end

    Old_debug_info = hookfunction(debug_info, function(...)
        if checkcaller() then
            return Old_debug_info(...)
        end

        local Result   = {Old_debug_info(...)}
        local Checking = Old_debug_info(..., "f")
        local IsInfo   = Checking == debug_info

        if IsInfo or Metamethods[Checking] then
            local string_find
                = string_find

            local Source = string_find(..., "s")
            local Arity  = string_find(..., "a")
            local Name   = string_find(..., "n")
            local Line   = string_find(..., "l")

            local Extra  = 0

            for Index in Result do
                Index += Extra

                if Index == Source then
                    Result[Index] = "[C]"
                elseif Index == Arity then
                    Extra += 1
                    Result[Index] = 0
                    Result[Index + 1] = true
                elseif Index == Name then
                    Result[Index] = IsInfo and "info" or ""
                elseif Index == Line then
                    Result[Index] = -1
                end
            end
        end

        return unpack(Result)
    end)
end, function()
    shared.BypassedMethod = nil
end, xpcall, debug_info, checkcaller, string.find, unpack)
--]]

return {}
