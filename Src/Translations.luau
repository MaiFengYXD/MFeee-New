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

local Language = wax.shared.Language
--/ Rojo cannot recognize .json files within the Src folder, so I have to use .luau :(
Translations[Language] = require(Language) :: {[string]: string}

function Translations:GetTranslation(Key: string): string
    return self[Language] and self[Language][Key] or Key
end

function Translations:FromTranslation(Value: string): string?
    for Key, Translation in self[Language] do
        if Value == Translation then return Key end
    end
    return
end

return Translations
