require("LiteralBlank")

local pcall, xpcall, error, type, print, string_find, string_sub, table_clear, table_insert, task_defer
    = pcall, xpcall, error, type, print, string.find, string.sub, table.clear, table.insert, task.defer

local Global = getgenv()

--// Prepare Environment //
local ExecutorSupport = {
    SupportFileSystem = false,
    TotalTestes       = 0,
    TotalWorking      = 0
}

local OutputList = {}
local Grabages   = {} :: {Function}

local function assert<T>(Assertion: T, Message: string?): (nil)
    --/ Set to 19998 for disabling traceback
    return if Assertion then nil else error(Message, 19998)
end

local function Test(
    Name:     string,
    Requires: {string?},
    Aliases:  {string?},
    TestFunction: (...any) -> (nil),
    Fix: ((nil) -> (nil)) | nil,
    CannotTest: boolean   | nil
): (nil)
    ExecutorSupport.TotalTestes += 1

    local Success:    boolean,
          TestResult: string?

    local IsFixable = type(Fix) == "function"

    local function GoSummary()
        for _, Function in Grabages do
            task_defer(pcall, Function)
        end

        local RealSuccess = Success or IsFixable

        ExecutorSupport[Name] = RealSuccess
        ExecutorSupport.TotalWorking += RealSuccess and 1 or 0

        table_insert(OutputList, `> {Success and (CannotTest and "⏺️" or "✅") or RealSuccess and "⚠️" or "❌"} [{Name}]{not Success and ` - {TestResult}` or ""}`)

        task_defer(table_clear, Requires)
        task_defer(table_clear, Aliases)
    end

    local function TryToFix(ErrorMessage: string): string?
        if not IsFixable then return ErrorMessage end

        local FixSuccess = pcall((Fix :: Function))
        IsFixable = FixSuccess

        return if FixSuccess then `{ErrorMessage}, but it can be fixed` else ErrorMessage
    end

    local RequirementValidated = true

    for _, Requirement in Requires do
        if type(Global[Requirement]) == "function" then continue end

        RequirementValidated = false
        Success    = false
        TestResult = `Missing requirement '{Requirement}'`
        break
    end

    if not RequirementValidated then
        return GoSummary()
    end

    local RealFunction = Global[Name]
    local UsesAlias    = false

    if not RealFunction then
        for _, Alias in (Aliases :: {string}) do
            local _, Table = string_find(Alias, "table: ")
            local Key      = string_find(Alias, "key: ")

            if Table and Key then
                local TableName = string_sub(Alias, Table + 1, Key - 2)
                local KeyName   = string_sub(Alias, Key + 5)

                local TableFunction = if type(Global[TableName]) == "table" then Global[TableName][KeyName] else nil
                RealFunction = if type(TableFunction) == "function" then TableFunction else nil

                if not RealFunction then continue
                else break end
            end

            if type(Global[Alias]) ~= "function" then continue end

            RealFunction = Global[Alias]
            break
        end

        if not RealFunction then
            Success    = false
            TestResult = TryToFix(`Missing function '{Name}' and its aliases`) :: string

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

table_insert(OutputList, "----------------")

--// File System //
local TestFolder = "MFeee-New/.test"
local TestFile   = `{TestFolder}/test.txt`

local function CleanFolder()
    delfolder(TestFolder)
end

--// Folder
Test("makefolder", {"isfolder"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    assert(isfolder(TestFolder), "Folder not created")
end)

Test("isfolder", {"makefolder"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    assert(isfolder(TestFolder), "Folder existence check failed")
end)

Test("delfolder", {"makefolder", "isfolder"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    delfolder(TestFolder)
    assert(isfolder(TestFolder) == false, "Folder deletion failed")
end)

--// File
Test("writefile", {"makefolder", "readfile"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    writefile(TestFile, "Hello, World!")
    assert(readfile(TestFile) == "Hello, World!", "File content mismatch")
end)

Test("isfile", {"makefolder", "writefile"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    writefile(TestFile, "Hello, World!")
    assert(isfile(TestFile), "File existence check failed")
end)

Test("readfile", {"makefolder", "writefile"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    writefile(TestFile, "Hello, World!")
    assert(readfile(TestFile) == "Hello, World!", "File content mismatch")
end)

Test("delfile", {"makefolder", "writefile"}, {}, function()
    table_insert(Grabages, CleanFolder)
    makefolder(TestFolder)
    writefile(TestFile, "Hello, World!")
    delfile(TestFile)
    assert(isfile(TestFile) == false, "File deletion failed")
end)

--// Metatable //
Test("hookmetamethod", {}, {}, function()
    local Object    = newproxy(true)
    local MetaTable = getmetatable(Object)

    table_insert(Grabages, function()
        Object, MetaTable = nil, nil
    end)

    --// Original meta methods
    MetaTable.__index = function(_, Key)
        return Key == "Banana" and 123 or "Hello "
    end

    MetaTable.__namecall = function(_, Arg)
        return Arg == "Orange" and 456 or "World!"
    end

    local Originals = {} :: {
        ["__index"   ]: (any, Key: string?) -> string | number,
        ["__namecall"]: (any, Arg: string?) -> string | number
    }

    --// Hook and store references from the original meta method
    Originals.__index    = hookmetamethod(Object, "__index"   , function(_, Key)
        return Key == "Banana" and "Hello " or 123
    end)

    Originals.__namecall = hookmetamethod(Object, "__namecall", function(_, Arg)
        return Arg == "Orange" and "World!" or 456
    end)

    --// Test hooked meta methods
    assert(Object.Banana           == "Hello " and Object.Orange           == 123, "Failed to hook (__index)")
    assert(Object:OhTest("Orange") == "World!" and Object:OhTest("Banana") == 456, "Failed to hook (__namecall)")

    --// Test original references
    assert(Originals.__index   (nil, "Banana") == 123 and Originals.__index   (nil, "Orange") == "Hello ", "Failed to get original reference (__index)")
    assert(Originals.__namecall(nil, "Orange") == 456 and Originals.__namecall(nil, "Banana") == "World!", "Failed to get original reference (__namecall)")

    --// Hook back original meta methods and test again
    hookmetamethod(Object, "__index"   , Originals.__index)
    hookmetamethod(Object, "__namecall", Originals.__namecall)

    assert(Object.Banana           == 123 and Object.Orange           == "Hello ", "Failed to restore original reference (__index)")
    assert(Object:OhTest("Orange") == 456 and Object:OhTest("Banana") == "World!", "Failed to restore original reference (__namecall)")
end)

Test("getnamecallmethod", {}, {}, function()
    pcall(function()
        game:HelloWorld() 
    end)

    local Method = tostring(getnamecallmethod())

    assert(Method == "HelloWorld", `Failed to get __namecall method (expected 'HelloWorld', got '{Method}')`)
end)

--// Closures //
Test("hookfunction", {}, {"replaceclosure", "hookfunc"}, function(RealFunction: ((Function, Function) -> Function))
    local Test = ({
        function(Arg)
            return Arg == "Hello " and "World!" or 456
        end
    })[1]

    --// Hook function and store reference to the original function
    local Original = RealFunction(Test, function(Arg)
        return Arg == "Hello " and 456 or "World!"
    end)

    assert(Test    ("Hello ") == 456      and Test    (123) == "World!", "Failed to hook function")
    assert(Original("Hello ") == "World!" and Original(123) == 456     , "Failed to get original reference")

    --// Hook back the original function and test again
    RealFunction(Test, Original)

    assert(Test("Hello ") == "World!" and Test(123) == 456, "Failed to restore original reference")
end)

Test("checkcaller", {}, {}, function()
    local IsCaller = checkcaller()
    assert(IsCaller == true, `Failed to check caller (expected true, got {tostring(IsCaller)}`)
end)

Test("getcallingscript", {}, {}, function()
    local Calling = getcallingscript()
    assert(Calling == nil, `Failed to get calling script (expected nil, got {typeof(Calling) == "Instance" and Calling:GetFullName() or tostring(Calling)})`)
end)

--// Cache //
Test("cloneref", {}, {"clonereference"}, function()
    local Part = Instance.new("Part")
    table_insert(Grabages, function()
        Part:Destroy()
    end)

    local Cloned = cloneref(Part) :: Part

    assert(Cloned ~= Part, "Failed to clone reference (clone is same as original)")

    Cloned.Name = "ClonedPart"
    assert(Part.Name == "ClonedPart", "Failed to get cloned reference")
end)

Test("iscached", {}, {"table: cache key: iscached"}, function()
    local Part = Instance.new("Part")
    table_insert(Grabages, function()
        Part:Destroy()
    end)

    assert(cache.iscached(Part), "Failed to check if part is cached")
    cache.invalidate(Part)
    assert(not cache.iscached(Part), "Failed to invalidate cache for part")
end)

--// Instance //
Test("getconnections", {}, {"get_signal_cons"}, function(RealFunction: (RBXScriptConnection) -> Table)
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

    --// Create a RBXScriptConnection and get its connections
    game.ChildAdded:Once(function() end)
    local Connection = RealFunction(game.ChildAdded)[1]

    for Key, Type in Returns do
        assert(Connection[Key] ~= nil, `Failed to get connection property {Key}`)
        assert(type(Connection[Key]) == Type, `Failed to get connection property {Key} (expected '{Type}', got '{type(Connection[Key])}')`)
    end
end)

Test("fireproximityprompt", {}, {}, function()
    local Prompt = Instance.new("ProximityPrompt", shared.Workspace) :: any & Instance

    local function DestroyPrompt()
        Prompt = Prompt:Destroy()
    end

    table_insert(Grabages, DestroyPrompt)
    Prompt.Triggered:Once(DestroyPrompt)

    fireproximityprompt(Prompt)

    task.wait(0.1)
    assert(Prompt == nil, "Failed to fire proximity prompt")
end, function()
    local      IsA,            Once, shared
        = game.IsA, game.Close.Once, shared

    local InputHoldBegin, InputHoldEnd;do
        local Prompt = Instance.new("ProximityPrompt")

        InputHoldBegin = Prompt.InputHoldBegin
        InputHoldEnd   = Prompt.InputHoldEnd

        Prompt:Destroy()
    end

    local Firing = {}
    local Inf    = (1 / 0)

    function Global.fireproximityprompt(Prompt: ProximityPrompt, Distance: number): boolean
        local Success, Result = xpcall(function()
            if Firing[Prompt] then return false end

            assert((Prompt :: any) ~= nil, "missing argument #1 to 'fireproximityprompt' (userdata expected)")
            assert(type(Prompt) == "userdata", `invalid argument #1 to 'fireproximityprompt' (userdata expected, got {type(Prompt)})`)
            assert(IsA(Prompt, "ProximityPrompt"), `invalid argument #1 to 'fireproximityprompt' (expected ProximityPrompt, got {Prompt.ClassName})`)

            Firing[Prompt] = true

            if type(Distance) ~= "number" or not shared.Speaker.Character or Distance ~= Distance then
                Distance = Inf
            end

            local PreDuration = Prompt.HoldDuration
            local PreDistance = Prompt.MaxActivationDistance
            local PreNoclip   = Prompt.RequiresLineOfSight

            Prompt.HoldDuration = 0
            Prompt.MaxActivationDistance = Distance
            Prompt.RequiresLineOfSight   = false

            Once(Prompt.Triggered, function()
                InputHoldEnd(Prompt)

                Prompt.HoldDuration          = PreDuration
                Prompt.MaxActivationDistance = PreDistance
                Prompt.RequiresLineOfSight   = PreNoclip

                Firing[Prompt] = nil
            end)

            InputHoldBegin(Prompt)
            return true
        end, function(Message)
            Firing[Prompt] = nil
            error(Message, 2)
        end)

        return if Success then Result else false
    end
end)

Test("firetouchinterest", {}, {"firetouchtransmitter"}, function(RealFunction: (Part1: BasePart, Part2: BasePart, State: number) -> nil)
    --/ nope cause firetouchinterest only works on server-side BasePart
end, nil, true)

Test("gethui", {}, {}, function()
    local HiddenUi = gethui()

    assert(typeof(HiddenUi) == "Instance", `Failed to get hidden UI (expected type 'Instance', got type '{typeof(HiddenUi)}')`)
    assert(HiddenUi:IsA("CoreGui") or HiddenUi:IsA("PlayerGui"), `Failed to get hidden UI (expected class 'CoreGui' or 'PlayerGui', got class '{HiddenUi.ClassName}')`)
    assert(HiddenUi ~= game:GetService("CoreGui") and HiddenUi ~= shared.PlayerGui, "Failed to get hidden UI (useless)")
end, function()
    local CanAccessCoreGui = pcall(function()
        local CoreGui = game:GetService("CoreGui")
        CoreGui:FindFirstChild("")
    end)
    local Gui = ExecutorSupport.cloneref and cloneref(
        CanAccessCoreGui and game:GetService("CoreGui") or shared.PlayerGui
    ) or shared.PlayerGui

    function Global.gethui(): CoreGui | PlayerGui
        return Gui
    end
end)

--// Environment //
Test("require", {}, {}, function()
    local      IsA,     require
        = game.IsA, wax.require

    for _, Object in game:GetDescendants() do
        if not IsA(Object, "ModuleScript") then continue end
        if require(Object) == nil then continue end

        return
    end

    assert(false, "Failed to find an available module script (or require is broken)")
end)

Test("getgc", {}, {}, function()
    local IsWorking = false

    local function Placeholder()
        --/ Just a placeholder
    end

    for _, Garbage in getgc() do
        if Garbage == Placeholder then
            IsWorking = true
            break
        end
    end

    assert(IsWorking, "Failed to get a grabage function")

    IsWorking = false
    Placeholder = {} :: any

    for _, Garbage in getgc(true) do
        if Garbage == Placeholder then
            IsWorking = true
            break
        end
    end

    assert(IsWorking, "Failed to get a garbage table")
end)

--// Miscellaneous //
Test("queue_on_teleport", {}, {"queueonteleport", "table: syn key: queue_on_teleport", "table: fluxus key: queue_on_teleport"}, function(RealFunction: (string) -> nil)
    xpcall(RealFunction, function(Message)
        return assert(false, `Failed to queue on teleport due to {Message}`)
    end, "return 1")
    --/ There's only this much I can do
end, nil, true)

Test("toclipboard", {}, {"setclipboard", "write_clipboard", "setrbxclipboard", "table: syn key: write_clipboard", "table: Clipboard key: set"}, function(RealFunction: (string) -> nil)
    --/ nope cause it involves managing the user's clipboard (it may be impolite and cannot verify if it works)
end, nil, true)

Test("mousemoverel", {}, {}, function()
    --/ idk
end, nil, true)

Test("Drawing", {}, {}, function()
    local typeof
        = typeof

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
    table_insert(Grabages, function()
        Circle:Remove()
    end)

    for Property, Type in Properties do
        assert(typeof(Circle[Property]) ~= "string", `Failed to get property '{Property}' (got unexpected type string)`)
        assert(typeof(Circle[Property]) == Type, `Failed to get property '{Property}' (expected type '{Type}', got type '{typeof(Circle[Property])}')`)
    end

    xpcall(Circle.Remove, function()
        assert(false, "Failed to test")
    end, Circle)
end)

--// Summary //
do
    local FileSystem = {
        "makefolder",
        "isfolder",
        "delfolder",
        "writefile",
        "isfile",
        "readfile",
        "delfile"
    }

    local FileSystemSupport = 0

    for _, Function in FileSystem do
        FileSystemSupport += ExecutorSupport[Function] and 1 or 0
    end

    ExecutorSupport.SupportFileSystem = FileSystemSupport == #FileSystem
end

table_insert(OutputList, "----------------")
table_insert(OutputList, `> 🛠️ Total working: {ExecutorSupport.TotalWorking}/{ExecutorSupport.TotalTestes}\n`)

for _, Output in OutputList do
    print(Output)
end

return ExecutorSupport
