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
        Duration = 5
    })
end

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
task.spawn(pcall, function()
    shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

shared.Camera  = shared.Workspace.CurrentCamera

wax.shared.Emoji           = require("Utils/ArtEmoji")
wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
wax.shared.FileHelper      = require("Utils/FileHelper")

shared.Connection  = require("Utils/Connection")
shared.ToClipboard = type(shared.ToClipboard) == "function" and shared.ToClipboard or function(...) end

local FileHelper = wax.shared.FileHelper

wax.shared.Language = FileHelper:CheckFile("MFeee~New/Language.txt", "en", {
    "am", "ar", "az", "de", "en",
    "es", "fa", "fr", "hi", "hr",
    "hu", "id", "ja", "kz", "ms",
    "pt", "ru", "sv", "tr", "ua",
    "ur", "vi", "zh-cn", "zh-hant"
})

do
    wax.shared.ScriptName    = "Universal"
    wax.shared.ScriptLoader  = "Universal"
    wax.shared.ScriptDisplay = "Universal"

    local Mappings = require("Mappings")
    local Mapping  = Mappings[game.PlaceId]

    if Mapping then
        wax.shared.ScriptName    = Mapping.Name
        wax.shared.ScriptLoader  = Mapping.Folder
        wax.shared.ScriptDisplay = Mapping.Display
    end
end

wax.shared.Translations  = require("Translations/Main")
wax.shared.EasingLibrary = require("Utils/EasingLibrary")

wax.shared.PlayerUniversal = require("Utils/PlayerUniversal")
wax.shared.MISCUniversal   = require("Utils/MISCUniversal")
wax.shared.VisualUniversal = require("Utils/VisualUniversal")
wax.shared.NpcHandler      = require("Utils/NPCHandler")

shared.ControlModule = require("Utils/ControlModule")

wax.shared.BloxstrapRPC = require("Utils/BloxstrapRPC")
wax.shared.TempStorage  = {}

shared.Connection:GiveSignal("CameraChangedSignal", shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera = shared.Workspace.CurrentCamera
end))

shared.Connection:GiveSignal("PlayerNameChangedSignal", shared.Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
    shared.Speaker = shared.Players.LocalPlayer
end))

--// Loader //
shared.ScriptVersion = "Build 1"

wax.shared.Icons     = require("Utils/Gui/Lucide")
wax.shared.UiManager = require("Utils/Gui/UiManager")

local UiManager = wax.shared.UiManager

wax.shared.Window = UiManager:CreateWindow()

require(`Places/{shared.ScriptLoader}/Loader`)

UiManager:CreateUniversalTabs()

getgenv().MFeeeLoading = false
getgenv().MFeeeLoaded = true
