-- MIT License | Copyright (c) 2023-2024 Latte Softworks <https://latte.to>

local stringsub,  stringmatch,  stringfind,  stringformat,  stringrep,  tableinsert,  tablefind
    = string.sub, string.match, string.find, string.format, string.rep, table.insert, table.find

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
        tableinsert(RefIds, instance)

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

        local RefId = tablefind(RefIds, instance)
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

                -- Helper function to parse the script and mark code, string, and comment regions
                local function BuildCodeRegions(Text)
                    local Regions = {} -- { {Type = "code"/"string"/"comment", Start = n, End = n}, ... }
                    local I = 1
                    local Len = #Text
                    local State = "code"
                    local RegionStart = 1
                    local StringQuote = nil
                    local LongStringEquals = nil

                    while I <= Len do
                        if State == "code" then
                            -- Single-line comment
                            if stringsub(Text, I, I+1) == "--" then
                                if stringsub(Text, I+2, I+3) == "[[" or stringmatch(stringsub(Text, I+2), "^%[(=*)%[") then
                                    -- Multi-line comment
                                    local _, eqs = stringmatch(stringsub(Text, I+2), "^(%[(=*)%[)")
                                    eqs = eqs or ""
                                    if RegionStart < I then
                                        tableinsert(Regions, {Type = "code", Start = RegionStart, End = I-1})
                                    end
                                    State = "longcomment"
                                    LongStringEquals = eqs
                                    RegionStart = I
                                    I = I + 2 + #eqs + 1
                                else
                                    -- Single-line comment
                                    if RegionStart < I then
                                        tableinsert(Regions, {Type = "code", Start = RegionStart, End = I-1})
                                    end
                                    State = "comment"
                                    RegionStart = I
                                    I = I + 2
                                end
                            -- Long string
                            elseif stringsub(Text, I, I) == "[" and stringmatch(stringsub(Text, I), "^%[(=*)%[") then
                                local _, eqs = stringmatch(stringsub(Text, I), "^(%[(=*)%[)")
                                eqs = eqs or ""
                                if RegionStart < I then
                                    tableinsert(Regions, {Type = "code", Start = RegionStart, End = I-1})
                                end
                                State = "longstring"
                                LongStringEquals = eqs
                                RegionStart = I
                                I = I + 1 + #eqs + 1
                            -- String literal
                            elseif stringsub(Text, I, I) == '"' or stringsub(Text, I, I) == "'" or stringsub(Text, I, I) == "`" then
                                StringQuote = stringsub(Text, I, I)
                                if RegionStart < I then
                                    tableinsert(Regions, {Type = "code", Start = RegionStart, End = I-1})
                                end
                                State = "string"
                                RegionStart = I
                                I = I + 1
                            else
                                I = I + 1
                            end
                        elseif State == "string" then
                            if stringsub(Text, I, I) == "\\" then
                                I = I + 2 -- skip escaped char
                            elseif stringsub(Text, I, I) == StringQuote then
                                I = I + 1
                                tableinsert(Regions, {Type = "string", Start = RegionStart, End = I-1})
                                RegionStart = I
                                State = "code"
                            else
                                I = I + 1
                            end
                        elseif State == "longstring" then
                            local closePat = "]" .. stringrep("=", #LongStringEquals) .. "]"
                            local closePos, _ = stringfind(Text, closePat, I, true)
                            if closePos then
                                I = closePos + #closePat
                                tableinsert(Regions, {Type = "string", Start = RegionStart, End = I-1})
                                RegionStart = I
                                State = "code"
                            else
                                break -- unterminated
                            end
                        elseif State == "comment" then
                            local nl = stringfind(Text, "\n", I, true)
                            if nl then
                                I = nl + 1
                                tableinsert(Regions, {Type = "comment", Start = RegionStart, End = nl-1})
                                RegionStart = I
                                State = "code"
                            else
                                tableinsert(Regions, {Type = "comment", Start = RegionStart, End = Len})
                                break
                            end
                        elseif State == "longcomment" then
                            local closePat = "]" .. stringrep("=", #LongStringEquals) .. "]"
                            local closePos, _ = stringfind(Text, closePat, I, true)
                            if closePos then
                                I = closePos + #closePat
                                tableinsert(Regions, {Type = "comment", Start = RegionStart, End = I-1})
                                RegionStart = I
                                State = "code"
                            else
                                break -- unterminated
                            end
                        end
                    end
                    if RegionStart <= Len then
                        tableinsert(Regions, {Type = State, Start = RegionStart, End = Len})
                    end
                    return Regions
                end

                -- Main function to find a 'whole word' match that is not inside a comment or string
                local function ContainsWholeWord(Text, Word)
                    local Regions = BuildCodeRegions(Text)
                    local WordLen = #Word
                    local TextLen = #Text
                    local StartIndex = 1

                    if type(Text) ~= "string" or type(Word) ~= "string" or WordLen == 0 then
                        return false
                    end

                    while true do
                        local FoundIndex = stringfind(Text, Word, StartIndex, true)
                        if not FoundIndex then
                            return false
                        end
                        local EndIndex = FoundIndex + WordLen - 1
                        local IsStartBoundary = (FoundIndex == 1) or (not stringmatch(stringsub(Text, FoundIndex - 1, FoundIndex - 1), "%w"))
                        local IsEndBoundary = (EndIndex == TextLen) or (not stringmatch(stringsub(Text, EndIndex + 1, EndIndex + 1), "%w"))
                        if IsStartBoundary and IsEndBoundary then
                            -- Check if this position is in a code region
                            for _, Region in Regions do
                                if Region.Type == "code" and FoundIndex >= Region.Start and EndIndex <= Region.End then
                                    return true
                                end
                            end
                        end
                        StartIndex = FoundIndex + 1
                    end
                end

                -- We're using `FunctionsReturnRaw` on LuaEncode later, this will set the return
                -- to the raw value, which is the script closure
                ClosureBindings[RefId] = function()
                    -- Silence unused variables
                    local UsesWax     = ContainsWholeWord(ScriptSource, "wax")
                    local UsesScript  = ContainsWholeWord(ScriptSource, "script")
                    local UsesRequire = ContainsWholeWord(ScriptSource, "require")

                    return stringformat([[
function()
local %s = __WaxImportGlobals(%d)

return (function()

%s
end)() end]],        `{UsesWax and "wax" or "_"}, {UsesScript and "script" or "_"}, {UsesRequire and "require" or "_"}` ,RefId, ScriptSource)
                end
            else
                local FirstLineOfError = stringmatch(tostring(CompileError), "%w* ?:%d*: ?([^\n]*)\n")
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
                    tableinsert(ObjectChildren, ChildObjectTree)
                end
            end

            InstanceObject[4] = ObjectChildren
        end

        return InstanceObject
    end

    for RealInstance, Children in ScrapedInstanceTree do
        local ChildObjectTree = CreateObjectTree(RealInstance, Children)

        if ChildObjectTree then
            tableinsert(ObjectTree, ChildObjectTree)
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
    RunIfVerbose(Log.Info, `Finished bundling model data in {stringformat("%.4f", ReadEndTime - ReadStartTime)} (seconds)`)

    local Prettify = if MinifyCodegen == false then true else false

    local SerializedObjectTree = LuaEncode(ObjectTree, {
        Prettify = Prettify,
        StackLimit = (1 / 0),
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
        for _, Ref in ModelRootChildren do
            if Ref.ClassName == "ModuleScript" and Ref.Name == "MainModule" then
                CodegenOutput ..= "\n-- AoT adjustment: Load init module (MainModule behavior)\nreturn LoadScript(RealObjectRoot.MainModule)"
                break
            end
        end
    end

    return CodegenOutput, FailedCompilations
end

return BundleModel
