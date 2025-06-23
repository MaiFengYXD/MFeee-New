--!optimize 2

local game, Instance_new
    = game, Instance.new

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

local loadstring = (loadstring or load) :: any
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

for _, Url in {
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script-Minified.luau",
    "https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script-Minified.luau",
    "https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script.luau"
} do
    local Content = HttpGet(Url)

    if Content ~= "404: Not Found" and Content ~= "Not Found" then
        getgenv().HttpGet = HttpGet
        return loadstring(Content)("FromHttpGet")
    end
end

return Notify(
    "Loading Stopped!",
    "Error: cannot download the script due to \"404: Not Found\""
)
