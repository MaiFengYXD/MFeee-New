local setmetatable, randomstring, math_max, task_delay, task_spawn, task_cancel, table_clear, UDim2_fromOffset
    = setmetatable, randomstring, math.max, task.delay, task.spawn, task.cancel, table.clear, UDim2.fromOffset

local      Destroy,      GetPropertyChangedSignal
    = game.Destroy, game.GetPropertyChangedSignal

local Clone = game.Clone :: <T>(T) -> T

local EasingLibrary = shared.EasingLibrary
local Ease = EasingLibrary.Ease

local Connect          = shared.Connect
local GiveSignal       = Connect.GiveSignal
local DisconnectSignal = Connect.DisconnectSignal

local PreRender = shared.RunService.PreRender

local Create = require("Create")

local RootFrame = Create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Parent = shared.ScreenGui,
    ZIndex = 9
})

local Frame = Create("Frame", {
    BackgroundTransparency = 1
}) :: Frame

local UIStroke = Create("UIStroke", {
    Thickness = 7680
}) :: UIStroke

Create("UICorner", {
    CornerRadius = UDim.new(1),
    Parent = Frame
})

local Black = Color3.new()

type Focus = {
    new: (
        Element:      GuiObject,
        FocusRadius:  number?,
        Transparency: number?,
        Color:        Color3?,
        Text:         string?
    ) -> FocusInstance,

    Initialize: (self: FocusInstance) -> (),
    Update:     (self: FocusInstance) -> (),
    Render:     (self: FocusInstance) -> (),
    Destroy:    (self: FocusInstance) -> (),

    __index: Focus
}

type FocusInstance = typeof(setmetatable({
    FocusRadius  = 80,
    AutoRadius   = true,
    Transparency = 0.6,
    Color        = Black,
    Text         = "",
    Elements     = {} :: {Target: GuiObject, Focus: Frame, Background: UIStroke},
    Index        = "",
    _Intro       = {
        Finished = false,
        OnFinish = {} :: {[string]: Function}
    }
}, {
    __index = {} :: Focus
}))

local Focus = {} :: Focus;do
    Focus.__index = Focus

    function Focus.new(
        Element:      GuiObject,
        FocusRadius:  number?,
        Transparency: number?,
        Color:        Color3?,
        Text:         string?
    ): FocusInstance
        local self = setmetatable({
            FocusRadius  = FocusRadius or math_max(Element.AbsoluteSize.X, Element.AbsoluteSize.Y) / 2,
            AutoRadius   = not FocusRadius,
            Transparency = Transparency or 0.6,
            Color        = Color or Black,
            Text         = Text or "",
            Elements     = {Target = game, Focus = game, Background = game}, -- lol
            Index        = randomstring(),
            _Intro       = {
                Finished = false,
                OnFinish = {}
            }
        }, {
            __index = Focus
        })

        self:Initialize()

        return self
    end

    function Focus.Initialize(self: FocusInstance): ()
        local Intro = self._Intro

        Intro.Finished = false
        for _, Callback in Intro.OnFinish do
            task_spawn(Callback)
        end
        Intro.OnFinish = table_clear(Intro.OnFinish)

        Destroy(self.Elements.Focus)
        Destroy(self.Elements.Background)

        local Focus      = Clone(Frame)
        local Background = Clone(UIStroke)

        Focus.Parent      = RootFrame
        Background.Parent = RootFrame

        self.Elements.Focus      = Focus
        self.Elements.Background = Background

        Background.Transparency = 1

        local Target = self.Elements.Target

        if self.AutoRadius then
            local TargetSize = Target.AbsoluteSize
            self.FocusRadius = math_max(TargetSize.X, TargetSize.Y) / 2
        end

        local Radius = self.FocusRadius
        Focus.Size = UDim2_fromOffset(Radius * 2, Radius * 2)

        Ease(EasingLibrary, Focus, "Size", UDim2_fromOffset(Radius, Radius), `Size{self.Index}`, 0.5)
        Ease(EasingLibrary, Background, "Transparency", self.Transparency, `Transparency{self.Index}`, 0.5)

        local Thread = task_delay(0.5, function()
            Intro.Finished = true
            for _, Callback in Intro.OnFinish do
                task_spawn(Callback)
            end
        end)

        Intro.OnFinish.CloseThread = function()
            task_cancel(Thread)
        end

        self:Update()

        GiveSignal(Connect, `FocusElementMovement{self.Index}`, GetPropertyChangedSignal(Target, "AbsolutePosition"), function()
            self:Update()
        end)

        GiveSignal(Connect, `FocusElementRender{self.Index}`, PreRender, function()
            self:Render()
        end)
    end

    function Focus.Update(self: FocusInstance): ()
        local Target = self.Elements.Target

        if self.AutoRadius then
            local TargetSize = Target.AbsoluteSize
            self.FocusRadius = math_max(TargetSize.X, TargetSize.Y) / 2
        end

        local TargetPosition = Target.AbsolutePosition
        self.Elements.Focus.Position = UDim2_fromOffset(TargetPosition.X, TargetPosition.Y)
    end

    function Focus.Render(self: FocusInstance): ()
        if self._Intro.Finished then
            self.Elements.Focus.Size = UDim2_fromOffset(self.FocusRadius * 2, self.FocusRadius * 2)
        elseif EasingLibrary.RunningTween[`Size{self.Index}`].Goal.Size.X.Offset / 2 ~= self.FocusRadius then
            Ease(EasingLibrary, self.Elements.Focus, "Size", UDim2_fromOffset(self.FocusRadius * 2, self.FocusRadius * 2), `Size{self.Index}`, 0.5)
        end

        self.Elements.Background.Color = self.Color
    end

    function Focus.Destroy(self: FocusInstance): ()
        DisconnectSignal(Connect, `FocusElementMovement{self.Index}`)
        DisconnectSignal(Connect, `FocusElementRender{self.Index}`)

        for _, Callback in self._Intro.OnFinish do
            task_spawn(Callback)
        end

        local Elements = self.Elements

        Ease(EasingLibrary, Elements.Focus, "Size", UDim2_fromOffset(self.FocusRadius * 2, self.FocusRadius * 2), `Size{self.Index}`, 0.5)
        Ease(EasingLibrary, Elements.Background, "Transparency", 1, `Transparency{self.Index}`, 0.5)

        task_delay(0.5, function()
            Destroy(Elements.Focus)
            Destroy(Elements.Background)
        end)
    end
end

return Focus
