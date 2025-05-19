local makefolder, writefile, isfile, readfile, type, tostring, tonumber, string_match
    = makefolder, writefile, isfile, readfile, type, tostring, tonumber, string.match

local FileHelper = {}

function FileHelper:CheckAPI()
    return not wax.shared.ExecutorSupport.SupportFileSystem
end

function FileHelper:CreateParentFolder(FilePath: string): string?
    if self:CheckAPI() then return nil end

    local FolderPath = FilePath:match("^(.*)/[^/]*$")
    if not FolderPath then return nil end

    makefolder(FolderPath)
    return FolderPath
end

function FileHelper:CreateFolder(Path: string): string?
    if self:CheckAPI() then return nil end

    makefolder(Path)
    return Path
end

function FileHelper:CheckFile(Path: string, Fallback: string, Targets: any): string | number?
    Fallback = tostring(Fallback)

    if self:CheckAPI() then return Fallback end
    self:CreateParentFolder(Path)

    local function Return(type: ("number" | "string")? | any): string | number?
        writefile(Path, Fallback)

        if type == "number" then
            return tonumber(Fallback)
        end

        return Fallback
    end

    local TargetType = type(Targets)

    if isfile(Path) then
        local Content = readfile(Path)

        if TargetType == "table" then
            local Matched

            for Target1, Target2 in Targets do
                if Content ~= Target1 and Content ~= Target2 then continue end

                Matched = Content
                break
            end

            return Matched or Return("string")
        elseif TargetType == "number" then
            if type(tonumber(Content)) ~= TargetType then return Return("number") end

            return tonumber(Content)
        elseif TargetType == "nil" then
            return Content
        end
    end

    return Return(TargetType)
end

function FileHelper:WriteFile(Path: string, Content: string, DontOverwrite: boolean?): string?
    Content = tostring(Content)

    if self:CheckAPI() then return Content end
    self:CreateParentFolder(Path)

    local LoopedTimes = 1
    local BasePath    = string_match(Path, "(.+)%.[^%.]+$")
    local Extension   = string_match(Path, "%.([^%.]+)$")

    while isfile(Path) and DontOverwrite do
        LoopedTimes += 1
        Path = `{BasePath} ({LoopedTimes}).{Extension}`
    end

    writefile(Path, Content)
    return Content
end

function FileHelper:IsFile(Path: string): (boolean | string)
    if self:CheckAPI() then return false end

    if isfile(Path) then
        return readfile(Path)
    end

    return false
end

return FileHelper
