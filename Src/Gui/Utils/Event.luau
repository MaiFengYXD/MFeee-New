local table_insert, task_spawn, table_clear
    = table.insert, task.spawn, table.clear

local Event = {};do
    local function CreateEvent(Callback: Function?): EventStore
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

    Event.CreateEvent = CreateEvent

    local Store   = CreateEvent()
    Event.OnEvent = Store.OnEvent
    Event.Fire    = Store.Fire
end

return Event
