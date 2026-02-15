-- Q&J RIVALS HUB
-- Interface mobile avec ESP, Silent Aim, Noclip, Infinite Jump

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Variables de configuration
local settings = {
    redESP = false,
    silentAim = false,
    silentAimChance = 100,
    noclip = false,
    infiniteJump = false
}

-- Cleanup
local connections = {}
local highlights = {}

local function cleanup()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    for _, hl in pairs(highlights) do
        if hl then hl:Destroy() end
    end
    connections = {}
    highlights = {}
end

-- Créer l'interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QJRivalsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection
local success = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Frame principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Titre
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Q&J RIVALS HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Parent = MainFrame

-- Fonction pour créer un bouton toggle
local function createToggleButton(text, position, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 50)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    Button.BorderSizePixel = 0
    Button.Text = text .. ": OFF"
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 20
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Parent = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Button
    
    local isEnabled = false
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        Button.Text = text .. ": " .. (isEnabled and "ON" or "OFF")
        Button.BackgroundColor3 = isEnabled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(40, 45, 60)
        callback(isEnabled)
    end)
    
    return Button
end

-- Red ESP Button
createToggleButton("Red ESP", UDim2.new(0.05, 0, 0, 80), function(enabled)
    settings.redESP = enabled
    
    if enabled then
        -- Créer ESP pour tous les joueurs
        local function addESP(plr)
            if plr == player then return end
            
            local function onCharacter(char)
                if highlights[plr] then
                    highlights[plr]:Destroy()
                end
                
                local highlight = Instance.new("Highlight")
                highlight.Name = "QJRivalsESP"
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
    else
        -- Supprimer tous les ESP
        for _, hl in pairs(highlights) do
            if hl then hl:Destroy() end
        end
        highlights = {}
    end
end)

-- Silent Aim Button
createToggleButton("Silent Aim", UDim2.new(0.05, 0, 0, 150), function(enabled)
    settings.silentAim = enabled
end)

-- Silent Aim Hit Chance Slider
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0.9, 0, 0, 70)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 220)
SliderFrame.BackgroundTransparency = 1
SliderFrame.Parent = MainFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 25)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Silent Aim Hit Chance: 100%"
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 16
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.Parent = SliderFrame

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, 0, 0, 8)
SliderBG.Position = UDim2.new(0, 0, 0, 35)
SliderBG.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = SliderFrame

local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(1, 0)
SliderBGCorner.Parent = SliderBG

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(1, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderButton = Instance.new("Frame")
SliderButton.Size = UDim2.new(0, 25, 0, 25)
SliderButton.Position = UDim2.new(1, -12.5, 0.5, -12.5)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBG

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(1, 0)
SliderButtonCorner.Parent = SliderButton

-- Slider dragging
local dragging = false
local function updateSlider(input)
    local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    SliderButton.Position = UDim2.new(pos, -12.5, 0.5, -12.5)
    
    local value = math.floor(pos * 100)
    settings.silentAimChance = value
    SliderLabel.Text = string.format("Silent Aim Hit Chance: %d%%", value)
end

SliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider(input)
    end
end)

SliderBG.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end))

-- Noclip Button
createToggleButton("Noclip", UDim2.new(0.05, 0, 0, 310), function(enabled)
    settings.noclip = enabled
end)

-- Infinite Jump Button
createToggleButton("Infinite Jump", UDim2.new(0.05, 0, 0, 380), function(enabled)
    settings.infiniteJump = enabled
end)

-- Rendre draggable
local draggingUI = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingUI = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and draggingUI then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end))

-- Fonctionnalités

-- Silent Aim
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if settings.silentAim and method == "FireServer" and self.Name == "RemoteEvent" then
        -- Vérifier si c'est un event de tir (à adapter selon ton jeu)
        if math.random(1, 100) <= settings.silentAimChance then
            local target = nil
            local closestDistance = math.huge
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                    local head = plr.Character.Head
                    local distance = (head.Position - camera.CFrame.Position).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        target = head
                    end
                end
            end
            
            if target then
                -- Modifier les arguments pour viser la tête
                if typeof(args[1]) == "Vector3" then
                    args[1] = target.Position
                elseif typeof(args[2]) == "Vector3" then
                    args[2] = target.Position
                end
            end
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

-- Noclip
table.insert(connections, RunService.Stepped:Connect(function()
    if settings.noclip then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- Infinite Jump
table.insert(connections, UserInputService.JumpRequest:Connect(function()
    if settings.infiniteJump then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end))

-- Cleanup à la destruction du GUI
ScreenGui.Destroying:Connect(cleanup)

print("Q&J Rivals Hub chargé avec succès!")
