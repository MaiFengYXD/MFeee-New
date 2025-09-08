local pcall, task, type
    = pcall, task, type

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
    "LocalizationService",
    "MarketplaceService",
    "CollectionService",
    "ReplicatedStorage",
    "UserInputService",
    "ContentProvider",
    "SoundService",
    "TweenService",
    "HttpService",
    "StarterGui",
    "GuiService",
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

do
    local Instance_new,      Destroy
        = Instance.new, game.Destroy

    local GuiService   = shared.GuiService   :: GuiService
    local StarterGui   = shared.StarterGui   :: StarterGui
    local SoundService = shared.SoundService :: SoundService

    local SendNotification = GuiService.SendNotification
    local SetCore          = StarterGui.SetCore

    local function Notify(Title: string, Text: string): ()
        warn(`[MFeee~ New] {Title} {Text}`)

        if (
            type(setthreadidentity) == "function" and (
                pcall(setthreadidentity, 3) and
                pcall(SendNotification, GuiService, {
                    Title = Title,
                    Text  = Text
                })
            ) or
            pcall(SetCore, StarterGui, "SendNotification", {
                Title    = Title,
                Text     = Text,
                Duration = 15,
                Button1  = "Close"
            })
        ) then
            local Sound = Instance_new("Sound", SoundService);do
                Sound.SoundId      = "rbxassetid://4590662766"
                Sound.Volume       = 2
                Sound.PlayOnRemove = true
            end

            Destroy(Sound)
        end
    end

    shared.MiniNotify = Notify

    if Global.MFeeeLoaded  then Notify("Loading Stopped!", "Error: already loaded.") ;return end
    if Global.MFeeeLoading then Notify("Loading Stopped!", "Error: already loading.");return end
end

Global.MFeeeLoading = true
Global.MFeeeLoaded  = false

if not Global.HttpGet then
    local function GetFunction(Function: any): Function?
        return type(Function) == "function" and Function or nil
    end

    local HttpGet
    pcall(function(game)
        HttpGet = GetFunction(secret_get) or GetFunction(HttpGet) or GetFunction(HttpGetAsync)
        assert(not HttpGet)

        local function Find(self, Key: string): any
            local Success, Result = pcall(function(self, Key)
                return self[Key]
            end, self, Key)

            return Success and GetFunction(Result) or nil
        end

        local Function = Find(game, "secret_get") or Find(game, "HttpGet") or Find(game, "HttpGetAsync")
        assert(Function)

        function HttpGet(Url: string): string
            return Function(game, Url)
        end
    end, game)

    Global.HttpGet = HttpGet
end

if not Global.request then
    local function GetFunction(Function: any): Function?
        return type(Function) == "function" and Function or nil
    end

    local request = (
        GetFunction(request) or
        GetFunction(http_request) or
        http and GetFunction(http.request) or
        syn and GetFunction(syn.request) or
        fluxus and GetFunction(fluxus.request)
    )

    if request then Global.request = request end
end

task.spawn(shared.ContentProvider.PreloadAsync, shared.ContentProvider, {
    "rbxassetid://103134660123798",
    "rbxassetid://77335290652571",
    "rbxassetid://4590662766",
    "rbxassetid://4590657391"
})

shared.PlayerGui = shared.Speaker:FindFirstChildOfClass("PlayerGui") or (function(IsA, Wait, ChildAdded)
    while true do
        local PlayerGui = Wait(ChildAdded)
        if IsA(PlayerGui, "PlayerGui") then
            return PlayerGui
        end
    end
end)(game.IsA, game.Close.Wait, shared.Speaker.ChildAdded)

shared.Emoji           = require("@self/Utils/ArtEmoji")
shared.ExecutorSupport = require("@self/Utils/ExecutorSupport")
shared.FileHelper      = require("@self/Utils/FileHelper")

shared.ConfigManager = require("@self/Utils/Config")

local BootConfig = shared.ConfigManager.new("Boot", {
    VersionCheck         = wax.arguments[1] ~= "FromHttpGet",
    InitialNotifications = true,
    TranslationsTimeout  = 10,
    DisableTranslation   = false,
    AutoBypassAntiCheat  = true
}, "boot.config.json")

local BootSettings  = BootConfig.Config
shared.BootSettings = BootSettings

if BootSettings.AutoBypassAntiCheat then
    require("@self/Utils/Bypass")
end

do
    local table_insert, table_clear, unpack, debug_profilebegin, debug_profileend
        = table.insert, table.clear, unpack, debug.profilebegin, debug.profileend

    local OnUnloadFunctions = {} :: {{any}}

    function wax.Unload()
        if wax.Unloaded then return end
        debug_profilebegin("[Multi-function pcall] Unload")

        local pcall, unpack
            = pcall, unpack

        for _, Bundled in OnUnloadFunctions do
            pcall(Bundled[1], unpack(Bundled[2]))
        end
        OnUnloadFunctions = table_clear(OnUnloadFunctions)

        Global.MFeeeLoaded  = false
        Global.MFeeeLoading = false

        wax.Unloaded = true
        debug_profileend()
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

        for _ = 1, Length or NextInteger(Random, 16, 32) do
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

    local Platform = (shared.UserInputService :: UserInputService):GetPlatform().Name

    for Type, OSList in DeviceTypes :: hash do
        for _, OS in OSList do
            if OS ~= Platform then continue end

            shared.DeviceType = Type
            break
        end
    end
end

local Mapping = require("@self/Mappings")[game.PlaceId]

local ScriptName    = Mapping.Name
local ScriptFolder  = Mapping.Folder
local ScriptDisplay = Mapping.Display

shared.ScriptName    = ScriptName
shared.ScriptFolder  = ScriptFolder
shared.ScriptDisplay = ScriptDisplay

--// Start to Load //
shared.TempStorage = {}

task.spawn(function()
    while not (pcall(function()
        shared.GameName = shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
    end) and shared.GameName) and task.wait(0.5) do end
end)

shared.Camera = shared.Workspace.CurrentCamera

shared.Translator    = require("@self/Translator")
shared.EasingLibrary = require("@self/Utils/EasingLibrary")

shared.Connect = require("@self/Utils/Connect")

shared.Connect.CommonSignals.CameraChanged(function(NewCamera: Camera)
    shared.Camera = NewCamera
end)

shared.Connect.CommonSignals.SpeakerChagned(function(NewSpeaker: Player)
    shared.Speaker = NewSpeaker
end)

--// Load //
shared.ScriptVersion = "Build 1"

shared.Gui    = require("@self/Gui")
shared.Window = shared.Gui:Init()

do (require :: any)(`@self/Places{shared.ScriptFolder}`) end

shared.Gui:AddUniversalTabs()

shared.Gui.SaveManager :LoadAutoloadConfig()
shared.Gui.ThemeManager:LoadDefault()

Global.MFeeeLoaded  = true
Global.MFeeeLoading = false

local Translate = shared.Translator.Translate
local Reverse   = shared.Translator.Reverse

if BootSettings.InitialNotifications then
    task.spawn(pcall, function()
        assert(BootSettings.VersionCheck)

        local Version   = Global.HttpGet("https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/heads/main/VERSION")
        assert(Version ~= shared.ScriptVersion and #Version > 0 and Version ~= "404: Not Found")

        shared.Gui:Notify({
            Title       = Translate("Version Mismatch"),
            Description = Reverse("The script version %s is outdated, please update it! (new version %s)", shared.ScriptVersion, Version),
            Time        = 15
        })
    end)

    task.spawn(pcall, function()
        assert(shared.BypassedMethod)

        shared.Gui:Notify({
            Title       = Translate("Bypassed Anticheat"),
            Description = Reverse("MFeee~ New has bypassed %s anti-hook anti-cheat", shared.BypassedMethod),
            Time        = 4
        })
    end)
end
