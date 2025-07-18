local Translations = {
    Reverse = {}
}

local Language = shared.Language

if Language ~= "en" then
    local task_wait
        = task.wait

    local Success, Result
    local Elasped = 0

    local Thread = task.spawn(function()
        print(`[MFeee~ New] Fetching translations for {Language}...`)

        Success, Result = pcall(function(HttpGet)
            local UrlContent = HttpGet(`https://raw.githubusercontent.com/MaiFengYXD/Translations/refs/heads/main/Translations/{Language}.json`)
            if not (UrlContent:find("{") and UrlContent:find("}")) then
                error("Translations raw page error or HttpGet problem, please report it!", 19998)
            end

            return shared.HttpService:JSONDecode(UrlContent)
        end, wax.Global.HttpGet)
    end)

    repeat
        Elasped += task_wait()

        if Elasped >= 10 then
            task.cancel(Thread)
            Success = false
            Result  = "Timeout! time exceeded 10 seconds."
        end
    until Success ~= nil

    if Success then
        Translations[Language] = Result
    else
        if Result:find("HttpGet is not a valid member of") then
            Result = "Missing 'HttpGet' function!"
        end

        shared.MiniNotify("Translations:", `Failed to fetch translations for {Language} due to "{Result}"`)
    end
end

local Translation = Translations[Language]
local Reverse     = Translations.Reverse

if Translation then
    for Key, Value in Translation do
        Reverse[Value] = Key
    end
end

function Translations.GetTranslation(Key: string): string
    return Translation and Translation[Key] or Key
end

function Translations.FromTranslation(Value: string): string?
    return Translation and Reverse[Value] or Value
end

return Translations
