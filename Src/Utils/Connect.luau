local unpack, pcall, typeof, table_clear, coroutine_close, coroutine_resume
    = unpack, pcall, typeof, table.clear, coroutine.close, coroutine.resume

local _Connect   = game.Close.Connect
local Disconnect = game.Close:Once(function() end).Disconnect

local RunService = shared.RunService

local BindToRenderStep     = RunService.BindToRenderStep
local UnbindFromRenderStep = RunService.UnbindFromRenderStep

local ContextService = shared.ContextActionService

local BindAction           = ContextService.BindAction
local BindActionAtPriority = ContextService.BindActionAtPriority
local UnbindAction         = ContextService.UnbindAction

local Connect = {}

local Connections       = {}
local Threads           = {}
local RenderConnections = {}
local ActionConnections = {}

type ActionCallback = (
    ActionName:  string,
    InputState:  Enum.UserInputState,
    InputObject: InputObject
) -> (nil)

function Connect:GiveSignal(
    Index:    string?,
    Signal:   RBXScriptSignal | RBXScriptConnection,
    Callback: Function?
): RBXScriptConnection
    if Connections[Index] then self:DisconnectSignal(Index) end

    if typeof(Signal) == "RBXScriptSignal" then
        return self:GiveSignal(Index, _Connect(Signal, Callback))
    end

    Connections[Index] = Signal
    return (Signal :: RBXScriptConnection)
end

function Connect:RunThread(Index: string?, Thread: thread): thread
    if Threads[Index] then self:StopThread(Index) end
    Threads[Index] = Thread

    pcall(coroutine_resume, Thread)
    return Thread
end

function Connect:BindRenderStep(
    Index:     string?,
    Priority:  Enum.RenderPriority | number,
    Function: (number) -> nil
): (number) -> nil
    self:UnbindRenderStep(Index)

    Priority = if typeof(Priority) ~= "number" then (Priority :: Enum.RenderPriority).Value else Priority

    BindToRenderStep(RunService, Index, Priority, Function)

    RenderConnections[Index] = Function
    return RenderConnections[Index]
end

function Connect:BindAction(
    Index:     string?,
    Function:  ActionCallback,
    TouchIcon: boolean?,
    Priority:  (Enum.ContextActionPriority | number)?,
    ...:       EnumItem
): ActionCallback
    self:UnbindAction(Index)

    local Enums = {...}
    local IsNormal = false

    if typeof(Priority) ~= "EnumItem" then
        if typeof(Priority) ~= "number" then IsNormal = true end
    else
        Priority = (Priority :: Enum.ContextActionPriority).Value
    end

    if IsNormal then
        BindAction(ContextService, Index, Function, TouchIcon, unpack(Enums))
    else
        BindActionAtPriority(ContextService, Index, Function, TouchIcon, Priority, unpack(Enums))
    end

    table_clear(Enums)
    ActionConnections[Index] = Function

    return Function
end

function Connect:DisconnectSignal(Index: string?)
    if pcall(Disconnect,  Connections[Index]) then Connections[Index] = nil end
end

function Connect:StopThread(Index: string?)
    if pcall(coroutine_close, Threads[Index]) then Threads[Index] = nil end
end

function Connect:UnbindRenderStep(Index: string?)
    UnbindFromRenderStep(RunService, Index)
    RenderConnections[Index] = nil
end

function Connect:UnbindAction(Index: string?)
    UnbindAction(ContextService, Index)
    ActionConnections[Index] = nil
end

wax.AddOnUnload(function()
    local Connect
        = Connect

    local         DisconnectSignal,         StopThread,         UnbindRenderStep,         UnbindAction
        = Connect.DisconnectSignal, Connect.StopThread, Connect.UnbindRenderStep, Connect.UnbindAction

    for Index in Connections do
        DisconnectSignal(Connect, Index)
    end

    for Index in Threads do
        StopThread(Connect, Index)
    end

    for Index in RenderConnections do
        UnbindRenderStep(Connect, Index)
    end

    for Index in ActionConnections do
        UnbindAction(Connect, Index)
    end
end)

return Connect
