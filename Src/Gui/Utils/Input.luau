local UserInputType  = Enum.UserInputType
local UserInputState = Enum.UserInputState

local MouseMovement = UserInputType.MouseMovement
local MouseButton1  = UserInputType.MouseButton1
local MouseButton2  = UserInputType.MouseButton2
local Touch         = UserInputType.Touch

local Begin  = UserInputState.Begin
local Change = UserInputState.Change

local function IsHoverInput(InputObject: InputObject, OnlyMouse: boolean?): boolean
    return InputObject.UserInputState == Change and (
        InputObject.UserInputType == MouseMovement or
        not OnlyMouse and (
            InputObject.UserInputType == Touch
        )
    )
end

local function IsClickInput(InputObject: InputObject, IncludeM1: boolean?, IncludeM2: boolean?): boolean
    return InputObject.UserInputState == Begin and (
        IncludeM1 ~= false and (
            InputObject.UserInputType == MouseButton1
        ) or
        IncludeM2 and (
            InputObject.UserInputType == MouseButton2
        ) or
        InputObject.UserInputType == Touch
    )
end

local function IsOverFrame(Frame: GuiObject, InputObject: InputObject): boolean
    local Position = InputObject.Position

    local FrameSize     = Frame.AbsoluteSize
    local FramePosition = Frame.AbsolutePosition

    local PositionX      = Position.X
    local PositionY      = Position.Y
    local FramePositionX = FramePosition.X
    local FramePositionY = FramePosition.Y

    return PositionX >= FramePositionX and
           PositionY >= FramePositionY and
           PositionX <= FramePositionX + FrameSize.X and
           PositionY <= FramePositionY + FrameSize.Y
end

return {
    IsHoverInput = IsHoverInput,
    IsClickInput = IsClickInput,
    IsOverFrame  = IsOverFrame
}
