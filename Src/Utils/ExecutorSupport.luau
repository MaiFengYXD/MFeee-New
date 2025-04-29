local assert:<T>(T, string?) -> T
    = assert

local taskwait,  stringfind
    = task.wait, string.find

local pcall, print
    = pcall, print

--// Prepere Environment //
local ExecutorSupport = {}

local function Test(Name: string, Function: (...any) -> (...any))
    local Support, Message = pcall(Function)
    ExecutorSupport[Name]  = Support

    if stringfind(Message, "attempt to call a nil value") then
        Message = `{Name} doesn't exist`
    end

    print(Support and `✅ [{Name}]` or `❌ [{Name}] {Message}`)
end

--// File System //

--// Folders
local function FolderTest(Assert: string?)
    makefolder("MFeee~New.test")
    assert(isfolder("MFeee~New.test"), Assert or "Failed to create a folder")
end

Test("makefolder", FolderTest)

Test("isfolder", function()
    FolderTest("Failed to check if folder exists")
end)

Test("delfolder", function()
    FolderTest()
    delfolder ("MFeee~New.test")
    assert(isfolder("MFeee~New.test") == false, "Failed to delete a folder")
end)

--// Files
local function FileTest(Assert: string?)
    makefolder("MFeee~New.test")
    writefile ("MFeee~New.test/Hello.txt", "Hello, World!")
    assert(isfile("MFeee~New.test/Hello.txt"), Assert or "Failed to create a file")
end

Test("writefile", FileTest)

Test("isfile", function()
    FileTest("Failed to check if file exists")
end)

Test("readfile", function()
    FileTest()
    assert(readfile("MFeee~New.test/Hello.txt") == "Hello, World!", "Failed to read a file")
end)

Test("appendfile", function()
    FileTest()
    appendfile("MFeee~New.test/Hello.txt", "\nHello, World!")
    assert(readfile("MFeee~New.test/Hello.txt") == "Hello, World!\nHello, World!", "Failed to append to a file")
end)

Test("delfile", function()
    FileTest()
    delfile("MFeee~New.test/Hello.txt")
    assert(isfile("MFeee~New.test/Hello.txt") == false, "Failed to delete a file")
end)

--// Metatables and Hooks //
Test("hookmetamethod", function()
    local Object = setmetatable({}, {
        __index  = function()
            return "Hello,"
        end
    })

    local Reference = hookmetamethod(Object, "__index", function()
        return " World!"
    end)

    assert(Object.Hi   == " World!"  , "Failed to hook metamethod")
    assert(Reference() == "Hello,"   , "Failed to get old metamethod reference")
    assert(Object.Hi   ~= Reference(), "hooked metamethod should not be equal to the original")

    hookmetamethod(Object, "__index", Reference)
    assert(Object.Hi == "Hello,", "Failed to restore the original metamethod")
end)

Test("getnamecallmethod", function()
    assert(pcall(function() game:Hi() end) or getnamecallmethod() == "Hi", "Failed to get a namecall method")
end)

Test("hookfunction", function()
    local function Original()
        return "Hello,"
    end

    local Reference = hookfunction(Original, function()
        return " World!"
    end)

    assert(Original()  == " World!", "Failed to hook function")
    assert(Reference() == "Hello," , "Failed to get old function reference")
    assert(Original    ~= Reference, "hooked function should not be equal to the original")

    hookfunction(Original, Reference)
    assert(Original() == "Hello,", "Failed to restore the original function") 
end)

Test("getcallingscript", function()
    assert(getcallingscript() == nil, "Calling script test should return nil cause this script isn't a instance")
end)

Test("checkcaller", function()
    assert(checkcaller() == true, "Check caller test should return true cause we are in the main thread")
end)

--[[ Important CoreGui Detection Bypass:

```luau
while true do
    local CoreGui = game:GetService("CoreGui")
    local Table   = {}

    local MetaTable = setmetatable({}, {
        __mode = "kv"
    })

    MetaTable[1] = CoreGui
    MetaTable[2] = Table

    CoreGui = nil
    Table   = nil

    while MetaTable[2] do
        --// Waiting for Lua garbage collection
        task.wait()
    end

    if MetaTable[1] then
        --// CoreGui exists, and an object uses CoreGui (most likely an exploit)
        game:GetService("Players").LocalPlayer:Kick()
    end
end
```
Creator can use the above code to detect CoreGui exploits.

This is a pretty clever CoreGui detection method,
so let's use a hook to make GetService("CoreGui") and game.CoreGui return nil or error every time.

--]]

type Object = Instance | DataModel

if ExecutorSupport.checkcaller then
    local game, checkcaller
        = game, checkcaller

    if ExecutorSupport.hookmetamethod then
        local OldIndex: (self: Object, Key: string) -> (...any)

        OldIndex = hookmetamethod(game, "__index", function(self: Object, Key: string)
            if self == game and Key == "CoreGui" and not checkcaller() then
                return error("The current thread cannot access 'CoreGui' (lacking capability Plugin)", 2)
            end

            return OldIndex(self, Key)
        end)

        if ExecutorSupport.getnamecallmethod then
            local getnamecallmethod
                = getnamecallmethod

            local OldNameCall: (self: Object, ...any) -> (...any)

            OldNameCall = hookmetamethod(game, "__namecall", function(self: Object, ...: any)
                if self == game and getnamecallmethod() == "GetService" and not checkcaller() and ... == "CoreGui" then
                    local Success = pcall(OldNameCall, self, ...)

                    if Success then return nil
                    else return error("The current thread cannot access 'CoreGui' (lacking capability Plugin)", 2) end
                end

                return OldNameCall(self, ...)
            end)
        end
    end

    if ExecutorSupport.hookfunction then
        local OldFunction: (self: Object, ServiceName: string) -> (...any)

        OldFunction = hookfunction(game.GetService, function(self: Object, ServiceName: string)
            if ServiceName == "CoreGui" and not checkcaller() then
                local Success = pcall(OldFunction, self, ServiceName)

                if Success then return nil
                else return error("The current thread cannot access 'CoreGui' (lacking capability Plugin)", 2) end
            end

            return OldFunction(self, ServiceName)
        end)
    end
end

require("Services"):GetServices({"CoreGui"})

--// Instances //
Test("fireproximityprompt", function()
    local Prompt = Instance.new("ProximityPrompt")

    Prompt.Triggered:Once(function()
        Prompt = Prompt:Destroy()
    end)

    assert(pcall(fireproximityprompt, Prompt) and taskwait(0.1) and Prompt == nil, "Failed to fire a ProximityPrompt")
end)

Test("firetouchinterest", function()
    shared.FireTouch = firetouchinterest or firetouchtransmitter

    local Part1 = Instance.new("Part")
    local Part2 = Instance.new("Part")

    Part2.Touched:Once(function()
        Part1 = Part1:Destroy()
        Part2 = Part2:Destroy()
    end)

    assert(pcall(shared.FireTouch, Part1, Part2, 0) and taskwait(0.1) and not (Part1 and Part2), "Failed to fire the 'TouchInterest'")
end)

Test("getconnections", function()
    shared.GetConnections = getconnections or get_signal_cons
    local Types = {
        Enabled = "boolean",
        ForeignState = "boolean",
        LuaConnection = "boolean",
        Function = "function",
        Thread = "thread",
        Fire = "function",
        Defer = "function",
        Disconnect = "function",
        Disable = "function",
        Enable = "function"
    }

    local Signal = Instance.new("BindableEvent")
    Signal.Event:Once(function() end)

    local Connection = shared.GetConnections(Signal.Event)[1]
    for Key, Type in Types do
        assert(Connection[Key] ~= nil, `Did not return a table with a '{Key}' field`)
        assert(type(Connection[Key]) == Type, `'{Key}' field is not a {Type}`)
    end
end)

Test("require", function()
    local IsA,      require: (Instance) -> any
        = game.IsA, getgenv().require

    assert(type(require) == "function", "attempt to call a nil value")

    local ModuleScript

    for _, Object in game:GetDescendants() do
        --// I did this because it was really quick on test
        if not IsA(Object, "ModuleScript") then continue end
        if require(Object) == nil then continue end

        ModuleScript = Object
        break
    end

    assert(ModuleScript, "Failed to find a ModuleScript")
    assert(require(ModuleScript) ~= nil, "No content in the ModuleScript?")
end)

Test("gethui", function()
    local HiddenUi = gethui()
    local Gui      = Instance.new("ScreenGui", HiddenUi)

    assert(Gui.Parent == (shared.Speaker:FindFirstChildWhichIsA("PlayerGui") or shared.CoreGui), "Failed to get hidden UI")
    Gui:Destroy()
end)

Test("protectgui", function()
    shared.ProtectGui = protectgui or syn and syn.protect_gui

    local Gui = Instance.new("ScreenGui")
    shared.ProtectGui(Gui)

    Gui.Parent = shared.Workspace
    for _, Object in shared.Workspace:GetChildren() do
        assert(Object == Gui, "Failed to protect GUI")
    end

    Gui:Destroy()
end)

--// Miscellaneous //
Test("decompile", function()
    assert(type(getgenv()["decompile"]) == "function", "Decompiler doesn't exist")
end)

Test("queue_on_teleport", function()
    shared.QueueTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport
    assert(type(getgenv()[shared.QueueTeleport]) == "function", "Seems like queue_on_teleport doesn't exist")
end)

Test("toclipboard", function()
    shared.ToClipboard = (
        toclipboard or setclipboard or write_clipboard or setrbxclipboard or
        syn and syn.write_clipboard or Clipboard and Clipboard.set
    )
    assert(type(getgenv()[shared.ToClipboard]) == "function", "Seems like toclipboard doesn't exist")
end)

Test("Drawing", function()
    local Draw = Drawing.new("Circle")
    Draw.Visible = false

    assert(pcall(Draw.Remove, Draw), "Drawing API is incomplete")
end)

--// Fixes //
local Global = getgenv()

if not ExecutorSupport.fireproximityprompt then
    local Inf = (1 / 0)

    function Global.fireproximityprompt(Prompt: ProximityPrompt, Distance: number?)
        local PreDuration = Prompt.HoldDuration
        local PreDistance = Prompt.MaxActivationDistance
        local PreNoclip   = Prompt.RequiresLineOfSight

        Prompt.HoldDuration = 0
        Prompt.MaxActivationDistance = Distance or Inf
        Prompt.RequiresLineOfSight   = false

        Prompt.Triggered:Once(function()
            Prompt:InputHoldEnd()

            Prompt.HoldDuration          = PreDuration
            Prompt.MaxActivationDistance = PreDistance
            Prompt.RequiresLineOfSight   = PreNoclip
        end)

        Prompt:InputHoldBegin()
    end
end

if not ExecutorSupport.firetouchinterest then
    local PreTouch1    = {}
    local PreTouch2    = {}
    local PrePositions = {}

    local function Touch1(Part1: BasePart, Part2: BasePart)
        PreTouch1   [Part1] = Part1
        PreTouch2   [Part2] = Part2
        PrePositions[Part2] = Part2.Position

        Part1.CanTouch = true
        Part2.CanTouch = true
        Part2.Position = Part1.Position
    end

    local function Touch0(Part1: BasePart, Part2: BasePart)
        Part2.Touched:Once(function()
            Part1.CanTouch = PreTouch1[Part1]
            Part2.CanTouch = PreTouch2[Part2]
            Part2.Position = PrePositions[Part2]

            PreTouch1   [Part1] = nil
            PreTouch2   [Part2] = nil
            PrePositions[Part2] = nil
        end)

        Touch1(Part1, Part2)
    end

    function Global.firetouchinterest(Part1: BasePart, Part2: BasePart, Touching: number)
        if     Touching == 1 then
            Touch1(Part1, Part2)
        elseif Touching == 0 then
            Touch0(Part1, Part2)
        end
    end

    shared.FireTouch = Global.firetouchinterest
end

--// Summary //
local FileSystem = {
    "makefolder",
    "isfolder",
    "delfolder",
    "writefile",
    "isfile",
    "readfile",
    "appendfile",
    "delfile"
}

local FileSystemSupport = 0

for _, Function in FileSystem do
    if ExecutorSupport[Function] then
        FileSystemSupport += 1
    end
end

ExecutorSupport.SupportFileSystem = FileSystemSupport == 8

return ExecutorSupport
