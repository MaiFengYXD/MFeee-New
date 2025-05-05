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

getgenv().MFeeeLoaded  = false
getgenv().MFeeeLoading = true

task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
    "rbxassetid://77335290652571",
    "rbxassetid://4590662766",
    "rbxassetid://4590657391"
})

if not game:IsLoaded() then game.Loaded:Wait() end

--// Start to Load //
wax.shared.TempStorage = {}

task.spawn(pcall, function()
    shared.GameName = nil
    shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

shared.Camera = shared.Workspace.CurrentCamera

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

shared.Connect     = require("Utils/Connect")
shared.ToClipboard = type(shared.ToClipboard) == "function" and shared.ToClipboard or function(...) end

wax.shared.Language = wax.shared.FileHelper:CheckFile("MFeee~New/Language.txt", "en", {
    "am", "ar", "az", "de", "en",
    "es", "fa", "fr", "hi", "hr",
    "hu", "id", "ja", "kz", "ms",
    "pt", "ru", "sv", "tr", "uk",
    "ur", "vi", "zh-cn", "zh-hant"
})

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
wax.shared.NpcHandler    = require("Utils/NPCHandler")

shared.Connect:GiveSignal("CameraChangedSignal" , shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera  = shared.Workspace.CurrentCamera
end))

shared.Connect:GiveSignal("SpeakerChangedSignal", shared.Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
    shared.Speaker = shared.Players.LocalPlayer
end))

--// Loader //
wax.shared.ScriptVersion = "Build 1"

wax.shared.Icons     = require("Utils/Gui/Lucide")
wax.shared.UiManager = require("Utils/Gui/UiManager")
wax.shared.Window    = wax.shared.UiManager:CreateWindow()

require(`Places/Loader/{wax.shared.ScriptFolder}`)

getgenv().MFeeeLoading = false
getgenv().MFeeeLoaded  = true
