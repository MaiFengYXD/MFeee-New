local PromptController = {
    Instances        = {},
    HoldDuration     = {},

    MaxActivationDistance = {},
    RequiresLineOfSight   = {},

    HoldDurationEnabled          = false,
    MaxActivationDistanceEnabled = false,
    RequiresLineOfSightEnabled   = false,

    Multiplier = 1
}

--// Local Caches //
local type, randomstring
    = type, randomstring

local shared_Connect
    = shared.Connect

local GiveSignal       = shared_Connect.GiveSignal
local DisconnectSignal = shared_Connect.DisconnectSignal

local      IsA,      GetPropertyChangedSignal
    = game.IsA, game.GetPropertyChangedSignal

local Once, Connect;do
    local Signal = game.Close

    Once    = Signal.Once
    Connect = Signal.Connect
end

--// Init //
local function InsertPrompt(Instance: ProximityPrompt)
    if not IsA(Instance, "ProximityPrompt") then return end

    local self = PromptController

    self.Instances   [Instance] = randomstring()
    self.HoldDuration[Instance] = Instance.HoldDuration

    self.MaxActivationDistance[Instance] = Instance.MaxActivationDistance
    self.RequiresLineOfSight  [Instance] = Instance.RequiresLineOfSight

    GiveSignal(shared_Connect, Instance, Once(Instance.Destroying, function()
        self.Instances   [Instance] = nil
        self.HoldDuration[Instance] = nil

        self.MaxActivationDistance[Instance] = nil
        self.RequiresLineOfSight  [Instance] = nil
    end))
end

for _, Descendant in shared.Workspace:GetDescendants() do
    InsertPrompt(Descendant)
end

GiveSignal(shared_Connect, "OnPromptAdded", Connect(shared.Workspace.DescendantAdded, InsertPrompt))

--// Main Logic //
local function ModTemplate(Property: string, Expected: boolean | number, IsMultiple: boolean?)
    local self = PromptController

    for Prompt: any, Id in self.Instances do
        if self[`{Property}Enabled`] then
            local Value = if type(Expected) == "boolean" then Expected else (Expected * (IsMultiple and self[Property][Prompt]) or 1)

            GiveSignal(shared_Connect, `{Property}-{Id}`, Connect(GetPropertyChangedSignal(Prompt, Property), function()
                Prompt[Property] = Value
            end))
            Prompt[Property] = Value
        else
            DisconnectSignal(shared_Connect, `{Property}-{Id}`)
            Prompt[Property] = self[Property][Prompt]
        end
    end
end

function PromptController.InstantInteract(Enabled: boolean)
    local self = PromptController
    self.HoldDurationEnabled = Enabled

    ModTemplate("HoldDuration", 0)
end

function PromptController.DistanceMultiplier(Enabled: boolean)
    local self = PromptController
    self.MaxActivationDistanceEnabled = Enabled

    ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.SetMultiplier(Multiplier: number)
    local self = PromptController
    self.Multiplier = Multiplier

    ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.PromptNoclip(Enabled: boolean)
    local self = PromptController
    self.RequiresLineOfSightEnabled = Enabled

    ModTemplate("RequiresLineOfSight", false)
end

return PromptController
