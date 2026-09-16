local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")

local ID_BOW_DRAW       = "rbxassetid://126832876895392"
local ID_BOW_PASS       = "rbxassetid://72129857868180"
local ID_BOW_BODY_HIT   = "rbxassetid://132110078840319"
local ID_KICK           = "rbxassetid://126832876895392"
local ID_THROW          = "rbxassetid://72129857868180"
local ID_MUTE           = "rbxassetid://0"

local kickKeywords = {"kickswoosh", "doorkick", "dropkick"}

local function patchSoundCombined(soundObject)
    if not soundObject:IsA("Sound") then return end
    
    local name = soundObject.Name:lower()
    
    if name:find("throw") then
        soundObject.SoundId = ID_THROW
        soundObject.Volume = 1.5
        
        soundObject:GetPropertyChangedSignal("SoundId"):Connect(function()
            if soundObject.SoundId ~= ID_THROW then
                soundObject.SoundId = ID_THROW
                soundObject.Volume = 1.5
            end
        end)
        return
    end
    
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
    
    if name == "arrowdraw" then
        soundObject.SoundId = ID_BOW_DRAW
        soundObject.Volume = 0.9 
        soundObject.PlaybackSpeed = 0.45
        
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
        soundObject.Volume = 1.0 
        soundObject.PlaybackSpeed = 1.0
        
    elseif name == "arrowhit1" or name == "arrowhit2" or name == "arrowkill" then
        soundObject.SoundId = ID_MUTE
        soundObject.Volume = 0
    end
end

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

monitorServiceAll(Workspace)
monitorServiceAll(ReplicatedStorage)
monitorServiceAll(SoundService)
monitorServiceAll(Players.LocalPlayer:WaitForChild("PlayerGui", 10))

wait(1)

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local UP_FORCE = 320
local ROTATION_SPEED = 60
local FLY_DURATION = 2.8

local corpsesFolder = Workspace:WaitForChild("corpses", 15)
if not corpsesFolder then return end

local function launchCorpse(corpseModel)
    task.wait(0.1)
    if not corpseModel or not corpseModel.Parent then return end

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

    for _, part in ipairs(corpseModel:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.Massless = true
        end
    end

    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://258128463"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 0, 0))
    sparks.Rate = 220
    sparks.Speed = NumberRange.new(5, 12)
    sparks.Lifetime = NumberRange.new(0.4, 0.7)
    sparks.Parent = mainPart

    local launchSound = Instance.new("Sound", mainPart)
    launchSound.SoundId = "rbxassetid://123227138621330"
    launchSound.Volume = 2.5
    launchSound:Play()

    mainPart.AssemblyLinearVelocity = Vector3.new(0, UP_FORCE, 0)

    local attachment = Instance.new("Attachment", mainPart)
    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.MaxTorque = math.huge
    angularVelocity.AngularVelocity = Vector3.new(0, ROTATION_SPEED, 0)
    angularVelocity.Attachment0 = attachment
    angularVelocity.Parent = mainPart

    local startTime = os.clock()
    while os.clock() - startTime < FLY_DURATION do
        if not mainPart or not mainPart.Parent then break end
        mainPart.AssemblyLinearVelocity = Vector3.new(mainPart.AssemblyLinearVelocity.X, UP_FORCE, mainPart.AssemblyLinearVelocity.Z)
        task.wait(0.05)
    end

    if mainPart and mainPart.Parent then
        local explosion = Instance.new("ParticleEmitter")
        explosion.Texture = "rbxassetid://244221448"
        explosion.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255))
        explosion.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 15)})
        explosion.Rate = 800
        explosion.Lifetime = NumberRange.new(1, 1.6)
        explosion.Speed = NumberRange.new(30, 75)
        explosion.Parent = mainPart
        
        explosion:Emit(150)

        local explosionSound = Instance.new("Sound", mainPart)
        explosionSound.SoundId = "rbxassetid://142070127"
        explosionSound.Volume = 2
        explosionSound:Play()

        for _, part in ipairs(corpseModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle then handle.Transparency = 1 end
            end
        end

        sparks.Enabled = false
        task.wait(2)
        corpseModel:Destroy()
    end
end

corpsesFolder.ChildAdded:Connect(function(child)
    task.spawn(launchCorpse, child)
end)

task.wait(1)

RunService.Heartbeat:Connect(function()
    local corpses = corpsesFolder:GetChildren()
    if #corpses == 0 then return end
    
    local ctrl = getgenv().uiLE and getgenv().uiLE.gcontroller

    for _, corpseModel in ipairs(corpses) do
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

        for _, part in ipairs(corpseModel:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
                
                if part.Name == "Head" and part.Size.Y > 3 then
                    part.Size = Vector3.new(2, 1, 1)
                end
            end
        end
    end
end)
