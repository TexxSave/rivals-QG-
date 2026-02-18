-- CROCO HUB ULTIMATE V3 FINAL 🐊
-- Avec ESP, Aimbot, Movement, Visuals, Unlock All et plus!

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

                -- CHARGER LE HUB PRINCIPAL
        local camera = Workspace.CurrentCamera
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootpart = character:WaitForChild("HumanoidRootPart")
        
        -- Variables principales
        local settings = {
            redESP = false,
            rainbowESP = false,
            espTransparency = 0.4,
            aimbot = false,
            aimbotLock = false,
            autoShoot = false,
            triggerBot = false,
            aimbotFOV = 200,
            aimbotSmooth = 3,
            targetPart = "Head",
            showFOV = true,
            noclip = false,
            infiniteJump = false,
            speedEnabled = false,
            walkSpeed = 16,
            fly = false,
            flySpeed = 50,
            jumpPower = 50,
            fullbright = false,
            noFog = false,
            fovChanger = false,
            fovValue = 70,
            thirdPerson = false,
            antiAFK = false,
            spinbot = false,
            spinSpeed = 10
        }
        
        local connections = {}
        local highlights = {}
        local lockedTarget = nil
        local fovCircle = nil
        local isRightClickHeld = false
        local rainbowHue = 0
        local flyConnection = nil
        
        local originalValues = {
            walkSpeed = humanoid.WalkSpeed,
            jumpPower = humanoid.JumpPower,
            fov = camera.FieldOfView
        }
        
        local function cleanup()
            for _, conn in pairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            for _, hl in pairs(highlights) do
                pcall(function() hl:Destroy() end)
            end
            if flyConnection then
                flyConnection:Disconnect()
            end
            connections = {}
            highlights = {}
            lockedTarget = nil
            
            if humanoid then
                humanoid.WalkSpeed = originalValues.walkSpeed
                humanoid.JumpPower = originalValues.jumpPower
            end
            camera.FieldOfView = originalValues.fov
        end
        
        -- Créer le GUI du hub
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
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 450, 0, 650)
        MainFrame.Position = UDim2.new(0.5, -225, 0.5, -325)
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
        Title.Size = UDim2.new(0.6, 0, 1, 0)
        Title.Position = UDim2.new(0, 20, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "🐊 CROCO HUB V3"
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 22
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar
        
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
        
        local ScrollFrame = Instance.new("ScrollingFrame")
        ScrollFrame.Size = UDim2.new(1, -30, 1, -80)
        ScrollFrame.Position = UDim2.new(0, 15, 0, 70)
        ScrollFrame.BackgroundTransparency = 1
        ScrollFrame.BorderSizePixel = 0
        ScrollFrame.ScrollBarThickness = 6
        ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 200, 80)
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 2400)
        ScrollFrame.Parent = MainFrame
        
        local yOffset = 0
        
        local function createToggle(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 65)
            Button.Position = UDim2.new(0, 0, 0, yOffset)
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Button.BorderSizePixel = 0
            Button.Text = ""
            Button.AutoButtonColor = false
            Button.Parent = ScrollFrame
            
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
            Label.TextSize = 17
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
            
            yOffset = yOffset + 75
            return Button
        end
        
        local function createSlider(text, min, max, default, suffix, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 90)
            SliderFrame.Position = UDim2.new(0, 0, 0, yOffset)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = ScrollFrame
            
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
            Label.TextSize = 17
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
            
            yOffset = yOffset + 100
        end
        
        local function createDivider(text)
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 40)
            Divider.Position = UDim2.new(0, 0, 0, yOffset)
            Divider.BackgroundTransparency = 1
            Divider.Parent = ScrollFrame
            
            local DividerLabel = Instance.new("TextLabel")
            DividerLabel.Size = UDim2.new(1, -20, 1, 0)
            DividerLabel.Position = UDim2.new(0, 10, 0, 0)
            DividerLabel.BackgroundTransparency = 1
            DividerLabel.Text = "═══ " .. text .. " ═══"
            DividerLabel.Font = Enum.Font.GothamBold
            DividerLabel.TextSize = 16
            DividerLabel.TextColor3 = Color3.fromRGB(40, 200, 80)
            DividerLabel.Parent = Divider
            
            yOffset = yOffset + 50
        end
        
        local function createActionButton(text, buttonText, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 65)
            Frame.Position = UDim2.new(0, 0, 0, yOffset)
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Frame.BorderSizePixel = 0
            Frame.Parent = ScrollFrame
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 12)
            Corner.Parent = Frame
            
            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Color3.fromRGB(45, 45, 50)
            Stroke.Thickness = 2
            Stroke.Parent = Frame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.55, 0, 1, 0)
            Label.Position = UDim2.new(0, 20, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 17
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Size = UDim2.new(0, 110, 0, 40)
            ActionBtn.Position = UDim2.new(1, -125, 0.5, -20)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
            ActionBtn.Text = buttonText
            ActionBtn.Font = Enum.Font.GothamBold
            ActionBtn.TextSize = 16
            ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Parent = Frame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 10)
            BtnCorner.Parent = ActionBtn
            
            ActionBtn.MouseButton1Click:Connect(function()
                callback(ActionBtn)
            end)
            
            yOffset = yOffset + 75
            return ActionBtn
        end
        
        -- ========== ESP ==========
        createDivider("ESP")
        
        createToggle("Red ESP", function(enabled)
            settings.redESP = enabled
            if enabled then
                settings.rainbowESP = false
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
                        highlight.FillTransparency = settings.espTransparency
                        highlight.OutlineTransparency = 0
                        highlight.Parent = char
                        highlights[plr] = highlight
                    end
                    if plr.Character then onCharacter(plr.Character) end
                    plr.CharacterAdded:Connect(onCharacter)
                end
                for _, plr in pairs(Players:GetPlayers()) do addESP(plr) end
                table.insert(connections, Players.PlayerAdded:Connect(addESP))
                table.insert(connections, Players.PlayerRemoving:Connect(function(plr)
                    if highlights[plr] then
                        pcall(function() highlights[plr]:Destroy() end)
                        highlights[plr] = nil
                    end
                end))
            else
                for _, hl in pairs(highlights) do pcall(function() hl:Destroy() end) end
                highlights = {}
            end
        end)
        
        createToggle("Rainbow ESP", function(enabled)
            settings.rainbowESP = enabled
            if enabled then
                settings.redESP = false
                local function addRainbowESP(plr)
                    if plr == player then return end
                    local function onCharacter(char)
                        task.wait(0.1)
                        if not char then return end
                        if highlights[plr] then pcall(function() highlights[plr]:Destroy() end) end
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "CrocoESP"
                        highlight.Adornee = char
                        highlight.FillColor = Color3.fromHSV(0, 1, 1)
                        highlight.OutlineColor = Color3.fromHSV(0, 1, 0.8)
                        highlight.FillTransparency = settings.espTransparency
                        highlight.OutlineTransparency = 0
                        highlight.Parent = char
                        highlights[plr] = highlight
                    end
                    if plr.Character then onCharacter(plr.Character) end
                    plr.CharacterAdded:Connect(onCharacter)
                end
                for _, plr in pairs(Players:GetPlayers()) do addRainbowESP(plr) end
                table.insert(connections, Players.PlayerAdded:Connect(addRainbowESP))
                table.insert(connections, RunService.RenderStepped:Connect(function()
                    if settings.rainbowESP then
                        rainbowHue = (rainbowHue + 0.005) % 1
                        for _, hl in pairs(highlights) do
                            if hl and hl.Parent then
                                hl.FillColor = Color3.fromHSV(rainbowHue, 1, 1)
                                hl.OutlineColor = Color3.fromHSV(rainbowHue, 1, 0.8)
                            end
                        end
                    end
                end))
            else
                for _, hl in pairs(highlights) do pcall(function() hl:Destroy() end) end
                highlights = {}
            end
        end)
        
        createSlider("ESP Transparency", 0, 100, 40, "%", function(value)
            settings.espTransparency = value / 100
            for _, hl in pairs(highlights) do
                if hl and hl.Parent then
                    hl.FillTransparency = settings.espTransparency
                end
            end
        end)
        
        -- ========== AIMBOT ==========
        createDivider("Aimbot")
        
        createToggle("Aimbot Lock Only", function(enabled)
            settings.aimbotLock = enabled
            if enabled then
                settings.aimbot = false
                if not fovCircle then
                    fovCircle = Drawing.new("Circle")
                    fovCircle.Visible = true
                    fovCircle.Thickness = 2.5
                    fovCircle.Color = Color3.fromRGB(100, 150, 255)
                    fovCircle.Transparency = 1
                    fovCircle.NumSides = 100
                    fovCircle.Radius = settings.aimbotFOV
                    fovCircle.Filled = false
                end
                table.insert(connections, RunService.RenderStepped:Connect(function()
                    if settings.aimbotLock and fovCircle and settings.showFOV then
                        local screenSize = camera.ViewportSize
                        fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                        fovCircle.Radius = settings.aimbotFOV
                        fovCircle.Visible = true
                    end
                end))
            else
                if fovCircle then fovCircle.Visible = false end
                lockedTarget = nil
            end
        end)
        
        createToggle("Aimbot Lock + Shoot", function(enabled)
            settings.aimbot = enabled
            if enabled then
                settings.aimbotLock = false
                settings.autoShoot = true
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
                    if settings.aimbot and fovCircle and settings.showFOV then
                        local screenSize = camera.ViewportSize
                        fovCircle.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                        fovCircle.Radius = settings.aimbotFOV
                        fovCircle.Visible = true
                    end
                end))
            else
                if fovCircle then fovCircle.Visible = false end
                lockedTarget = nil
            end
        end)
        
        createToggle("Trigger Bot", function(enabled)
            settings.triggerBot = enabled
        end)
        
        createToggle("Show FOV Circle", function(enabled)
            settings.showFOV = enabled
            if fovCircle then
                fovCircle.Visible = enabled and (settings.aimbot or settings.aimbotLock)
            end
        end)
        
        createSlider("FOV Size", 50, 600, 200, " px", function(value)
            settings.aimbotFOV = value
            if fovCircle then fovCircle.Radius = value end
        end)
        
        createSlider("Smoothness", 1, 20, 3, "", function(value)
            settings.aimbotSmooth = value
        end)
        
        -- ========== MOVEMENT ==========
        createDivider("Movement")
        
        createToggle("Noclip", function(enabled)
            settings.noclip = enabled
        end)
        
        createToggle("Infinite Jump", function(enabled)
            settings.infiniteJump = enabled
        end)
        
        createToggle("Speed Hack", function(enabled)
            settings.speedEnabled = enabled
            if not enabled and humanoid then
                humanoid.WalkSpeed = originalValues.walkSpeed
            end
        end)
        
        createSlider("Walk Speed", 16, 500, 16, "", function(value)
            settings.walkSpeed = value
            if settings.speedEnabled and humanoid then
                humanoid.WalkSpeed = value
            end
        end)
        
        createToggle("Fly", function(enabled)
            settings.fly = enabled
            if enabled then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.zero
                bv.Parent = rootpart
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 10000
                bg.D = 500
                bg.Parent = rootpart
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not settings.fly then return end
                    local cam = camera
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = moveDir.Unit * settings.flySpeed
                    else
                        bv.Velocity = Vector3.zero
                    end
                    bg.CFrame = cam.CFrame
                end)
            else
                if flyConnection then flyConnection:Disconnect() end
                if rootpart:FindFirstChild("BodyVelocity") then rootpart.BodyVelocity:Destroy() end
                if rootpart:FindFirstChild("BodyGyro") then rootpart.BodyGyro:Destroy() end
            end
        end)
        
        createSlider("Fly Speed", 10, 500, 50, "", function(value)
            settings.flySpeed = value
        end)
        
        createSlider("Jump Power", 50, 500, 50, "", function(value)
            settings.jumpPower = value
            if humanoid then humanoid.JumpPower = value end
        end)
        
        -- ========== VISUALS ==========
        createDivider("Visuals")
        
        createToggle("FullBright", function(enabled)
            settings.fullbright = enabled
            local lighting = game:GetService("Lighting")
            if enabled then
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.FogEnd = 100000
                lighting.GlobalShadows = false
                lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            else
                lighting.Brightness = 1
                lighting.ClockTime = 12
                lighting.FogEnd = 100000
                lighting.GlobalShadows = true
            end
        end)
        
        createToggle("No Fog", function(enabled)
            settings.noFog = enabled
            local lighting = game:GetService("Lighting")
            if enabled then
                lighting.FogEnd = 100000
                for _, v in pairs(lighting:GetChildren()) do
                    if v:IsA("Atmosphere") then v.Density = 0 end
                end
            else
                lighting.FogEnd = 500
            end
        end)
        
        createToggle("FOV Changer", function(enabled)
            settings.fovChanger = enabled
            if not enabled then camera.FieldOfView = originalValues.fov end
        end)
        
        createSlider("FOV Value", 70, 120, 70, "°", function(value)
            settings.fovValue = value
            if settings.fovChanger then camera.FieldOfView = value end
        end)
        
        createToggle("Force Third Person", function(enabled)
            settings.thirdPerson = enabled
            if enabled then
                player.CameraMode = Enum.CameraMode.Classic
                player.CameraMinZoomDistance = 5
            else
                player.CameraMode = Enum.CameraMode.Classic
                player.CameraMinZoomDistance = 0.5
            end
        end)
        
        -- ========== OTHER ==========
        createDivider("Other")
        
        createToggle("Anti-AFK", function(enabled)
            settings.antiAFK = enabled
            if enabled then
                table.insert(connections, RunService.Heartbeat:Connect(function()
                    if settings.antiAFK then
                        local vu = game:GetService("VirtualUser")
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new())
                    end
                end))
            end
        end)
        
        createToggle("Spinbot", function(enabled)
            settings.spinbot = enabled
        end)
        
        createSlider("Spin Speed", 1, 50, 10, "", function(value)
            settings.spinSpeed = value
        end)
        
        -- ========== UNLOCK ALL ==========
        createDivider("Unlock All")
        
        createActionButton("Unlock All Items", "UNLOCK", function(btn)
            btn.Text = "⏳ WORKING..."
            btn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
            task.spawn(function()
                local success = 0
                pcall(function()
                    local RS = game:GetService("ReplicatedStorage")
                    local possibleEvents = {"UnlockItem", "BuyItem", "PurchaseItem", "UnlockWeapon", "UnlockSkin", "UnlockCrate", "OpenCase", "UnlockAll"}
                    for _, eventName in pairs(possibleEvents) do
                        local event = RS:FindFirstChild(eventName, true)
                        if event and event:IsA("RemoteEvent") then
                            local testArgs = {{"all"}, {true}, {999999}, {"unlock", "all"}}
                            for _, args in pairs(testArgs) do
                                pcall(function() event:FireServer(unpack(args)) success = success + 1 end)
                            end
                        end
                    end
                end)
                pcall(function()
                    local possibleInventories = {"Inventory", "Backpack", "Items", "Weapons", "Skins", "Owned"}
                    for _, invName in pairs(possibleInventories) do
                        local inv = player:FindFirstChild(invName)
                        if inv then
                            local allItems = game.ReplicatedStorage:FindFirstChild("Items") or game.ReplicatedStorage:FindFirstChild("Weapons") or game.ReplicatedStorage:FindFirstChild("AllItems")
                            if allItems then
                                for _, item in pairs(allItems:GetChildren()) do
                                    pcall(function() local clone = item:Clone() clone.Parent = inv success = success + 1 end)
                                end
                            end
                        end
                    end
                end)
                pcall(function()
                    if player:FindFirstChild("leaderstats") then
                        for _, stat in pairs(player.leaderstats:GetChildren()) do
                            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                                pcall(function() stat.Value = 999999999 success = success + 1 end)
                            end
                        end
                    end
                end)
                pcall(function()
                    local badges = player:FindFirstChild("Badges") or player:FindFirstChild("Achievements")
                    if badges then
                        for _, badge in pairs(badges:GetChildren()) do
                            if badge:IsA("BoolValue") then
                                pcall(function() badge.Value = true success = success + 1 end)
                            end
                        end
                    end
                end)
                pcall(function()
                    local MarketplaceService = game:GetService("MarketplaceService")
                    local oldFunction = MarketplaceService.UserOwnsGamePassAsync
                    MarketplaceService.UserOwnsGamePassAsync = function(...) return true end
                    success = success + 1
                end)
                task.wait(1)
                if success > 0 then
                    btn.Text = "✅ UNLOCKED!"
                    btn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
                else
                    btn.Text = "❌ FAILED"
                    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
                task.wait(3)
                btn.Text = "UNLOCK"
                btn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
            end)
        end)
        
        createActionButton("Give All Weapons", "GIVE ALL", function(btn)
            btn.Text = "⏳ GIVING..."
            btn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
            task.spawn(function()
                local count = 0
                pcall(function()
                    local RS = game:GetService("ReplicatedStorage")
                    local weapons = RS:FindFirstChild("Weapons") or RS:FindFirstChild("Tools")
                    if weapons then
                        for _, weapon in pairs(weapons:GetChildren()) do
                            pcall(function() local clone = weapon:Clone() clone.Parent = player.Backpack count = count + 1 end)
                        end
                    end
                end)
                task.wait(1)
                if count > 0 then
                    btn.Text = "✅ GAVE " .. count
                    btn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
                else
                    btn.Text = "❌ NO WEAPONS"
                    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
                task.wait(3)
                btn.Text = "GIVE ALL"
                btn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
            end)
        end)
        
        createActionButton("Max Money/Coins", "MAX OUT", function(btn)
            btn.Text = "⏳ MAXING..."
            btn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
            task.spawn(function()
                local count = 0
                pcall(function()
                    if player:FindFirstChild("leaderstats") then
                        for _, stat in pairs(player.leaderstats:GetChildren()) do
                            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                                local names = stat.Name:lower()
                                if names:find("money") or names:find("cash") or names:find("coin") or names:find("gold") or names:find("credit") or names:find("dollar") then
                                    pcall(function() stat.Value = 999999999 count = count + 1 end)
                                end
                            end
                        end
                    end
                    local folders = {"Stats", "PlayerStats", "Data", "PlayerData"}
                    for _, folderName in pairs(folders) do
                        local folder = player:FindFirstChild(folderName)
                        if folder then
                            for _, stat in pairs(folder:GetChildren()) do
                                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                                    pcall(function() stat.Value = 999999999 count = count + 1 end)
                                end
                            end
                        end
                    end
                end)
                task.wait(1)
                if count > 0 then
                    btn.Text = "✅ MAXED!"
                    btn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
                else
                    btn.Text = "❌ FAILED"
                    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
                task.wait(3)
                btn.Text = "MAX OUT"
                btn.BackgroundColor3 = Color3.fromRGB(40, 200, 80)
            end)
        end)
        
        -- ========== FONCTIONS AIMBOT ==========
        
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
        
        table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                isRightClickHeld = true
                if settings.aimbot or settings.aimbotLock then
                    lockedTarget = getClosestPlayerInFOV()
                end
            end
        end))
        
        table.insert(connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                isRightClickHeld = false
                lockedTarget = nil
            end
        end))
        
        -- ========== LOOPS PRINCIPAUX ==========
        
        table.insert(connections, RunService.RenderStepped:Connect(function()
            if settings.aimbotLock and isRightClickHeld then
                if not lockedTarget or not lockedTarget.Character then
                    lockedTarget = getClosestPlayerInFOV()
                end
                if lockedTarget and lockedTarget.Character then
                    local targetPart = lockedTarget.Character:FindFirstChild(settings.targetPart)
                    local hum = lockedTarget.Character:FindFirstChildOfClass("Humanoid")
                    if targetPart and hum and hum.Health > 0 then
                        local targetPos = targetPart.Position
                        local currentCFrame = camera.CFrame
                        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                        camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / settings.aimbotSmooth)
                    else
                        lockedTarget = nil
                    end
                end
            end
            if settings.aimbot and isRightClickHeld then
                if not lockedTarget or not lockedTarget.Character then
                    lockedTarget = getClosestPlayerInFOV()
                end
                if lockedTarget and lockedTarget.Character then
                    local targetPart = lockedTarget.Character:FindFirstChild(settings.targetPart)
                    local hum = lockedTarget.Character:FindFirstChildOfClass("Humanoid")
                    if targetPart and hum and hum.Health > 0 then
                        local targetPos = targetPart.Position
                        local currentCFrame = camera.CFrame
                        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                        camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 / settings.aimbotSmooth)
                        if settings.autoShoot then
                            pcall(function() mouse1click() end)
                        end
                    else
                        lockedTarget = nil
                    end
                end
            end
            if settings.triggerBot then
                local mouseTarget = player:GetMouse().Target
                if mouseTarget then
                    local targetPlayer = Players:GetPlayerFromCharacter(mouseTarget.Parent)
                    if targetPlayer and targetPlayer ~= player then
                        pcall(function() mouse1click() end)
                    end
                end
            end
        end))
        
        table.insert(connections, RunService.Stepped:Connect(function()
            if settings.noclip and character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end))
        
        table.insert(connections, UserInputService.JumpRequest:Connect(function()
            if settings.infiniteJump and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
        
        table.insert(connections, RunService.Heartbeat:Connect(function()
            if settings.speedEnabled and humanoid then
                humanoid.WalkSpeed = settings.walkSpeed
            end
        end))
        
        local spinAngle = 0
        table.insert(connections, RunService.RenderStepped:Connect(function()
            if settings.spinbot and rootpart then
                spinAngle = spinAngle + settings.spinSpeed
                rootpart.CFrame = rootpart.CFrame * CFrame.Angles(0, math.rad(spinAngle), 0)
            end
        end))
        
        table.insert(connections, player.CharacterAdded:Connect(function(char)
            character = char
            humanoid = char:WaitForChild("Humanoid")
            rootpart = char:WaitForChild("HumanoidRootPart")
            originalValues.walkSpeed = humanoid.WalkSpeed
            originalValues.jumpPower = humanoid.JumpPower
        end))
        
        local isMinimized = false
        ToggleBtn.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            ScrollFrame.Visible = not isMinimized
            if isMinimized then
                MainFrame.Size = UDim2.new(0, 450, 0, 55)
                ToggleBtn.Text = "+"
            else
                MainFrame.Size = UDim2.new(0, 450, 0, 650)
                ToggleBtn.Text = "─"
            end
        end)
        
        CloseBtn.MouseButton1Click:Connect(function()
            cleanup()
            if fovCircle then fovCircle:Remove() end
            ScreenGui:Destroy()
        end)
        
        ScreenGui.Destroying:Connect(function()
            cleanup()
            if fovCircle then fovCircle:Remove() end
        end)
        
        print("🐊 CROCO HUB V3 ULTIMATE FINAL chargé!")
        print("━━━━━━━━━━━━━━━━━━━━━━━━")
        print("✅ TOUTES LES FONCTIONNALITÉS:")
        print("• ESP (Red + Rainbow)")
        print("• Aimbot (Lock + Auto Shoot)")
        print("• Movement (Noclip, Fly, Speed, Jump)")
        print("• Visuals (FullBright, FOV, etc.)")
        print("• Unlock All (Items, Weapons, Money)")
        print("• Other (Anti-AFK, Spinbot)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━")
        
    else
        StatusLabel.Text = "❌ Invalid Key! Try again."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyInput.Text = ""
    end
end

GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/bES4cJPgqc")
    StatusLabel.Text = "📋 Discord link copied!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    checkKey()
end)

KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

openKeyFrame()

print("🐊 CROCO HUB V3 ULTIMATE - Key System chargé!")
print("━━━━━━━━━━━━━━━━━━━━━━━━")
print("Clé: freebycroco")
print("Discord: https://discord.gg/bES4cJPgqc")
