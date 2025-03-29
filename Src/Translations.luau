local Translations = {}

function Translations:GetTranslation(Key: string): string
    return Translations[wax.shared.Langauge] and Translations[wax.shared.Langauge][Key] or Key
end

Translations["zh-cn"] = {
    
}

return Translations