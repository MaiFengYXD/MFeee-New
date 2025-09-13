local setmetatable, type, assert, table_clone, table_clear, pcall
    = setmetatable, type, assert, table.clone, table.clear, pcall

local HttpService = shared.HttpService
local JSONEncode  = HttpService.JSONEncode
local JSONDecode  = HttpService.JSONDecode

local FileHelper = shared.FileHelper
local WriteFile  = FileHelper.WriteFile
local IsFile     = FileHelper.IsFile

type ConfigManager = {
    new: (Index: string, Default: hash | nil, RelativePath: string?) -> ConfigInstance,
    Get: (self: ConfigInstance, Key: string) -> any,
    Set: (self: ConfigInstance, Key: string, Value: any) -> (),

    Initialize: (self: ConfigInstance, Relativepath: string?) -> (),
    Save:       (self: ConfigInstance, RelativePath: string?) -> (),
    Load:       (self: ConfigInstance, RelativePath: string?) -> (),

    Replace: (self: ConfigInstance, NewConfig: hash) -> (),
    Merge:   (self: ConfigInstance, NewConfig: hash, Priority: "New" | "Current") -> (),
    Clear:   (self: ConfigInstance) -> (),

    FindConfig: (Index: string) -> ConfigInstance?,

    Instances: {[string]: ConfigInstance},
    __index:   ConfigManager
}

type ConfigInstance = typeof(setmetatable({
    __index = {} :: hash,
    Default = {} :: hash,

    Config = setmetatable({}, {
        __index    = {} :: hash,
        __newindex = function(_, Key: string, Value: any): () end
    }),

    DefaultConfigPath = nil  :: string?,
    AutoSaveEnabled   = true :: boolean
}, {
    __index = {} :: ConfigManager
}))

local Instances = {} :: {[string]: ConfigInstance}

local Config = {} :: ConfigManager;do
    Config.Instances = Instances

    local function TryToAutoSave(self: ConfigInstance): ()
        if self.AutoSaveEnabled then
            self:Save()
        end
    end

    local function ValidatePath(self: ConfigInstance, RelativePath: string?): string | never
        local DefaultPath = type(self.DefaultConfigPath) == "string" and self.DefaultConfigPath or nil
        local Path = RelativePath or DefaultPath
        assert(Path, "No path provided to save config")

        return Path
    end

    Config.__index = Config

    function Config.new(Index: string, Default: hash | nil, RelativePath: string?): ConfigInstance
        local self = setmetatable({
            __index = type(Default) == "table" and table_clone(Default :: hash) or {},
            Default = type(Default) == "table" and Default or {},

            DefaultConfigPath = type(RelativePath) == "string" and RelativePath or nil,
            AutoSaveEnabled   = true
        }, Config)

        self.Config = setmetatable({}, {
            __index    = self.__index,
            __newindex = function(_, Key: string, Value: any)
                self:Set(Key, Value)
            end
        })

        self:Initialize()
        self:Load()

        Instances[Index] = self
        return self
    end

    function Config.Get(self: ConfigInstance, Key: string): any
        return self.__index[Key]
    end

    function Config.Set(self: ConfigInstance, Key: string, Value: any): ()
        self.__index[Key] = Value
        TryToAutoSave(self)
    end

    function Config.Initialize(self: ConfigInstance, RelativePath: string?): ()
        local Path    = ValidatePath(self, RelativePath)
        local Content = IsFile(FileHelper, Path)

        if Content == false or not pcall(JSONDecode, HttpService, Content) then
            self:Save(RelativePath)
        end
    end

    function Config.Save(self: ConfigInstance, RelativePath: string?): ()
        local Path = ValidatePath(self, RelativePath)

        local Success, Encoded = pcall(JSONEncode, HttpService, self.__index)
        assert(Success, "Failed to parse config to JSON")

        WriteFile(FileHelper, `MFeee-New/{Path}`, Encoded)
    end

    function Config.Load(self: ConfigInstance, RelativePath: string?): ()
        local Path = ValidatePath(self, RelativePath)

        local Content = IsFile(FileHelper, `MFeee-New/{Path}`)
        assert(Content ~= false, `No such file: MFeee-New/{Path}`)

        local Success, Decoded = pcall(JSONDecode, HttpService, Content)
        assert(Success, "Failed to parse config from JSON")

        self:Merge(Decoded, "New")
    end

    function Config.Merge(self: ConfigInstance, NewConfig: hash, Priority: "New" | "Current"): ()
        assert(type(NewConfig) == "table", "Invalid new config")
        if Priority ~= "New" and Priority ~= "Current" then
            Priority = "New"
        end

        NewConfig = table_clone(NewConfig)

        local MergedConfig = Priority == "New" and table_clone(self.__index) or NewConfig
        local Default      = self.Default

        for Key, Value in NewConfig do
            if type(Value) ~= type(Default[Key]) then
                NewConfig[Key] = nil
            end
        end

        for Key, Value in Priority == "New" and NewConfig or self.__index do
            MergedConfig[Key] = Value
        end

        self:Replace(MergedConfig)
    end

    function Config.Replace(self: ConfigInstance, NewConfig: hash): ()
        assert(type(NewConfig) == "table", "New config must be a table")
        local __index = self.__index

        table_clear(__index)
        for Key, Value in NewConfig do
            __index[Key] = Value
        end

        TryToAutoSave(self)
    end

    function Config.Clear(self: ConfigInstance): ()
        table_clear(self.__index)

        TryToAutoSave(self)
    end
end

return Config
