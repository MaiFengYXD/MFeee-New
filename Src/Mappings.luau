local Mappings = setmetatable({
    [77614252294790] = {
        Name = "The Foundation",
        Folder = "The Foundation/Game",
        Display = "THE FOUNDATION (Game)"
    },

    [18186775539] = {
        Name = "The Foundation",
        Folder = "The Foundation/Lobby",
        Display = "THE FOUNDATION (Lobby)"
    }
}, {
    __index = function()
        return {
            Name = "Universal",
            Folder = "Universal",
            Display = "Universal"
        }
    end
})

return Mappings
