local Instance_new, pcall, randomstring, next, typeof
    = Instance.new, pcall, randomstring, next, typeof

local Library = shared.Gui.Library

local Colors = require("Colors")
local GetDarkerColor = Colors.GetDarkerColor

local InstanceTemplates = {
    Frame = {
        BorderSizePixel = 0
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
    },
    UIStroke = {
        Color = "OutlineColor"
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
        TextColor3 = "FontColor"
    },

    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        Text = "",
        TextColor3 = "FontColor"
    },

    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        Text = "",
        TextColor3 = "FontColor",
        PlaceholderColor3 = function()
            return GetDarkerColor(Library.Scheme.FontColor)
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
    local ThemeProperties = Library.ThemeRegistry[Instance] or {}
    local Scheme = Library.Scheme

    for Property, Value in Properties do
        if ThemeProperties[Property] then
            ThemeProperties[Property] = nil
        elseif Property ~= "Text" and (Scheme[Value] or typeof(Value) == "function") then
            ThemeProperties[Property] = Value
            __newindex(Instance, Property, Scheme[Value] or Value())
        elseif Property ~= "Parent" and Property ~= "Name" then
            __newindex(Instance, Property, Value)
        end
    end

    __newindex(Instance, "Name",   randomstring())
    __newindex(Instance, "Parent", Properties.Parent)

    if next(ThemeProperties) then
        Library.ThemeRegistry[Instance] = ThemeProperties
    end
end

local function Create(ClassName: string, Properties: hash | Instance | any): Instance
    local typeof
        = typeof

    -- It always use Frame instead of CanvasGroup 'cause the CanvasGroup works bad
    local Instance = Instance_new(ClassName ~= "CanvasGroup" and ClassName or "Frame")
    local Template = InstanceTemplates[ClassName ~= "CanvasGroup" and ClassName or "Frame"]

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
