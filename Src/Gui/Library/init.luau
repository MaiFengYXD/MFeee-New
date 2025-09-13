local task_spawn
    = task.spawn

type LibraryTips = (
    | "Resize"
)

local Library = {
    ThemeRegistry = {},
    Tips = {} :: {[LibraryTips]: Function}
}
shared.Gui.Library = Library

local LibraryConfig = shared.ConfigManager.new("UILibrary", {
    NotificationSound = "Preset 1", -- Preset 1: 4590662766, Preset 2: 4590657391
    NotificationSide  = "TopRight",
    ToggleKeybind     = "RightShift",

    EnabledKeybindFrame = false,
    CheckboxStyle       = false,
    CustomCursor        = false,
    AlwaysOnTop         = false,
    NoNotify            = false,
    BaseActivated       = true,

    DPIScale            = 1,
    NotificationVolume  = 2,
    NotificationSoundId = 4590662766,

    Tips = {
        Resize = true
    } :: {[LibraryTips]: boolean}
}, "ui.config.json")

local SchemeConfig = shared.ConfigManager.new("UILibraryScheme", {
    BackgroundColor = "#010409",

    PrimaryColor1 = "#238636",
    PrimaryColor2 = "#1f6feb",
    PrimaryColor3 = "#f78166",

    TextColor1 = "#f0f6fc",
    TextColor2 = "#9198a1",

    BoardColor1 = "#0d1117",
    BoardColor2 = "#151b23",
    BoardColor3 = "#212830",

    BorderColor = "#3d444d",

    PrimaryBoardColor  = "#121d2f",
    PrimaryBorderColor = "#214981",

    DangerTextColor   = "#fa5a51",
    DangerBoardColor  = "#b62324",
    DangerBorderColor = "#6b2a2b",

    Font = {
        "BuilderSans", -- Family
        "DemiBold",    -- Weight
        "Normal"       -- Style
    }
}, "scheme.config.json")

Library.Config = LibraryConfig.Config
Library.Scheme = SchemeConfig.Config

Library.CurrentConfig = {};do
    local math_max, math_min, UDim2_fromOffset
        = math.max, math.min, UDim2.fromOffset

    local CurrentConfig = Library.CurrentConfig

    local MaxSizeX = 480
    local MaxSizeY = 240
    local MinSizeX = 300
    local MinSizeY = 150

    if shared.DeviceType == "Desktop" then
        MaxSizeX = 600
        MaxSizeY = 400
    end

    local NormalSizeX = MaxSizeX
    local NormalSizeY = MaxSizeY

    local Camera = shared.Camera :: Camera

    shared.Connect.CommonSignals.CameraChanged(function(NewCamera: Camera)
        Camera = NewCamera
    end)

    local function Update()
        local ViewportSize = Camera.ViewportSize

        MaxSizeX = math_max(MaxSizeX, ViewportSize.X)
        MaxSizeY = math_max(MaxSizeY, ViewportSize.Y)
        MinSizeX = math_min(MinSizeX, ViewportSize.X, MaxSizeX)
        MinSizeY = math_min(MinSizeY, ViewportSize.Y, MaxSizeY)

        CurrentConfig.MaxSizeX = MaxSizeX
        CurrentConfig.MaxSizeY = MaxSizeY
        CurrentConfig.MinSizeX = MinSizeX
        CurrentConfig.MinSizeY = MinSizeY

        CurrentConfig.NormalSize = UDim2_fromOffset(
            math_min(NormalSizeX, MaxSizeX),
            math_min(NormalSizeY, MaxSizeY)
        )
    end

    shared.Connect:GiveSignal("UILibraryCurrentConfigSizeUpdates", Camera:GetPropertyChangedSignal("ViewportSize"), Update)
    Update()
end

local ElementTypes = {
    "DropdownMenu",
    "SortableList",
    "Toggle",
    "Button",
    "Slider",
    "Input",
    "Label",
    "ColorPicker",
    "KeyPicker"
}

local Elements = {}
for _, ElementType in ElementTypes do
    Elements[ElementType] = {}
end

Library.Elements = Elements
Library.Utils    = require("@self/../Utils")

Library.AddWindow = require("@self/Window")

for Name, TipCallback in Library.Tips do
    if not LibraryConfig.Tips[Name] then continue end

    task_spawn(TipCallback)
    LibraryConfig.Tips[Name] = false
end

return Library
