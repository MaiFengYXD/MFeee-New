local FileHelper = {}

local function CheckAPI()
    return not wax.shared.ExecutorSupport.SupportFileSystem
end

function FileHelper:CreateFolder(Path: string): string?
    if CheckAPI() then return nil end

    makefolder(Path)
    return Path
end

function FileHelper:CheckFile(Path: string, Fallback: string): string?
    if CheckAPI() then return nil end

    if isfile(Path) then
        return readfile(Path)
    end

    writefile(Path, Fallback)
    return Fallback
end

return FileHelper
