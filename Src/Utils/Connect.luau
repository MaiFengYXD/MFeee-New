local tableclear
    = table.clear

local ConnectionManager = {}

local Connections       = {}
local RenderConnections = {}
local ActionConnections = {}

type Priority = {Value: number} | number

function ConnectionManager:GiveSignal(
    Index: string?,
    Signal: RBXScriptSignal | RBXScriptConnection
): RBXScriptConnection
    Connections[Index] = Connections[Index] and Connections[Index]:Disconnect() or Signal
    return Connections[Index]
end

function ConnectionManager:BindRenderStep(
    Index:     string?,
    Priority:  Priority,
    Function: (number) -> nil
): RBXScriptConnection
    if type(Priority) ~= "number" then Priority = Priority.Value;end

    shared.RunService:UnbindFromRenderStep(Index)
    shared.RunService:BindToRenderStep(Index, Priority, Function)

    RenderConnections[Index] = Function
    return RenderConnections[Index]
end

function ConnectionManager:BindAction(
    Index:     string?,
    Function: (any) -> nil,
    TouchIcon: boolean?,
    Priority:  Priority,
    ...:       EnumItem
): RBXScriptConnection
    local Enums = {...}
    local IsNormal = false

    if not Priority then IsNormal = true
    elseif type(Priority) ~= "number" then Priority = Priority.Value end

    shared.ContextActionService:UnbindAction(Index)

    if IsNormal then
        shared.ContextActionService:BindAction(Index, Function, TouchIcon, unpack(Enums))
    else
        shared.ContextActionService:BindActionAtPriority(Index, Function, TouchIcon, Priority, unpack(Enums))
    end

    ActionConnections[Index] = Function
    return tableclear(Enums) or ActionConnections[Index]
end

function ConnectionManager:DisconnectSignal(Index: string?)
    Connections[Index] = Connections[Index] and Connections[Index]:Disconnect()
end

function ConnectionManager:UnbindRenderStep(Index: string?)
    RenderConnections[Index] = shared.RunService:UnbindFromRenderStep(Index)
end

function ConnectionManager:UnbindAction(Index: string?)
    ActionConnections[Index] = shared.ContextActionService:UnbindAction(Index)
end

return ConnectionManager
