-- CROCO HUB ULTIMATE 🐊 - AVEC SYSTÈME DE CLÉS
-- Loader avec Key System

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Liste des clés valides
local validKeys = {
    "freebycroco"
}

-- Créer le GUI du Key System
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "CrocoKeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.DisplayOrder = 999999999

pcall(function()
    if gethui then
        KeyGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(KeyGui)
        KeyGui.Parent = CoreGui
    else
        KeyGui.Parent = CoreGui
    end
end)

-- Frame principale
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 0, 0, 0)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KeyFrame.BorderSizePixel = 0
KeyFrame.ClipsDescendants = true
KeyFrame.Parent = KeyGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 15)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(40, 200, 80)
KeyStroke.Thickness = 3
KeyStroke.Parent = KeyFrame

-- Logo/Icon
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 100, 0, 100)
LogoFrame.Position = UDim2.new(0.5, -50, 0, 30)
LogoFrame.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = KeyFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 20)
LogoCorner.Parent = LogoFrame

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "🐊"
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 60
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.Parent = LogoFrame

-- Titre
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 20, 0, 145)
Title.BackgroundTransparency = 1
Title.Text = "CROCO HUB ULTIMATE"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(40, 200, 80)
Title.Parent = KeyFrame

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 30)
Subtitle.Position = UDim2.new(0, 20, 0, 185)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Enter your key to continue"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 16
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.Parent = KeyFrame

-- Input de clé
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -60, 0, 50)
KeyInput.Position = UDim2.new(0, 30, 0, 235)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
KeyInput.BorderSizePixel = 0
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 18
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInput

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(45, 45, 50)
KeyInputStroke.Thickness = 2
KeyInputStroke.Parent = KeyInput

-- Bouton "Get Key"
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.45, -20, 0, 50)
GetKeyBtn.Position = UDim2.new(0, 30, 0, 300)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Text = "Get Key"
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 18
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Parent = KeyFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyBtn

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(255, 180, 50)
GetKeyStroke.Thickness = 2
GetKeyStroke.Parent = GetKeyBtn

-- Bouton "Check Key"
local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0.45, -20, 0, 50)
CheckKeyBtn.Position = UDim2.new(0.55, 10, 0, 300)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
CheckKeyBtn.BorderSizePixel = 0
CheckKeyBtn.Text = "Check Key"
CheckKeyBtn.Font = Enum.Font.GothamBold
CheckKeyBtn.TextSize = 18
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.Parent = KeyFrame

local CheckKeyCorner = Instance.new("UICorner")
CheckKeyCorner.CornerRadius = UDim.new(0, 10)
CheckKeyCorner.Parent = CheckKeyBtn

-- Label de statut
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -60, 0, 30)
StatusLabel.Position = UDim2.new(0, 30, 0, 365)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.Parent = KeyFrame

-- Animation d'ouverture
local function openKeyFrame()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(KeyFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 420)})
    tween:Play()
end

-- Fonction pour vérifier la clé
local function checkKey()
    local enteredKey = KeyInput.Text
    
    if enteredKey == "" then
        StatusLabel.Text = "⚠️ Please enter a key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 50)
        return
    end
    
    local isValid = false
    for _, key in ipairs(validKeys) do
        if enteredKey == key then
            isValid = true
            break
        end
    end
    
    if isValid then
        StatusLabel.Text = "✅ Key Valid! Loading Croco Hub..."
        StatusLabel.TextColor3 = Color3.fromRGB(40, 200, 80)
        
        -- Animation de fermeture
        task.wait(1)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(KeyFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Wait()
        
        KeyGui:Destroy()
        
        -- Charger le hub principal
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TexxSave/rivals-QG-/refs/heads/main/croco_hub_ultimate.lua"))()
    else
        StatusLabel.Text = "❌ Invalid Key! Try again."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyInput.Text = ""
    end
end

-- Bouton Get Key
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/bES4cJPgqc")
    StatusLabel.Text = "📋 Discord link copied! Get your key there."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
end)

-- Bouton Check Key
CheckKeyBtn.MouseButton1Click:Connect(function()
    checkKey()
end)

-- Vérifier avec Entrée
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

-- Ouvrir le frame
openKeyFrame()

print("🐊 Croco Hub Key System chargé!")
print("━━━━━━━━━━━━━━━━━━━━━━━━")
print("Clé valide:")
print("• freebycroco")
print("━━━━━━━━━━━━━━━━━━━━━━━━")
print("Discord: https://discord.gg/bES4cJPgqc")
