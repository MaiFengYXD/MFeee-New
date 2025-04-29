local NPCHandler = {
    Npcs = {}
}

function NPCHandler:Init(Npc: Model)
    table.insert(self.Npcs, Npc)
    local Id = `{Npc}AncestryChanged`

    local function Disconnect()
        table.remove(self.Npcs, table.find(self.Npcs, Npc))
        shared.Connection:DisconnectSignal(Id)
        shared.Connection:DisconnectSignal(Npc)
    end

    shared.Connection:GiveSignal(Npc, Npc.Destroying:Once(Disconnect))

    shared.Connection:GiveSignal(Id, Npc.AncestryChanged:Connect(function(_, Parent: Instance?)
        if typeof(Parent) ~= "Instance" or not Parent:IsDescendantOf(shared.Workspace) then
            Disconnect()
        end
    end))
end

--// Find Npcs in the Workspace //
local function Handle(Object: Instance)
    if not Object:IsA("Humanoid") then return end

    local Parent = Object.Parent :: Model?
    if shared.Players:GetPlayerFromCharacter(Parent) then return end

    NPCHandler:Init(Parent)
end

for _, Object in shared.Workspace:GetDescendants() do
    Handle(Object)
end

shared.Connection:GiveSignal("NpcDescendantsAdded", shared.Workspace.DescendantAdded:Connect(Handle))

return NPCHandler
