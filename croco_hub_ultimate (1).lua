-- CROCO HUB ULTIMATE 🐊
-- ESP + Aimbot qui LOCK et TIRE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- Variables
local settings = {
    redESP = false,
    aimbot = false,
    autoShoot = true,
    aimbotFOV = 200,
    aimbotSmooth = 3,
    targetPart = "Head"
}

local connections = {}
local highlights = {}
local lockedTarget = nil
local fovCircle = nil
local isAimbotActive = false

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
    lockedTarget = nil
end

-- Créer le GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrocoHubUltimate"
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
MainFrame.Size = UDim2.new(0, 420, 0, 500)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 200, 80)
MainStroke.Thickness = 3
MainStroke.Parent = MainFrame

-- Barre de titre
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 28)
TitleFix.Position = UDim2.new(0, 0, 1, -28)
TitleFix.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐊 CROCO HUB ULTIMATE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Bouton Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(1, -90, 0.5, -20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
ToggleBtn.Text = "─"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = TitleBar

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(0, 10)
ToggleBtnCorner.Parent = ToggleBtn

-- Bouton Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 10)
CloseBtnCorner.Parent = CloseBtn

-- Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 1, -80)
Container.Position = UDim2.new(0, 15, 0, 70)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Fonction pour créer un toggle
local function createToggle(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 65)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 50)
    Stroke.Thickness = 2
    Stroke.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 20, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 20
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 80, 0, 40)
    Status.Position = UDim2.new(1, -95, 0.5, -20)
    Status.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Status.Text = "OFF"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 18
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Parent = Button
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 10)
    StatusCorner.Parent = Status
    
    local isEnabled = false
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        Status.Text = isEnabled and "ON" or "OFF"
        Status.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(45, 45, 50)
        Button.BackgroundColor3 = isEnabled and Color3.fromRGB(30, 35, 40) or Color3.fromRGB(25, 25, 30)
        Stroke.Color = isEnabled and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(45, 45, 50)
        callback(isEnabled)
    end)
    
    return Button
end

-- Fonction pour créer un slider
local function createSlider(text, position, min, max, default, suffix, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 90)
    SliderFrame.Position = position
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = SliderFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(45, 45, 50)
    Stroke.Thickness = 2
    Stroke.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 0, 28)
    Label.Position = UDim2.new(0, 15, 0, 12)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default .. (suffix or "")
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(0.88, 0, 0, 14)
    SliderBG.Position = UDim2.new(0.06, 0, 0, 60)
    SliderBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    
    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("Frame")
    SliderButton.Size = UDim2.new(0, 24, 0, 24)
    SliderButton.Position = UDim2.new((default - min)/(max - min), -12, 0.5, -12)
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
        SliderButton.Position = UDim2.new(pos, -12, 0.5, -12)
        
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value .. (suffix or "")
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
end

-- Red ESP Toggle
createToggle("Red ESP", UDim2.new(0, 0, 0, 0), function(enabled)
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
                highlight.Name = "CrocoESP"
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                highlight.FillTransparency = 0.4
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

-- Aimbot Toggle
createToggle("Aimbot Lock + Shoot", UDim2.new(0, 0, 0, 75), function(enabled)
    settings.aimbot = enabled
    
    if enabled then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Visible = true
            fovCircle.Thickness = 2.5
            fovCircle.Color = Color3.fromRGB(40, 200, 80)
            fovCircle.Transparency = 1
            fovCircle.NumSides = 100
            fovCircle.Radius = settings.aimbotFOV
            fovCircle.Filled = false
        end
        
        table.insert(connections, RunService.RenderStepped:Connect(function()
            if settings.aimbot and fovCircle then
                local screenSize = camera.ViewportSize
                fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                fovCircle.Radius = settings.aimbotFOV
                fovCircle.Visible = true
            end
        end))
    else
        if fovCircle then
            fovCircle.Visible = false
        end
        lockedTarget = nil
        isAimbotActive = false
    end
end)

-- Auto Shoot Toggle
createToggle("Auto Shoot", UDim2.new(0, 0, 0, 150), function(enabled)
    settings.autoShoot = enabled
end)

-- FOV Size Slider
createSlider("FOV Size", UDim2.new(0, 0, 0, 225), 50, 600, 200, " px", function(value)
    settings.aimbotFOV = value
    if fovCircle then
        fovCircle.Radius = value
    end
end)

-- Smoothness Slider
createSlider("Smoothness", UDim2.new(0, 0, 0, 325), 1, 15, 3, "", function(value)
    settings.aimbotSmooth = value
end)

-- Fonction pour trouver le joueur le plus proche dans le FOV
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetPart = plr.Character:FindFirstChild(settings.targetPart)
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen then
                    local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (screenPos2D - screenCenter).Magnitude
                    
                    if distance <= settings.aimbotFOV and distance < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Détection clic droit
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAimbotActive = true
        if settings.aimbot then
            lockedTarget = getClosestPlayerInFOV()
        end
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAimbotActive = false
        lockedTarget = nil
    end
end))

-- Aimbot Loop avec tir automatique
table.insert(connections, RunService.RenderStepped:Connect(function()
    if settings.aimbot and isAimbotActive then
        -- Trouver une cible si on n'en a pas ou si la cible actuelle est morte
        if not lockedTarget or not lockedTarget.Character then
            lockedTarget = getClosestPlayerInFOV()
        end
        
        if lockedTarget and lockedTarget.Character then
            local targetPart = lockedTarget.Character:FindFirstChild(settings.targetPart)
            local humanoid = lockedTarget.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                -- Lock la caméra sur la cible
                local targetPos = targetPart.Position
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                
                -- Smooth aim
                camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / settings.aimbotSmooth)
                
                -- Auto shoot
                if settings.autoShoot then
                    -- Simuler un clic gauche
                    mouse1click()
                end
            else
                lockedTarget = nil
            end
        end
    end
end))

-- Bouton Toggle (minimiser)
local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Container.Visible = not isMinimized
    
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 420, 0, 55)
        ToggleBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 420, 0, 500)
        ToggleBtn.Text = "─"
    end
end)

-- Bouton Close
CloseBtn.MouseButton1Click:Connect(function()
    cleanup()
    if fovCircle then
        fovCircle:Remove()
    end
    ScreenGui:Destroy()
end)

-- Cleanup final
ScreenGui.Destroying:Connect(function()
    cleanup()
    if fovCircle then
        fovCircle:Remove()
    end
end)

-- Info de chargement
local function createNotification(title, text, duration)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    NotifFrame.Position = UDim2.new(1, -320, 1, -100)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifFrame
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(40, 200, 80)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = NotifFrame
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 25)
    NotifTitle.Position = UDim2.new(0, 10, 0, 8)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = title
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextSize = 16
    NotifTitle.TextColor3 = Color3.fromRGB(40, 200, 80)
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotifFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 0, 40)
    NotifText.Position = UDim2.new(0, 10, 0, 35)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextSize = 14
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextWrapped = true
    NotifText.Parent = NotifFrame
    
    task.wait(duration or 3)
    NotifFrame:Destroy()
end

task.spawn(function()
    createNotification("🐊 CROCO HUB ULTIMATE", "Maintiens CLIC DROIT pour lock & shoot", 5)
end)

print("🐊 CROCO HUB ULTIMATE chargé!")
print("━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ Red ESP: Voir les ennemis")
print("🎯 Aimbot: Lock sur la tête")
print("🔫 Auto Shoot: Tire automatiquement")
print("━━━━━━━━━━━━━━━━━━━━━━━━")
print("🖱️ Maintiens CLIC DROIT pour activer")
