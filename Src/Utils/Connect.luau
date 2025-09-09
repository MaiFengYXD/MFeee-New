local unpack, pcall, typeof, table_clear, table_insert, task_cancel, coroutine_close, coroutine_resume
    = unpack, pcall, typeof, table.clear, table.insert, task.cancel, coroutine.close, coroutine.resume

local _Connect   = game.Close.Connect
local Disconnect = game.Close:Once(function() end).Disconnect

local RunService = shared.RunService :: RunService

local BindToRenderStep     = RunService.BindToRenderStep
local UnbindFromRenderStep = RunService.UnbindFromRenderStep

local ContextService = shared.ContextActionService :: ContextActionService

local BindAction           = ContextService.BindAction
local BindActionAtPriority = ContextService.BindActionAtPriority
local UnbindAction         = ContextService.UnbindAction

type ActionCallback = (
    ActionName:  string,
    InputState:  Enum.UserInputState,
    InputObject: InputObject
) -> (nil)

local Connect = {};do
    local Connections       = {}
    local Threads           = {}
    local RenderConnections = {}
    local ActionConnections = {}

    local UnnamedConnections = {}
    local UnnamedThreads     = {}

    function Connect:GiveSignal(
        Index:    string?,
        Signal:   RBXScriptSignal | RBXScriptConnection,
        Callback: Function?
    ): RBXScriptConnection
        if Connections[Index] then self:DisconnectSignal(Index) end

        if typeof(Signal) == "RBXScriptSignal" then
            return self:GiveSignal(Index, _Connect(Signal, Callback))
        end

        if typeof(Index) == "nil" or typeof(Index) == "boolean" then
            table_insert(UnnamedConnections, Signal)
        else
            Connections[Index] = Signal
        end

        return Signal :: RBXScriptConnection
    end

    function Connect:RunThread(Index: string?, Thread: thread, Type: "task" | "coroutine" | nil): thread
        if Threads[Index] then self:StopThread(Index) end

        if typeof(Index) == "nil" or typeof(Index) == "boolean" then
            table_insert(UnnamedThreads, Thread)
        else
            Threads[Index] = Thread
        end

        if Type ~= "task" then
            pcall(coroutine_resume, Thread)
        end
        return Thread
    end

    function Connect:BindRenderStep(
        Index:     string,
        Priority:  Enum.RenderPriority | number,
        Function: (number) -> nil
    ): (number) -> nil
        self:UnbindRenderStep(Index)

        Priority = if typeof(Priority) ~= "number" then (Priority :: Enum.RenderPriority).Value else Priority

        BindToRenderStep(RunService, Index, Priority :: number, Function)

        RenderConnections[Index] = Function
        return Function
    end

    function Connect:BindAction(
        Index:     string,
        Function:  ActionCallback,
        TouchIcon: boolean?,
        Priority:  (Enum.ContextActionPriority | number)?,
        ...:       Enum.KeyCode | Enum.UserInputType
    ): ActionCallback
        self:UnbindAction(Index)

        local Enums    = {...}
        local IsNormal = false

        if typeof(Priority) ~= "EnumItem" then
            if typeof(Priority) ~= "number" then IsNormal = true end
        else
            Priority = (Priority :: Enum.ContextActionPriority).Value
        end

        if IsNormal then
            BindAction(ContextService, Index, Function, TouchIcon or false, unpack(Enums))
        else
            BindActionAtPriority(ContextService, Index, Function, TouchIcon or false, Priority :: number, unpack(Enums))
        end

        table_clear(Enums)

        ActionConnections[Index] = Function
        return Function
    end

    function Connect:DisconnectSignal(Index: string?)
        if pcall(Disconnect, Connections[Index]) then Connections[Index] = nil end
    end

    function Connect:StopThread(Index: string?)
        if (
            pcall(coroutine_close, Threads[Index]) or
            pcall(task_cancel, Threads[Index])
        ) then Threads[Index] = nil end
    end

    function Connect:UnbindRenderStep(Index: string)
        UnbindFromRenderStep(RunService, Index)
        RenderConnections[Index] = nil
    end

    function Connect:UnbindAction(Index: string)
        UnbindAction(ContextService, Index)
        ActionConnections[Index] = nil
    end

    function Connect:DisconnectAll()
        local      DisconnectSignal,      StopThread,      UnbindRenderStep,      UnbindAction
            = self.DisconnectSignal, self.StopThread, self.UnbindRenderStep, self.UnbindAction

        for Index in Connections do
            DisconnectSignal(self, Index)
        end

        for Index in Threads do
            StopThread(self, Index)
        end

        for Index in RenderConnections do
            UnbindRenderStep(self, Index)
        end

        for Index in ActionConnections do
            UnbindAction(self, Index)
        end

        for _, Connection in UnnamedConnections do
            pcall(Disconnect, Connection)
        end

        for _, Thread in UnnamedThreads do
            pcall(coroutine_close, Thread)
            pcall(task_cancel, Thread)
        end
    end
end

local CommonSignals = {};do
    local GetPropertyChangedSignal = game.GetPropertyChangedSignal
    local GiveSignal = Connect.GiveSignal

    Connect.CommonSignals = CommonSignals

    local        Workspace,        Players
        = shared.Workspace, shared.Players

    local CameraChangedSignal  = GetPropertyChangedSignal(shared.Workspace, "CurrentCamera")
    local SpeakerChangedSignal = GetPropertyChangedSignal(shared.Players, "LocalPlayer")

    function CommonSignals.CameraChanged(Callback: Function): RBXScriptConnection
        return GiveSignal(Connect, nil, CameraChangedSignal, function()
            Callback(Workspace.CurrentCamera)
        end)
    end

    function CommonSignals.SpeakerChanged(Callback: Function): RBXScriptConnection
        return GiveSignal(Connect, nil, SpeakerChangedSignal, function()
            Callback(Players.LocalPlayer)
        end)
    end
end

wax.AddOnUnload(Connect.DisconnectAll, Connect)

return Connect
