--// Source by mstudio45 //

local Instance_new, Vector2_new, Vector3_new, Color3_new, Path2DControlPoint_new, UDim2_new, UDim2_fromOffset, CFrame_new, CFrame_Angles
    = Instance.new, Vector2.new, Vector3.new, Color3.new, Path2DControlPoint.new, UDim2.new, UDim2.fromOffset, CFrame.new, CFrame.Angles

local table_clone, table_find, table_remove, table_clear, coroutine_resume, coroutine_create, coroutine_yield, coroutine_close
    = table.clone, table.find, table.remove, table.clear, coroutine.resume, coroutine.create, coroutine.yield, coroutine.close

local math_rad, math_cos, math_atan2, math_deg, math_sin, math_floor, string_match, string_format
    = math.rad, math.cos, math.atan2, math.deg, math.sin, math.floor, string.match, string.format

local randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof
    = randomstring, setmetatable, assert, pcall, tostring, getrainbowcolor, typeof

local      IsA,      Destroy,                                 Disconnect: (RBXScriptConnection) -> nil
    = game.IsA, game.Destroy, game.Close:Once(function() end).Disconnect

local UserInputService = shared.UserInputService
local GetMouseLocation = UserInputService.GetMouseLocation

local _VERSION = "2.0.2";

type TracerESPSettings = {
    Enabled: boolean,

    Color: Color3?,
    Thickness: number?,
    Transparency: number?,
    From: Vector2 | "Top" | "Bottom" | "Center" | "Mouse",

    To: Vector2?,
}

type ArrowESPSettings = {
    Enabled: boolean,

    Color: Color3?,
    CenterOffset: number?,
}

type ESPSettings = {
    Name: string?,

    Model: Object,
    TextModel: Object?,

    Visible: boolean?,
    Color: Color3?,
    MaxDistance: number?,

    StudsOffset: Vector3?,
    TextSize: number?,

    ESPType: "Text" | "SphereAdornment" | "CylinderAdornment" | "Adornment" | "SelectionBox" | "Highlight",
    Thickness: number?,
    Transparency: number?,

    SurfaceColor: Color3?,
    BorderColor: Color3?,

    FillColor: Color3?,
    OutlineColor: Color3?,

    FillTransparency: number?,
    OutlineTransparency: number?,

    Tracer: TracerESPSettings?,
    Arrow: ArrowESPSettings?,

    OnDestroy: BindableEvent?,
    OnDestroyFunc: (() -> nil)?,

    ModelRoot: Instance?,
}

--// Variables //
local tablefreeze = function<T>(provided_table: T & {}): any
    local proxy = {}
    local data = table_clone(provided_table)

    local mt = {
        __index = function(table, key)
            return data[key]
        end,

        __newindex = function(table, key, value)
            -- nope --
        end
    }

    return setmetatable(proxy, mt) :: any
end

--// Functions //
local GetPivot = (function()
    local CFrame_identity
        = CFrame.identity

    local GetPivot = Instance_new("Part").GetPivot

    return function(Instance: Bone | Attachment | Camera | PVInstance | any): CFrame
        if IsA(Instance, "Bone") then
            return Instance.TransformedWorldCFrame
        elseif IsA(Instance, "Attachment") then
            return Instance.WorldCFrame
        elseif IsA(Instance, "Camera") then
            return Instance.CFrame
        elseif IsA(Instance, "PVInstance") then
            return GetPivot(Instance :: PVInstance)
        end

        return CFrame_identity
    end
end)()

--// Instances //
local InstancesLib = {
    Create = function(instanceType, properties): Instance
        assert(typeof(instanceType) == "string", "Argument #1 must be a string.")
        assert(typeof(properties) == "table", "Argument #2 must be a table.")

        local instance = Instance_new(instanceType)
        instance.Name = randomstring()

        for name, val in properties do
            if name == "Parent" then
                continue --/ Parenting is expensive, do last.
            end

            (instance :: any)[name] = val
        end

        instance["Parent"] = properties["Parent"]

        return instance :: typeof(instance)
    end,

    TryGetProperty = function(instance: Instance | Object?, propertyName): any
        assert(typeof(instance) == "Instance", "Argument #1 must be an Instance.")
        assert(typeof(propertyName) == "string", "Argument #2 must be a string.")

        local success, property = pcall(function()
            return (instance :: any)[propertyName]
        end)

        return if success then property else nil;
    end,

    FindPrimaryPart = function(instance): any | Instance
        if typeof(instance) ~= "Instance" then
            return nil
        end

        local Primary = "PrimaryPart"

        return (IsA(instance, "Model") and instance[Primary] or nil)
            or instance:FindFirstChildWhichIsA("BasePart")
            or instance:FindFirstChildWhichIsA("UnionOperation")
            or instance;
    end,

    DistanceFrom = function(inst, from): number
        if not (inst and from) then
            return 9e9;
        end

        local position = if typeof(inst) == "Instance" then GetPivot(inst).Position else inst;
        local fromPosition = if typeof(from) == "Instance" then GetPivot(from).Position else from;

        return (fromPosition - position).Magnitude;
    end
}

--// GUI //
local ActiveFolder = InstancesLib.Create("Folder", {})

local StorageFolder = InstancesLib.Create("Folder", {})

local MainGUI = InstancesLib.Create("ScreenGui", {
    Parent = gethui(),
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ClipToDeviceSafeArea = false,
    OnTopOfCoreBlur = true,
    DisplayOrder = 1e6
})

local BillboardGUI = InstancesLib.Create("ScreenGui", {
    Parent = gethui(),
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ClipToDeviceSafeArea = false,
    OnTopOfCoreBlur = true,
    DisplayOrder = 1e6
})

--// Library //
local Library = {
    Destroyed = false,

    --// Storages
    ActiveFolder = ActiveFolder,
    StorageFolder = StorageFolder,
    MainGUI = MainGUI,
    BillboardGUI = BillboardGUI,
    ESP = {},
    Connections = {} :: { RBXScriptConnection },

    --// Global Config
    GlobalConfig = {
        IgnoreCharacter = false,
        Rainbow = false,

        Billboards = true,
        Highlighters = true,
        Distance = true,
        Tracers = true,
        Arrows = true,

        Font = wax.shared.FirstFont or Enum.Font.SourceSans
    },

    --// Rainbow Variables
    RainbowSpeed = 0.4,
    RainbowColor = Color3_new()
}

--// Player Variables //
local character: Model
local rootPart: Part?
local Camera: Camera = shared.Camera

local WorldToViewportPoint = Camera.WorldToViewportPoint

local function UpdatePlayerVariables(newCharacter: any, force: boolean?)
    if force ~= true and Library.GlobalConfig.IgnoreCharacter == true then
        return
    end

    character = newCharacter or shared.Players.LocalPlayer.Character or shared.Players.LocalPlayer.CharacterAdded:Wait();
    rootPart = (
        character:WaitForChild("HumanoidRootPart", 2.5)
        or character:WaitForChild("UpperTorso", 2.5)
        or character:WaitForChild("Torso", 2.5)
        or character.PrimaryPart
        or character:WaitForChild("Head", 2.5)
    ) :: Part;
end
task.spawn(UpdatePlayerVariables, nil, true);

--// Library Functions //
local PublicESPDestroy

function Library:Clear()
    if Library.Destroyed == true then
        return
    end

    for _, ESP in Library.ESP do
        if not ESP then continue end

        if not PublicESPDestroy then
            PublicESPDestroy = (ESP :: any).Destroy
        end
        PublicESPDestroy(ESP)
    end
end

function Library:Destroy()
    if Library.Destroyed == true then
        return
    end

    Library.Destroyed = true;
    Library:Clear();

    Destroy(ActiveFolder);
    Destroy(StorageFolder);
    Destroy(MainGUI);
    Destroy(BillboardGUI);

    --// Clear connections
    for _, connection in Library.Connections do
        if not connection.Connected then
            continue
        end

        Disconnect(connection)
    end

    table_clear(Library)
end

--// Type Checks //
local AllowedTracerFrom = {
    Top = true,
    Bottom = true,
    Center = true,
    Mouse = true,
}

local AllowedESPType = {
    Text = true,
    Sphereadornment = true,
    Cylinderadornment = true,
    Adornment = true,
    Selectionbox = true,
    Highlight = true,
}

--// ESP Instances //
local function TracerCreate(espSettings: TracerESPSettings, instanceName: string?)
    if Library.Destroyed == true then
        return
    end

    if not espSettings or espSettings.Enabled ~= true then
        return
    end

    --// Fix Settings
    espSettings.Color = typeof(espSettings.Color) == "Color3" and espSettings.Color or Color3_new()
    espSettings.Thickness = typeof(espSettings.Thickness) == "number" and espSettings.Thickness or 2
    espSettings.Transparency = typeof(espSettings.Transparency) == "number" and espSettings.Transparency or 0
    espSettings.From = typeof(espSettings.From) == "string" and espSettings.From or "Bottom"
    if AllowedTracerFrom[espSettings.From] == nil then
        espSettings.From = "Bottom"
    end

    --// Create Path2D
    local Path2D = (InstancesLib.Create("Path2D", {
        Parent = MainGUI,
        Name = if typeof(instanceName) == "string" then instanceName else "Tracer",
        Closed = true,

        --// Settings
        Color3 = espSettings.Color,
        Thickness = espSettings.Thickness,
        Transparency = espSettings.Transparency,
    }) :: Path2D)

    local SetControlPoints = Path2D.SetControlPoints

    local function UpdateTracer(from: Vector2, to: Vector2)
        SetControlPoints(Path2D, {
            Path2DControlPoint_new(UDim2_fromOffset(from.X, from.Y)),
            Path2DControlPoint_new(UDim2_fromOffset(to.X, to.Y))
        })
    end

    --// Data Table
    local data = {
        From = if typeof(espSettings.From) == "Vector2" then espSettings.From else Vector2_new(0, 0),
        To = if typeof(espSettings.To) == "Vector2" then espSettings.To else Vector2_new(0, 0),

        Visible = true,
        Color3 = espSettings.Color,
        Thickness = espSettings.Thickness,
        Transparency = espSettings.Transparency,
    }
    UpdateTracer((data.From :: Vector2), (data.To :: Vector2));

    --// Tracer Metatable
    local proxy = {}
    local Tracer = {
        __newindex = function(table, key, value)
            if not Path2D then
                return
            end

            if key == "From" then
                assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                UpdateTracer(value, (data.To :: Vector2))

            elseif key == "To" then
                assert(typeof(value) == "Vector2", tostring(key) .. "; expected Vector2, got " .. typeof(value))
                UpdateTracer((data.From :: Vector2), value)

            elseif key == "Transparency" or key == "Thickness" then
                assert(typeof(value) == "number", tostring(key) .. "; expected number, got " .. typeof(value));
                (Path2D :: any)[key] = value

            elseif key == "Color3" then
                assert(typeof(value) == "Color3", tostring(key) .. "; expected Color3, got " .. typeof(value));
                (Path2D :: any).Color3 = value

            elseif key == "Visible" then
                assert(typeof(value) == "boolean", tostring(key) .. "; expected boolean, got " .. typeof(value))

                Path2D.Parent = if value then MainGUI else StorageFolder;
            end

            data[key] = value
        end,

        __index = function(table, key)
            if not Path2D then
                return nil
            end

            if key == "Destroy" or key == "Delete" then
                return (function()
                    SetControlPoints(Path2D, {});
                    Path2D = Destroy(Path2D);
                end) :: any
            end

            return (data :: any)[key]
        end,
    }

    return setmetatable(proxy, Tracer)
end

function Library:Add(espSettings: ESPSettings)
    if Library.Destroyed == true then
        return
    end

    assert(typeof(espSettings) == "table", "espSettings; expected table, got " .. typeof(espSettings))
    assert(
        typeof(espSettings.Model) == "Instance",
        "espSettings.Model; expected Instance, got " .. typeof(espSettings.Model)
    )

    --// Fix ESPType
    if not espSettings.ESPType then
        espSettings.ESPType = "Highlight"
    end
    assert(
        typeof(espSettings.ESPType) == "string",
        "espSettings.ESPType; expected string, got " .. typeof(espSettings.ESPType)
    )

    assert(AllowedESPType[espSettings.ESPType] == true, "espSettings.ESPType; invalid ESPType")

    --// Fix Settings
    local Name = "Name"

    espSettings.Name = if typeof(espSettings.Name) == "string" then espSettings[Name] else (espSettings.Model :: any)[Name];
    espSettings.TextModel = if typeof(espSettings.TextModel) == "Instance" then espSettings.TextModel else espSettings.Model;

    espSettings.Visible = if typeof(espSettings.Visible) == "boolean" then espSettings.Visible else true;
    espSettings.Color = if typeof(espSettings.Color) == "Color3" then espSettings.Color else Color3_new();
    espSettings.MaxDistance = if typeof(espSettings.MaxDistance) == "number" then espSettings.MaxDistance else 5000;

    espSettings.StudsOffset = if typeof(espSettings.StudsOffset) == "Vector3" then espSettings.StudsOffset else Vector3_new();
    espSettings.TextSize = if typeof(espSettings.TextSize) == "number" then espSettings.TextSize else 16;

    espSettings.Thickness = if typeof(espSettings.Thickness) == "number" then espSettings.Thickness else 0.1;
    espSettings.Transparency = if typeof(espSettings.Transparency) == "number" then espSettings.Transparency else 0.65;

    espSettings.SurfaceColor = if typeof(espSettings.SurfaceColor) == "Color3" then espSettings.SurfaceColor else Color3_new();
    espSettings.BorderColor = if typeof(espSettings.BorderColor) == "Color3" then espSettings.BorderColor else Color3_new();

    espSettings.FillColor = if typeof(espSettings.FillColor) == "Color3" then espSettings.FillColor else Color3_new();
    espSettings.OutlineColor = if typeof(espSettings.OutlineColor) == "Color3" then espSettings.OutlineColor else Color3_new(1, 1, 1);

    espSettings.FillTransparency = if typeof(espSettings.FillTransparency) == "number" then espSettings.FillTransparency else 0.65;
    espSettings.OutlineTransparency = if typeof(espSettings.OutlineTransparency) == "number" then espSettings.OutlineTransparency else 0;

    espSettings.Tracer = if typeof(espSettings.Tracer) == "table" then espSettings.Tracer else { Enabled = false, From = "Bottom" };
    espSettings.Arrow = if typeof(espSettings.Arrow) == "table" then espSettings.Arrow else { Enabled = false };

    --// ESP Data //
    local ESP = {
        Index = randomstring(),
        OriginalSettings = tablefreeze(espSettings),
        CurrentSettings = espSettings,

        Hidden = false,
        Deleted = false,
        Connections = {} :: { RBXScriptConnection },
        RenderThread = nil :: thread?
    } :: table

    --// Create Billboard
    local Billboard = (InstancesLib.Create("BillboardGui", {
        Parent = BillboardGUI,
        Name = ESP.Index,

        Enabled = true,
        ResetOnSpawn = false,
        AlwaysOnTop = true,
        Size = UDim2_new(0, 200, 0, 50),

        --// Settings
        Adornee = ESP.CurrentSettings.TextModel or ESP.CurrentSettings.Model,
        StudsOffset = ESP.CurrentSettings.StudsOffset or Vector3_new(),
    }) :: BillboardGui)

    local BillboardText = (InstancesLib.Create("TextLabel", {
        Parent = Billboard,

        Size = UDim2_new(0, 200, 0, 50),
        Font = Library.GlobalConfig.Font,
        TextWrap = true,
        TextWrapped = true,
        RichText = true,
        TextStrokeTransparency = 0,
        BackgroundTransparency = 1,

        --// Settings
        Text = ESP.CurrentSettings.Name,
        TextColor3 = ESP.CurrentSettings.Color or Color3_new(),
        TextSize = ESP.CurrentSettings.TextSize or 16,
    }) :: TextLabel)

    InstancesLib.Create("UIStroke", {
        Parent = BillboardText
    })

    --// Create Highlighter
    local Highlighter: any, IsAdornment = nil, not not string_match(ESP.OriginalSettings.ESPType, "Adornment")

    if IsAdornment then
        local _, ModelSize
        if ESP.CurrentSettings.Model:IsA("Model") then
            _, ModelSize = ESP.CurrentSettings.Model:GetBoundingBox()
        elseif ESP.CurrentSettings.Model:IsA("BasePart") then
            ModelSize = ESP.CurrentSettings.Model.Size
        elseif not InstancesLib.TryGetProperty(ESP.CurrentSettings.Model, "Size") then
            local prim = InstancesLib.FindPrimaryPart(ESP.CurrentSettings.Model)
            if not InstancesLib.TryGetProperty(prim, "Size") then
                espSettings.ESPType = "Highlight"
                return Library:Add(espSettings)
            end

            ModelSize = prim.Size
        end

        if ESP.OriginalSettings.ESPType == "Sphereadornment" then
            Highlighter = InstancesLib.Create("SphereHandleAdornment", {
                Parent = ActiveFolder,
                Name = ESP.Index,

                Adornee = ESP.CurrentSettings.Model,

                AlwaysOnTop = true,
                ZIndex = 10,

                Radius = ModelSize.X * 1.085,
                CFrame = CFrame_new() * CFrame_Angles(math_rad(90), 0, 0),

                --// Settings
                Color3 = ESP.CurrentSettings.Color or Color3_new(),
                Transparency = ESP.CurrentSettings.Transparency or 0.65,
            })
        elseif ESP.OriginalSettings.ESPType == "Cylinderadornment" then
            Highlighter = InstancesLib.Create("CylinderHandleAdornment", {
                Parent = ActiveFolder,
                Name = ESP.Index,

                Adornee = ESP.CurrentSettings.Model,

                AlwaysOnTop = true,
                ZIndex = 10,

                Height = ModelSize.Y * 2,
                Radius = ModelSize.X * 1.085,
                CFrame = CFrame_new() * CFrame_Angles(math_rad(90), 0, 0),

                --// Settings
                Color3 = ESP.CurrentSettings.Color or Color3_new(),
                Transparency = ESP.CurrentSettings.Transparency or 0.65,
            })
        else
            Highlighter = InstancesLib.Create("BoxHandleAdornment", {
                Parent = ActiveFolder,
                Name = ESP.Index,

                Adornee = ESP.CurrentSettings.Model,

                AlwaysOnTop = true,
                ZIndex = 10,

                Size = ModelSize,

                --// Settings
                Color3 = ESP.CurrentSettings.Color or Color3_new(),
                Transparency = ESP.CurrentSettings.Transparency or 0.65,
            })
        end
    elseif ESP.OriginalSettings.ESPType == "Selectionbox" then
        Highlighter = InstancesLib.Create("SelectionBox", {
            Parent = ActiveFolder,
            Name = ESP.Index,

            Adornee = ESP.CurrentSettings.Model,

            Color3 = ESP.CurrentSettings.BorderColor or Color3_new(),
            LineThickness = ESP.CurrentSettings.Thickness or 0.1,

            SurfaceColor3 = ESP.CurrentSettings.SurfaceColor or Color3_new(),
            SurfaceTransparency = ESP.CurrentSettings.Transparency or 0.65,
        })
    elseif ESP.OriginalSettings.ESPType == "Highlight" then
        Highlighter = InstancesLib.Create("Highlight", {
            Parent = ActiveFolder,
            Name = ESP.Index,

            Adornee = ESP.CurrentSettings.Model,

            --// Settings
            FillColor = ESP.CurrentSettings.FillColor or Color3_new(),
            OutlineColor = ESP.CurrentSettings.OutlineColor or Color3_new(1, 1, 1),

            FillTransparency = ESP.CurrentSettings.FillTransparency or 0.65,
            OutlineTransparency = ESP.CurrentSettings.OutlineTransparency or 0,
        })
    end

    --// Create Tracer and Arrow
    local TracerData = ESP.CurrentSettings.Tracer :: TracerESPSettings?
    local Tracer = if typeof(TracerData) == "table" then TracerCreate((TracerData :: TracerESPSettings), ESP.Index) else nil;

    local ArrowData = ESP.CurrentSettings.Arrow :: ArrowESPSettings?
    local Arrow = nil :: ImageLabel?;

    if typeof(ArrowData) == "table" then
        Arrow = (InstancesLib.Create("ImageLabel", {
            Parent = MainGUI,
            Name = ESP.Index,

            Size = UDim2_new(0, 48, 0, 48),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,

            AnchorPoint = Vector2_new(0.5, 0.5),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,

            Image = "http://www.roblox.com/asset/?id=16368985219",
            ImageColor3 = ESP.CurrentSettings.Color or Color3_new(),
        }) :: ImageLabel);

        (ArrowData :: table).CenterOffset = if typeof((ArrowData :: table).CenterOffset) == "number" then (ArrowData :: table).CenterOffset else 300;
    end

    --// Setup Delete Handler
    function ESP:Destroy()
        if self.Deleted == true then
            return;
        end

        self.Deleted = true

        if self.RenderThread then
            pcall(coroutine.close, self.RenderThread)
        end

        if table_find(Library.ESP, self.Index) then
            table_remove(Library.ESP, table_find(Library.ESP, self.Index))
        end

        Library.ESP[self.Index] = nil

        --// Delete ESP Instances
        if Billboard then Destroy(Billboard) end
        if Highlighter then Destroy(Highlighter) end
        if Tracer then Destroy(Tracer) end
        if Arrow then Destroy(Arrow) end

        --// Clear connections
        for _, connection in self.Connections do
            if not connection.Connected then
                continue
            end

            Disconnect(connection)
        end

        table_clear(self.Connections)

        --// OnDestroy
        if self.OriginalSettings.OnDestroy then
            pcall(self.OriginalSettings.OnDestroy.Fire, self.OriginalSettings.OnDestroy)
        end

        if self.OriginalSettings.OnDestroyFunc then
            pcall(self.OriginalSettings.OnDestroyFunc)
        end
    end

    --// Setup Update Handler
    local function Show(forceShow: boolean?)
        if not (ESP and ESP.Deleted ~= true) then return end
        if forceShow ~= true and not ESP.Hidden then
            return
        end

        ESP.Hidden = false;

        --// Apply to Instances
        Billboard.Enabled = true;

        if Highlighter then
            Highlighter.Adornee = ESP.CurrentSettings.Model;
            Highlighter.Parent = ActiveFolder;
        end

        if Tracer then
            Tracer.Visible = true;
        end

        if Arrow then
            Arrow.Visible = true;
        end
    end

    local function Hide(forceHide: boolean?)
        if not (ESP and ESP.Deleted ~= true) then return end
        if forceHide ~= true and ESP.Hidden then
            return
        end

        ESP.Hidden = true

        --// Apply to Instances
        Billboard.Enabled = false;

        if Highlighter then
            Highlighter.Adornee = nil;
            Highlighter.Parent = StorageFolder;
        end

        if Tracer then
            Tracer.Visible = false;
        end

        if Arrow then
            Arrow.Visible = false;
        end
    end

    function ESP:Show(force: boolean?)
        ESP.CurrentSettings.Visible = true
        Show(force);
    end

    function ESP:Hide(force: boolean?)
        if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then return end

        ESP.CurrentSettings.Visible = false
        Hide(force);
    end

    function ESP:ToggleVisibility(force: boolean?)
        ESP.CurrentSettings.Visible = not ESP.CurrentSettings.Visible
        if ESP.CurrentSettings.Visible then
            Show(force);
        else
            Hide(force);
        end
    end

    function ESP:Render()
        if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then return end
        if
            ESP.CurrentSettings.Visible == false or
            not Camera or
            (if Library.GlobalConfig.IgnoreCharacter == true then false else not rootPart)
        then
            Hide()
            return
        end

        --// Check Distance
        if not ESP.CurrentSettings.ModelRoot then
            ESP.CurrentSettings.ModelRoot = InstancesLib.FindPrimaryPart(ESP.CurrentSettings.Model)
        end

        local ModelRoot = ESP.CurrentSettings.ModelRoot :: Instance
        local screenPos, isOnScreen = WorldToViewportPoint(
            Camera,
            GetPivot(ModelRoot or ESP.CurrentSettings.Model).Position
        )

        local distanceFromPlayer = InstancesLib.DistanceFrom(
            (ModelRoot or ESP.CurrentSettings.Model),
            (if Library.GlobalConfig.IgnoreCharacter == true then (Camera or rootPart) else rootPart)
        )

        if distanceFromPlayer > (ESP.CurrentSettings.MaxDistance :: number) then
            Hide()
            return
        end

        --// Update Arrow (only requires distance check) //
        if Arrow then
            local ArrowData = ESP.CurrentSettings.Arrow :: ArrowESPSettings
            Arrow.Visible = Library.GlobalConfig.Arrows == true and ArrowData.Enabled == true and (isOnScreen ~= true)

            if Arrow.Visible then
                local screenSize = Camera.ViewportSize
                local centerPos = screenSize / 2

                --[[use aspect to make oval circle
                local aspectRatioX = screenSize.X / screenSize.Y;
                local aspectRatioY = screenSize.Y / screenSize.X;
                local arrowPosPixel = Vector2_new(
                    arrowTable.ArrowInstance.Position.X.Scale,
                    arrowTable.ArrowInstance.Position.Y.Scale
                ) * 1000;]]
                local partPos = Vector2_new(screenPos.X, screenPos.Y)

                local IsInverted = screenPos.Z <= 0
                local invert = (IsInverted and -1 or 1)

                local direction = (partPos - centerPos)
                local arctan = math_atan2(direction.Y, direction.X)
                local angle = math_deg(arctan) + 90
                local distance = ((ArrowData.CenterOffset :: number) * 0.001) * screenSize.Y

                Arrow.Rotation = angle + 180 * (IsInverted and 0 or 1)
                Arrow.Position = UDim2_new(
                    0,
                    centerPos.X + (distance * math_cos(arctan) * invert),
                    0,
                    centerPos.Y + (distance * math_sin(arctan) * invert)
                )
                Arrow.ImageColor3 =
                    (if Library.GlobalConfig.Rainbow then Library.RainbowColor else ArrowData.Color :: Color3);
            end
        end

        if isOnScreen == false then
            Hide()
            return
        else Show() end

        --// Update Tracer //
        if Tracer then
            local TracerData = ESP.CurrentSettings.Tracer :: TracerESPSettings
            Tracer.Visible = Library.GlobalConfig.Tracers == true and TracerData.Enabled == true;

            if Tracer.Visible then
                if TracerData.From == "Mouse" then
                    local mousePos = GetMouseLocation(UserInputService)
                    Tracer.From = Vector2_new(mousePos.X, mousePos.Y)
                elseif TracerData.From == "Top" then
                    Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, 0)
                elseif TracerData.From == "Center" then
                    Tracer.From = Camera.ViewportSize / 2
                else
                    Tracer.From = Vector2_new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                end

                Tracer.To = Vector2_new(screenPos.X, screenPos.Y)

                Tracer.Transparency = TracerData.Transparency
                Tracer.Thickness = TracerData.Thickness
                Tracer.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor
                    or TracerData.Color
            end
        end

        --// Update Billboard //
        if Billboard then
            Billboard.Enabled = Library.GlobalConfig.Billboards == true;

            if Billboard.Enabled then
                if Library.GlobalConfig.Distance then
                    local Name, TextSize = ESP.CurrentSettings.Name, ESP.CurrentSettings.TextSize
                    BillboardText.Text = string_format(
                        '%s\n<font size="%d">[%s]</font>',
                        Name,
                        TextSize - 3,
                        tostring(math_floor(distanceFromPlayer))
                    )
                else
                    BillboardText.Text = ESP.CurrentSettings.Name
                end

                BillboardText.Font = Library.GlobalConfig.Font
                BillboardText.TextColor3 =
                    if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.Color;
                BillboardText.TextSize = ESP.CurrentSettings.TextSize
            end
        end

        --// Update Highlighter //
        if Highlighter then
            Highlighter.Parent = if Library.GlobalConfig.Highlighters == true then ActiveFolder else StorageFolder;
            Highlighter.Adornee = if Library.GlobalConfig.Highlighters == true then ESP.CurrentSettings.Model else nil;

            if Highlighter.Adornee then
                if IsAdornment then
                    Highlighter.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor or ESP.CurrentSettings.Color
                    Highlighter.Transparency = ESP.CurrentSettings.Transparency

                elseif ESP.OriginalSettings.ESPType == "Selectionbox" then
                    Highlighter.Color3 = Library.GlobalConfig.Rainbow and Library.RainbowColor or ESP.CurrentSettings.Color
                    Highlighter.LineThickness = ESP.CurrentSettings.Thickness

                    Highlighter.SurfaceColor3 = ESP.CurrentSettings.SurfaceColor
                    Highlighter.SurfaceTransparency = ESP.CurrentSettings.Transparency

                else
                    Highlighter.FillColor =
                        if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.FillColor;
                    Highlighter.OutlineColor =
                        if Library.GlobalConfig.Rainbow then Library.RainbowColor else ESP.CurrentSettings.OutlineColor;

                    Highlighter.FillTransparency = ESP.CurrentSettings.FillTransparency
                    Highlighter.OutlineTransparency = ESP.CurrentSettings.OutlineTransparency
                end
            end
        end
    end

    if not ESP.OriginalSettings.Visible then
        Hide()
    end

    ESP.RenderThread = coroutine_create(function()
        local Render = ESP.Render

        while true do
            pcall(Render, ESP)
            coroutine_yield()
        end
    end)

    coroutine_resume(ESP.RenderThread)

    Library.ESP[ESP.Index] = ESP
    return ESP
end

--// Update Player Variables //
table.insert(Library.Connections, shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = shared.Workspace.CurrentCamera;
end))
table.insert(Library.Connections, shared.Speaker.CharacterAdded:Connect(UpdatePlayerVariables))

--// Rainbow Handler //
table.insert(Library.Connections, shared.RunService.PreRender:Connect(function()
    Library.RainbowColor = getrainbowcolor(Library.RainbowSpeed)
end))

--// Main Handler //
table.insert(Library.Connections, shared.RunService.PreRender:Connect(function()
    for Index, ESP in Library.ESP do
        if not (ESP and ESP.CurrentSettings and ESP.Deleted ~= true) then
            if ESP and ESP.RenderThread then
                pcall(coroutine_close, ESP.RenderThread)
            end

            Library.ESP[Index] = nil
            continue
        end

        if not ESP.CurrentSettings.Model or not ESP.CurrentSettings.Model.Parent then
            if not PublicESPDestroy then
                PublicESPDestroy = ESP.Destroy
            end

            PublicESPDestroy(ESP)
            continue
        end

        pcall(coroutine_resume, ESP.RenderThread)
    end
end))

return Library
