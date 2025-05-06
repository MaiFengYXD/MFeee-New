local assert:<T>(T, string?) -> T
    = assert

local task_wait, string_find, Instance_new, table_find, pcall, print
    = task.wait, string.find, Instance.new, table.find, pcall, print

local      IsA
    = game.IsA

--// Prepare Environment //
local ExecutorSupport = {}
local Fixable         = {
    "fireproximityprompt",
    "firetouchinterest",
    "randomstring"
}

local function Test(Name: string, Function: (...any) -> (...any))
    local CanBeFixed = table_find(Fixable, Name)

    local Support, Message = pcall(Function)
    ExecutorSupport[Name]  = if CanBeFixed then true else Support

    if string_find(Message, "attempt to call a nil value") then
        Message = `{Name} doesn't exist`
    end

    if not Support and CanBeFixed then
        Message ..= ", but it can be fixed"
    end

    print(Support and `✅ [{Name}]` or `{CanBeFixed and "⚠️" or "❌"} [{Name}] {Message}`)
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

--// Instances //
Test("fireproximityprompt", function()
    assert(type(fireproximityprompt) == "function", "attempt to call a nil value")
    local Prompt = Instance_new("ProximityPrompt")

    Prompt.Triggered:Once(function()
        Prompt = Prompt:Destroy()
    end)

    assert(pcall(fireproximityprompt, Prompt) and task_wait(0.1) and Prompt == nil, "Failed to fire a ProximityPrompt")
end)

Test("firetouchinterest", function()
    shared.FireTouch = firetouchinterest or firetouchtransmitter
    assert(type(shared.FireTouch) == "function", "attempt to call a nil value")

    local Part1 = Instance_new("Part")
    local Part2 = Instance_new("Part")

    Part2.Touched:Once(function()
        Part1 = Part1:Destroy()
        Part2 = Part2:Destroy()
    end)

    assert(pcall(shared.FireTouch, Part1, Part2, 0) and task_wait(0.1) and not (Part1 and Part2), "Failed to fire the 'TouchInterest'")
end)

Test("getconnections", function()
    shared.GetConnections = getconnections or get_signal_cons
    assert(type(shared.GetConnections) == "function", "attempt to call a nil value")

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

    local Signal = Instance_new("BindableEvent")
    Signal.Event:Once(function() end)

    local Connection = shared.GetConnections(Signal.Event)[1]
    for Key, Type in Types do
        assert(Connection[Key] ~= nil, `Did not return a table with a '{Key}' field`)
        assert(type(Connection[Key]) == Type, `'{Key}' field is not a {Type}`)
    end
end)

Test("require", function()
    local require: (Instance) -> any
        = getgenv().require

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
end)

Test("gethui", function()
    assert(IsA(gethui(), "CoreGui"), "Failed to get CoreGui")
end)

Test("protectgui", function()
    shared.ProtectGui = protectgui or syn and syn.protect_gui
    assert(type(shared.ProtectGui) == "function", "attempt to call a nil value")

    local Gui = Instance_new("ScreenGui")
    shared.ProtectGui(Gui)

    Gui.Parent = shared.Workspace
    for _, Object in shared.Workspace:GetChildren() do
        assert(Object == Gui, "Failed to protect GUI")
    end

    Gui:Destroy()
end)

--// Miscellaneous //
Test("queue_on_teleport", function()
    shared.QueueTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport
    assert(type(shared.QueueTeleport) == "function", "Seems like queue_on_teleport doesn't exist")
end)

Test("toclipboard", function()
    shared.ToClipboard = (
        toclipboard or setclipboard or write_clipboard or setrbxclipboard or
        syn and syn.write_clipboard or Clipboard and Clipboard.set
    )
    assert(type(shared.ToClipboard) == "function", "Seems like toclipboard doesn't exist")
end)

Test("Drawing", function()
    local Draw = Drawing.new("Circle")
    Draw.Visible = false

    assert(pcall(Draw.Remove, Draw), "Drawing API is incomplete")
end)

Test("randomstring", function()
    local String = randomstring(128)
    assert(type(String) == "string" and #String == 128, "Failed to generate a random string")
end)

--// Fixes //
local Global = getgenv()

if not ExecutorSupport.fireproximityprompt then
    local Inf = (1 / 0)

    function Global.fireproximityprompt(Prompt: ProximityPrompt, Distance: number | nil)
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
    local PreTouch1 = {}
    local PreTouch2 = {}

    local PreCollided1 = {}
    local PreCollided2 = {}

    local PreTransparency1 = {}
    local PreTransparency2 = {}

    local PrePositions = {}

    local function Touch1(Part1: BasePart, Part2: BasePart)
        PreTouch1[Part1] = Part1.CanTouch
        PreTouch2[Part2] = Part2.CanTouch

        PreCollided1[Part1] = Part1.CanCollide
        PreCollided2[Part2] = Part2.CanCollide

        PreTransparency1[Part1] = Part1.Transparency
        PreTransparency2[Part2] = Part2.Transparency

        PrePositions[Part2] = Part2.Position

        Part1.CanTouch = true
        Part2.CanTouch = true

        Part1.CanCollide = false
        Part2.CanCollide = false

        Part1.Transparency = 1
        Part2.Transparency = 1

        Part2.Position = Part1.Position
    end

    local function Touch0(Part1: BasePart, Part2: BasePart)
        Part2.Touched:Once(function()
            Part1.CanTouch = PreTouch1[Part1]
            Part2.CanTouch = PreTouch2[Part2]

            Part1.CanCollide = PreCollided1[Part1]
            Part2.CanCollide = PreCollided2[Part2]

            Part1.Transparency = PreTransparency1[Part1]
            Part2.Transparency = PreTransparency2[Part2]

            Part2.Position = PrePositions[Part2]

            PreTouch1[Part1] = nil
            PreTouch2[Part2] = nil

            PreCollided1[Part1] = nil
            PreCollided2[Part2] = nil

            PreTransparency1[Part1] = nil
            PreTransparency2[Part2] = nil

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

if not ExecutorSupport.randomstring then
    local stringchar
        = string.char

    local Random      = Random.new()
    local NextInteger = Random.NextInteger

    function Global.randomstring(Length: number | nil): string
        local String = ""

        for _ = 1, Length or 16 do
            String ..= stringchar(NextInteger(Random, 33, 126))
        end

        return String
    end
end

--[[ CoreGui Detection Bypass:

```luau
while true do
    local CoreGui = game:GetService("CoreGui") --/ Get CoreGui strong reference
    local Dummy   = {} :: any

    local MetaTable = setmetatable({}, {
        --// Set as weak table so Lua garbage collection can collect it without any strong references
        __mode = "kv"
    })

    --// Add these two variables to the weak table as weak references in the weak table
    MetaTable[1] = CoreGui
    MetaTable[2] = Dummy

    --// Clean up the two strong references so Lua can collect CoreGui on the next garbage collection
    CoreGui = nil
    Dummy   = nil

    while MetaTable[2] do
        --// Waiting for Lua garbage collection
        task.wait()
    end

    if MetaTable[1] then
        --// CoreGui reference exists, and an object uses CoreGui (most likely an exploit)
        game:GetService("Players").LocalPlayer:Kick()
    end
end
```
Creator can use the above code to detect CoreGui exploits.

So let's use a hook to make GetService("CoreGui") and game.CoreGui return nil or error every time.

--]]

type Object = Instance | DataModel

if ExecutorSupport.gethui then
    --// gethui can bypass this detection
    shared.CoreGui = gethui()
elseif ExecutorSupport.checkcaller then
    local game, checkcaller, error
        = game, checkcaller, error

    local OldIndex, OldNameCall, OldFunction

    local ErrorMessage = "The current thread cannot access 'CoreGui' (lacking capability Plugin)"

    if ExecutorSupport.hookmetamethod then
        OldIndex = hookmetamethod(game, "__index", function(self: Object, Key: string): (...any)
            if self == game and Key == "CoreGui" and not checkcaller() then
                return error(ErrorMessage, 2)
            end

            return OldIndex(self, Key)
        end)

        if ExecutorSupport.getnamecallmethod then
            local getnamecallmethod
                = getnamecallmethod

            OldNameCall = hookmetamethod(game, "__namecall", function(self: Object, ...: any): (...any)
                if self == game and getnamecallmethod() == "GetService" and ... == "CoreGui" and not checkcaller() then
                    return if pcall(OldNameCall, self, ...) then nil else error(ErrorMessage, 2)
                end

                return OldNameCall(self, ...)
            end)
        end
    end

    if ExecutorSupport.hookfunction then
        OldFunction = hookfunction(game.GetService, function(self: Object, ServiceName: string): (...any)
            if not checkcaller() and ServiceName == "CoreGui" then
                return if pcall(OldFunction, self, ServiceName) then nil else error(ErrorMessage, 2)
            end

            return OldFunction(self, ServiceName)
        end)
    end

    require("Services"):GetServices({"CoreGui"})
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
    FileSystemSupport += ExecutorSupport[Function] and 1 or 0
end

ExecutorSupport.SupportFileSystem = FileSystemSupport == 8

return ExecutorSupport
