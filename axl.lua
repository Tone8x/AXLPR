-- Steal a Brainrot - Advanced Animated ESP
-- خط أسود وأبيض متحرك | Toggle ثابت بعد الموت | أنيميشن خرافي

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- قائمة Secret Brainrots
local SecretBrainrots = {
    "La Vacca Saturno Saturnita", "Bisonte Giuppitere", "Blackhole Goat",
    "Agarrini Ia Palini", "Chachechi", "Karkerkar Kurkur", "Los Tortus",
    "Los Matteos", "Sammyni Spyderini", "Trenostruzzo Turbo 4000",
    "Chimpanzini Spiderini", "Boatito Auratito", "Fragola La La La",
    "Dul Dul Dul", "Frankentteo", "Karker Sahur", "Torrtuginni Dragonfrutini",
    "Los Tralaleritos", "Zombie Tralala", "La Cucaracha", "Vulturino Skeletono",
    "Guerriro Digitale", "Extinct Tralalero", "Yess My Examine", "Extinct Matteo",
    "Las Tralaleritas", "Las Vaquitas Saturnitas", "Job Job Job Sahur",
    "Los Karkeritos", "Graipuss Medussi", "La Vacca Jacko Linterino",
    "Los Spyderinis", "Perrito Burrito", "Los Jobcitos", "Nooo My Hotspot",
    "Pot Hotspot", "Noo My Examine", "La Sahur Combinasion", "To To To Sahur",
    "Horegini Boom", "Quesadilla Crocodila", "Chicleteira Bicicleteira",
    "Spaghetti Tualetti", "Esok Sekolah", "Chicleteirina Bicicleteirina",
    "Los Nooo My Hotspotsitos", "La Grande Combinassion", "Rang Ring Bus",
    "Los Chicleteiras", "67", "Mariachi Corazoni", "Los Combinasionas",
    "Tacorita Bicicleta", "Nuclearo Dinosauro", "Las Sis", "La Karkerkar Combinasion",
    "Chillin Chili", "Money Money Puggy", "Celularcini Viciosini", "Los Mobilis",
    "Los 67", "Mieteteira Bicicleteira", "La Spooky Grande", "Los Hotspositos",
    "Tralalalaledon", "La Extinct Grande Combinasion", "Los Primos", "Eviledon",
    "Los Tacoritas", "Tang Tang Kelentang", "Ketupat Kepat", "Los Bros",
    "Tictac Sahur", "La Supreme Combinasion", "Ketchuru and Masturu",
    "Garama and Madundung", "Spooky and Pumpky", "La Secret Combinasion",
    "Burguro and Fryuro", "Dragon Cannelloni",
}

local SecretSet = {}
for _, name in ipairs(SecretBrainrots) do
    SecretSet[name] = true
end

-- متغيرات التحكم
local isESPActive = true
local animationTime = 0

-- وظيفة إنشاء خط للاعب من بعيد
local function CreateTracerLine(model)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    -- حذف الخط القديم
    local oldLine = model:FindFirstChild("TracerLine")
    if oldLine then
        oldLine:Destroy()
    end
    
    -- إنشاء Beam للخط
    local att0 = Instance.new("Attachment")
    att0.Name = "TracerAtt0"
    att0.Parent = humanoidRootPart
    
    local att1 = Instance.new("Attachment")
    att1.Name = "TracerAtt1"
    att1.Parent = primaryPart
    
    local beam = Instance.new("Beam")
    beam.Name = "TracerLine"
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Width0 = 0.3
    beam.Width1 = 0.3
    beam.FaceCamera = true
    beam.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    beam.Transparency = NumberSequence.new(0.3)
    beam.LightEmission = 0.5
    beam.LightInfluence = 0
    beam.Parent = model
    
    return beam, att0, att1
end

-- وظيفة إنشاء ظل واقعي
local function CreateShadow(model)
    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    local oldShadow = model:FindFirstChild("RealisticShadow")
    if oldShadow then oldShadow:Destroy() end
    
    local shadow = Instance.new("Part")
    shadow.Name = "RealisticShadow"
    shadow.Size = Vector3.new(primaryPart.Size.X * 1.2, 0.1, primaryPart.Size.Z * 1.2)
    shadow.Anchored = true
    shadow.CanCollide = false
    shadow.Transparency = 0.5
    shadow.Material = Enum.Material.SmoothPlastic
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Parent = model
    
    task.spawn(function()
        while shadow and shadow.Parent and isESPActive do
            if primaryPart and primaryPart.Parent then
                local rayOrigin = primaryPart.Position
                local rayDirection = Vector3.new(0, -100, 0)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {model}
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if rayResult then
                    shadow.Position = rayResult.Position + Vector3.new(0, 0.05, 0)
                    local distance = (primaryPart.Position - rayResult.Position).Magnitude
                    shadow.Transparency = math.clamp(0.3 + (distance / 50), 0.3, 0.95)
                end
            end
            task.wait(0.1)
        end
    end)
    
    return shadow
end

-- وظيفة إنشاء Outline متحرك (يمين أسود، يسار أبيض)
local function CreateAnimatedOutline(model)
    if not model:IsA("Model") then return end
    if not SecretSet[model.Name] then return end
    
    local oldHighlight = model:FindFirstChildOfClass("Highlight")
    if oldHighlight then oldHighlight:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "AnimatedOutline"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    CreateShadow(model)
    CreateTracerLine(model)
    
    return highlight
end

-- وظيفة تحديث الأنيميشن (أسود ↔ أبيض كل 3 ثواني)
local function UpdateAnimation()
    if not isESPActive then return end
    
    local phase = math.floor(animationTime / 3) % 2
    local targetColor = phase == 0 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Highlight") and descendant.Name == "AnimatedOutline" then
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(descendant, tweenInfo, {OutlineColor = targetColor}):Play()
        end
        
        if descendant:IsA("Beam") and descendant.Name == "TracerLine" then
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(descendant, tweenInfo, {
                Color = ColorSequence.new(targetColor)
            }):Play()
        end
    end
end

-- تطبيق ESP
local function ApplyESPToAll()
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and SecretSet[model.Name] then
            pcall(function()
                CreateAnimatedOutline(model)
            end)
        end
    end
end

-- حذف ESP
local function RemoveAllESP()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant.Name == "AnimatedOutline" or 
           descendant.Name == "RealisticShadow" or 
           descendant.Name == "TracerLine" or
           descendant.Name == "TracerAtt0" or
           descendant.Name == "TracerAtt1" then
            pcall(function() descendant:Destroy() end)
        end
    end
end

-- إنشاء Toggle دائري صغير مع أنيميشن خرافي
local function CreateToggle()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotESPToggle"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = game.CoreGui
    
    -- الزر الدائري الصغير
    local toggle = Instance.new("ImageButton")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0, 60, 0, 60)
    toggle.Position = UDim2.new(0.95, -70, 0.5, -30)
    toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = false
    toggle.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggle
    
    -- حدود متوهجة
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = toggle
    
    -- الأيقونة
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "👁"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 28
    icon.Parent = toggle
    
    -- ظل
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.Position = UDim2.new(0, 3, 0, 3)
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.ZIndex = 0
    shadow.Parent = toggle
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = shadow
    
    -- أنيميشن نبض للزر
    task.spawn(function()
        while toggle and toggle.Parent do
            local tween1 = TweenService:Create(toggle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 65, 0, 65)
            })
            tween1:Play()
            tween1.Completed:Wait()
            
            local tween2 = TweenService:Create(toggle, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 60, 0, 60)
            })
            tween2:Play()
            tween2.Completed:Wait()
        end
    end)
    
    -- أنيميشن دوران للأيقونة
    task.spawn(function()
        while icon and icon.Parent do
            local tween = TweenService:Create(icon, TweenInfo.new(4, Enum.EasingStyle.Linear), {
                Rotation = 360
            })
            tween:Play()
            tween.Completed:Wait()
            icon.Rotation = 0
        end
    end)
    
    -- أنيميشن توهج الحدود
    task.spawn(function()
        while stroke and stroke.Parent do
            local tween1 = TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Thickness = 5
            })
            tween1:Play()
            tween1.Completed:Wait()
            
            local tween2 = TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Thickness = 3
            })
            tween2:Play()
            tween2.Completed:Wait()
        end
    end)
    
    -- صوت
    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://9118823108"
    clickSound.Volume = 0.4
    clickSound.Parent = toggle
    
    -- وظيفة الضغط
    toggle.MouseButton1Click:Connect(function()
        pcall(function() clickSound:Play() end)
        isESPActive = not isESPActive
        
        -- أنيميشن ضغط
        TweenService:Create(toggle, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        task.wait(0.1)
        TweenService:Create(toggle, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        
        if isESPActive then
            icon.Text = "👁"
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 255, 100)}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            ApplyESPToAll()
            print("✅ ESP مفعل")
        else
            icon.Text = "👁‍🗨"
            TweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(255, 50, 50)}):Play()
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 20, 20)}):Play()
            RemoveAllESP()
            print("⛔ ESP متوقف")
        end
    end)
    
    -- السحب بحرية
    local dragging = false
    local dragInput, mousePos, framePos
    
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = toggle.Position
            TweenService:Create(toggle, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
        end
    end)
    
    toggle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(toggle, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            toggle.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- مراقبة Brainrots الجديدة
workspace.DescendantAdded:Connect(function(descendant)
    if isESPActive and descendant:IsA("Model") and SecretSet[descendant.Name] then
        task.wait(0.1)
        pcall(function()
            CreateAnimatedOutline(descendant)
        end)
    end
end)

-- حلقة الأنيميشن الرئيسية
RunService.Heartbeat:Connect(function(deltaTime)
    if isESPActive then
        animationTime = animationTime + deltaTime
        if animationTime >= 3 then
            UpdateAnimation()
            animationTime = 0
        end
    end
end)

-- تشغيل السكربت
task.spawn(function()
    task.wait(1)
    CreateToggle()
    ApplyESPToAll()
    
    print("════════════════════════════════")
    print("⚫⚪ Animated Black & White ESP")
    print("✨ " .. #SecretBrainrots .. " Secrets")
    print("📍 خط من اللاعب للـ Brainrot")
    print("🔄 تحديث كل 3 ثواني")
    print("🎮 Toggle يبقى بعد الموت")
    print("════════════════════════════════")
end)

-- تحديث ESP كل 5 ثواني
task.spawn(function()
    while task.wait(5) do
        if isESPActive then
            pcall(ApplyESPToAll)
        end
    end
end)
