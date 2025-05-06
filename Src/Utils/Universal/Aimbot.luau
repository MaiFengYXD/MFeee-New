local Color3_fromHSV, Vector2_new, CFrame_new, CFrame_lookAt, RaycastParams_new, Ray_new, Vector3_zero
    = Color3.fromHSV, Vector2.new, CFrame.new, CFrame.lookAt, RaycastParams.new, Ray.new, Vector3.zero

local      FindFirstChild,      FindFirstChildOfClass,      GetDescendants,      IsA
    = game.FindFirstChild, game.FindFirstChildOfClass, game.GetDescendants, game.IsA

local getcallingscript, checkcaller, mousemoverel, unpack, warn, tostring, pcall
    = getcallingscript, checkcaller, mousemoverel, unpack, warn, tostring, pcall

local tick, table_insert, table_sort, table_clear, table_find, os_clock
    = tick, table.insert, table.sort, table.clear, table.find, os.clock

local Aimbot = {
    Enabled = false,
    Method  = "SilentAim" :: "SilentAim" | "Aimbot",
    Modules = {},

    Shared = {
        TeamCheck  = true,
        AliveCheck = true,
        WallCheck  = false,

        ForceFieldCheck = true,

        TargetPlayers = true,
        TargetNpcs    = true,

        Locked = nil,

        TeamCheckBasedOn = "TeamColor" :: "TeamColor" | "Team" ,
        BlacklistMode    = "Blacklist" :: "Blacklist" | "Whitelist",

        HitChance      = 100,
        HeadshotChance = 100,
        MaxDistance    = 2000,

        Blacklist = {},
        Projectile = {
            Enabled = false,
            Library = require("../Prediction"),

            Speed   = 1000,
            Gravity = shared.Workspace.Gravity
        }
    },

    Fov = {
        Circle = nil,

        Enabled = false,
        Visible = true,

        Rainbow   = false,
        Filled    = false,
        FromMouse = true,

        Radius       = 150,
        Thickness    = 2,
        NumSides     = 60,
        Transparency = 0.35,
        RainbowSpeed = 0.4,

        Color       = Color3.new(1, 1, 1),
        LockedColor = Color3.new(1, 0, 0),

        Outline = {
            Circle  = nil,
            Visible = true,

            Thickness    = 1,
            Transparency = 0.35,

            Color = Color3.new(0, 0, 0)
        }
    }
}

local Random: Random = Random.new()
local NextNumber     = Random.NextNumber

local WorldToViewportPoint = shared.Camera.WorldToViewportPoint
local GetPlayers    = shared.Players.GetPlayers
local Raycast = shared.Workspace.Raycast

local EasingLibrary = wax.shared.EasingLibrary
local NpcHandler    = wax.shared.NpcHandler
local UiManager     = wax.shared.UiManager

local Options = UiManager.Library.Options

local function GetMousePosition()
    if shared.UserInputService.TouchEnabled or not Aimbot.Fov.FromMouse then
        return shared.Camera.ViewportSize / 2
    end
    return shared.UserInputService:GetMouseLocation()
end

--// Fov //
if wax.shared.ExecutorSupport.Drawing then
    local self = Aimbot.Fov

    self.Circle         = Drawing.new("Circle")
    self.Outline.Circle = Drawing.new("Circle")

    self.Circle.Visible         = false
    self.Outline.Circle.Visible = false

    shared.Connect:GiveSignal("AimbotCircleUpdate", shared.RunService.PreRender:Connect(function()
        local CirclePotistion = GetMousePosition()
        local RainbowColor    = self.Rainbow and Color3_fromHSV((tick() * self.RainbowSpeed) % 1, 1, 1)
        local CircleVisible   = Aimbot.Enabled and self.Enabled and self.Visible

        --// Update Circle
        self.Circle.Visible      = CircleVisible
        self.Circle.Position     = CirclePotistion
        self.Circle.Color        = RainbowColor or Aimbot.Shared.Locked and self.LockedColor or self.Color
        self.Circle.Radius       = self.Radius
        self.Circle.Thickness    = self.Thickness
        self.Circle.NumSides     = self.NumSides
        self.Circle.Filled       = self.Filled
        self.Circle.Transparency = 1 - self.Transparency

        --// Update Outline
        self.Outline.Circle.Visible      = CircleVisible and self.Outline.Visible
        self.Outline.Circle.Position     = CirclePotistion
        self.Outline.Circle.Color        = RainbowColor or self.Outline.Color
        self.Outline.Circle.Radius       = self.Radius + self.Outline.Thickness / 2
        self.Outline.Circle.Thickness    = self.Outline.Thickness
        self.Outline.Circle.NumSides     = self.NumSides
        self.Outline.Circle.Filled       = false
        self.Outline.Circle.Transparency = 1 - self.Outline.Transparency
    end))
end

--// Shared Functions //
Aimbot.Shared.WallChecker = function(Origin: Vector3, Position: Vector3, IgonreObjects: Array): RaycastResult?
    local RaycastParams = RaycastParams_new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParams.FilterDescendantsInstances = IgonreObjects

    return Raycast(shared.Workspace, Origin, (Position - Origin), RaycastParams)
end

Aimbot.Shared.FindRoot = function(Character: Model): BasePart | any
    if not Character then return end
    return (
        FindFirstChild(Character, "HumanoidRootPart") or
        FindFirstChild(Character, "UpperTorso") or
        FindFirstChild(Character, "Torso")
    )
end

Aimbot.Shared.CheckCondition = function(Character: Model): boolean
    local Shared = Aimbot.Shared

    local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")
    if not Humanoid or Shared.AliveCheck and Humanoid.Health <= 0 then return true end

    local RootPart = Shared.FindRoot(Character)
    if not RootPart then return true end

    if Shared.ForceFieldCheck and FindFirstChildOfClass(Character, "ForceField") then return true end
    return false
end

Aimbot.Shared.FastSolve = function(Origin: Vector3, TargetPart: BasePart, Params: RaycastParams?)
    local Projectile = Aimbot.Shared.Projectile
    return Projectile.Library.SolveTrajectory(
        Origin,
        Projectile.Speed,
        Projectile.Gravity,
        TargetPart.Position,
        TargetPart.AssemblyLinearVelocity,
        nil,
        nil,
        Params
    )
end

--// Old Aimbot //
Aimbot.Modules.Aimbot = {
    Running = false,

    LockMethod = "CFrame" :: "CFrame" | "mousemoverel",
    LockPart = nil,

    Sensitivity = 3.5, --/ Mouse move speed
    Smoothness  = 0, --/ Tween duration

    OldMouseSensitivity = shared.UserInputService.MouseDeltaSensitivity,

    CancelLock = function(self)
        if self.LockPart then
            shared.UserInputService.MouseDeltaSensitivity = self.OldMouseSensitivity
        end
        self.LockPart = nil

        Aimbot.Shared.Locked = nil
        EasingLibrary:CancelTween("AimbotTween")
    end,

    GetTarget = function(self)
        local Fov    = Aimbot.Fov
        local Shared = Aimbot.Shared

        local RequiredDistance = Fov.Enabled and Fov.Radius or Shared.MaxDistance

        local function OnIteration(Character: Model, Player: Player?)
            if Shared.CheckCondition(Character) then return end
            local RootPart = Shared.FindRoot(Character)

            local HitChance = NextNumber(Random, 0, 100)
            if HitChance > Shared.HitChance then return end

            local Head           = FindFirstChild(Character, "Head")
            local TargetPart     = NextNumber(Random, 0, 100) <= Shared.HeadshotChance and Head or RootPart
            local TargetPosition = TargetPart.Position

            self.LockPart = TargetPart

            if Shared.WallCheck then
                local Ignored       = {}
                local SelfCharacter = shared.Speaker.Character
                if not SelfCharacter then return end

                local SelfRoot     = Shared.FindRoot(SelfCharacter)
                local SelfPosition = SelfRoot and SelfRoot.Position or SelfCharacter:GetPivot()

                for _, Part in GetDescendants(Character) do
                    if Part == TargetPart or not IsA(Part, "BasePart") then continue end
                    table_insert(Ignored, Part)
                end

                for _, Part in GetDescendants(SelfCharacter) do
                    if not IsA(Part, "BasePart") then continue end
                    table_insert(Ignored, Part)
                end

                if Shared.WallChecker(SelfPosition, TargetPosition, Ignored) then return end
            end

            local Vector, OnScreen, Distance = WorldToViewportPoint(shared.Camera, TargetPosition)

            Vector   = Vector2_new(Vector.X, Vector.Y)
            Distance = (GetMousePosition() - Vector).Magnitude

            if Distance > RequiredDistance or not OnScreen then return end
            Shared.Locked = Player
        end

        if not Shared.Locked then
            if Shared.TargetPlayers then
                for _, Player in GetPlayers(shared.Players) do
                    if Shared.Locked then break end
                    if Player == shared.Speaker then continue end

                    if (Shared.BlacklistMode == "Blacklist") == (table_find(Shared.Blacklist, Player.Name) ~= nil) then continue end
                    if Shared.TeamCheck and Player[Shared.TeamCheckBasedOn] == shared.Speaker[Shared.TeamCheckBasedOn] then continue end

                    local Character = Player.Character
                    OnIteration(Character, Player)
                end
            end

            if not Shared.Locked and Shared.TargetNpcs then
                for _, Npc in NpcHandler.Npcs do
                    OnIteration(Npc, Npc)
                end
            end
        else
            local Character = IsA(Shared.Locked, "Model") and Shared.Locked or Shared.Locked.Character
            local Humanoid  = Character and FindFirstChildOfClass(Character, "Humanoid")
            if not Humanoid or Humanoid.Health <= 0 then
                self:CancelLock()
                return
            end

            local PartPosition = self.LockPart.Position
            local Vector       = WorldToViewportPoint(shared.Camera, PartPosition)
            local Distance     = (GetMousePosition() - Vector2_new(Vector.X, Vector.Y)).Magnitude

            if Distance > RequiredDistance then
                self:CancelLock()
                return
            end
        end
    end
};do
    local self = Aimbot.Modules.Aimbot
    local function OnStep()
        self.Running = Options.AimbotKeyPicker:GetState()

        if Aimbot.Method ~= "Aimbot" or not (self.Running and Aimbot.Enabled) then
            self:CancelLock()
            return
        end

        pcall(self.GetTarget, self)
        if not (Aimbot.Shared.Locked and self.LockPart) then return end

        shared.UserInputService.MouseDeltaSensitivity = 0

        local AimPosition = self.LockPart.Position
        local LookCFrame  = CFrame_new(shared.Camera.CFrame.Position, AimPosition)

        if self.LockMethod == "mousemoverel" then
            local TargetVector = WorldToViewportPoint(shared.Camera, AimPosition)
            mousemoverel(
                (TargetVector.X - GetMousePosition().X) / self.Sensitivity,
                (TargetVector.Y - GetMousePosition().Y) / self.Sensitivity
            )
        elseif self.Smoothness > 0 then
            EasingLibrary:Ease(shared.Camera, "CFrame", LookCFrame, "AimbotTween", self.Smoothness) 
        else
            shared.Camera.CFrame = LookCFrame
        end
    end

    shared.Connect:GiveSignal("AimbotStep", shared.RunService.PreRender:Connect(function()
        pcall(OnStep)
    end))
end

--// Modern Aimbot //
Aimbot.Modules.SilentAim = {
    Running  = false,
    Wallbang = false,

    OldRay      = nil,
    OldNameCall = nil,

    Hooks = {},

    EnabledHooks = {
        FindPartOnRay = true,
        FindPartOnRayWithIgnoreList = true,
        FindPartOnRayWithWhitelist  = true,
        ViewportPointToRay = true,
        ScreenPointToRay   = true,
        Raycast = true,
        Ray     = true
    },

    ProjectileParams = RaycastParams_new(),
    WallbangParams   = RaycastParams_new(),

    LastGet = os_clock(),

    GetEntity = function(self, Settings: {Origin: Vector3, Part: string}): Instance?
        local Fov    = Aimbot.Fov
        local Shared = Aimbot.Shared

        local SelfCharacter = shared.Speaker.Character
        if not SelfCharacter then return nil end

        local SelfRoot      = Shared.FindRoot(SelfCharacter)
        local SelfPosition  = SelfRoot and SelfRoot.Position or SelfCharacter:GetPivot().Position

        local RequiredDistance    = Fov.Enabled and Fov.Radius or Shared.MaxDistance
        local LocationCheckOrigin = Fov.Enabled and GetMousePosition() or SelfPosition

        local SortingTable = {}
        local BestEntity: Instance? = nil

        local function ProcessTarget(Target: any)
            local Character = IsA(Target, "Player") and Target.Character or Target
            if Shared.CheckCondition(Character) then return end

            local TargetRoot = Shared.FindRoot(Character)
            if not TargetRoot then return end

            if IsA(Target, "Player") then
                if (Shared.BlacklistMode == "Blacklist") == (table_find(Shared.Blacklist, Target.Name) ~= nil) then return end
                if Shared.TeamCheck and Target[Shared.TeamCheckBasedOn] == shared.Speaker[Shared.TeamCheckBasedOn] then return end
            end

            local FoundPart    = FindFirstChild(Character, Settings.Part) or TargetRoot
            local PartPosition = FoundPart.Position

            local Magnitude : number
            local IsOnScreen: boolean = true

            if Fov.Enabled then
                local ScreenPosition, OnScreen = WorldToViewportPoint(shared.Camera, PartPosition)
                if not OnScreen then IsOnScreen = false;return end
                Magnitude = (LocationCheckOrigin - Vector2_new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
            else
                Magnitude = (SelfPosition - PartPosition).Magnitude
            end

            if Magnitude <= RequiredDistance and IsOnScreen then
                table_insert(SortingTable, {
                    Entity    = Target,
                    Magnitude = Magnitude,
                    Part      = FoundPart
                })
            end
        end

        if Shared.TargetPlayers then
            for _, Player in GetPlayers(shared.Players) do
                if Player == shared.Speaker then continue end
                ProcessTarget(Player)
            end
        end

        if Shared.TargetNpcs then
            for _, Npc in NpcHandler.Npcs do
                ProcessTarget(Npc)
            end
        end

        table_sort(SortingTable, function(A, B)
            return A.Magnitude < B.Magnitude
        end)

        for _, Data in SortingTable do
            local TargetCharacter = IsA(Data.Entity, "Player") and Data.Entity.Character or Data.Entity
            local TargetPart = Data.Part

            if Shared.WallCheck and not self.Wallbang then
                local Ignored = {SelfCharacter}
                for _, Part in GetDescendants(TargetCharacter) do
                    if IsA(Part, "BasePart") then
                       table_insert(Ignored, Part)
                    end
                end
                if Shared.WallChecker(SelfPosition, TargetPart.Position, Ignored) then continue end
            end

            BestEntity = Data.Entity
            break
        end

        table_clear(SortingTable)
        return BestEntity
    end,

    GetTarget = function(self, Origin: Vector3): (Instance?, BasePart?, Vector3?)
        local Shared = Aimbot.Shared
        if NextNumber(Random, 1, 100) > Shared.HitChance then return end

        local TargetPartName = NextNumber(Random, 1, 100) <= Shared.HeadshotChance and "Head" or "HumanoidRootPart"
        local Entity = self:GetEntity({
            Origin = Origin,
            Part   = TargetPartName
        })

        if not Entity then Shared.Locked = nil; end

        local Character = IsA(Entity, "Player") and Entity.Character or Entity
        local TargetPartInstance = Character and FindFirstChild(Character, TargetPartName) or Shared.FindRoot(Character)

        if not TargetPartInstance then return end

        if Shared.Projectile.Enabled then
            self.ProjectileParams.FilterType     = Enum.RaycastFilterType.Exclude
            self.ProjectileParams.CollisionGroup = TargetPartInstance.CollisionGroup

            self.ProjectileParams.FilterDescendantsInstances = {shared.Speaker.Character, Character}
        end

        Shared.Locked = Entity
        self.LastGet = os_clock()

        return Entity, TargetPartInstance, Origin
    end
};do
    local self   = Aimbot.Modules.SilentAim
    local Shared = Aimbot.Shared

    self.Hooks.ScreenPointToRay = function(Arguments)
        if not (
            self.EnabledHooks.ScreenPointToRay or
            self.EnabledHooks.ViewportPointToRay
        ) then return nil end

        local Entity, TargetPart, Origin = self:GetTarget(shared.Camera.CFrame.Position)
        if not Entity or not TargetPart or not Origin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(Origin, TargetPart, self.ProjectileParams)
            AimPosition = PredictedAimVector or TargetPart.Position
        end

        local LookDirection = CFrame_lookAt(Origin, AimPosition)

        local RayOriginOffset = Arguments[3] and LookDirection.LookVector * Arguments[3] or Vector3_zero
        return {Ray_new(Origin + RayOriginOffset, LookDirection.LookVector)}
    end

    self.Hooks.FindPartOnRay = function(Arguments)
        if not (
            self.EnabledHooks.FindPartOnRayWithIgnoreList or
            self.EnabledHooks.FindPartOnRayWithWhitelist or
            self.EnabledHooks.FindPartOnRay
        ) then return nil end

        local OriginalRay: Ray = Arguments[1]
        local Entity, TargetPart, Origin = self:GetTarget(OriginalRay.Origin)
        if not Entity or not TargetPart or not Origin then return nil end

        if self.Wallbang then
            return {TargetPart, TargetPart.Position, TargetPart.Position, TargetPart.Material}
        end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(Origin, TargetPart, self.ProjectileParams)
            if PredictedAimVector then
                AimPosition = PredictedAimVector
            end
        end

        local LookDirection = CFrame_lookAt(Origin, AimPosition)
        Arguments[1]        = Ray_new(Origin, LookDirection.LookVector * OriginalRay.Direction.Magnitude)
        return nil
    end

    self.Hooks.Raycast = function(Arguments)
        if not self.EnabledHooks.Raycast then return nil end

        local Origin:          Vector3 = Arguments[1]
        local DirectionVector: Vector3 = Arguments[2]
        local Params:    RaycastParams = Arguments[3]

        local Entity, TargetPart, TargetOrigin = self:GetTarget(Origin)
        if not Entity or not TargetPart or not TargetOrigin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(TargetOrigin, TargetPart, self.ProjectileParams)
            AimPosition = PredictedAimVector or TargetPart.Position
        end

        local LookDirection = CFrame_lookAt(TargetOrigin, AimPosition)
        Arguments[2]        = LookDirection.LookVector * DirectionVector.Magnitude

        if self.Wallbang then
            self.WallbangParams.FilterType = Enum.RaycastFilterType.Include
            self.WallbangParams.FilterDescendantsInstances = {TargetPart}

            Arguments[3] = self.WallbangParams
        else
            if not Params then Params = RaycastParams_new() end

            local IgnoreList = Params.FilterDescendantsInstances or {}
            local Character  = IsA(Entity, "Player") and Entity.Character or Entity

            table_insert(IgnoreList, shared.Speaker.Character)
            table_insert(IgnoreList, Character)

            Params.FilterType = Enum.RaycastFilterType.Exclude
            Params.FilterDescendantsInstances = IgnoreList

            Arguments[3] = Params
        end
        return nil
    end

    self.Hooks.Ray = function(Arguments)
        if not self.EnabledHooks.Ray then return nil end

        local Origin:    Vector3 = Arguments[1]
        local Direction: Vector3 = Arguments[2]

        local Entity, TargetPart, TargetOrigin = self:GetTarget(Origin)
        if not Entity or not TargetPart or not TargetOrigin then return nil end

        local AimPosition = TargetPart.Position
        if Shared.Projectile.Enabled then
            local PredictedAimVector = Shared.FastSolve(TargetOrigin, TargetPart, self.ProjectileParams)
            if PredictedAimVector then
                AimPosition = PredictedAimVector
            end
        end

        local LookDirection = CFrame_lookAt(TargetOrigin, AimPosition)
        Arguments[2]        = LookDirection.LookVector * Direction.Magnitude
        return nil
    end

    self.Hooks.FindPartOnRayWithIgnoreList = self.Hooks.FindPartOnRay
    self.Hooks.FindPartOnRayWithWhitelist  = self.Hooks.FindPartOnRay
    self.Hooks.ViewportPointToRay          = self.Hooks.ScreenPointToRay

    self.Start = function(Enabled: boolean)
        self.Running = Enabled
        if Enabled then
            if (
                wax.shared.ExecutorSupport.hookmetamethod and
                wax.shared.ExecutorSupport.getnamecallmethod and
                not self.OldNameCall
            ) then
                self.OldNameCall = hookmetamethod(game, "__namecall", function(Object, ...)
                    local MethodName = getnamecallmethod()
                    if not (
                        not checkcaller() and
                        Aimbot.Enabled and 
                        Aimbot.Method == "SilentAim" and
                        wax.shared.ExecutorSupport.checkcaller and
                        self.EnabledHooks[MethodName] and
                        self.Hooks[MethodName]
                    ) then
                        return self.OldNameCall(Object, ...)
                    end

                    if wax.shared.ExecutorSupport.getcallingscript then
                        local CallingScript = getcallingscript()
                        if table_find({"ControlScript", "ControlModule"}, tostring(CallingScript)) then
                            return self.OldNameCall(Object, ...)
                        end
                    end

                    local Args = {...}
                    local Hook = self.Hooks[MethodName]
                    local Result

                    local Success, Error = pcall(function()
                        Result = Hook(Args)
                    end)

                    if not Success then
                        warn(`[SilentAim Hook Error] {MethodName}: "{Error}"`)
                        return self.OldNameCall(Object, unpack(Args))
                    end

                    if Result then
                        return unpack(Result)
                    else
                        return self.OldNameCall(Object, unpack(Args))
                    end
                end)
            end

            if (wax.shared.ExecutorSupport.hookfunction and not self.OldRay) then
                self.OldRay = hookfunction(Ray_new, function(Origin, Direction)
                    if not (
                        not checkcaller() and
                        Aimbot.Enabled and
                        Aimbot.Method == "SilentAim" and
                        self.EnabledHooks.Ray and
                        wax.shared.ExecutorSupport.checkcaller
                    ) then
                        return self.OldRay(Origin, Direction)
                    end

                    if wax.shared.ExecutorSupport.getcallingscript then
                        local CallingScript = getcallingscript()
                        if table_find({"ControlScript", "ControlModule"}, tostring(CallingScript)) then
                            return self.OldRay(Origin, Direction)
                        end
                    end

                    local Args = {Origin, Direction}
                    local Success, Error = pcall(self.Hooks.Ray, Args)

                    if not Success then
                        warn(`[SilentAim Hook Error] Ray.new: "{Error}"`)
                        return self.OldRay(Origin, Direction)
                    end

                    return self.OldRay(unpack(Args))
                end)
            end
        else
            if self.OldNameCall and wax.shared.ExecutorSupport.hookmetamethod then
                pcall(hookmetamethod, game, "__namecall", self.OldNameCall)
            end

            if self.OldRay and wax.shared.ExecutorSupport.hookfunction then
                pcall(hookfunction, Ray_new, self.OldRay)
            end

            self.OldNameCall = nil
            self.OldRay = nil

            Aimbot.Shared.Locked = nil
        end
    end

    shared.Connect:GiveSignal("LastGetDetection", shared.RunService.Heartbeat:Connect(function()
        if os_clock() - self.LastGet > 0.2 and Aimbot.Method == "SilentAim" and self.Running then
            Shared.Locked = nil
        end
    end))
end

Aimbot.Toggle = function(Enabled: boolean)

end

return Aimbot
