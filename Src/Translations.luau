local Translations = {}

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
