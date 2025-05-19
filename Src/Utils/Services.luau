local pcall, game,      GetService
    = pcall, game, game.GetService

local Services = {}

local cloneref = cloneref or clonereference or function(Object: Instance)
    return Object
end

function Services:GetServices(Table: {string})
    for _, Name in Table do
        local Success, Service = pcall(cloneref, GetService(game, Name))
        shared[Name] = if Success then Service else nil
    end
end

return Services
