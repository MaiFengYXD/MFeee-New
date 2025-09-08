local table_insert, task_spawn, table_clear
    = table.insert, task.spawn, table.clear

export type EventStore = typeof(setmetatable({
    Events  = {} :: {Function},
    OnEvent = function(self: EventStore, Callback: Function): () end,
    Fire    = function(self: EventStore, ...:      any):      () end,
    Clear   = function(self: EventStore):                     () end
}, {__mode  = "kv" :: "kv"}))

local function CreateEventStore(Callback: Function?): EventStore
    local Event = setmetatable({
        Events = {Callback :: any}
    }, {__mode = "kv" :: "kv"}) :: EventStore

    function Event:OnEvent(Callback: Function): ()
        if not self.Events then
            self.Events = {Callback}
        else
            table_insert(self.Events, Callback)
        end
    end

    function Event:Fire(...: any): ()
        if not self.Events then return end
        for _, Callback in self.Events do
            task_spawn(Callback, ...)
        end
    end

    function Event:Clear(): ()
        table_clear(self.Events)
    end

    return Event
end

local Store   = CreateEventStore()
local OnEvent = Store.OnEvent
local Fire    = Store.Fire

return {
    CreateEventStore = CreateEventStore,
    OnEvent = OnEvent,
    Fire = Fire
}
