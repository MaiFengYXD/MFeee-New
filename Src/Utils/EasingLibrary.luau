local TweenInfo_new, table_clear, type
    = TweenInfo.new, table.clear, type

local        TweenService
    = shared.TweenService

local              Create
    = TweenService.Create

local Play, Cancel;do
    local Tween = Instance.new("Tween")

    Play   = Tween.Play
    Cancel = Tween.Cancel

    Tween:Destroy()
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

    EasingMode      = "Quartic" :: "None" | string?,
    EasingDirection = "Out",
    EasingDuration  = 1,
}

type StoredTween = {
    Tween:       Tween | TweenBase,
    OnCompleted: RBXScriptConnection
}

function EasingLibrary:CancelTween(Index: string)
    if not self.RunningTween[Index] then return end
    Cancel(self.RunningTween[Index].Tween) --/ OnCompleted will automatically clean the RunningTween
end

function EasingLibrary:PlayTween(Tween: Tween | TweenBase, Index: string): StoredTween
    self.RunningTween[Index] = self:CancelTween(Index) or {
        Tween = Tween,

        OnCompleted = Tween.Completed:Once(function()
            self.RunningTween[Index] = table_clear(self.RunningTween[Index])
        end)
    } :: StoredTween

    Play(Tween)

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

    local TweenInfo = TweenInfo_new(
        Duration  or self.EasingDuration or 1,
        Mode      or self.EasingModes[self.EasingMode] or Enum.EasingStyle.Quart,
        Direction or self.EasingDirections[self.EasingDirection] or Enum.EasingDirection.Out
    )
    local Goal = if type(Property) == "table" then Property else {[Property] = EndValue}

    return self:PlayTween(Create(TweenService, Target, TweenInfo, Goal), Index)
end

return EasingLibrary
