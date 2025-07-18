--declare script: LocalScript

export type Function = (...any) -> (...any)
export type Callback = (...any) -> ()

export type Table = {[any]: any}
export type table = Table

export type Array = {[number]: any}
export type array = Array

export type Hash = {[string]: any}
export type hash = Hash

export type ContentId = typeof(`rbxassetid://{123}`)
export type RobloxId  = typeof(`rbxasset://somepath/something`)

declare class DataModel extends DataModel
    function HttpGet(self, url: string): string
    function HttpPost(self, url: string, data: string, contentType: string?): string
    function HttpGetAsync(self, url: string): string
    function GetObjects(self, localFilePath: string): {[number]: any}
    function secret_get(self, Url: string): string
end

declare game: DataModel

declare class WorldRoot extends WorldRoot
    function FindPartOnRay(self, ray: Ray, ignoreDescendantsInstance: Instance, terrainCellsAreCubes: boolean, ignoreWater: boolean): (BasePart?, Vector3?, Vector3?, Enum.Material?)
    function FindPartOnRayWithIgnoreList(self, ray: Ray, ignoreDescendantsTable: {Instance}, terrainCellsAreCubes: boolean, ignoreWater: boolean): (BasePart?, Vector3?, Vector3?, Enum.Material?)
    function FindPartOnRayWithWhitelist(self, ray: Ray, whitelistDescendantsTable: {Instance}, ignoreWater: boolean): (BasePart?, Vector3?, Vector3?, Enum.Material?)
end

declare class HttpResponse
    Body: string
    StatusCode: number
    StatusMessage: string
    Success: boolean
    Headers: {[string]: any}
end

--// Actors //
declare run_on_actor: (actor: Actor, source: string, ...any) -> (nil)
declare function getactors(): { Actor }
declare function create_comm_channel(): (number | string, BindableEvent)
declare function get_comm_channel(channel: any): BindableEvent

--// Scripts //
declare function getgc(includeTables: boolean?): array
declare function getgenv(): { [any]: any }
declare function getloadedmodules(excludeCore: boolean?): {ModuleScript}
declare function getmodules(excludeCore: boolean?): {ModuleScript}
declare function getrenv(): { [string]: any }
declare function getreg(): {[string]: any}
declare function getrunningscripts(): {LocalScript | ModuleScript}
declare function getscriptbytecode(script: LocalScript | ModuleScript): string
declare function dumpstring(script: LocalScript | ModuleScript): string
declare function getscriptclosure(script: LocalScript | ModuleScript): Function
declare function getscriptfunction(script: LocalScript | ModuleScript): Function
declare function decompile(script: LocalScript | ModuleScript): string
declare function getscripthash(script: LocalScript | ModuleScript): string
declare function getscripts(): {LocalScript | ModuleScript}
declare function getsenv(script: LocalScript | ModuleScript): { [string]: any }
declare function getthreadidentity(): number
declare function getidentity(): number
declare function getthreadcontext(): number
declare function setthreadidentity(identity: number): ()
declare function setidentity(identity: number): ()
declare function setthreadcontext(identity: number): ()
declare function require(target: ModuleScript | string, ...: any): any

--// Misc //
declare function identifyexecutor(): (string, string)
declare function getexecutorname(): (string, string)
declare function lz4compress(data: string): string
declare function lz4decompress(data: string, size: number): string
declare function messagebox(text: string, caption: string, flags: number): number
declare function queue_on_teleport(code: string): ()
declare function queueonteleport(code: string): ()
declare function request(options: {[string]: any}): HttpResponse
declare function http_request(options:{[string]: any}): HttpResponse
declare function setclipboard(text: string): ()
declare function writeclipboard(text: string): ()
declare function toclipboard(text:string): ()
declare function write_clipboard(data: string): ()
declare function setfpscap(fps: number): ()
declare function saveinstance(path: string): ()
declare function randomstring(length: number?): string
declare function getrainbowcolor(RainbowSpeed: number | nil): Color3
declare function HttpGet(url: string): string
declare function HttpGetAsync(url: string): string
declare function secret_get(Url: string): string
declare function getfflag(Flag: string): boolean | "false" | "true"
declare function setfflag(Flag: string, Value: "false" | "true"): ()

--// Metatable //
declare function getrawmetatable(object: any): {[string]: any}
declare function hookmetamethod(object: any, method: string, hook: Function): Function
declare function getnamecallmethod(): string
declare function isreadonly(object: any): boolean
declare function setrawmetatable(object: any, metatable: {[string]: any}): ()
declare function setreadonly(object: any, readonly: boolean): ()

--// Instances //
declare function fireclickdetector(object: Instance, distance: number?, event: string?): ()
declare function firetouchinterest(toucher: BasePart, toTouch: BasePart, State0Untouching1Touching: number): ()
declare function firetouchtransmitter(toucher: BasePart, toTouch: BasePart, State0Untouching1Touching: number): ()
declare function fireproximityprompt(object: ProximityPrompt, distance: number?): ()
declare function getcallbackvalue(object: Instance, property: string): Function?
declare function isnetworkowner(object: Instance): boolean
declare class ConnectionGarbage
    Enabled: boolean
    ForeignState: boolean
    LuaConnection: boolean
    Function: Function?
    Thread: thread?

    function Fire(self, ...: any): nil
    function Defer(self, ...: any): nil
    function Disconnect(self): nil
    function Disable(self): nil
    function Enable(self): nil
end

declare function getconnections(signal: RBXScriptSignal, context: number?): { [number]: ConnectionGarbage }
declare function get_signal_cons(signal: RBXScriptSignal, context: number?): { [number]: ConnectionGarbage }
declare function getcustomasset(path: string, noCache: boolean?): string
declare function getsynasset(path: string, noCache: boolean?): string
declare function gethiddenproperty(object: Instance, property: string): (any, boolean)
declare function gethui(): Instance
declare function protectgui(gui: ScreenGui): ()
declare function getinstances(): {Instance}
declare function getnilinstances(): {Instance}
declare function isscriptable(object: Instance, property: string): boolean
declare function sethiddenproperty(object: Instance, property: string, value: any): boolean
declare function setrbxclipboard(data: string): boolean
declare function setscriptable(object: Instance, property: string, value: boolean): boolean

--// Input //
declare function isrbxactive(): boolean
declare function isgameactive(): boolean
declare function iswindowactive(): boolean
declare function mouse1click(): ()
declare function mouse1press(): ()
declare function mouse1release(): ()
declare function mouse2click(): ()
declare function mouse2press(): ()
declare function mouse2release(): ()
declare function mousemoveabs(x: number, y: number): ()
declare function mousemoverel(x: number, y: number): ()
declare function mousescroll(pixels: number): ()
declare Input: {
    MouseMove: (x: number, y: number) -> ()
}

--// File System //
declare function readfile(path: string): string
declare function listfiles(path: string): {string}
declare function writefile(path: string, data: string): ()
declare function makefolder(path: string): ()
declare function appendfile(path: string, data: string): ()
declare function isfile(path: string): boolean
declare function isfolder(path: string): boolean
declare function delfile(path: string): ()
declare function delfolder(path: string): ()
declare function loadfile(path: string, chunkname: string?): (Function?, string?)
declare function dofile(path: string): ()

--// Console //
declare function rconsoleclear(): ()
declare function consoleclear(): ()
declare function rconsolecreate(): ()
declare function consolecreate(): ()
declare function rconsoledestroy(): ()
declare function consoledestroy(): ()
declare function consoledestroy(): ()
declare function rconsoleinput(): string
declare function consoleinput(): string
declare function rconsoleprint(text: string): ()
declare function consoleprint(text: string): ()
declare function rconsolesettitle(title: string): ()
declare function rconsolename(title: string): ()
declare function consolesettitle(title: string): ()

--// Closures //
declare function checkcaller(): boolean
declare function clonefunction(func: Function): Function
declare function clonefunc(func: Function): Function
declare function getcallingscript(): BaseScript | nil
declare function hookfunction(func: Function, hook: Function): Function
declare function isfunctionhooked(func: Function): boolean
declare function restorefunction(func: Function): ()
declare function replaceclosure(func: Function, hook: Function): Function
declare function iscclosure(func: Function): boolean
declare function islclosure(func: Function): boolean
declare function isexecutorclosure(func: Function): boolean
declare function checkclosure(func: Function): boolean
declare function isourclosure(func: Function): boolean
declare function loadstring(source: string, chunkname: string?): (Function?, string?)
declare function load(source: string, chunkname: string?): (Function?, string?)
declare function newcclosure(func: Function): Function
declare function copyfunction(original: Function): Function

--// Cache //
declare function invalidate(object: Instance): ()
declare function iscached(object: Instance): boolean
declare function replace(object: Instance, newObject: Instance): ()
declare function clonereference(object: Instance): Instance
declare function cloneref(object: Instance): Instance | any
declare function compareinstances(a: Instance, b: Instance): boolean
declare function base64_encode(data: string): string
declare function base64_decode(data: string): string

declare debug: {
    info: (<R...>(thread, number, string) -> R...) & (<R...>(number, string) -> R...) & (<A..., R1..., R2...>((A...) -> R1..., string) -> R2...), -- Traverses the entire stack of target thread and returns a string containing the call stack of target level details. Traverses the entire stack of current thread and returns a string containing the call stack of target level details. Traverses the entire stack of current thread and returns a string containing the call stack of target function details.
    traceback: ((string?, number?) -> string) & ((thread, string?, number?) -> string), -- Returns a full execution stack trace of stack level lvl and starting with message message before the logging. Both arguments are optional and the default value for lvl is 1 which is the current thread.
    profilebegin: (label: string) -> (), -- The text that this MicroProfiler label displays.
    profileend: () -> (), -- Stops profiling for the most recent label that <code>debug.profilebegin()</code> opened.
    getmemorycategory: () -> string, -- Returns the name of the current thread's active memory category.
    setmemorycategory: (tag: string) -> (), -- Assigns a custom tag to the current thread's memory category.
    resetmemorycategory: () -> (), -- Resets the tag assigned by <code>debug.setmemorycategory()</code> to the automatically assigned value (typically, the script name).
    getprotos: (f: Function | number) -> { [number]: any }, -- Returns a table containing the inner prototypes of function f. Use debug.getproto with activated set to true to get a list of closures.
    getproto: ((f: Function | number, index: number?, activated: true) -> { [number]: (() -> any) })
        & ((f: Function | number, index: number?, activated: boolean?) -> (() -> any)), -- Gets the inner function of f at index. Note: If activated is true, it instead will return a table of functions. These are the closures of that proto that exist within the GC.
    getstack: (level: number, index: number?) -> any, -- Returns a table containing the local variables at the stack level lvl. Unfortunately, this function does not allow you to get the arguments of a function (probably because of Luau?).
    setstack: (level: number, index: number, value: any) -> nil, -- Sets the local at index idx to value at stack level lvl. Unfortunately, you cannot set the arguments of a function with this function (probably because of Luau?).
    getupvalues: (fn: Function | number) -> { [number]: any }, -- Returns a table containing the upvalues of function or stack level f. If the function is from a script inside the game, you will get number indices instead of names because of Luau.
    getupvalue: (fn: Function | number, index: number) -> any, -- Returns the upvalue inside the function or stack levelf at index idx. If an upvalue at idx is not found, nil is returned.
    setupvalue: (fn: Function | number, index: number, newvalue: any) -> nil, -- Sets the upvalue at index idx to value in function or stack level f.
    getconstants: (f: Function | number, pseudo_indices: boolean?) -> { [number]: any }, -- Retrieve the constants in function f or at level f.
    getconstant: (f: Function | number, index: number) -> any, -- Returns the constant at the specified index in function or stack level f.
    setconstant: (f: Function | number, index: number, newvalue: any, pseudo_indices: boolean?) -> nil, -- Sets the constant at index idx to value inside function or stack level f. It's recommended to use debug.getconstants to see all of the constants available in a function before using this function.
    setmetatable: <MT>(o: any, MT) -> nil, -- Sets o's metatable to mt even if the __metatable field exists in o's metatable. Keep in mind that this function will return a boolean in Synapse X even though the function is supposed to return o according to the reference manual.
    getmetatable: <MT>(o: any) -> MT, -- Returns the metatable of object o or nil if o has no metatable. This function is not the same as getmetatable because it will always return the table even if there is __metatable in the metatable.
    validlevel: (level: number, t: thread?) -> boolean, -- Checks if level is a valid index level for the current thread or t if passed.
    getcallstack: (t: thread?) -> { [number]: { func: string, currentline: number? } }, -- Returns a table with each index having fields for the func being executed at that call stack level, and the currentline if it is a Lua closure. Uses t instead of the callers thread if one is passed.
    getregistery: () -> { [any]: any }, -- Returns the Lua registry table. This table contains all functions and threads created from any client-side scripts. Keep in mind that getgc() is actually better for most purposes.
    getfenv: (target: any) -> { [any]: any }, -- Returns the global environment table of function or stack level f. Same as getfenv except it ignores all the safety checks.
    getinfo: (fn: Function | number) -> { source: string, short_src: string, linedefined: number, what: string, name: string, namewhat: string, nups: number, func: Function } -- Returns a table with information about the function or stack level f. The what argument can be used to select specific pieces of information that will go in the returned table. For information on how to use it, read this page https://www.lua.org/pil/23.1.html.
}

declare function getinfo(Function: Function | number): { source: string, short_src: string, linedefined: number, what: string, name: string, namewhat: string, nups: number, func: Function }
declare function getregistry(): { [any]: any }
declare function setconstant(fn: Function | number, index: number, newvalue: any, pseudo_indices: boolean?): nil
declare function getconstant(fn: Function | number, index: number): any
declare function getconstants(fn: Function | number): { [number]: any }
declare function setupvalue(fn: Function | number, index: number, newvalue: any): nil
declare function getupvalue(fn: Function | number, index: number): any
declare function getupvalues(fn: Function | number): { [number]: any }
declare function getstack(level: number, index: number?): any
declare function setstack(level: number, index: number, value: any): nil
declare function getprotos(f: Function | number): { [number]: any }
declare function getproto(f: Function | number, index: number?, activated: true): { [number]: (() -> any) }
    & ((f: Function | number, index: number?, activated: boolean?) -> (() -> any))

declare http: {
    request: (options: {[string]: any}) -> HttpResponse
}

declare fluxus: {
    request: (options: {[string]: any}) -> HttpResponse,
    queue_on_teleport: (code: string) -> nil,
    set_thread_identity: (identity: number) -> nil,
    crypt: {
        base64: {
            encode: (data: string) -> string,
            decode: (data: string) -> string
        },
        hash: (data: string, algorithm: string) -> string,
        random: (size: number) -> string
    },
}

declare syn: {
    queue_on_teleport: (code: string) -> nil,
    set_thread_identity: (identity: number) -> nil,
    get_thread_identity: () -> number,
    write_clipboard: (data: string) -> nil,
    is_cached: (object: Instance) -> boolean,
    protect_gui: (gui: ScreenGui) -> nil,
    unprotect_gui: (gui: ScreenGui) -> nil,
    is_beta: () -> boolean,
    request: (options: {[string]: any}) -> HttpResponse,
    create_secure_function: (Function) -> Function,
    run_secure_function: (Function, ...any) -> (...any),
    secrun: (Function, ...any) -> (...any),
    secure_call: (Function, ...any) -> (...any),
    crypt: {
        base64: {
            encode: (data: string) -> string,
            decode: (data: string) -> string
        },
        custom: {
            hash: (data: string, algorithm: string) -> string,
        },
        encrypt: (data: string, key: string, iv: string?, mode: string?) -> (string, string),
        decrypt: (data: string, key: string, iv: string, mode: string) -> string,
        hash: (data: string, algorithm: string) -> string,
        derive: (key: string, salt: string, iterations: number, length: number) -> string,
        random: (size: number) -> string,
        custom_encrypt: (data: string, key: string, iv: string?, mode: string?) -> (string, string),
        custom_decrypt: (data: string, key: string, iv: string, mode: string) -> string
    },
    cache: {
        replace: (object: Instance, newObject: Instance) -> nil,
        iscached: (object: Instance) -> boolean,
        invalidate: (object: Instance) -> nil
    },
    websokect: {
        connect: (Url: string) -> {
            OnMessage: RBXScriptSignal<string>,
            OnClose: RBXScriptSignal,
            Send: (self: any?, Data: string) -> nil,
            Close: (self: any?) -> nil
        }
    }
}

declare cache: {
    replace: (object: Instance, newObject: Instance) -> nil,
    iscached: (object: Instance) -> boolean,
    invalidate: (object: Instance) -> nil
}

declare crypt: {
    base64encode: (data: string) -> string,
    base64_encode: (data: string) -> string,
    base64decode: (data: string) -> string,
    base64_decode: (data: string) -> string,
    encrypt: (data: string, key: string, iv: string?, mode: string?) -> (string, string),
    decrypt: (data: string, key: string, iv: string, mode: string) -> string,
    generatebytes: (size: number) -> string,
    generatekey: () -> string,
    hash: (data: string, algorithm: string) -> string,
}

--// Luraph Macros //
declare LPH_OBFUSCATED: boolean
declare LPH_NO_VIRTUALIZE: (func: Function) -> Function
declare LPH_ENCFUNC: (func: Function, encKey: string, decKey: string) -> Function
declare LPH_ENCSTR: (string: string) -> string
declare LPH_ENCNUM: (number: number) -> number
declare LPH_CRASH: () -> nil
declare LPH_JIT: (func: Function) -> Function
declare LPH_NO_UPVALUES: (func: Function) -> Function
declare LPH_LINE: number

--// Luarmor Macros //
declare LRM_IsUserPremium: boolean
declare LRM_LinkedDiscordID: string
declare LRM_ScriptName: string
declare LRM_TotalExecutions: number
declare LRM_SecondsLeft: number
declare LRM_UserNote: string
declare LRM_ScriptVersion: string

--// Drawing //
declare class DrawEntry
    Visible: boolean
    Transparency: number
    Opacity: number
    ZIndex: number
    Color: Color3

    function Remove(self): nil
    function Destroy(self): nil
    function MoveToFront(self): nil
    function MoveToBack(self): nil
end

declare class LineDrawing extends DrawEntry
    Thickness: number
    From: Vector2
    To: Vector2
    Visible: boolean
end

declare class TextDrawing extends DrawEntry
    Text: string
    TextBounds: Vector2
    Position: Vector2
    Size: number
    Font: number
    Centered: boolean
    Outlined: boolean
    OutlineColor3: boolean
end

declare class ImageDrawing extends DrawEntry
    Data: string
    ImageSize: Vector2
    Size: Vector2
    Position: Vector2
    Rounding: number
end

declare class CircleDrawing extends DrawEntry
    Thickness: number
    NumSides: number
    Radius: number
    Filled: boolean
    Position: Vector2
end

declare class SquareDrawing extends DrawEntry
    Thickness: number
    Size: Vector2
    Position: Vector2
    Filled: boolean
end

declare class TriangleDrawing extends DrawEntry
    Thickness: number
    PointA: Vector2
    PointB: Vector2
    PointC: Vector2
    Filled: boolean
end

declare class QuadDrawing extends DrawEntry
    Thickness: number
    PointA: Vector2
    PointB: Vector2
    PointC: Vector2
    PointD: Vector2
    Filled: boolean
end

declare Drawing: {
    new: ((Type: "Line") -> LineDrawing) 
        & ((Type: "Text") -> TextDrawing)
        & ((Type: "Image") -> ImageDrawing)
        & ((Type: "Circle") -> CircleDrawing)
        & ((Type: "Square") -> SquareDrawing)
        & ((Type: "Triangle") -> TriangleDrawing)
        & ((Type: "Quad") -> QuadDrawing),
    Fonts: {
        UI: number,
        System: number,
        Plex: number,
        Monospace: number
    },
    fonts: {
        UI: number,
        System: number,
        Plex: number,
        Monospace: number
    },
    Clear: () -> nil,
    clear: () -> nil
}

declare function isrenderobj(Drawing: LineDrawing | TextDrawing | ImageDrawing | CircleDrawing | SquareDrawing | TriangleDrawing | QuadDrawing): boolean
declare function setrenderproperty(Drawing: LineDrawing | TextDrawing | ImageDrawing | CircleDrawing | SquareDrawing | TriangleDrawing | QuadDrawing, Property: string, Value: any): nil
declare function getrenderproperty(Drawing: LineDrawing | TextDrawing | ImageDrawing | CircleDrawing | SquareDrawing | TriangleDrawing | QuadDrawing, Property: string): any
declare function cleardrawingcache(): nil

declare WebSocket: {
    connect: (Url: string) -> {
        OnMessage: RBXScriptSignal<string>,
        OnClose: RBXScriptSignal,
        Send: (self: any?, Data: string) -> nil,
        Close: (self: any?) -> nil
    }
}

declare Clipboard: {
    set: (content: string) -> nil
}

declare bit: {
    badd: (...number) -> number,
    bsub: (...number) -> number,
    bmul: (...number) -> number,
    bdiv: (...number) -> number,
    band: (...number) -> number,
    bor: (...number) -> number,
    bxor: (...number) -> number,
    bnot: (...number) -> number,
    lshift: (value: number, disp: number) -> number,
    rshift: (value: number, disp: number) -> number,
    lrotate: (value: number, disp: number) -> number,
    rrotate: (value: number, disp: number) -> number,
    arshift: (value: number, n: number) -> number,
    rol: (value: number, n: number) -> number,
    ror: (value: number, n: number) -> number,
    bpopcount: (value: number) -> number,
    bswap: (value: number) -> number,
    tohex: (value: number, nibbles: number) -> number,
    tobit: (value: number) -> number,
    btest: (...number) -> number,
    byteswap: (x: number) -> number,
    countlz: (n: number) -> number,
    countrz: (n: number) -> number,
    extract: (n: number, field: number, width: number) -> number,
    replace: (n: number, v: number, field: number, width: number) -> number
}

declare wax: {
    version: string,
    envname: string,
    shared: {[any]: any},

    script: LuaSourceContainer,

    require: (...any) -> ...any,
    [any]: any
}

--[==[
--// mspaint Addon //
type ToggleOptions = {
    Text: string?,
    Default: boolean?,
    Tooltip: string?,
    DisabledTooltip: string?,
    Callback: (Enabled: boolean) -> (),
    Changed: (Enabled: boolean) -> (),
    Risky: boolean?,
    Disabled: boolean?,
    Visible: boolean?
}

type IETFLanguageTag =
    | "am" | "ar" | "az" | "de" | "en"
    | "es" | "fa" | "fr" | "hi" | "hr"
    | "hu" | "id" | "ja" | "kz" | "ms"
    | "pt" | "ru" | "sv" | "tr" | "uk"
    | "ur" | "vi" | "zh-cn" | "zh-hant"

type LabelReturn = {
    Text: string,
    DoesWrap: boolean,
    Visible: boolean,
    SetVisible: (self: Table, Visible: boolean) -> nil,
    SetText: (self: Table, Text: string) -> nil,
    TextLabel: TextLabel,
    Container: Frame,
    Holder: TextLabel,
}

type LabelOptions = {
    Text: string?,
    DoesWrap: boolean?,
    Size: number?,
    Visible: boolean?
}

declare class Groupbox
    function AddButton(self, Text: string?, Callback: Function?): Table
    function AddButton(self, Options: {
        Text: string?,
        Func: () -> ()?,
        DoubleClick: boolean?,
        Tooltip: string?,
        DisabledTooltip: string?,
        Risky: boolean?,
        Disabled: boolean?,
        Visible: boolean?
    }): Table
    function AddToggle(self, Index: string, Options: ToggleOptions): Table
    function AddCheckbox(self, Index: string, Options: ToggleOptions): Table
    function AddLabel(self, Text: string?, DoesWrap: boolean?, Index: string?): LabelReturn
    function AddLabel(self, Index: string?, Options: LabelOptions): LabelReturn
    function AddLabel(self, Options: LabelOptions): LabelReturn
    function AddDivider(self): nil
    function AddSlider(self, Index: string, Info: {
        Text: string?,
        Default: number?,
        Min: number?,
        Max: number?,
        Prefix: string?,
        Suffix: string?,
        Tooltip: string?,
        Rounding: number?,
        DisabledTooltip: string?,
        Compact: boolean?,
        HideMax: boolean?,
        Callback: (Value: number) -> (),
        Changed: (Value: number) -> (),
        Disabled: boolean?,
        Visible: boolean?
    }): {
        Holder: Frame,
        UpdateColors: (self: Table) -> nil,
        Display: (self: Table) -> nil,
        OnChanged: (self: Table, Function: Function) -> nil,
        SetMax: (self: Table, Max: number) -> nil,
        SetMin: (self: Table, Min: number) -> nil,
        SetValue: (self: Table, Value: number) -> nil,
        SetDisabled: (self: Table, Disabled: boolean) -> nil,
        SetText: (self: Table, Text: string) -> nil,
        SetVisible: (self: Table, Visible: boolean) -> nil,
        SetPrefix: (self: Table, Prefix: string) -> nil,
        SetSuffix: (self: Table, Suffix: string) -> nil
    }
    Holder: Instance
end

type NotificationData = {
    Title: string?,
    Description: string?,
    Time: (number | Instance)?,
    SoundId: any,
    Steps: number?,
    Resize: () -> (),
    ChangeTitle: (NewText: string?) -> (),
    ChangeDescription: (NewText: string?) -> (),
    ChangeStep: (NewStep: number?) -> ()
}

declare class Library
    function Notify(self, Description: string?, Duration: number?): NotificationData
    function Notify(self, Options: {
        Title: string?,
        Description: string?,
        Time: (number | Instance)?,
        SoundId: any,
        Steps: number?
    }): NotificationData
    function UpdateKeybindFrame(self): (nil)
    function AddToRegistry(self, Instance: Instance, Properties: {[string]: any}): nil
    function RemoveFromRegistry(self, Instance: Instance): nil
    function UpdateColorsUsingRegistry(self): nil
    function UpdateDPI(self, Instance: Instance, Properties: {[string]: any}): (nil)
    function SetDPIScale(self, DPIScale: number): nil
    function GiveSignal(self, Connection: RBXScriptConnection): RBXScriptConnection
    function GetIcon(self, IconName: string): ({
        IconName: string,
        Id: number,
        Url: string,
        ImageRectSize: Vector2,
        ImageRectOffset: Vector2
    }?)
    function Validate(self, Table: {[string]: any}, Template: {[string]: any}): {[string]: any}
    function GetBetterColor(self, Color: Color3, Add: number): Color3
    function GetDarkerColor(self, Color: Color3): Color3
    function GetKeyString(self, KeyCode: Enum.KeyCode): string
    function GetTextBounds(self, Text: string, Font: Font, Size: number, Width: number): (number, number)
    function MouseIsOverFrame(self, Frame: GuiObject, Mouse: Vector2): boolean
    function SafeCallback(self, Func: Function, ...: any): (any)
    function MakeDraggable(self, UI: GuiObject, DragFrame: GuiObject, IgnoreToggled: boolean?, IsMainWindow: boolean?): (nil)
    function MakeResizable(self, UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?): (nil)
    function MakeCover(self, Holder: GuiObject, Place: string): Instance
    function MakeLine(self, Frame: GuiObject, Info: {
        AnchorPoint: Vector2?,
        Position: Vector2,
        Size: Vector2
    }): Instance
    function MakeOutline(self, Frame: GuiObject, Corner: number?, ZIndex: number?): Instance
    function AddDraggableButton(self, Text: string, Func: Function): {
        SetText: (self: Table, NewText: string) -> nil,
        Button: TextButton
    }
    function AddContextMenu(self, 
        Holder: GuiObject,
        Size: UDim2 | () -> (),
        Offset: {[number]: number} | () -> {},
        List: number?,
        ActiveCallback: (Active: boolean) -> ()?
    ): {
        Active: boolean,
        Holder: GuiObject,
        Menu: ScrollingFrame | Frame,
        List: number?,
        Signal: RBXScriptSignal,
        Size: UDim2 | () -> (),
        Open: (self: Table) -> (nil)?,
        Close: (self: Table) -> (nil)?,
        Toggle: (self: Table) -> nil,
        SetSize: (self: Table, Size: UDim2 | () -> ()) -> nil
    }
    function AddTooltip(self, InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject): {
        Disabled: boolean,
        Hovering: boolean,
        Signals: Table,
        Destroy: (self: Table) -> nil
    }
    function OnUnload(self, Callback: () -> ())
    function Unload(self): nil
    function SetFont(self, FontFace: Font | Enum.Font): nil
    function SetNotifySide(self, Side: string): nil
    function CreateWindow(self, WindowInfo: Table): {
        AddTab: (self: Table, Name: string, Icon: any) -> {
            Groupboxes: Table,
            Tabboxes: Table,
            Sides: {
                number: ScrollingFrame,
                number: ScrollingFrame
            },
            Resize: (self: Table, ResizeWarningBox: boolean?) -> (nil),
            UpdateWarningBox: (self: Table, Info: Table | any) -> nil,
            AddGroupbox: (self: Table, Info: Table | any) -> Groupbox
        }
    }
    Options: {[string]: Table}
    Toggles: {[string]: Table}
    Buttons: {[string]: Table}
    Labels:  {[string]: Table}
    LocalPlayer: Player
    DevicePlatform: Enum.Platform
    IsMobile: boolean
    ScreenGui: GuiObject
    ActiveTab: Table
    Tabs: Table
    KeybindFrame: Frame
    KeybindContainer: Frame
    KeybindToggles: Table
    Notifications: Table
    ToggleKeybind: Enum.KeyCode
    TweenInfo: TweenInfo
    NotifyTweenInfo: TweenInfo
    Toggled: boolean
    Unloaded: boolean
    NotifySide: string
    ShowCustomCursor: boolean
    ForceCheckbox: boolean
    ShowToggleFrameInKeybinds: boolean
    NotifyOnError: boolean
    CantDragForced: boolean
    Signals: Table
    UnloadSignals: Table
    MinSize: Vector2
    DPIScale: number
    CornerRadius: number
    IsLightTheme: boolean
    Scheme: {
        BackgroundColor: Color3,
        MainColor: Color3,
        AccentColor: Color3,
        OutlineColor: Color3,
        FontColor: Color3,
        Font: Font,
        Red: Color3,
        Dark: Color3,
        White: Color3
    }
    Registry: Table
    DPIRegistry: Table
end

declare mspaint: {
    AddonInfo: {
        Name: string,
        Title: string?,
        Description: string?,
        Game: string | {[number]: string} | {[number]: number} | number
    },
    Groupbox: Groupbox,
    CurrentLanguage: IETFLanguageTag,
    DiscordUserData: {
        id: string,
        global_name: string,
        username: string
    },
    ExecutorSupport: {
        ["readfile"]: boolean,
        ["listfiles"]: boolean,
        ["writefile"]: boolean,
        ["makefolder"]: boolean,
        ["appendfile"]: boolean,
        ["isfile"]: boolean,
        ["isfolder"]: boolean,
        ["delfile"]: boolean,
        ["delfolder"]: boolean,
        ["loadfile"]: boolean,
        ["getgc"]: boolean,
        ["getsenv"]: boolean,
        ["getrenv"]: boolean,
        ["getinfo"]: boolean,
        ["getupvalue"]: boolean,
        ["getupvalues"]: boolean,
        ["setupvalue"]: boolean,
        ["require"]: boolean,
        ["checkcaller"]: boolean,
        ["getcallingscript"]: boolean,
        ["getnamecallmethod"]: boolean,
        ["hookmetamethod"]: boolean,
        ["hookfunction"]: boolean,
        ["isexecutorclosure"]: boolean,
        ["isfunctionhooked"]: boolean,
        ["clonefunction"]: boolean,
        ["restorefunction"]: boolean,
        ["getconnections"]: boolean,
        ["firetouchinterest"]: boolean,
        ["firesignal"]: boolean,
        ["replicatesignal"]: boolean,
        ["fireproximityprompt"]: boolean,
        ["fireclickdetector"]: boolean,
        ["request"]: boolean,
        ["queue_on_teleport"]: boolean,
        ["gethui"]: boolean,
        ["mousemoverel"]: boolean,
        ["Drawing"]: boolean
    },
    Library: Library
}

declare Library: Library
]==]
