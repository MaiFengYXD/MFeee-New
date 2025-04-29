-- MIT License | Copyright (c) 2023-2024 Latte Softworks <https://latte.to>

local luau = require("@lune/luau")
local roblox = require("@lune/roblox")

local LuneUtils = require("Libraries/LuneUtils")

local Log = LuneUtils.Log
local StringUtils = LuneUtils.StringUtils

local LuaEncode = require("Libraries/LuaEncode")

local Version = require("Data/Version")

-- Init script template for codegen (in this, we'll maintain 5.1 *syntax* compat
-- for optional compilation to vanilla Lua 5.1x bytecode format)
local InitScriptTemplate = require("Data/Template")

-- The line where the 1st closure's function will start in bundled codegen
local InitialLineOffset = 8

local ClassNameIdKeys = {
    Folder = 1,
    ModuleScript = 2,
    Script = 3,
    LocalScript = 4,
    StringValue = 5,
}

-- Building codegen directly from model data (from .rbxm/.rbxmx) or a deserialized
-- object using Lune's `roblox` library
local function BundleModel(modelData: string | {roblox.Instance}, envName: string?, minifyCodegen: boolean?, extraLinesToOffset: number?, verbose: boolean?): (string, number)
    local EnvName = envName or "WaxRuntime"
    local MinifyCodegen = if minifyCodegen == nil then true else minifyCodegen
    local ExtraLinesToOffset = extraLinesToOffset or 0
    local Verbose = if verbose == nil then true else verbose

    -- Same as in Wax CLI
    local function RunIfVerbose(f, ...)
        if Verbose then
            f(...)
        end
    end

    local LineDebugging = MinifyCodegen == false

    local ModelRoot = if type(modelData) == "string" then
        roblox.deserializeModel(modelData)
    else modelData

    -- We'll track how long it takes for us to read the entire object tree, with all
    -- other various processes included
    local ReadStartTime = os.clock()

    local FailedCompilations = 0

    -- We'll initialize the output object tree, then walk through what we need to
    local ObjectTree = {}
    local ClosureBindings = {} -- [RefId] = Closure
    local ClosureSourceLineCounts = {} -- [RefId] = LineCount

    local ScrapedInstanceTree = {} -- [RealRef] = {Child, ...}
    local RefIds = {} -- [RefId] = RealRef

    -- Recursive function to actually walk through the real instance tree, and assign refs
    local function ScrapeInstanceChildren(instance)
        -- Add a reference id for this instance
        table.insert(RefIds, instance)

        local ScrapedChildren = {}
        for _, Child in instance:GetChildren() do
            ScrapedChildren[Child] = ScrapeInstanceChildren(Child)
        end

        return ScrapedChildren
    end

    -- Initialize the scraped instance tree and assign all refs from root
    local ModelRootChildren = ModelRoot -- Using later aswell
    for _, RealInstance in ModelRootChildren do
        ScrapedInstanceTree[RealInstance] = ScrapeInstanceChildren(RealInstance)
    end

    -- Now, we'll recursively create the fake object tree
    local function CreateObjectTree(instance, children, currentPathString: string?)
        currentPathString = currentPathString or instance.Name

        local RefId = table.find(RefIds, instance)
        local ClassName = instance.ClassName

        local ClassNameId = ClassNameIdKeys[ClassName]
        if not ClassNameId then
            Log.Warn(`Skipping instance of ClassName "{ClassName}", as it isn't supported in bundling`)
            return
        end

        local InstanceIsABaseScript = ClassName == "LocalScript" or ClassName == "Script"
        local InstanceIsAScript = InstanceIsABaseScript or ClassName == "ModuleScript"

        --[[
            {
                [1] = RefId,
                [2] = ClassName,
                [3] = Properties,
                [4] = Children?
            }
        ]]

        local InstanceObject = {
            [1] = RefId,
            [2] = ClassNameId,
        }

        -- If it's statically disabled, we just won't include the closure to run
        if InstanceIsAScript and not (InstanceIsABaseScript and instance.Disabled) then
            local ScriptSource = instance.Source

            RunIfVerbose(Log.Info, `Compile-checking {instance.ClassName} "{currentPathString}"..`)
            local CompileSuccess, CompileError = pcall(luau.compile, ScriptSource)

            if CompileSuccess then
                -- The added line here is the "\nend" below every arbitrary closure
                ClosureSourceLineCounts[RefId] = StringUtils.LineCount(ScriptSource) + 1

                -- Helper function to perform heuristic checks for comments and strings on the line of the found word
                local function IsLikelyInCommentOrString(FullText, WordStartIndex)
                    -- Find the start and end positions of the line containing the word
                    local LineStartPos = 1
                    -- Efficiently search backwards for the previous newline character
                    for I = WordStartIndex - 1, 1, -1 do
                        if string.sub(FullText, I, I) == "\n" then
                            LineStartPos = I + 1
                            break
                        end
                    end

                    local LineEndPos = string.find(FullText, "\n", WordStartIndex, true)
                    if not LineEndPos then
                        LineEndPos = #FullText + 1 -- Use end of the full text if no newline is found after the word
                    end

                    -- Extract the content of the current line
                    local CurrentLine = string.sub(FullText, LineStartPos, LineEndPos - 1)
                    -- Calculate the word's starting position relative to the beginning of the current line
                    local WordIndexInLine = WordStartIndex - LineStartPos + 1

                    -- 1. Check for single-line comment marker '--' appearing before the word on the current line
                    local CommentMarkerPos = string.find(CurrentLine, "--", 1, true)
                    if CommentMarkerPos and CommentMarkerPos < WordIndexInLine then
                        -- If '--' is found, check if it's the start of a multi-line comment '--[['
                        -- If it's not a multi-line comment start, the word is likely in a single-line comment
                        if not string.match(CurrentLine, "^%-%-%[", CommentMarkerPos) then
                            return true -- Likely inside a single-line comment
                        end
                        -- Note: This heuristic doesn't reliably handle cases where the word is within
                        -- a multi-line comment block that started on a previous line.
                    end

                    -- 2. Check if the word is inside a string literal by tracking quote status
                    --    Iterate through the line up to the character before the word starts
                    local SubLineBeforeWord = string.sub(CurrentLine, 1, WordIndexInLine - 1)
                    local InString = false
                    local CurrentQuote = nil -- Stores the type of quote ('"', "'", "`") that opened the current string
                    local Escaped = false
                    for I = 1, #SubLineBeforeWord do
                        local Char = string.sub(SubLineBeforeWord, I, I)
                        -- Handle backslash escape character
                        if Char == '\\' and not Escaped then
                            Escaped = true
                        else
                            if CurrentQuote then -- Currently inside a string literal
                                -- Check if the current character closes the string (and is not escaped)
                                if Char == CurrentQuote and not Escaped then
                                    InString = false
                                    CurrentQuote = nil
                                end
                            else -- Not currently inside a string literal
                                -- Check if the current character starts a string literal (and is not escaped)
                                if (Char == '"' or Char == '\'' or Char == '`') and not Escaped then
                                    InString = true
                                    CurrentQuote = Char
                                end
                            end
                            -- Reset escape status after processing the character
                            Escaped = false
                        end
                    end

                    -- If the loop finishes while still inside a string, the word starts within that string
                    if InString then
                        return true -- Likely inside a string literal
                    end

                    -- Note: This heuristic doesn't handle Luau's multi-line strings like [=[...]=]

                    -- If neither comment nor string heuristics matched, assume it's likely code
                    return false
                end

                -- Main function to find a 'whole word' match that is likely not inside a comment or string literal
                local function ContainsWholeWord(Text, Word)
                    local WordLen = #Word
                    local TextLen = #Text
                    local StartIndex = 1 -- Start searching from the beginning of the text

                    -- Basic input validation
                    if type(Text) ~= "string" or type(Word) ~= "string" or WordLen == 0 then
                        return false
                    end

                    -- Loop to find all occurrences of the word
                    while true do
                        -- Find the next occurrence of the word (case-sensitive, plain search)
                        local FoundIndex = string.find(Text, Word, StartIndex, true)

                        -- If no more occurrences are found, return false
                        if not FoundIndex then
                            return false
                        end

                        local EndIndex = FoundIndex + WordLen - 1

                        -- Check for word boundaries:
                        -- The character before the word (if it exists) must not be a 'word' character (%w: alphanumeric or underscore)
                        local IsStartBoundary = (FoundIndex == 1) or (not string.match(string.sub(Text, FoundIndex - 1, FoundIndex - 1), "%w"))
                        -- The character after the word (if it exists) must not be a 'word' character (%w)
                        local IsEndBoundary = (EndIndex == TextLen) or (not string.match(string.sub(Text, EndIndex + 1, EndIndex + 1), "%w"))

                        -- If both start and end boundaries are valid
                        if IsStartBoundary and IsEndBoundary then
                            -- Perform heuristic checks to see if the found word is likely inside a comment or string
                            if not IsLikelyInCommentOrString(Text, FoundIndex) then
                                -- If the heuristics suggest it's not in a comment or string, we found a valid match
                                return true
                            end
                        end

                        -- If boundaries were invalid, or if heuristics indicated comment/string,
                        -- continue the search starting from the character *after* the current found index.
                        -- This prevents getting stuck on the same invalid match.
                        StartIndex = FoundIndex + 1
                    end
                end

                -- We're using `FunctionsReturnRaw` on LuaEncode later, this will set the return
                -- to the rew value, which is the script closure
                ClosureBindings[RefId] = function()
                    -- Here's a little change because luau-lsp makes me do this:sob:
                    -- Let's silence unused variables
                    local UsesWax     = ContainsWholeWord(ScriptSource, "wax")
                    local UsesScript  = ContainsWholeWord(ScriptSource, "script")
                    local UsesRequire = ContainsWholeWord(ScriptSource, "require")
                    return ("function()\nlocal %s = ImportGlobals(%d)\n\nlocal ImportGlobals = nil\nlocal _ = ImportGlobals\n\nreturn (function()\n\n%s\nend)() end")
                           :format(`{UsesWax and "wax" or "_"}, {UsesScript and "script" or "_"}, {UsesRequire and "require" or "_"}`, RefId, ScriptSource)
                end
            else
                local FirstLineOfError = string.match(tostring(CompileError), "%w* ?:%d*: ?([^\n]*)\n")
                Log.Warn(`WARNING: {instance.ClassName} "{currentPathString}" failed to compile: {FirstLineOfError or "[Failed to parse compiler error]"}`)
                FailedCompilations += 1

                ClosureSourceLineCounts[RefId] = 1 -- Guaranteed 1 line; see below lol

                ClosureBindings[RefId] = function()
                    return `function()error("[AOT COMPILER ERROR] {StringUtils.SerializeStringData(FirstLineOfError)}")end`
                end
            end
        end

        -- Add any properties
        local Properties = {[1] = instance.Name} -- For byte preservation (lol) the name is just set as the property index 1, and not "Name"

        if ClassName == "StringValue" then
            Properties.Value = instance.Value
        end

        -- The init script will assume the `Name` is the same as the `ClassName` if not included
        if instance.Name ~= ClassName then
            InstanceObject[3] = Properties
        end

        -- Recursively add children
        if next(children) then
            local ObjectChildren = {}

            for Child, ChildrenOfChild in children do
                local ChildObjectTree = CreateObjectTree(Child, ChildrenOfChild, `{currentPathString}.{Child.Name}`)
                if ChildObjectTree then
                    table.insert(ObjectChildren, ChildObjectTree)
                end
            end

            InstanceObject[4] = ObjectChildren
        end

        return InstanceObject
    end

    for RealInstance, Children in ScrapedInstanceTree do
        local ChildObjectTree = CreateObjectTree(RealInstance, Children)

        if ChildObjectTree then
            table.insert(ObjectTree, ChildObjectTree)
        end
    end

    local LineOffsets = {}
    if LineDebugging then
        -- Where the first closure func start should be
        local CurrentLineOffset = ExtraLinesToOffset + InitialLineOffset

        for RefId, LineCount in ClosureSourceLineCounts do
            LineOffsets[RefId] = CurrentLineOffset
            CurrentLineOffset += LineCount
        end
    end

    -- Now we're done reading everything!
    local ReadEndTime = os.clock()
    RunIfVerbose(Log.Info, `Finished bundling model data in {string.format("%.4f", ReadEndTime - ReadStartTime)} (seconds)`)

    local Prettify = if MinifyCodegen == false then true else false

    local SerializedObjectTree = LuaEncode(ObjectTree, {
        Prettify = Prettify,
        StackLimit = math.huge,
    })

    local SerializedClosureBindings = LuaEncode(ClosureBindings, {
        Prettify = Prettify,
        FunctionsReturnRaw = true, -- For Script.Source function closures
    })

    local SerializedLineOffsets = if not LineDebugging then
        "nil"
    else
        LuaEncode(LineOffsets, {
            Prettify = Prettify,
        })

    local CodegenOutput = StringUtils.Replace(InitScriptTemplate, {
        Version = StringUtils.SerializeStringData(Version),
        EnvName = StringUtils.SerializeStringData(EnvName),
        ObjectTree = SerializedObjectTree,
        ClosureBindings = SerializedClosureBindings,
        LineOffsets = SerializedLineOffsets,
    })

    -- If there's a top-level init modulescript, we'll return it from the output's closure directly
    -- It's better to impl this all AoT!
    if #ModelRootChildren == 1 and ModelRootChildren[1].ClassName == "ModuleScript" then
        CodegenOutput ..= "\n-- AoT adjustment: Load init module (MainModule behavior)\nreturn LoadScript(RealObjectRoot:GetChildren()[1])"
    else
        for _, Ref in next, ModelRootChildren do
            if Ref.ClassName == "ModuleScript" and Ref.Name == "MainModule" then
                CodegenOutput ..= "\n-- AoT adjustment: Load init module (MainModule behavior)\nreturn LoadScript(RealObjectRoot.MainModule)"
                break
            end
        end
    end

    return CodegenOutput, FailedCompilations
end

return BundleModel
