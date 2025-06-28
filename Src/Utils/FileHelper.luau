local string_match, tostring, tonumber, makefolder, writefile, isfolder, isfile, readfile, type
    = string.match, tostring, tonumber, makefolder, writefile, isfolder, isfile, readfile, type

local FileHelper = {
    ApiUncompatible = not shared.ExecutorSupport.SupportFileSystem
}

function FileHelper:CreateFolder(FolderPath: string): string?
    if self.ApiUncompatible then return nil end

    if not isfolder(FolderPath) then
        makefolder(FolderPath)
    end

    return FolderPath
end

function FileHelper:CreateParentFolder(FilePath: string): string?
    if self.ApiUncompatible then return nil end

    local FolderPath = string_match(FilePath, "^(.*)/[^/]*$")
    if not FolderPath then return nil end

    return self:CreateFolder(FolderPath)
end

function FileHelper:WriteFile(FilePath: string, Content: string, DontOverwrite: boolean?): string?
    if self.ApiUncompatible then return nil end

    Content = tostring(Content)
    self:CreateParentFolder(FilePath)

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
    return Content
end

function FileHelper:IsFile(FilePath: string): boolean? | string
    if self.ApiUncompatible then return nil end
    return if isfile(FilePath) then readfile(FilePath) else false
end

function FileHelper:CheckFile(FilePath: string, Fallback: string, Target: any): string? | number?
    if self.ApiUncompatible then return nil end

    if not self:IsFile(FilePath) then return self:WriteFile(FilePath, Fallback) end

    local Content    = readfile(FilePath)
    local TargetType = type(Target)

    if TargetType == "number" then
        local NewContent = tonumber(Content)

        return if type(NewContent) ~= "number" then tonumber(self:WriteFile(FilePath, Fallback)) else NewContent
    elseif TargetType == "table" then
        for Key, Value in Target do
            if Key == Content or Value == Content then
                return Content
            end
        end

        return self:WriteFile(FilePath, Fallback)
    end

    return Content
end

return FileHelper
