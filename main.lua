-- CROCO HUB 🐊
-- ESP + Aimbot Lock

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- Variables
local settings = {
    redESP = false,
    aimbot = false,
    aimbotFOV = 200,
    aimbotSmooth = 5
}

local connections = {}
local highlights = {}
local lockedTarget = nil
local fovCircle = nil
local isAimbotKeyDown = false

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
ScreenGui.Name = "CrocoHub"
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
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 200, 100)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Barre de titre
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 25)
TitleFix.Position = UDim2.new(0, 0, 1, -25)
TitleFix.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐊 CROCO HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Bouton Toggle (minimiser)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 35, 0, 35)
ToggleBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
ToggleBtn.Text = "—"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = TitleBar

local ToggleBtnCorner = Instance.new("UICorner")
ToggleBtnCorner.CornerRadius = UDim.new(0, 8)
ToggleBtnCorner.Parent = ToggleBtn

-- Bouton Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Container pour les boutons
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -70)
Container.Position = UDim2.new(0, 10, 0, 60)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Parent = MainFrame

-- Fonction pour créer un bouton toggle
local function createToggle(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 60)
    Button.Position = position
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
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 20
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 70, 0, 35)
    Status.Position = UDim2.new(1, -85, 0.5, -17.5)
    Status.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Status.Text = "OFF"
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 16
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Parent = Button
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = Status
    
    local isEnabled = false
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        Status.Text = isEnabled and "ON" or "OFF"
        Status.BackgroundColor3 = isEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 50, 55)
        Button.BackgroundColor3 = isEnabled and Color3.fromRGB(40, 40, 45) or Color3.fromRGB(30, 30, 35)
        Stroke.Color = isEnabled and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(50, 50, 55)
        callback(isEnabled)
    end)
    
    return Button
end

-- Fonction pour créer un slider
local function createSlider(text, position, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 85)
    SliderFrame.Position = position
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
    Label.Position = UDim2.new(0, 10, 0, 10)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. default
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(0.9, 0, 0, 12)
    SliderBG.Position = UDim2.new(0.05, 0, 0, 55)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBG.BorderSizePixel = 0
    SliderBG.Parent = SliderFrame
    
    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBG
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("Frame")
    SliderButton.Size = UDim2.new(0, 22, 0, 22)
    SliderButton.Position = UDim2.new((default - min)/(max - min), -11, 0.5, -11)
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
        SliderButton.Position = UDim2.new(pos, -11, 0.5, -11)
        
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value
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
createToggle("Red ESP", UDim2.new(0, 0, 0, 10), function(enabled)
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

-- Aimbot Lock Toggle
createToggle("Aimbot Lock (Right Click)", UDim2.new(0, 0, 0, 80), function(enabled)
    settings.aimbot = enabled
    
    if enabled then
        -- Créer le cercle FOV
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Visible = true
            fovCircle.Thickness = 2
            fovCircle.Color = Color3.fromRGB(50, 200, 100)
            fovCircle.Transparency = 1
            fovCircle.NumSides = 64
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
    end
end)

-- FOV Size Slider
createSlider("FOV Size", UDim2.new(0, 0, 0, 150), 50, 500, 200, function(value)
    settings.aimbotFOV = value
    if fovCircle then
        fovCircle.Radius = value
    end
end)

-- Smoothness Slider
createSlider("Aimbot Smoothness", UDim2.new(0, 0, 0, 245), 1, 20, 5, function(value)
    settings.aimbotSmooth = value
end)

-- Fonction pour trouver le joueur le plus proche dans le FOV
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

-- Détection du clic droit
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAimbotKeyDown = true
        if settings.aimbot then
            lockedTarget = getClosestPlayerInFOV()
        end
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAimbotKeyDown = false
        lockedTarget = nil
    end
end))

-- Aimbot Loop
table.insert(connections, RunService.RenderStepped:Connect(function()
    if settings.aimbot and isAimbotKeyDown and lockedTarget then
        local target = lockedTarget
        
        if target.Character then
            local head = target.Character:FindFirstChild("Head")
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local targetPos = head.Position
                local currentCFrame = camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                
                -- Smooth aim
                camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / settings.aimbotSmooth)
            else
                lockedTarget = nil
            end
        else
            lockedTarget = nil
        end
    end
end))

-- Bouton Toggle (minimiser)
local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Container.Visible = not isMinimized
    
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 50)
        ToggleBtn.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 450)
        ToggleBtn.Text = "—"
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

-- Cleanup
ScreenGui.Destroying:Connect(function()
    cleanup()
    if fovCircle then
        fovCircle:Remove()
    end
end)

print("🐊 Croco Hub chargé!")
print("Maintiens CLIC DROIT pour lock l'aimbot")
