local TweenInfo_new, type, assert
    = TweenInfo.new, type, assert

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

local EasingStyle     = Enum.EasingStyle
local EasingDirection = Enum.EasingDirection

local EasingLibrary = {
    RunningTween = {},

    EasingModes = {
        --// Polynomial
        ["Linear"   ] = EasingStyle.Linear,
        ["Quadratic"] = EasingStyle.Quad,
        ["Cubic"    ] = EasingStyle.Cubic,
        ["Quartic"  ] = EasingStyle.Quart,
        ["Quintic"  ] = EasingStyle.Quint,

        --// Trigonometric
        ["Circular"] = EasingStyle.Circular,
        ["Sine"    ] = EasingStyle.Sine,

        --// Exponential
        ["Exponential"] = EasingStyle.Exponential,

        --// Special
        ["Back"   ] = EasingStyle.Back,
        ["Elastic"] = EasingStyle.Elastic,
        ["Bounce" ] = EasingStyle.Bounce
    },

    EasingDirections = {
        ["In"   ] = EasingDirection.In,
        ["Out"  ] = EasingDirection.Out,
        ["InOut"] = EasingDirection.InOut
    },

    EasingMode      = "Quartic" :: "None" | string,
    EasingDirection = "Out" :: string,
    EasingDuration  = 1,
}

local EasingConfig = shared.ConfigManager.new("EasingLibrary", {
    EasingMode      = "Quartic",
    EasingDirection = "Out",
    EasingDuration  = 1,
}, "easing.config.json")

local Set = EasingConfig.Set

EasingLibrary.Config = EasingConfig.Config

local Quart = EasingStyle.Quart
local Out   = EasingDirection.Out

type StoredTween = {
    Tween:       TweenBase,
    Goal:        hash,
    OnCompleted: RBXScriptConnection
}

function EasingLibrary:CancelTween(Index: string | any)
    local Running = self.RunningTween[Index]
    if not Running then return end

    Cancel(Running.Tween) --/ OnCompleted will automatically clean the RunningTween
end

function EasingLibrary:PlayTween(Index: string | any, Tween: TweenBase, Goal: hash): StoredTween
    local This = {
        Tween = Tween,
        Goal  = Goal,

        OnCompleted = Tween.Completed:Once(function()
            local Running = self.RunningTween[Index]
            if not Running then return end

            self.RunningTween[Index] = Destroy(Running.Tween)
        end)
    } :: StoredTween

    self.RunningTween[Index] = (self:CancelTween(Index) :: nil) or This

    return Play(Tween) or This
end

function EasingLibrary:Ease(
    Target:    Instance & any,
    Property:  string | hash,
    EndValue:  any,
    Index:     string | any,
    Duration:  number | nil,
    Mode:      string | Enum.EasingStyle | nil,
    Direction: string | Enum.EasingDirection | nil
): StoredTween | nil
    assert(Index ~= nil, "EasingLibrary.Ease: argument 'Index' is required!")

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

    local Goal = if type(Property) == "table" then Property :: hash else {[Property :: string] = EndValue} :: hash
    local Store = self:PlayTween(Index, Create(
        TweenService,
        Target,
        TweenInfo_new(
            Duration or self.EasingDuration or 1,
            type(Mode) == "string" and self.EasingModes[Mode] or self.EasingModes[self.EasingMode] or Quart,
            type(Direction) == "string" and self.EasingDirections[Direction] or self.EasingDirections[self.EasingDirection] or Out
        ),
        Goal
    ), Goal)

    return Store
end

return setmetatable({}, {
    __index    = EasingLibrary,
    __newindex = function(_, Key: string, Value: any)
        if Key == "EasingMode" or Key == "EasingDirection" or Key == "EasingDuration" then
            EasingLibrary[Key] = Value
            Set(EasingConfig, Key, Value)
        end
    end
})
