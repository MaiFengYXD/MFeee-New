local Library = {}
shared.Gui.Library = Library

local LibraryConfig = shared.ConfigManager.new("UILibrary", {
    NotificationSound   = "Preset 1", -- Preset 1: 4590662766, Preset 2: 4590657391
    NotificationSide    = "TopRight",
    ToggleKeybind       = "RightShift",
    EnabledKeybindFrame = false,
    CheckboxStyle       = false,
    CustomCursor        = false,
    AlwaysOnTop         = false,
    NoNotify            = false,
    UIActivated         = true,
    DPIScale            = 1,
    NotificationVolume  = 2,
    NotificationSoundId = 4590662766
}, "ui.config.json")

Library.Config = LibraryConfig.Config

local ElementTypes = {
    "Dropdown",
    "SortableList",
    "Toggle",
    "Button",
    "Slider",
    "Input",
    "ColorPicker",
    "KeyPicker"
}

local Elements = {}
for _, ElementType in ElementTypes do
    Elements[ElementType] = {}
end

Library.Elements = Elements
Library.Utils    = require("@self/../Utils")

return Library
