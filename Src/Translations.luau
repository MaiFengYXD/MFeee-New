export type IETFLanguageTag =
    | "am" | "ar" | "az" | "de" | "en"
    | "es" | "fa" | "fr" | "hi" | "hr"
    | "hu" | "id" | "ja" | "kz" | "ms"
    | "pt" | "ru" | "sv" | "tr" | "ua"
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
        ["ua"] = "Українська мова",
        ["ur"] = "اردو",
        ["vi"] = "Tiếng Việt",
        ["zh-cn"]   = "简体中文",
        ["zh-hant"] = "繁體中文"
    } :: {[IETFLanguageTag]: NativeNames}
}

local Language = wax.shared.Language;do
    local taskwait
        = task.wait

    local Success, FailedOrResult
    local Elasped = 0

    local Thread = coroutine.create(function()
        Success, FailedOrResult = pcall(function()
            return shared.HttpService:JSONDecode(game:HttpGet(`https://github.com/MaiFengYXD/Translations/raw/refs/heads/main/{Language}.json`))
        end)
    end)
    coroutine.resume(Thread)

    repeat
        Elasped += taskwait()
        if Elasped >= 10 then
            coroutine.close(Thread)
            Success = false
            FailedOrResult = "Timeout! time exceeded 10 seconds."
        end
    until Success ~= nil

    if Success then
        Translations[Language] = FailedOrResult
    else
        Translations[Language] = nil
        warn(`Failed to fetch translations for {Language} due to "{FailedOrResult}"`)
        shared.MiniNotify("Translations:", `Failed to fetch translations for {Language}.`)
    end
end

function Translations:GetTranslation(Key: string): string
    return self[Language] and self[Language][Key] or Key
end

function Translations:FromTranslation(Value: string): string?
    for Key, Translation in self[Language] or {} do
        if Value == Translation then return Key end
    end
    return
end

return Translations
