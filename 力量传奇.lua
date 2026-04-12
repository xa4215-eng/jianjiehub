local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()

local rainbowBorderAnimation = nil
local currentBorderColorScheme = "Sakura Mist"
local borderInitialized = false
local animationSpeed = 2
local borderEnabled = true

local COLOR_SCHEMES = {
    ["Blue White"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["Neon"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))
    }), "sparkles"},
    ["Sakura Mist"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFF5F8")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFE0E9")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"light_cherry"},
}

local colorSchemeNames = {}
for name, _ in pairs(COLOR_SCHEMES) do
    table.insert(colorSchemeNames, name)
end
table.sort(colorSchemeNames)

local function createRainbowBorder(window, colorScheme)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil
        end
    end

    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke
    end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["Blue White"][1]
    end
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end

    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end

    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end

    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end

    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end

    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)

    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    local rainbowStroke = createRainbowBorder(Window, scheme)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
end

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G</font>",
    Author = "<font color='#FFA0B5'>YG团队-力量传奇</font>",
    Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/qjWYa4nk2uxfW8NYoz5bgluvARZS4nkjdejCvuKdKIwVOnRPNBCwwaMz9XBsn5jd_2048x2048x4017713.png",
    IconTransparency = 1,
    Folder = "YG",
    Size = UDim2.fromOffset(500, 480),  -- 调大窗口以容纳更多选项卡
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 200,
    HasOutline = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/8Wt7bZfoaK9brDb8dgju7fF8h3UwFAz9x9bLLHVKS1hmPkdfDTgubZ99sZG1I9O2_5120x3856x2331578.jpeg",
    BackgroundImageTransparency = 0.425,
})

Window:EditOpenButton({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G-付费用户</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 188, 217)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 153, 204)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 192, 203))
    }),
    Draggable = true,
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "Theme Changed",
        Content = "Current theme: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local function setBorderActive(active)
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if active then
        if not rainbowStroke then
            rainbowStroke = createRainbowBorder(Window, currentBorderColorScheme)
        end
        if rainbowStroke then
            rainbowStroke.Enabled = true
            if not rainbowBorderAnimation then
                startBorderAnimation(Window, animationSpeed)
            end
        end
    else
        if rainbowStroke then
            rainbowStroke.Enabled = false
        end
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
    end
end

local function applyBorderState()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local shouldBeActive = mainFrame.Visible and borderEnabled
    setBorderActive(shouldBeActive)
end

spawn(function()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then
        repeat
            wait()
            mainFrame = Window.UIElements and Window.UIElements.Main
        until mainFrame
    end
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(applyBorderState)
    applyBorderState()
end)

-- ========================== 原有UI设置选项卡 ==========================
local Settings = Window:Tab({
    Title = "UI settings",
    Icon = "crown",
})

Settings:Toggle({
    Title = "Enable Border",
    Value = borderEnabled,
    Callback = function(value)
        borderEnabled = value
        applyBorderState()
        WindUI:Notify({
            Title = "Border",
            Content = value and "Enabled" or "Disabled",
            Duration = 2,
            Icon = value and "eye" or "eye-off"
        })
    end
})

Settings:Dropdown({
    Title = "Border Settings",
    Desc = "Select Border Color Scheme",
    Values = colorSchemeNames,
    Value = "Sakura Mist",
    Callback = function(value)
        currentBorderColorScheme = value
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[value]
                    if schemeData then
                        glowEffect.Color = schemeData[1]
                    end
                end
            end
        end
        playSound()
    end
})

Settings:Slider({
    Title = "Border Speed",
    Desc = "Adjust the rotation speed of the border",
    Value = { Min = 1, Max = 10, Default = 6 },
    Callback = function(value)
        animationSpeed = value
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame and mainFrame.Visible and borderEnabled then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke and rainbowStroke.Enabled then
                startBorderAnimation(Window, animationSpeed)
            end
        end
        playSound()
    end
})

Settings:Slider({
    Title = "Border Thickness",
    Desc = "Adjust the thickness of the border",
    Value = { Min = 1, Max = 5, Default = 2.65 },
    Step = 0.5,
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                rainbowStroke.Thickness = value
            end
        end
        playSound()
    end
})

Settings:Slider({
    Title = "Corner Radius",
    Desc = "Adjust the corner radius of the UI",
    Value = { Min = 0, Max = 20, Default = 17 },
    Callback = function(value)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local corner = mainFrame:FindFirstChildOfClass("UICorner")
            if not corner then
                corner = Instance.new("UICorner")
                corner.Parent = mainFrame
            end
            corner.CornerRadius = UDim.new(0, value)
        end
        playSound()
    end
})

Settings:Button({
    Title = "Random Color",
    Icon = "palette",
    Callback = function()
        local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
        currentBorderColorScheme = randomColor
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if mainFrame then
            local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
            if rainbowStroke then
                local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
                if glowEffect then
                    local schemeData = COLOR_SCHEMES[randomColor]
                    if schemeData then
                        glowEffect.Color = schemeData[1]
                    end
                end
            end
        end
        playSound()
    end
})

-- ==================== 力量传奇功能代码开始 ====================
-- 全局状态
getgenv().antiafk = getgenv().antiafk or false
getgenv().lockposition = getgenv().lockposition or false
getgenv().autospin = getgenv().autospin or false
getgenv().autobr = getgenv().autobr or false
getgenv().noCooldown = getgenv().noCooldown or false  -- 新增：全道具无冷却
getgenv().autowork = getgenv().autowork or false
getgenv().autopunch = getgenv().autopunch or false
getgenv().autorock = getgenv().autorock or false
getgenv().autokill = getgenv().autokill or false
getgenv().autolockkill = getgenv().autolockkill or false
getgenv().autoevolve = getgenv().autoevolve or false
getgenv().autopetbuy = getgenv().autopetbuy or false
getgenv().unlockpasses = getgenv().unlockpasses or false
getgenv().selectedWorkType = getgenv().selectedWorkType or "哑铃"
getgenv().selectedRockType = getgenv().selectedRockType or ""
getgenv().selectedPetForEvolve = getgenv().selectedPetForEvolve or ""
getgenv().selectedPetToBuy = getgenv().selectedPetToBuy or ""
getgenv().selectedCrystalType = getgenv().selectedCrystalType or "力量水晶"
getgenv().whitelist = getgenv().whitelist or {}
getgenv().lockTargets = getgenv().lockTargets or {}
getgenv().petList = getgenv().petList or {}

-- 窗口焦点状态
getgenv().windowFocused = true
getgenv().forcePacketMode = false

-- 线程管理
getgenv().workThread = nil
getgenv().punchThread = nil
getgenv().rockThread = nil
getgenv().spinThread = nil
getgenv().brawlThread = nil
getgenv().killThread = nil
getgenv().lockKillThread = nil
getgenv().evolveThread = nil
getgenv().petBuyThread = nil
getgenv().unlockPassesThread = nil
getgenv().noCooldownThread = nil  -- 新增线程

-- 获取必要服务
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = Workspace.CurrentCamera
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

-- 石头配置
local ROCK_NAMES = {"冰晶石头", "炼狱石头", "神话石头", "至尊石头", "丛林石头"}

-- 锻炼类型
local WORK_TYPES = {"哑铃", "倒立", "仰卧起坐", "俯卧撑"}

-- 锻炼对应的背包工具名称
local WORK_TOOL_NAMES = {
    ["哑铃"] = "Weight",
    ["倒立"] = "Handstands",
    ["仰卧起坐"] = "Situps",
    ["俯卧撑"] = "Pushups"
}

-- 进化宠物列表（英文名映射）
local EVOLVE_PETS = {
    "霓虹守护者",
    "暗星", 
    "肌肉老师", 
    "赛博龙"
}

local PET_ENGLISH_NAMES = {
    ["霓虹守护者"] = "Neon Guardian",
    ["暗星"] = "Darkstar Hunter",
    ["肌肉老师"] = "Muscle Sensei",
    ["赛博龙"] = "Cybernetic Showdown Dragon"
}

-- 可购买的宠物列表
local BUYABLE_PETS = {
    "小岩石怪",
    "火焰精灵",
    "冰霜幼龙",
    "雷电鸟",
    "暗影猫",
    "光明天使",
    "肌肉猩猩",
    "水晶龟"
}

-- 水晶类型
local CRYSTAL_TYPES = {
    "力量水晶",
    "敏捷水晶", 
    "防御水晶",
    "智慧水晶",
    "幸运水晶",
    "传奇水晶"
}

-- 安全平台坐标
local TELEPORT_LOCATIONS = {
    {name = "安全平台", coords = CFrame.new(-300, 100100, -450)},
    {name = "大厅", coords = CFrame.new(2.93, 88.93, 243.94)},
    {name = "小岛", coords = CFrame.new(-38.86, 7.53, 1894.03)},
    {name = "冰霜健身房", coords = CFrame.new(-2623.02, 7.38, -409.07)},
    {name = "神话健身房", coords = CFrame.new(2250.77, 7.38, 1073.22)},
    {name = "永恒健身房", coords = CFrame.new(-6758.96, 7.38, -1284.91)},
    {name = "传奇健身房", coords = CFrame.new(4603.28, 991.53, -3897.86)},
    {name = "肌肉之王", coords = CFrame.new(-8625.92, 17.23, -5730.47)},
    {name = "丛林健身房", coords = CFrame.new(-8685.62, 6.81, 2392.32)},
    {name = "转盘岛", coords = CFrame.new(1952.09, 1.86, 6180.28)},
    {name = "熔岩争斗", coords = CFrame.new(4472.61, 119.96, -8849.90)},
    {name = "沙漠争斗", coords = CFrame.new(987.70, 17.23, -7440.26)},
    {name = "海滩争斗", coords = CFrame.new(-1863.18, 17.23, -6292.78)},
}

-- 缓存常用对象
local PlayerBackpack = Player:WaitForChild("Backpack")
local ReplicatedStorageCache = ReplicatedStorage
local WorkspaceCache = Workspace

-- 辅助函数
local function getCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end
local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function getRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getLeftHand()
    local char = getCharacter()
    return char and char:FindFirstChild("LeftHand")
end

-- 获取所有玩家名称
local function getPlayerNames()
    local names = {}
    local players = Players:GetPlayers()
    for i = 1, #players do
        local player = players[i]
        if player ~= Player then
            names[#names + 1] = player.Name
        end
    end
    table.sort(names)
    return names
end

-- 扩大版安全平台生成函数
local function createPlatform()
    local success = pcall(function()
        local existingPlatform = WorkspaceCache:FindFirstChild("QW_SafePlatform")
        if existingPlatform then
            existingPlatform:Destroy()
        end
        
        local platformModel = Instance.new("Model")
        platformModel.Name = "QW_SafePlatform"
        platformModel.Parent = WorkspaceCache
        
        local platformPos = Vector3.new(-300, 100090, -450)
        
        -- 主平台
        local mainPlatform = Instance.new("Part")
        mainPlatform.Name = "MainPlatform"
        mainPlatform.Size = Vector3.new(100, 5, 100)
        mainPlatform.Position = platformPos
        mainPlatform.Anchored = true
        mainPlatform.Material = Enum.Material.Neon
        mainPlatform.BrickColor = BrickColor.new("Bright blue")
        mainPlatform.Transparency = 0.2
        mainPlatform.Parent = platformModel
        
        -- 光效
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(0, 255, 255)
        pointLight.Range = 50
        pointLight.Brightness = 2
        pointLight.Parent = mainPlatform
        
        -- 文字标签
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlatformLabel"
        billboard.Size = UDim2.new(0, 300, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 40, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = mainPlatform
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "🔰 安全平台 🔰\n高度: 100100"
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = billboard
        
        return true
    end)
    
    return success
end

-- 获取当前拥有的宠物列表
local function scanOwnedPets()
    return pcall(function()
        local pets = {}
        local playerData = Player:FindFirstChild("PlayerData")
        if playerData then
            local petData = playerData:FindFirstChild("Pets")
            if petData then
                for _, pet in ipairs(petData:GetChildren()) do
                    table.insert(pets, pet.Name)
                end
            end
        end
        
        for _, item in ipairs(PlayerBackpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Pet") then
                table.insert(pets, item.Name)
            end
        end
        
        getgenv().petList = pets
        return pets
    end)
end

-- 自动进化宠物
local function startAutoEvolve()
    if getgenv().evolveThread then
        task.cancel(getgenv().evolveThread)
    end
    
    getgenv().evolveThread = task.spawn(function()
        local rEvents = ReplicatedStorageCache:FindFirstChild("rEvents")
        local petEvolveEvent = rEvents and rEvents:FindFirstChild("petEvolveEvent")
        
        while getgenv().autoevolve do
            pcall(function()
                local petName = getgenv().selectedPetForEvolve
                local englishName = PET_ENGLISH_NAMES[petName]
                
                if englishName and petEvolveEvent then
                    petEvolveEvent:FireServer("evolvePet", englishName)
                end
            end)
            task.wait(2)
        end
    end)
end

-- 自动购买宠物
local function startAutoBuyPet()
    if getgenv().petBuyThread then
        task.cancel(getgenv().petBuyThread)
    end
    
    getgenv().petBuyThread = task.spawn(function()
        while getgenv().autopetbuy do
            pcall(function()
                local petName = getgenv().selectedPetToBuy
                local crystalType = getgenv().selectedCrystalType
                
                if petName and petName ~= "" then
                    local rEvents = ReplicatedStorageCache:FindFirstChild("rEvents")
                    if rEvents then
                        local buyEvent = rEvents:FindFirstChild("buyPetEvent") 
                            or rEvents:FindFirstChild("purchasePetEvent")
                        if buyEvent then
                            buyEvent:FireServer("buy", petName, crystalType)
                        end
                    end
                end
            end)
            task.wait(3)
        end
    end)
end

-- 解锁通行证功能
local function startUnlockPasses()
    if getgenv().unlockPassesThread then
        task.cancel(getgenv().unlockPassesThread)
        getgenv().unlockPassesThread = nil
    end
    
    getgenv().unlockPassesThread = task.spawn(function()
        print("解锁通行证线程已启动")
        
        while getgenv().unlockpasses do
            pcall(function()
                local gamepassIds = ReplicatedStorageCache:FindFirstChild("gamepassIds")
                local ownedGamepasses = Player:FindFirstChild("ownedGamepasses")
                
                if gamepassIds and ownedGamepasses then
                    for _, v in ipairs(gamepassIds:GetChildren()) do
                        v.Parent = ownedGamepasses
                    end
                end
                
                local dataFolder = Player:FindFirstChild("Data") or ReplicatedStorageCache:FindFirstChild("Data")
                if dataFolder then
                    local dataGamepassIds = dataFolder:FindFirstChild("gamepassIds")
                    local dataOwnedGamepasses = dataFolder:FindFirstChild("ownedGamepasses")
                    
                    if dataGamepassIds and dataOwnedGamepasses then
                        for _, v in ipairs(dataGamepassIds:GetChildren()) do
                            v.Parent = dataOwnedGamepasses
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end

-- 获取屏幕右上角最边缘位置
local function getTopRightCorner()
    local viewport = Camera.ViewportSize
    return Vector2.new(viewport.X - 5, 5)
end

-- 模拟鼠标点击右上角最边缘位置
local function clickTopRightCorner()
    if not UserInputService.WindowFocused then
        return false
    end
    
    return pcall(function()
        local clickPos = getTopRightCorner()
        
        VirtualInputManager:SendMouseMoveEvent(clickPos.X, clickPos.Y, game, 0)
        task.wait(0.01)
        
        VirtualInputManager:SendMouseButtonEvent(
            clickPos.X, clickPos.Y,
            0, true, game, 0
        )
        task.wait(0.01)
        
        VirtualInputManager:SendMouseButtonEvent(
            clickPos.X, clickPos.Y,
            0, false, game, 0
        )
        
        return true
    end)
end

-- 装备Punch工具函数
local function equipPunchTool()
    return pcall(function()
        local punchTool = PlayerBackpack:FindFirstChild("Punch")
        if punchTool then
            local char = getCharacter()
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(punchTool)
                return true
            end
        end
        return false
    end)
end

-- 自动击杀全部
local function startAutoKill()
    if getgenv().killThread then
        task.cancel(getgenv().killThread)
        getgenv().killThread = nil
    end
    
    getgenv().killThread = task.spawn(function()
        print("自动击杀线程已启动 - 自动切换Punch并点击")
        
        while getgenv().autokill do
            pcall(function()
                -- 1. 先装备Punch工具
                equipPunchTool()
                
                -- 2. 点击右上角（触发攻击）
                if UserInputService.WindowFocused then
                    clickTopRightCorner()
                end
                
                -- 3. 遍历所有玩家进行击杀逻辑
                local players = Players:GetPlayers()
                for i = 1, #players do
                    local player = players[i]
                    if player ~= Player and not getgenv().whitelist[player.Name] then
                        local targetHead = player.Character and player.Character:FindFirstChild('Head')
                        local leftHand = getLeftHand()
                        if targetHead and leftHand then
                            firetouchinterest(targetHead, leftHand, 0)
                            task.wait(0.01)
                            firetouchinterest(targetHead, leftHand, 1)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
        
        print("自动击杀线程已停止")
    end)
end

-- 自动挥拳（使用Punch工具）
local function startAutoPunch()
    if getgenv().punchThread then
        task.cancel(getgenv().punchThread)
        getgenv().punchThread = nil
    end
    
    getgenv().punchThread = task.spawn(function()
        print("自动挥拳线程已启动")
        
        local lastPunchTime = 0
        local punchInterval = 0.1
        local muscleEvent = Player:FindFirstChild("muscleEvent")
        
        while getgenv().autopunch do
            local currentTime = tick()
            
            if (currentTime - lastPunchTime) >= punchInterval then
                pcall(function()
                    equipPunchTool()
                    
                    if muscleEvent then
                        muscleEvent:FireServer("punch", "leftHand")
                        task.wait(0.02)
                        muscleEvent:FireServer("punch", "rightHand")
                    end
                    
                    if UserInputService.WindowFocused then
                        clickTopRightCorner()
                    end
                    
                    lastPunchTime = currentTime
                end)
            end
            
            task.wait(0.05)
        end
    end)
end

-- 自动打石头
local function startAutoRock()
    if getgenv().rockThread then
        task.cancel(getgenv().rockThread)
        getgenv().rockThread = nil
    end
    
    getgenv().rockThread = task.spawn(function()
        local rockMap = {
            ["丛林石头"] = "Ancient Jungle Rock",
            ["至尊石头"] = "Muscle King Mountain",
            ["神话石头"] = "Rock Of Legends",
            ["炼狱石头"] = "Inferno Rock",
            ["冰晶石头"] = "Frozen Rock"
        }
        
        while getgenv().autorock do
            pcall(function()
                equipPunchTool()
                
                if UserInputService.WindowFocused then
                    clickTopRightCorner()
                end
                
                local rockType = getgenv().selectedRockType
                local folderName = rockMap[rockType]
                if folderName then
                    local folder = WorkspaceCache:FindFirstChild("machinesFolder")
                    if folder then
                        local rockFolder = folder[folderName]
                        if rockFolder and rockFolder.Rock then
                            local rock = rockFolder.Rock
                            local leftHand = getLeftHand()
                            if rock and leftHand then
                                firetouchinterest(rock, leftHand, 0)
                                task.wait(0.01)
                                firetouchinterest(rock, leftHand, 1)
                            end
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end

-- 反挂机
local function startAntiAfk()
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), WorkspaceCache.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), WorkspaceCache.CurrentCamera.CFrame)
    end)
end

-- 防甩飞
local function toggleLockPosition(state)
    getgenv().lockposition = state
    if state then
        local hrp = getCharacter() and getCharacter():FindFirstChild("HumanoidRootPart")
        if hrp then
            local lockedPos = hrp.Position
            task.spawn(function()
                while getgenv().lockposition do
                    pcall(function()
                        local root = getCharacter() and getCharacter():FindFirstChild("HumanoidRootPart")
                        if root then root.CFrame = CFrame.new(lockedPos) end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
end

-- 自动抽奖
local function startAutoSpin()
    if getgenv().spinThread then
        task.cancel(getgenv().spinThread)
    end
    
    getgenv().spinThread = task.spawn(function()
        local fortuneWheelChances = ReplicatedStorageCache:FindFirstChild("fortuneWheelChances")
        local rEvents = ReplicatedStorageCache:FindFirstChild("rEvents")
        local openFortuneWheelRemote = rEvents and rEvents:FindFirstChild("openFortuneWheelRemote")
        
        while getgenv().autospin do
            pcall(function()
                if fortuneWheelChances and openFortuneWheelRemote then
                    local wheel = fortuneWheelChances:FindFirstChild('Fortune Wheel')
                    if wheel then
                        openFortuneWheelRemote:InvokeServer('openFortuneWheel', wheel)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end
-- 自动加入比赛
local function startAutoBrawl()
    if getgenv().brawlThread then
        task.cancel(getgenv().brawlThread)
    end
    
    getgenv().brawlThread = task.spawn(function()
        local rEvents = ReplicatedStorageCache:FindFirstChild("rEvents")
        local brawlEvent = rEvents and rEvents:FindFirstChild("brawlEvent")
        
        while getgenv().autobr do
            pcall(function() 
                if brawlEvent then
                    brawlEvent:FireServer('joinBrawl')
                end
            end)
            task.wait(1)
        end
    end)
end

-- 锁定击杀指定目标
local function startLockKill()
    if getgenv().lockKillThread then
        task.cancel(getgenv().lockKillThread)
        getgenv().lockKillThread = nil
    end
    
    getgenv().lockKillThread = task.spawn(function()
        local muscleEvent = Player:FindFirstChild("muscleEvent")
        
        while getgenv().autolockkill do
            for targetName, _ in pairs(getgenv().lockTargets) do
                local targetPlayer = Players:FindFirstChild(targetName)
                if targetPlayer then
                    pcall(function()
                        local targetChar = targetPlayer.Character
                        local localChar = Player.Character
                        if targetChar and localChar then
                            if targetChar.Head then
                                targetChar.Head.Anchored = true
                                targetChar.Head.CanCollide = false
                            end
                            if muscleEvent then
                                muscleEvent:FireServer("punch", "leftHand")
                                muscleEvent:FireServer("punch", "rightHand")
                            end
                            task.wait()
                            if targetChar.Head and localChar.LeftHand then
                                targetChar.Head.Position = localChar.LeftHand.Position
                            end
                        end
                    end)
                end
            end
            task.wait(1)
        end
    end)
end

-- 数据包锻炼方法
local function packetWorkMethod()
    return pcall(function()
        local muscleEvent = Player:FindFirstChild("muscleEvent")
        if muscleEvent then
            muscleEvent:FireServer("rep")
            return true
        end
        
        local rEvents = ReplicatedStorageCache:FindFirstChild("rEvents")
        if rEvents then
            local workEvent = rEvents:FindFirstChild("workEvent") 
                or rEvents:FindFirstChild("exerciseEvent")
            if workEvent then
                workEvent:FireServer("start", getgenv().selectedWorkType)
                return true
            end
        end
        
        local toolName = WORK_TOOL_NAMES[getgenv().selectedWorkType]
        if toolName then
            local char = getCharacter()
            local tool = char:FindFirstChild(toolName)
            if tool then
                tool:Activate()
                return true
            end
        end
        
        return false
    end)
end

-- 点击锻炼方法
local function clickWorkMethod()
    if not UserInputService.WindowFocused then
        return false
    end
    
    return pcall(function()
        clickTopRightCorner()
        
        local toolName = WORK_TOOL_NAMES[getgenv().selectedWorkType]
        if toolName then
            local tool = PlayerBackpack:FindFirstChild(toolName)
            if tool then
                local char = getCharacter()
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:EquipTool(tool)
                end
            end
        end
        
        return true
    end)
end

-- 窗口状态监控
local function startWindowMonitor()
    task.spawn(function()
        local lastFocused = true
        local focusLostTime = 0
        local switchDelay = 2
        
        while true do
            local currentFocused = UserInputService.WindowFocused
            local currentTime = tick()
            
            if currentFocused ~= lastFocused then
                if currentFocused then
                    print("窗口恢复焦点")
                    getgenv().forcePacketMode = false
                else
                    print("窗口失去焦点")
                    focusLostTime = currentTime
                end
                lastFocused = currentFocused
            end
            
            if not currentFocused and not getgenv().forcePacketMode then
                if currentTime - focusLostTime > switchDelay then
                    getgenv().forcePacketMode = true
                end
            end
            
            task.wait(1)
        end
    end)
end

-- 自动锻炼
local function startAutoWork()
    if getgenv().workThread then
        task.cancel(getgenv().workThread)
        getgenv().workThread = nil
    end
    
    getgenv().workThread = task.spawn(function()
        print("自动锻炼线程已启动")
        
        local lastExecuteTime = 0
        local executeInterval = 0.3
        local userActive = false
        local lastUserInput = tick()
        
        local inputConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                userActive = true
                lastUserInput = tick()
                
                task.spawn(function()
                    task.wait(1)
                    if tick() - lastUserInput >= 1 then
                        userActive = false
                    end
                end)
            end
        end)
        
        while getgenv().autowork do
            local currentTime = tick()
            
            if not userActive and (currentTime - lastExecuteTime) >= executeInterval then
                local success = false
                
                if getgenv().forcePacketMode or not UserInputService.WindowFocused then
                    success = packetWorkMethod()
                else
                    success = clickWorkMethod()
                    if not success then
                        success = packetWorkMethod()
                    end
                end
                
                if success then
                    lastExecuteTime = currentTime
                end
            end
            
            task.wait(0.1)
        end
        
        inputConnection:Disconnect()
    end)
end

-- 传送函数
local function teleportTo(location)
    local hrp = getRootPart()
    if hrp then
        hrp.CFrame = location.coords
        WindUI:Notify({
            Title = "传送",
            Content = "已传送至 " .. location.name,
            Duration = 2
        })
        
        if location.name == "安全平台" then
            createPlatform()
        end
    end
end

-- ==================== 新增：全道具无冷却功能 ====================
local function startNoCooldown()
    if getgenv().noCooldownThread then
        task.cancel(getgenv().noCooldownThread)
    end
    
    getgenv().noCooldownThread = task.spawn(function()
        while getgenv().noCooldown do
            pcall(function()
                -- 处理背包中的物品
                local backpack = Player:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            if item:FindFirstChild("repTime") then
                                item.repTime.Value = 0
                            end
                            if item:FindFirstChild("attackTime") then
                                item.attackTime.Value = 0
                            end
                        end
                    end
                end
                
                -- 处理当前角色手持的物品
                local char = getCharacter()
                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") then
                            if item:FindFirstChild("repTime") then
                                item.repTime.Value = 0
                            end
                            if item:FindFirstChild("attackTime") then
                                item.attackTime.Value = 0
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)  -- 快速循环保持冷却为0
        end
    end)
end

local function toggleNoCooldown(state)
    getgenv().noCooldown = state
    if state then
        startNoCooldown()
        WindUI:Notify({
            Title = "全道具无冷却",
            Content = "已开启",
            Duration = 2
        })
    else
        if getgenv().noCooldownThread then
            task.cancel(getgenv().noCooldownThread)
            getgenv().noCooldownThread = nil
        end
        WindUI:Notify({
            Title = "全道具无冷却",
            Content = "已关闭",
            Duration = 2
        })
    end
end

-- ==================== 创建选项卡 ====================

-- 基础功能选项卡
local BasicTab = Window:Tab({ Title = "基础", Icon = "home" })

BasicTab:Section({ Title = "基础设置", Opened = true })

BasicTab:Toggle({
    Title = "反挂机",
    Icon = "clock",
    Value = getgenv().antiafk,
    Callback = function(state)
        getgenv().antiafk = state
        if state then 
            startAntiAfk()
            WindUI:Notify({
                Title = "反挂机",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "反挂机",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

BasicTab:Toggle({
    Title = "防甩飞",
    Icon = "lock",
    Value = getgenv().lockposition,
    Callback = function(state)
        toggleLockPosition(state)
        if state then
            WindUI:Notify({
                Title = "防甩飞",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "防甩飞",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

BasicTab:Toggle({
    Title = "自动抽奖",
    Icon = "dollar-sign",
    Value = getgenv().autospin,
    Callback = function(state)
        getgenv().autospin = state
        if state then 
            startAutoSpin()
            WindUI:Notify({
                Title = "自动抽奖",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "自动抽奖",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

BasicTab:Toggle({
    Title = "自动加入比赛",
    Icon = "trophy",
    Value = getgenv().autobr,
    Callback = function(state)
        getgenv().autobr = state
        if state then 
            startAutoBrawl()
            WindUI:Notify({
                Title = "自动加入比赛",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "自动加入比赛",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

BasicTab:Divider()

-- 新增：全道具无冷却开关
BasicTab:Toggle({
    Title = "全道具无冷却",
    Icon = "zap",
    Value = getgenv().noCooldown,
    Callback = toggleNoCooldown
})

BasicTab:Divider()

BasicTab:Toggle({
    Title = "解锁通行证",
    Icon = "key",
    Value = getgenv().unlockpasses,
    Callback = function(state)
        getgenv().unlockpasses = state
        if state then 
            startUnlockPasses()
            WindUI:Notify({
                Title = "解锁通行证",
                Content = "已开启",
                Duration = 2
            })
        else
            if getgenv().unlockPassesThread then
                task.cancel(getgenv().unlockPassesThread)
                getgenv().unlockPassesThread = nil
            end
            WindUI:Notify({
                Title = "解锁通行证",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

-- 特色功能选项卡
local FeaturesTab = Window:Tab({ Title = "特色", Icon = "zap" })

FeaturesTab:Section({ Title = "自动锻炼", Opened = true })

FeaturesTab:Dropdown({
    Title = "锻炼类型",
    Values = WORK_TYPES,
    Value = getgenv().selectedWorkType,
    Multi = false,
    Callback = function(option)
        getgenv().selectedWorkType = optionWindUI:Notify({
            Title = "锻炼类型",
            Content = "已选择: " .. option,
            Duration = 2
        })
    end
})

FeaturesTab:Toggle({
    Title = "自动锻炼",
    Icon = "activity",
    Value = getgenv().autowork,
    Callback = function(state)
        getgenv().autowork = state
        if state then 
            startAutoWork()
            WindUI:Notify({
                Title = "自动锻炼",
                Content = "已开启",
                Duration = 2
            })
        else
            if getgenv().workThread then
                task.cancel(getgenv().workThread)
                getgenv().workThread = nil
            end
            WindUI:Notify({
                Title = "自动锻炼",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

FeaturesTab:Divider()

FeaturesTab:Toggle({
    Title = "自动挥拳",
    Icon = "hand",
    Value = getgenv().autopunch,
    Callback = function(state)
        getgenv().autopunch = state
        if state then 
            startAutoPunch()
            WindUI:Notify({
                Title = "自动挥拳",
                Content = "已开启",
                Duration = 2
            })
        else
            if getgenv().punchThread then
                task.cancel(getgenv().punchThread)
                getgenv().punchThread = nil
            end
            WindUI:Notify({
                Title = "自动挥拳",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

FeaturesTab:Divider()

-- 自动石头区域
FeaturesTab:Section({ Title = "自动石头", Opened = true })

FeaturesTab:Dropdown({
    Title = "石头类型",
    Values = ROCK_NAMES,
    Value = getgenv().selectedRockType,
    Multi = false,
    Callback = function(option)
        getgenv().selectedRockType = option
        WindUI:Notify({
            Title = "石头类型",
            Content = "已选择: " .. option,
            Duration = 2
        })
    end
})

FeaturesTab:Toggle({
    Title = "自动打石头",
    Icon = "mountain",
    Value = getgenv().autorock,
    Callback = function(state)
        getgenv().autorock = state
        if state then
            if getgenv().selectedRockType ~= "" then
                startAutoRock()
                WindUI:Notify({
                    Title = "自动打石头",
                    Content = "已开启",
                    Duration = 2
                })
            else
                getgenv().autorock = false
                WindUI:Notify({ 
                    Title = "提示", 
                    Content = "请先选择石头类型", 
                    Duration = 2 
                })
            end
        else
            if getgenv().rockThread then
                task.cancel(getgenv().rockThread)
                getgenv().rockThread = nil
            end
            WindUI:Notify({
                Title = "自动打石头",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

-- PVP功能选项卡
local PvPTab = Window:Tab({ Title = "PVP", Icon = "sword" })

PvPTab:Section({ Title = "PVP设置", Opened = true })

PvPTab:Dropdown({
    Title = "白名单",
    Values = getPlayerNames(),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        local newWhitelist = {}
        for _, name in ipairs(selected) do
            newWhitelist[name] = true
        end
        getgenv().whitelist = newWhitelist
        WindUI:Notify({
            Title = "白名单",
            Content = "已更新",
            Duration = 2
        })
    end
})

PvPTab:Toggle({
    Title = "自动击杀全部",
    Icon = "skull",
    Value = getgenv().autokill,
    Callback = function(state)
        getgenv().autokill = state
        if state then 
            startAutoKill()
            WindUI:Notify({
                Title = "自动击杀全部",
                Content = "已开启（自动切换Punch）",
                Duration = 2
            })
        else
            if getgenv().killThread then
                task.cancel(getgenv().killThread)
                getgenv().killThread = nil
            end
            WindUI:Notify({
                Title = "自动击杀全部",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

PvPTab:Divider()

PvPTab:Dropdown({
    Title = "击杀目标",
    Values = getPlayerNames(),
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        local newTargets = {}
        for _, name in ipairs(selected) do
            newTargets[name] = true
        end
        getgenv().lockTargets = newTargets
        WindUI:Notify({
            Title = "击杀目标",
            Content = "已更新",
            Duration = 2
        })
    end
})

PvPTab:Toggle({
    Title = "开始击杀指定目标",
    Icon = "target",
    Value = getgenv().autolockkill,
    Callback = function(state)
        getgenv().autolockkill = state
        if state then 
            startLockKill()
            WindUI:Notify({
                Title = "击杀指定目标",
                Content = "已开启",
                Duration = 2
            })
        else
            if getgenv().lockKillThread then
                task.cancel(getgenv().lockKillThread)
                getgenv().lockKillThread = nil
            end
            WindUI:Notify({
                Title = "击杀指定目标",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

-- 宠物选项卡
local PetsTab = Window:Tab({ Title = "宠物", Icon = "dog" })

PetsTab:Section({ Title = "宠物管理", Opened = true })

PetsTab:Button({
    Title = "刷新宠物列表",
    Icon = "refresh-cw",
    Callback = function()
        local pets = scanOwnedPets()
        if pets and #pets > 0 then
            WindUI:Notify({
                Title = "宠物列表",
                Content = "找到 " .. #pets .. " 只宠物",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "宠物列表",
                Content = "未找到宠物",
                Duration = 2
            })
        end
    end
})

PetsTab:Divider()

PetsTab:Section({ Title = "宠物进化", Opened = true })

PetsTab:Dropdown({
    Title = "选择宠物",
    Values = EVOLVE_PETS,
    Value = getgenv().selectedPetForEvolve,
    Multi = false,
    Callback = function(option)
        getgenv().selectedPetForEvolve = option
        WindUI:Notify({
            Title = "宠物选择",
            Content = "已选择: " .. option,
            Duration = 2
        })
    end
})

PetsTab:Toggle({
    Title = "自动进化",
    Icon = "sparkles",
    Value = getgenv().autoevolve,
    Callback = function(state)
        getgenv().autoevolve = state
        if state then 
            startAutoEvolve()
            WindUI:Notify({
                Title = "自动进化",
                Content = "已开启",
                Duration = 2
            })
        else
            if getgenv().evolveThread then
                task.cancel(getgenv().evolveThread)
                getgenv().evolveThread = nil
            end
            WindUI:Notify({
                Title = "自动进化",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

PetsTab:Divider()

PetsTab:Section({ Title = "宠物购买", Opened = true })

PetsTab:Dropdown({
    Title = "选择宠物",
    Values = BUYABLE_PETS,
    Value = getgenv().selectedPetToBuy,
    Multi = false,
    Callback = function(option)
        getgenv().selectedPetToBuy = option
        WindUI:Notify({
            Title = "宠物选择",
            Content = "已选择: " .. option,
            Duration = 2
        })
    end
})

PetsTab:Dropdown({
    Title = "水晶类型",
    Values = CRYSTAL_TYPES,
    Value = getgenv().selectedCrystalType,
    Multi = false,
    Callback = function(option)
        getgenv().selectedCrystalType = option
        WindUI:Notify({
            Title = "水晶类型",
            Content = "已选择: " .. option,
            Duration = 2
        })
    end
})

PetsTab:Toggle({
    Title = "自动购买",
    Icon = "shopping-cart",
    Value = getgenv().autopetbuy,
    Callback = function(state)
        getgenv().autopetbuy = state
        if state then 
            if getgenv().selectedPetToBuy ~= "" then
                startAutoBuyPet()
                WindUI:Notify({
                    Title = "自动购买",
                    Content = "已开启",
                    Duration = 2
                })
            else
                getgenv().autopetbuy = false
                WindUI:Notify({
                    Title = "提示",
                    Content = "请先选择宠物",
                    Duration = 2
                })
            end
        else
            if getgenv().petBuyThread then
                task.cancel(getgenv().petBuyThread)
                getgenv().petBuyThread = nil
            end
            WindUI:Notify({
                Title = "自动购买",
                Content = "已关闭",
                Duration = 2
            })
        end
    end
})

-- 传送选项卡
local TeleportTab = Window:Tab({ Title = "传送", Icon = "map-pin" })

TeleportTab:Section({ Title = "快速传送", Opened = true })

for _, location in ipairs(TELEPORT_LOCATIONS) do
    TeleportTab:Button({
        Title = location.name,
        Icon = "map-pin",
        Callback = function()
            teleportTo(location)
        end
    })
end

TeleportTab:Divider()
TeleportTab:Button({
    Title = "重新生成安全平台",
    Icon = "box",
    Callback = function()
        local success = createPlatform()
        if success then
            WindUI:Notify({
                Title = "安全平台",
                Content = "平台生成成功",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "安全平台",
                Content = "平台生成失败",
                Duration = 3
            })
        end
    end
})

-- 关于选项卡
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })

AboutTab:Paragraph({
    Title = "QW 力量传奇",
    Desc = "版本: 1.2.0\n作者: Was",
    Image = "award",
    ImageSize = 32,
    Color = "Orange"
})

AboutTab:Divider()

-- ==================== 停止所有功能按钮 ====================
AboutTab:Button({
    Title = "停止所有功能",
    Icon = "square",
    Callback = function()
        -- 将所有全局开关设为 false
        getgenv().antiafk = false
        getgenv().lockposition = false
        getgenv().autospin = false
        getgenv().autobr = false
        getgenv().noCooldown = false  -- 新增
        getgenv().autowork = false
        getgenv().autopunch = false
        getgenv().autorock = false
        getgenv().autokill = false
        getgenv().autolockkill = false
        getgenv().autoevolve = false
        getgenv().autopetbuy = false
        getgenv().unlockpasses = false

        -- 取消所有线程
        if getgenv().workThread then task.cancel(getgenv().workThread); getgenv().workThread = nil end
        if getgenv().punchThread then task.cancel(getgenv().punchThread); getgenv().punchThread = nil end
        if getgenv().rockThread then task.cancel(getgenv().rockThread); getgenv().rockThread = nil end
        if getgenv().spinThread then task.cancel(getgenv().spinThread); getgenv().spinThread = nil end
        if getgenv().brawlThread then task.cancel(getgenv().brawlThread); getgenv().brawlThread = nil end
        if getgenv().killThread then task.cancel(getgenv().killThread); getgenv().killThread = nil end
        if getgenv().lockKillThread then task.cancel(getgenv().lockKillThread); getgenv().lockKillThread = nil end
        if getgenv().evolveThread then task.cancel(getgenv().evolveThread); getgenv().evolveThread = nil end
        if getgenv().petBuyThread then task.cancel(getgenv().petBuyThread); getgenv().petBuyThread = nil end
        if getgenv().unlockPassesThread then task.cancel(getgenv().unlockPassesThread); getgenv().unlockPassesThread = nil end
        if getgenv().noCooldownThread then task.cancel(getgenv().noCooldownThread); getgenv().noCooldownThread = nil end  -- 新增

        WindUI:Notify({
            Title = "停止",
            Content = "所有自动功能已停止",
            Duration = 3
        })
    end
})

-- ==================== 启动监控与通知 ====================
startWindowMonitor()

task.spawn(function()
    task.wait(2)
    createPlatform()
    WindUI:Notify({
        Title = "安全平台",
        Content = "已自动生成",
        Duration = 3
    })
end)

WindUI:Notify({
    Title = "YG 力量传奇",
    Content = "加载成功",
    Duration = 3
})

-- 窗口关闭时不停止功能
Window:OnClose(function()
    -- 注释掉所有停止代码，仅保留空函数
    -- 关闭窗口后功能继续运行
    -- 如需彻底停止，请使用“停止所有功能”按钮
end)