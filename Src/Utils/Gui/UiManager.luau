--[[
    Imagine rewriting UIManager
    -- MaiFengYXD
--]]

--[[
    shared:
    ```luau
    {
        NotifySound     = "Obsidian",
        NotifySide      = "TopRight",
        EasingMode      = "Quartic",
        EasingDirection = "Out",
        ToggleKeybind1  = "KeyCode",
        ToggleKeybind2  = "RightControl",
        ForceCheckbox   = false,
        CustomCursor    = false,
        KeybindFrame    = false,
        AlwaysOnTop     = false,
        DisableNotify   = false,
        UIActivated     = true,
        UICorner        = 5,
        DPIScale        = 100,
        Skipped         = 0,
        NotifyVolume    = 200,
        EasingDuration  = 1
    }
    ```

    tips:
    ```luau
    local Random  = Random.new()

    local TipTitles = {
        "Did you know?",
        "Guess what?",
        "Loading...",
        "@upio:",
        "Do you know?",
        "Tip hunt:",
        "MOTD:",
        "Calculating:",
        "Did you know?",
        "Error:",
        "@fr:",
        "upio:",
        "upio:",
        ""
    }

    local TipContents = {
        "You can click on the notification to close it.",
        "You can actually bind any key to open the menu (even mouse buttons <s>although it's stupid fr</s>)",
        "Fetching new tips... (remaining 2147483647 years)",
        "when i skidded and pasted the most",
        "Click me to skip to the next tip",
        "Our tips are currently on vacation, please try again <s>never</s>later",
        "zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib zib z",
        "Determining the precise gravitational pull exerted by this tip on your mouse cursor... (requires planetary alignment)",
        "Are you reading this tip, or is this tip reading you?🤫🧏",
        "Failed to load tips: Server error, firefighters are putting out the fire on our server",
        "",
        "if no bypass is detected we detect one",
        "If no executor is detected, we default to a generic bypass",
        "<b>⚠️ YOUR SITE HAS BEN DDOS PLEASE SEND 20$ TO UNDDOS</b> :"
    }

    for Index, Content in TipTitles do
        TipTitles[Index]   = GetTranslation(Content)
    end

    for Index, Content in TipContents do
        TipContents[Index] = GetTranslation(Content)
    end

    local function FormatTip(Title, Content)
        return `<u><b><i>{Title}</i></b></u>\n{Content}`
    end

    local AllTips = #TipTitles

    local CurrentIndex = Random:NextInteger(1, AllTips)
    local CurrentTip   = FormatTip(TipTitles[CurrentIndex], TipContents[CurrentIndex])

    AllTips += 1

    table_insert(TipTitles  , GetTranslation("Funny trivia:"))
    table_insert(TipContents, string_format(GetTranslation("You had %f%% chance to roll this tip"), 1 / AllTips * 100))
    ```
--]]

local UIManager = {}



return UIManager
