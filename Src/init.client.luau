local pcall, task
    = pcall, task

if type(getgenv) ~= "function" then
    task.spawn(error, "This script only supports exploit environments.")
    return
elseif not game:IsLoaded() then
    game.Loaded:Wait()
    task.wait(1)
end

wax.Unloaded = false

--// Pre-Checks //
require("@self/Utils/Services"):GetServices({
    "ContextActionService",
    "MarketplaceService",
    "CollectionService",
    "ReplicatedStorage",
    "UserInputService",
    "ContentProvider",
    "SoundService",
    "TweenService",
    "TextService",
    "HttpService",
    "StarterGui",
    "RunService",
    "Workspace",
    "Lighting",
    "Players",
    "Teams"
})

shared.Speaker = shared.Players.LocalPlayer

if shared.Workspace.DistributedGameTime < 1 then
    task.wait(1 - shared.Workspace.DistributedGameTime)
end

local Global = getgenv()
wax.Global   = Global

local function Notify(Title: string, Text: string)
    print(`[MFeee~ New] {Title} {Text}`)

    shared.StarterGui:SetCore("SendNotification", {
        Title    = Title,
        Text     = Text,
        Button1  = "Close",
        Duration = 15
    })
end

shared.MiniNotify = Notify

if Global.MFeeeLoaded  then Notify("Loading Stopped!", "Error: already loaded.") ;return end
if Global.MFeeeLoading then Notify("Loading Stopped!", "Error: already loading.");return end

Global.MFeeeLoading = true
Global.MFeeeLoaded  = false

if not Global.HttpGet then
    local HttpGet = secret_get or HttpGet or HttpGetAsync
    if not HttpGet then
        pcall(function(game)
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
        end, game)
    end

    Global.HttpGet = HttpGet
end

task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
    "rbxassetid://103134660123798",
    "rbxassetid://77335290652571",
    "rbxassetid://4590662766",
    "rbxassetid://4590657391"
})

shared.PlayerGui = shared.Speaker:FindFirstChildOfClass("PlayerGui") or (function(IsA, Wait, ChildAdded)
    local PlayerGui

    repeat
        PlayerGui = Wait(ChildAdded)
    until IsA(PlayerGui, "PlayerGui")

    return PlayerGui
end)(game.IsA, game.Close.Wait, shared.Speaker.ChildAdded)

shared.Emoji           = require("@self/Utils/ArtEmoji")
shared.ExecutorSupport = require("@self/Utils/ExecutorSupport")
shared.FileHelper      = require("@self/Utils/FileHelper")

require("@self/Utils/Bypass")

do
    local table_insert, table_clear, unpack
        = table.insert, table.clear, unpack

    local OnUnloadFunctions = {} :: {{any}}

    function wax.Unload()
        if wax.Unloaded then return end

        local pcall, task_spawn
            = pcall, task.spawn

        for _, Bundled in OnUnloadFunctions do
            task_spawn(pcall, Bundled[1], unpack(Bundled[2]))
        end
        OnUnloadFunctions = table_clear(OnUnloadFunctions)

        Global.MFeeeLoaded  = false
        Global.MFeeeLoading = false

        wax.Unloaded = true
    end

    function wax.AddOnUnload(Callback: () -> (), ...: any)
        table_insert(OnUnloadFunctions, {(Callback :: any), {...}})
    end

    local utf8_char
        = utf8.char

    local Random      = Random.new()
    local NextInteger = Random.NextInteger

    function Global.randomstring(Length: number | nil): string
        local utf8_char, Random, NextInteger
            = utf8_char, Random, NextInteger

        local String = ""

        for _ = 1, Length or NextInteger(Random, 16, 64) do
            String ..= utf8_char(NextInteger(Random, 0, 1114111))
        end

        return String
    end

    local Color3_fromHSV, tick
        = Color3.fromHSV, tick

    function Global.getrainbowcolor(RainbowSpeed: number | nil): Color3
        return Color3_fromHSV((tick() * (RainbowSpeed or 0.4)) % 1, 1, 1)
    end

    local ScreenGui = Instance.new("ScreenGui");do
        ScreenGui.ZIndexBehavior       = Enum.ZIndexBehavior.Sibling
        ScreenGui.ClipToDeviceSafeArea = false
        ScreenGui.IgnoreGuiInset       = true
        ScreenGui.ResetOnSpawn         = false
        ScreenGui.AutoLocalize         = false
        ScreenGui.DisplayOrder         = 2^31 - 1
        ScreenGui.Name                 = Global.randomstring()
        ScreenGui.Parent               = Global.gethui()
    end

    shared.ScreenGui = ScreenGui

    local tonumber, string_match, table_sort
        = tonumber, string.match, table.sort

    function shared.Sequencing(Table: table): table
        local tonumber, string_match
            = tonumber, string_match

        table_sort(Table, function(A, B)
            local NumA = tonumber(string_match(A.Name, "^(%d+)%."))
            local NumB = tonumber(string_match(B.Name, "^(%d+)%."))

            return NumA < NumB
        end)

        return Table
    end

    local type
        = type

    function shared.Validate(Target: table, Template: table): table
        if type(Target) ~= "table" then
            return Template
        end

        for Key, Value in Template do
            if Target[Key] == nil then
                Target[Key] = Value
            end
        end

        return Target
    end

    local DeviceTypes = {
        Mobile = {
            "IOS",
            "Android",
            "Ouya",
            "Chromecast",
            "MetaOS"
        },

        Desktop = {
            "AndroidTV",
            "Windows",
            "OSX",
            "Linux",
            "SteamOS",
            "DOS",
            "BeOS",
            "UWP",
            "XBoxOne",
            "PS4",
            "PS3",
            "XBox360",
            "WiiU",
            "NX",
            "WebOS",
            "PS5",
            "None"
        }
    }

    local Platform = shared.UserInputService:GetPlatform().Name

    for Type, OSList in DeviceTypes :: hash do
        for _, OS in OSList do
            if OS ~= Platform then continue end

            shared.DeviceType = Type
            break
        end
    end

    shared.ScriptName    = "Universal"
    shared.ScriptFolder  = "Universal"
    shared.ScriptDisplay = "Universal"

    local Mappings = require("@self/Mappings")
    local Mapping  = Mappings[game.PlaceId]

    if Mapping then
        shared.ScriptName    = Mapping.Name
        shared.ScriptFolder  = Mapping.Folder
        shared.ScriptDisplay = Mapping.Display
    end
end

--// Start to Load //
shared.TempStorage = {}

task.spawn(function()
    while not (pcall(function()
        shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
    end) and shared.GameName) and task.wait(0.5) do end
end)

shared.Camera = shared.Workspace.CurrentCamera

shared.AllowedLanguages = {
    -- ["am"] = "አማርኛ",
    -- ["ar"] = "العربية",
    -- ["az"] = "Azərbaycan dili",
    -- ["de"] = "Deutsch",
    ["en"] = "English",
    ["es"] = "Español",
    -- ["et"] = "Eesti",
    -- ["fa"] = "فارسی",
    -- ["fr"] = "Français",
    -- ["hi"] = "हिन्दी",
    -- ["hr"] = "Hrvatski",
    -- ["hu"] = "Magyar",
    -- ["id"] = "Bahasa Indonesia",
    ["ja"] = "日本語",
    -- ["kz"] = "Қазақ тілі",
    -- ["ms"] = "Bahasa Melayu",
    -- ["pt"] = "Português",
    ["ru"] = "Русский язык",
    -- ["sv"] = "Svenska",
    -- ["tr"] = "Türkçe",
    -- ["uk"] = "Українська мова",
    -- ["ur"] = "اردو",
    -- ["vi"] = "Tiếng Việt",
    ["zh-cn"  ] = "简体中文",
    ["zh-hant"] = "繁體中文"
}

shared.Language = shared.FileHelper:CheckFile("MFeee-New/Language.txt", "en", shared.AllowedLanguages)

shared.Translations  = require("@self/Translations")
shared.EasingLibrary = require("@self/Utils/EasingLibrary")

shared.Connect = require("@self/Utils/Connect")

shared.Connect:GiveSignal(nil, shared.Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    shared.Camera = shared.Workspace.CurrentCamera
end)

shared.Connect:GiveSignal(nil, shared.Players:GetPropertyChangedSignal("LocalPlayer"), function()
    shared.Speaker = shared.Players.LocalPlayer
end)

--// Loader //
shared.ScriptVersion = "Build 1"

shared.UIManager = require("@self/Gui/UIManager")
shared.Window    = shared.UIManager:Init()

require(`@self/Places/Loader/{shared.ScriptFolder}`)

shared.UIManager:AddUniversalTabs()

shared.UIManager.SaveManager :LoadAutoloadConfig()
shared.UIManager.ThemeManager:LoadDefault()

Global.MFeeeLoaded  = true
Global.MFeeeLoading = false

task.spawn(pcall, function()
    assert(wax.argument[1] ~= "FromHttpGet")

    local Version   = Global.HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")
    assert(Version ~= shared.ScriptVersion and #Version > 0 and not string.find(Version, ":"))

    shared.UIManager:Notify({
        Title       = shared.Translations.GetTranslation("Version Mismatch"),
        Description = shared.Translations.GetTranslation("The script version is outdated, please update it!"),
        Time        = 15
    })
end)

task.spawn(pcall, function()
    assert(shared.BypassedMethod)

    shared.UIManager:Notify({
        Title       = shared.Translations.GetTranslation("Bypassed Anticheat"),
        Description = string.format(shared.Translations.GetTranslation("MFeee~ New has bypassed %s anti-hook anti-cheat"), shared.BypassedMethod),
        Time        = 4
    })
end)
