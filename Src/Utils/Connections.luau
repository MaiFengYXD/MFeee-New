local ConnectionsModule = {}
shared.Connections = {}

function ConnectionsModule:GiveSignal(Index: string, Signal: RBXScriptConnection | RBXScriptSignal)
    if shared.Connections[Index] then
        shared.Connections[Index]:Disconnect()
    end

    shared.Connections[Index] = Signal
end

function ConnectionsModule:DisconnectSignal(Index: string, Signal: RBXScriptConnection | RBXScriptSignal)
    shared.Connections[Index]:Disconnect()
    shared.Connections[Index] = nil
end

return ConnectionsModule
