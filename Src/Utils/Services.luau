local game, GetService
    = game, game.GetService

local Services = {}
local Cloneref = cloneref or function(...) return ... end

function Services:GetServices(Table)
    for _, Name in Table do
        local Success, Service = pcall(Cloneref, GetService(game, Name))
        shared[Name] = if Success then Service else nil
    end
end

return Services
