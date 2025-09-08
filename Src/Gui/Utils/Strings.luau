local string_gsub, type
    = string.gsub, type

local function Trim(String: any): string
    local Result = string_gsub(string_gsub(`{String}`, "^%s+", ""), "%s+$", "")
    return Result
end

local function ToContentId(Original: string | number): string
    return Original and (
        type(Original) == "number" and `rbxassetid://{Original}` or Original :: string
    ) or ""
end

return {
    Trim = Trim,
    ToContentId = ToContentId
}
