local Instance_new, pcall, randomstring, next, typeof, Color3_fromHex, Font_new
    = Instance.new, pcall, randomstring, next, typeof, Color3.fromHex, Font.new

local Enum_FontWeight = Enum.FontWeight
local Enum_FontStyle  = Enum.FontStyle

local Library = shared.Gui.Library

local Scheme        = Library.Scheme
local ThemeRegistry = Library.ThemeRegistry

local Colors = require("Colors")
local GetDarkerColor = Colors.GetDarkerColor

local Templates = {
    Frame = {
        BorderSizePixel = 0
    },

    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },

    UIStroke = {
        Color = "BorderColor"
    },

    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    },

    ImageButton = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    },

    ScrollingFrame = {
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        TopImage = "",
        MidImage = "",
        BottomImage = "",
        CanvasSize = UDim2.fromScale(0, 0)
    },

    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        Text = "",
        TextColor3 = "TextColor1"
    },

    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        Text = "",
        TextColor3 = "TextColor1"
    },

    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        Text = "",
        TextColor3 = "TextColor2",
        PlaceholderColor3 = function()
            return GetDarkerColor(Scheme.TextColor2)
        end
    }
}

local function __newindex(self: any, Key: string, Value: any)
    pcall(function(self, Key, Value)
        self[Key] = Value
    end, self, Key, Value)
end

local function Fill(
    Instance:   Instance,
    Properties: hash,
    __newindex: typeof(__newindex),
    typeof:     typeof(typeof)
)
    local ThemeProperties = ThemeRegistry[Instance] or {}
    local Scheme = Scheme

    for Property, Value in Properties do
        if ThemeProperties[Property] then
            ThemeProperties[Property] = nil
        elseif Property ~= "Text" and (Scheme[Value] or typeof(Value) == "function") then
            ThemeProperties[Property] = Value
            if Value == "Font" then
                local FontConfig = Scheme[Value]
                __newindex(Instance, Property, Font_new(
                    `rbxasset://fonts/families/{FontConfig[1]}.json`,
                    (Enum_FontWeight :: any)[FontConfig[2]],
                    (Enum_FontStyle  :: any)[FontConfig[3]]
                ))
            else
                __newindex(Instance, Property, Color3_fromHex(Scheme[Value]) or Value())
            end
        elseif Property ~= "Parent" and Property ~= "Name" then
            __newindex(Instance, Property, Value)
        end
    end

    __newindex(Instance, "Name",   randomstring())
    __newindex(Instance, "Parent", Properties.Parent)

    if next(ThemeProperties) then
        ThemeRegistry[Instance] = ThemeProperties
    end
end

local function Create(ClassName: string, Properties: hash | Instance | any): Instance
    local typeof
        = typeof

    -- It always use Frame instead of CanvasGroup 'cause the CanvasGroup works bad
    local Instance = Instance_new(ClassName ~= "CanvasGroup" and ClassName or "Frame")
    local Template = Templates[ClassName ~= "CanvasGroup" and ClassName or "Frame"]

    if Template then
        Fill(Instance, Template, __newindex, typeof)
    end

    if ClassName == "CanvasGroup" then
        __newindex(Instance, "ClipsDescendants", true)
    end

    if typeof(Properties) == "table" then
        Fill(Instance, Properties :: hash, __newindex, typeof)
    elseif typeof(Properties) == "Instance" then
        __newindex(Instance, "Parent", Properties)
    end

    return Instance
end

return Create
