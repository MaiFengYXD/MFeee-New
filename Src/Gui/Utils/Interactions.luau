local randomstring, UDim2_new
    = randomstring, UDim2.new

local Event = require("Event")
local Fire  = Event.Fire

local Input = require("Input")

local MISC = require("MISC")
local SafeCallback = MISC.SafeCallback

local EasingLibrary = shared.EasingLibrary
local Ease = EasingLibrary.Ease

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local function MakeRotatable(
    Target:    ImageButton,
    Bounding:  (TextButton | ImageButton)?,
    Callback:  Function?,
    Increment: number?
): () -> ()
    local Id = randomstring(20)

    local TheIncrement = Increment or 180
    local NextRotation = Target.Rotation

    local function Rotate()
        NextRotation += TheIncrement
        Ease(EasingLibrary, Target, "Rotation", NextRotation, Id, 1 / 3)
        SafeCallback(Callback)
    end

    GiveSignal(Connect, Id, (Bounding or Target).Activated, Rotate)
    return Rotate
end

local function MakeDraggable(
    Targets:  {GuiObject},
    Bounding: GuiObject?,
    Event:    EventStore,
    Offset:   UDim2?
)
    local function Update()

    end
end

return {}
