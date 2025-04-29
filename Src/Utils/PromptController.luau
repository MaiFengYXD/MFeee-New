local PromptController = {
    Instance         = {},
    HoldDuration     = {},

    MaxActivationDistance = {},
    RequiresLineOfSight   = {},

    HoldDurationEnabled          = false,
    MaxActivationDistanceEnabled = false,
    RequiresLineOfSightEnabled   = false,

    Multiplier = 1
}

--// Local Caches //
local type
    = type

local IsA = Instance.new("Part").IsA
local PropertyChanged = Instance.new("Part").GetPropertyChangedSignal

local RandomString;do
    local Random      = Random.new()
    local NextInteger = Random.NextInteger
    local Char        = string.char

    function RandomString()
        local String = ""

        for _ = 1, NextInteger(Random, 8, 16) do
            String ..= Char(NextInteger(Random, 33, 126))
        end

        return String
    end
end

--// Init //
local function InsertPrompt(Instance: ProximityPrompt)
    if not IsA(Instance, "ProximityPrompt") then return end

    local self = PromptController

    self.Instance    [Instance] = RandomString()
    self.HoldDuration[Instance] = Instance.HoldDuration

    self.MaxActivationDistance[Instance] = Instance.MaxActivationDistance
    self.RequiresLineOfSight  [Instance] = Instance.RequiresLineOfSight

    shared.Connection:GiveSignal(Instance, Instance.Destroying:Once(function()
        self.Instance    [Instance] = nil
        self.HoldDuration[Instance] = nil

        self.MaxActivationDistance[Instance] = nil
        self.RequiresLineOfSight  [Instance] = nil
    end))
end

for _, Descendant in shared.Workspace:GetDescendants() do
    InsertPrompt(Descendant)
end

shared.Connection:GiveSignal("OnPromptAdded", shared.Workspace.DescendantAdded:Connect(InsertPrompt))

--// Main Logic //

--[[ @private ]]
function PromptController:_ModTemplate(Property: string, Expected: boolean | number, IsMultiple: boolean?)
    for Prompt, Id in self.Instance do
        if self[`{Property}Enabled`] then
            local Value = if type(Expected) == "boolean" then Expected else (Expected * (IsMultiple and self[Property][Prompt]) or 1)

            shared.Connection:GiveSignal(`{Property}-{Id}`, PropertyChanged(Prompt, Property):Connect(function()
                Prompt[Property] = Value
            end))
            Prompt[Property] = Value
        else
            shared.Connection:DisconnectSignal(`{Property}-{Id}`)
            Prompt[Property] = self[Property][Prompt]
        end
    end
end

function PromptController.InstantInteract(Enabled: boolean)
    local self = PromptController
    self.HoldDurationEnabled = Enabled

    self:_ModTemplate("HoldDuration", 0)
end

function PromptController.DistanceMultiplier(Enabled: boolean)
    local self = PromptController
    self.MaxActivationDistanceEnabled = Enabled

    self:_ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.SetMultiplier(Multiplier: number)
    local self = PromptController
    self.Multiplier = Multiplier

    self:_ModTemplate("MaxActivationDistance", self.Multiplier, true)
end

function PromptController.PromptNoclip(Enabled: boolean)
    local self = PromptController
    self.RequiresLineOfSightEnabled = Enabled

    self:_ModTemplate("RequiresLineOfSight", false)
end

return PromptController
