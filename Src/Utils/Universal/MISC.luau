local Universal = {}

do
    local pcall, getconnections
        = pcall, getconnections

    Universal.AntiAFK = {
        Enabled = false,
        Support = wax.shared.ExecutorSupport.getconnections :: boolean,

        Idled   = shared.Speaker.Idled :: RBXScriptSignal,

        Start = function(Enabled: boolean)
            local self   = Universal.AntiAFK
            self.Enabled = Enabled

            if not self.Support then return end

            local Connections = getconnections(self.Idled)
            local CallValue   = Enabled and "Disable" or "Enable"

            for _, Connection: any in Connections do
                pcall(Connection[CallValue], Connection)
            end
        end
    }
end

do
    local      GetFullName, checkcaller, getcallingscript, getnamecallmethod, hookfunction, hookmetamethod, warn
        = game.GetFullName, checkcaller, getcallingscript, getnamecallmethod, hookfunction, hookmetamethod, warn

    local ExecutorName = identifyexecutor()

    local function FormatCaller(Calling: (Instance | string)?, IsExecutor: boolean, Message: string?): string
        if typeof(Calling) ~= "Instance" then
            Calling = if IsExecutor then `{ExecutorName} LocalScript` else "Unknown"
        else
            Calling = if not Calling.Parent then `[nil].{Calling.Name}` else GetFullName(Calling)
        end

        return `[MFeee~ New] Prevented a kick! Calling script: "{Calling}", Message: "{Message}"`
    end

    Universal.AntiKick = {
        Enabled  = false,
        Support1 = wax.shared.ExecutorSupport.hookfunction      :: boolean,
        Support2 = wax.shared.ExecutorSupport.hookmetamethod    :: boolean,
        Support3 = wax.shared.ExecutorSupport.checkcaller       :: boolean,
        Support4 = wax.shared.ExecutorSupport.getcallingscript  :: boolean,
        Support5 = wax.shared.ExecutorSupport.getnamecallmethod :: boolean,

        Kick = shared.Speaker.Kick :: (self: any, Message: string) -> nil,

        OldFunction = nil :: ((self: any, Message: string?) -> any) | nil,
        OldNameCall = nil :: ((self: any, any) -> (...any)) | nil,

        Start = function(Enabled: boolean)
            local self   = Universal.AntiKick
            self.Enabled = Enabled

            local CanFormat = self.Support3 and self.Support4

            if self.Support1 then
                if Enabled then
                    self.OldFunction = hookfunction(self.Kick, function(self: any, Message: string?)
                        if CanFormat then
                            local IsExecutor = checkcaller()
                            local Calling    = getcallingscript()

                            warn(FormatCaller(Calling, IsExecutor, Message))
                        end
                    end) :: ((self: any, Message: string?) -> any) | nil
                elseif self.OldFunction then
                    hookfunction(self.Kick, self.OldFunction)
                    self.OldFunction = nil
                end
            end

            if self.Support2 and self.Support5 then
                if Enabled then
                    local Speaker = shared.Speaker
                    local OldNameCall: typeof(self.OldNameCall)

                    self.OldNameCall = hookmetamethod(game, "__namecall", function(self: any, ...: any)
                        if self ~= Speaker or getnamecallmethod() ~= "Kick" then
                            return (OldNameCall or self.OldNameCall)(self, ...)
                        end

                        if CanFormat then
                            local IsExecutor = checkcaller()
                            local Calling = getcallingscript()

                            warn(FormatCaller(Calling, IsExecutor, ...))
                        end
                    end) :: ((self: any, any) -> (...any)) | nil

                    OldNameCall = self.OldNameCall
                elseif self.OldNameCall then
                    hookmetamethod(game, "__namecall", self.OldNameCall)
                    self.OldNameCall = nil
                end
            end
        end
    }
end

return Universal
