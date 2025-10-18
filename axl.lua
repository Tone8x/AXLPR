-- Steal a Brainrot - Ultra RGB Outline ESP
-- RGB حواف فقط | ظلال واقعية | Pixel Perfect | أنيميشن سلس

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- قائمة كاملة بجميع Secret Brainrots
local SecretBrainrots = {
    "La Vacca Saturno Saturnita",
    "Bisonte Giuppitere",
    "Blackhole Goat",
    "Agarrini Ia Palini",
    "Chachechi",
    "Karkerkar Kurkur",
    "Los Tortus",
    "Los Matteos",
    "Sammyni Spyderini",
    "Trenostruzzo Turbo 4000",
    "Chimpanzini Spiderini",
    "Boatito Auratito",
    "Fragola La La La",
    "Dul Dul Dul",
    "Frankentteo",
    "Karker Sahur",
    "Torrtuginni Dragonfrutini",
    "Los Tralaleritos",
    "Zombie Tralala",
    "La Cucaracha",
    "Vulturino Skeletono",
    "Guerriro Digitale",
    "Extinct Tralalero",
    "Yess My Examine",
    "Extinct Matteo",
    "Las Tralaleritas",
    "Las Vaquitas Saturnitas",
    "Job Job Job Sahur",
    "Los Karkeritos",
    "Graipuss Medussi",
    "La Vacca Jacko Linterino",
    "Los Spyderinis",
    "Perrito Burrito",
    "Los Jobcitos",
    "Nooo My Hotspot",
    "Pot Hotspot",
    "Noo My Examine",
    "La Sahur Combinasion",
    "To To To Sahur",
    "Horegini Boom",
    "Quesadilla Crocodila",
    "Chicleteira Bicicleteira",
    "Spaghetti Tualetti",
    "Esok Sekolah",
    "Chicleteirina Bicicleteirina",
    "Los Nooo My Hotspotsitos",
    "La Grande Combinassion",
    "Rang Ring Bus",
    "Los Chicleteiras",
    "67",
    "Mariachi Corazoni",
    "Los Combinasionas",
    "Tacorita Bicicleta",
    "Nuclearo Dinosauro",
    "Las Sis",
    "La Karkerkar Combinasion",
    "Chillin Chili",
    "Money Money Puggy",
    "Celularcini Viciosini",
    "Los Mobilis",
    "Los 67",
    "Mieteteira Bicicleteira",
    "La Spooky Grande",
    "Los Hotspositos",
    "Tralalalaledon",
    "La Extinct Grande Combinasion",
    "Los Primos",
    "Eviledon",
    "Los Tacoritas",
    "Tang Tang Kelentang",
    "Ketupat Kepat",
    "Los Bros",
    "Tictac Sahur",
    "La Supreme Combinasion",
    "Ketchuru and Masturu",
    "Garama and Madundung",
    "Spooky and Pumpky",
    "La Secret Combinasion",
    "Burguro and Fryuro",
    "Dragon Cannelloni",
}

-- تحويل إلى Set
local SecretSet = {}
for _, name in ipairs(SecretBrainrots) do
    SecretSet[name] = true
end

-- وظيفة HSV إلى RGB
local function HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

local rgbTime = 0

-- وظيفة إنشاء ظل واقعي تحت المجسم
local function CreateRealisticShadow(model)
    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primaryPart then return end
    
    -- حذف الظل القديم
    local oldShadow = model:FindFirstChild("RealisticShadow")
    if oldShadow then
        oldShadow:Destroy()
    end
    
    -- إنشاء Part للظل
    local shadow = Instance.new("Part")
    shadow.Name = "RealisticShadow"
    shadow.Size = Vector3.new(primaryPart.Size.X * 1.2, 0.1, primaryPart.Size.Z * 1.2)
    shadow.Anchored = true
    shadow.CanCollide = false
    shadow.Transparency = 0.5
    shadow.Material = Enum.Material.SmoothPlastic
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Parent = model
    
    -- إنشاء Decal للظل
    local decal = Instance.new("Decal")
    decal.Texture = "rbxasset://textures/face.png"
    decal.Face = Enum.NormalId.Top
    decal.Transparency = 0.7
    decal.Color3 = Color3.fromRGB(0, 0, 0)
    decal.Parent = shadow
    
    -- تحديث موضع الظل
    local function updateShadowPosition()
        if shadow and shadow.Parent and primaryPart and primaryPart.Parent then
            local rayOrigin = primaryPart.Position
            local rayDirection = Vector3.new(0, -100, 0)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {model}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if rayResult then
                shadow.Position = rayResult.Position + Vector3.new(0, 0.05, 0)
                
                -- تغيير شفافية الظل حسب المسافة
                local distance = (primaryPart.Position - rayResult.Position).Magnitude
                shadow.Transparency = math.clamp(0.3 + (distance / 50), 0.3, 0.95)
            else
                shadow.Position = primaryPart.Position - Vector3.new(0, primaryPart.Size.Y/2 + 0.1, 0)
            end
        end
    end
    
    -- تحديث الظل بشكل مستمر
    task.spawn(function()
        while shadow and shadow.Parent do
            updateShadowPosition()
            task.wait(0.1)
        end
    end)
    
    return shadow
end

-- وظيفة إنشاء Highlight RGB للحواف فقط
local function CreatePixelPerfectRGBOutline(model)
    if not model:IsA("Model") then return end
    if not SecretSet[model.Name] then return end
    
    -- حذف Highlight القديم
    local oldHighlight = model:FindFirstChildOfClass("Highlight")
    if oldHighlight then
        oldHighlight:Destroy()
    end
    
    -- إنشاء Highlight جديد - حواف فقط
    local highlight = Instance.new("Highlight")
    highlight.Name = "PixelRGBOutline"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 1 -- شفاف تماماً (بدون Fill)
    highlight.OutlineTransparency = 0 -- حواف واضحة
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    -- إنشاء الظل الواقعي
    CreateRealisticShadow(model)
    
    -- إنشاء Beam للتأثيرات الإضافية
    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if primaryPart then
        -- حذف Beam القديم
        for _, child in pairs(primaryPart:GetChildren()) do
            if child:IsA("Beam") then
                child:Destroy()
            end
        end
        
        -- إنشاء Attachment للـ Beam
        local att0 = Instance.new("Attachment")
        att0.Name = "RGBAttachment0"
        att0.Position = Vector3.new(0, primaryPart.Size.Y/2, 0)
        att0.Parent = primaryPart
        
        local att1 = Instance.new("Attachment")
        att1.Name = "RGBAttachment1"
        att1.Position = Vector3.new(0, -primaryPart.Size.Y/2, 0)
        att1.Parent = primaryPart
        
        -- إنشاء Beam
        local beam = Instance.new("Beam")
        beam.Name = "RGBBeam"
        beam.Attachment0 = att0
        beam.Attachment1 = att1
        beam.FaceCamera = true
        beam.Width0 = 0.5
        beam.Width1 = 0.5
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        beam.Transparency = NumberSequence.new(0.3)
        beam.LightEmission = 1
        beam.LightInfluence = 0
        beam.Parent = primaryPart
        
        -- أنيميشن نبض سلس للـ Beam
        task.spawn(function()
            while beam and beam.Parent do
                local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
                local goal = {Width0 = 1, Width1 = 1}
                local tween = TweenService:Create(beam, tweenInfo, goal)
                tween:Play()
                task.wait(0.1)
            end
        end)
    end
    
    return highlight
end

-- وظيفة تحديث RGB بشكل سلس جداً
local function UpdateAllRGBOutlines()
    local workspace = game:GetService("Workspace")
    
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("Highlight") and descendant.Name == "PixelRGBOutline" then
            local hue = (rgbTime % 360) / 360
            local rgbColor = HSVtoRGB(hue, 1, 1)
            
            -- تحديث لون الحواف
            descendant.OutlineColor = rgbColor
            
            -- تحديث لون الـ Beam
            local parent = descendant.Parent
            if parent then
                local primaryPart = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    local beam = primaryPart:FindFirstChild("RGBBeam")
                    if beam then
                        beam.Color = ColorSequence.new(rgbColor)
                    end
                end
            end
        end
    end
end

-- تطبيق ESP على الكل
local function ApplyESPToAll()
    local workspace = game:GetService("Workspace")
    
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and SecretSet[model.Name] then
            pcall(function()
                CreatePixelPerfectRGBOutline(model)
            end)
        end
    end
end

-- مراقبة Brainrots الجديدة
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and SecretSet[descendant.Name] then
        task.wait(0.15)
        pcall(function()
            CreatePixelPerfectRGBOutline(descendant)
        end)
    end
end)

-- حلقة RGB السلسة - 60 FPS
RunService.RenderStepped:Connect(function(deltaTime)
    rgbTime = rgbTime + (deltaTime * 100) -- سرعة RGB
    UpdateAllRGBOutlines()
end)

-- تطبيق ESP عند البدء
task.spawn(function()
    task.wait(1)
    ApplyESPToAll()
    print("════════════════════════════════")
    print("🌈 Pixel Perfect RGB Outline ESP")
    print("✨ " .. #SecretBrainrots .. " Secrets Loaded")
    print("🎨 Realistic Shadows Active")
    print("⚡ Smooth 60 FPS Animation")
    print("════════════════════════════════")
end)

-- إعادة تطبيق كل 10 ثواني
task.spawn(function()
    while task.wait(10) do
        pcall(ApplyESPToAll)
    end
end)

-- تنظيف عند المغادرة
LocalPlayer.CharacterRemoving:Connect(function()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant.Name == "PixelRGBOutline" or descendant.Name == "RealisticShadow" or descendant.Name == "RGBBeam" then
            descendant:Destroy()
        end
    end
end)
