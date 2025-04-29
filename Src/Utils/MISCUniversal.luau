local Universal = {}

local Support = wax.shared.ExecutorSupport

Universal.AntiAFK = {
    Enabled = false,
    
    Start = function(Enabled: boolean)
        local self = Universal.AntiAFK
        self.Enabled = Enabled

        if not Support.getconnections then return end

        for _, Connection in shared.GetConnections(shared.Speaker.Idled) do
            if Enabled then
                pcall(Connection.Disable, Connection)
            else
                pcall(Connection.Enable, Connection)
            end
        end
    end
}

Universal.AntiKick = {
    Enabled = false,
    
    OldFunction = nil,
    OldIndex = nil,
    OldNameCall = nil,

    Start = function(Enabled: boolean)
        local self = Universal.AntiKick
        self.Enabled = Enabled

        if Enabled then
            if Support.hookfunction then
                self.OldFunction = hookfunction(shared.Speaker.Kick, function(...) end)
            end

            if Support.hookmetamethod then
                self.OldIndex = hookmetamethod(game, "__index", function(self, Key)
                    if self ~= shared.Speaker and Key:lower() ~= "kick" then
                        return self.OldIndex(self, Key)
                    end
                    return
                end)

                if Support.getnamecallmethod then
                    self.OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
                        if getnamecallmethod():lower() ~= "kick" then
                            return self.OldNameCall(self, ...)
                        end
                        return
                    end)
                end
            end
        else
            if self.OldFunction then
                hookfunction(shared.Speaker.Kick, self.OldFunction)
            end

            if self.OldIndex then
                hookmetamethod(shared.Speaker, "__index", self.OldIndex)
            end

            if self.OldNameCall then
                hookmetamethod(shared.Speaker, "__namecall", self.OldNameCall)
            end
        end
    end
}

return Universal
