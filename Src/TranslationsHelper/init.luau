local string_format
    = string.format

local Translator = {
    Reversed = {},
    CurrentLocaleID = "en-us"
} :: hash

local Language = "English"
local Display  = "English"

local BuiltInTranslations = {} :: {[string]: string}
local RealShouldTranslate: boolean

local LocaleIDTree = {
    ["sq-al"]  = {Language = "Albanian", Display = "Shqipe", Code = "sq"},
    ["ar-001"] = {Language = "Arabic", Display = "العربية", Code = "ar"},
    ["bn-bd"]  = {Language = "Bengali", Display = "বাংলা", Code = "bn"},
    ["nb-no"]  = {Language = "Bokmal", Display = "Bokmål", Code = "nb"},
    ["bs-ba"]  = {Language = "Bosnian", Display = "босански", Code = "bs"},
    ["bg-bg"]  = {Language = "Bulgarian", Display = "български", Code = "bg"},
    ["my-mm"]  = {Language = "Burmese", Display = "ဗမာစာ", Code = "my"},
    ["zh-cn"]  = {Language = "Chinese (Simplified)", Display = "中文(简体)", Code = "zh-hans"},
    ["zh-tw"]  = {Language = "Chinese (Traditional)", Display = "中文(繁體)", Code = "zh-hant"},
    ["hr-hr"]  = {Language = "Croatian", Display = "Hrvatski", Code = "hr"},
    ["cs-cz"]  = {Language = "Czech", Display = "Čeština", Code = "cs"},
    ["da-dk"]  = {Language = "Danish", Display = "Dansk", Code = "da"},
    ["nl-nl"]  = {Language = "Dutch", Display = "Nederlands", Code = "nl"},
    ["en-us"]  = {Language = "English", Display = "English", Code = "en"},
    ["et-ee"]  = {Language = "Estonian", Display = "Eesti", Code = "et"},
    ["fil-ph"] = {Language = "Filipino", Display = "Filipino", Code = "fil"},
    ["fi-fi"]  = {Language = "Finnish", Display = "Suomi", Code = "fi"},
    ["fr-fr"]  = {Language = "French", Display = "Français", Code = "fr"},
    ["ka-ge"]  = {Language = "Georgian", Display = "ქართული", Code = "ka"},
    ["de-de"]  = {Language = "German", Display = "Deutsch", Code = "de"},
    ["el-gr"]  = {Language = "Greek", Display = "ελληνικά", Code = "el"},
    ["hi-in"]  = {Language = "Hindi", Display = "हिन्दी", Code = "hi"},
    ["hu-hu"]  = {Language = "Hungarian", Display = "Magyar", Code = "hu"},
    ["id-id"]  = {Language = "Indonesian", Display = "Bahasa Indonesia", Code = "id"},
    ["it-it"]  = {Language = "Italian", Display = "Italiano", Code = "it"},
    ["ja-jp"]  = {Language = "Japanese", Display = "日本語", Code = "ja"},
    ["kk-kz"]  = {Language = "Kazakh", Display = "қазақ тілі", Code = "kk"},
    ["km-kh"]  = {Language = "Khmer", Display = "ភាសាខ្មែ儿", Code = "km"},
    ["ko-kr"]  = {Language = "Korean", Display = "한국어", Code = "ko"},
    ["lv-lv"]  = {Language = "Latvian", Display = "Latviešu", Code = "lv"},
    ["lt-lt"]  = {Language = "Lithuanian", Display = "Lietuvių", Code = "lt"},
    ["ms-my"]  = {Language = "Malay", Display = "Bahasa Melayu", Code = "ms"},
    ["pl-pl"]  = {Language = "Polish", Display = "Polski", Code = "pl"},
    ["pt-br"]  = {Language = "Portuguese", Display = "Português", Code = "pt"},
    ["ro-ro"]  = {Language = "Romanian", Display = "Română", Code = "ro"},
    ["ru-ru"]  = {Language = "Russian", Display = "русский", Code = "ru"},
    ["sr-rs"]  = {Language = "Serbian", Display = "српски", Code = "sr"},
    ["si-lk"]  = {Language = "Sinhala", Display = "සිංහල", Code = "si"},
    ["sk-sk"]  = {Language = "Slovak", Display = "Slovenčina", Code = "sk"},
    ["sl-sl"]  = {Language = "Slovenian", Display = "Slovenski", Code = "sl"},
    ["es-es"]  = {Language = "Spanish", Display = "Español", Code = "es"},
    ["sv-se"]  = {Language = "Swedish", Display = "Svenska", Code = "sv"},
    ["th-th"]  = {Language = "Thai", Display = "ภาษาไทย", Code = "th"},
    ["tr-tr"]  = {Language = "Turkish", Display = "Türkçe", Code = "tr"},
    ["uk-ua"]  = {Language = "Ukrainian", Display = "україньска", Code = "uk"},
    ["vi-vn"]  = {Language = "Vietnamese", Display = "Tiểng Việt", Code = "vi"},
} :: {[LocaleID]: {
    Language: string,
    Display:  string,
    Code:     string
}};do
    local LocaleID_Language = {}
    local LocaleID_Display  = {}
    local LocaleID_Code     = {}
    local Language_LocaleID = {}

    for LocaleID, Info in LocaleIDTree do
        LocaleID_Language     [LocaleID] = Info.Language
        LocaleID_Display      [LocaleID] = Info.Display
        LocaleID_Code         [LocaleID] = Info.Code
        Language_LocaleID[Info.Language] = LocaleID
    end

    shared.LocaleID_Language = LocaleID_Language
    shared.LocaleID_Display  = LocaleID_Display
    shared.LocaleID_Code     = LocaleID_Code
    shared.Language_LocaleID = Language_LocaleID

    local Exist: boolean
    Language, Exist = shared.FileHelper:CheckFile("MFeee-New/Language.txt", "English", Language_LocaleID)

    if not Exist then
        if not pcall(function(LocalizationService: LocalizationService)
            local RobloxLocaleId = LocalizationService.RobloxLocaleId
            assert((LocaleIDTree :: any)[RobloxLocaleId])

            Language = LocaleID_Language[RobloxLocaleId]
        end, shared.LocalizationService) then
            Language = "English" -- Maybe a repeat?
        end
    end

    Translator.CurrentLocaleID = Language_LocaleID[Language]
    Display = LocaleID_Display[Language_LocaleID[Language]]

    RealShouldTranslate = not shared.BootSettings.DisableTranslation and Language ~= "English"

    if RealShouldTranslate then
        local Original, BuiltInTranslationsTree = require("BuiltInTranslations")

        for LocaleID, Translation in BuiltInTranslationsTree do
            if LocaleID_Language[LocaleID] ~= Language then continue end

            for Index, Translated in Translation do
                BuiltInTranslations[Original[Index]] = Translated
            end
            break
        end
    end

    shared.LocaleID        = Translator.CurrentLocaleID
    shared.DisplayLanguage = Display
    shared.Language        = Language
end

local function GetBuiltInTranslation(Key: string): string
    return BuiltInTranslations[Key] or Key
end

if RealShouldTranslate then --/ Source language: English
    local task_wait
        = task.wait

    local function TranslateWithFormat(Key: string, ...: any): string
        --/ Temporarily set to search only from BuiltInTranslations
        return string_format(GetBuiltInTranslation(Key), ...)
    end

    local Success: boolean, Result: string | hash | any
    local Elapsed = 0

    local Thread = task.spawn(function()
        print(`[MFeee~ New] {TranslateWithFormat("Fetching translations for %s...", Language)}`)

        Success, Result = pcall(function(HttpGet: typeof(HttpGet), request: typeof(request))
            local HttpService = shared.HttpService
            local JSONDecode  = HttpService.JSONDecode

            local Url = `https://raw.githubusercontent.com/MaiFengYXD/Translator/refs/heads/MFeee-New/Translations/{Translator.CurrentLocaleID}.json`

            local Succeeded:   boolean = false
            local StatusCode:  number = 200

            local ErrorReason: string
            local UrlContent:  string

            local RealTranslations: hash?

            if request then
                local Delay = 0.2

                for _ = 1, 3 do
                    local Response = request({
                        Url = Url,
                        Method = "GET"
                    })

                    StatusCode = Response.StatusCode

                    if StatusCode == 200 or StatusCode == 304 then
                        UrlContent = Response.Body
                        local Success
                        Success, RealTranslations = pcall(JSONDecode, HttpService, UrlContent)

                        if Success then
                            Succeeded = true
                            break
                        end

                        ErrorReason = GetBuiltInTranslation("Translator raw page error or HttpGet problem, please report it!")
                    elseif Response.Success == false then
                        ErrorReason = TranslateWithFormat("Http Error: %*", StatusCode)
                    end

                    RealTranslations = nil

                    task_wait(Delay)
                    Delay *= 2
                end
            end

            if not request or not (StatusCode == 404 or Succeeded) then
                local Delay = 0.2

                for _ = 1, 3 do
                    UrlContent = HttpGet(Url)

                    if UrlContent == "404: Not Found" then
                        StatusCode = 404
                        ErrorReason = TranslateWithFormat("Http Error: %s", "404")
                    else
                        local Success
                        Success, RealTranslations = pcall(JSONDecode, HttpService, UrlContent)

                        if Success then
                            Succeeded = true
                            break
                        end

                        ErrorReason = GetBuiltInTranslation("Translator raw page error or HttpGet problem, please report it!")
                    end

                    RealTranslations = nil

                    task_wait(Delay)
                    Delay *= 2
                end
            end

            if not Succeeded then error(ErrorReason, 19998) end

            return RealTranslations
        end, wax.Global.HttpGet, wax.Global.request)
    end)

    local Timeout = shared.BootSettings.TranslationsTimeout

    repeat
        Elapsed += task_wait()

        if Elapsed >= Timeout then
            task.cancel(Thread)
            Success = false
            Result  = GetBuiltInTranslation("Timeout! time exceeded 10 seconds.")
        end
    until Success ~= nil

    if Success then
        Translator[Language] = Result
    else
        if Result:match("(.+) is not a valid member of .-") or Result:match("attempt to call a .+ value") then
            Result = GetBuiltInTranslation("Missing 'HttpGet' function!")
        end

        shared.MiniNotify(GetBuiltInTranslation("Translator:"), TranslateWithFormat("Failed to fetch translations for %s due to %s", Display, Result))
    end
end

do
    local Translation = Translator[Language]
    local Reversed    = Translator.Reversed

    if Translation then
        for Key, Value in Translation do
            Reversed[Value] = Key
        end
    end

    local function Translate(Key: string): string
        return Translation and Translation[Key] or BuiltInTranslations[Key] or Key
    end

    local function TranslateWithFormat(Key: string, ...: any): string
        return Translation and string_format(Translate(Key), ...)
    end

    local function Reverse(Value: string): string?
        return Translation and Reversed[Value] or Value
    end

    -- Translator.GetTranslation    = Translate           --/ Deprecated name
    -- Translator.FormatTranslation = TranslateWithFormat --/ Deprecated name
    -- Translator.FromTranslation   = Reverse             --/ Deprecated name

    Translator.Translate           = Translate
    Translator.TranslateWithFormat = TranslateWithFormat
    Translator.Reverse             = Reverse

    return Translator
end
