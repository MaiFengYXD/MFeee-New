local UDim2_fromOffset, UDim2_fromScale, UDim2_new
    = UDim2.fromOffset, UDim2.fromScale, UDim2.new

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

local Create      = Library.Utils.Create :: (ClassName: string, Properties: hash | Instance | any) -> Instance
local ToContentId = Library.Utils.Strings.ToContentId :: (Original: string | number) -> string

function Library:AddWindow(Name: string, Icon: string | number)
    local IconUrl = ToContentId(Icon)

    local Window = {
        Name = Name,
        Icon = IconUrl
    }

    local Base = Create("Frame", {
        Active = Config.BaseActivated,
        Size = UDim2_fromOffset(CurrentConfig.MaxSizeX, CurrentConfig.MaxSizeY),
        Position = UDim2_new(0.5, CurrentConfig.MaxSizeX / 2, 0.5, CurrentConfig.MaxSizeY / 2),
        BackgroundColor3 = "BackgroundColor",
        ZIndex = 5
    }) :: Frame

    local Shadow = Base:Clone()

    Shadow.Parent = shared.ScreenGui
    Shadow.BackgroundColor3 = Color3.new()
    Shadow.BackgroundTransparency = 0.5

    Base.Parent = Shadow
end
