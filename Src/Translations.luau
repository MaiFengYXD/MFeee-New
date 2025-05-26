local Translations = {}

local Language = wax.shared.Language

if Language ~= "en" then
    local task_wait
        = task.wait

    local Success, Result
    local Elasped = 0

    local Thread = coroutine.create(function()
        print(`[MFeee~ New] Fetching translations for {Language}...`)

        Success, Result = pcall(function()
            local UrlContent = game:HttpGet(`https://raw.githubusercontent.com/MaiFengYXD/Translations/refs/heads/main/Translations/{Language}.json`)
            if not (UrlContent:find("{") and UrlContent:find("}")) then
                error("Translations raw page error or HttpGet problem, please report it!", (0 / 0))
            end

            return shared.HttpService:JSONDecode(UrlContent)
        end)
    end)
    coroutine.resume(Thread)

    repeat
        Elasped += task_wait()

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

local Translation = Translations[Language]
local Reverse     = Translations.Reverse

function Translations.GetTranslation(Key: string): string
    return Translation and Translation[Key] or Key
end

function Translations.FromTranslation(Value: string): string?
    return not Translation and Value or Reverse[Value]
end

return Translations
