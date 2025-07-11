-- This codegen template *not* be 100% compatible with Lua 5.1x+, MUST just Luau
-- With that being said, this aint explains the weird cflow in any parts

return [=[
-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Holds direct closure data
local ClosureBindings = ${ClosureBindings} :: ClosureBindings -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = ${ObjectTree} :: {ObjectDictionary}

type ClosureBindings  = {(table, table, table, Function, ...any) -> (...any)}
type ObjectDictionary = {number | {string} | {ObjectDictionary}}

-- Misc AOT variable imports
local WaxVersion = "${Version}"
local EnvName = "${EnvName}"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring
    = string, task, setmetatable, error, table, unpack, coroutine, script, type, require, pcall, xpcall, tostring

local shared: {[any]: any} = shared

local table_insert = table.insert
local table_remove = table.remove

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
--[[
    if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
        local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
        if RequireSuccess and LuneTaskLib then
            task = LuneTaskLib
        end
    end
--]]

local task_defer = task.defer

-- Will be used later for getting flattened globals
local ImportGlobals: (number) -> (table, table, Function)

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- shared __index/__newindex
local SharedEnvironment = {} :: any

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
        return
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
        return
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = "This metatable is locked"

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        return InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local Global_wax = {
    -- From AOT variable imports
    version = WaxVersion,
    envname = EnvName,

    shared = shared,

    -- "Real" globals instead of the env set ones
    script = script,
    require = require,

    argument = {...}
}

local function LoadScript(scriptRef, ...)
    local Args = {...}

    local function OnError()
        local Title = "Error Loading!"
        local Text  = "Would you like to unload?"

        local Bindable = Instance.new("BindableFunction")
        function Bindable.OnInvoke(Choice)
            if Choice ~= "Yes" then return end

            pcall(pcall, SharedEnvironment.Unload)

            local Global = getgenv and getgenv() or Global_wax.Global
            if Global then
                Global.MFeeeLoaded  = false
                Global.MFeeeLoading = false
            end

            if SharedEnvironment.ScreenGui then
                SharedEnvironment.ScreenGui:Destroy()
            end

            if shared.Connect then
                shared.Connect:DisconnectAll()
            end

            table.clear(Global_wax)
            table.clear(SharedEnvironment)
        end

        print(string.format("[%*] %* %*", EnvName, Title, Text))

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = Title,
            Text     = Text,
            Button1  = "Yes",
            Button2  = "No",
            Duration = (1 / 0),
            Callback = Bindable
        })
    end

    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(err)
        err = tostring(err)
        local VirtualFullName = scriptRef:GetFullName()

        -- Create a new error stack and process each line
        local newStack = {}
        for line in string_gmatch(err, "[^\n]+") do
            -- Look for error info lines with line numbers
            local filePath, lineNum, message = string_match(line, "^([^:]+):(%d+): (.+)$")

            if filePath and lineNum and message then
                -- Replace file path with virtual file path
                table_insert(newStack, VirtualFullName .. ":" .. lineNum .. ": " .. message)
            else
                -- Not a regular error line, keep as is
                table_insert(newStack, line)
            end
        end

        -- Join the processed error stack
        return table.concat(newStack, "\n    ")
    end

    local scriptRefId = ScriptClosureRefIds[scriptRef]
    if not scriptRefId then
        error("Error: scriptRefId not found in ScriptClosureRefIds! This script instance was not properly registered.", 2)
    end

    local wax, script, require = ImportGlobals(scriptRefId)

    -- Modify xpcall usage
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = xpcall(Closure, function(msg)
            return FormatError(debug.traceback(msg, 2))
        end, SharedEnvironment, wax, script, require, unpack(Args))

        if not RunSuccess then
            task_defer(OnError)
            error(ErrorMessage, 0) -- Use level 0 to directly throw the fully formatted error
        end
        return
    else
        -- Module script logic
        local PCallReturn
        local RunSuccess, ErrorMessage = xpcall(function(Args)
            PCallReturn = {Closure(SharedEnvironment, wax, script, require, unpack(Args))}
        end, function(msg)
            return FormatError(debug.traceback(msg, 2))
        end, Args)

        if not RunSuccess then
            task_defer(OnError)
            error(ErrorMessage, 0)
        end

        if ScriptClassName == "ModuleScript" then
            StoredModuleValues[scriptRef] = PCallReturn
        end

        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {xpcall(f, function(msg)
            return debug.traceback(msg, 2)
        end, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local Args = {...}
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module, unpack(Args))
        elseif ModuleArgType == "string" then
            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            elseif string_sub(module, 1, 6) == "@self/" then
                module = string_sub(module, 7)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    if PathMatch == ".." then
                        CurrentRefPointer = CurrentRefPointer.Parent
                        if not CurrentRefPointer then
                            error("Virtual script path \"" .. module .. "\" not found - attempt to go above root", 2)
                        end
                    else
                        local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                        if not ResultRef then
                            local CurrentRefParent = CurrentRefPointer.Parent
                            if CurrentRefParent then
                                ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                            end
                        end

                        if ResultRef then
                            CurrentRefPointer = ResultRef
                        elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                            error("Virtual script path \"" .. module .. "\" not found", 2)
                        end
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer, unpack(Args))
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in ScriptsToRun do
    task_defer(LoadScript, ScriptRef)
end
]=]
