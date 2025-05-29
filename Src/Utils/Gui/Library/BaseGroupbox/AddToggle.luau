local UDim2_fromOffset, UDim2_fromScale, UDim2_new, UDim_new, Vector2_new, setmetatable, table_insert, typeof: typeof(typeof)
    = UDim2.fromOffset, UDim2.fromScale, UDim2.new, UDim.new, Vector2.new, setmetatable, table.insert, typeof

local Left       = Enum.TextXAlignment.Left
local Horizontal = Enum.FillDirection.Horizontal
local Right      = Enum.TextXAlignment.Right
local RelativeYY = Enum.SizeConstraint.RelativeYY

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local Library  = ...
local Scheme   = Library.Scheme
local Registry = Library.Registry
local Toggles  = Library.Toggles

local Tooltip     = require("Tooltip", Library)
local AddCheckbox = require("AddCheckbox", Library)

local AddTooltip  = Tooltip.AddTooltip

local GetTranslation = wax.shared.Translations.GetTranslation
local EasingLibrary  = wax.shared.EasingLibrary
local Validate       = wax.shared.Validate

local Ease           = EasingLibrary.Ease
local SafeCallback   = Library.Utils.SafeCallback
local GetDarkerColor = Library.Utils.GetDarkerColor
local Create         = Library.Utils.Create
local BaseAddons     = Library.BaseAddons

Library.BaseGroupbox.__index.AddCheckbox = AddCheckbox

type Groupbox = {
    Holder:    Frame,
    Container: Frame,
    Elements:  array,
    Resize:    (self: Groupbox) -> ()
}

type ToggleInfo = {
    Text:     string?,
    Default:  boolean?,
    Tooltip:  string?,
    DisabledTooltip: string?,
    Callback: (boolean) -> (),
    Changed:  (boolean) -> (),
    Risky:    boolean?,
    Disabled: boolean?,
    Visible:  boolean?
}

type ToggleStore = {
    Text:     string,
    Value:    boolean,
    Tooltip:  string?,
    DisabledTooltip: string?,
    TooltipTable:    any,
    Callback: (boolean) -> (),
    Changed:  (boolean) -> (),
    Risky:    boolean,
    Disabled: boolean,
    Visible:  boolean,
    Addons:   array,
    Type:     "Toggle",

    Groupbox:     Groupbox,
    Container:    Frame,
    Button:       TextButton,
    Switch:       Frame,
    SwitchStroke: UIStroke,
    Ball:         Frame,
    TextLabel:    TextLabel,
    UpdateColors: (ToggleStore) -> (),
    Display:      (ToggleStore) -> (),
    OnChanged:    (ToggleStore, (boolean) -> ()) -> (),
    SetValue:     (ToggleStore, boolean) -> (),
    SetDisabled:  (ToggleStore, boolean) -> (),
    SetVisible:   (ToggleStore, boolean) -> (),
    SetText:      (ToggleStore, string)  -> (),
    SetTooltip:   (ToggleStore, string, string) -> ()
}

local Template = {
    Text     = GetTranslation("Toggle"),
    Default  = false,
    Tooltip  = nil,
    DisabledTooltip = nil,
    Callback = function() end,
    Changed  = function() end,
    Risky    = false,
    Disabled = false,
    Visible  = true
} :: ToggleInfo

local function AddToggle(self: Groupbox, Index: string, Info: ToggleInfo)
    if Library.ForceCheckbox then
        return AddCheckbox(self, Index, Info)
    end

    Validate(Info, Template)

    local Toggle = {
        Text     = Info.Text,
        Value    = Info.Default,
        Tooltip  = Info.Tooltip,
        DisabledTooltip = Info.DisabledTooltip,
        TooltipTable    = nil,
        Callback = Info.Callback,
        Changed  = Info.Changed,
        Risky    = Info.Risky,
        Disabled = Info.Disabled,
        Visible  = Info.Visible,
        Addons   = {},
        Type     = "Toggle"
    } :: ToggleStore

    local Groupbox  = self
    local Container = Groupbox.Container

    Toggle.Groupbox  = Groupbox
    Toggle.Container = Container

    local Button = Create("TextButton", {
        Active = not Toggle.Disabled,
        BackgroundTransparency = 1,
        Size = UDim2_new(1, 0, 0, 18),
        Text = "",
        Visible = Toggle.Visible,
        Parent = Container
    }) :: TextButton

    local Label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2_new(1, -40, 1, 0),
        Text = Toggle.Text,
        TextSize = 14,
        TextTransparency = 0.3,
        TextXAlignment = Left,
        Parent = Button
    }) :: TextLabel

    Create("UIListLayout", {
        FillDirection = Horizontal,
        HorizontalAlignment = Right,
        Padding = UDim_new(0, 6),
        Parent = Label
    })

    local Switch = Create("Frame", {
        AnchorPoint = Vector2_new(1, 0),
        BackgroundColor3 = "MainColor",
        Position = UDim2_fromScale(1, 0),
        Size = UDim2_fromOffset(32, 18),
        Parent = Button,
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim_new(1, 0),
        Parent = Switch
    })

    Create("UIPadding", {
        PaddingBottom = UDim_new(0, 2),
        PaddingLeft = UDim_new(0, 2),
        PaddingRight = UDim_new(0, 2),
        PaddingTop = UDim_new(0, 2),
        Parent = Switch,
    })

    local SwitchStroke = Create("UIStroke", {
        Color = "OutlineColor",
        Parent = Switch
    }) :: UIStroke

    local Ball = Create("Frame", {
        BackgroundColor3 = "FontColor",
        Size = UDim2_fromScale(1, 1),
        SizeConstraint = RelativeYY,
        Parent = Switch,
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim_new(1, 0),
        Parent = Ball
    })

    Toggle.Button       = Button
    Toggle.Switch       = Switch
    Toggle.SwitchStroke = SwitchStroke
    Toggle.Ball         = Ball
    Toggle.TextLabel    = Label

    function Toggle:UpdateColors()
        self:Display()
    end

    function Toggle:Display()
        if wax.Unloaded then return end

        local Value  = self.Value
        local Offset = Value and 1 or 0

        local Transparency = self.Disabled and 0.75 or 0

        local Switch       = self.Switch
        local SwitchStroke = self.SwitchStroke
        local Ball         = self.Ball

        Switch.BackgroundTransparency = Transparency
        SwitchStroke.Transparency     = Transparency

        Switch.BackgroundColor3 = Value and Scheme.AccentColor or Scheme.MainColor
        SwitchStroke.Color      = Value and Scheme.AccentColor or Scheme.OutlineColor

        Registry[Switch].BackgroundColor3 = Value and "AccentColor" or "MainColor"
        Registry[SwitchStroke].Color      = Value and "AccentColor" or "OutlineColor"

        if self.Disabled then
            self.TextLabel.TextTransparency = 0.8

            Ball.AnchorPoint      = Vector2_new(Offset, 0)
            Ball.Position         = UDim2_fromOffset(Offset, 0)
            Ball.BackgroundColor3 = GetDarkerColor(Scheme.FontColor)

            Registry[Ball].BackgroundColor3 = function()
                return GetDarkerColor(Scheme.FontColor)
            end
        else
            local Ease, EasingLibrary
                = Ease, EasingLibrary

            Ease(EasingLibrary, self.TextLabel, "TextTransparency", Value and 0 or 0.3, self.TextLabel, 0.2)

            Ease(EasingLibrary, Ball, {
                AnchorPoint = Vector2_new(Offset, 0),
                Position    = UDim2_fromOffset(Offset, 0)
            }, nil, Ball, 0.2)

            Ball.BackgroundColor3 = Scheme.FontColor
            Registry[Ball].BackgroundColor3 = "FontColor"
        end
    end

    function Toggle:OnChanged(Changed: (boolean) -> ())
        self.Changed = Changed
    end

    function Toggle:SetValue(Value: boolean)
        if self.Disabled or self.Value == Value then
            return
        end

        self.Value = Value
        self:Display()

        for _, Addon in self.Addons do
            if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                Addon.Toggled = Value
                Addon:Update()
            end
        end

        SafeCallback(self.Callback, Value)
        SafeCallback(self.Changed, Value)

        if self.TooltipTable then
            self.TooltipTable:Update()
        end
    end

    function Toggle:SetDisabled(Disabled: boolean)
        if self.Disabled == Disabled then
            return
        end

        self.Disabled = Disabled
        if self.TooltipTable then
            self.TooltipTable.Disabled = Disabled
        end

        for _, Addon in self.Addons do
            if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                Addon:Update()
            end
        end

        self.Button.Active = not Disabled
        self:Display()
    end

    function Toggle:SetVisible(Visible: boolean)
        if self.Visible == Visible then
            return
        end

        self.Visible = Visible
        self.Button.Visible = Visible

        self.Groupbox:Resize()
    end

    function Toggle:SetText(Text: string)
        self.Text = Text
        self.TextLabel.Text = Text
    end

    function Toggle:SetTooltip(Text: string, DisabledText: string)
        if Text then self.TooltipTable.Text = Text end
        if DisabledText then self.TooltipTable.DisabledText = DisabledText end
    end

    GiveSignal(Connect, nil, Button.MouseButton1Click, function()
        Toggle:SetValue(not Toggle.Value)
    end)

    GiveSignal(Connect, nil, Label.MouseEnter, function()
        if Toggle.Disabled then return end
        Ease(EasingLibrary, Label, "TextTransparency", 0.15, Label, 0.2)
    end)

    GiveSignal(Connect, nil, Label.MouseLeave, function()
        Ease(EasingLibrary, Label, "TextTransparency", 0.3, Label, 0.2)
    end)

    if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
        Toggle.TooltipTable = AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
        Toggle.TooltipTable.Disabled = Toggle.Disabled
    end

    if Toggle.Risky then
        Label.TextColor3 = Scheme.Risky
        Registry[Label].TextColor3 = "Risky"
    end

    Toggle:Display()
    Groupbox:Resize()

    setmetatable(Toggle, BaseAddons)
    table_insert(Groupbox.Elements, Toggle)

    Toggles[Index] = Toggle
    return Toggle
end

return AddToggle
