--[[
    Yep I'm gonna rewrite this entire UI Library AGAIN.
    Cause the current one looks so cheap! 😭
--]]

local error, xpcall, string_find, debug_traceback, string_gsub, string_sub, task_spawn, task_delay, table_clear
    = error, xpcall, string.find, debug.traceback, string.gsub, string.sub, task.spawn, task.delay, table.clear

local pcall, typeof, setmetatable, randomstring, Instance_new, table_insert, table_concat, table_find, Enum
    = pcall, typeof, setmetatable, randomstring, Instance.new, table.insert, table.concat, table.find, Enum

local      GetPropertyChangedSignal,      GetAttribute,      SetAttribute,      Destroy
    = game.GetPropertyChangedSignal, game.GetAttribute, game.SetAttribute, game.Destroy

local UserInputService = shared.UserInputService :: UserInputService

--// I used a custom event system (lua-based) to prevent "tables cannot be cyclic" errors
type EventStore = typeof(setmetatable({
    Events  = {} :: {Function},
    OnEvent = function(self: EventStore, Callback: Function): () end,
    Fire    = function(self: EventStore, ...:      any):      () end,
    Clear   = function(self: EventStore):                     () end
}, {__mode  = "kv" :: "kv"}))

local GetDarkerColor:   (Original: Color3, Alpha: number?) -> Color3,
      GetBrighterColor: (Original: Color3, Alpha: number?) -> Color3,

      SafeCallback:   (Callback:    Function?,   ...any) -> (boolean, ...any),
      IsHoverInput:   (InputObject: InputObject, OnlyMouse: boolean?) -> boolean,
      IsClickInput:   (InputObject: InputObject, IncludeM1: boolean?, IncludeM2: boolean?) -> boolean,
      IsOverFrame:    (Frame:       GuiObject,   Input:     InputObject) -> boolean,

      CreateEventStore: (Callback: Function?) -> EventStore

local Lerp: typeof(Color3.new().Lerp)

do
    local Bright = Color3.new(1, 1, 1)
    local Dark   = Color3.new()

    Lerp = Dark.Lerp

    local MouseMovement = Enum.UserInputType.MouseMovement
    local MouseButton1  = Enum.UserInputType.MouseButton1
    local MouseButton2  = Enum.UserInputType.MouseButton2
    local Touch         = Enum.UserInputType.Touch

    local Begin  = Enum.UserInputState.Begin
    local Change = Enum.UserInputState.Change

    function GetDarkerColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, Dark, Alpha or 0.5)
    end

    function GetBrighterColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, Bright, Alpha or 0.5)
    end

    function SafeCallback(Callback: Function, ...: any): (boolean, ...any)
        if not Callback or typeof(Callback) ~= "function" then
            return false, "No function provided"
        end

        return xpcall(Callback, function(Error: string)
            local Traceback = string_gsub(debug_traceback(), "\n", " ")
            local _, Index  = string_find(Traceback, ":%d+ ")

            Error ..= ` - {string_gsub(string_sub(Traceback, (Index or 0) + 1), " :", ":")}`
            task_spawn(error, Error)

            return Error
        end, ...)
    end

    function IsHoverInput(InputObject: InputObject, OnlyMouse: boolean?): boolean
        return InputObject.UserInputState == Change and (
            InputObject.UserInputType == MouseMovement or
            not OnlyMouse and (
                InputObject.UserInputType == Touch
            )
        )
    end

    function IsClickInput(InputObject: InputObject, IncludeM1: boolean?, IncludeM2: boolean?): boolean
        return InputObject.UserInputState == Begin and (
            IncludeM1 ~= false and (
                InputObject.UserInputType == MouseButton1
            ) or
            IncludeM2 and (
                InputObject.UserInputType == MouseButton2
            ) or
            InputObject.UserInputType == Touch
        )
    end

    function IsOverFrame(Frame: GuiObject, Input: InputObject): boolean
        local Position      = Input.Position
        local FrameSize     = Frame.AbsoluteSize
        local FramePosition = Frame.AbsolutePosition

        local PositionX      = Position.X
        local PositionY      = Position.Y
        local FramePositionX = FramePosition.X
        local FramePositionY = FramePosition.Y

        return PositionX >= FramePositionX and
               PositionY >= FramePositionY and
               PositionX <= FramePositionX + FrameSize.X and
               PositionY <= FramePositionY + FrameSize.Y
    end

    function CreateEventStore(Callback: Function?): EventStore
        local Event = setmetatable({
            Events = {Callback :: any}
        }, {__mode = "kv" :: "kv"}) :: EventStore

        function Event:OnEvent(Callback: Function): ()
            if not self.Events then
                self.Events = {Callback}
            else
                table_insert(self.Events, Callback)
            end
        end

        function Event:Fire(...: any): ()
            if not self.Events then return end
            for _, Callback in self.Events do
                task_spawn(Callback, ...)
            end
        end

        function Event:Clear(): ()
            table_clear(self.Events)
        end

        return Event
    end
end

local OnEvent, Fire, Disconnect, Wait;do
    local Store  = CreateEventStore()
    local Signal = game.Close

    OnEvent = Store.OnEvent
    Fire    = Store.Fire

    Wait       = Signal.Wait
    Disconnect = Signal:Once(function() end).Disconnect
end

local GetAsset = require("Lucide").GetAsset
local Validate = shared.Validate

local EasingLibrary = shared.EasingLibrary :: {Ease: Ease}
local Ease = EasingLibrary.Ease :: Ease

type Ease = (
    self:      typeof(EasingLibrary),
    Target:    Instance,
    Property:  string | {[string]: any},
    EndValue:  any,
    Index:     string | any,
    Duration:  number | nil,
    Mode:      string | Enum.EasingStyle | nil,
    Direction: string | Enum.EasingDirection | nil
) -> {
    Tween:       Tween | TweenBase,
    OnCompleted: RBXScriptConnection
} | nil

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local Translate = shared.Translator.Translate :: (string) -> string

type CustomCursorStyle = (
    | "Crosshair"
    | "ContentId"
)

type NotificationSide = (
    | "Center"
    | "Top"
    | "Bottom"
    | "TopLeft"
    | "TopRight"
    | "BottomLeft"
    | "BottomRight"
    | "Left"
    | "Right"
)

type NotificationDirection = (
    | "Vertical"
    | "Horizontal"
)

--// Base Groupboxes
local Dropdowns = {} :: {[string]: Dropdown}
local Toggles   = {} :: {[string]: Toggle}
local Buttons   = {} :: {[string]: Button}
local Sliders   = {} :: {[string]: Slider}
local Inputs    = {} :: {[string]: Input}
local Labels    = {} :: {[string]: Label}

--// Base Addons
local KeyPickers   = {} :: {[string]: KeyPicker}
local ColorPickers = {} :: {[string]: ColorPicker}

local Library = {
    ShowCustomCursor  = false,
    CustomCursorStyle = "Crosshair" :: CustomCursorStyle,
    CustomCursorId    = "rbxasset://SystemCursors/Arrow" :: RobloxId | ContentId,

    WindowSize      = shared.DeviceType == "Mobile" and UDim2.fromOffset(480, 300) or UDim2.fromOffset(720, 500),
    WindowSizeEvent = CreateEventStore(),

    DPIScale = 1,

    NotificationSide      = "BottomRight" :: NotificationSide,
    NotificationDirection = "Vertical"    :: NotificationDirection,
    NotificationSound     = "rbxassetid://4590662766" :: ContentId,
    NotificationVolume    = 2,

    NoNotify = false,

    NotificationSideEvent = CreateEventStore(),

    Scheme = {
        BackgroundColor = Color3.fromHex("111019"),
        PrimaryColor    = Color3.fromHex("141929"),
        SecondaryColor  = Color3.fromHex("243b52"),
        AccentColor     = Color3.fromHex("57b3e1"),
        OutlineColor    = Color3.fromHex("170c17"),
        FontColor       = Color3.fromHex("FFFFFF"),
        RiskyColor      = Color3.fromHex("d02525"),

        Font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.SemiBold)
    },

    ThemeRegistry = {},

    Windows = {} :: {Window},

    Dropdowns = Dropdowns,
    Toggles   = Toggles,
    Buttons   = Buttons,
    Sliders   = Sliders,
    Inputs    = Inputs,
    Labels    = Labels,

    KeyPickers   = KeyPickers,
    ColorPickers = ColorPickers,

    UseCheckbox      = false,
    UseCheckboxEvent = CreateEventStore(),

    TwoColumnGroupboxes      = false,
    TwoColumnGroupboxesEvent = CreateEventStore(),

    FocusedContextMenu = CreateEventStore(),

    ClipsSafeArea = false,
    AlwaysOnTop   = false,
    UIActivated   = false
}

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

local ElementTemplates = {} :: {[string]: () -> table}

function ElementTemplates.Notification()
    return {
        Title   = nil,
        Text    = "",
        Time    = 5,
        SoundId = Library.NotificationSound,
        Side    = Library.NotificationSide
    } :: NotificationInfo
end

function ElementTemplates.NotificationArray()
    return {
        [1] = "",
        [2] = 5,
        [3] = Library.NotificationSound,
        [4] = Library.NotificationSide
    } :: NotificationInfoArray
end

function ElementTemplates.Window()
    return {
        Icon              = "",
        Title             = Translate("Window"),
        DPIScale          = Library.DPIScale,
        NotificationSide  = Library.NotificationSide,
        NotificationSound = Library.NotificationSound,
        ShowCustomCursor  = false,
        AlwaysOnTop       = false,
        UIActivated       = false
    } :: WindowInfo
end

function ElementTemplates.Dropdown()
    return {
        Text            = Translate("Dropdown"),
        Values          = {""},
        Default         = "",
        Disabled        = false,
        DisabledValues  = {},
        Visible         = true,
        Risky           = false,
        Tooltip         = nil,
        DisabledTooltip = nil,
        AllowNull       = false,
        Multi           = false,
        SpecialType     = nil,
        ExcludeSpeaker  = true,
        Searchable      = false,
        Compact         = false,
        Callback        = function() end
    } :: DropdownInfo
end

function ElementTemplates.Toggle()
    return {
        Text            = Translate("Toggle"),
        Default         = false,
        Disabled        = false,
        Visible         = true,
        Risky           = false,
        Tooltip         = nil,
        DisabledTooltip = nil,
        Callback        = function() end
    } :: ToggleInfo
end

function ElementTemplates.Button()
    return {} :: ButtonInfo
end

function ElementTemplates.Slider()
    return {} :: SliderInfo
end

function ElementTemplates.Input()
    return {} :: InputInfo
end

function ElementTemplates.Label()
    return {} :: LabelInfo
end

function ElementTemplates.KeyPicker()
    return {} :: KeyPickerInfo
end

function ElementTemplates.ColorPicker()
    return {} :: ColorPickerInfo
end

do
    local ViewportSize = shared.Camera.ViewportSize :: Vector2

    local SizeX = Library.WindowSize.X.Offset
    local SizeY = Library.WindowSize.Y.Offset

    SizeX = ViewportSize.X < SizeX and ViewportSize.X or SizeX
    SizeY = ViewportSize.Y < SizeY and ViewportSize.Y or SizeY

    Library.WindowSize = UDim2.fromOffset(SizeX, SizeY)
end

--// Helpers //
local math_min, math_max
    = math.min, math.max

local InputChanged   = UserInputService.InputChanged
local WindowFocused  = UserInputService.WindowFocused
local TextboxFocused = UserInputService.TextBoxFocused

local End = Enum.UserInputState.End

local function __newindex(self: any, Key: string, Value: any)
    pcall(function(self, Key, Value)
        self[Key] = Value
    end, self, Key, Value)
end

local function __index(self: any, Key: string): any
    local Success, Response = pcall(function(self, Key)
        return self[Key]
    end, self, Key)

    return Success and Response or nil
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

local function GetUnscaledTextBounds(TextElement: TextLabel | TextButton, Latitude: "X" | "Y" | nil): Vector2 | number
    local TextBounds = TextElement.TextBounds / Library.DPIScale

    return (
        Latitude == "X" and TextBounds.X or
        Latitude == "Y" and TextBounds.Y or
        TextBounds
    )
end

local function GetUnscaledContentSize(UIListLayout: UIListLayout, Latitude: "X" | "Y" | any): Vector2 | number
    local ContentSize = UIListLayout.AbsoluteContentSize / Library.DPIScale

    return (
        Latitude == "X" and ContentSize.X or
        Latitude == "Y" and ContentSize.Y or
        ContentSize
    )
end

local function UpdateWithContentSize(
    Frame:        ScrollingFrame | Frame,
    UIListLayout: UIListLayout,
    Offset:       UDim2?,
    MaxSize:      number?
)
    local ExtraOffset = Offset or UDim2.fromScale(0, 0)
    local MaxSizeY    = MaxSize or (1 / 0)

    local Key = Frame.ClassName == "ScrollingFrame" and "CanvasSize" or "Size"

    local function Update()
        local Frame: any, Key: string
            = Frame,      Key

        local CurrentSize = Frame[Key] :: UDim2

        Frame[Key] = UDim2.new(
            CurrentSize.X.Scale,
            CurrentSize.X.Offset,
            CurrentSize.Y.Scale,
            math_min(GetUnscaledContentSize(UIListLayout, "Y") :: number, MaxSizeY)
        ) + ExtraOffset
    end

    GiveSignal(Connect, nil, GetPropertyChangedSignal(UIListLayout, "AbsoluteContentSize"), Update)
    Update()
end

local function ToContentId(Original: string | number): string
    return Original and (
        typeof(Original) == "string" and (Original :: string) or `rbxassetid://{Original}`
    ) or ""
end

local function MakeRotatable(
    Target:    ImageButton,
    Bounding:  (TextButton | ImageButton)?,
    Callback:  Function?,
    Increment: number?
): () -> ()
    local Id = randomstring(20)

    local TheIncrement = Increment or 180
    local NextRotation = Target.Rotation

    local function Rotate()
        NextRotation += TheIncrement
        Ease(EasingLibrary, Target, "Rotation", NextRotation, Id, 0.25)
        SafeCallback(Callback)
    end

    GiveSignal(Connect, Id, (Bounding or Target).Activated, Rotate)
    return Rotate
end

local function GetDraggableBase(
    Target:    GuiObject | typeof(table.create(2, Create("Frame") :: GuiObject)),
    Bounding:  GuiObject,
    IdSeed:    number,
    Event:     EventStore?,
    Key:       string?,
    Offset:    UDim2?,
    MinSize:   typeof(table.create(2, 1) :: {number})?
)
    local Target1: GuiObject,
          Target2: GuiObject?

    local ExtraOffset = Offset or UDim2.fromOffset(0, 0)
    local Tracking    = Key or "Position"

    if typeof(Target) == "table" then
        Target1 = (Target :: {GuiObject})[1]
        Target2 = (Target :: {GuiObject})[2]
    else
        Target1 = Target :: GuiObject
    end

    local MinSizeX = 0
    local MinSizeY = 0

    if MinSize then
        MinSizeX = (MinSize :: {number})[1]
        MinSizeY = (MinSize :: {number})[2]
    end

    local DragId1 = randomstring(IdSeed)
    local DragId2 = randomstring(IdSeed + 1)

    local IsDragging = false
    SetAttribute(Target1, "IsDragging", GetAttribute(Target1, "IsDragging") or false)

    GiveSignal(Connect, nil, Bounding.InputBegan, function(InputObject: InputObject)
        if (
            IsDragging or not IsClickInput(InputObject) or GetAttribute(Target1, "IsDragging")
        ) then return end

        SetAttribute(Target1, "IsDragging", true)
        IsDragging = true

        local StartPosition = InputObject.Position
        local FramePosition = (Target1 :: any)[Tracking] :: UDim2

        local FrameX = FramePosition.X.Offset
        local FrameY = FramePosition.Y.Offset

        local Changed, Ended, Focused1, Focused2

        local function DisconnectAll()
            IsDragging = false
            SetAttribute(Target1, "IsDragging", false)

            Disconnect(Changed)
            Disconnect(Ended)
            Disconnect(Focused1)
            Disconnect(Focused2)
        end

        Changed = if MinSize then GiveSignal(Connect, nil, InputChanged, function(Input: InputObject)
            if not IsHoverInput(Input) then return end

            local Delta    = (Input.Position - StartPosition) / Library.DPIScale
            local Position = UDim2.fromOffset(
                math_max(Delta.X + FrameX, MinSizeX),
                math_max(Delta.Y + FrameY, MinSizeY)
            )

            Ease(EasingLibrary, Target1, Tracking, Position, DragId1, 0.25, "Quintic")
            if Target2 then
                Ease(EasingLibrary, Target2, Tracking, Position + ExtraOffset, DragId2, 0.25, "Quintic")
            end

            if Event then Fire(Event, Position) end
        end) else GiveSignal(Connect, nil, InputChanged, function(Input: InputObject)
            if not IsHoverInput(Input) then return end

            local Delta    = (Input.Position - StartPosition) / Library.DPIScale
            local Position = FramePosition + UDim2.fromOffset(Delta.X, Delta.Y)

            Ease(EasingLibrary, Target1, Tracking, Position, DragId1, 0.25, "Quintic")
            if Target2 then
                Ease(EasingLibrary, Target2, Tracking, Position + ExtraOffset, DragId2, 0.25, "Quintic")
            end

            if Event then Fire(Event, Position) end
        end)

        Ended = GiveSignal(Connect, nil, GetPropertyChangedSignal(InputObject, "UserInputState"), function()
            if InputObject.UserInputState ~= End then return end
            DisconnectAll()
        end)

        Focused1 = GiveSignal(Connect, nil, WindowFocused,  DisconnectAll)
        Focused2 = GiveSignal(Connect, nil, TextboxFocused, DisconnectAll)
    end)
end

local function MakeDraggable(
    Target:   GuiObject | typeof(table.create(2, Create("Frame") :: GuiObject)),
    Bounding: GuiObject,
    Event:    EventStore?,
    Offset:   UDim2?
)
    GetDraggableBase(Target, Bounding, 26, Event, nil, Offset)
end

local function MakeResizable(
    Target:   GuiObject | typeof(table.create(2, Create("Frame") :: GuiObject)),
    Bounding: GuiObject,
    Event:    EventStore?,
    MinSize:  typeof(table.create(2, 1) :: {number})?
)
    GetDraggableBase(Target, Bounding, 28, Event, "Size", nil, MinSize)
end

--// Main //
local BaseGroupboxes = {}
local BaseAddons     = {}

local WindowSizeEvent = Library.WindowSizeEvent

local ScreenGui = Create("ScreenGui", {
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ClipToDeviceSafeArea = false,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    AutoLocalize = false,
    DisplayOrder = 2^31 - 3,
    Name = randomstring(),
    Parent = shared.ScreenGui
}) :: ScreenGui

local NotificationArea = Create("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Parent = ScreenGui,
    ZIndex = 3
})

local NotificationList = Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    Parent = NotificationArea
}) :: UIListLayout

Create("UIPadding", {
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5),
    Parent = NotificationArea
})

Library.ScreenGui        = ScreenGui
Library.NotificationArea = NotificationArea
Library.NotificationList = NotificationList

--// Library __newindex
local Library__newindexFunction
local Library__newindex = {} :: {[any]: any};do
    local Left   = Enum.HorizontalAlignment.Left
    local Right  = Enum.HorizontalAlignment.Right
    local Center = Enum.HorizontalAlignment.Center

    local Top     = Enum.VerticalAlignment.Top
    local Bottom  = Enum.VerticalAlignment.Bottom
    local Center2 = Enum.VerticalAlignment.Center

    local Vertical   = Enum.FillDirection.Vertical
    local Horizontal = Enum.FillDirection.Horizontal

    local None             = Enum.ScreenInsets.None
    local DeviceSafeInsets = Enum.ScreenInsets.DeviceSafeInsets

    local Scheme = Library.Scheme

    local UseCheckboxEvent         = Library.UseCheckboxEvent
    local TwoColumnGroupboxesEvent = Library.TwoColumnGroupboxesEvent

    local MouseIconEnabled = UserInputService:GetPropertyChangedSignal("MouseIconEnabled")
    local MouseIcon        = UserInputService:GetPropertyChangedSignal("MouseIcon")

    local MouseFrame = Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(25, 25),
        Position = UDim2.fromScale(0.5, 0.5),
        Parent = ScreenGui
    }) :: Frame

    Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 2, 1, 0),
        Parent = MouseFrame
    })

    Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 2, 1, 0),
        Rotation = 90,
        Parent = MouseFrame
    })

    local MouseMoveSignal, MouseIconEnabledSignal, MouseIconSignal

    local SupportOnTopOfCoreBlur = pcall(function()
        Instance.new("ScreenGui").OnTopOfCoreBlur = true
    end)

    function Library__newindex.NotificationSide(Side: NotificationSide)
        local IsCenter = string_find(Side, "Center")

        NotificationList.HorizontalAlignment = (
            string_find(Side, "Right") and Right or
            IsCenter and Center or
            Left
        )
        NotificationList.VerticalAlignment = (
            string_find(Side, "Top") and Top or
            IsCenter and Center2 or
            Bottom
        )
    end

    function Library__newindex.NotificationSound(SoundId: string | number)
        SoundId = ToContentId(SoundId) :: string
        if typeof(SoundId) ~= "string" then return end

        Library.NotificationSound = SoundId :: string
    end

    function Library__newindex.NotificationDirection(Direction: NotificationDirection)
        NotificationList.FillDirection = (
            Direction == "Vertical" and Vertical or Horizontal
        )
    end

    function Library__newindex.UseCheckbox(Enabled: boolean)
        Fire(UseCheckboxEvent, Enabled)
    end

    function Library__newindex.TwoColumnGroupboxes(Enabled: boolean)
        Fire(TwoColumnGroupboxesEvent, Enabled)
    end

    function Library__newindex.WindowSize(Size: UDim2)
        Fire(WindowSizeEvent, Size)
    end

    function Library__newindex.ShowCustomCursor(Enabled: boolean)
        if MouseMoveSignal then MouseMoveSignal = Disconnect(MouseMoveSignal) end
        if MouseIconSignal then MouseIconSignal = Disconnect(MouseIconSignal) end
        if MouseIconEnabledSignal then MouseIconEnabledSignal = Disconnect(MouseIconEnabledSignal) end

        MouseFrame.Parent = Enabled and ScreenGui or nil

        if not Enabled then
            UserInputService.MouseIconEnabled = true
            return
        end

        if Library.CustomCursorStyle == "Crosshair" then
            MouseMoveSignal = GiveSignal(Connect, nil, InputChanged, function(InputObject: InputObject)
                if not IsHoverInput(InputObject) then return end
                __newindex(MouseFrame, "Position", UDim2.fromOffset(InputObject.Position.X, InputObject.Position.Y))
            end)

            MouseIconEnabledSignal = GiveSignal(Connect, nil, MouseIconEnabled, function()
                __newindex(UserInputService, "MouseIconEnabled", false)
            end)
        else
            MouseIconSignal = GiveSignal(Connect, nil, MouseIcon, function()
                __newindex(UserInputService, "MouseIcon", Library.CustomCursorId)
            end)

            MouseIconEnabledSignal = GiveSignal(Connect, nil, MouseIconEnabled, function()
                __newindex(UserInputService, "MouseIconEnabled", true)
            end)
        end
    end

    function Library__newindex.DPIScale(Scale: number)
        for _, Window in Library.Windows do
            Window.UIScale.Scale = Scale
        end
    end

    function Library__newindex.ClipsSafeArea(Enabled: boolean)
        ScreenGui.ScreenInsets = Enabled and DeviceSafeInsets or None
        ScreenGui.ClipToDeviceSafeArea = Enabled
    end

    function Library__newindex.AlwaysOnTop(Enabled: boolean)
        if not SupportOnTopOfCoreBlur then return end

        shared.ScreenGui.OnTopOfCoreBlur = Enabled
        ScreenGui.OnTopOfCoreBlur = Enabled
    end

    function Library__newindex.UIActivated(Enabled: boolean)
        for _, Window in Library.Windows do
            Window.BaseCanvas.Active = Enabled
        end
    end

    local function UpdateTheme(...)
        for Instance: any, Properties in Library.ThemeRegistry do
            for Property, Value in Properties do
                if typeof(Value) == "string" then
                    Instance[Property] = Scheme[Value]
                elseif typeof(Value) == "function" then
                    Instance[Property] = Value()
                end
            end
        end
    end

    Library__newindex[Scheme] = {}

    for Key in Scheme do
        Library__newindex[Scheme][Key] = UpdateTheme
    end
end

do
    local rawset
        = rawset

    function Library__newindexFunction(self: typeof(Library) & table, Key: string, Value: any)
        local __newindex = Library__newindex

        rawset(self, Key, Value)

        if self == Library and __newindex[Key] then
            __newindex[Key](Value)
        elseif __newindex[self] and __newindex[self][Key] then
            __newindex[self][Key](Value)
        end
    end
end

do
    local FocusedContextMenu = Library.FocusedContextMenu
    local CurrentFocused = nil

    OnEvent(FocusedContextMenu, function(Focused)
        CurrentFocused = Focused
    end)

    GiveSignal(Connect, "LibraryContextMenuUnfocused1", UserInputService.InputBegan, function(Input: InputObject)
        if not (CurrentFocused and IsClickInput(Input) and IsOverFrame(CurrentFocused, Input)) then return end
        Fire(FocusedContextMenu)
    end)

    GiveSignal(Connect, "LibraryContextMenuUnfocused2", WindowFocused, function()
        Fire(FocusedContextMenu)
    end)

    GiveSignal(Connect, "LibraryContextMenuUnfocused3", TextboxFocused, function()
        Fire(FocusedContextMenu)
    end)
end

--// Types
type BooleanCallback = (Value: boolean) -> ()
type NumberCallback  = (Value: number)  -> ()

type NotificationInfo = {
    Title:       string?,
    Text:        string,
    Description: string,
    Time:        number | Instance,
    Duration:    number | Instance,
    SoundId:     number | string,
    Side:        NotificationSide
}

type NotificationInfoArray = {
    | string
    | number
    | ContentId
    | NotificationSide
}

type Notification = {
    Title:      string?,
    Text:       string,
    Time:       number | Instance,
    SoundId:    string,
    Side:       NotificationSide,
    Background: Frame,
    List:       UIListLayout,
    TitleLabel: TextLabel,
    TitleLine:  Frame,
    TextLabel:  TextLabel,
    TimeBar:    Frame,
    Bar:        Frame,
    Update:     (self: Notification) -> ()
}

type WindowInfo = {
    Icon:              string | number,
    Title:             string,
    DPIScale:          number,
    NotificationSide:  NotificationSide,
    NotificationSound: string,
    ShowCustomCursor:  boolean,
    AlwaysOnTop:       boolean,
    UIActivated:       boolean
}

type Window = {
    CurrentTab:        Tab?,
    Tabs:              {Tab},
    UIScale:           UIScale,
    BaseCanvas:        Frame,
    BaseShadow:        Frame,
    LeftPanel:         Frame,
    TitleContainer:    Frame,
    TabsScrolling:     ScrollingFrame,
    TabsContainer:     Frame,
    RightPanel:        Frame,
    ContentsContainer: ScrollingFrame,
    Collapsed:         boolean,
    CollapsedEvent:    EventStore,
    MinimizedEvent:    EventStore,
    SwitchTabEvent:    EventStore,
    AddTab:            (self: Window, Name: string, Icon: string?) -> Tab
}

type Tab = {
    Window:           Window,
    Num:              number,
    Id:               number,
    LayoutOrder:      number,
    Groupboxes:       {Groupbox},
    Focused:          boolean,
    Holder:           Frame,
    UIListLayout:     UIListLayout,
    Container:        ScrollingFrame,
    LeftContainer:    Frame,
    RightContainer:   Frame,
    TextHolder:       TextLabel,
    IconHolder:       ImageLabel,
    AddGroupbox:      (self: Tab, Title: string, Side: "Left" | "Right") -> Groupbox,
    AddLeftGroupbox:  (self: Tab, ...string) -> Groupbox,
    AddRightGroupbox: (self: Tab, ...string) -> Groupbox
}

type Groupbox = typeof(setmetatable({
    Side        = "Left" :: "Left" | "Right",
    Tab         = {}     :: Tab,
    Num         = 1      :: number,
    LayoutOrder = 1      :: number,
    Container   = game   :: Frame,
    Elements    = {}     :: {AllGroupboxes},
}, {__index     = BaseGroupboxes}))

type BaseInstance<Element> = typeof(setmetatable({}, {
    __index    = game :: Element, -- wtf I can cast game into Element 'cause they are related
    __newindex = function(self: BaseInstance<Element> & table, Key: string, Value: any): () end
}))

type DropdownInfo = {
    Text:            string,
    Values:          array,
    Default:         any | array,
    Disabled:        boolean,
    DisabledValues:  array,
    Visible:         boolean,
    Risky:           boolean,
    Tooltip:         string?,
    DisabledTooltip: string?,
    AllowNull:       boolean,
    Multi:           boolean,
    SpecialType:     "Players" | "Teams" | nil,
    ExcludeSpeaker:  boolean,
    Searchable:      boolean,
    Compact:         boolean,
    Callback:        (Value: any | array) -> ()
}

type ToggleInfo = {
    Text:            string,
    Default:         boolean,
    Disabled:        boolean,
    Visible:         boolean,
    Risky:           boolean,
    Tooltip:         string?,
    DisabledTooltip: string?,
    Callback:        BooleanCallback
}

type ButtonInfo = {

}

type SliderInfo = {

}

type InputInfo = {

}

type LabelInfo = {

}

type KeyPickerInfo = {

}

type ColorPickerInfo = {

}

type DropdownOption = typeof(setmetatable({
    Selected = false :: boolean,
    Button   = game  :: TextButton,
    Update   = function(self: DropdownOption): () end,
}, {__mode   = "kv"  :: "kv"}))

type Dropdown = {
    Groupbox:        Groupbox,
    Num:             number,
    LayoutOrder:     number,
    Index:           string,
    Text:            string,
    Value:           any | array,
    Values:          array,
    Disabled:        boolean,
    DisabledValues:  array,
    Visible:         boolean,
    Risky:           boolean,
    Tooltip:         string?,
    DisabledTooltip: string?,
    AllowNull:       boolean,
    Multi:           boolean,
    Callback:        {(Value: any | array) -> ()},
    Options:         {[string]: DropdownOption},
    Type:            "Dropdown",
    Container:       Frame,
    Holder:          TextButton,
    HolderText:      TextLabel,
    HolderImage:     ImageLabel,
    Title:           TextLabel,
    MenuContainer:   Frame,
    ContextMenu:     ScrollingFrame,
    SearchBox:       TextBox,
    Update:          (self: Dropdown) -> (),
    Trigger:         (self: Dropdown,            Value: any | array)        -> (),
    OnChanged:       (self: Dropdown, Callback: (Value: any | array) -> ()) -> ()
}

type Toggle = typeof(setmetatable({
    Groupbox         = setmetatable({}, {}) :: Groupbox,
    Num              = 1        :: number,
    LayoutOrder      = 1        :: number,
    Index            = ""       :: string,
    Text             = ""       :: string,
    Value            = false    :: boolean,
    Risky            = false    :: boolean,
    Disabled         = false    :: boolean,
    Visible          = true     :: boolean,
    Tooltip          = nil      :: string?,
    DisabledTooltip  = nil      :: string?,
    Callback         = {}       :: {BooleanCallback},
    Type             = "Toggle" :: "Toggle",
    Addons           = {}       :: {AllAddons},
    Container        = game     :: Frame,
    Holder           = game     :: TextButton,
    Title            = game     :: TextLabel,
    Switch           = game     :: Frame,
    Ball             = game     :: Frame,
    Checkbox         = game     :: Frame,
    CheckImage       = game     :: ImageLabel,
    Update           = function(self: Toggle): () end,
    Trigger          = function(self: Toggle, Value:    boolean):         () end,
    OnChanged        = function(self: Toggle, Callback: BooleanCallback): () end
}, {__index = BaseAddons}))

type Button = {

}

type Slider = {

}

type Input = {

}

type Label = typeof(setmetatable({

}, {__index = BaseAddons}))

type KeyPicker = {

}

type ColorPicker = {

}

type AllGroupboxes = Dropdown | Toggle | Button | Slider | Input | Label
type AllAddons     = KeyPicker | ColorPicker

--// Methods
local TextLeft   = Enum.TextXAlignment.Left
local TextRight  = Enum.TextXAlignment.Right
local TextCenter = Enum.TextXAlignment.Center

local SoundService = shared.SoundService :: SoundService

function Library.Notify(self: typeof(Library), ...: NotificationInfo): Notification
    local Notification: Notification

    if typeof(...) == "table" then
        local NotificationInfo = ...
        Validate(NotificationInfo, ElementTemplates.Notification())

        Notification = {
            Title = NotificationInfo.Title,
            Text = NotificationInfo.Description or NotificationInfo.Text,
            Time = NotificationInfo.Duration or NotificationInfo.Time,
            SoundId = ToContentId(NotificationInfo.SoundId),
            Side = NotificationInfo.Side
        } :: Notification
    else
        local NotificationInfo = {...} :: array
        Validate(NotificationInfo, ElementTemplates.NotificationArray())

        Notification = {
            Text = NotificationInfo[1],
            Time = NotificationInfo[2],
            SoundId = NotificationInfo[3],
            Side = NotificationInfo[4]
        } :: Notification
    end

    if self.NoNotify then return Notification end

    local IsLeft  = string_find(Notification.Side, "Left")
    local IsRight = string_find(Notification.Side, "Right")

    local Container = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0, 0),
        Parent = NotificationArea
    })

    local Background = Create("CanvasGroup", {
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.new(1, 8, 0, 0),
        Parent = Container
    }) :: Frame

    if IsRight then
        Background.Position = -Background.Position
    end

    local List = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = Background
    }) :: UIListLayout

    Create("UICorner", Background)

    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        Parent = Background
    })

    if Notification.Title then
        local Title = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Notification.Title,
            TextSize = 22,
            TextTransparency = 0.2,
            TextXAlignment = IsLeft and TextLeft or IsRight and TextRight or TextCenter,
            Parent = Background
        }) :: TextLabel

        local TitleLine = Create("Frame", {
            BackgroundColor3 = "PrimaryColor",
            Size = UDim2.new(1, 8, 0, 2),
            Position = UDim2.fromScale(0, 0.5),
            Parent = Title
        }) :: Frame

        Create("UICorner", TitleLine)

        Notification.TitleLabel = Title
        Notification.TitleLine  = TitleLine
    end

    local Text = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0, 0),
        Text = Notification.Text,
        TextSize = 18,
        TextTransparency = 0.3,
        TextXAlignment = IsLeft and TextLeft or IsRight and TextRight or TextCenter,
        Parent = Background
    }) :: TextLabel

    Notification.Background = Background
    Notification.List       = List
    Notification.TextLabel  = Text

    function Notification.Update(self: Notification)
        local Background = self.Background
        local Title      = self.TitleLabel
        local Text       = self.TextLabel

        local TitleBounds = GetUnscaledTextBounds(Title) :: Vector2
        local TextBounds  = GetUnscaledTextBounds(Text) :: Vector2

        Title.Size = UDim2.fromOffset(TitleBounds.X, TitleBounds.Y)
        Text.Size  = UDim2.fromOffset(TextBounds.X, TextBounds.Y)

        self.TitleLine.Position = UDim2.new(1, TitleBounds.X + 5, 0.5, 0)

        local ListSize = GetUnscaledContentSize(self.List) :: Vector2
        Background.Size = UDim2.fromOffset(ListSize.X + 5, ListSize.Y + 5)
    end

    Notification:Update()
    Ease(EasingLibrary, Background, "Position", UDim2.fromScale(0, 0), Background, 0.4)

    if typeof(Notification.Time) == "Instance" then
        task_spawn(function()
            Wait((Notification.Time :: Instance).Destroying)
            Ease(EasingLibrary, Background, "Position", UDim2.new(1, 8, 0, 0), Background, 0.4)
        end)
    else
        local TimeBar = Create("Frame", {
            BackgroundColor3 = "PrimaryColor",
            Size = UDim2.new(1, 0, 0, 4),
            Parent = Background
        }) :: Frame

        local Bar = Create("Frame", {
            BackgroundColor3 = function()
                return GetDarkerColor(self.Scheme.AccentColor, 0.1)
            end,
            Size = UDim2.fromScale(1, 1),
            Parent = TimeBar
        }) :: Frame

        Create("UICorner", TimeBar)
        Create("UICorner", Bar)

        Notification.TimeBar = TimeBar
        Notification.Bar     = Bar

        Ease(EasingLibrary, Bar, "Size", UDim2.fromScale(0, 1), Bar, 0.4, "Linear")
        task_delay(Notification.Time :: number, Ease, EasingLibrary, Background, "Position", UDim2.new(1, 8, 0, 0), Background, 0.4)
    end

    Destroy(Create("Sound", {
        SoundId = Notification.SoundId,
        Volume = self.NotificationVolume,
        PlayOnRemove = true,
        Parent = SoundService
    }))

    return Notification
end

function Library.CreateWindow(self: typeof(Library), WindowInfo: WindowInfo): Window
    Validate(WindowInfo, ElementTemplates.Window())

    local function Config(Property: string)
        local Value = WindowInfo[Property]
        if Value == nil then return end

        Library__newindexFunction(self, Property, Value)
    end

    Config("UIActivated")
    Config("DPIScale")
    Config("NotificationSide")
    Config("NotificationSound")
    Config("NotificationVolume")
    Config("ShowCustomCursor")
    Config("AlwaysOnTop")
    Config("UIActivated")
    Config("NoNotify")

    local Window = {
        CurrentTab = nil :: Tab?,
        Tabs = {} :: {Tab}
    } :: Window

    local BaseCanvas = Create("CanvasGroup", {
        Active = WindowInfo.UIActivated,
        BackgroundTransparency = 1,
        Size = Library.WindowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        ZIndex = 2,
        Parent = ScreenGui
    }) :: Frame

    BaseCanvas.Position -= UDim2.fromOffset(
        BaseCanvas.Size.X.Offset / 2,
        BaseCanvas.Size.Y.Offset / 2
    )

    local BaseShadow = Create("Frame", {
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(),
        Size = BaseCanvas.Size,
        Position = BaseCanvas.Position + UDim2.fromOffset(2, 2),
        Parent = ScreenGui
    }) :: Frame

    Create("UICorner", BaseCanvas)
    Create("UICorner", BaseShadow)

    local UIScale = Create("UIScale", {
        Scale = WindowInfo.DPIScale,
        Parent = ScreenGui
    }) :: UIScale

    GiveSignal(Connect, nil, GetPropertyChangedSignal(UIScale, "Scale"), function()
        if Library.DPIScale ~= UIScale.Scale then
            Library.DPIScale = UIScale.Scale
        end
    end)

    Window.BaseCanvas = BaseCanvas
    Window.BaseShadow = BaseShadow
    Window.UIScale    = UIScale

    local LeftPanel = Create("CanvasGroup", {
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.new(0, 200, 1, 0),
        ZIndex = 2,
        Parent = BaseCanvas
    }) :: Frame

    Create("UICorner", LeftPanel)
    Window.LeftPanel = LeftPanel

    local TitleContainer = Create("CanvasGroup", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = LeftPanel
    })

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(50, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = WindowInfo.Title,
        TextSize = 28,
        TextXAlignment = TextLeft,
        Parent = TitleContainer
    })

    Create("Frame", {
        BackgroundColor3 = "PrimaryColor",
        Position = UDim2.fromOffset(0, 39),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = LeftPanel
    })

    local TabsScrolling = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 1, -80),
        Parent = LeftPanel
    }) :: ScrollingFrame

    local TabsContainer = Create("CanvasGroup", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(4, 0),
        Size = UDim2.fromScale(1, 1),
        Parent = TabsScrolling
    }) :: Frame

    UpdateWithContentSize(TabsContainer, Create("UIListLayout", TabsContainer) :: UIListLayout)

    Window.TabsScrolling = TabsScrolling
    Window.TabsContainer = TabsContainer

    Create("Frame", {
        BackgroundColor3 = "PrimaryColor",
        Position = UDim2.new(0, 0, 1, -41),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = LeftPanel
    })

    local ComponentsContainer = Create("CanvasGroup", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -40),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = LeftPanel
    })

    local RightPanel = Create("CanvasGroup", {
        BackgroundColor3 = "PrimaryColor",
        Position = UDim2.fromOffset(184, 0),
        Size = UDim2.new(1, -184, 1, 0),
        Parent = BaseCanvas
    }) :: Frame

    Create("UICorner", RightPanel)

    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        Parent = RightPanel
    })

    local ContentsContainer = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ScrollingEnabled = false,
        Parent = RightPanel
    }) :: ScrollingFrame

    Create("UIListLayout", ContentsContainer)

    Window.RightPanel        = RightPanel
    Window.ContentsContainer = ContentsContainer

    do
        local ResizeArea = Create("TextButton", {
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = 0.1,
            Size = UDim2.fromOffset(38, 38),
            Position = UDim2.new(1, -30, 1, -30),
            Parent = BaseCanvas
        }) :: TextButton

        Create("UICorner", ResizeArea)

        local Asset = GetAsset("maximize-2")

        Create("ImageLabel", {
            Size = UDim2.new(1, -14, 1, -14),
            Position = UDim2.fromOffset(3, 3),
            Image = Asset.Url,
            ImageRectSize = Asset.ImageRectSize,
            ImageRectOffset = Asset.ImageRectOffset,
            ImageTransparency = 0.1,
            Rotation = 90,
            Parent = ResizeArea
        })

        MakeResizable(
            {
                BaseCanvas,
                BaseShadow
            } :: {GuiObject},
            ResizeArea :: GuiObject,
            WindowSizeEvent,
            {400, 250}
        )
    end

    local CollapsedEvent = CreateEventStore();do
        local Asset = GetAsset("arrow-left-to-line")

        local CollapseButton = Create("ImageButton", {
            Active = true,
            Position = UDim2.fromOffset(8, 4),
            Size = UDim2.fromOffset(32, 32),
            Image = Asset.Url,
            ImageRectSize = Asset.ImageRectSize,
            ImageRectOffset = Asset.ImageRectOffset,
            ImageTransparency = 0.1,
            Parent = ComponentsContainer
        }) :: ImageButton

        Window.Collapsed = false

        MakeRotatable(CollapseButton, nil, function()
            local Collapsed  = not Window.Collapsed
            Window.Collapsed = Collapsed
            Fire(CollapsedEvent, Collapsed)
        end)
    end

    local MinimizedEvent = CreateEventStore();do
        local Asset = GetAsset("minimize")

        local MinimizeButton = Create("ImageButton", {
            Position = UDim2.fromOffset(50, 4),
            Size = UDim2.fromOffset(32, 32),
            Image = Asset.Url,
            ImageRectSize = Asset.ImageRectSize,
            ImageRectOffset = Asset.ImageRectOffset,
            ImageTransparency = 0.1,
            Parent = ComponentsContainer
        }) :: ImageButton

        local WindowIcon = Create("ImageButton", {
            Position = UDim2.fromOffset(8, 2),
            Size = UDim2.fromOffset(35, 35),
            Image = ToContentId(WindowInfo.Icon),
            Parent = TitleContainer
        }) :: ImageButton

        local Minimized = false

        GiveSignal(Connect, nil, MinimizeButton.Activated, function()
            Minimized = not Minimized
            Fire(MinimizedEvent, Minimized)
        end)

        GiveSignal(Connect, nil, WindowIcon.Activated, function(_, Repeated: number)
            if Repeated < 1 then return end

            Minimized = not Minimized
            Fire(MinimizedEvent, Minimized)
        end)

        local NeedToBeDraggable = {
            BaseCanvas,
            BaseShadow
        } :: {GuiObject}

        MakeDraggable(
            NeedToBeDraggable,
            TitleContainer :: GuiObject,
            nil,
            UDim2.fromOffset(2, 2)
        )

        MakeDraggable(
            NeedToBeDraggable,
            WindowIcon,
            nil,
            UDim2.fromOffset(2, 2)
        )
    end

    local SwitchTabEvent = CreateEventStore();do
        local Id = randomstring(23)

        OnEvent(SwitchTabEvent, function(Tab: Tab)
            Tab.Focused = true
            Window.CurrentTab = Tab

            Ease(EasingLibrary, ContentsContainer, "CanvasPosition", Vector2.new(
                0,
                (Tab.Num - Tab.Num) * Library.WindowSize.Y.Offset
            ), Id, 0.3)

            Ease(EasingLibrary, Tab.TextHolder, "TextTransparency", 0.10, Tab.Id, 0.2)
            Ease(EasingLibrary, Tab.IconHolder, "ImageTransparency", 0.10, Tab.Id, 0.2)
            Ease(EasingLibrary, Tab.Holder, "BackgroundTransparency", 0.6, Tab.Id, 0.2)

            for _, Tab_ in Window.Tabs do
                if Tab_ == Tab then continue end
                Tab_.Focused = false

                Ease(EasingLibrary, Tab_.TextHolder, "TextTransparency", 0.3, Tab_.Id, 0.2)
                Ease(EasingLibrary, Tab_.IconHolder, "ImageTransparency", 0.3, Tab_.Id, 0.2)
                Ease(EasingLibrary, Tab_.Holder, "BackgroundTransparency", 1.0, Tab_.Id, 0.2)
            end
        end)
    end

    Window.CollapsedEvent = CollapsedEvent
    Window.MinimizedEvent = MinimizedEvent
    Window.SwitchTabEvent = SwitchTabEvent

    function Window:AddTab(Name: string, Icon: string?): Tab
        local NumTabs = #self.Tabs

        local Tab = {
            Window = self,
            Id = tick(),
            Num = NumTabs + 1,
            LayoutOrder = NumTabs,
            Focused = false,
            Groupboxes = {}
        } :: Tab

        local Holder = Create("CanvasGroup", {
            BackgroundTransparency = 1,
            BackgroundColor3 = "SecondaryColor",
            Size = UDim2.new(1, 0, 0, 35),
            LayoutOrder = Tab.LayoutOrder,
            Parent = self.TabsScrolling
        }) :: Frame

        Create("UICorner", Create("Frame", {
            BackgroundColor3 = "PrimaryColor",
            Position = UDim2.new(0, 42, 1, -2),
            Size = UDim2.new(1, -40, 0, 2),
            ImageTransparency = 0.3,
            Parent = Holder
        }))

        local TextHolder = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(45, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Text = Name,
            TextSize = 24,
            TextTransparency = 0.3,
            TextXAlignment = TextLeft,
            Parent = Holder
        }) :: TextLabel

        Tab.Holder     = Holder
        Tab.TextHolder = TextHolder

        local Asset = GetAsset(Icon)

        if Asset then
            Tab.IconHolder = Create("ImageLabel", {
                Position = UDim2.fromOffset(8, 3),
                Size = UDim2.fromOffset(30, 30),
                Image = Asset.Url,
                ImageRectSize = Asset.ImageRectSize,
                ImageRectOffset = Asset.ImageRectOffset,
                Parent = Holder
            }) :: ImageLabel
        end

        GiveSignal(Connect, nil, (Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -2, 1, 0),
            ZIndex = 2,
            Parent = Holder
        }) :: TextButton).Activated, function()
            Fire(self.SwitchTabEvent, Tab)
        end)

        GiveSignal(Connect, nil, Holder.MouseEnter, function()
            if Tab.Focused then return end
            Ease(EasingLibrary, Holder, "BackgroundTransparency", 0.8, Tab.Id, 0.2)
        end)

        GiveSignal(Connect, nil, Holder.MouseLeave, function()
            if Tab.Focused then return end
            Ease(EasingLibrary, Holder, "BackgroundTransparency", 1, Tab.Id, 0.2)
        end)

        self.ContentsContainer.CanvasSize = UDim2.fromScale(0, 1 + Tab.Num)

        local Container = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Library.WindowSize.Y.Offset),
            LayoutOrder = Tab.LayoutOrder,
            Parent = self.ContentsContainer
        }) :: ScrollingFrame

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 7),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 7),
            Parent = Container
        })

        OnEvent(WindowSizeEvent, function(NewSize: UDim2)
            Container.Size = UDim2.new(1, 0, 0, NewSize.Y.Offset)
        end)

        local UIListLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            Parent = Container
        }) :: UIListLayout

        Tab.UIListLayout = UIListLayout
        Tab.Container    = Container

        UpdateWithContentSize(Container, UIListLayout)

        local LeftContainer = Create("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = Container
        }) :: Frame

        local RightContainer = Create("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = Container
        }) :: Frame

        UpdateWithContentSize(LeftContainer,  Create("UIListLayout", LeftContainer)  :: UIListLayout)
        UpdateWithContentSize(RightContainer, Create("UIListLayout", RightContainer) :: UIListLayout)

        Tab.LeftContainer  = LeftContainer
        Tab.RightContainer = RightContainer

        local Horizontal = Enum.FillDirection.Horizontal
        local Vertical   = Enum.FillDirection.Vertical

        OnEvent(Window.CollapsedEvent, function(Collapsed: boolean)
            if Library.TwoColumnGroupboxes then return end
            UIListLayout.FillDirection = Collapsed and Horizontal or Vertical
        end)

        OnEvent(Library.TwoColumnGroupboxesEvent, function(Enabled: boolean)
            if Window.Collapsed then return end
            UIListLayout.FillDirection = Enabled and Horizontal or Vertical
        end)

        if Library.TwoColumnGroupboxes then
            UIListLayout.FillDirection = Horizontal

            LeftContainer.Size  = UDim2.fromScale(0.5, 0)
            RightContainer.Size = UDim2.fromScale(0.5, 0)
        end

        function Tab:AddGroupbox(Title: string, Side: "Left" | "Right"): Groupbox
            local NumGroupboxes = #self.Groupboxes

            local Groupbox = setmetatable({
                Side = Side,
                Tab = self,
                Num = NumGroupboxes + 1,
                LayoutOrder = NumGroupboxes,
                Elements = {}
            }, {__index = BaseGroupboxes}) :: Groupbox

            local Container = Create("CanvasGroup", {
                BackgroundColor3 = "BackgroundColor",
                LayoutOrder = Groupbox.LayoutOrder,
                Size = UDim2.fromScale(1, 0),
                Parent = self[`{Side}Container`]
            }) :: Frame

            Create("UICorner", Container)

            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                Parent = Container
            })

            UpdateWithContentSize(Container, Create("UIListLayout", {
                Padding = UDim.new(0, 5),
                Parent = Container
            }) :: UIListLayout, UDim2.fromOffset(0, 5))

            Groupbox.Container = Container

            if Title then
                Container.Size = UDim2.new(1, 0, 0, 30)

                local TitleContainer = Create("CanvasGroup", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Container
                })

                local TitleLabel = Create("TextLabel", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 1),
                    Text = Title,
                    TextSize = 20,
                    TextTransparency = 0.3,
                    TextXAlignment = TextLeft,
                    Parent = TitleContainer
                }) :: TextLabel

                TitleLabel.Size = UDim2.new(
                    0,
                    (GetUnscaledTextBounds(TitleLabel, "X") :: number) + 5,
                    1,
                    0
                )

                Create("UICorner", Create("Frame", {
                    BackgroundColor3 = "PrimaryColor",
                    Position = UDim2.new(0, 0, 0.5, -1),
                    Size = UDim2.new(1, 0, 0, 2),
                    ZIndex = 0,
                    Parent = TitleContainer
                }))
            end

            self.Groupboxes[Groupbox.Num] = Groupbox
            return Groupbox
        end

        function Tab:AddLeftGroupbox(...)
            return self:AddGroupbox(..., "Left")
        end

        function Tab:AddRightGroupbox(...)
            return self:AddGroupbox(..., "Right")
        end

        self.Tabs[Tab.Num] = Tab
        if not self.CurrentTab then
            Fire(self.SwitchTabEvent, Tab)
        end

        return Tab
    end

    table_insert(self.Windows, Window)
    return Window
end

do
    local string_lower
        = string.lower

    local CaptureFocus, ReleaseFocus;do
        local TextBox = Create("TextBox") :: TextBox

        CaptureFocus = TextBox.CaptureFocus
        ReleaseFocus = TextBox.ReleaseFocus

        Destroy(TextBox)
    end

    local PlayerChanged = CreateEventStore()
    local TeamChanged   = CreateEventStore()

    local Border = Enum.ApplyStrokeMode.Border

    function BaseGroupboxes.AddDropdown(self: Groupbox, Index: string, DropdownInfo: DropdownInfo): BaseInstance<Dropdown>
        Validate(DropdownInfo, ElementTemplates.Dropdown())
        local NumElements = #self.Elements

        local Dropdown = {
            Groupbox = self,
            Num = NumElements + 1,
            LayoutOrder = NumElements,
            Index = Index,
            Callback = {DropdownInfo.Callback},
            Options = {},
            Type = "Dropdown" :: "Dropdown"
        } :: Dropdown

        for _, Property in {
            "Text",
            "Value",
            "Values",
            "Disabled",
            "DisabledValues",
            "Visible",
            "Risky",
            "Tooltip",
            "DisabledTooltip",
            "AllowNull",
            "Multi"
        } do
            Dropdown[Property] = DropdownInfo[Property]
        end

        local GroupboxContainer = self.Container

        local DropdownContainer = Create("CanvasGroup", {
            BackgroundColor3 = "SecondaryColor",
            BackgroundTransparency = 0.7,
            Size = UDim2.new(1, 0, 0, DropdownInfo.Compact and 30 or 56),
            LayoutOrder = Dropdown.LayoutOrder,
            Parent = GroupboxContainer
        }) :: Frame

        local Holder = Create("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundColor3 = "SecondaryColor",
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, -12, 0, 24),
            Position = UDim2.fromOffset(6, DropdownInfo.Compact and 3 or 27),
            Parent = DropdownContainer,
            ZIndex = 3
        }) :: TextButton

        local AdornmentContainer = Create("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Holder
        })

        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            Parent = AdornmentContainer
        })

        local HolderText = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            TextTransparency = 0.33,
            TextSize = 16,
            Text = "---",
            TextXAlignment = TextLeft,
            Parent = AdornmentContainer
        }) :: TextLabel

        local SearchBox: TextBox?
        if DropdownInfo.Searchable then
            SearchBox = Create("TextBox", {
                Active = false,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                TextSize = 16,
                Text = "",
                TextXAlignment = TextLeft,
                ClearTextOnFocus = true,
                Parent = AdornmentContainer,
                ZIndex = 2
            }) :: TextBox

            Dropdown.SearchBox = SearchBox :: TextBox
        end

        local Asset = GetAsset("chevron-down")
        local function Rotate()
            --/ A placeholder
        end

        if Asset then
            local HolderImage = Create("ImageLabel", {
                Image = Asset.Url,
                ImageRectSize = Asset.ImageRectSize,
                ImageRectOffset = Asset.ImageRectOffset,
                Position = UDim2.new(1, -18, 0, 3),
                Size = UDim2.fromOffset(18, 18),
                Parent = AdornmentContainer
            })

            Rotate = MakeRotatable(HolderImage :: ImageButton, Holder)
            Dropdown.HolderImage = HolderImage :: ImageLabel
        end

        Dropdown.Container  = DropdownContainer
        Dropdown.Holder     = Holder
        Dropdown.HolderText = HolderText

        local Title = Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -12, 0, 26), 
            Position = UDim2.fromOffset(6, 3),
            Text = Dropdown.Text,
            TextSize = 18,
            TextTransparency = 0.3,
            TextXAlignment = TextLeft,
            TextColor3 = Dropdown.Risky and "RiskyColor" or "FontColor",
            Parent = DropdownContainer,
            ZIndex = 2
        }) :: TextLabel

        local TextBounds = GetUnscaledTextBounds(Title, "X") :: number

        if DropdownInfo.Compact then
            Holder.Size     = UDim2.new(1, -TextBounds - 6, 1, -6)
            Holder.Position = UDim2.fromOffset(TextBounds + 12, 0)
        end

        Dropdown.Title = Title

        Create("UICorner", DropdownContainer)

        Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = Holder
        })

        local ContextMenuContainer = Create("CanvasGroup", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = Holder
        }) :: Frame

        local ContextMenu = Create("ScrollingFrame", {
            BackgroundColor3 = function()
                return GetDarkerColor(Library.Scheme.PrimaryColor, 0.2)
            end,
            Size = UDim2.fromScale(1, 1),
            Parent = ContextMenuContainer
        }) :: ScrollingFrame

        Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = ContextMenuContainer
        })

        local UIListLayout = Create("UIListLayout", ContextMenu) :: UIListLayout
        UpdateWithContentSize(ContextMenu, UIListLayout)

        Dropdown.MenuContainer = ContextMenuContainer
        Dropdown.ContextMenu   = ContextMenu

        local Options = Dropdown.Options

        local function SetValue(Value: any | array)
            Dropdown.Value = Value
            Dropdown:Update()

            for _, Option in Options do
                Option:Update()
            end

            if not Dropdown.Disabled then
                for _, Callback in Dropdown.Callback do
                    SafeCallback(Callback, Value)
                end
            end
        end

        function Dropdown.OnChanged(self: Dropdown, Callback: (Value: any | array) -> ())
            table_insert(self.Callback, Callback)
        end

        function Dropdown.Trigger(self: Dropdown, Value: any | array)
            self.Value = Value
            self:Update()

            if not self.Disabled then
                for _, Callback in self.Callback do
                    SafeCallback(Callback, Value)
                end
            end
        end

        --[[
            Used in: GetPropertyChangedSignal(SearchBox, "Text"), __newindex
        --]]
        local function BuildList()
            local setmetatable, Create, Options, Dropdown, string_lower, string_find
                = setmetatable, Create, Options, Dropdown, string_lower, string_find

            for Index, Option in Options do
                Destroy(Option.Button)
                Options[Index] = nil
            end

            local Values         = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues

            local Update = Dropdown.Update
            local Text   = SearchBox and SearchBox.Text

            for Index, Value in Values do
                if Text and not string_find(string_lower(Value), string_lower(Text)) then continue end

                local Option = setmetatable({}, {__mode = "kv" :: "kv"}) :: DropdownOption

                local Button = Create("TextButton", {
                    BackgroundColor3 = "SecondaryColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = Index,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = `{Value}`,
                    TextSize = 16,
                    TextTransparency = 0.4,
                    TextXAlignment = TextLeft,
                    Parent = ContextMenu
                }) :: TextButton

                Create("UIStroke", {
                    ApplyStrokeMode = Border,
                    Parent = Button
                })

                if next(Values) then
                    Create("Frame", {
                        BackgroundColor3 = "OutlineColor",
                        Size = UDim2.new(1, 0, 0, 2),
                        Position = UDim2.new(0, 0, 1, -1),
                        Parent = Button
                    })
                end

                Option.Button   = Button
                Option.Selected = false

                local IsDisabled = table_find(DisabledValues, Value)

                function Option:Update()
                    local Selected = if Dropdown.Multi then
                        table_find(Dropdown.Value, Value) ~= nil
                    else Dropdown.Value == Value

                    self.Selected = Selected
                    local Button = self.Button

                    Ease(EasingLibrary, Button, "BackgroundTransparency", Selected and 0.2 or 1, Button, 0.25)
                    Ease(EasingLibrary, Button, "TextTransparency", IsDisabled and 0.7 or Selected and 0.1 or 0.4, Option, 0.25)
                end

                Option:Update()
                Update(Dropdown)

                Options[Value] = Option
                if IsDisabled then continue end

                GiveSignal(Connect, Button, Button.Activated, function()
                    local CurrentValue = Dropdown.Value
                    local Try = not Option.Selected

                    if Dropdown.Multi and (Dropdown.AllowNull or CurrentValue ~= Value) then
                        return SetValue(Try and Value or (if Dropdown.AllowNull then nil else CurrentValue))
                    end

                    if Try then
                        table_insert(CurrentValue, Value)
                    else
                        (CurrentValue :: array)[table_find(CurrentValue, Value) :: number] = nil
                    end

                    SetValue(CurrentValue)
                end)
            end
        end

        function Dropdown.Update(self: Dropdown)
            if self.Multi then
                local Values    = self.Values
                local ValueList = {}

                for _, Value in self.Value :: array do
                    if not table_find(Values, Value) then continue end
                    table_insert(ValueList, Value)
                end

                self.HolderText.Text = table_concat(ValueList, ", ")
            else
                self.HolderText.Text = self.Value or "---"
            end

            local Scheme        = Library.Scheme
            local ThemeRegistry = Library.ThemeRegistry

            local Disabled = self.Disabled
            local Value    = self.Value

            local Title      = self.Title
            local HolderText = self.HolderText

            Title.Text = self.Text
            Title.TextColor3 = self.Risky and Scheme.RiskyColor or Scheme.FontColor

            if Disabled then
                local HolderColor = function()
                    
                end

                ThemeRegistry[Title].TextTransparency = 0.6
                ThemeRegistry[HolderText].TextTransparency = 0.65

                Ease(EasingLibrary, Title, "TextTransparency", 0.6, Title, 0.25)
                Ease(EasingLibrary, HolderText, "TextTransparency", 0.65, HolderText, 0.25)
            end

            BuildList()
        end

        local FocusedContextMenu = Library.FocusedContextMenu
        local Closed = true

        local function Toggle()
            if Dropdown.Disabled then return end
            Closed = not Closed

            if Closed then
                if SearchBox then
                    ReleaseFocus(SearchBox)
                    SearchBox.Active = false
                    SearchBox.Text = ""
                end

                ContextMenuContainer.Size = UDim2.fromScale(1, 0)
            else
                if SearchBox then
                    HolderText.Text = ""
                    SearchBox.Active = true
                    CaptureFocus(SearchBox)
                end

                Ease(EasingLibrary, ContextMenuContainer, "Size", UDim2.new(
                    1,
                    0,
                    0,
                    math_min(GetUnscaledContentSize(UIListLayout, "Y") :: number, 120)
                ), ContextMenuContainer, 0.5, "Quintic")
            end

            Rotate()

            if not Closed then
                Fire(FocusedContextMenu, ContextMenu)
            end
        end

        GiveSignal(Connect, nil, Holder.Activated, Toggle)

        OnEvent(FocusedContextMenu, function(Focused: GuiObject)
            if Focused == ContextMenu then return end
            Toggle()
        end)

        if SearchBox then
            GiveSignal(Connect, nil, GetPropertyChangedSignal(SearchBox, "Text"), BuildList)
        end

        local function SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled
            if not Closed then Toggle() end
        end

        SetValue(Dropdown.Value)

        local function __newindex(self: BaseInstance<Dropdown> & table, Key: string, Value: any)
            if Key == "Value" then
                SetValue(Value)
            elseif Key == "Disabled" then
                SetDisabled(Value)
            elseif Dropdown[Key] then
                Dropdown[Key] = Value
                Dropdown:Update()
            else
                rawset(self, Key, Value)
            end
        end

        return setmetatable({}, {
            __index    = Dropdown :: any,
            __newindex = __newindex
        })
    end
end

function BaseGroupboxes.AddToggle(self: Groupbox, Index: string, ToggleInfo: ToggleInfo): BaseInstance<Toggle>
    Validate(ToggleInfo, ElementTemplates.Toggle())
    local NumElements = #self.Elements

    local Toggle = setmetatable({
        Groupbox = self,
        Num = NumElements + 1,
        LayoutOrder = NumElements,
        Index = Index,
        Callback = {ToggleInfo.Callback},
        Type = "Toggle" :: "Toggle",
        Addons = {}
    }, {__index = BaseAddons}) :: Toggle

    for _, Property in {
        "Text",
        "Value",
        "Risky",
        "Disabled",
        "Visible",
        "Tooltip",
        "DisabledTooltip"
    } do
        Toggle[Property] = ToggleInfo[Property]
    end

    local GroupboxContainer = self.Container

    local ToggleContainer = Create("CanvasGroup", {
        BackgroundColor3 = "SecondaryColor",
        BackgroundTransparency = 0.7,
        Size = UDim2.new(1, 0, 0, 30),
        LayoutOrder = Toggle.LayoutOrder,
        Parent = GroupboxContainer
    }) :: Frame

    local Holder = Create("TextButton", {
        Active = not Toggle.Disabled,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -12, 1, -6),
        Position = UDim2.fromOffset(6, 3),
        Parent = ToggleContainer,
        ZIndex = 3
    }) :: TextButton

    local Title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -12, 1, -6),
        Position = UDim2.fromOffset(6, 3),
        Text = Toggle.Text,
        TextSize = 18,
        TextTransparency = 0.3,
        TextXAlignment = TextLeft,
        TextColor3 = Toggle.Risky and "RiskyColor" or "FontColor",
        Parent = ToggleContainer,
        ZIndex = 2
    }) :: TextLabel

    Create("UICorner", Holder)
    Create("UICorner", ToggleContainer)

    Toggle.Container = ToggleContainer
    Toggle.Holder    = Holder
    Toggle.Title     = Title

    local Switch = Create("CanvasGroup", {
        BackgroundColor3 = function()
            return GetBrighterColor(ToggleContainer.BackgroundColor3, 0.1)
        end,
        Size = UDim2.fromOffset(36, 18),
        Position = UDim2.new(1, -42, 0, 6),
        Parent = ToggleContainer
    }) :: Frame

    local Ball = Create("Frame", {
        BackgroundColor3 = "OutlineColor",
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromOffset(1, 1),
        Parent = Switch
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim.new(1),
        Parent = Switch
    })

    Create("UICorner", {
        CornerRadius = UDim.new(1),
        Parent = Ball
    })

    Create("UIStroke", Switch)

    Toggle.Switch = Switch
    Toggle.Ball   = Ball

    local Checkbox = Create("CanvasGroup", {
        BackgroundColor3 = function()
            return GetBrighterColor(ToggleContainer.BackgroundColor3, 0.1)
        end,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromOffset(0, 4),
        Size = UDim2.fromOffset(18, 18),
        Parent = ToggleContainer
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = Checkbox
    })

    Create("UIStroke", Checkbox)

    local Asset = GetAsset("check")

    if Asset then
        Toggle.CheckImage = Create("ImageLabel", {
            Image = Asset.Url,
            ImageRectSize = Asset.ImageRectSize,
            ImageRectOffset = Asset.ImageRectOffset,
            ImageTransparency = 1,
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.fromOffset(2, 2),
            Parent = Checkbox
        }) :: ImageLabel
    end

    Toggle.Checkbox = Checkbox

    --[[
        Used in: SetValue, __newindex.
    --]]
    function Toggle.Update(self: Toggle)
        local Scheme        = Library.Scheme
        local ThemeRegistry = Library.ThemeRegistry

        local Disabled   = self.Disabled
        local Value      = self.Value

        local Title      = self.Title
        local Container  = self.Container
        local Switch     = self.Switch
        local Ball       = self.Ball
        local Checkbox   = self.Checkbox
        local CheckImage = self.CheckImage

        Title.Text       = self.Text
        Title.TextColor3 = self.Risky and Scheme.RiskyColor or Scheme.FontColor

        ThemeRegistry[Title].TextColor3 = self.Risky and "RiskyColor" or "FontColor"

        self.Holder.Active    = not Disabled
        Container.Parent = self.Visible and self.Groupbox.Container or nil

        if Disabled then
            local SwitchColor = function()
                return GetDarkerColor(Container.BackgroundColor3, 0.1)
            end

            local CheckboxColor = function()
                return GetDarkerColor(Container.BackgroundColor3, 0.1)
            end

            ThemeRegistry[Ball].BackgroundColor3     = "OutlineColor"
            ThemeRegistry[Title].TextTransparency    = 0.6
            ThemeRegistry[Switch].BackgroundColor3   = SwitchColor
            ThemeRegistry[Checkbox].BackgroundColor3 = CheckboxColor

            Ease(EasingLibrary, Ball, "BackgroundColor3", Scheme.OutlineColor, Ball, 0.25)
            Ease(EasingLibrary, Title, "TextTransparency", 0.6, Title, 0.25)
            Ease(EasingLibrary, Switch, "BackgroundColor3", SwitchColor(), Switch, 0.25)
            Ease(EasingLibrary, Checkbox, "BackgroundColor3", CheckboxColor(), Checkbox, 0.25)
            if CheckImage then Ease(EasingLibrary, CheckImage, "ImageTransparency", 0.5, CheckImage, 0.25) end

            return
        end

        local SwitchColor = function()
            return Value and GetDarkerColor(Scheme.AccentColor, 0.1) or GetBrighterColor(Container.BackgroundColor3, 0.1)
        end

        local CheckboxColor = function()
            return Value and GetDarkerColor(Scheme.AccentColor, 0.1) or GetBrighterColor(Container.BackgroundColor3, 0.1)
        end

        local BallColor = function()
            return Value and GetDarkerColor(Scheme.OutlineColor, 0.1) or Scheme.OutlineColor
        end

        ThemeRegistry[Title].TextTransparency    = Value and 0.1 or 0.3
        ThemeRegistry[Switch].BackgroundColor3   = SwitchColor
        ThemeRegistry[Checkbox].BackgroundColor3 = CheckboxColor

        Ease(EasingLibrary, Title, "TextTransparency", Value and 0.1 or 0.3, Title, 0.25)
        Ease(EasingLibrary, Switch, "BackgroundColor3", SwitchColor(), Switch, 0.25)
        Ease(EasingLibrary, Checkbox, "BackgroundColor3", CheckboxColor(), Checkbox, 0.25)
        Ease(EasingLibrary, Ball, "BackgroundColor3", BallColor(), Ball, 0.25)
        Ease(EasingLibrary, Ball, "Position", UDim2.fromOffset(Value and 19 or 1, 1), Ball.Name, 0.25)

        if CheckImage then Ease(EasingLibrary, CheckImage, "ImageTransparency", Value and 0 or 1, CheckImage, 0.25) end
    end

    function Toggle.Trigger(self: Toggle, Value: boolean)
        for _, Callback in self.Callback do
            task_spawn(SafeCallback, Callback, Value)
        end
    end

    function Toggle.OnChanged(self:Toggle, Callback: BooleanCallback)
        table_insert(self.Callback, Callback)
    end

    local function SetValue(Value: boolean)
        local self = Toggle
        local CurrentValue = self.Value

        self.Value = Value
        self:Update()

        if Value ~= CurrentValue then
            self:Trigger(Value)
        end
    end

    OnEvent(Library.UseCheckboxEvent, function(UseCheckbox: boolean)
        Ease(EasingLibrary, Checkbox, "Position", UDim2.new(UseCheckbox and 1 or 0, UseCheckbox and 4 or 0, 0, 4), Checkbox, 0.25)
        Ease(EasingLibrary, Switch, "Position", UDim2.new(1, UseCheckbox and 0 or 42, 0, 0), Switch, 0.25)
    end)

    GiveSignal(Connect, nil, Holder.Activated, function()
        SetValue(not Toggle.Value)
    end)

    self.Elements[Toggle.Num] = Toggle
    Toggles[Index] = Toggle

    SetValue(Toggle.Value)

    local function __newindex(self: BaseInstance<Toggle> & table, Key: string, Value: any)
        if Key == "Value" then
            SetValue(Value)
        elseif Toggle[Key] then
            Toggle[Key] = Value
            Toggle:Update()
        else
            rawset(self, Key, Value)
        end
    end

    return setmetatable({}, {
        __index    = Toggle :: any,
        __newindex = __newindex
    })
end

function BaseGroupboxes.AddButton(self: Groupbox, ButtonInfo: ButtonInfo)

end

function BaseGroupboxes.AddSlider(self: Groupbox, SliderInfo: SliderInfo)

end

function BaseGroupboxes.AddInput(self: Groupbox, InputInfo: InputInfo)

end

function BaseGroupboxes.AddLabel(self: Groupbox, LabelInfo: LabelInfo)

end

function BaseAddons.AddKeyPicker(self: Toggle | Label, KeyPickerInfo: KeyPickerInfo)

end

function BaseAddons.AddColorPicker(self: Toggle | Label, ColorPickerInfo: ColorPickerInfo)

end

--// Finalizer //
return setmetatable({}, {
    __index    = Library,
    __newindex = Library__newindexFunction
})
