--[[
MFeee~ New's UI Library

Big credit to deivid Obsidian Library
(Tentative name: Obsidian Lite)
--]]

local Library = {
    Toggled = false,
    ShowCustomCursor = false,

    BaseFrame = Instance.new("Frame", wax.shared.ScreenGui),

    Toggles = {},
    Buttons = {},
    Options = {},
    Labels  = {},

    Scheme = {
        --// Colors
        MainColor       = Color3.fromHex("0d1117"),
        AccentColor     = Color3.fromHex("1f6feb"),
        BackgroundColor = Color3.fromHex("010409"),
        FontColor       = Color3.fromHex("ffffff"),
        OutlineColor    = Color3.fromHex("1f242b"),
        Risky           = Color3.fromRGB(255, 50, 50),

        --// MISC
        CornerRadius = UDim.new(0, 4),
        Font         = Font.fromEnum(Enum.Font.BuilderSans)
    },

    Registry    = {},
    DPIRegistry = {}
}

Library.BaseFrame.ClipsDescendants = true
Library.BaseFrame.BackgroundColor3 = Library.Scheme.MainColor
Library.BaseFrame.BackgroundTransparency = 1

Library.Utils = require("Utils", Library)

---@deivid we dont need __namecall meta method cause it only works on newproxy()
local BaseAddons   = {__index = {}}
local BaseGroupbox = {__index = {}}

Library.BaseAddons   = BaseAddons
Library.BaseGroupbox = BaseGroupbox

do
    local Addons     = script.Parent.BaseAddons:GetChildren()
    local Groupboxes = script.Parent.BaseGroupbox:GetChildren()

    local function Sorting(A: ModuleScript, B: ModuleScript)
        return A.Name < B.Name
    end

    table.sort(Addons, Sorting)
    table.sort(Groupboxes, Sorting)

    for _, Addon: ModuleScript in Addons do
        BaseAddons.__index[Addon.Name] = require(Addon, Library)
    end

    for _, Groupbox: ModuleScript in Groupboxes do
        BaseGroupbox.__index[Groupbox.Name] = require(Groupbox, Library)
    end
end

shared.Connect:GiveSignal("LibraryUnregister", Library.BaseFrame.DescendantRemoving, function(Instance: Instance)
    Library.Registry[Instance] = nil
end)

return Library
