local Black = Color3.new()
local White = Color3.new(1, 1, 1)

local Lerp = Black.Lerp

local Colors = {};do
    function Colors.GetDarkerColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, Black, Alpha or 0.5)
    end

    function Colors.GetBrighterColor(Original: Color3, Alpha: number?): Color3
        return Lerp(Original, White, Alpha or 0.5)
    end
end

return Colors
