--!optimize 2

local game, Instance_new, type
    = game, Instance.new, type

if type(getgenv) ~= "function" then
    return game:GetService("Players").LocalPlayer:Kick("This script only supports exploit environments.")
end

local StarterGui   = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local function Notify(Title: string, Text: string)
    print(`[MFeee~ New] {Title} {Text}`)

    pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
        Title    = Title,
        Text     = Text,
        Duration = 30,
        Button1  = "Close"
    })

    local Sound = Instance_new("Sound", SoundService);do
        Sound.SoundId = "rbxassetid://4590657391"
        Sound.Volume  = 2
        Sound.PlayOnRemove = true
    end

    Sound.Destroy(Sound)
end

local ContentProvider = game:GetService("ContentProvider")
task.spawn(ContentProvider.PreloadAsync, ContentProvider, {"rbxassetid://4590662766"})

local loadstring = (loadstring or load) :: (string) -> Function
local HttpGet    = (secret_get or HttpGet or HttpGetAsync) :: any

if not loadstring then
    return Notify(
        "Loading Stopped!",
        "Error: missing 'loadstring' function. Please try to download and execute the latest release"
    )
end

if not (HttpGet or pcall(function(game)
    local function __index(self, Key: string): any
        local Success, Result = pcall(function(self, Key)
            return self[Key]
        end, self, Key)

        return Success and Result or nil
    end

    local Function = __index(game, "secret_get") or __index(game, "HttpGet") or __index(game, "HttpGetAsync")
    assert(type(Function == "function"))

    HttpGet = function(Url: string): string
        return Function(game, Url)
    end
end, game)) then
    return Notify(
        "Loading Stopped!", 
        "Error: missing 'HttpGet' function. Please try to download and execute the latest release"
    )
end

local request = (request or http_request or http.request or syn.request or fluxus.request) :: typeof(request)
local Urls = {
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script-Minified.luau",
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script-Minified.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script.luau"
}

if type(request) == "function" then
    local StatusCode

    for _, Url in Urls do
        local Response = request({Url = Url})
        local Status   = Response.StatusCode

        if Status == 200 or Status == 304 then
            return loadstring(Response.Body)("FromHttpGet")
        end

        StatusCode = Status
    end

    return Notify(
        "Loading Stopped!",
        `Error: cannot download the script due to Http error "{StatusCode}"`
    )
end

for _, Url in Urls do
    local Content = HttpGet(Url)
    if Content == "404: Not Found" or Content == "Not Found" then continue end

    getgenv().HttpGet = HttpGet
    return loadstring(Content)("FromHttpGet")
end

return Notify(
    "Loading Stopped!",
    "Error: cannot download the script due to \"404: Not Found\" and Http error"
)
