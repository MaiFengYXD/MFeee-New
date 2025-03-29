local Services = {}

local Cloneref = cloneref or function(...) return ... end

function Services:GetServices(Table)
    for _, Name in next, Table do
        local Service = Cloneref(game:GetService(Name))
        shared[Name] = Service
    end
end

return Services
