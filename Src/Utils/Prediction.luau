--[[
Source: https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
Thank you NOVEIGMA, I successfully used it on Aimbot! ^^
--]]

local math_pow, math_abs, math_sqrt, math_acos, math_cos, math_pi
    = math.pow, math.abs, math.sqrt, math.acos, math.cos, math.pi

local unpack, Vector3_new, table_insert
    = unpack, Vector3.new, table.insert

local Workspace = shared.Workspace
local Raycast   = Workspace.Raycast

local Prediction = {}

local function IsZero(Value)
    return (Value > -1e-9) and (Value < 1e-9)
end

local function CubeRoot(Value)
    return (Value > 0) and math_pow(Value, 1/3) or -math_pow(math_abs(Value), 1/3)
end

local function SolveQuadratic(Coeff0, Coeff1, Coeff2)
    local Root1, Root2
    local NormalizedP  = Coeff1 / (2 * Coeff0)
    local NormalizedQ  = Coeff2 / Coeff0
    local Discriminant = NormalizedP * NormalizedP - NormalizedQ

    if IsZero(Discriminant) then
        return -NormalizedP
    elseif Discriminant < 0 then
        return
    else --/ if (Discriminant > 0) then
        local SqrtDiscriminant = math_sqrt(Discriminant)
        Root1 =  SqrtDiscriminant - NormalizedP
        Root2 = -SqrtDiscriminant - NormalizedP

        return Root1, Root2
    end
end

local function SolveCubic(Coeff0, Coeff1, Coeff2, Coeff3)
    local Root1, Root2, Root3, RootCount

    local NormalizedA = Coeff1 / Coeff0
    local NormalizedB = Coeff2 / Coeff0
    local NormalizedC = Coeff3 / Coeff0

    local SquaredA = NormalizedA * NormalizedA

    local IntermediateP = (1/3) * (- (1/3) * SquaredA + NormalizedB)
    local IntermediateQ = 0.5 * ((2/27) * NormalizedA * SquaredA - (1/3) * NormalizedA * NormalizedB + NormalizedC)

    local CubedP = IntermediateP * IntermediateP * IntermediateP
    local Discriminant = IntermediateQ * IntermediateQ + CubedP

    if IsZero(Discriminant) then
        if IsZero(IntermediateQ) then --/ One triple solution
            Root1 = 0
            RootCount = 1
        else --/ One single and one double solution
            local CubeRootTerm = CubeRoot(-IntermediateQ)

            Root1 = 2 * CubeRootTerm
            Root2 = -CubeRootTerm
            RootCount = 2
        end
    elseif Discriminant < 0 then --/ Casus irreducibilis: three real solutions
        local AnglePhi = (1/3) * math_acos(-IntermediateQ / math_sqrt(-CubedP))
        local TrigScale = 2 * math_sqrt(-IntermediateP)

        Root1 =  TrigScale * math_cos(AnglePhi)
        Root2 = -TrigScale * math_cos(AnglePhi + math_pi/3)
        Root3 = -TrigScale * math_cos(AnglePhi - math_pi/3)

        RootCount = 3
    else --/ One real solution
        local SqrtDiscriminant = math_sqrt(Discriminant)
        local CubeRootU =  CubeRoot(SqrtDiscriminant - IntermediateQ)
        local CubeRootV = -CubeRoot(SqrtDiscriminant + IntermediateQ)

        Root1 = CubeRootU + CubeRootV
        RootCount = 1
    end

    local Adjustment = (1/3) * NormalizedA

    if RootCount > 0 then Root1 -= Adjustment end
    if RootCount > 1 then Root2 -= Adjustment end
    if RootCount > 2 then Root3 -= Adjustment end

    return Root1, Root2, Root3
end

function Prediction.SolveQuartic(Coeff0, Coeff1, Coeff2, Coeff3, Coeff4)
    local Roots, Coefficients = {}, {}
    local IntermediateZ, SqrtU, SqrtV, Adjustment, RootCount

    local NormalizedA = Coeff1 / Coeff0
    local NormalizedB = Coeff2 / Coeff0
    local NormalizedC = Coeff3 / Coeff0
    local NormalizedD = Coeff4 / Coeff0

    local SquaredA = NormalizedA * NormalizedA

    local QuarticP = -0.375 * SquaredA + NormalizedB
    local QuarticQ =  0.125 * SquaredA * NormalizedA - 0.5 * NormalizedA * NormalizedB + NormalizedC
    local QuarticR = (
        -(3/256) * SquaredA * SquaredA +
        0.0625 * SquaredA * NormalizedB -
        0.25 * NormalizedA * NormalizedC +
        NormalizedD
    )

    if IsZero(QuarticR) then
        Coefficients[3] = QuarticQ
        Coefficients[2] = QuarticP
        Coefficients[1] = 0
        Coefficients[0] = 1

        local CubicResults = {SolveCubic(Coefficients[0], Coefficients[1], Coefficients[2], Coefficients[3])}
        RootCount = #CubicResults
        Roots[1], Roots[2], Roots[3] = CubicResults[1], CubicResults[2], CubicResults[3]
    else
        Coefficients[3] = 0.5 * QuarticR * QuarticP - 0.125 * QuarticQ * QuarticQ
        Coefficients[2] = -QuarticR
        Coefficients[1] = -0.5 * QuarticP
        Coefficients[0] = 1

        Roots[1], Roots[2], Roots[3] = SolveCubic(Coefficients[0], Coefficients[1], Coefficients[2], Coefficients[3])
        IntermediateZ = Roots[1]

        local UTerm = IntermediateZ * IntermediateZ - QuarticR
        local VTerm = 2 * IntermediateZ - QuarticP

        SqrtU = if (UTerm > 0) then math_sqrt(UTerm) else (if IsZero(UTerm) then 0 else nil)
        SqrtV = if (VTerm > 0) then math_sqrt(VTerm) else (if IsZero(VTerm) then 0 else nil)

        if SqrtU and SqrtV then
            Coefficients[2] = IntermediateZ - SqrtU
            Coefficients[1] = (QuarticQ < 0) and -SqrtV or SqrtV
            Coefficients[0] = 1

            local QuadResults = {SolveQuadratic(Coefficients[0], Coefficients[1], Coefficients[2])}

            RootCount = #QuadResults
            Roots[1], Roots[2] = QuadResults[1], QuadResults[2]

            Coefficients[2] = IntermediateZ + SqrtU
            Coefficients[1] = (QuarticQ < 0) and SqrtV or -SqrtV

            if RootCount == 0 or RootCount == 1 or RootCount == 2 then
                QuadResults = {SolveQuadratic(Coefficients[0], Coefficients[1], Coefficients[2])}
                RootCount += #QuadResults
            end

            if RootCount == 0 then
                Roots[1], Roots[2] = QuadResults[1], QuadResults[2]
            elseif RootCount == 1 then
                Roots[2], Roots[3] = QuadResults[1], QuadResults[2]
            elseif RootCount == 2 then
                Roots[3], Roots[4] = QuadResults[1], QuadResults[2]
            end
        end
    end
    Adjustment = 0.25 * NormalizedA

    for Index = 1, RootCount do
        Roots[Index] -= Adjustment
    end
    return Roots
end

function Prediction.SolveTrajectory(
    Origin         : Vector3, ProjectileSpeed : number, Gravity        : number,
    TargetPosition : Vector3, TargetVelocity  : Vector3,
    PlayerGravity  : number?, PlayerHeight    : number?, RaycastParams : RaycastParams?
)
    local Displacement = TargetPosition - Origin
    local TargetVelX, TargetVelY, TargetVelZ = TargetVelocity.X, TargetVelocity.Y, TargetVelocity.Z
    local DispX, DispY, DispZ = Displacement.X, Displacement.Y, Displacement.Z
    local GravityFactor = -0.5 * Gravity

    --/ Attempt gravity calculation, may return to it in the future.
    if math_abs(TargetVelY) > 0.01 and PlayerGravity and PlayerGravity > 0 then
        local EstimatedTime = Displacement.Magnitude / ProjectileSpeed
        TargetVelY -= 0.5 * PlayerGravity * EstimatedTime

        local VelocityStep = TargetVelocity * 0.016
        local RayResult = Raycast(Workspace, TargetPosition, Vector3_new(
            VelocityStep.X,
            (TargetVelY * EstimatedTime) - PlayerHeight, VelocityStep.Z),
            RaycastParams
        )

        if RayResult then
            local NewTarget = RayResult.Position + Vector3_new(0, PlayerHeight, 0)

            EstimatedTime -= math_sqrt(((TargetPosition - NewTarget).Magnitude * 2) / PlayerGravity)
            TargetPosition = NewTarget
            DispY = (TargetPosition - Origin).Y
            TargetVelY = 0
        end
    end

    local QuarticCoeffs = {
        GravityFactor * GravityFactor,
        -2 * TargetVelY * GravityFactor,
        TargetVelY^2 - 2 * DispY * GravityFactor - ProjectileSpeed^2 + TargetVelX^2 + TargetVelZ^2,
        2 * DispY * TargetVelY + 2 * DispX * TargetVelX + 2 * DispZ * TargetVelZ,
        DispY^2 + DispX^2 + DispZ^2
    }

    local SolutionRoots = Prediction.SolveQuartic(unpack(QuarticCoeffs))

    if SolutionRoots then
        local PositiveRoots = {}

        for _, Root in SolutionRoots do --/ Filter out the negative roots
            if Root > 0 then table_insert(PositiveRoots, Root) end
        end

        if #PositiveRoots > 0 then
            local Time = PositiveRoots[1]

            local DeltaX = (DispX + TargetVelX * Time) / Time
            local DeltaY = (DispY + TargetVelY * Time - GravityFactor * Time^2) / Time
            local DeltaZ = (DispZ + TargetVelZ * Time) / Time

            return Origin + Vector3_new(DeltaX, DeltaY, DeltaZ)
        end
    elseif Gravity == 0 then
        local Time = Displacement.Magnitude / ProjectileSpeed

        local DeltaX = (DispX + TargetVelX * Time) / Time
        local DeltaY = (DispY + TargetVelY * Time - GravityFactor * Time^2) / Time
        local DeltaZ = (DispZ + TargetVelZ * Time) / Time

        return Origin + Vector3_new(DeltaX, DeltaY, DeltaZ)
    end
    return nil
end

return Prediction
