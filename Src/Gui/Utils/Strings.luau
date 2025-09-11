local string_gsub, type
    = string.gsub, type

local Strings = {};do
    function Strings.Trim(String: any): string
        local Result = string_gsub(string_gsub(`{String}`, "^%s+", ""), "%s+$", "")
        return Result
    end

    function Strings.ToContentId(Original: string | number): string
        return Original and (
            type(Original) == "number" and `rbxassetid://{Original}` or Original :: string
        ) or ""
    end
end

return Strings
