local UDim2_fromOffset, task_spawn, table_clear, typeof: typeof(typeof)
    = UDim2.fromOffset, task.spawn, table.clear, typeof

local Tooltip = {
    CurrentHoverInstance = nil :: any
}

local Library = ...
local CurrentHoverInstance: GuiObject?

local ContextMenu = require("ContextMenu", Library)

local TooltipLabel = Library.Utils.Create("TextLabel", {
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    Parent = wax.shared.ScreenGui,
    ZIndex = 999
}) :: TextLabel

Library.Utils.Create("UICorner", TooltipLabel)

local GetTextBounds = Library.Utils.GetTextBounds
local UpdateDPI     = Library.Utils.UpdateDPI

local Camera = shared.Camera
local Mouse  = shared.Speaker:GetMouse() :: Mouse

local function UpdateLabel()
    local TooltipLabel
        = TooltipLabel

    local DPIScale = Library.DPIScale

    local X, Y = GetTextBounds(
        TooltipLabel.Text,
        TooltipLabel.FontFace,
        TooltipLabel.TextSize,
        Camera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 4
    )

    TooltipLabel.Size = UDim2_fromOffset(X + 8 * DPIScale, Y + 4 * DPIScale)

    UpdateDPI(TooltipLabel, {
        Size = UDim2_fromOffset(X, Y),
        DPIOffset = {Size = {8, 4}}
    })
end

local Connect    = shared.Connect
local GiveSignal = Connect.GiveSignal

local PreRender = shared.RunService.PreRender
local Wait      = game.Close.Wait
local Disconnet = game.Close:Once(function() end).Disconnect

GiveSignal(Connect, TooltipLabel, TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdateLabel))

local IsMouseOverFrame = Library.Utils.IsMouseOverFrame

type TooltipTable = {
    Text:          string,
    DisabledText:  string?,
    HoverInstance: GuiObject,
    Disabled:      boolean,
    Hovering:      boolean,
    Signals:       {RBXScriptConnection},
    DoHover:       (self: TooltipTable) -> (),
    Update:        (self: TooltipTable) -> (),
    Destroy:       (self: TooltipTable) -> ()
}

local function AddTooltip(Text: string, DisabledText: string?, HoverInstance: GuiObject): TooltipTable
    local TooltipTable = {
        Text          = Text,
        DisabledText  = DisabledText,
        HoverInstance = HoverInstance,
        Disabled      = false,
        Hovering      = false,
        Signals       = {}
    } :: TooltipTable

    function TooltipTable:DoHover()
        if (
            CurrentHoverInstance == self.HoverInstance or
            (ContextMenu.CurrentMenu and IsMouseOverFrame(ContextMenu.CurrentMenu.Menu)) or
            (self.Disabled and typeof(self.DisabledText) ~= "string") or
            (not self.Disabled and typeof(self.Text) ~= "string")
        ) then return end

        CurrentHoverInstance = self.HoverInstance
        Tooltip.CurrentHoverInstance = self.HoverInstance

        TooltipLabel.Text = self.Disabled and self.DisabledText or self.Text
        TooltipLabel.Visible = true

        local Wait, PreRender
            = Wait, PreRender

        while (
            Library.Toggled and
            IsMouseOverFrame(self.HoverInstance) and
            not (ContextMenu.CurrentMenu and IsMouseOverFrame(ContextMenu.CurrentMenu.Menu))
        ) do
            local ShowCustomCursor = Library.ShowCustomCursor

            TooltipLabel.Position = UDim2_fromOffset(
                Mouse.X + (ShowCustomCursor and 8 or 14),
                Mouse.Y + (ShowCustomCursor and 8 or 12)
            )

            Wait(PreRender)
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
        Tooltip.CurrentHoverInstance = nil
    end

    local function DoHover()
        return TooltipTable:DoHover()
    end

    TooltipTable.Signals[1] = GiveSignal(Connect, nil, HoverInstance.MouseEnter, DoHover)
    TooltipTable.Signals[2] = GiveSignal(Connect, nil, HoverInstance.MouseMoved, DoHover)

    TooltipTable.Signals[3] = GiveSignal(Connect, nil, HoverInstance.MouseLeave, function()
        if CurrentHoverInstance ~= HoverInstance then return end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
        Tooltip.CurrentHoverInstance = nil
    end)

    function TooltipTable:Update()
        Wait(PreRender)
        task_spawn(UpdateLabel)
    end

    function TooltipTable:Destroy()
        for _, Connection in self.Signals do
            Disconnet(Connection)
        end
        self.Signals = table_clear(self.Signals)

        if CurrentHoverInstance == self.HoverInstance then
            TooltipLabel.Visible = false
            CurrentHoverInstance = nil
            Tooltip.CurrentHoverInstance = nil
        end
    end

    task_spawn(DoHover)

    return TooltipTable
end

Tooltip.AddTooltip = AddTooltip

return Tooltip
