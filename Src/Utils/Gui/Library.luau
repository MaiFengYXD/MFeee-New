local pcall, typeof, setmetatable, randomstring, Instance_new, Enum: typeof(Enum)
    = pcall, typeof, setmetatable, randomstring, Instance.new, Enum

local GetDarkerColor: (Original: Color3, Alpha: number?) -> Color3,
      GetBrightColor: (Original: Color3, Alpha: number?) -> Color3,

      SafeCallback:   (Callback: Function, ...any) -> (boolean, ...any)

local GetTranslation = wax.shared.Translations.GetTranslation :: (string) -> string

local Fire, GetPropertyChangedSignal;do
    local Bindable = Instance_new("BindableEvent")

    Fire = Bindable.Fire
    GetPropertyChangedSignal = game.GetPropertyChangedSignal

    Bindable:Destroy()
end

local GetAsset = require("Lucide").GetAsset
local Validate = wax.shared.Validate

local EasingLibrary = wax.shared.EasingLibrary
local Ease = EasingLibrary.Ease

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

type NotificationSide = (
    | "Center"
    | "Top"    | "TopLeft"
    | "Bottom" | "BottomLeft"
    | "Left"   | "TopRight"
    | "Right"  | "BottomRight"
)

local Windows = {}

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

    WindowSize = wax.shared.DeviceType == "Mobile" and UDim2.fromOffset(480, 300) or UDim2.fromOffset(480, 500),
    DPIScale   = 1,

    NotificationSide  = "BottomRight" :: NotificationSide,
    NotificationSound = "rbxassetid://4590662766" :: string,

    Scheme = {
        BackgroundColor = Color3.fromHex("#121E2E"),
        PrimaryColor    = Color3.fromHex("#1F3246"),
        SecondaryColor  = Color3.fromHex("#3B5878"),
        AccentColor     = Color3.fromHex("#6299fe"),
        OutlineColor    = Color3.fromHex("#0A141F"),
        FontColor       = Color3.fromHex("#FFFFFF"),
        RiskyColor      = Color3.fromHex("#C02020"),

        Font = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium)
    },

    ThemeRegistry = {},

    Windows = Windows,

    Dropdowns = Dropdowns,
    Toggles   = Toggles,
    Buttons   = Buttons,
    Sliders   = Sliders,
    Inputs    = Inputs,
    Labels    = Labels,

    KeyPickers   = KeyPickers,
    ColorPickers = ColorPickers,

    UseCheckbox      = false,
    UseCheckboxEvent = Instance_new("BindableEvent") :: BindableEvent
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
        TextColor3 = "FontColor"
    },

    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
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

if Library.WindowSize.X.Offset < ViewportSize.X then
    Library.WindowSize = UDim2.fromOffset(ViewportSize.X, Library.WindowSize.Y.Offset)
end

if Library.WindowSize.Y.Offset < ViewportSize.Y then
    Library.WindowSize = UDim2.fromOffset(Library.WindowSize.X.Offset, ViewportSize.Y)
end

--// Helpers //
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

local function AddClickBounce(GuiObject: GuiObject, Size1: UDim2, Size2: UDim2)
    local Id = randomstring(22)

    GiveSignal(Connect, GuiObject.InputBegan, nil, function()
        Ease(EasingLibrary, GuiObject, "Size", Size1, Id, 0.2)
    end)

    GiveSignal(Connect, GuiObject.InputEnded, nil, function()
        Ease(EasingLibrary, GuiObject, "Size", Size2, Id, 0.2)
    end)
end

local function UpdateWithContentSize(Frame: ScrollingFrame | Frame, UIListLayout: UIListLayout)
    local OnChanged = (Frame.ClassName == "Frame" and function()
        local CurrentSize = Frame.Size;

        (Frame :: Frame).Size = UDim2.new(
            CurrentSize.X.Scale,
            CurrentSize.X.Offset,
            CurrentSize.Y.Scale,
            GetUnscaledContentSize(UIListLayout, "Y") :: number
        )
    end) or function()
        local CurrentSize = (Frame :: ScrollingFrame).CanvasSize;

        (Frame :: ScrollingFrame).CanvasSize = UDim2.new(
            CurrentSize.X.Scale,
            CurrentSize.X.Offset,
            CurrentSize.Y.Scale,
            GetUnscaledContentSize(UIListLayout, "Y") :: number
        )
    end

    GiveSignal(Connect, nil, GetPropertyChangedSignal(UIListLayout, "AbsoluteContentSize"), OnChanged)
end

local function GetUnscaledTextBounds(TextElement: TextLabel | TextButton, Latitude: "X" | "Y"): Vector2 | number
    local TextBounds = TextElement.TextBounds / Library.DPIScale

    return (
        Latitude == "X" and TextBounds.X or
        Latitude == "Y" and TextBounds.Y or
        TextBounds
    )
end

do
    local error, xpcall, string_find, debug_traceback, string_gsub, string_sub, task_defer
        = error, xpcall, string.find, debug.traceback, string.gsub, string.sub, task.defer

    local Bright = Color3.new(1, 1, 1)
    local Dark   = Color3.new()

    local Lerp = Dark.Lerp

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
end

--// Main //
local WindowSizeEvent = Create("BindableEvent") :: BindableEvent

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
    RightPanel:        CanvasGroup,
    ContentsContainer: ScrollingFrame,
    CollapsedEvent:    BindableEvent,
    MinimizedEvent:    BindableEvent,
    SwitchTabEvent:    BindableEvent,
    AddTab:            (self: Window, Name: string, Icon: string?, HideHolder: boolean?) -> Tab
}

type Tab = {
    Window:           Window,
    Num:              number,
    LayoutOrder:      number,
    Groupboxes:       {Groupbox},
    Holder:           Frame,
    UIListLayout:     UIListLayout,
    Container:        ScrollingFrame,
    LeftContainer:    Frame,
    RightContainer:   Frame,
    TextHolder:       TextLabel?,
    IconHolder:       ImageLabel?,
    AddGroupbox:      (self: Tab, Title: string, Side: "Left" | "Right") -> Groupbox,
    AddLeftGroupbox:  (self: Tab, ...string) -> Groupbox,
    AddRightGroupbox: (self: Tab, ...string) -> Groupbox
}

type Groupbox = hash & {
    Side:        string,
    Tab:         Tab,
    Num:         number,
    LayoutOrder: number,
    Container:   Frame,
    Elements:    {any},
}

local BaseGroupboxes = {}
local BaseAddons     = {}

function BaseGroupboxes:AddDropdown()

end

function Library:CreateWindow(WindowInfo: WindowInfo)
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

    do
        local BaseCanvas = Create("CanvasGroup", {
            BackgroundTransparency = 1,
            Size = Library.WindowSize,
            Position = UDim2.new(
                0.5,
                Library.WindowSize.X.Offset / 2,
                0.5,
                Library.WindowSize.Y.Offset / 2
            ),
            ZIndex = 2,
            Parent = ScreenGui
        }) :: CanvasGroup

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

        UpdateWithContentSize(TabsScrolling, Create("UIListLayout", TabsScrolling) :: UIListLayout)
        Window.TabsScrolling = TabsScrolling

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

        local CollapsedEvent = Create("BindableEvent") :: BindableEvent;do
            local Asset = GetAsset("arrow-left-to-line")

            local CollapseButton = Create("ImageButton", {
                Position = UDim2.fromOffset(8, 4),
                Size = UDim2.fromOffset(32, 32),
                Image = Asset.Url,
                ImageRectSize = Asset.ImageRectSize,
                ImageRectOffset = Asset.ImageRectOffset,
                Parent = ComponentsContainer
            }) :: ImageButton

            local Collapsed = false

            if Random.new():NextNumber(1, 2) > 1 then
                --/ Do funny rotation
                local NextRotation = 0

                GiveSignal(Connect, nil, CollapseButton.Activated, function()
                    NextRotation += 180

                    Ease(EasingLibrary, CollapseButton, "Rotation", NextRotation, CollapseButton, 0.25)
                    Fire(CollapsedEvent, Collapsed)
                end)
            else
                GiveSignal(Connect, nil, CollapseButton.Activated, function()
                    Collapsed = not Collapsed

                    Ease(EasingLibrary, CollapseButton, "Rotation", Collapsed and 180 or 0, CollapseButton, 0.25)
                    Fire(CollapsedEvent, Collapsed)
                end)
            end

            AddClickBounce(CollapseButton, UDim2.fromOffset(28, 28), UDim2.fromOffset(32, 32))
        end

        local MinimizedEvent = Create("BindableEvent") :: BindableEvent;do
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
                if Repeated == 1 then
                    Minimized = not Minimized
                    Fire(MinimizedEvent, Minimized)
                end
            end)

            AddClickBounce(MinimizeButton, UDim2.fromOffset(28, 28), UDim2.fromOffset(32, 32))
            AddClickBounce(WindowIcon, UDim2.fromOffset(30, 30), UDim2.fromOffset(35, 35))
        end

        local SwitchTabEvent = Create("BindableEvent") :: BindableEvent;do
            local Id = randomstring(23)

            GiveSignal(Connect, nil, SwitchTabEvent.Event, function(Tab: Tab)
                Window.CurrentTab = Tab

                Ease(EasingLibrary, ContentsContainer, "CanvasPosition", Vector2.new(
                    0,
                    Tab.Num * Library.WindowSize.Y.Offset
                ), Id, 0.3)

                if Tab.TextHolder and Tab.IconHolder then
                    Tab.TextHolder.TextTransparency  = 0.1
                    Tab.IconHolder.ImageTransparency = 0.1
                end

                for _, Tab_ in Window.Tabs do
                    if Tab_.TextHolder and Tab_.IconHolder then
                        Tab_.TextHolder.TextTransparency = 0.3
                        Tab_.IconHolder.ImageTransparency = 0.3
                    end
                end
            end)
        end

        Window.CollapsedEvent = CollapsedEvent
        Window.MinimizedEvent = MinimizedEvent
        Window.SwitchTabEvent = SwitchTabEvent
    end

    function Window:AddTab(Name: string, Icon: string?, HideHolder: boolean?): Tab
        local NumTabs = #self.Tabs

        local Tab = {
            Window = self,
            Num = NumTabs + 1,
            LayoutOrder = 1 - NumTabs,
            Groupboxes = {}
        } :: Tab

        if not HideHolder then
            local Holder = Create("Frame", {
                BackgroundTransparency = 1,
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
                Fire(Window.SwitchTabEvent, Tab)
            end)
        end

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

        GiveSignal(Connect, nil, WindowSizeEvent.Event, function(NewSize: UDim2)
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

        GiveSignal(Connect, nil, Window.CollapsedEvent.Event, function(Collapsed: boolean)
            UIListLayout.FillDirection = Collapsed and Horizontal or Vertical
        end)

        function Tab:AddGroupbox(Title: string, Side: "Left" | "Right"): Groupbox
            local NumGroupboxes = #self.Groupboxes

            local Groupbox = setmetatable(({
                Side = Side,
                Tab = self,
                Num = NumGroupboxes + 1,
                LayoutOrder = 1 - NumGroupboxes,
                Elements = {}
            } :: Groupbox), BaseGroupboxes)

            local Container = Create("Frame", {
                BackgroundColor3 = function()
                    return GetDarkerColor(Library.Scheme.PrimaryColor, 0.2)
                end,
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

    Window:AddTab("", nil, true)

    return Window
end

return Library
