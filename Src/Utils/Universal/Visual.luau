local randomstring
    = randomstring

local      GetPropertyChangedSignal
    = game.GetPropertyChangedSignal

local Connect;do
    local Signal = game.Close

    Connect = Signal.Connect
end

local Universal = {}

local EasingLibrary = wax.shared.EasingLibrary
local RunningTween  = EasingLibrary.RunningTween
local Ease = EasingLibrary.Ease

local _Connect = shared.Connect
local GiveSignal = _Connect.GiveSignal
local DisconnectSignal = _Connect.DisconnectSignal

type Template<T> = {
    Enabled: boolean,
    Stopped: boolean,

    Default: (nil & T)?,
    Moded:   (nil & T)?,
}

local function GenerateFor<T>(Object: Instance, Property: string, Default: (nil & T)?, Moded: (nil & T)?): Template<T>
    local EaseIndex     = randomstring()
    local ChangedSignal = `{Property}ChangedSignal`

    local Generated = {
        Enabled = false,
        Stopped = false,

        Default = Default or (Object :: any)[Property],
        Moded   = Moded   or (Object :: any)[Property]
    }

    function Generated.Start(Enabled: boolean)
        local self   = Generated
        self.Enabled = Enabled

        if Enabled then
            Ease(EasingLibrary, Object, Property, self.Moded, EaseIndex)

            GiveSignal(_Connect, ChangedSignal, Connect(GetPropertyChangedSignal(Object, Property), function()
                if self.Stopped then return end

                local CurrentValue = (Object :: any)[Property]
                if CurrentValue ~= self.Moded then
                    self.Default = CurrentValue
                end

                if not RunningTween[EaseIndex] then
                    (Object :: any)[Property] = self.Moded
                end
            end))
        else
            DisconnectSignal(ChangedSignal)
            Ease(EasingLibrary, Object, Property, self.Default, EaseIndex)
        end
    end

    function Generated.SetValue(Value: T)
        local self = Generated
        self.Moded = (Value :: any)

        if not self.Enabled then return end
        Ease(EasingLibrary, Object, Property, Value, EaseIndex)
    end

    return Generated
end

Universal.FOV     = GenerateFor(shared.Camera , "FieldOfView")
Universal.MaxZoom = GenerateFor(shared.Speaker, "CameraMaxZoomDistance")
Universal.MinZoom = GenerateFor(shared.Speaker, "CameraMinZoomDistance")

return Universal
