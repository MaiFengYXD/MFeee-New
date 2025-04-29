local stringfind,  stringmatch,  stringsub
    = string.find, string.match, string.sub

local makefolder, writefile, isfile, readfile
    = makefolder, writefile, isfile, readfile

local FileHelper = {}

function FileHelper:CheckAPI()
    return not wax.shared.ExecutorSupport.SupportFileSystem
end

function FileHelper:CreateParentFolder(FilePath: string): string?
    if self:CheckAPI() then return nil end

    local Slash      = stringfind(FilePath, "[^/]+$", 1, true)
    local FolderPath = if Slash then stringsub(FilePath, 1, Slash - 2) else FilePath

    makefolder(FolderPath)
    return FolderPath
end

function FileHelper:CreateFolder(Path: string): string?
    if self:CheckAPI() then return nil end

    makefolder(Path)
    return Path
end

function FileHelper:CheckFile(Path: string, Fallback: string, Targets: any): string
    if self:CheckAPI() then return Fallback end
    self:CreateParentFolder(Path)

    local function Return()
        writefile(Path, Fallback)
        return Fallback
    end

    if isfile(Path) then
        local Content    = readfile(Path)
        local TargetType = type(Targets)

        if TargetType == "table" then
            for _, Target in Targets do
                if Content ~= Target then return Return() end
            end
        elseif TargetType == "number" then
            if type(tonumber(Content)) ~= TargetType then return Return() end
        end

        return Content
    end

    return Return()
end

function FileHelper:WriteFile(Path: string, Content: string, DontOverwrite: boolean?): string?
    if self:CheckAPI() then return nil end
    self:CreateParentFolder(Path)

    local LoopedTimes = 1
    local BasePath    = stringmatch(Path, "(.+)%.[^%.]+$")
    local Extension   = stringmatch(Path, "%.([^%.]+)$")

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
