local task_spawn, string_find, string_sub, table_clear, table_insert
    = task.spawn, string.find, string.sub, table.clear, table.insert

local pcall, xpcall, error, typeof, print
    = pcall, xpcall, error, typeof, print

local Global = wax.Global

--// Prepare Environment //
local ExecutorSupport = {
    SupportFileSystem = false,
    TotalTestes       = 0,
    TotalWorking      = 0
}

local OutputList = {}
local Garbages   = {} :: {Function}

local OnTestCompletionCallback = {} :: {Function}

local function assert<T>(Assertion: T, Message: string?): (nil)
    -- Set to 19998 for disabling traceback
    return if Assertion then nil else error(Message, 19998)
end

local function Test(
    Name:         string,
    Requires:     {string?},
    Aliases:      {string?},
    TestFunction: (...any) -> (),
    Fix:          (() -> ()) | nil,
    CannotTest:   boolean    | nil
): ()
    ExecutorSupport.TotalTestes += 1

    local Success:    boolean,
          TestResult: string?

    Success = true

    local IsFixable = typeof(Fix) == "function"
    local ActiveRequirements = {} :: hash

    local function GoSummary()
        for _, Function in Garbages do
            task_spawn(pcall, Function)
        end

        local RealSuccess = Success or IsFixable

        ExecutorSupport[Name] = RealSuccess
        ExecutorSupport.TotalWorking += RealSuccess and 1 or 0

        local Emoji = Success and (CannotTest and "⏺️" or "✅") or RealSuccess and "⚠️" or "❌"
        local Info  = TestResult and ` - {TestResult}` or ""

        local Output = `> {Emoji} [{Name}]{Info}`

        table_insert(OutputList, Output)

        for _, Callback in OnTestCompletionCallback do
            Callback(Name, RealSuccess, IsFixable, ActiveRequirements, Output)
        end

        task_spawn(table_clear, Requires)
        task_spawn(table_clear, Aliases)
        task_spawn(table_clear, Garbages)
    end

    local function TryToFix(ErrorMessage: string): string?
        if not IsFixable then return ErrorMessage end

        local FixSuccess = pcall((Fix :: Function))
        IsFixable = FixSuccess

        return if FixSuccess then `{ErrorMessage}, but it can be fixed` else ErrorMessage
    end

    local function GetRealFunction(Description: string): Function?
        local _, Table = string_find(Description, "table: ")
        local Key      = string_find(Description, "key: ")

        if not (Table and Key) then
            local GlobalFunction = Global[Description]
            return typeof(GlobalFunction) == "function" and GlobalFunction or nil
        end

        local TableName = string_sub(Description, Table + 1, Key - 2)
        local KeyName   = string_sub(Description, Key + 5)

        local TableFunction = if typeof(Global[TableName]) == "table" then Global[TableName][KeyName] else nil
        local RealFunction  = if typeof(TableFunction) == "function" then TableFunction else nil

        return RealFunction
    end

    if #Requires > 0 then
        for _, Requirement in Requires :: {string} do
            local Function = GetRealFunction(Requirement)
            local Tested   = ExecutorSupport[Requirement]

            if Function and (if Tested ~= nil then Tested else true) then continue end

            Success    = false
            TestResult = TryToFix(`Missing requirement '{Requirement}'`)

            ActiveRequirements[Requirement] = false
        end

        if not Success then
            return GoSummary()
        end
    end

    local RealFunction = Global[Name]
    local UsesAlias    = false

    if not RealFunction then
        for _, Alias in (Aliases :: {string}) do
            RealFunction = GetRealFunction(Alias)
            if RealFunction then break end
        end

        if not RealFunction then
            Success    = false
            TestResult = TryToFix(`Missing function '{Name}' and its aliases`)

            return GoSummary()
        end

        UsesAlias = true
    end

    Success, TestResult = xpcall(TestFunction, TryToFix, RealFunction)

    if UsesAlias then
        Global[Name] = RealFunction
    end

    return GoSummary()
end

local function TestAll()
    local task_spawn, task_delay, string_sub, table_insert, Instance_new, debug_profilebegin, debug_profileend
        = task.spawn, task.delay, string.sub, table.insert, Instance.new, debug.profilebegin, debug.profileend

    local pcall, typeof, print, assert
        = pcall, typeof, print, assert

    local OutputList, Garbages, Test
        = OutputList, Garbages, Test

    local Global = wax.Global

    local function GetShortName(Name: string): string
        return #Name > 15 and string_sub(Name, 1, 15) .. "..." or Name
    end

    table_insert(OutputList, "----------------")

    --// File System //
    local TestFolder = "MFeee-New/.test"
    local TestFile   = `{TestFolder}/test.txt`

    local function CleanFolder()
        debug_profilebegin("[File I/O] delfolder")
        delfolder(TestFolder)
        debug_profileend()
    end

    --// Folder
    Test("makefolder", {"isfolder"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] makefolder")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        assert(isfolder(TestFolder), "Folder not created")

        debug_profileend()
    end)

    Test("isfolder", {"makefolder"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] isfolder")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        assert(isfolder(TestFolder), "Folder existence check failed")

        debug_profileend()
    end)

    Test("delfolder", {"makefolder", "isfolder"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] delfolder")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        delfolder(TestFolder)
        assert(isfolder(TestFolder) == false, "Folder deletion failed")

        debug_profileend()
    end)

    --// File
    Test("writefile", {"makefolder", "readfile"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] writefile")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        writefile(TestFile, "Hello, World!")
        assert(readfile(TestFile) == "Hello, World!", "File content mismatch")

        debug_profileend()
    end)

    Test("isfile", {"makefolder", "writefile"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] isfile")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        writefile(TestFile, "Hello, World!")
        assert(isfile(TestFile), "File existence check failed")

        debug_profileend()
    end)

    Test("readfile", {"makefolder", "writefile"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] readfile")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        writefile(TestFile, "Hello, World!")
        assert(readfile(TestFile) == "Hello, World!", "File content mismatch")

        debug_profileend()
    end)

    Test("delfile", {"makefolder", "writefile"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [File I/O] delfile")

        table_insert(Garbages, CleanFolder)
        makefolder(TestFolder)
        writefile(TestFile, "Hello, World!")
        delfile(TestFile)
        assert(isfile(TestFile) == false, "File deletion failed")

        debug_profileend()
    end)

    --// Metatable //
    Test("hookmetamethod", {}, {}, function()
        local Object    = newproxy(true)
        local MetaTable = getmetatable(Object)

        table_insert(Garbages, function()
            Object, MetaTable = nil, nil
        end)

        function MetaTable.__index(_, Key)
            return Key == "Banana" and 123 or "Hello "
        end

        function MetaTable.__namecall(_, Arg)
            return Arg == "Orange" and 456 or "World!"
        end

        local Originals = {} :: {
            ["__index"   ]: (any, Key: string?) -> string | number,
            ["__namecall"]: (any, Arg: string?) -> string | number
        }

        Originals.__index    = hookmetamethod(Object, "__index"   , function(_, Key)
            return Key == "Banana" and "Hello " or 123
        end)

        Originals.__namecall = hookmetamethod(Object, "__namecall", function(_, Arg)
            return Arg == "Orange" and "World!" or 456
        end)

        assert(Object.Banana           == "Hello " and Object.Orange           == 123, "Failed to hook (__index)")
        assert(Object:OhTest("Orange") == "World!" and Object:OhTest("Banana") == 456, "Failed to hook (__namecall)")

        assert(Originals.__index   (nil, "Banana") == 123 and Originals.__index   (nil, "Orange") == "Hello ", "Failed to get original reference (__index)")
        assert(Originals.__namecall(nil, "Orange") == 456 and Originals.__namecall(nil, "Banana") == "World!", "Failed to get original reference (__namecall)")

        hookmetamethod(Object, "__index"   , Originals.__index)
        hookmetamethod(Object, "__namecall", Originals.__namecall)

        assert(Object.Banana           == 123 and Object.Orange           == "Hello ", "Failed to restore original reference (__index)")
        assert(Object:OhTest("Orange") == 456 and Object:OhTest("Banana") == "World!", "Failed to restore original reference (__namecall)")
    end)

    Test("getnamecallmethod", {}, {}, function()
        pcall(function()
            game:HelloWorld() 
        end)

        local Method = `{getnamecallmethod()}`
        assert(Method == "HelloWorld", `Failed to get __namecall method ("HelloWorld" expected, got "{Method}")`)

        return Method
    end)

    --// Closures //
    Test("hookfunction", {}, {"replaceclosure", "hookfunc"}, function(RealFunction: typeof(hookfunction))
        local Test = ({
            function(Arg)
                return Arg == "Hello " and "World!" or 456
            end
        })[1]

        local Original = RealFunction(Test, function(Arg)
            return Arg == "Hello " and 456 or "World!"
        end)

        assert(Test    ("Hello ") == 456      and Test    (123) == "World!", "Failed to hook function")
        assert(Original("Hello ") == "World!" and Original(123) == 456     , "Failed to get original reference")

        RealFunction(Test, Original)

        assert(Test("Hello ") == "World!" and Test(123) == 456, "Failed to restore original reference")
    end)

    Test("checkcaller", {}, {}, function()
        local IsCaller = checkcaller()
        assert(IsCaller == true, `Failed to check caller (true expected, got {tostring(IsCaller)}`)
    end)

    Test("getcallingscript", {}, {}, function()
        local Calling = getcallingscript() :: BaseScript & any

        if typeof(Calling) == "Instance" then
            assert(Calling:IsA("LocalScript"), `Failed to get calling script (LocalScript expected, got {Calling.ClassName})`)
            assert(not Calling:IsDescendantOf(game), `Failed to get calling script, your executor cannot execute scripts safely (FullName "" expected, got "{Calling:GetFullName()}")`)

            return GetShortName(`{Calling}`)
        elseif Calling ~= nil then
            assert(false, `Failed to get calling script, (Instance | nil expected, got {typeof(Calling)})`)
        end

        return "nil"
    end)

    --// Cache //
    Test("cloneref", {}, {"clonereference"}, function(RealFunction: typeof(cloneref))
        debug_profilebegin("[ExecutorSupport] [Instance I/O] cloneref")

        local Part = Instance_new("Part")
        table_insert(Garbages, function()
            Part:Destroy()
        end)

        local Cloned = RealFunction(Part) :: Part
        assert(Cloned ~= Part, "Failed to clone reference (clone is same as original)")

        Cloned.Name = "ClonedPart"
        assert(Part.Name == "ClonedPart", "Failed to get the real cloned reference")

        debug_profileend()
    end)

    --// Instance //
    Test("getconnections", {}, {"get_signal_cons"}, function(RealFunction: typeof(getconnections))
        local Returns = {
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

        -- Not using game.Close 'cause it's crashing on seliware 🥀🥀
        game.Changed:Once(function() end)
        local Connection = RealFunction(game.Changed)[1] :: any

        for Key, Type in Returns do
            assert(Connection[Key] ~= nil, `Failed to get connection property {Key}`)
            assert(typeof(Connection[Key]) == Type, `Failed to get connection property {Key} ({Type} expected, got {typeof(Connection[Key])})`)
        end
    end)

    Test("firesignal", {}, {}, function()
        debug_profilebegin("[ExecutorSupport] [Instance I/O] firesignal")

        local Event = Instance_new("BindableEvent")
        local Relay = Instance_new("BindableEvent")

        table_insert(Garbages, function()
            Event:Destroy()
            Relay:Destroy()
        end)

        Event.Event:Once(function(Received1: string, Received2: string)
            if Received1 == "Hello " and Received2 == "World!" then
                Relay:Fire(true)
            else
                Relay:Fire(false, `failed to receive arguments ("Hello World!" expected, got "{Received1} {Received2}")`)
            end
        end)

        task_delay(0, Relay.Fire, Relay, false, "timed out")
        task_spawn(firesignal, Event.Event, "Hello ", "World!")

        debug_profileend()
        local Response, Cause = Relay.Event:Wait()
        assert(Response, `Failed to fire signal ({Cause})`)
    end, function()
        local getconnections = (ExecutorSupport.getconnections and getconnections) :: typeof(getconnections)
        assert(getconnections)

        local Fire = getconnections(game.Changed)[1].Fire

        function Global.firesignal(Signal: RBXScriptSignal, ...: any)
            local Fire
                = Fire

            for _, Connection in getconnections(Signal) do
                Fire(Connection, ...)
            end
        end
    end)

    Test("fireproximityprompt", {}, {}, function()
        debug_profilebegin("[ExecutorSupport] [Instance I/O] fireproximityprompt")

        local Prompt = Instance_new("ProximityPrompt", shared.Workspace) :: any & Instance
        local Relay  = Instance_new("BindableEvent")

        table_insert(Garbages, function()
            Prompt:Destroy()
            Relay:Destroy()
        end)

        Prompt.Triggered:Once(function()
            Prompt = Prompt:Destroy()
            Relay:Fire(true)
        end)

        task_delay(0.1, Relay.Fire, Relay, false)
        task_spawn(fireproximityprompt, Prompt)

        debug_profileend()
        assert(Relay.Event:Wait() and Prompt == nil, "Failed to fire proximity prompt (timed out)")
    end, function()
        local firesignal = (ExecutorSupport.firesignal and firesignal) :: typeof(firesignal)
        assert(firesignal)

        local Speaker = shared.Speaker :: Player

        function Global.fireproximityprompt(Prompt: ProximityPrompt)
            local firesignal, Speaker
                = firesignal, Speaker

            if Prompt.HoldDuration == 0 then
                firesignal(Prompt.Triggered, Speaker)
                firesignal(Prompt.TriggerEnded, Speaker)
            else
                firesignal(Prompt.PromptButtonHoldBegan, Speaker)
                firesignal(Prompt.Triggered, Speaker)
                firesignal(Prompt.PromptButtonHoldEnded, Speaker)
                firesignal(Prompt.TriggerEnded, Speaker)
            end
        end
    end)

    Test("firetouchinterest", {}, {"firetouchtransmitter"}, function(RealFunction: typeof(firetouchinterest))
        -- nope 'cause firetouchinterest only works on FE BaseParts
    end, nil, true)

    Test("gethui", {}, {}, function()
        local HiddenUI = gethui()

        assert(typeof(HiddenUI) == "Instance", `Failed to get hidden UI (Instance expected, got {typeof(HiddenUI)})`)
        assert(HiddenUI:IsA("CoreGui") or HiddenUI:IsA("PlayerGui"), `Failed to get hidden UI (CoreGui | PlayerGui expected, got {HiddenUI.ClassName})`)

        local CoreGui = game:GetService("CoreGui")
        table_insert(Garbages, function()
            CoreGui = nil
        end)

        assert(HiddenUI ~= CoreGui and HiddenUI ~= shared.PlayerGui, "Failed to get hidden UI (useless)")
        return GetShortName(`{HiddenUI}`)
    end, function()
        local GarbageFunction
        local CanAccessCoreGui = pcall(function()
            local CoreGui = game:GetService("CoreGui")
            function GarbageFunction()
                CoreGui = nil
            end

            CoreGui:FindFirstChild("")
        end)

        GarbageFunction()

        local CoreGui = game:GetService("CoreGui")
        local Gui = CanAccessCoreGui and ExecutorSupport.cloneref and cloneref(CoreGui) or shared.PlayerGui

        CoreGui = nil

        function Global.gethui(): CoreGui | PlayerGui
            return Gui
        end

        -- These `CoreGui = nil` statements are to against anti-cheat,
        -- see https://github.com/ethanm2502/anti-coregui for details
    end)

    --// Environment //
    Test("require", {}, {}, function()
        debug_profilebegin("[ExecutorSupport] [Instance I/O] require")

        local      IsA,     require
            = game.IsA, wax.require

        for _, Object in game:GetDescendants() do
            if not IsA(Object, "ModuleScript") then continue end
            if require(Object) == nil then continue end

            return GetShortName(`{Object}`)
        end

        assert(false, "Failed to find an available module script (or require is broken)")

        debug_profileend()
    end)

    Test("getgc", {}, {}, function()
        local IsWorking = false

        local function Placeholder(...)
            --/ Just a placeholder
        end

        Placeholder("EpicFunction")

        for _, Garbage in getgc() do
            if Garbage ~= Placeholder then continue end

            IsWorking = true
            break
        end

        assert(IsWorking, "Failed to get a Garbage function")

        IsWorking   = false
        Placeholder = {} :: any

        for _, Garbage in getgc(true) do
            if Garbage ~= Placeholder then continue end

            IsWorking = true
            break
        end

        assert(IsWorking, "Failed to get a garbage table")
    end)

    --// Actors //
    shared.WorkingActors   = {}
    shared.GameUsingActors = false

    local function CommuniticationChannelTest()
        debug_profilebegin("[ExecutorSupport] [Instance I/O] CommuniticationChannelTest")

        local ChannelId, Event = create_comm_channel()

        assert(typeof(ChannelId) == "number" or typeof(ChannelId) == "string", `Failed to create a communitication channel (value #1: number | string expected, got {typeof(ChannelId)})`)
        assert(typeof(Event) == "Instance", `Failed to create a communitication channel (value #2: Instance expected, got {typeof(Event)})`)
        assert(Event:IsA("BindableEvent"), `Failed to create a communitication channel (value #2: BindableEvent expected, got {Event.ClassName})`)

        local Received = get_comm_channel(ChannelId)
        assert(Received == Event, "Failed to get the communitication channel")

        local Relay = Instance_new("BindableEvent")
        table_insert(Garbages, function()
            Relay:Destroy()
        end)

        Received.Event:Once(function()
            Relay:Fire(true)
        end)

        task_spawn(Event.Fire, Event)
        task_delay(0, Relay.Fire, Relay, false)

        debug_profileend()
        assert(Relay.Event:Wait(), "Failed to receive the communitication channel event (timed out)")
        return GetShortName(`{ChannelId}`)
    end

    Test("create_comm_channel", {"get_comm_channel"}, {}, CommuniticationChannelTest)
    Test("get_comm_channel", {"create_comm_channel"}, {}, CommuniticationChannelTest)

    Test("getactors", {"run_on_actor", "create_comm_channel", "get_comm_channel"}, {}, function()
        debug.profilebegin("[ExecutorSupport] [Instance I/O] getactors - 1")

        local      IsA, string_format, task_spawn, task_delay, Instance_new
            = game.IsA, string.format, task_spawn, task_delay, Instance_new

        local Actors = getactors()

        debug_profileend()

        local WorkingActors = {}
        local Wait = game.Close.Wait

        for Index, Actor in Actors do
            debug_profilebegin(`[ExecutorSupport] [Instance I/O] getactors - {Index + 1}`)

            assert(typeof(Actor) == "Instance" and IsA(Actor, "Actor"), `Failed to get a valid Actor Instance (got {typeof(Actor)})`)

            local ChannelId, Event = create_comm_channel()
            local Relay = Instance_new("BindableEvent")

            table_insert(Garbages, function()
                Relay:Destroy()
            end)

            Event.Event:Once(function(Success)
                Relay:Fire(Success)
            end)

            task_spawn(run_on_actor, Actors[1], string_format([[
                get_comm_channel(%*):Fire(pcall(function()
                    game.Close:ConnectParallel(function() end)
                end))
            ]], typeof(ChannelId) == "number" and ChannelId or `"{ChannelId}"`))

            task_delay(0, Relay.Fire, Relay, false)
            debug_profileend()

            if Wait(Relay.Event) then
                table_insert(WorkingActors, Actor)
            end
        end

        local Working = #WorkingActors

        shared.GameUsingActors = Working > 0
        shared.WorkingActors   = WorkingActors

        return GetShortName(`{Working} available`)
    end, function()
        local      IsA, table_insert
            = game.IsA, table_insert

        local Instances = {} :: array

        if getinstances then
            for _, Instance in getinstances() do
                table_insert(Instances, Instance)
            end
        else
            for _, Instance in game:GetDescendants() do
                table_insert(Instances, Instance)
            end

            if getnilinstances then
                for _, Instance in getnilinstances() do
                    table_insert(Instances, Instance)
                end
            end
        end

        local Actors = {}

        for _, Object in Instances do
            if not IsA(Object, "Actor") then continue end
            table_insert(Actors, Object)
        end

        function Global.getactors()
            return Actors
        end
    end)

    Test("run_on_actor", {"create_comm_channel", "get_comm_channel"}, {}, function()
        debug_profilebegin("[ExecutorSupport] [Instance I/O] run_on_actor")

        local ChannelId, Event = create_comm_channel()
        local Relay = Instance_new("BindableEvent")

        table_insert(Garbages, function()
            Relay:Destroy()
        end)

        Event.Event:Once(function()
            Relay:Fire(true)
        end)

        task_spawn(run_on_actor, Instance_new("Actor"), string.format([[
            pcall(function()
                get_comm_channel(%*):Fire(true)
            end)
        ]], typeof(ChannelId) == "number" and ChannelId or `"{ChannelId}"`))

        task_delay(0, Relay.Fire, Relay, false)
        debug_profileend()

        assert(Relay.Event:Wait(), "Failed to run on actor (timed out)")
    end)

    --// Miscellaneous //
    Test("queue_on_teleport", {}, {"queueonteleport", "table: syn key: queue_on_teleport", "table: fluxus key: queue_on_teleport"}, function(RealFunction: typeof(queue_on_teleport))
        local Success, Message = pcall(RealFunction :: any, "return 1")
        assert(Success, `Failed to queue on teleport due to {Message}`)
        -- There's only this much I can do
    end, nil, true)

    Test("toclipboard", {}, {"setclipboard", "write_clipboard", "setrbxclipboard", "table: syn key: write_clipboard", "table: Clipboard key: set"}, function(RealFunction: typeof(toclipboard))
        -- Cannot test, so just verify existence
    end, nil, true)

    Test("mousemoverel", {}, {}, function()
        -- Cannot test, so just verify existence
    end, nil, true)

    Test("Drawing", {}, {}, function()
        local Properties = {
            Color = "Color3",
            Filled = "boolean",
            NumSides = "number",
            -- Opacity = "number",
            Position = "Vector2",
            Radius = "number",
            Thickness = "number",
            Transparency = "number",
            Visible = "boolean",
            ZIndex = "number",
            Destroy = "function",
            -- MoveToBack = "function",
            -- MoveToFront = "function",
            Remove = "function"
        }

        local Circle: any = Drawing.new("Circle")
        table_insert(Garbages, function()
            Circle:Remove()
        end)

        for Property, Type in Properties do
            assert(typeof(Circle[Property]) == Type, `Failed to get property '{Property}' ({Type} expected, got {typeof(Circle[Property])})`)
        end

        assert(pcall(Circle.Remove, Circle), "Failed to remove the drawing")
    end)

    --// Summary //
    do
        --// SupportFileSystem
        local FileSystemSupport = 0

        for _, Function in {
            "makefolder",
            "isfolder",
            "delfolder",
            "writefile",
            "isfile",
            "readfile",
            "delfile"
        } do
            FileSystemSupport += ExecutorSupport[Function] and 1 or 0
        end

        ExecutorSupport.SupportFileSystem = FileSystemSupport == 7

        --// SupportActors
        local ActorsSupport = 0

        for _, Function in {
            "create_comm_channel",
            "get_comm_channel",
            "getactors",
            "run_on_actor"
        } do
            ActorsSupport += ExecutorSupport[Function] and 1 or 0
        end

        ExecutorSupport.SupportActors = ActorsSupport == 4
    end

    table_insert(OutputList, "----------------")
    table_insert(OutputList, `> 🛠️ Total working: {ExecutorSupport.TotalWorking}/{ExecutorSupport.TotalTestes}\n`)

    for _, Output in OutputList do
        print(Output)
    end
end

ExecutorSupport.Test    = Test
ExecutorSupport.TestAll = TestAll

function ExecutorSupport.OnTestCompletion(Callback: (
    Name:     string,
    Success:  boolean,
    Fixed:    boolean,
    Requires: hash,
    Ouput:    string
) -> ()): ()
    table_insert(OnTestCompletionCallback, Callback)
end

if ... == true then
    TestAll()
end

return ExecutorSupport
