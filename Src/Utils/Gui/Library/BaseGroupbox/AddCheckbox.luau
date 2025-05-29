
local table_insert, NumberSequence_new, NumberSequenceKeypoint_new, setmetatable, typeof: typeof(typeof)
    = table.insert, NumberSequence.new, NumberSequenceKeypoint.new, setmetatable, typeof

local UDim2_fromOffset, UDim2_fromScale, UDim2_new, UDim_new, Vector2_new
    = UDim2.fromOffset, UDim2.fromScale, UDim2.new, UDim.new, Vector2.new

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

local Tooltip    = require("Tooltip", Library)
local AddTooltip = Tooltip.AddTooltip

local GetTranslation = wax.shared.Translations.GetTranslation
local EasingLibrary  = wax.shared.EasingLibrary
local Validate       = wax.shared.Validate

local Ease           = EasingLibrary.Ease
local SafeCallback   = Library.Utils.SafeCallback
local Create         = Library.Utils.Create
local BaseAddons     = Library.BaseAddons

local CheckIcon   = Library.Utils.GetAsset("check")
local CheckUrl    = CheckIcon and CheckIcon.Url or ""
local CheckOffset = CheckIcon and CheckIcon.ImageRectOffset or Vector2.zero
local CheckSize   = CheckIcon and CheckIcon.ImageRectSize   or Vector2.zero

type Groupbox = {
    Holder:    Frame,
    Container: Frame,
    Elements:  array,
    Resize:    (self: Groupbox) -> ()
}

type CheckboxInfo = {
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

type CheckboxStore = {
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

    Groupbox:      Groupbox,
    Container:     Frame,
    Button:        TextButton,
    CheckHolder:   Frame,
    CheckStoke:    UIStroke,
    CheckImage:    ImageLabel,
    CheckGradient: UIGradient,
    TextLabel:     TextLabel,
    UpdateColors:  (CheckboxStore) -> (),
    Display:       (CheckboxStore) -> (),
    OnChanged:     (CheckboxStore, (boolean) -> ()) -> (),
    SetValue:      (CheckboxStore, boolean) -> (),
    SetDisabled:   (CheckboxStore, boolean) -> (),
    SetVisible:    (CheckboxStore, boolean) -> (),
    SetText:       (CheckboxStore, string)  -> (),
    SetTooltip:    (CheckboxStore, string, string) -> ()
}

local Template = {
    Text     = GetTranslation("Checkbox"),
    Default  = false,
    Tooltip  = nil,
    DisabledTooltip = nil,
    Callback = function() end,
    Changed  = function() end,
    Risky    = false,
    Disabled = false,
    Visible  = true
} :: CheckboxInfo

local function AddCheckbox(self: Groupbox, Index: string, Info: CheckboxInfo)
    Validate(Info, Template)

    local Checkbox = {
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
    } :: CheckboxStore

    local Groupbox  = self
    local Container = Groupbox.Container

    Checkbox.Groupbox  = Groupbox
    Checkbox.Container = Container

    local Button = Create("TextButton", {
        Active = not Checkbox.Disabled,
        BackgroundTransparency = 1,
        Size = UDim2_new(1, 0, 0, 18),
        Text = "",
        Visible = Checkbox.Visible,
        Parent = Container
    }) :: TextButton

    local Label = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2_new(1, -40, 1, 0),
        Text = Checkbox.Text,
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

    local CheckHolder = Create("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2_fromScale(1, 1),
        SizeConstraint = RelativeYY,
        Parent = Button
    }) :: Frame

    Create("UICorner", {
        CornerRadius = UDim_new(0, Library.CornerRadius / 2),
        Parent = CheckHolder
    })

    local CheckStoke = Create("UIStroke", {
        Color = "OutlineColor",
        Parent = CheckHolder
    }) :: UIStroke

    local CheckImage = Create("ImageLabel", {
        Image = CheckUrl,
        ImageColor3 = "FontColor",
        ImageRectOffset = CheckOffset,
        ImageRectSize = CheckSize,
        ImageTransparency = 0,
        Position = UDim2_fromOffset(2, 2),
        Size = UDim2_new(1, -4, 1, -4),
        Parent = CheckHolder
    }) :: ImageLabel

    local GradientVector2 = Vector2_new(0.05, 0)

    local CheckGradient = Create("UIGradient", {
        Offset = -GradientVector2,
        Transparency = NumberSequence_new({
            NumberSequenceKeypoint_new(0.00, 0),
            NumberSequenceKeypoint_new(0.49, 0),
            NumberSequenceKeypoint_new(0.51, 1),
            NumberSequenceKeypoint_new(1.00, 1)
        }),
        Parent = CheckImage
    }) :: UIGradient

    Checkbox.Button        = Button
    Checkbox.CheckHolder   = CheckHolder
    Checkbox.CheckStoke    = CheckStoke
    Checkbox.CheckImage    = CheckImage
    Checkbox.CheckGradient = CheckGradient

    function Checkbox:UpdateColors()
        self:Display()
    end

    function Checkbox:Display()
        if wax.Unloaded then return end

        local Value = self.Value

        local CheckHolder = self.CheckHolder
        local TextLabel   = self.TextLabel

        self.CheckStoke.Transparency = self.Disabled and 0.5 or 0

        if self.Disabled then
            TextLabel.TextTransparency   = 0.8
            self.CheckImage.ImageTransparency = Value and 0.8 or 1
            CheckHolder.BackgroundColor3 = Scheme.BackgroundColor

            Registry[CheckHolder].BackgroundColor3 = "BackgroundColor"
        else
            local CheckGradient = self.CheckGradient

            Ease(EasingLibrary, TextLabel, "TextTransparency", Value and 0 or 0.3, TextLabel, 0.2)
            Ease(EasingLibrary, CheckGradient, "Offset", Value and GradientVector2 or -GradientVector2, CheckGradient, 0.2)

            CheckHolder.BackgroundColor3 = Scheme.MainColor
            Registry[CheckHolder].BackgroundColor3 = "MainColor"
        end
    end

    function Checkbox:OnChanged(Callback: (boolean) -> ())
        self.Changed = Callback
    end

    function Checkbox:SetValue(Value: boolean)
        if Value == self.Value or self.Disabled then
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

    function Checkbox:SetDisabled(Disabled: boolean)
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

    function Checkbox:SetVisible(Visible: boolean)
        if self.Visible == Visible then
            return
        end

        self.Visible = Visible
        self.Button.Visible = Visible

        self.Groupbox:Resize()
    end

    function Checkbox:SetText(Text: string)
        self.Text = Text
        self.TextLabel.Text = Text
    end

    function Checkbox:SetTooltip(Text: string, DisabledText: string)
        if typeof(Text) == "string" then
            self.TooltipTable.Text = Text
        end

        if typeof(DisabledText) == "string" then
            self.TooltipTable.DisabledText = DisabledText
        end
    end

    GiveSignal(Connect, nil, Button.MouseButton1Click, function()
        Checkbox:SetValue(not Checkbox.Value)
    end)

    GiveSignal(Connect, nil, Label.MouseEnter, function()
        if Checkbox.Disabled then return end
        Ease(EasingLibrary, Label, "TextTransparency", 0.15, Label, 0.2)
    end)

    GiveSignal(Connect, nil, Label.MouseLeave, function()
        Ease(EasingLibrary, Label, "TextTransparency", 0.3, Label, 0.2)
    end)

    if typeof(Checkbox.Tooltip) == "string" or typeof(Checkbox.DisabledTooltip) == "string" then
        Checkbox.TooltipTable = AddTooltip(Checkbox.Tooltip, Checkbox.DisabledTooltip, Button)
        Checkbox.TooltipTable.Disabled = Checkbox.Disabled
    end

    if Checkbox.Risky then
        Label.TextColor3 = Scheme.Risky
        Registry[Label].TextColor3 = "Risky"
    end

    Checkbox:Display()
    Groupbox:Resize()

    setmetatable(Checkbox, BaseAddons)
    table_insert(Groupbox.Elements, Checkbox)

    Toggles[Index] = Checkbox
    return Checkbox
end

return AddCheckbox
