local UDim2_fromOffset, UDim2_fromScale, UDim2_new, UDim_new
    = UDim2.fromOffset, UDim2.fromScale, UDim2.new, UDim.new

type Window = {
    Name:    string,
    Icon:    string,
    Destroy: (self: Window) -> nil,
    
    Instances: {
        Base:   Frame,
        Shadow: Frame
    },
    -- Tabs: {Tab},
    -- AddTab: (self: Window, Name: string, Icon: string) -> Tab,
}

local Library = shared.Gui.Library

local Config        = Library.Config
local CurrentConfig = Library.CurrentConfig

local Interactions  = Library.Utils.Interactions
local MakeDraggable = Interactions.MakeDraggable
local MakeResizable = Interactions.MakeResizable

local Create      = Library.Utils.Create :: (ClassName: string, Properties: hash | Instance | any) -> Instance
local ToContentId = Library.Utils.Strings.ToContentId :: (Original: string | number) -> string

local function AddWindow(Name: string, Icon: string | number)
    local IconUrl = ToContentId(Icon)

    local Window = {
        Name = Name,
        Icon = IconUrl
    }

    local Base = Create("Frame", {
        Active = Config.BaseActivated,
        Size = CurrentConfig.NormalSize,
        Position = UDim2_new(0.5, CurrentConfig.NormalSize.X.Offset / -2, 0.5, CurrentConfig.NormalSize.Y.Offset / -2),
        BackgroundColor3 = "BackgroundColor",
        Parent = shared.ScreenGui,
        ZIndex = 5
    }) :: Frame

    local Shadow = Create("Frame", {
        Size = CurrentConfig.NormalSize,
        Position = Base.Position + UDim2_fromOffset(2.5, 2.5),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(),
        Parent = shared.ScreenGui,
        ZIndex = 4
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim_new(0, 6),
        Parent = Base
    }):Clone().Parent = Shadow

    Create("UIStroke", {
        Thickness = 2,
        Parent = Base
    })

    MakeDraggable({Base, Shadow})

    local ResizeDragger = Create("Frame", {
        Size = UDim2_fromOffset(24, 24),
        Position = UDim2_new(1, -12, 1, -12),
        BackgroundColor = "BorderColor",
        Parent = Base
    }) :: Frame

    MakeResizable({Base, Shadow}, ResizeDragger)

    

    return Window
end

return AddWindow
