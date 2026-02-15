-- Q&J RIVALS HUB V2
-- Toutes les fonctionnalités fonctionnelles
-- Touche INSERT pour ouvrir/fermer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")

-- Variables
local settings = {
    redESP = false,
    silentAim = false,
    silentAimChance = 100,
    silentAimFOV = 200,
    noclip = false,
    infiniteJump = false
}

local connections = {}
local highlights = {}
local fovCircle = nil

-- Fonction de nettoyage
local function cleanup()
    for _, conn in pairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, hl in pairs(highlights) do
        pcall(function() hl:Destroy() end)
    end
    connections = {}
    highlights = {}
end

-- Créer le GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QJRivalsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
end)

-- Frame principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 40, 40)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Barre de titre
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Q&J RIVALS HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = TitleBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Press INSERT to toggle"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 12
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.Parent = MainFrame

-- Container pour les boutons
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -85)
Container.Position = UDim2.new(0, 10, 0, 75)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 40)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = Container

-- Fonction pour créer un bouton toggle
local yOffset = 0
local function createToggle(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.95, 0, 0, 55)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 50, 55)
    Stroke.Thickness = 1
    Stroke.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 60, 0, 30)
    Status.Position = UDim2.new(1, -75, 0.5, -15)
    Status.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Status.Text = "OFF"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 14
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Parent = Button
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = Status
    
    local isEnabled = false
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        Status.Text = isEnabled and "ON" or "OFF"
        Status.BackgroundColor3 = isEnabled and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(50, 50, 55)
        Button.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35)
        Stroke.Color = isEnabled and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(50, 50, 55)
        callback(isEnabled)
    end)
    
    yOffset = yOffset + 65
    return Button
end

-- Fonction pour créer un slider
local function createSlider(text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.95, 0, 0, 80)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = SliderFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 50, 55)
    Stroke.Thickness = 1
    Stroke.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default .. "%"
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(0.9, 0, 0, 10)
    SliderBG.Position = UDim2.new(0.05, 0, 0, 50)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    
    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(default/max, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("Frame")
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new(default/max, -10, 0.5, -10)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Parent = SliderBG
    
    local SliderButtonCorner = Instance.new("UICorner")
    SliderButtonCorner.CornerRadius = UDim.new(1, 0)
    SliderButtonCorner.Parent = SliderButton
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        SliderButton.Position = UDim2.new(pos, -10, 0.5, -10)
        
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value .. "%"
        callback(value)
    end
    
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    SliderBG.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end))
    
    yOffset = yOffset + 90
end

-- Créer les toggles
createToggle("Red ESP", function(enabled)
    settings.redESP = enabled
    
    if enabled then
        local function addESP(plr)
            if plr == player then return end
            
            local function onCharacter(char)
                task.wait(0.1)
                if not char then return end
                
                if highlights[plr] then
                    pcall(function() highlights[plr]:Destroy() end)
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "QJESP"
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(150, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = char
                
                highlights[plr] = highlight
            end
            
            if plr.Character then
                onCharacter(plr.Character)
            end
            
            plr.CharacterAdded:Connect(onCharacter)
        end
        
        for _, plr in pairs(Players:GetPlayers()) do
            addESP(plr)
        end
        
        table.insert(connections, Players.PlayerAdded:Connect(addESP))
        
        table.insert(connections, Players.PlayerRemoving:Connect(function(plr)
            if highlights[plr] then
                pcall(function() highlights[plr]:Destroy() end)
                highlights[plr] = nil
            end
        end))
    else
        for _, hl in pairs(highlights) do
            pcall(function() hl:Destroy() end)
        end
        highlights = {}
    end
end)

createToggle("Silent Aim", function(enabled)
    settings.silentAim = enabled
    
    if enabled and not fovCircle then
        -- Créer le cercle FOV
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 40, 40)
        fovCircle.Transparency = 1
        fovCircle.NumSides = 64
        fovCircle.Radius = settings.silentAimFOV
        fovCircle.Filled = false
        
        table.insert(connections, RunService.RenderStepped:Connect(function()
            if settings.silentAim and fovCircle then
                local screenSize = camera.ViewportSize
                fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                fovCircle.Radius = settings.silentAimFOV
                fovCircle.Visible = true
            end
        end))
    elseif not enabled and fovCircle then
        fovCircle.Visible = false
    end
end)

createSlider("Hit Chance", 0, 100, 100, function(value)
    settings.silentAimChance = value
end)

createSlider("FOV Size", 50, 500, 200, function(value)
    settings.silentAimFOV = value
    if fovCircle then
        fovCircle.Radius = value
    end
end)

createToggle("Noclip", function(enabled)
    settings.noclip = enabled
end)

createToggle("Infinite Jump", function(enabled)
    settings.infiniteJump = enabled
end)

-- Mettre à jour la taille du canvas
Container.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- Fonctionnalités actives

-- Silent Aim avec hook
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (screenPos2D - screenCenter).Magnitude
                    
                    if distance <= settings.silentAimFOV and distance < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Hook pour Mouse
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if settings.silentAim and tostring(self) == "Mouse" and (key == "Hit" or key == "Target") then
        local target = getClosestPlayerInFOV()
        
        if target and math.random(1, 100) <= settings.silentAimChance then
            local head = target.Character and target.Character:FindFirstChild("Head")
            if head then
                if key == "Hit" then
                    return CFrame.new(head.Position)
                elseif key == "Target" then
                    return head
                end
            end
        end
    end
    
    return oldIndex(self, key)
end)

setreadonly(mt, true)

-- Noclip
table.insert(connections, RunService.Stepped:Connect(function()
    if settings.noclip then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- Infinite Jump
table.insert(connections, UserInputService.JumpRequest:Connect(function()
    if settings.infiniteJump then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end))

-- Mise à jour du personnage
table.insert(connections, player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootpart = char:WaitForChild("HumanoidRootPart")
end))

-- Toggle avec INSERT
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end))

-- Cleanup
ScreenGui.Destroying:Connect(function()
    cleanup()
    if fovCircle then
        fovCircle:Remove()
    end
end)

print("Q&J Rivals Hub V2 chargé! Appuie sur INSERT pour ouvrir/fermer")
