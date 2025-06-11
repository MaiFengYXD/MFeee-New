local pcall, typeof, setmetatable, randomstring, Instance_new, Enum: typeof(Enum)
    = pcall, typeof, setmetatable, randomstring, Instance.new, Enum

local      GetPropertyChangedSignal,                                 Disconnect
    = game.GetPropertyChangedSignal, game.Close:Once(function() end).Disconnect

local UserInputService = shared.UserInputService :: UserInputService

--// I used a custom event system to prevent "tables cannot be cyclic" errors
type EventStore = {
    OnEvent: (self: EventStore, Callback: Function) -> (),
    Fire:    (self: EventStore, ...any) -> (),
    Clear:   (self: EventStore) -> (),
    Events:  {Function}
}

local GetDarkerColor: (Original: Color3, Alpha: number?) -> Color3,
      GetBrightColor: (Original: Color3, Alpha: number?) -> Color3,

      SafeCallback:   (Callback: Function, ...any) -> (boolean, ...any),
      IsHoverInput:   (InputObject: InputObject)   -> boolean,
      IsClickInput:   (InputObject: InputObject, IncludeM1: boolean?, IncludeM2: boolean?) -> boolean,

      CreateEventStore: (Callback: Function?) -> EventStore

do
    local error, xpcall, string_find, debug_traceback, string_gsub, string_sub, task_defer, table_clear
        = error, xpcall, string.find, debug.traceback, string.gsub, string.sub, task.defer, table.clear

    local Bright = Color3.new(1, 1, 1)
    local Dark   = Color3.new()

    local Lerp = Dark.Lerp

    local MouseMovement = Enum.UserInputType.MouseMovement
    local MouseButton1  = Enum.UserInputType.MouseButton1
    local MouseButton2  = Enum.UserInputType.MouseButton2
    local Touch         = Enum.UserInputType.Touch

    local Begin  = Enum.UserInputState.Begin
    local Change = Enum.UserInputState.Change

    function GetDarkerColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, Dark, Alpha or 0.5)
    end

    function GetBrightColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, Bright, Alpha or 0.5)
    end

    function SafeCallback(Callback: Function, ...: any): (boolean, ...any)
        if not Callback or typeof(Callback) ~= "function" then
            return false, "No function provided"
        end

        return xpcall(Callback, function(Error: string)
            local Traceback = string_gsub(debug_traceback(), "\n", " ")
            local _, Index  = string_find(Traceback, ":%d+ ")
            Traceback       = string_gsub(string_sub(Traceback, (Index or 0) + 1), " :", ":")

            Error ..= ` - {Traceback}`
            task_defer(error, Error)

            return Error
        end, ...)
    end

    function IsHoverInput(InputObject: InputObject): boolean
        return InputObject.UserInputState == Change and (
            InputObject.UserInputType == MouseMovement or InputObject.UserInputType == Touch
        )
    end

    function IsClickInput(InputObject: InputObject, IncludeM1: boolean?, IncludeM2: boolean?): boolean
        return InputObject.UserInputState == Begin and (
            IncludeM1 ~= false and (
                IncludeM1 and InputObject.UserInputType == MouseButton1
            ) or
            IncludeM2 and (
                InputObject.UserInputType == MouseButton2
            ) or
            InputObject.UserInputType == Touch
        )
    end

    function CreateEventStore(Callback: Function?): EventStore
        local Event = {
            Events = {Callback :: any}
        } :: EventStore

        function Event:OnEvent(Callback: Function): ()
            self.Events[#self.Events + 1] = Callback
        end

        function Event:Fire(...: any): ()
            for _, Callback in self.Events do
                task_defer(Callback, ...)
            end
        end

        function Event:Clear(): ()
            table_clear(self.Events)
        end

        return Event
    end
end

local OnEvent, Fire;do
    local Store = CreateEventStore()

    OnEvent = Store.OnEvent
    Fire    = Store.Fire
end

local GetAsset = require("Lucide").GetAsset
local Validate = wax.shared.Validate

local EasingLibrary = wax.shared.EasingLibrary
local Ease = EasingLibrary.Ease

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local GetTranslation = wax.shared.Translations.GetTranslation :: (string) -> string

type NotificationSide = (
    | "Top"    | "TopLeft"
    | "Bottom" | "BottomLeft"
    | "Left"   | "TopRight"
    | "Right"  | "BottomRight"
    | "Center"
)

--// Base Groupboxes
local Dropdowns = {}
local Toggles   = {}
local Buttons   = {}
local Sliders   = {}
local Inputs    = {}
local Labels    = {}

--// Base Addons
local KeyPickers   = {}
local ColorPickers = {}

local Library = {
    ShowCustomCursor = false,

    WindowSize = wax.shared.DeviceType == "Mobile" and UDim2.fromOffset(480, 300) or UDim2.fromOffset(720, 500),

    DPIScale = 1,
    MinSizeX = 400,
    MinSizeY = 250,
    MaxSizeX = 1000,
    MaxSizeY = 1000,

    NotificationSide  = "BottomRight" :: NotificationSide,
    NotificationSound = "rbxassetid://4590662766" :: string,

    Scheme = {
        BackgroundColor = Color3.fromHex("#121E2E"),
        PrimaryColor    = Color3.fromHex("#1F3246"),
        SecondaryColor  = Color3.fromHex("#3B5878"),
        AccentColor     = Color3.fromHex("#62a8fe"),
        OutlineColor    = Color3.fromHex("#0A141F"),
        FontColor       = Color3.fromHex("#FFFFFF"),
        RiskyColor      = Color3.fromHex("#C02020"),

        Font = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Medium)
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
    TwoColumnGroupboxesEvent = CreateEventStore()
}

local InstanceTemplates = {
    Frame = {
        BorderSizePixel = 0
    },
    CanvasGroup = {
        BorderSizePixel = 0
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder
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
        CanvasSize = UDim2.fromScale(0, 0)
    },

    GetTextBoundsParams = {
        RichText = true,
        Font = function()
            return Library.Scheme.Font
        end
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

local ElementTemplates = {
    Window = {
        Icon     = "",
        Title    = GetTranslation("Window"),
        DPIScale = Library.DPIScale,
        NotificationSide  = Library.NotificationSide,
        NotificationSound = Library.NotificationSound,
        ShowCustomCursor  = false
    }
}

local ViewportSize = shared.Camera.ViewportSize

Library.MaxSizeX = ViewportSize.X
Library.MaxSizeY = ViewportSize.Y

if Library.WindowSize.X.Offset > Library.MaxSizeX then
    Library.WindowSize = UDim2.fromOffset(Library.MaxSizeX, Library.WindowSize.Y.Offset)
    Library.MinSizeX   = Library.MaxSizeX
end

if Library.WindowSize.Y.Offset > Library.MaxSizeY then
    Library.WindowSize = UDim2.fromOffset(Library.WindowSize.X.Offset, Library.MaxSizeY)
    Library.MinSizeY   = Library.MaxSizeY
end

if Library.WindowSize.X.Offset > 720 then
    Library.TwoColumnGroupboxes = true
end

--// Helpers //
local math_max
    = math.max

local InputChanged = UserInputService.InputChanged
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
    local ThemeProperties  = Library.ThemeRegistry[Instance] or {}
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
    local Instance = Instance_new(ClassName)
    local Template = InstanceTemplates[ClassName]

    if Template then
        Fill(Instance, Template, __newindex, typeof)
    end

    if typeof(Properties) == "table" then
        Fill(Instance, Properties :: hash, __newindex, typeof)
    elseif typeof(Properties) == "Instance" then
        __newindex(Instance, "Parent", Properties)
    end

    return Instance
end

local function GetUnscaledContentSize(UIListLayout: UIListLayout, Latitude: "X" | "Y" | any): Vector2 | number
    local ContentSize = UIListLayout.AbsoluteContentSize / Library.DPIScale

    return (
        Latitude == "X" and ContentSize.X or
        Latitude == "Y" and ContentSize.Y or
        ContentSize
    )
end

local function UpdateWithContentSize(Frame: ScrollingFrame | Frame, UIListLayout: UIListLayout)
    local Key = Frame.ClassName == "ScrollingFrame" and "CanvasSize" or "Size"

    GiveSignal(Connect, nil, GetPropertyChangedSignal(UIListLayout, "AbsoluteContentSize"), function()
        local CurrentSize = (Frame :: any)[Key];

        (Frame :: any)[Key] = UDim2.new(
            CurrentSize.X.Scale,
            CurrentSize.X.Offset,
            CurrentSize.Y.Scale,
            GetUnscaledContentSize(UIListLayout, "Y") :: number
        )
    end)
end

local function GetUnscaledTextBounds(TextElement: TextLabel | TextButton, Latitude: "X" | "Y"): Vector2 | number
    local TextBounds = TextElement.TextBounds / Library.DPIScale

    return (
        Latitude == "X" and TextBounds.X or
        Latitude == "Y" and TextBounds.Y or
        TextBounds
    )
end

local function MakeDraggable(
    Target:   GuiObject | typeof(table.create(2, Create("Frame") :: GuiObject)),
    Bounding: GuiObject,
    Event:    EventStore?,
    Signal:   RBXScriptSignal?
)
    local Target1: GuiObject,
          Target2: GuiObject?

    if typeof(Target) == "table" then
        Target1 = (Target :: {GuiObject})[1]
        Target2 = (Target :: {GuiObject})[2]
    else
        Target1 = Target :: GuiObject
    end

    local IsDragging = false

    GiveSignal(Connect, nil, Signal or Bounding.InputBegan, function(InputObject: InputObject)
        if IsDragging or not IsClickInput(InputObject) then return end
        IsDragging = true

        local StartPosition  = InputObject.Position
        local Frame1Position = Target1.Position
        local Frame2Position = Target2 and Target2.Position

        local Changed, Ended

        Changed = GiveSignal(Connect, nil, InputChanged, function(Input: InputObject)
            if not IsHoverInput(Input) then return end

            local Delta     = Input.Position - StartPosition
            local Increment = UDim2.fromOffset(Delta.X, Delta.Y)

            Target1.Position = Frame1Position + Increment
            if Target2 and Frame2Position then
                Target2.Position = Frame2Position + Increment
            end

            if Event then
                Fire(Event, Increment)
            end
        end)

        Ended = GiveSignal(Connect, nil, GetPropertyChangedSignal(InputObject, "UserInputState"), function()
            if InputObject.UserInputState ~= End then return end
            IsDragging = false

            Disconnect(Changed)
            Disconnect(Ended)
        end)
    end)
end

local function MakeResizable(
    Target:   GuiObject | typeof(table.create(2, Create("Frame") :: GuiObject)),
    Bounding: GuiObject,
    Event:    EventStore?,
    Signal:   RBXScriptSignal?
)
    local Target1: GuiObject,
          Target2: GuiObject?

    if typeof(Target) == "table" then
        Target1 = (Target :: {GuiObject})[1]
        Target2 = (Target :: {GuiObject})[2]
    else
        Target1 = Target :: GuiObject
    end

    local IsDragging = false

    GiveSignal(Connect, nil, Signal or Bounding.InputBegan, function(InputObject: InputObject)
        if IsDragging or not IsClickInput(InputObject) then return end
        IsDragging = true

        local StartPosition = InputObject.Position
        local Frame1Size    = Target1.Size
        local Frame2Size    = Target2 and Target2.Size

        local Changed, Ended

        Changed = GiveSignal(Connect, nil, InputChanged, function(Input: InputObject)
            if not IsHoverInput(Input) then return end

            local Delta     = Input.Position - StartPosition
            local Increment = UDim2.fromOffset(
                math_max(Delta.X, Library.MinSizeX),
                math_max(Delta.Y, Library.MinSizeY)
            )

            local Postiion1  = Frame1Size + Increment
            Target1.Position = Postiion1

            if Target2 and Frame2Size then
                Target2.Position = Frame2Size + Increment
            end

            if Event then
                Fire(Event, Postiion1)
            end
        end)

        Ended = GiveSignal(Connect, nil, GetPropertyChangedSignal(InputObject, "UserInputState"), function()
            if InputObject.UserInputState ~= End then return end
            IsDragging = false

            Disconnect(Changed)
            Disconnect(Ended)
        end)
    end)
end

--// Main //
local BaseGroupboxes = {}
local BaseAddons     = {}

local WindowSizeEvent = CreateEventStore()

local ScreenGui = Create("ScreenGui", {
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ClipToDeviceSafeArea = false,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    AutoLocalize = false,
    DisplayOrder = 2^31 - 3,
    Name = randomstring(),
    Parent = wax.shared.ScreenGui
})

Library.ScreenGui = ScreenGui

type WindowInfo = {
    Icon:              string | number,
    Title:             string,
    DPIScale:          number,
    NotificationSide:  NotificationSide,
    NotificationSound: string,
    ShowCustomCursor:  boolean
}

type Window = {
    CurrentTab:        Tab?,
    Tabs:              {Tab},
    UIScale:           UIScale,
    BaseCanvas:        CanvasGroup,
    BaseShadow:        Frame,
    LeftPanel:         CanvasGroup,
    TitleContainer:    Frame,
    TabsScrolling:     ScrollingFrame,
    TabsContainer:     Frame,
    RightPanel:        CanvasGroup,
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
    Side = "Left" :: "Left" | "Right",
    Tab = {} :: Tab,
    Num = 1 :: number,
    LayoutOrder = 1 :: number,
    Container = Create("Frame") :: Frame,
    Elements = {} :: {any},
}, {__index = BaseGroupboxes}))

function BaseGroupboxes:AddDropdown()

end

function Library:CreateWindow(WindowInfo: WindowInfo): Window
    Validate(WindowInfo, ElementTemplates.Window)

    for Property, Value in WindowInfo :: any do
        if Property == "DPIScale" then
            Library.DPIScale = Value
        elseif Property == "NotificationSide" then
            Library.NotificationSide  = Value
        elseif Property == "NotificationSound" then
            Library.NotificationSound = Value
        elseif Property == "ShowCustomCursor" then
            Library.ShowCustomCursor  = Value
        end
    end

    local Window = {
        CurrentTab = nil :: Tab?,
        Tabs = {} :: {Tab}
    } :: Window

    local BaseCanvas = Create("CanvasGroup", {
        BackgroundTransparency = 1,
        Size = Library.WindowSize,
        Position = UDim2.fromScale(0.5, 0.5),
        ZIndex = 2,
        Parent = ScreenGui
    }) :: CanvasGroup

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

    Window.UIScale = Create("UIScale", {
        Scale = WindowInfo.DPIScale,
        Parent = ScreenGui
    }) :: UIScale

    Window.BaseCanvas = BaseCanvas
    Window.BaseShadow = BaseShadow

    local LeftPanel = Create("CanvasGroup", {
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.new(0, 200, 1, 0),
        ZIndex = 2,
        Parent = BaseCanvas
    }) :: CanvasGroup

    Create("UICorner", LeftPanel)
    Window.LeftPanel = LeftPanel

    local TitleContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = LeftPanel
    })

    MakeDraggable({
        BaseCanvas,
        BaseShadow
    } :: {GuiObject}, TitleContainer :: GuiObject)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(50, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Text = WindowInfo.Title,
        TextSize = 28,
        TextXAlignment = Enum.TextXAlignment.Left,
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

    local TabsContainer = Create("Frame", {
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

    local ComponentsContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 1, -40),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = LeftPanel
    })

    local RightPanel = Create("CanvasGroup", {
        BackgroundColor3 = "PrimaryColor",
        Position = UDim2.fromOffset(192, 0),
        Size = UDim2.new(1, -192, 1, 0),
        Parent = BaseCanvas
    }) :: CanvasGroup

    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
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
            Rotation = 90,
            Parent = ResizeArea
        })

        MakeResizable({
            BaseCanvas,
            BaseShadow
        } :: {GuiObject}, ResizeArea :: GuiObject, WindowSizeEvent, ResizeArea.Activated)
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
            Parent = ComponentsContainer
        }) :: ImageButton

        local Collapsed  = false
        Window.Collapsed = false

        if Random.new():NextNumber(1, 2) > 1 then
            --/ Do funny rotation
            local NextRotation = 0

            GiveSignal(Connect, nil, CollapseButton.Activated, function()
                NextRotation += 180
                
                Collapsed = not Collapsed
                Window.Collapsed = Collapsed

                Ease(EasingLibrary, CollapseButton, "Rotation", NextRotation, CollapseButton, 0.25)
                Fire(CollapsedEvent, Collapsed)
            end)
        else
            GiveSignal(Connect, nil, CollapseButton.Activated, function()
                Collapsed = not Collapsed
                Window.Collapsed = Collapsed

                Ease(EasingLibrary, CollapseButton, "Rotation", Collapsed and 180 or 0, CollapseButton, 0.25)
                Fire(CollapsedEvent, Collapsed)
            end)
        end
    end

    local MinimizedEvent = CreateEventStore();do
        local Asset = GetAsset("minimize")

        local MinimizeButton = Create("ImageButton", {
            Position = UDim2.fromOffset(50, 4),
            Size = UDim2.fromOffset(32, 32),
            Image = Asset.Url,
            ImageRectSize = Asset.ImageRectSize,
            ImageRectOffset = Asset.ImageRectOffset,
            Parent = ComponentsContainer
        }) :: ImageButton

        local WindowIcon = Create("ImageButton", {
            Position = UDim2.fromOffset(8, 2),
            Size = UDim2.fromOffset(35, 35),
            Image = typeof(WindowInfo.Icon) == "string" and WindowInfo.Icon or `rbxassetid://{WindowInfo.Icon}`,
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

        MakeDraggable(NeedToBeDraggable, TitleContainer :: GuiObject)
        MakeDraggable(NeedToBeDraggable, WindowIcon, nil, WindowIcon.Activated)
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
            Ease(EasingLibrary, Tab.Holder, "BackgroundTransparency", 0.92, Tab.Id, 0.2)

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
            LayoutOrder = 1 - NumTabs,
            Focused = false,
            Groupboxes = {}
        } :: Tab

        local Holder = Create("Frame", {
            BackgroundTransparency = 1,
            BackgroundColor3 = "AccentColor",
            Size = UDim2.new(1, 0, 0, 35),
            ClipsDescendants = true,
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
            TextXAlignment = Enum.TextXAlignment.Left,
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
            Ease(EasingLibrary, Holder, "BackgroundTransparency", 0.96, Tab.Id, 0.2)
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

        local LeftContainer = Create("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = Container
        }) :: Frame

        local RightContainer = Create("Frame", {
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
                LayoutOrder = 1 - NumGroupboxes,
                Elements = {}
            }, BaseGroupboxes) :: Groupbox & any

            local Container = Create("Frame", {
                BackgroundColor3 = function()
                    return GetDarkerColor(Library.Scheme.PrimaryColor, 0.2)
                end,
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
            }) :: UIListLayout)

            Groupbox.Container = Container

            if Title then
                Container.Size = UDim2.new(1, 0, 0, 30)

                local TitleContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Parent = Container
                })

                local TitleLabel = Create("TextLabel", {
                    BackgroundColor3 = function()
                        return GetDarkerColor(Library.Scheme.PrimaryColor, 0.2)
                    end,
                    Size = UDim2.fromScale(1, 1),
                    Text = Title,
                    TextSize = 20,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TitleContainer
                }) :: TextLabel

                TitleLabel.Size = UDim2.new(
                    0,
                    GetUnscaledTextBounds(TitleLabel, "X") :: number,
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

            self.Groupboxes[NumGroupboxes + 1] = Groupbox

            return Groupbox
        end

        function Tab:AddLeftGroupbox(...)
            return self:AddGroupbox(..., "Left")
        end

        function Tab:AddRightGroupbox(...)
            return self:AddGroupbox(..., "Right")
        end

        self.Tabs[NumTabs + 1] = Tab

        if not self.CurrentTab then
            Fire(self.SwitchTabEvent, Tab)
        end

        return Tab
    end

    self.Windows[#self.Windows + 1] = Window

    return Window
end

return Library
