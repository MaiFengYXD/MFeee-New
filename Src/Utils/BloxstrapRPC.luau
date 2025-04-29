local BloxstrapRPC = {
    Enabled = false,
}

type RichPresence = {
    details:     string?,
    state:       string?,
    timeStart:   number?,
    timeEnd:     number?,
    smallImage:  RichPresenceImage?,
    largeImage:  RichPresenceImage?
}

type RichPresenceImage = {
    assetId:    number?,
    hoverText:  string?,
    clear:      boolean?,
    reset:      boolean?
}

function BloxstrapRPC.SendMessage(Command: string, Data: any)
    local Json = shared.HttpService:JSONEncode({
        command = Command, 
        data = Data
    })

    print(`[BloxstrapRPC] {Json}`)
end

function BloxstrapRPC.SetRichPresence()
    if not BloxstrapRPC.Enabled then return end

    local Data: RichPresence = {
        details = `Playing {shared.GameName} [MFeee~ New | {shared.ScriptVersion}]`,
        state = `{#shared.Players:GetPlayers()} players in the game`,
        largeImage = {
            hoverText = `Using MFeee~ New | {wax.shared.ScriptDisplay}`,
        },
        smallImage = {
            hoverText = shared.Speaker.Name,
        }
    }

    BloxstrapRPC.SendMessage("SetRichPresence", Data)
end

shared.Connection:GiveSignal("BloxstrapRPCAdded"   , shared.Players.PlayerAdded   :Connect(BloxstrapRPC.SetRichPresence))
shared.Connection:GiveSignal("BloxstrapRPCRemoving", shared.Players.PlayerRemoving:Connect(BloxstrapRPC.SetRichPresence))

return BloxstrapRPC
