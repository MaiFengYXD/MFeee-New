local game
    = game

local StarterGui = game:GetService("StarterGui")

local function Notify(Title: string, Text: string)
    print(`[MFeee~ New] {Title} {Text}`)

    pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
        Title    = Title,
        Text     = Text,
        Duration = 30,
        Button1  = "Close"
    })

    local Sound = Instance.new("Sound", game:GetService("SoundService"));do
        Sound.SoundId = "rbxassetid://4590657391"
        Sound.Volume  = 2
        Sound.PlayOnRemove = true
    end

    game.Destroy(Sound)
end

local ContentProvider = game:GetService("ContentProvider")
task.spawn(ContentProvider.PreloadAsync, ContentProvider, {"rbxassetid://4590662766"})

local loadstring = loadstring or load
local HttpGet    = HttpGet or HttpGetAsync :: any

if not loadstring then
    return Notify(
        "Loading Stopped!",
        "Error: missing 'loadstring' and 'load' function. Please try to download and execute the latest release"
    )
end

if not (HttpGet or pcall(function()
    local Function = game.HttpGet or game.HttpGetAsync
    assert(type(Function == "function"))

    HttpGet = function(Url: string): string
        return Function(game, Url)
    end
end)) then
    return Notify(
        "Loading Stopped!", 
        "Error: missing 'HttpGet' and 'HttpGetAsync' function. Please try to download and execute the latest release"
    )
end

local Content = HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script-Minified.luau")

if Content == "404: Not Found" then
    Content = HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/Distribution/Script.luau")

    if (Content :: string) == "404: Not Found" then
        Content = HttpGet("https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script-Minified.luau")

        if (Content :: string) == "Not Found" then
            Content = HttpGet("https://github.com/MaiFengYXD/MFeee-New/releases/latest/download/Script.luau")

            if (Content :: string) == "Not Found" then
                return Notify(
                    "Loading Stopped!",
                    "Error: cannot download the script due to \"404: Not Found\""
                )
            end
        end
    end
end

return (loadstring :: Function)(Content)
