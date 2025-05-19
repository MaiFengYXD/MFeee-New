local TweenInfo_new, type
    = TweenInfo.new, type

local      Destroy
    = game.Destroy

local TweenService = shared.TweenService
local Create       = TweenService.Create

local Play, Cancel;do
    local Tween = Instance.new("Tween")

    Play   = Tween.Play
    Cancel = Tween.Cancel

    Destroy(Tween)
end

local EasingLibrary = {
    RunningTween = {},

    EasingModes = {
        --// Polynomial
        ["Linear"   ] = Enum.EasingStyle.Linear,
        ["Quadratic"] = Enum.EasingStyle.Quad,
        ["Cubic"    ] = Enum.EasingStyle.Cubic,
        ["Quartic"  ] = Enum.EasingStyle.Quart,
        ["Quintic"  ] = Enum.EasingStyle.Quint,

        --// Trigonometric
        ["Circular"] = Enum.EasingStyle.Circular,
        ["Sine"    ] = Enum.EasingStyle.Sine,

        --// Exponential
        ["Exponential"] = Enum.EasingStyle.Exponential,

        --// Special
        ["Back"   ] = Enum.EasingStyle.Back,
        ["Elastic"] = Enum.EasingStyle.Elastic,
        ["Bounce" ] = Enum.EasingStyle.Bounce
    },

    EasingDirections = {
        ["In"   ] = Enum.EasingDirection.In,
        ["Out"  ] = Enum.EasingDirection.Out,
        ["InOut"] = Enum.EasingDirection.InOut
    },

    EasingMode      = "Quartic" :: "None" | string,
    EasingDirection = "Out" :: string,
    EasingDuration  = 1,
}

local Quart = Enum.EasingStyle.Quart
local Out   = Enum.EasingDirection.Out

type StoredTween = {
    Tween:       Tween | TweenBase,
    OnCompleted: RBXScriptConnection
}

function EasingLibrary:CancelTween(Index: string)
    local Running = self.RunningTween[Index]
    if not Running then return end

    Cancel (Running.Tween) --/ OnCompleted will automatically clean the RunningTween
    Destroy(Running.Tween)
end

function EasingLibrary:PlayTween(Index: string?, Tween: Tween | TweenBase): StoredTween
    self.RunningTween[Index] = (self:CancelTween(Index) :: nil) or {
        Tween = Tween,

        OnCompleted = Tween.Completed:Once(function()
            self.RunningTween[Index] = Destroy(self.RunningTween[Index].Tween)
        end)
    } :: StoredTween

    Play(Tween)

    return self.RunningTween[Index]
end

function EasingLibrary:Ease(
    Target:    Instance & any,
    Property:  string | {[number]: string},
    EndValue:  any,
    Index:     string?,
    Duration:  number | nil,
    Mode:      string | Enum.EasingStyle | nil,
    Direction: string | Enum.EasingDirection | nil
): StoredTween | nil
    if Mode == "None" or self.EasingMode == "None" then
        if type(Property) == "string" then
            (Target :: any)[Property] = EndValue
        else
            for Key, Value in (Property :: table) do
                (Target :: any)[Key] = Value
            end
        end
        return
    end

    local TweenInfo = TweenInfo_new(
        Duration  or self.EasingDuration or 1,
        type(Mode) == "string" and self.EasingModes[Mode] or self.EasingModes[self.EasingMode] or Quart,
        type(Direction) == "string" and self.EasingDirections[Direction] or self.EasingDirections[self.EasingDirection] or Out
    )
    local Goal = if type(Property) == "table" then Property else {[Property] = EndValue}

    return self:PlayTween(Index, Create(TweenService, Target, TweenInfo, Goal))
end

return EasingLibrary
