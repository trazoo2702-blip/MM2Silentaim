-- MM2 2026 - Silent Aim  + ESP Pre-Ronda + Grab Gun Mejorado
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "MM2 2026",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "",
})

local Tab = Window:CreateTab("MM2", 4483362458)

local silentEnabled = false
local knifeSilent = false
local gunSilent = false
local espEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MM2ESP"
ESPFolder.Parent = game.CoreGui


local function getRole(plr)
    if not plr or not plr.Character then return "Innocent" end
    local char = plr.Character
    local bp = plr:FindFirstChild("Backpack")

   
    if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then
        return "Murderer"
    elseif char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Revolver") then
        return "Sheriff"
    end
    return "Innocent"
end

local function updateESP()
    ESPFolder:ClearAllChildren()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = Instance.new("Highlight")
            hl.Adornee = plr.Character
            hl.FillTransparency = 0.4
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            local role = getRole(plr)
            if role == "Murderer" then
                hl.FillColor = Color3.fromRGB(255, 30, 30)
            elseif role == "Sheriff" then
                hl.FillColor = Color3.fromRGB(30, 100, 255)
            else
                hl.FillColor = Color3.fromRGB(30, 255, 80)
            end
            hl.Parent = ESPFolder
        end
    end
end


local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    local name = tostring(self):lower()

    if silentEnabled and method == "FireServer" then
        local target = nil

        
        if gunSilent and (name:find("gun") or name:find("shoot") or name:find("fire") or name:find("revolver")) then
            target = getMurderer()
        end

        
        if knifeSilent and (name:find("knife") or name:find("throw") or name:find("stab")) then
            target = getClosestPlayer()
        end

        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local pos = target.Character.HumanoidRootPart.Position

            if gunSilent and (name:find("gun") or name:find("shoot") or name:find("fire")) then
                args[2] = pos  
            elseif knifeSilent then
                args[1] = pos
            end
        end
    end

    return old(self, unpack(args))
end)

setreadonly(mt, true)

function getMurderer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and getRole(plr) == "Murderer" then
            return plr
        end
    end
    return nil
end

function getClosestPlayer()
    local closest, dist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (plr.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            if d < dist then dist = d closest = plr end
        end
    end
    return closest
end

-- ================== GRAB GUN MÁS AGRESIVO ==================
local function grabGun()
    Rayfield:Notify({Title = "Grab Gun", Content = "grabing gun", Duration = 2})

    -- Busca todos los posibles remotes
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("gun") or n:find("pick") or n:find("grab") or n:find("tool") or n:find("equip") then
                pcall(function() v:FireServer() end)
            end
        end
    end

    
    for _, tool in ipairs(workspace:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:find("Gun") or tool.Name:find("Knife")) then
            pcall(function() LocalPlayer.Character.Humanoid:EquipTool(tool) end)
        end
    end
end

-- ================== TOGGLES ==================
Tab:CreateToggle({Name = "Silent Aim Activado", CurrentValue = false, Callback = function(v) silentEnabled = v end})
Tab:CreateToggle({Name = "Silent Aim Knife (más cercano)", CurrentValue = true, Callback = function(v) knifeSilent = v end})
Tab:CreateToggle({Name = "Silent Aim Gun (SOLO Murderer)", CurrentValue = true, Callback = function(v) gunSilent = v end})

Tab:CreateToggle({ 
    Name = "Role ESP (pre-round)", 
    CurrentValue = false, 
    Callback = function(v) 
        if v then
            RunService:BindToRenderStep("ESP", 50, updateESP)  
        else
            RunService:UnbindFromRenderStep("ESP")
            ESPFolder:ClearAllChildren()
        end
    end 
})

Tab:CreateButton({Name = " Grab Gun", Callback = grabGun})

Rayfield:Notify({Title = "Script Cargado", Content = "Silent Aim mejorado + ESP pre-ronda + Grab Gun fuerte", Duration = 6})
