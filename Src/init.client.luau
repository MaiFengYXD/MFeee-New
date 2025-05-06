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

if getgenv().MFeeeLoaded  then Notify("Loading Stopped!", "Error: Already loaded.");return end
if getgenv().MFeeeLoading then Notify("Loading Stopped!", "Error: Loading.")       ;return end

getgenv().MFeeeLoading = true
getgenv().MFeeeLoaded  = false

task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
    "rbxassetid://103134660123798",
    "rbxassetid://77335290652571",
    "rbxassetid://4590662766",
    "rbxassetid://4590657391"
})

if not game:IsLoaded() then game.Loaded:Wait() end

--// Start to Load //
wax.shared.TempStorage = {}

task.spawn(pcall, function()
    wax.shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

shared.Camera = shared.Workspace.CurrentCamera

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

shared.Connect     = require("Utils/Connect")
shared.ToClipboard = type(shared.ToClipboard) == "function" and shared.ToClipboard or function(...) end

wax.shared.AllowedLanguages = {
    ["am"] = "አማርኛ",
    ["ar"] = "العربية",
    ["az"] = "Azərbaycan dili",
    ["de"] = "Deutsch",
    ["en"] = "English",
    ["es"] = "Español",
    ["fa"] = "فارسی",
    ["fr"] = "Français",
    ["hi"] = "हिन्दी",
    ["hr"] = "Hrvatski",
    ["hu"] = "Magyar",
    ["id"] = "Bahasa Indonesia",
    ["ja"] = "日本語",
    ["kz"] = "Қазақ тілі",
    ["ms"] = "Bahasa Melayu",
    ["pt"] = "Português",
    ["ru"] = "Русский язык",
    ["sv"] = "Svenska",
    ["tr"] = "Türkçe",
    ["uk"] = "Українська мова",
    ["ur"] = "اردو",
    ["vi"] = "Tiếng Việt",
    ["zh-cn"  ] = "简体中文",
    ["zh-hant"] = "繁體中文"
}

wax.shared.Language = wax.shared.FileHelper:CheckFile("MFeee~New/Language.txt", "en", wax.shared.AllowedLanguages)

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

wax.shared.Translations  = require("Translations")
wax.shared.EasingLibrary = require("Utils/EasingLibrary")
wax.shared.NpcHandler    = require("Utils/Universal/NPCHandler")

shared.Connect:GiveSignal("CameraChangedSignal" , shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera  = shared.Workspace.CurrentCamera
end))

shared.Connect:GiveSignal("SpeakerChangedSignal", shared.Players  :GetPropertyChangedSignal("LocalPlayer"  ):Connect(function()
    shared.Speaker = shared.Players  .LocalPlayer
end))

--// Loader //
wax.shared.ScriptVersion = "Build 1"

wax.shared.Icons     = require("Utils/Gui/Lucide")
wax.shared.UiManager = require("Utils/Gui/UiManager")
wax.shared.Window    = wax.shared.UiManager:CreateWindow()

require(`Places/Loader/{wax.shared.ScriptFolder}`)

getgenv().MFeeeLoaded  = true
getgenv().MFeeeLoading = false

task.spawn(pcall, function()
    local Version = game:HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/.LatestVersion")
    assert(Version ~= wax.shared.ScriptVersion)

    wax.shared.UiManager:Notify({
        Title       = wax.shared.Translations:GetTranslation("Version Mismatch"),
        Description = wax.shared.Translations:GetTranslation("The script version is outdated, please update it!"),
    })
end)
