local UDim_new, UDim2_new, Font_fromEnum, Instance_new, randomstring, pcall, xpcall, typeof: typeof(typeof)
    = UDim.new, UDim2.new, Font.fromEnum, Instance.new, randomstring, pcall, xpcall, typeof

local string_find, debug_traceback, string_gsub, string_sub, string_match, task_defer
    = string.find, debug.traceback, string.gsub, string.sub, string.match, task.defer

local Library = ...
local Utils   = {}

--// MISC Utils //
local Mouse = shared.Speaker:GetMouse() :: Mouse

local function SafeCallback(Callback: Function, ...: any): any
    if typeof(Callback) ~= "function" then
        return
    end

    local Success, Response = xpcall(Callback, function(Error)
        local Traceback = string_gsub(debug_traceback(), "\n", " ")
        local _, Index  = string_find(Traceback, ":%d+ ")
        Traceback       = string_gsub(string_sub(Traceback, (Index or 0) + 1), " :", ":")

        task_defer(error, `{Error} - {Traceback}`)
        if Library.NotifyOnError then
            Library:Notify(Error)
        end
    end, ...)

    return Success and Response or nil
end

local function IsMouseOverFrame(Frame: GuiObject): boolean
    local Mouse
        = Mouse

    local AbsolutePosition = Frame.AbsolutePosition
    local AbsoluteSize     = Frame.AbsoluteSize

    return (
        Mouse.X >= AbsolutePosition.X and
        Mouse.X <= AbsolutePosition.X + AbsoluteSize.X and
        Mouse.Y >= AbsolutePosition.Y and
        Mouse.Y <= AbsolutePosition.Y + AbsoluteSize.Y
    )
end

--// Color Utils //
local Bright = Color3.new(1, 1, 1)
local Dark   = Color3.new()
local Lerp   = Dark.Lerp

local function GetDarkerColor(Color: Color3, Alpha: number?): Color3
    return Lerp(Color, Dark, Alpha or 0.5)
end

local function GetBetterColor(Color: Color3, Alpha: number?): Color3
    return Lerp(Color, Bright, Alpha or 0.5)
end

--// Scaling Utils //
local function ApplyDPIScale(Dimension: UDim | UDim2, ExtraOffset: array?): UDim | UDim2
    local DPIScale = Library.DPIScale

    if typeof(Dimension) == "UDim" then
        return UDim_new((Dimension :: UDim).Scale, (Dimension :: UDim).Offset * DPIScale)
    end

    if ExtraOffset then
        return UDim2_new(
            (Dimension :: UDim2).X.Scale,
            ((Dimension :: UDim2).X.Offset * DPIScale) + (ExtraOffset[1] * DPIScale),
            (Dimension :: UDim2).Y.Scale,
            ((Dimension :: UDim2).Y.Offset * DPIScale) + (ExtraOffset[2] * DPIScale)
        )
    end

    return UDim2_new(
        (Dimension :: UDim2).X.Scale,
        (Dimension :: UDim2).X.Offset * DPIScale,
        (Dimension :: UDim2).Y.Scale,
        (Dimension :: UDim2).Y.Offset * DPIScale
    )
end

local function ApplyTextScale(TextSize: number): number
    return TextSize * Library.DPIScale
end

--// Apparency Utils //
local BuilderSans = Font_fromEnum(Enum.Font.BuilderSans)

local function FixFont(FontFace: Font | Enum.Font): Font
    if typeof(FontFace) == "EnumItem" then
        return Font_fromEnum(FontFace :: Enum.Font)
    elseif typeof(FontFace) == "Font" then
        return FontFace :: Font
    end

    return BuilderSans
end

local Camera = shared.Camera
local TextService = shared.TextService
local GetTextBoundsAsync = TextService.GetTextBoundsAsync

local function GetTextBounds(
    Text:  string,
    Font:  Font | Enum.Font,
    Size:  number,
    Width: number?
): (number, number)
    local Params = Instance_new("GetTextBoundsParams");do
        Params.Text     = Text
        Params.RichText = true
        Params.Font     = FixFont(Font)
        Params.Size     = Size
        Params.Width    = Width or Camera.ViewportSize.X - 32
    end

    local Bounds = GetTextBoundsAsync(TextService, Params)
    return Bounds.X, Bounds.Y
end

local DPIRegistry = Library.DPIRegistry

local function UpdateDPI(Instance: Instance, Properties: hash)
    local CurrentRegistry = DPIRegistry[Instance]

    if not CurrentRegistry then
        return
    end

    for Property, Value in Properties do
        CurrentRegistry[Property] = Value or nil
    end
end

local Lucide = require("../Lucide")

local function GetAsset(Name: string): {
    Id:  number,
    Url: string,
    
    IconName:        string,
    ImageRectSize:   Vector2,
    ImageRectOffset: Vector2
}?
    local Success, Asset = pcall(Lucide.GetAsset, Name)
    return Success and Asset or nil
end

--// Creator Utils //
local Scheme   = Library.Scheme
local Registry = Library.Registry

local Templates = {
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    UICorner = {
        CornerRadius = function()
            return Scheme.CornerRadius
        end
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },

    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },

    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            return GetDarkerColor(Scheme.FontColor)
        end,
        Text = "",
        TextColor3 = "FontColor",
    }
}

---@private
local function __newindex(self: any, Key: string, Value: any)
    self[Key] = Value
end

---@private
local function Fill(
    Instance:   Instance,
    Properties: hash,
    __newindex: typeof(__newindex),
    pcall:      typeof(pcall),
    typeof:     typeof(typeof)
)
    local ThemeProperties = Registry   [Instance] or {}
    local DPIProperties   = DPIRegistry[Instance] or {}

    local DPIExclude = DPIProperties.DPIExclude or Properties.DPIExclude or {}
    local DPIOffset  = DPIProperties.DPIOffset  or Properties.DPIOffset  or {}

    for Key, Value in Properties do
        if Key == "Name" or Key == "Parent" then
            continue
        elseif Key == "DPIExclude" or Key == "DPIOffset" then
            continue
        elseif ThemeProperties[Key] then
            ThemeProperties[Key] = nil
        elseif Key ~= "Text" and (Scheme[Value] or typeof(Value) == "function") then
            ThemeProperties[Key] = Value
            pcall(__newindex, Instance, Key, Scheme[Value] or Value())
            continue
        end

        if not DPIExclude[Key] then
            if Key == "Position" or Key == "Size" or string_match(Key, "Padding") then
                DPIProperties[Key] = Value
                Value = ApplyDPIScale(Value, DPIOffset[Key])
            elseif Key == "TextSize" then
                DPIProperties[Key] = Value
                Value = ApplyTextScale(Value)
            end
        end

        pcall(__newindex, Instance, Key, Value)
    end

    if next(ThemeProperties) then
        Registry[Instance] = ThemeProperties
    end

    if next(DPIProperties) then
        DPIProperties.DPIExclude = DPIExclude
        DPIProperties.DPIOffset  = DPIOffset

        DPIRegistry[Instance] = DPIProperties
    end
end

local function Create(ClassName: string, Properties: hash | Instance | any): Instance
    local __newindex, pcall, typeof
        = __newindex, pcall, typeof

    local Instance = Instance_new(ClassName)
    pcall(__newindex, Instance, "Name", randomstring())

    if Templates[ClassName] then
        Fill(Instance, Templates[ClassName], __newindex, pcall, typeof)
    end

    if typeof(Properties) == "table" then
        Fill(Instance, Properties :: hash, __newindex, pcall, typeof)
        pcall(__newindex, Instance, "Parent", Properties.Parent)
    elseif typeof(Properties) == "Instance" then
        pcall(__newindex, Instance, "Parent", Properties)
    end

    return Instance
end

--// Bundle //
Utils.SafeCallback     = SafeCallback
Utils.IsMouseOverFrame = IsMouseOverFrame
Utils.GetDarkerColor   = GetDarkerColor
Utils.GetBetterColor   = GetBetterColor
Utils.ApplyDPIScale    = ApplyDPIScale
Utils.ApplyTextScale   = ApplyTextScale
Utils.FixFont          = FixFont
Utils.GetTextBounds    = GetTextBounds
Utils.GetAsset         = GetAsset
Utils.UpdateDPI        = UpdateDPI
Utils.Create           = Create

return Utils
