export type IETFLanguageTag =
    | "am" | "ar" | "az" | "de" | "en"
    | "es" | "fa" | "fr" | "hi" | "hr"
    | "hu" | "id" | "ja" | "kz" | "ms"
    | "pt" | "ru" | "sv" | "tr" | "uk"
    | "ur" | "vi" | "zh-cn" | "zh-hant"

export type NativeNames = 
    | "አማርኛ" | "العربية" | "Azərbaycan dili" | "Deutsch" | "English"
    | "Español" | "فارسی" | "Français" | "हिन्दी" | "Hrvatski"
    | "Magyar" | "Bahasa Indonesia" | "日本語" | "Қазақ тілі" | "Bahasa Melayu"
    | "Português" | "Русский язык" | "Svenska" | "Türkçe" | "Українська мова"
    | "اردو" | "Tiếng Việt" | "简体中文" | "繁體中文"

local Translations = {
    NativeNames = {
        ["am"] = "አማርኛ",
        ["ar"] = "العربية",
        ["az"] = "Azərbaycan dili",
        ["de"] = "Deutsch",
        ["en"] = "English",
        ["es"] = "Español",
        ["fa"] = "فارسی",
        ["fr"] = "Français",
        ["hi"] = "हिन्दी",
        ["hr"] = "Hrvatski",
        ["hu"] = "Magyar",
        ["id"] = "Bahasa Indonesia",
        ["ja"] = "日本語",
        ["kz"] = "Қазақ тілі",
        ["ms"] = "Bahasa Melayu",
        ["pt"] = "Português",
        ["ru"] = "Русский язык",
        ["sv"] = "Svenska",
        ["tr"] = "Türkçe",
        ["uk"] = "Українська мова",
        ["ur"] = "اردو",
        ["vi"] = "Tiếng Việt",
        ["zh-cn"]   = "简体中文",
        ["zh-hant"] = "繁體中文"
    } :: {[IETFLanguageTag]: NativeNames}
}

local Language = wax.shared.Language

if Language ~= "en" then
    local taskwait
        = task.wait

    local Success, Result
    local Elasped = 0

    local Thread = coroutine.create(function()
        Success, Result = pcall(function()
            local UrlContent = game:HttpGet(`https://raw.githubusercontent.com/MaiFengYXD/Translations/refs/heads/main/Translations/{Language}.json`)
            assert(UrlContent:find("{"), "Translations raw page error or HttpGet problem, please report it!")

            return shared.HttpService:JSONDecode(UrlContent)
        end)
    end)
    coroutine.resume(Thread)

    repeat
        Elasped += taskwait()

        if Elasped >= 10 then
            coroutine.close(Thread)
            Success = false
            Result  = "Timeout! time exceeded 10 seconds."
        end
    until Success ~= nil

    if Success then
        Translations[Language] = Result
    else
        if Result:find("HttpGet is not a valid member of") then
            Result = "HttpGet doesn't exist!"
        end

        wax.shared.MiniNotify("Translations:", `Failed to fetch translations for {Language} due to {Result}`)
    end
end

Translations.Reverse = {};do
    for Key, Value in Translations[Language] or {} do
        Translations.Reverse[Value] = Key
    end
end

function Translations:GetTranslation(Key: string): string
    return self[Language] and self[Language][Key] or Key
end

function Translations:FromTranslation(Value: string): string?
    return self.Reverse[Value]
end

return Translations
