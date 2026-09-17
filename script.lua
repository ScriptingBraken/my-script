local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local function runM1crickdIntro()
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "IntroUI_m1crickd"
    IntroGui.Parent = CoreGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "made by m1crickd"
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 255) -- Неоново-бирюзовый цвет
    TextLabel.TextSize = 45
    TextLabel.Font = Enum.Font.FredokaOne -- Жирный красивый шрифт
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextTransparency = 1 -- Начинаем с невидимого
    TextLabel.Parent = IntroGui

    -- Плавное появление (1.2 секунды)
    local fadeIn = TweenService:Create(TextLabel, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeIn:Play()
    fadeIn.Completed:Wait()

    task.wait(1.8) -- Сколько секунд надпись висит по центру экрана

    -- Плавное исчезновение (1 секунда)
    local fadeOut = TweenService:Create(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()

    IntroGui:Destroy()
end

task.spawn(runM1crickdIntro)

--[[
	WARNING: This script is provided for educational purposes within a gaming environment.
]]
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local localPlayer = game.Players.LocalPlayer

-- ВАШИ ИДЕАЛЬНЫЕ НАСТРОЙКИ СКОРОСТИ:
local PUSH_FORCE = 150 -- Сила полета вперед
local UP_FORCE = 30    -- Сила подбрасывания вверх

local bricksFolder = workspace.obby.bricks

local effectPart = nil
local resetPart = nil
local parryPart = nil

for _, child in pairs(bricksFolder:GetChildren()) do
    if child:IsA("BasePart") then
        if child.BrickColor.Name == "Magenta" then
            effectPart = child
        elseif child.BrickColor.Name == "Lime green" then
            resetPart = child
        elseif child.BrickColor.Name == "Teal" or child.Name:lower():match("teal") then
            parryPart = child
        end
    end
end

if not effectPart then
    warn("No Magenta brick found in workspace.obby.bricks")
    return
end

if not resetPart then
    warn("No Lime green brick found in workspace.obby.bricks")
    return
end

if not parryPart then
    warn("No Teal brick found in workspace.obby.bricks")
    return
end

local oldGui = CoreGui:FindFirstChild("CombinedUI")
if oldGui then
    oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombinedUI"
ScreenGui.Parent = CoreGui

local function createToggle(position, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 155, 0, 30)
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 18, 0, 18)
    checkbox.Position = UDim2.new(0, 8, 0.5, -9)
    checkbox.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    checkbox.Text = ""
    checkbox.BorderSizePixel = 0
    checkbox.Parent = frame

    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 4)
    checkboxCorner.Parent = checkbox

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 0, 20)
    label.Position = UDim2.new(0, 32, 0.5, -10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    return checkbox
end

local parryEnabled = false
local resetEnabled = false
local effectEnabled = false

local parryCheckbox = createToggle(
    UDim2.new(0, 15, 1, -95),
    "Parry Block (Toggle B)"
)

local resetCheckbox = createToggle(
    UDim2.new(0, 15, 1, -70),
    "Reset UI (Toggle N)"
)

local effectCheckbox = createToggle(
    UDim2.new(0, 15, 1, -45),
    "Physics Effect (Toggle J)"
)

local function updateCheckbox(checkbox, state)
    checkbox.BackgroundColor3 = state
        and Color3.fromRGB(50, 220, 50)
        or Color3.fromRGB(220, 50, 50)
end

local function toggleParry()
    parryEnabled = not parryEnabled
    updateCheckbox(parryCheckbox, parryEnabled)
end

local function toggleReset()
    resetEnabled = not resetEnabled
    updateCheckbox(resetCheckbox, resetEnabled)
end

local function toggleEffect()
    effectEnabled = not effectEnabled
    updateCheckbox(effectCheckbox, effectEnabled)
end

parryCheckbox.MouseButton1Click:Connect(toggleParry)
resetCheckbox.MouseButton1Click:Connect(toggleReset)
effectCheckbox.MouseButton1Click:Connect(toggleEffect)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Функция с чатом (gameProcessed) полностью убрана по вашему запросу

    -- Скрытие и показ менюшки на клавишу M
    if input.KeyCode == Enum.KeyCode.M then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    if input.KeyCode == Enum.KeyCode.B then
        toggleParry()
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleReset()
    elseif input.KeyCode == Enum.KeyCode.J then
        toggleEffect()
    end

    if input.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end

    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local head = character and character:FindFirstChild("Head")

    if parryEnabled and rootPart and parryPart then
        firetouchinterest(parryPart, rootPart, 0)
        task.wait()
        firetouchinterest(parryPart, rootPart, 1)
    end

    if effectEnabled and rootPart and effectPart then
        local camera = workspace.CurrentCamera
        if camera then
            local lookDirection = camera.CFrame.LookVector
            local flatDirection = Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit
            
            local velocity = (flatDirection * PUSH_FORCE) + Vector3.new(0, UP_FORCE, 0)
            rootPart.AssemblyLinearVelocity = velocity
        end

        firetouchinterest(effectPart, rootPart, 0)
        firetouchinterest(effectPart, rootPart, 1)
    end

    if resetEnabled and rootPart and head and resetPart then
        resetPart.CFrame = rootPart.CFrame * CFrame.new(0, 1.5, 2)
        task.wait(0.05)

        firetouchinterest(resetPart, rootPart, 0)
        task.wait()
        firetouchinterest(resetPart, rootPart, 1)
    end
end)

wait(1)

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

-- ====================================================================
-- ⚙️ НАСТРОЙКА ТВОИХ ЗВУКОВЫХ ID И ГРОМКОСТИ:
-- ====================================================================
-- Звуки Лука:
local ID_BOW_DRAW       = "rbxassetid://126832876895392" -- Твой ID на натяжение тетивы
local ID_BOW_PASS       = "rbxassetid://72129857868180"  -- Пролёт стрелы
local ID_BOW_BODY_HIT   = "rbxassetid://132110078840319" -- Твой ID на попадание в тело

-- Звук Кика:
local ID_KICK           = "rbxassetid://126832876895392" -- Твой сочный ID на удары ногами

-- ⚙️ ТВОЙ НОВЫЙ ЗАПРОС: Звук на броски оружия/предметов
local ID_THROW          = "rbxassetid://72129857868180"

-- Сервисные ID:
local ID_MUTE           = "rbxassetid://0"               -- Для глушения лишних звуков лука

-- ====================================================================
-- 📜 СПИСКИ КЛЮЧЕВЫХ СЛОВ:
-- ====================================================================
local kickKeywords = {"kickswoosh", "doorkick", "dropkick"}

print("🚀 Аудио-комбайн лука, кика и бросков запущен! Все настройки активированы.")

-- Функция проверки и подмены звуков
local function patchSoundCombined(soundObject)
    if not soundObject:IsA("Sound") then return end
    
    local name = soundObject.Name:lower()
    
    -- 🤾 1. ПЕРЕХВАТ КИДАНИЯ/БРОСКОВ (throw, shortthrow, longthrow)
    if name:find("throw") then
        soundObject.SoundId = ID_THROW
        soundObject.Volume = 1.5 -- Отличная слышимость для броска предметов
        
        soundObject:GetPropertyChangedSignal("SoundId"):Connect(function()
            if soundObject.SoundId ~= ID_THROW then
                soundObject.SoundId = ID_THROW
                soundObject.Volume = 1.5
            end
        end)
        print("✨ [Бросок] Успешно изменен звук кидания: " .. soundObject.Name)
        return
    end
    
    -- 🦶 2. НАСТРОЙКА КИКА (kickswoosh, doorkick, dropkick)
    for _, keyword in ipairs(kickKeywords) do
        if name:find(keyword) then
            soundObject.SoundId = ID_KICK
            soundObject.Volume = 3.5 
            soundObject.PlaybackSpeed = 1.0 
            
            soundObject:GetPropertyChangedSignal("SoundId"):Connect(function()
                if soundObject.SoundId ~= ID_KICK then
                    soundObject.SoundId = ID_KICK
                    soundObject.Volume = 3.5
                    soundObject.PlaybackSpeed = 1.0
                end
            end)
            return
        end
    end
    
    -- 🏹 3. ТОЧЕЧНАЯ НАСТРОЙКА ЛУКА (Строго по папке sounds в ReplicatedStorage)
    if name == "arrowdraw" then
        soundObject.SoundId = ID_BOW_DRAW
        soundObject.Volume = 0.9 
        soundObject.PlaybackSpeed = 0.45 -- Дьявольское рычание тетивы
        
        soundObject:GetPropertyChangedSignal("PlaybackSpeed"):Connect(function()
            if soundObject.PlaybackSpeed ~= 0.45 and soundObject.Name:lower() == "arrowdraw" then
                soundObject.PlaybackSpeed = 0.45
            end
        end)
        
    elseif name == "arrowpass" then
        soundObject.SoundId = ID_BOW_PASS
        soundObject.Volume = 0.33 
        soundObject.PlaybackSpeed = 1.0
        
    elseif name == "arrowhitbody" then
        soundObject.SoundId = ID_BOW_BODY_HIT
        soundObject.Volume = 1.0 -- Твоя комфортная громкость попадания в тело
        soundObject.PlaybackSpeed = 1.0
        print("✨ Новый сбалансированный звук попадания в тело установлен!")
        
    elseif name == "arrowhit1" or name == "arrowhit2" or name == "arrowkill" then
        soundObject.SoundId = ID_MUTE
        soundObject.Volume = 0
    end
end

-- Функция для сканирования и привязки слежки к сервисам игры Dzielnica
local function monitorServiceAll(service)
    pcall(function()
        for _, desc in ipairs(service:GetDescendants()) do
            patchSoundCombined(desc)
        end
        service.DescendantAdded:Connect(function(desc)
            task.wait() 
            patchSoundCombined(desc)
        end)
    end)
end

-- Запускаем тотальный мониторинг по всем ключевым зонам игры
monitorServiceAll(Workspace)
monitorServiceAll(ReplicatedStorage)
monitorServiceAll(SoundService)
monitorServiceAll(Players.LocalPlayer:WaitForChild("PlayerGui", 10))

print("🎯 Всемогущий комбайн полностью настроен. Проверяй броски, кик и лук в Dzielnica!")

wait(1)
local Workspace = game:GetService("Workspace")

-- Настройки полета ракеты
local UP_FORCE = 320        -- ЗНАЧИТЕЛЬНО УВЕЛИЧИЛИ СИЛУ (было 190)
local ROTATION_SPEED = 60   -- Труп будет крутиться ещё быстрее и безумнее
local FLY_DURATION = 2.8

-- Ждем появления папки с трупами на карте Dzielnica
local corpsesFolder = Workspace:WaitForChild("corpses", 15)

if not corpsesFolder then
    warn("❌ Папка 'corpses' не найдена в Workspace!")
    return
end

print("✅ Скрипт фейерверка со звуками успешно активирован!")

-- Функция запуска модели трупа в космос
local function launchCorpse(corpseModel)
    -- Даем игре 0.1 сек, чтобы рэгдолл успел загрузиться в папку
    task.wait(0.1)
    if not corpseModel or not corpseModel.Parent then return end

    -- НАХОДИМ ХОТЬ КАКОЙ-НИБУДЬ ПАРТ ДЛЯ ПРИМЕНЕНИЯ ФИЗИКИ И ЗВУКА
    local mainPart = corpseModel.PrimaryPart or corpseModel:FindFirstChildOfClass("BasePart")
    
    if not mainPart then
        for _, desc in ipairs(corpseModel:GetDescendants()) do
            if desc:IsA("BasePart") then
                mainPart = desc
                break
            end
        end
    end

    if not mainPart then return end

    -- Отключаем коллизии и гравитацию для абсолютно ВСЕХ деталей внутри модели
    for _, part in ipairs(corpseModel:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end

    -- ЭФФЕКТЫ: Искры хвоста фейерверка
    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://258128463"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 0, 0))
    sparks.Rate = 220
    sparks.Speed = NumberRange.new(5, 12)
    sparks.Lifetime = NumberRange.new(0.4, 0.7)
    sparks.Parent = mainPart

    -- 🔊 1. ТВОЙ ЗВУК ЗАПУСКА (Включается прямо на старте взлета)
    local launchSound = Instance.new("Sound", mainPart)
    launchSound.SoundId = "rbxassetid://123227138621330" -- ID звука запуска фейерверка
    launchSound.Volume = 2.5 -- Хорошая слышимая громкость
    launchSound:Play()

    -- ТВОЯ НАДЕЖНАЯ ФИЗИКА СКОРОСТИ
    mainPart.AssemblyLinearVelocity = Vector3.new(0, UP_FORCE, 0)

    -- Закручивание модели в полете
    local attachment = Instance.new("Attachment", mainPart)
    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.MaxTorque = math.huge
    angularVelocity.AngularVelocity = Vector3.new(0, ROTATION_SPEED, 0)
    angularVelocity.Attachment0 = attachment
    angularVelocity.Parent = mainPart

    -- Поддерживаем скорость в цикле взлета, пока проигрывается звук запуска
    local startTime = os.clock()
    while os.clock() - startTime < FLY_DURATION do
        if not mainPart or not mainPart.Parent then break end
        mainPart.AssemblyLinearVelocity = Vector3.new(mainPart.AssemblyLinearVelocity.X, UP_FORCE, mainPart.AssemblyLinearVelocity.Z)
        task.wait(0.05)
    end

    -- 🎆 2. КУЛЬМИНАЦИЯ: Финальный Бабах и Салют в небе!
    if mainPart and mainPart.Parent then
        -- Эффект взрыва фейерверка
        local explosion = Instance.new("ParticleEmitter")
        explosion.Texture = "rbxassetid://244221448"
        explosion.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255))
        explosion.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 15)})
        explosion.Rate = 800
        explosion.Lifetime = NumberRange.new(1, 1.6)
        explosion.Speed = NumberRange.new(30, 75)
        explosion.Parent = mainPart
        
        explosion:Emit(150) -- Моментальный праздничный залп

        -- Звук финального взрыва салюта
        local explosionSound = Instance.new("Sound", mainPart)
        explosionSound.SoundId = "rbxassetid://142070127"
        explosionSound.Volume = 2
        explosionSound:Play()

        -- Скрываем все видимые части трупа и аксессуаров перед удалением
        for _, part in ipairs(corpseModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle then handle.Transparency = 1 end
            end
        end

        sparks.Enabled = false
        task.wait(2) -- Даем звуку взрыва красиво доиграть на фоне
        corpseModel:Destroy()
    end
end

-- Отслеживаем появление новых моделей трупов в папке corpses
corpsesFolder.ChildAdded:Connect(function(child)
    task.spawn(launchCorpse, child)
end)

wait(1)

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local corpsesFolder = Workspace:WaitForChild("corpses", 15)

if not corpsesFolder then
    warn("❌ Папка 'corpses' не найдена для очистки!")
    return
end

print("🧹 Скрипт-очиститель веса запущен в фоновом режиме! Хитбоксы на трупах отключаются.")

-- Постоянный цикл на частоте кадров (Heartbeat) для мгновенной очистки
RunService.Heartbeat:Connect(function()
    local corpses = corpsesFolder:GetChildren()
    if #corpses == 0 then return end
    
    local ctrl = getgenv().uiLE and getgenv().uiLE.gcontroller

    for _, corpseModel in ipairs(corpses) do
        -- 1. Срочно отключаем этот труп в твоем экстендере хитбоксов
        local corpseName = corpseModel.Name
        if ctrl then
            pcall(function()
                local blacklist = ctrl:Get("BlacklistPlayers") or {}
                if not table.find(blacklist, corpseName) then
                    table.insert(blacklist, corpseName)
                    ctrl:Set("BlacklistPlayers", blacklist)
                end
            end)
        end

        -- 2. Полностью сбрасываем вес и размеры со всех деталей трупа
        for _, part in ipairs(corpseModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false -- Отключаем коллизию, чтобы не бился о столбы
                part.Massless = true    -- ОБНУЛЯЕМ ВЕС: огромная голова больше ничего не весит!
                
                -- Если экстендер успел раздуть голову, принудительно возвращаем нормальный размер
                if part.Name == "Head" and part.Size.Y > 3 then
                    part.Size = Vector3.new(2, 1, 1)
                end
            end
        end
    end
end)

wait(1)

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Settings = {
    GoldSize = Vector3.new(2.0, 0.6, 1.0), -- Аккуратный размер слитка
    GoldColor = Color3.fromRGB(255, 215, 0), -- Роскошный золотой RGB
}

local function brickReplaceFixedRotation(child)
    if child.Name == "wep_model" then
        task.wait(0.02)
        
        local mainPart = child:FindFirstChild("main") or (child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildOfClass("BasePart")))
        if not mainPart or not mainPart:IsA("BasePart") then return end
        
        -- Сжимаем оригинальные черно-белые детали стрелы в микро-точки
        for _, part in ipairs(child:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(0.001, 0.001, 0.001)
                part.CanCollide = false
                part.Massless = true
            elseif part:IsA("SpecialMesh") then
                part.Scale = Vector3.new(0, 0, 0)
            end
        end
        
        -- Создаем золотой блок-слиток
        local goldBrick = Instance.new("Part")
        goldBrick.Name = "XenoGoldBrick"
        goldBrick.Size = Settings.GoldSize
        
        -- Настройка материала и максимального зеркального отражения
        goldBrick.Material = Enum.Material.Metal
        goldBrick.Reflectance = 0.5 -- Золотой зеркальный блеск
        goldBrick.BrickColor = BrickColor.new("Bright gold")
        goldBrick.Color = Settings.GoldColor
        
        -- Отключаем физику, чтобы блок управлялся чисто кодом
        goldBrick.CanCollide = false
        goldBrick.Massless = true
        goldBrick.Anchored = true 
        goldBrick.Parent = child
        
        -- Добавляем системные Sparkles для мощных вспышек на золоте
        local sparkles = Instance.new("Sparkles")
        sparkles.Name = "GoldSparklesEffect"
        sparkles.SparkleColor = Color3.fromRGB(255, 240, 100)
        sparkles.Parent = goldBrick
        
        -- Дополнительный легкий шлейф звезд
        local trailParticles = Instance.new("ParticleEmitter")
        trailParticles.Name = "LightTrail"
        trailParticles.Texture = "rbxassetid://4744839158" -- Красивая 4-лучевая звезда
        trailParticles.Color = ColorSequence.new(Color3.fromRGB(255, 230, 100))
        trailParticles.LightEmission = 1.0
        trailParticles.Rate = 50
        trailParticles.Speed = NumberRange.new(1, 3)
        trailParticles.Lifetime = NumberRange.new(0.2, 0.35)
        trailParticles.Size = NumberSequence.new(0.5, 0)
        trailParticles.Parent = goldBrick
        
        -- ИДЕАЛЬНЫЙ ЦИКЛ ПОЛЕТА (Вырезаем вращение оригинальной стрелы)
        task.spawn(function()
            while child and child.Parent and mainPart and mainPart.Parent and goldBrick and goldBrick.Parent do
                -- Считываем вектор направления полета стрелы
                local velocity = mainPart.AssemblyLinearVelocity
                local direction = velocity.Magnitude > 1 and velocity.Unit or mainPart.CFrame.LookVector
                
                -- ГЛАВНЫЙ СЕКРЕТ ПОЧИНКИ: 
                -- Мы берем ТОЛЬКО позицию стрелы (mainPart.Position) и направляем слиток строго в сторону полета (direction).
                -- Полностью ИГНОРИРУЕМ внутреннее бешеное вращение оригинального CFrame игры!
                goldBrick.CFrame = CFrame.lookAt(mainPart.Position, mainPart.Position + direction)
                
                RunService.Heartbeat:Wait()
            end
            
            if goldBrick then goldBrick:Destroy() end
        end)
        
        print("[Xeno FX]: Фиксатор углов применен! Слиток летит абсолютно ровно.")
    end
end

-- Подключение к папке снарядов
local localarrows = Workspace:WaitForChild("localarrows", 5)
if localarrows then
    localarrows.ChildAdded:Connect(brickReplaceFixedRotation)
    print("[Xeno]: Мод фиксированного золотого слитка запущен. Проверяй выстрел!")
end

wait(1)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- НАСТРОЙКИ АУДИО
local Settings = {
    AudioId = "rbxassetid://138324332743976", -- Твой ID звука
    PitchSpeed = 0.1,                          -- Мрачная замедленная скорость
    Volume = 2.0,                              -- Громкость
}

local currentSound = nil

-- Функция инициализации звука (создается всего один раз за жизнь персонажа)
local function initSound(head)
    if not head then return end
    
    -- Проверяем, нет ли уже созданного звука
    local oldSound = head:FindFirstChild("m1crickd_SavedBowSound")
    if oldSound then oldSound:Destroy() end
    
    local sound = Instance.new("Sound")
    sound.Name = "m1crickd_SavedBowSound"
    sound.SoundId = Settings.AudioId
    sound.Volume = Settings.Volume
    sound.PlaybackSpeed = Settings.PitchSpeed
    
    -- ПЕРВАЯ ФИШКА: Включаем бесконечный повтор аудио, если оно закончится
    sound.Looped = true 
    
    sound.Parent = head
    currentSound = sound
    
    -- Сразу подгружаем его в память движка, чтобы не было задержек при первом взятии лука
    sound:Play()
    sound:Pause()
end

-- Функция включения звука с сохраненного момента
local function resumeBowSound()
    if currentSound then
        -- ВТОРАЯ ФИШКА: Продолжаем играть с той же секунды, где остановились
        currentSound:Resume()
        print("[Xeno Audio]: Лук взят. Звук продолжен с сохраненного момента!")
    else
        -- Если вдруг звук пропал (после респавна), создаем заново
        local character = LocalPlayer.Character
        local head = character and character:FindFirstChild("Head")
        if head then
            initSound(head)
            if currentSound then currentSound:Resume() end
        end
    end
end

-- Функция постановки трека на паузу (сохранение момента)
local function pauseBowSound()
    if currentSound then
        -- Ставим на паузу вместо полного удаления инструмента
        currentSound:Pause()
        print("[Xeno Audio]: Лук убран. Звук поставлен на паузу (момент сохранен).")
    end
end

-- Функция отслеживания инвентаря для конкретного персонажа
local function setupInventoryTracking(character)
    if not character then return end
    local head = character:WaitForChild("Head", 10)
    
    -- Инициализируем аудиобазу в голове персонажа при спавне
    if head then
        initSound(head)
    end
    
    local playerBackpackFolder = LocalPlayer:WaitForChild("backpack", 10)
    local equippedValueObj = playerBackpackFolder and playerBackpackFolder:WaitForChild("equipped", 5)

    if equippedValueObj and equippedValueObj:IsA("StringValue") then
        -- Проверяем стартовое оружие при спавне
        if equippedValueObj.Value == "Compound Bow" then
            resumeBowSound()
        end
        
        -- Отслеживаем смену оружия в слотах через StringValue
        equippedValueObj.Changed:Connect(function(newValue)
            if newValue == "Compound Bow" then
                resumeBowSound() -- Снимаем с паузы
            else
                pauseBowSound() -- Ставим на паузу
            end
        end)
    end
end

-- Запуск скрипта при первой загрузке
if LocalPlayer.Character then
    setupInventoryTracking(LocalPlayer.Character)
end

-- Автоматический сброс паузы и пересоздание звука в новой голове после смерти
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    currentSound = nil -- Очищаем ссылку на старую взорванную голову
    setupInventoryTracking(newCharacter)
end)

print("[Xeno Audio]: Скрипт бесконечной паузы звука лука успешно запущен!")

wait(1)

loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua'))()

