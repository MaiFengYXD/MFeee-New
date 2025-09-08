--// Credit to richie0866 //

local Instance_new, randomstring, CFrame_fromMatrix, Vector3_new, Vector2_new, CFrame_new, math_ceil, task_spawn
    = Instance.new, randomstring, CFrame.fromMatrix, Vector3.new, Vector2.new, CFrame.new, math.ceil, task.spawn

local Brick    = Enum.MeshType.Brick
local Cylinder = Enum.MeshType.Cylinder

local Camera           = shared.Camera :: Camera
local ScreenPointToRay = Camera.ScreenPointToRay

shared.Connect:GiveSignal("AcrylicBlurCameraChanged", shared.Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    Camera = shared.Workspace.CurrentCamera
end)

local function Create(ClassName: string, Properties: hash): Instance
    local Instance = Instance_new(ClassName)
    Instance.Name = randomstring()

    for Key, Value in Properties do
        (Instance :: any)[Key] = Value
    end

    return Instance
end

local function ConnectTable(Target: table, Assets: table): table
    for Key, Value in Assets do
        if Target[Key] then continue end
        Target[Key] = Value
    end

    return Target
end

local Fill = {
    Color = Color3.new(),
    Material = Enum.Material.Glass,
    Size = Vector3_new(1, 1, 0),
    Anchored = true,
    CanCollide = false,
    Locked = true,
    CastShadow = false,
    Transparency = 1 - 1e-5
}

local Corner = ConnectTable({
    Size = Vector3_new(0, 1, 1)
}, Fill)

local DofEffect = Create("DepthOfFieldEffect", {
    FarIntensity  = 0,
    InFocusRadius = 0.1,
    NearIntensity = 1
}) :: DepthOfFieldEffect

local Proxy = {
    DofEffect = DofEffect,
    Enabled   = false
}

local MetaTable = {
    __index = Proxy,

    __newindex = function(_, Key, Value)
        if Key == "Enabled" then
            DofEffect.Parent = Value and shared.Lighting or nil
        end
        Proxy[Key] = Value
    end
}

local function new(Radius: number?, Distance: number?)
    local AcrylicBlur = {
        Radius   = Radius   or 0,
        Distance = Distance or 1e-3
    }

    local Id = randomstring()

    local AcrylicInstance = Create("Model", {Parent = shared.Workspace})

    local Horizontal = Create("Part", ConnectTable({
        Parent = AcrylicInstance
    }, Fill)) :: Part & {Mesh: SpecialMesh}

    local TopLeft = Create("Part", ConnectTable({
        Parent = AcrylicInstance
    }, Corner)) :: Part & {Mesh: SpecialMesh}

    local Horizontal_Mesh = Create("SpecialMesh", {
        MeshType = Brick,
        Offset = Vector3_new(0, 0, 1e-5),
        Parent = Horizontal,
        Name = "Mesh"
    }) :: SpecialMesh

    local TopLeft_Mesh = Create("SpecialMesh", {
        MeshType = Cylinder,
        Parent = TopLeft,
        Name = "Mesh"
    }) :: SpecialMesh

    local Vertical      = Horizontal:Clone()
    local Vertical_Mesh = Vertical.Mesh
    Vertical.Parent     = AcrylicInstance

    local TopRight      = TopLeft:Clone()
    local TopRight_Mesh = TopRight.Mesh
    TopRight.Parent     = AcrylicInstance

    local BottomLeft      = TopLeft:Clone()
    local BottomLeft_Mesh = BottomLeft.Mesh
    BottomLeft.Parent     = AcrylicInstance

    local BottomRight      = TopLeft:Clone()
    local BottomRight_Mesh = BottomRight.Mesh
    BottomRight.Parent     = AcrylicInstance

    local CylinderAngleOffset = CFrame.Angles(0, math.rad(90), 0)

    local FrameInfo = {
        TopLeft2d       = Vector2.new(),
        TopRight2d      = Vector2.new(),
        BottomRight2d   = Vector2.new(),
        TopLeftRadius2d = Vector2.new()
    }

    local function ViewportPointToWorld(Location: Vector2, Distance: number): Vector3
        local UnitRay = ScreenPointToRay(Camera, Location.X, Location.Y)
        return UnitRay.Origin + UnitRay.Direction * Distance
    end

    local function UpdateBlur()
        local FrameInfo, Camera_CFrame, AcrylicBlur
            = FrameInfo, Camera.CFrame, AcrylicBlur

        local Distance = AcrylicBlur.Distance

        local TopLeft_      = ViewportPointToWorld(FrameInfo.TopLeft2d, Distance)
        local TopRight_     = ViewportPointToWorld(FrameInfo.TopRight2d, Distance)
        local BottomRight_  = ViewportPointToWorld(FrameInfo.BottomRight2d, Distance)
        local TopLeftRadius = ViewportPointToWorld(FrameInfo.TopLeftRadius2d, Distance)

        local CornerRadius = (TopLeftRadius - TopLeft_).Magnitude
        local Width        = (TopRight_ - TopLeft_).Magnitude
        local Height       = (TopRight_ - BottomRight_).Magnitude

        local Center = CFrame_fromMatrix(
            (TopLeft_ + BottomRight_) / 2,
            Camera_CFrame.XVector,
            Camera_CFrame.YVector,
            Camera_CFrame.ZVector
        )

        if AcrylicBlur.Radius > 0 then
            local CFrame_new, CylinderAngleOffset, Vector3_new
                = CFrame_new, CylinderAngleOffset, Vector3_new

            --// Update Body
            Horizontal.CFrame     = Center
            Horizontal_Mesh.Scale = Vector3_new(Width - CornerRadius * 2, Height, 0)

            Vertical.CFrame     = Center
            Vertical_Mesh.Scale = Vector3_new(Width, Height - CornerRadius * 2, 0)

            --// Update Corners
            local LeftCFrame = (
                Center *
                CFrame_new(-Width / 2 + CornerRadius, Height / 2 - CornerRadius, 0) *
                CylinderAngleOffset
            )

            local RightCFrame = (
                Center *
                CFrame_new(Width / 2 - CornerRadius, Height / 2 - CornerRadius, 0) *
                CylinderAngleOffset
            )

            local MeshScale = Vector3_new(0, CornerRadius * 2, CornerRadius * 2)

            TopLeft.CFrame     = LeftCFrame
            TopLeft_Mesh.Scale = MeshScale

            TopRight.CFrame     = RightCFrame
            TopRight_Mesh.Scale = MeshScale

            BottomLeft.CFrame     = LeftCFrame
            BottomLeft_Mesh.Scale = MeshScale

            BottomRight.CFrame     = RightCFrame
            BottomRight_Mesh.Scale = MeshScale
        else
            Horizontal.CFrame     = Center
            Horizontal_Mesh.Scale = Vector3_new(Width, Height, 0)
        end
    end

    UpdateBlur()

    AcrylicBlur.PositionHandle     = shared.Connect:GiveSignal(`AcrylicBlurPositionHandle{Id}`,     Camera:GetPropertyChangedSignal("CFrame"),       UpdateBlur)
    AcrylicBlur.FovHandle          = shared.Connect:GiveSignal(`AcrylicBlurFovHandle{Id}`,          Camera:GetPropertyChangedSignal("FieldOfView"),  UpdateBlur)
    AcrylicBlur.ViewportSizeHandle = shared.Connect:GiveSignal(`AcrylicBlurViewportSizeHandle{Id}`, Camera:GetPropertyChangedSignal("ViewportSize"), UpdateBlur)

    local function GetOffset(): number
        return 8 + (Camera.ViewportSize.Y * 48) / 2560
    end

    local function UpdateFrameInfo(Size: Vector2, Position: Vector2)
        local TopLeftRaw = Position - Size / 2
        local TopLeft2d  = Vector2_new(math_ceil(TopLeftRaw.X), math_ceil(TopLeftRaw.Y))

        FrameInfo = {
            TopLeft2d       = TopLeft2d,
            TopRight2d      = TopLeft2d + Vector2_new(Size.X, 0),
            BottomRight2d   = TopLeft2d + Size,
            TopLeftRadius2d = TopLeft2d + Vector2_new(AcrylicBlur.Radius, 0)
        }
    end

    local function SetFrame(Frame: Frame)
        local function OnChanged()
            local BlurOffset = GetOffset()
            local Size       = Frame.AbsoluteSize - Vector2_new(BlurOffset, BlurOffset)
            local Position   = Frame.AbsolutePosition + Frame.AbsoluteSize / 2

            UpdateFrameInfo(Size, Position)
            task_spawn(UpdateBlur)
        end

        AcrylicBlur.Change = {
            AbsoluteSize     = shared.Connect:GiveSignal(`AcrylicBlurAbsoluteSizeChange{Id}`,     Frame:GetPropertyChangedSignal("AbsoluteSize"),     OnChanged),
            AbsolutePosition = shared.Connect:GiveSignal(`AcrylicBlurAbsolutePositionChange{Id}`, Frame:GetPropertyChangedSignal("AbsolutePosition"), OnChanged)
        }
    end

    AcrylicBlur.SetFrame = SetFrame

    return setmetatable(AcrylicBlur, MetaTable)
end

return {new = new}
