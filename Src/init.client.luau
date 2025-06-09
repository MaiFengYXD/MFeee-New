local pcall, task
    = pcall, task

if not game:IsLoaded() then
    game.Loaded:Wait()
    task.wait(1)
end

wax.Unloaded = false

--// Pre-Checks //
require("Utils/Services"):GetServices({
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

if type(getgenv) ~= "function" then
    shared.Speaker:Kick("This script doesn't support non-executor environments.");return
elseif shared.Workspace.DistributedGameTime < 1 then
    task.wait(1 - shared.Workspace.DistributedGameTime)
end

local Global = getgenv()

local function Notify(Title: string, Text: string)
    print(`[MFeee~ New] {Title} {Text}`)

    shared.StarterGui:SetCore("SendNotification", {
        Title    = Title,
        Text     = Text,
        Button1  = "Close",
        Duration = 30
    })
end

wax.shared.MiniNotify = Notify

if Global.MFeeeLoaded  then Notify("Loading Stopped!", "Error: already loaded.") ;return end
if Global.MFeeeLoading then Notify("Loading Stopped!", "Error: already loading.");return end

Global.MFeeeLoading = true
Global.MFeeeLoaded  = false

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

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

do
    local table_insert, table_clear, unpack
        = table.insert, table.clear, unpack

    local OnUnloadFunctions = {} :: {{any}}

    function wax.Unload()
        if wax.Unloaded then return end

        local pcall, task_defer
            = pcall, task.defer

        for _, Bundled in OnUnloadFunctions do
            task_defer(pcall, Bundled[1], unpack(Bundled[2]))
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

    wax.shared.ScreenGui = ScreenGui

    local tonumber, string_match, table_sort
        = tonumber, string.match, table.sort

    function wax.shared.Sequencing(Table: table): table
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

    function wax.shared.Validate(Target: table, Template: table): table
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

            wax.shared.DeviceType = Type
            break
        end
    end

    wax.shared.ScriptName    = "Universal"
    wax.shared.ScriptFolder  = "Universal"
    wax.shared.ScriptDisplay = "Universal"

    local Mappings = require("Mappings")
    local Mapping  = Mappings[game.PlaceId]

    if Mapping then
        wax.shared.ScriptName    = Mapping.Name
        wax.shared.ScriptFolder  = Mapping.Folder
        wax.shared.ScriptDisplay = Mapping.Display
    end
end

--// Start to Load //
wax.shared.TempStorage = {}

task.spawn(function()
    while not (pcall(function()
        wax.shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
    end) and wax.shared.GameName) and task.wait(0.5) do end
end)

shared.Camera = shared.Workspace.CurrentCamera

wax.shared.AllowedLanguages = {
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

wax.shared.Language = wax.shared.FileHelper:CheckFile("MFeee-New/Language.txt", "en", wax.shared.AllowedLanguages)

wax.shared.Translations  = require("Translations")
wax.shared.EasingLibrary = require("Utils/EasingLibrary")

shared.Connect = require("Utils/Connect")

shared.Connect:GiveSignal(nil, shared.Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    shared.Camera = shared.Workspace.CurrentCamera
end)

shared.Connect:GiveSignal(nil, shared.Players:GetPropertyChangedSignal("LocalPlayer"), function()
    shared.Speaker = shared.Players.LocalPlayer
end)

--// Loader //
wax.shared.ScriptVersion = "Build 1"

wax.shared.UiManager = require("Utils/Gui/UIManager")
wax.shared.Window    = wax.shared.UiManager:CreateWindow()

require(`Places/Loader/{wax.shared.ScriptFolder}`)

wax.shared.UiManager:CreateUniversalTabs()

wax.shared.UiManager.SaveManager :LoadAutoloadConfig()
wax.shared.UiManager.ThemeManager:LoadDefault()

Global.MFeeeLoaded  = true
Global.MFeeeLoading = false

task.spawn(pcall, function()
    assert(wax.shared.argument ~= "FromHttpGet")

    local Version   = game:HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")
    assert(Version ~= wax.shared.ScriptVersion and #Version > 0 and not string.find(Version, ":"))

    wax.shared.UiManager:Notify({
        Title       = wax.shared.Translations.GetTranslation("Version Mismatch"),
        Description = wax.shared.Translations.GetTranslation("The script version is outdated, please update it!"),
        Time        = 15
    })
end)

task.spawn(pcall, function()
    if wax.shared.BypassedMethod then
        wax.shared.UiManager:Notify({
            Title       = wax.shared.Translations.GetTranslation("Bypassed Anticheat"),
            Description = string.format(wax.shared.Translations.GetTranslation("MFeee~ New has bypassed %s anti-hook anti-cheat"), wax.shared.BypassedMethod),
            Time        = 4
        })
    end
end)
