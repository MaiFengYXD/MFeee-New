local setmetatable, type, assert, table_clone, table_clear
    = setmetatable, type, assert, table.clone, table.clear

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

    Save: (self: ConfigInstance, RelativePath: string?) -> (),
    Load: (self: ConfigInstance, RelativePath: string?) -> (),

    Replace: (self: ConfigInstance, NewConfigs: hash) -> (),
    Clear:   (self: ConfigInstance) -> (),

    FindConfig: (Index: string) -> ConfigInstance?,

    __index: ConfigManager
}

type ConfigInstance = typeof(setmetatable({
    Default = {} :: hash | nil,
    Configs = {} :: hash,

    DefaultConfigPath = nil  :: string?,
    AutoSaveEnabled   = true :: boolean
}, {
    __index = {} :: ConfigManager
}))

local AllConfigs = {} :: {[string]: ConfigInstance}

local Config = {} :: ConfigManager;do
    local function TryToAutoSave(self: ConfigInstance): ()
        if self.AutoSaveEnabled then
            self:Save()
        end
    end

    Config.__index = Config

    function Config.new(Index: string, Default: hash | nil, RelativePath: string?): ConfigInstance
        local self = setmetatable({
            Default = type(Default) == "table" and Default or nil,
            Configs = type(Default) == "table" and table_clone(Default :: hash) or {},

            DefaultConfigPath = type(RelativePath) == "string" and RelativePath or nil,
            AutoSaveEnabled   = true
        }, Config)

        if type(Index) == "string" then
            AllConfigs[Index] = self
        end

        TryToAutoSave(self)

        return self
    end

    function Config.Get(self: ConfigInstance, Key: string): any
        return self.Configs[Key]
    end

    function Config.Set(self: ConfigInstance, Key: string, Value: any): ()
        self.Configs[Key] = Value
        TryToAutoSave(self)
    end

    function Config.Save(self: ConfigInstance, RelativePath: string?): ()
        local DefaultPath = type(self.DefaultConfigPath) == "string" and self.DefaultConfigPath or nil
        local Path = RelativePath or DefaultPath
        assert(Path, "No path provided to save config")

        local Success, Encoded = JSONEncode(HttpService, self.Configs)
        assert(Success, "Failed to parse config to JSON")

        WriteFile(`MFeee-New/{Path}`, Encoded)
    end

    function Config.Load(self: ConfigInstance, RelativePath: string?): ()
        local DefaultPath = type(self.DefaultConfigPath) == "string" and self.DefaultConfigPath or nil
        local Path = RelativePath or DefaultPath
        assert(Path, "No path provided to load config")

        local Content = IsFile(FileHelper, `MFeee-New/{Path}`)
        assert(Content ~= false, `No such file: MFeee-New/{Path}`)

        local Success, Decoded = JSONDecode(HttpService, Content)
        assert(Success, "Failed to parse config from JSON")

        self:Replace(Decoded)
    end

    function Config.Replace(self: ConfigInstance, NewConfigs: hash): ()
        assert(type(NewConfigs) == "table", "New configs must be a table")
        self.Configs = NewConfigs

        TryToAutoSave(self)
    end

    function Config.Clear(self: ConfigInstance): ()
        table_clear(self.Configs)

        TryToAutoSave(self)
    end

    function Config.FindConfig(Index: string): ConfigInstance?
        return AllConfigs[Index]
    end
end

return Config
