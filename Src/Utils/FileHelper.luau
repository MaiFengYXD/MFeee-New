local tonumber, makefolder, writefile, isfolder, isfile, readfile, type, ipairs
    = tonumber, makefolder, writefile, isfolder, isfile, readfile, type, ipairs

local string_match, debug_profilebegin, debug_profileend
    = string.match, debug.profilebegin, debug.profileend

local FileHelper = {
    APIUncompatible = not shared.ExecutorSupport.SupportFileSystem
}

local APIUncompatible = FileHelper.APIUncompatible

function FileHelper:CreateFolder(FolderPath: string): string?
    if APIUncompatible then return nil end
    debug_profilebegin("[File I/O] CreateFolder")

    if not isfolder(FolderPath) then
        makefolder(FolderPath)
    end

    debug_profileend()
    return FolderPath
end

function FileHelper:CreateParentFolder(FilePath: string): string?
    if APIUncompatible then return nil end

    local FolderPath = string_match(FilePath, "^(.*)/[^/]*$")
    if not FolderPath then return nil end

    return self:CreateFolder(FolderPath)
end

function FileHelper:WriteFile(FilePath: string, Content: string, DontOverwrite: boolean?): string?
    if APIUncompatible then return nil end

    Content = `{Content}`
    self:CreateParentFolder(FilePath)

    debug_profilebegin("[File I/O] WriteFile")
    if DontOverwrite then
        local Repeated  = 1
        local BasePath  = string_match(FilePath, "(.+)%.[^%.]+$")
        local Extension = string_match(FilePath, "%.([^%.]+)$")

        while isfile(FilePath) do
            Repeated += 1
            FilePath  = `{BasePath} ({Repeated}).{Extension}`
        end
    end

    writefile(FilePath, Content)

    debug_profileend()
    return Content
end

function FileHelper:IsFile(FilePath: string): boolean | string
    if APIUncompatible then return false end
    debug_profilebegin("[File I/O] IsFile")

    local ReturnValue: boolean | string = false
    if isfile(FilePath) then
        ReturnValue = readfile(FilePath)
    end

    debug_profileend()
    return ReturnValue
end

function FileHelper:CheckFile(FilePath: string, Fallback: string, AllowedTarget: any): (string? | number?, boolean)
    --/ 2nd (boolean) = is file exist

    if APIUncompatible then return nil, false end

    if not self:IsFile(FilePath) then return self:WriteFile(FilePath, Fallback), false end
    debug_profilebegin("[File I/O] CheckFile")

    local Content    = readfile(FilePath)
    local TargetType = type(AllowedTarget)

    if TargetType == "number" then
        local NewContent = tonumber(Content)
        local Value = if type(NewContent) ~= "number" then tonumber(self:WriteFile(FilePath, Fallback)) else NewContent

        debug_profileend()
        return Value, true
    elseif TargetType == "table" then -- TargetType == "array"
        for _, Value in ipairs(AllowedTarget) do
            if Value == Content then
                return Content, true
            end
        end

        debug_profileend()
        return self:WriteFile(FilePath, Fallback), true
    end

    debug_profileend()
    return Content, true
end

return FileHelper
