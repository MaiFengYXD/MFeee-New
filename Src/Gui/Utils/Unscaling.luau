local Library = shared.Gui.Library

local Unscaling = {};do
    function Unscaling.GetUnscaledTextBounds(TextElement: TextLabel | TextButton, Latitude: ("X" | "Y")?): Vector2 | number
        local TextBounds = TextElement.TextBounds / Library.DPIScale

        return (
            Latitude == "X" and TextBounds.X or
            Latitude == "Y" and TextBounds.Y or
            TextBounds
        )
    end

    function Unscaling.GetUnscaledContentSize(UIListLayout: UIListLayout, Latitude: ("X" | "Y")?): Vector2 | number
        local ContentSize = UIListLayout.AbsoluteContentSize / Library.DPIScale

        return (
            Latitude == "X" and ContentSize.X or
            Latitude == "Y" and ContentSize.Y or
            ContentSize
        )
    end
end

return Unscaling
