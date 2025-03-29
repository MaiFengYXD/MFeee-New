
--// Pre-Checks //
local Services = require("Utils/Services")

Services:GetServices({
    "Players",
    "Workspace",
    "StarterGui",
    "UserInputService"
})

local function Notify(Title: string, Text: string)
    print(Title, Text)

    shared.StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Button1 = "Close",
        Duration = 5
    })
end

if getgenv().MFeeeLoaded then return Notify("Loading Stopped!", "Error: Already loaded.") end
if getgenv().MFeeeLoading then return Notify("Loading Stopped!", "Error: Loading.") end

getgenv().MFeeeLoading = true

if not game:IsLoaded() then game.Loaded:Wait() end

--// Loader //

--// Prepare
shared.Speaker = shared.Players.LocalPlayer
shared.Camera = shared.Workspace.CurrentCamera

wax.shared.ExecutorSupport = wax.shared.ExecutorSupport or require("Utils/ExecutorSupport")
wax.shared.FileHelper = wax.shared.FileHelper or require("Utils/FileHelper")

wax.shared.ScriptBaseFolder = wax.shared.FileHelper:CreateFolder("MFeee~New")
wax.shared.Langauge = wax.shared.FileHelper:CheckFile("MFeee~New/Langauge.txt", "en")

if not wax.shared.GotPlace then
    wax.shared.GotPlace = true

    shared.ScriptName = "Universal"
    shared.ScriptLoader = "Universal"

    local Mappings = require("Mappings")
    local MappingID = Mappings[game.GameId]

    if MappingID then
        local Folder = MappingID["Folder"]
        local Name = MappingID["Name"] or Folder
        local GameExclusions = MappingID["Exclusions"] or {}
        local Exclusion = GameExclusions[game.PlaceId]

        shared.ScriptName = Name
        shared.ScriptLoader = `{Folder}/{MappingID["Loader"]}`

        shared.Mapping = MappingID
        shared.ScriptFolder = Folder
        shared.ScriptExclusion = Exclusion

        if Exclusion then
            shared.ScriptName = `{Name} ({Exclusion})`
            shared.ScriptLoader = `{Folder}/{Exclusion}`
        end
    end
end

wax.shared.Translations = wax.shared.Translations or require("Translations")

shared.Connection = shared.Connection or require("Utils/Connections")
shared.ControlModule = shared.ControlModule or require("Utils/ControlModule")

shared.Connection:GiveSignal("CameraChangeSignal", shared.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    shared.Camera = shared.Workspace.CurrentCamera
end))

--// Loader