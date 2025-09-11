local UDim2_fromScale, UDim2_new, math_min
    = UDim2.fromScale, UDim2.new, math.min

local      GetPropertyChangedSignal
    = game.GetPropertyChangedSignal

local Unscaling = require("Unscaling")
local GetUnscaledContentSize = Unscaling.GetUnscaledContentSize

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local Monitoring = {};do
    function Monitoring.UpdateWithContentSize(
        Frame:        ScrollingFrame | Frame,
        UIListLayout: UIListLayout,
        Offset:       UDim2?,
        MaxSize:      number?
    ): () -> ()
        local ExtraOffset = Offset or UDim2_fromScale(0, 0)
        local MaxSizeY    = MaxSize or (1 / 0)

        local Key = Frame.ClassName == "ScrollingFrame" and "CanvasSize" or "Size"

        local function Update()
            local Frame: any, Key: string
                = Frame,      Key

            local CurrentSize = Frame[Key] :: UDim2

            Frame[Key] = UDim2_new(
                CurrentSize.X.Scale,
                CurrentSize.X.Offset,
                CurrentSize.Y.Scale,
                math_min(GetUnscaledContentSize(UIListLayout, "Y") :: number, MaxSizeY)
            ) + ExtraOffset
        end

        GiveSignal(Connect, nil, GetPropertyChangedSignal(UIListLayout, "AbsoluteContentSize"), Update)
        Update()

        return Update
    end
end

return Monitoring
