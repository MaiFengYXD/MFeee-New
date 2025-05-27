local pcall, task
    = pcall, task

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
    "Players",
    "Teams"
})

shared.Speaker = shared.Players.LocalPlayer

if type(getgenv) ~= "function" then
    shared.Speaker:Kick("This script doesn't support non-executor environments.");return
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

if not game:IsLoaded() then game.Loaded:Wait() end

shared.PlayerGui = shared.Speaker:FindFirstChildOfClass("PlayerGui") or (function(IsA, Wait, ChildAdded)
    local PlayerGui

    repeat
        PlayerGui = Wait(ChildAdded)
    until IsA(PlayerGui, "PlayerGui")

    return PlayerGui
end)(game.IsA, game.Close.Wait, shared.Speaker.ChildAdded)

do
    local table_insert, unpack
        = table.insert, unpack

    local OnUnloadFunctions = {} :: {{any}}

    function wax.Unload()
        if wax.Unloaded then return end

        local pcall, task_defer
            = pcall, task.defer

        for _, Bundled in OnUnloadFunctions do
            task_defer(pcall, Bundled[1], unpack(Bundled[2]))
        end
        OnUnloadFunctions = table.clear(OnUnloadFunctions)

        Global.MFeeeLoaded  = false
        Global.MFeeeLoading = false

        wax.Unloaded = true
    end

    function wax.AddOnUnload(Callback: () -> (), ...: any)
        table_insert(OnUnloadFunctions, {(Callback :: any), {...}})
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

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

do
    local utf8_char
        = utf8.char

    local Random      = Random.new()
    local NextInteger = Random.NextInteger

    function Global.randomstring(Length: number | nil): string
        local String = ""

        for _ = 1, Length or NextInteger(Random, 16, 64) do
            String ..= utf8_char(NextInteger(Random, 0, 1114111))
        end

        return String
    end
end

do
    local Color3_fromHSV, tick
        = Color3.fromHSV, tick

    function Global.getrainbowcolor(RainbowSpeed: number | nil): Color3
        return Color3_fromHSV((tick() * (RainbowSpeed or 0.4)) % 1, 1, 1)
    end
end

do
    local ScreenGui = Instance.new("ScreenGui") :: ScreenGui;do
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ResetOnSpawn   = false
        ScreenGui.DisplayOrder   = 2^31 - 1
        ScreenGui.Name           = Global.randomstring()
        ScreenGui.Parent         = Global.gethui()
    end

    wax.shared.ScreenGui = ScreenGui
end

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

do
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

do
    local tonumber, string_match, table_sort
        = tonumber, string.match, table.sort

    function wax.shared.Sequencing(Table: table): table
        table_sort(Table, function(A, B)
            local NumA = tonumber(string_match(A.Name, "^(%d+)%."))
            local NumB = tonumber(string_match(B.Name, "^(%d+)%."))

            return NumA < NumB
        end)

        return Table
    end
end

wax.shared.Translations  = require("Translations")
wax.shared.EasingLibrary = require("Utils/EasingLibrary")

shared.Connect = require("Utils/Connect")

shared.Connect:GiveSignal("CameraChangedSignal" , shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera  = shared.Workspace.CurrentCamera
end))

shared.Connect:GiveSignal("SpeakerChangedSignal", shared.Players  :GetPropertyChangedSignal("LocalPlayer"  ):Connect(function()
    shared.Speaker = shared.Players  .LocalPlayer
end))

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
    local Version   = game:HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")
    assert(Version ~= wax.shared.ScriptVersion and #Version > 0)

    wax.shared.UiManager:Notify({
        Title       = wax.shared.Translations:GetTranslation("Version Mismatch"),
        Description = wax.shared.Translations:GetTranslation("The script version is outdated, please update it!"),
        Time        = 15
    })
end)
