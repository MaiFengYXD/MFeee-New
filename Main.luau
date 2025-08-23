--!optimize 2

local game, Instance_new, type
    = game, Instance.new, type

local function GetFunction(Function: any)
    return type(Function) == "function" and Function
end

if not GetFunction(getgenv) then
    return error("This script only supports exploit environments.") :: nil
end

local cloneref = (GetFunction(cloneref) or GetFunction(clonereference) or function(Object: Instance)
    return Object
end) :: any

local StarterGui   = cloneref(game:GetService("StarterGui"))
local GuiService   = cloneref(game:GetService("GuiService"))
local SoundService = cloneref(game:GetService("SoundService"))

local setthreadidentity = GetFunction(setthreadidentity)

local function Notify(Title: string, Text: string)
    print(`[MFeee~ New] {Title} {Text}`)

    local function Alert()
        local Sound = Instance_new("Sound", SoundService);do
            Sound.SoundId      = "rbxassetid://4590662766"
            Sound.Volume       = 2
            Sound.PlayOnRemove = true
        end

        Sound:Destroy()
    end

    if (
        setthreadidentity and (
            pcall(setthreadidentity, 8) and
            pcall(GuiService.SendNotification, GuiService, {
                Title = Title,
                Text  = Text
            })
        ) or
        pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
            Title    = Title,
            Text     = Text,
            Duration = 15,
            Button1  = "Close"
        })
    ) then
        Alert()
    end
end

local ContentProvider = cloneref(game:GetService("ContentProvider"))
task.spawn(ContentProvider.PreloadAsync, ContentProvider, {"rbxassetid://4590662766"})

local loadstring = (GetFunction(loadstring) or GetFunction(load)) :: any
local HttpGet    = (GetFunction(secret_get) or GetFunction(HttpGet) or GetFunction(HttpGetAsync)) :: any

if not loadstring then
    return Notify(
        "Loading Stopped!",
        "Error: missing 'loadstring' function. Please try to download and execute the latest release"
    )
end

if not (HttpGet or pcall(function(game)
    local function Find(self, Key: string): any
        local Success, Result = pcall(function(self, Key)
            return self[Key]
        end, self, Key)

        return Success and type(Result) == "function" and Result or nil
    end

    local Function = Find(game, "secret_get") or Find(game, "HttpGet") or Find(game, "HttpGetAsync")
    assert(Function)

    HttpGet = function(Url: string): string
        return Function(game, Url)
    end
end, game)) then
    return Notify(
        "Loading Stopped!", 
        "Error: missing 'HttpGet' function. Please try to download and execute the latest release"
    )
end

local makefolder = GetFunction(makefolder)
local writefile  = GetFunction(writefile)
local isfolder   = GetFunction(isfolder)
local isfile     = GetFunction(isfile)

local readfile = GetFunction(readfile)
local loadfile = (GetFunction(loadfile) or (readfile and function(Path: string): Function
    return loadstring(readfile(Path))
end)) :: any

local function LoadScript(Source: string)
    if makefolder and writefile then
        if not isfolder or not isfolder("MFeee-New") then
            makefolder("MFeee-New")
        end

        writefile("MFeee-New/Cached.luau", Source)
    end

    return loadstring(Source)("FromHttpGet")
end

local request = (
    GetFunction(request) or
    GetFunction(http_request) or
    http and GetFunction(http.request) or
    syn and GetFunction(syn.request) or
    fluxus and GetFunction(fluxus.request)
) :: any

local Urls = {
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script-Minified.luau",
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script-Minified.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script.luau"
}

local DownloadFile = (if type(request) == "function" then
    function(Url: string): (any, any)
        local Response = request({Url = Url, Method = "GET"})
        local Status   = Response.StatusCode

        if Status == 200 or Status == 304 then
            return Response.Body, Status
        end

        return true, Status
    end
else
    function(Url: string): (any, any)
        local Content = HttpGet(Url)
        if Content == "404: Not Found" or Content == "Not Found" then return true, 404 end

        return Content, 200
    end) :: (string) -> (any, any)

local CurrentVersion = DownloadFile("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")

if (
    isfile and readfile and
    isfile("MFeee-New/Cached.luau") and
    isfile("MFeee-New/Cached-Version") and
    readfile("MFeee-New/Cached-Version") == CurrentVersion
) then
    local Success, Cached = pcall(loadfile, "MFeee-New/Cached.luau")
    if Success and GetFunction(Cached) then return Cached("FromHttpGet") end

    local delfile = GetFunction(delfile)

    if delfile then
        delfile("MFeee-New/Cached.luau")
        delfile("MFeee-New/Cached-Version")
    end
elseif CurrentVersion ~= true and isfolder and writefile then
    if not isfolder("MFeee-New") then
        makefolder("MFeee-New")
    end

    writefile("MFeee-New/Cached-Version", CurrentVersion)
end

local StatusCode

for _, Url in Urls do
    local FailedOrContent, Status = DownloadFile(Url)
    StatusCode = Status

    if FailedOrContent == true then continue end
    return LoadScript(FailedOrContent)
end

return Notify(
    "Loading Stopped!",
    `Error: cannot download the script due to Http error: {StatusCode}`
)
