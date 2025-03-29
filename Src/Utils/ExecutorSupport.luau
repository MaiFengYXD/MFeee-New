--// Prepere Environment //
local ExecutorSupport = {}

local function Test(Name: string, Function: any)
    local Support, Message = pcall(Function)
    ExecutorSupport[Name] = Support

    print(Support and `✅ [{Name}]` or `❌ [{Name}] - {Message}`)
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
    delfolder("MFeee~New.test")
    assert(isfolder("MFeee~New.test") == false, "Failed to delete a folder")
end)

--// Files
local function FileTest(Assert: string?)
    makefolder("MFeee~New.test")
    writefile("MFeee~New.test/Hello.txt", "Hello, World!")
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
        __index = newcclosure(function()
            return "Hello,"
        end),

        __metatble = "Locked!"
    })

    local Reference = hookmetamethod(Object, "__index", function()
        return " World!"
    end)

    assert(Object == " World!", "Failed to hook metamethod")
    assert(Reference() == "Hello,", "Failed to get reference")
end)

Test("getnamecallmethod", function()
    pcall(function()
        game:Hi()
    end)

    assert(getnamecallmethod() == "Hi", "Failed to get a namecall method")
end)

Test("hookfunction", function()
    local function Original()
        return "Hello,"
    end

    local Reference = hookfunction(Original, function()
        return " World!"
    end)

    assert(Original() == " World!", "Failed to hook function")
    assert(Reference() == "Hello,", "Failed to get reference")
    assert(Original ~= Reference, "New function should not be equal to the original")
end)

Test("getcallingscript", getcallingscript)

Test("checkcaller", checkcaller)

--// MISC //
Test("fireproximityprompt", function()
    local Prompt = Instance.new("ProximityPrompt", shared.Workspace)
    Prompt.Triggered:Once(function()
        Prompt = Prompt:Destroy()
    end)

    fireproximityprompt(Prompt)
    task.wait(0.1)

    assert(Prompt == nil, "Failed to fire proximity prompt")
end)

Test("require", function()
    local PlayerScripts = shared.Speaker:WaitForChild("PlayerScripts")

    local Start = os.clock()
    local Script = require(PlayerScripts:WaitForChild("PlayerModule", 5))
    local Delta = os.clock() - Start

    assert(Script, Delta < 5 and "Failed to require a module" or "Require time out, module is not loaded or your game removed it")
end)

Test("queue_on_teleport", function()
    shared.QueueTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport
    assert(type(getgenv()[shared.QueueTeleport]) == "function", "Seems like queue_on_teleport doesn't exist")
end)

Test("toclipboard", function()
    shared.ToClipboard = toclipboard or setclipboard or write_clipboard or setrbxclipboard or syn and syn.write_clipboard or Clipboard and Clipboard.set
    assert(type(getgenv()[shared.ToClipboard]) == "function", "Seems like toclipboard doesn't exist")
end)

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

for _, _ in next, FileSystem do
    if ExecutorSupport[FileSystem] then
        FileSystemSupport += 1
    end
end

ExecutorSupport.SupportFileSystem = FileSystemSupport == 8

return ExecutorSupport
