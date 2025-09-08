local type, string_gsub, debug_traceback, string_find, string_sub, task_spawn
    = type, string.gsub, debug.traceback, string.find, string.sub, task.spawn

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

return {
    SafeCallback = SafeCallback
}
