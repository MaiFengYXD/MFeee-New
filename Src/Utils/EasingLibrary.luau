local TweenInfonew,  tableclear
    = TweenInfo.new, table.clear

local TweenService
    = shared.TweenService

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

    EasingMode      = "Quartic",
    EasingDirection = "Out",
    EasingDuration  = 1,
}

type StoredTween = {
    Tween:      Tween,
    OnCompleted: RBXScriptConnection,
    Destroy:    () -> nil
}

function EasingLibrary:CancelTween(Index: string)
    if not self.RunningTween[Index] then return end
    self.RunningTween[Index].Tween:Cancel() --/ OnCompleted will automatically clean the RunningTween
end

function EasingLibrary:PlayTween(Tween: Tween, Index: string): StoredTween
    self.RunningTween[Index] = self:CancelTween(Index) or {
        Tween       = Tween,
        OnCompleted = Tween.Completed:Once(function()
            self.RunningTween[Index] = tableclear(self.RunningTween[Index])
        end),

        Destroy = function()
            self:CancelTween(Index)
        end
    } :: StoredTween
    Tween:Play()

    return self.RunningTween[Index]
end

function EasingLibrary:Ease(
    Target:    Instance,
    Property:  string | {[number]: string},
    EndValue:  any,
    Index:     string,
    Duration:  number?,
    Mode:      string?,
    Direction: string?
): StoredTween?
    if self.EasingMode == "None" then
        Target[Property] = EndValue
        return
    end

    local TweenInfo = TweenInfonew(
        Duration  or self.EasingDuration or 1,
        Mode      or self.EasingModes[self.EasingMode] or Enum.EasingStyle.Quart,
        Direction or self.EasingDirections[self.EasingDirection] or Enum.EasingDirection.Out
    )
    local Goal = if type(Property) == "table" then Property else {[Property] = EndValue}

    return self:PlayTween(TweenService:Create(Target, TweenInfo, Goal), Index)
end

return EasingLibrary
