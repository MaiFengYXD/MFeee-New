local      GetAttribute,      SetAttribute,      GetPropertyChangedSignal
    = game.GetAttribute, game.SetAttribute, game.GetPropertyChangedSignal

local randomstring, UDim2_new, UDim2_fromOffset, next, math_clamp
    = randomstring, UDim2.new, UDim2.fromOffset, next, math.clamp

local Library = shared.Gui.Library

local Event = require("Event")
local Fire  = Event.Fire

local Input        = require("Input")
local IsHoverInput = Input.IsHoverInput
local IsClickInput = Input.IsClickInput

local MISC          = require("MISC")
local SafeCallback  = MISC.SafeCallback
-- local IsOutOfBounds = MISC.IsOutOfBounds

local EasingLibrary = shared.EasingLibrary
local Ease          = EasingLibrary.Ease :: Ease

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignall

local UserInputService = shared.UserInputService :: UserInputService

local InputChanged = UserInputService.InputChanged

local WindowFocusReleased = UserInputService.WindowFocusReleased
local WindowFocused       = UserInputService.WindowFocused

local TextboxFocuseReleased = UserInputService.TextBoxFocusReleased
local TextboxFocused        = UserInputService.TextBoxFocused

local End = Enum.UserInputState.End
local Inf = (1 / 0)

local Disconnect = game.Close:Once(function() end).Disconnect

type Ease = (
    self:      typeof(EasingLibrary),
    Target:    Instance,
    Property:  string | {[string]: any},
    EndValue:  any,
    Index:     string | any,
    Duration:  number | nil,
    Mode:      string | Enum.EasingStyle | nil,
    Direction: string | Enum.EasingDirection | nil
) -> {
    Tween:       Tween | TweenBase,
    OnCompleted: RBXScriptConnection
} | nil

local function MakeRotatable(
    Target:    ImageButton,
    Bounding:  (TextButton | ImageButton)?,
    Callback:  Function?,
    Increment: number?
): () -> ()
    local Id = randomstring(17)

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

    -- TODO: constrain to viewport
    -- ConstrainToViewport: boolean?,
    -- ConstrainMode:       ("Outer" | "Inner")?
)
    local OnlyOneTarget  = #Targets < 2
    local _, FirstTarget = next(Targets)

    local IsDragging = GetAttribute(FirstTarget, "IsDragging") or false

    SetAttribute(FirstTarget, "IsDragging", IsDragging)

    local AvailableBounding: GuiObject;do
        if Bounding then
            AvailableBounding = Bounding
        elseif OnlyOneTarget then
            AvailableBounding = FirstTarget
        else
            local LastZIndex: number
            local TopTarget:  GuiObject

            for _, Target in Targets do
                local ZIndex = Target.ZIndex
                if (if LastZIndex then ZIndex >= LastZIndex else true) then
                    TopTarget = Target
                end

                LastZIndex = ZIndex
            end

            AvailableBounding = TopTarget
        end
    end

    local IDs = {} :: {[GuiObject]: string};do
        for _, Target in Targets do
            IDs[Target] = randomstring(18)
        end
    end

    local CorrectedOffset = Offset or UDim2_new()

    GiveSignal(Connect, nil, AvailableBounding.InputBegan, function(InputObject: InputObject)
        local FirstTarget
            = FirstTarget

        if (
            IsDragging or not IsClickInput(InputObject) or GetAttribute(FirstTarget, "IsDragging") == true
        ) then return end

        SetAttribute(FirstTarget, "IsDragging", true)
        IsDragging = true

        local GiveSignal, Connect
            = GiveSignal, Connect

        local StartPosition  = InputObject.Position
        local FramePositions = {} :: {[GuiObject]: UDim2};do
            if OnlyOneTarget then
                FramePositions[FirstTarget] = FirstTarget.Position
            else
                for _, Target in Targets do
                    FramePositions[Target] = Target.Position
                end
            end
        end

        local Changed, Ended, Focused1, Focused2, Released1, Released2

        local function DisconnectAll(Disconnect: typeof(Disconnect))
            Disconnect(Changed)
            Disconnect(Ended)
            Disconnect(Focused1)
            Disconnect(Focused2)
            Disconnect(Released1)
            Disconnect(Released2)

            SetAttribute(FirstTarget, "IsDragging", false)
            IsDragging = false
        end

        Changed = GiveSignal(Connect, nil, InputChanged, function(InputObject: InputObject)
            if not IsHoverInput(InputObject) then return end

            local CorrectedOffset
                = CorrectedOffset

            local Delta = (InputObject.Position - StartPosition) / Library.DPIScale
            local IDs   = IDs

            for Target, Position in FramePositions do
                Ease(EasingLibrary, Target, "Position", UDim2_fromOffset(
                    Delta.X + Position.X,
                    Delta.Y + Position.Y
                ) + CorrectedOffset, IDs[Target], 0.25)
            end

            if Event then Fire(Event) end
        end)

        Ended = GiveSignal(Connect, nil, GetPropertyChangedSignal(InputObject, "UserInputState"), function()
            if InputObject.UserInputState ~= End then return end
            DisconnectAll(Disconnect)
        end)

        Focused1  = GiveSignal(Connect, nil, WindowFocused,         DisconnectAll)
        Focused2  = GiveSignal(Connect, nil, TextboxFocused,        DisconnectAll)
        Released1 = GiveSignal(Connect, nil, WindowFocusReleased,   DisconnectAll)
        Released2 = GiveSignal(Connect, nil, TextboxFocuseReleased, DisconnectAll)
    end)
end

local function MakeResizable(
    Targets:  {GuiObject},
    Bounding: GuiObject?,
    Event:    EventStore,
    Offset:   UDim2?,
    MaxSize:  typeof({480, 240})?,
    MinSize:  typeof({300, 150})?
)
    local OnlyOneTarget  = #Targets < 2
    local _, FirstTarget = next(Targets)

    -- Use the same attribute "IsDragging" as MakeDraggable used to prevent dragging and scaling at the same time
    local IsDragging = GetAttribute(FirstTarget, "IsDragging") or false

    SetAttribute(FirstTarget, "IsDragging", IsDragging)

    local AvailableBounding: GuiObject;do
        if Bounding then
            AvailableBounding = Bounding
        elseif OnlyOneTarget then
            AvailableBounding = FirstTarget
        else
            local LastZIndex: number
            local TopTarget:  GuiObject

            for _, Target in Targets do
                local ZIndex = Target.ZIndex
                if (if LastZIndex then ZIndex >= LastZIndex else true) then
                    TopTarget = Target
                end

                LastZIndex = ZIndex
            end

            AvailableBounding = TopTarget
        end
    end

    local IDs = {} :: {[GuiObject]: string};do
        for _, Target in Targets do
            IDs[Target] = randomstring(19)
        end
    end

    local CorrectedOffset = Offset or UDim2_new()

    local MaxSizeX, MaxSizeY, MinSizeX, MinSizeY;do
        if MaxSize then
            MaxSizeX = MaxSize[1]
            MaxSizeY = MaxSize[2]
        else
            MaxSizeX = Inf
            MaxSizeY = Inf
        end

        if MinSize then
            MinSizeX = MinSize[1]
            MinSizeY = MinSize[2]
        else
            MinSizeX = -Inf
            MinSizeY = -Inf
        end
    end

    GiveSignal(Connect, nil, AvailableBounding.InputBegan, function(InputObject: InputObject)
        local FirstTarget
            = FirstTarget

        if (
            IsDragging or not IsClickInput(InputObject) or GetAttribute(FirstTarget, "IsDragging") == true
        ) then return end

        SetAttribute(FirstTarget, "IsDragging", true)
        IsDragging = true

        local GiveSignal, Connect
            = GiveSignal, Connect

        local StartPosition = InputObject.Position
        local FrameSizes    = {} :: {[GuiObject]: UDim2};do
            if OnlyOneTarget then
                FrameSizes[FirstTarget] = FirstTarget.Size
            else
                for _, Target in Targets do
                    FrameSizes[Target] = Target.Size
                end
            end
        end

        local Changed, Ended, Focused1, Focused2, Released1, Released2

        local function DisconnectAll(Disconnect: typeof(Disconnect))
            Disconnect(Changed)
            Disconnect(Ended)
            Disconnect(Focused1)
            Disconnect(Focused2)
            Disconnect(Released1)
            Disconnect(Released2)

            SetAttribute(FirstTarget, "IsDragging", false)
            IsDragging = false
        end

        Changed = GiveSignal(Connect, nil, InputChanged, function(InputObject: InputObject)
            if not IsHoverInput(InputObject) then return end

            local CorrectedOffset
                = CorrectedOffset

            local Delta = (InputObject.Position - StartPosition) / Library.DPIScale
            local IDs   = IDs

            for Target, Size in FrameSizes do
                -- TODO: Improve the current scaling effect.
                -- The UDim2 value can be any, often greater than the maximum.
                -- It should scale up to the maximum value, stop immediately, and not scale up to the new value.

                Ease(EasingLibrary, Target, "Size", UDim2_fromOffset(
                    math_clamp(Delta.X + Size.X, MinSizeX, MaxSizeX),
                    math_clamp(Delta.Y + Size.Y, MinSizeY, MaxSizeY)
                ) + CorrectedOffset, IDs[Target], 0.25)
            end

            if Event then Fire(Event) end
        end)

        Ended = GiveSignal(Connect, nil, GetPropertyChangedSignal(InputObject, "UserInputState"), function()
            if InputObject.UserInputState ~= End then return end
            DisconnectAll(Disconnect)
        end)

        Focused1  = GiveSignal(Connect, nil, WindowFocused,         DisconnectAll)
        Focused2  = GiveSignal(Connect, nil, TextboxFocused,        DisconnectAll)
        Released1 = GiveSignal(Connect, nil, WindowFocusReleased,   DisconnectAll)
        Released2 = GiveSignal(Connect, nil, TextboxFocuseReleased, DisconnectAll)
    end)
end

return {
    MakeRotatable = MakeRotatable,
    MakeDraggable = MakeDraggable,
    MakeResizable = MakeResizable
}
