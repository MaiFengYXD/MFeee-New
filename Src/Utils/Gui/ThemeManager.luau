local pcall, Color3_fromHex
    = pcall, Color3.fromHex

local HttpService = shared.HttpService :: HttpService
local JSONDecode  = HttpService.JSONDecode

type Label = {
    Text:     string,
    Clicked:  {Callback},
    [string]: any
}

type Groupbox = {
    AddToggle:      (self: Groupbox, Index: string, Info: hash?) -> any,
    AddDropdown:    (self: Groupbox, Index: string, Info: hash?) -> any,
    AddLabel:       (self: Groupbox, Index: string, Info: hash?) -> Label,
    AddColorPicker: (self: Label,    Index: string, Info: hash?) -> any
}

type Tab = {
    AddLeftGroupbox: (self: Tab, Title: string) -> any,
    [string]: any
}

type Library = {
    UpdateColors: (self: Library) -> (),
    [string]: any
}

local ThemeManager = {
    Schemes = {}
}

for Name, Scheme in {
    ["Blue Dusk"]     = [[{"BackgroundColor":"#121E2E","PrimaryColor":"#1F3246","SecondaryColor":"#3B5878","AccentColor":"#6299fe","OutlineColor":"#0A141F","RiskyColor":"#C02020"}]],
    ["Green Forest"]  = [[{"BackgroundColor":"#2A3A2A","PrimaryColor":"#4A6A4A","SecondaryColor":"#7BA37B","AccentColor":"#C8E6C9","OutlineColor":"#1E2B1E","RiskyColor":"#F44336"}]],
    ["Volcanic Red"]  = [[{"BackgroundColor":"#2B0F0A","PrimaryColor":"#5E2D24","SecondaryColor":"#9A4F3F","AccentColor":"#FF8C00","OutlineColor":"#1F0B08","RiskyColor":"#FF3333"}]],
    ["Deep Violet"]   = [[{"BackgroundColor":"#2A1A2A","PrimaryColor":"#5C3D5C","SecondaryColor":"#8E6F8E","AccentColor":"#C38DDC","OutlineColor":"#1E121E","RiskyColor":"#FF0000"}]],
    ["Golden Sand"]   = [[{"BackgroundColor":"#4A3A2A","PrimaryColor":"#7A6A4A","SecondaryColor":"#B5A577","AccentColor":"#FFD700","OutlineColor":"#3A2D1A","RiskyColor":"#B00020"}]],
    ["Cyber Blue"]    = [[{"BackgroundColor":"#0A1B2E","PrimaryColor":"#1F3A5C","SecondaryColor":"#3A6CA0","AccentColor":"#00BFFF","OutlineColor":"#050E18","RiskyColor":"#CC0000"}]],
    ["Monochrome"]    = [[{"BackgroundColor":"#2D2D2D","PrimaryColor":"#4F4F4F","SecondaryColor":"#7B7B7B","AccentColor":"#AAAAAA","OutlineColor":"#1F1F1F","RiskyColor":"#E53935"}]],
    ["Aqua Mint"]     = [[{"BackgroundColor":"#2C3A3A","PrimaryColor":"#4E6B6B","SecondaryColor":"#8CC9C9","AccentColor":"#A7F0ED","OutlineColor":"#1D2828","RiskyColor":"#FF4C4C"}]],
    ["Ocean Deep"]    = [[{"BackgroundColor":"#0D1A2A","PrimaryColor":"#1E3652","SecondaryColor":"#3F638F","AccentColor":"#6B9ED2","OutlineColor":"#07101A","RiskyColor":"#F4511E"}]],
    ["Amber Glow"]    = [[{"BackgroundColor":"#3D2A1A","PrimaryColor":"#6E4D2C","SecondaryColor":"#A07A4A","AccentColor":"#F09A3E","OutlineColor":"#2B1D10","RiskyColor":"#D32F2F"}]],
    ["Galaxy Night"]  = [[{"BackgroundColor":"#0A0A1A","PrimaryColor":"#2A2A3A","SecondaryColor":"#5A5A6A","AccentColor":"#8A8AD2","OutlineColor":"#05050F","RiskyColor":"#FF3B30"}]],
    ["Pink Bloom"]    = [[{"BackgroundColor":"#3A2A3A","PrimaryColor":"#6A4A6A","SecondaryColor":"#9A7A9A","AccentColor":"#FFB6C1","OutlineColor":"#2A1A2A","RiskyColor":"#DC143C"}]],
    ["Bronze Gear"]   = [[{"BackgroundColor":"#2D2D2D","PrimaryColor":"#4F4F4F","SecondaryColor":"#7B7B7B","AccentColor":"#B8860B","OutlineColor":"#1F1F1F","RiskyColor":"#CD5C5C"}]],
    ["Emerald Oasis"] = [[{"BackgroundColor":"#1A3A3A","PrimaryColor":"#2C5A5A","SecondaryColor":"#4A8A8A","AccentColor":"#7FFFD4","OutlineColor":"#122B2B","RiskyColor":"#FF6347"}]],
    ["Neon Alley"]    = [[{"BackgroundColor":"#0F0F1A","PrimaryColor":"#2A2A3A","SecondaryColor":"#4A4A5A","AccentColor":"#FFFF00","OutlineColor":"#080812","RiskyColor":"#FFD700"}]],
    ["Forge Ember"]   = [[{"BackgroundColor":"#2A1A0A","PrimaryColor":"#5A3A1A","SecondaryColor":"#8A5A2A","AccentColor":"#FFA500","OutlineColor":"#1A0A00","RiskyColor":"#FF4500"}]],
    ["Arctic Ice"]    = [[{"BackgroundColor":"#2A3A4A","PrimaryColor":"#4A6A8A","SecondaryColor":"#7AAAB8","AccentColor":"#D4F0FF","OutlineColor":"#1A2A3A","RiskyColor":"#FF0000"}]],
    ["Cave Dweller"]  = [[{"BackgroundColor":"#1E1E1E","PrimaryColor":"#3A3A3A","SecondaryColor":"#5C5C5C","AccentColor":"#A020F0","OutlineColor":"#121212","RiskyColor":"#B22222"}]],
    ["Retro Pixel"]   = [[{"BackgroundColor":"#000000","PrimaryColor":"#222222","SecondaryColor":"#444444","AccentColor":"#00FF00","OutlineColor":"#000000","RiskyColor":"#FF0000"}]],
    ["Coastal Dawn"]  = [[{"BackgroundColor":"#2A3A4A","PrimaryColor":"#4A6A8A","SecondaryColor":"#8AC0C8","AccentColor":"#FFA07A","OutlineColor":"#1A2A3A","RiskyColor":"#D32F2F"}]]
} :: hash do
    local Success, Data = pcall(JSONDecode, HttpService, Scheme)
    if not Success then continue end

    local Color3Scheme = {}

    for Key, HexValue in Data do
        Color3Scheme[Key] = Color3_fromHex(HexValue)
    end

    ThemeManager.Schemes[Name] = Color3Scheme
end
