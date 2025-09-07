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
        "RiskyColor"
    }

    for Name, Scheme in {
        ["Cool Cold"] = {"111019", "141929", "243b52", "57b3e1", "170c17", "d02525"}
    } :: hash do
        local Color3Scheme = {
            FontColor = Color3_fromHex("ffffff")
        }

        for Index, HexValue in Scheme do
            Color3Scheme[IndexToKey[Index]] = Color3_fromHex(HexValue)
        end

        ThemeManager.Schemes[Name] = Color3Scheme
    end
end
