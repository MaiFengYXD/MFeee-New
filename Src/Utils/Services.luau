local pcall, debug_profilebegin, debug_profileend, game,      GetService
    = pcall, debug.profilebegin, debug.profileend, game, game.GetService

local Services = {}

local cloneref = cloneref or clonereference or function(Object: Instance)
    return Object
end

function Services:GetServices(Table: {string})
    debug_profilebegin("[Instance I/O] GetServices")

    for _, Name in Table do
        local Success, Service: Instance? = pcall(cloneref, GetService(game, Name))
        if Success then
            shared[Name] = Service :: Instance
        end
    end

    debug_profileend()
end

return Services
