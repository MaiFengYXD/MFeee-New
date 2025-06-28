local pcall, Color3_fromHex
    = pcall, Color3.fromHex

local HttpService = shared.HttpService :: HttpService
local JSONDecode  = HttpService.JSONDecode

local ThemeManager = {
    Schemes = {}
};do
    local IndexToKey = {
        "BackgroundColor",
        "PrimaryColor",
        "SecondaryColor",
        "AccentColor",
        "OutlineColor",
        "FontColor",
        "RiskyColor"
    }

    for Name, Scheme in {
        ["Cool Cold"] = {"080c0f", "0b1719", "0b9b8a", "67ddab", "909090", "FFFFFF", "f65938"}
    } :: hash do
        local Color3Scheme = {}

        for Index, HexValue in Scheme do
            Color3Scheme[IndexToKey[Index]] = Color3_fromHex(HexValue)
        end

        ThemeManager.Schemes[Name] = Color3Scheme
    end
end
