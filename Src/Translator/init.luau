local string_format
    = string.format

local FileHelper = shared.FileHelper

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

    local LocaleIDs = {}
    local Displays  = {}
    local Codes     = {}
    local Languages = {}

    for LocaleID, Info in LocaleIDTree do
        local InfoLanguage = Info.Language
        local InfoDisplay  = Info.Display
        local InfoCode     = Info.Code

        LocaleID_Language    [LocaleID] = InfoLanguage
        LocaleID_Display     [LocaleID] = InfoDisplay
        LocaleID_Code        [LocaleID] = InfoCode
        Language_LocaleID[InfoLanguage] = LocaleID

        LocaleIDs[#LocaleIDs + 1] = LocaleID
        Displays [#Displays  + 1] = InfoDisplay
        Codes    [#Codes     + 1] = InfoCode
        Languages[#Languages + 1] = InfoLanguage
    end

    shared.LocaleID_Language = LocaleID_Language
    shared.LocaleID_Display  = LocaleID_Display
    shared.LocaleID_Code     = LocaleID_Code
    shared.Language_LocaleID = Language_LocaleID
    
    shared.LocaleIDs = LocaleIDs
    shared.Displays  = Displays
    shared.Codes     = Codes
    shared.Languages = Languages

    local UserLocaleID, Exist = FileHelper:CheckFile("MFeee-New/UserLocaleID.txt", "en-us", LocaleIDs)
    Language = LocaleID_Language[UserLocaleID]

    if not Exist then
        if not pcall(function(LocalizationService: LocalizationService)
            local RobloxLocaleId = LocalizationService.RobloxLocaleId
            assert((LocaleIDTree :: any)[RobloxLocaleId])

            Language = LocaleID_Language[RobloxLocaleId]
        end, shared.LocalizationService) then
            Language = "English"
        end
    end

    Translator.CurrentLocaleID = Language_LocaleID[Language]
    Display = LocaleID_Display[Language_LocaleID[Language]]

    RealShouldTranslate = not shared.BootSettings.DisableTranslation and Language ~= "English"

    if RealShouldTranslate then
        local Original, BuiltInTranslationsTree = (require :: any)("@self/BuiltInTranslations")

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

    local CachedTranslations = FileHelper:IsFile(`MFeee-New/Translator/Translations/{Translator.CurrentLocaleID}.json`)

    local Thread = task.spawn(function()
        print(`[MFeee~ New] {TranslateWithFormat("Fetching translations for %*...", Display)}`)

        Success, Result = pcall(function(HttpGet: typeof(HttpGet), request: typeof(request), FileHelper)
            local WriteFile = FileHelper.WriteFile

            local HttpService = shared.HttpService
            local JSONDecode  = HttpService.JSONDecode

            local Url = `https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/Translator/Translations/{Translator.CurrentLocaleID}.json`

            local Succeeded:   boolean = false
            local StatusCode:  number = 200

            local ErrorReason: string
            local UrlContent:  string

            local RealTranslations: hash?

            local SHA1, Exist = FileHelper:CheckFile(`MFeee-New/Translator/SHA1/{Translator.CurrentLocaleID}`, "")
            if CachedTranslations and Exist then
                local string_len
                    = string.len

                local SHA1Url = `https://raw.githubusercontent.com/MaiFengYXD/MFeee-New/refs/Translator/SHA1/{Translator.CurrentLocaleID}`

                if request then
                    local Response = request({
                        Url = SHA1Url,
                        Method = "GET"
                    })

                    local ThisStatusCode = Response.StatusCode

                    if ThisStatusCode == 200 or ThisStatusCode == 304 then
                        local ResponseBody = Response.Body

                        if string_len(ResponseBody) == 40 then
                            if ResponseBody == SHA1 then
                                UrlContent = CachedTranslations
                                local Success
                                Success, RealTranslations = pcall(JSONDecode, HttpService, UrlContent)

                                if Success then
                                    Succeeded = true
                                else
                                    RealTranslations = nil
                                end
                            else
                                WriteFile(FileHelper, `MFeee-New/Translator/SHA1/{Translator.CurrentLocaleID}`, ResponseBody)
                            end
                        end
                    end
                end

                if (not request and HttpGet) or not Succeeded then
                    local ResponseBody = HttpGet(SHA1Url)

                    if string_len(UrlContent) == 40 then
                        if ResponseBody == SHA1 then
                            UrlContent = CachedTranslations
                            local Success
                            Success, RealTranslations = pcall(JSONDecode, HttpService, UrlContent)

                            if Success then
                                Succeeded = true
                            else
                                RealTranslations = nil
                            end
                        else
                            WriteFile(FileHelper, `MFeee-New/Translator/SHA1/{Translator.CurrentLocaleID}`, ResponseBody)
                        end
                    end
                end
            end

            if not Succeeded and request then
                local Delay = 0.25

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

                        ErrorReason = GetBuiltInTranslation("Failed to parse translations, please report it!")
                    elseif StatusCode == 404 then
                        ErrorReason = TranslateWithFormat("Http Error: %*", 404)
                        break
                    elseif Response.Success == false then
                        ErrorReason = TranslateWithFormat("Http Error: %*", StatusCode)
                    end

                    warn(`[MFeee~ New] {TranslateWithFormat("Failed to fetch, retry in %* seconds...", Delay)}`)
                    RealTranslations = nil

                    task_wait(Delay)
                    Delay *= 2
                end
            end

            if not Succeeded and (not request and HttpGet) and StatusCode ~= 404 then
                local Delay = 0.25

                for _ = 1, 3 do
                    UrlContent = HttpGet(Url)

                    if UrlContent == "404: Not Found" then
                        ErrorReason = TranslateWithFormat("Http Error: %*", 404)
                        break
                    else
                        local Success
                        Success, RealTranslations = pcall(JSONDecode, HttpService, UrlContent)

                        if Success then
                            Succeeded = true
                            break
                        end

                        ErrorReason = GetBuiltInTranslation("Failed to parse translations, please report it!")
                    end

                    warn(`[MFeee~ New] {TranslateWithFormat("Failed to fetch, retry in %* seconds...", Delay)}`)
                    RealTranslations = nil

                    task_wait(Delay)
                    Delay *= 2
                end
            end

            if not Succeeded then error(ErrorReason or GetBuiltInTranslation("Unable to fetch! Your executor lacks the required features."), 19998) end

            WriteFile(FileHelper, `MFeee-New/Translator/{Translator.CurrentLocaleID}.json`, UrlContent)
            return RealTranslations
        end, wax.Global.HttpGet, wax.Global.request, FileHelper)
    end)

    local Timeout = shared.BootSettings.TranslationsTimeout

    repeat
        Elapsed += task_wait()

        if Elapsed >= Timeout then
            task.cancel(Thread)
            Success = false
            Result  = TranslateWithFormat("Fetching translations timed out! (exceeded %* seconds)", Timeout)
        end
    until Success ~= nil

    if Success then
        Translator[Language] = Result
    else
        shared.MiniNotify(GetBuiltInTranslation("Translator:"), TranslateWithFormat("Failed to fetch translations for %* due to %*", Display, Result))
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
