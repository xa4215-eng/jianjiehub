-- 加载剑杰 UI库
local WindUI = (function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua", true))()
    end)
    if success and result then return result end
    warn("WindUI加载失败，尝试备用链接")
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua", true))()
end)()

if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "剑杰 | 加载失败", Text = "无法加载WindUI库", Duration = 5})
    return
end

-- ========== 彩虹边框配置 ==========
local COLOR_SCHEMES = {
    ["Blue White"] = {ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5,Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1,Color3.fromHex("FFFFFF"))}),"droplet"},
    ["Neon"] = {ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25,Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5,Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75,Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1,Color3.fromHex("00FFFF"))}),"sparkles"},
    ["Sakura Mist"] = {ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHex("FFF5F8")),ColorSequenceKeypoint.new(0.5,Color3.fromHex("FFE0E9")),ColorSequenceKeypoint.new(1,Color3.fromHex("FFB6C1"))}),"light_cherry"},
    ["Purple Haze"] = {ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHex("E6E6FA")),ColorSequenceKeypoint.new(0.5,Color3.fromHex("9370DB")),ColorSequenceKeypoint.new(1,Color3.fromHex("4B0082"))}),"cloud"},
    ["Sunset"] = {ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5,Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1,Color3.fromHex("FF69B4"))}),"sun"},
}
local colorSchemeNames = {}
for n in pairs(COLOR_SCHEMES) do table.insert(colorSchemeNames, n) end
table.sort(colorSchemeNames)

local rainbowBorderAnimation, currentBorderColorScheme, borderEnabled, animationSpeed = nil, "Sakura Mist", true, 2

local function createRainbowBorder(w)
    if not w or not w.UIElements then wait(1); if not w or not w.UIElements then return end end
    local mf = w.UIElements.Main; if not mf then return end
    local ex = mf:FindFirstChild("RainbowStroke")
    if ex then
        local ge = ex:FindFirstChild("GlowEffect")
        if ge and COLOR_SCHEMES[currentBorderColorScheme] then ge.Color = COLOR_SCHEMES[currentBorderColorScheme][1] end
        return ex
    end
    if not mf:FindFirstChildOfClass("UICorner") then
        Instance.new("UICorner", mf).CornerRadius = UDim.new(0,16)
    end
    local rs = Instance.new("UIStroke")
    rs.Name = "RainbowStroke"; rs.Thickness = 1.5; rs.Color = Color3.new(1,1,1); rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rs.LineJoinMode = Enum.LineJoinMode.Round; rs.Enabled = borderEnabled; rs.Parent = mf
    local ge = Instance.new("UIGradient")
    ge.Name = "GlowEffect"; ge.Color = COLOR_SCHEMES[currentBorderColorScheme] and COLOR_SCHEMES[currentBorderColorScheme][1] or COLOR_SCHEMES["Blue White"][1]
    ge.Rotation = 0; ge.Parent = rs
    return rs
end

local function startBorderAnimation(w, s)
    if not w or not w.UIElements then return end
    local mf = w.UIElements.Main; if not mf then return end
    local rs = mf:FindFirstChild("RainbowStroke"); if not rs or not rs.Enabled then return end
    local ge = rs:FindFirstChild("GlowEffect"); if not ge then return end
    if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect(); rainbowBorderAnimation = nil end
    local a
    a = game:GetService("RunService").Heartbeat:Connect(function()
        if not rs or rs.Parent == nil or not rs.Enabled then a:Disconnect(); return end
        ge.Rotation = (tick() * s * 60) % 360
    end)
    rainbowBorderAnimation = a
end

local function setBorderActive(a)
    local mf = Window.UIElements and Window.UIElements.Main; if not mf then return end
    local rs = mf:FindFirstChild("RainbowStroke")
    if a then
        if not rs then rs = createRainbowBorder(Window) end
        if rs then
            rs.Enabled = true
            if not rainbowBorderAnimation then startBorderAnimation(Window, animationSpeed) end
        end
    else
        if rs then rs.Enabled = false end
        if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect(); rainbowBorderAnimation = nil end
    end
end

local function applyBorderState()
    local mf = Window.UIElements and Window.UIElements.Main; if not mf then return end
    setBorderActive(mf.Visible and borderEnabled)
end

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- ========== 创建YG风格主窗口 ==========
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G</font> BloxFruits",
    Author = "YG团队",
    Icon = "https://chaton-images.s3.us-east-2.amazonaws.com/qjWYa4nk2uxfW8NYoz5bgluvARZS4nkjdejCvuKdKIwVOnRPNBCwwaMz9XBsn5jd_2048x2048x4017713.png",
    IconTransparency = 1,
    Folder = "YGBloxFruits",
    Size = UDim2.fromOffset(400, 600),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 120,
    HasOutline = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/8Wt7bZfoaK9brDb8dgju7fF8h3UwFAz9x9bLLHVKS1hmPkdfDTgubZ99sZG1I9O2_5120x3856x2331578.jpeg",
    BackgroundImageTransparency = 0.425,
})

Window:EditOpenButton({
    Title = "<font color='#FFB6C1'>Y</font><font color='#FFA0B5'>G</font>",
    CornerRadius = UDim.new(16,16),
    StrokeThickness = 2,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,188,217)),ColorSequenceKeypoint.new(0.3,Color3.fromRGB(255,153,204)),ColorSequenceKeypoint.new(0.6,Color3.fromRGB(255,105,180)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,192,203))}),
    Draggable = true,
})

spawn(function()
    local mf = Window.UIElements and Window.UIElements.Main
    if not mf then repeat wait(); mf = Window.UIElements and Window.UIElements.Main until mf end
    mf:GetPropertyChangedSignal("Visible"):Connect(applyBorderState)
    applyBorderState()
end)

-- ==================== 以下为原脚本功能代码（保留所有功能）====================
-- 核心服务
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

repeat task.wait() until Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

-- 自定义工具函数
local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- 移动常量：安全高度和分段步长
local SAFE_HEIGHT = 25
local MOVE_STEP = 20

-- ==================== 所有箱子坐标（完整68个）====================
local CHEST_POSITIONS = {
    CFrame.new(-1832.09204, 79.1240082, -3054.45605),
    CFrame.new(-1580.61804, 109.108002, -3333.73804),
    CFrame.new(-1439.12097, 79.9300079, -2955.59692),
    CFrame.new(1456.18701, 0.871994019, 4384.6792),
    CFrame.new(831.89801, 5.19099426, 4365.78516),
    CFrame.new(908.260986, 14.0420074, 4567.93799),
    CFrame.new(1239.99597, 14.4909973, 4525.86523),
    CFrame.new(60947.8398, 125.42601, 1213.14294),
    CFrame.new(61563.582, 251.425995, 1172.93005),
    CFrame.new(61671.6719, 163.283005, 1520.69299),
    CFrame.new(61506.8398, 207.082001, 979.012024),
    CFrame.new(5336.06982, 81.3240051, 4597.77197),
    CFrame.new(6295.42578, 42.0830078, 4001.83594),
    CFrame.new(6219.80908, 37.2539978, 4469.53418),
    CFrame.new(5667.39209, 578.120972, 4301.03076),
    CFrame.new(1202.24695, 44.0780029, -1252.60999),
    CFrame.new(1404.22595, 96.0050049, -1294.61694),
    CFrame.new(1381.35901, 87.0050049, -1399.12),
    CFrame.new(1409.10498, 54.0780029, -1272.40405),
    CFrame.new(-1177.26904, 10.6040039, 131.574997),
    CFrame.new(-1665.70703, 21.6040039, 329.9750060),
    CFrame.new(-1609.35901, 10.8040009, 146.104996),
    CFrame.new(-1128.86902, 39.2340088, -526.437012),
    CFrame.new(-5776.01807, 7.34399414, 8576.63184),
    CFrame.new(-5263.47412, 7.34399414, 8773.82129),
    CFrame.new(-5509.15088, 16.697998, 8693.6416),
    CFrame.new(-5514.16504, 61.553009, 8577.87207),
    CFrame.new(-5927.29297, 55.4060059, 8897.43457),
    CFrame.new(-4924.56104, 40.0050049, 4399.95312),
    CFrame.new(-4905.38623, 79.852005, 3873.1731),
    CFrame.new(-5141.94922, 239.404999, 4375.61377),
    CFrame.new(-4928.71777, 83.1380005, 4518.66699),
    CFrame.new(-2528.71704, 5.65400696, 1979.20203),
    CFrame.new(-3117.44702, 208.014008, 2048.06909),
    CFrame.new(-2956.06006, 39.7669983, 2025.41394),
    CFrame.new(-2834.12207, 6.31500244, 5484.58301),
    CFrame.new(-970.971985, 12.5050049, 3990.18701),
    CFrame.new(-1178.08301, 31.3150024, 4164.86182),
    CFrame.new(-1250.96399, 43.5050049, 3820.15991),
    CFrame.new(-1103.00195, 12.5039978, 3896.41895),
    CFrame.new(5261.78076, 6.54100037, 825.221008),
    CFrame.new(5243.021, 2.08399963, 627.47699),
    CFrame.new(5009.82617, 87.4049988, 739.771973),
    CFrame.new(5243.08496, 87.4190063, 742.737),
    CFrame.new(5429.479, 160.565994, 780.674988),
    CFrame.new(-4888.24707, 2.6519928, -2181.02393),
    CFrame.new(-5073.21484, 2.6519928, -2397.91602),
    CFrame.new(-4955.3208, 294.497009, -2900.99292),
    CFrame.new(-5274.14307, 387.404999, -2183.53198),
    CFrame.new(-4815.81299, 718.398987, -2666.21704),
    CFrame.new(-4631.36084, 848.585999, -1939.802),
    CFrame.new(-7925.55811, 5606.44482, -1668.927),
    CFrame.new(-8049.27979, 5643.78613, -1974.755),
    CFrame.new(-7761.54688, 5643.63477, -1881.95605),
    CFrame.new(-7747.87598, 5621.01514, -1746.03503),
    CFrame.new(-8004.93311, 5680.78613, -1959.94397),
    CFrame.new(-8037.43311, 5680.78613, -2016.23706),
    CFrame.new(-7995.58594, 5680.78613, -2005.75598),
    CFrame.new(-654.679993, 6.60499573, 1421.47595),
    CFrame.new(-1203.08105, 1.40499878, 1871.54602),
    CFrame.new(-387.940002, 1.40499878, 1648.08801),
    CFrame.new(-781.18103, 32.4049988, 1606.97498),
    CFrame.new(1147.20496, 18.4490051, 1260.28796),
    CFrame.new(958.301025, 14.9880066, 1339.74597)
}
-- ==================== 所有传送点坐标（快速传送使用，Y在原基础上再加20）====================
local TELEPORT_POSITIONS = {
    {name = "海贼岛", pos = CFrame.new(1172.34998, 10 + 20, 1539.53406)},
    {name = "水手岛", pos = CFrame.new(-2735.37402, 20.3320007 + 20, 1967.646)},
    {name = "竞技场", pos = CFrame.new(-1650.755, 56.6549988 + 20, -3169.92798)},
    {name = "沙漠岛", pos = CFrame.new(898.513, 6.39300537 + 20, 4364.10791)},
    {name = "喷泉岛", pos = CFrame.new(5713.72314, 283.834991 + 20, 4392.41113)},
    {name = "雪地岛", pos = CFrame.new(1398.59595, 83.7360077 + 20, -1345.65002)},
    {name = "丛林岛", pos = CFrame.new(-1368.65405, 62.2030029 + 20, -56.9450073)},
    {name = "岩浆岛", pos = CFrame.new(-5574.34814, 118.358002 + 20, 8670.28027)},
    {name = "海军基地", pos = CFrame.new(-4934.0708, 165.384995 + 20, 4324.09814)},
    {name = "海军起点", pos = CFrame.new(-2942.41992, -47.6650085 + 20, 2022.61804)},
    {name = "海盗", pos = CFrame.new(-1087.82104, 51.4420013 + 20, 4148.36816)},
    {name = "监狱", pos = CFrame.new(5272.05713, 69.6170044 + 20, 747.97699)},
    {name = "天空岛", pos = CFrame.new(-5017.71484, 362.227997 + 20, -2391.30811)},
    {name = "天空区域1", pos = CFrame.new(-4662.9458, 907.10498 + 20, -1777.54297)},
    {name = "天空区域2", pos = CFrame.new(-7827.42676, 5855.98486 + 20, -1454.60999)},
    {name = "巷子", pos = CFrame.new(-832.372009, 34.6650085 + 20, 1621.47705)},
    {name = "风车", pos = CFrame.new(1068.07996, 32.6750031 + 20, 1442.68103)},
}

-- ==================== 任务配置（完整版）====================
local TASK_CONFIG = {
    -- 初始强盗任务
    {name = "强盗任务1[海盗]", questName = "BanditQuest1", level = 1, reqLevel = 1, targetCount = 5, enemyName = "Bandit", npcPos = CFrame.new(1032.18701, 13.5559998, 1541.37402)},
    
    -- 海军训练任务（坐标已更新）
    {name = "训练任务[海军]", questName = "MarineQuest", level = 1, reqLevel = 1, targetCount = 5, enemyName = "Trainee", npcPos = CFrame.new(-2667.06006, 39.6869965, 2099.198)},
    
    -- 丛林系列任务
    {name = "猴子任务 [Lv.15]", questName = "JungleQuest", level = 1, reqLevel = 15, targetCount = 6, enemyName = "Monkey", npcPos = CFrame.new(-1623.31104, 34.4440002, 140.190994)},
    {name = "大猩猩任务 [Lv.15]", questName = "JungleQuest", level = 2, reqLevel = 15, targetCount = 4, enemyName = "Gorilla", npcPos = CFrame.new(-1623.31104, 34.4440002, 140.190994)},
    {name = "猩猩王任务 [Lv.20,Boss]", questName = "JungleQuest", level = 3, reqLevel = 20, targetCount = 1, enemyName = "Gorilla King", npcPos = CFrame.new(-1623.31104, 34.4440002, 140.190994)},
    
    -- 沙漠系列任务
    {name = "强盗任务2 [Lv.60]", questName = "DesertQuest", level = 1, reqLevel = 60, targetCount = 8, enemyName = "Desert Bandit", npcPos = CFrame.new(898.513, 6.39300537, 4364.10791)},
    {name = "军官任务 [Lv.75]", questName = "DesertQuest", level = 2, reqLevel = 75, targetCount = 6, enemyName = "Desert Officer", npcPos = CFrame.new(898.513, 6.39300537, 4364.10791)},
    
    -- 雪地系列任务 (SnowQuest)
    {name = "雪强盗 [Lv.90]", questName = "SnowQuest", level = 1, reqLevel = 90, targetCount = 7, enemyName = "Snow Bandit", npcPos = CFrame.new(1399.75305, 88.1000061, -1302.19202)},
    {name = "雪人任务 [Lv.100]", questName = "SnowQuest", level = 2, reqLevel = 100, targetCount = 8, enemyName = "Snowman", npcPos = CFrame.new(1399.75305, 88.1000061, -1302.19202)},
    {name = "雪怪 [Lv.105,Boss]", questName = "SnowQuest", level = 3, reqLevel = 105, targetCount = 1, enemyName = "Yeti", npcPos = CFrame.new(1399.75305, 88.1000061, -1302.19202)},
    
    -- 喷泉岛系列任务 (FountainQuest)
    {name = "海盗厨房 [Lv.625]", questName = "FountainQuest", level = 1, reqLevel = 625, targetCount = 8, enemyName = "Galley Pirate", npcPos = CFrame.new(5272.34424, 51.3650055, 4056.94409)},
    {name = "厨房船长 [Lv.650]", questName = "FountainQuest", level = 2, reqLevel = 650, targetCount = 9, enemyName = "Galley Captain", npcPos = CFrame.new(5272.34424, 51.3650055, 4056.94409)},
    {name = "生化人任务 [Lv.675,Boss]", questName = "FountainQuest", level = 3, reqLevel = 675, targetCount = 1, enemyName = "Cyborg", npcPos = CFrame.new(5272.34424, 51.3650055, 4056.94409)},
}

-- ==================== 加点配置 ====================
local STAT_OPTIONS = {
    {name = "Melee", value = "Melee"},
    {name = "Defense", value = "Defense"},
    {name = "Sword", value = "Sword"},
    {name = "Gun", value = "Gun"},
    {name = "Blox Fruit", value = "BloxFruit"},
}

-- ==================== 全局状态管理 ====================
getgenv().BloxFruits = getgenv().BloxFruits or {
    AutoClick = false,
    AutoClickThread = nil,
    AutoAim = false,
    AutoAimConnection = nil,
    Hitbox = false,
    HitboxThread = nil,
    HitboxSize = 5,
    FOVSize = 150,
    AutoFarm = false,
    AutoFarmThread = nil,

    AimbotSettings = {
        Smooth = false,
        Speed = 300,
        Distance = 1000,
        ShowFOV = false,
        CheckObstacles = false,
        FOVCircle = nil
    },

    -- 自动任务（支持多选）
    AutoQuest = false,
    AutoQuestThread = nil,
    SelectedTasks = {},           -- 存储选中的任务配置表（按选中顺序）
    CurrentTaskIdx = 1,           -- 当前正在执行的任务在 SelectedTasks 中的索引
    KillCount = 0,
    TargetKills = 6,
    QuestStatus = "空闲",
    QuestPhase = "idle",

    -- 自动加点（默认全选）
    AutoStat = false,
    AutoStatThread = nil,
    SelectedStats = {"Melee", "Defense", "Sword", "Gun", "BloxFruit"},

    AutoChest = false,
    ChestThread = nil,
    ChestIndex = 1,
    TotalChests = #CHEST_POSITIONS,

    AntiAfk = false,
    HideUI = false,
    TeleportPoints = TELEPORT_POSITIONS,

    -- 第一人称
    FirstPerson = false,
}

local STATE = getgenv().BloxFruits

-- ==================== 辅助函数 ====================
local function getCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChild("Humanoid")
end

-- 获取玩家等级（增强版）
local function getPlayerLevel()
    local success, level = pcall(function()
        local data = Player:FindFirstChild("Data")
        if data then
            local levelObj = data:FindFirstChild("Level")
            if levelObj then
                if levelObj:IsA("NumberValue") or levelObj:IsA("IntValue") then
                    return levelObj.Value
                else
                    return tonumber(levelObj.Value) or 0
                end
            end
        end
        local leaderstats = Player:FindFirstChild("leaderstats")
        if leaderstats then
            local lvl = leaderstats:FindFirstChild("Level") or leaderstats:FindFirstChild("level")
            if lvl then
                if lvl:IsA("NumberValue") or lvl:IsA("IntValue") then
                    return lvl.Value
                else
                    return tonumber(lvl.Value) or 0
                end
            end
        end
        return 0
    end)
    if success and type(level) == "number" then
        return level
    end
    return 0
end

-- 检查玩家是否死亡
local function isPlayerDead()
    local char = Player.Character
    if not char then return true end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return true end
    return false
end

-- 获取所有Bandit（用于自动刷怪）
local function getAllBandits()
    local bandits = {}
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name:lower():find("bandit") then
                local humanoid = enemy:FindFirstChild("Humanoid")
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp and humanoid.Health > 0 then
                    table.insert(bandits, enemy)
                end
            end
        end
    end
    return bandits
end

-- 从EnemySpawns获取指定名称的生物（增强版）
local function getEnemiesByName(enemyName)
    local enemies = {}
    local seen = {}

    local function addEnemy(instance)
        if seen[instance] then return end
        local humanoid = instance:FindFirstChild("Humanoid")
        local hrp = instance:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and humanoid.Health > 0 then
            local name = instance.Name
            local matched = false
            if enemyName == "Bandit" and name:find("Bandit") and not name:find("Desert") then
                matched = true
            elseif enemyName == "Trainee" and (name:find("Trainee") or name:find("Training")) then
                matched = true
            elseif enemyName == "Gorilla" and (name:find("Gorilla") and not name:find("King")) then
                matched = true
            elseif enemyName == "Gorilla King" and name:find("Gorilla King") then
                matched = true
            elseif enemyName == "Monkey" and name:find("Monkey") then
                matched = true
            elseif enemyName == "Desert Bandit" and (name:find("Desert") and name:find("Bandit")) then
                matched = true
            elseif enemyName == "Desert Officer" and (name:find("Desert") and name:find("Officer")) then
                matched = true
            elseif enemyName == "Snow Bandit" and (name:find("Snow") and name:find("Bandit")) then
                matched = true
            elseif enemyName == "Snowman" and name:find("Snowman") then
                matched = true
            elseif enemyName == "Yeti" and name:find("Yeti") then
                matched = true
            elseif enemyName == "Galley Pirate" and (name:find("Galley") and name:find("Pirate")) then
                matched = true
            elseif enemyName == "Galley Captain" and (name:find("Galley") and name:find("Captain")) then
                matched = true
            elseif enemyName == "Cyborg" and name:find("Cyborg") then
                matched = true
            end
            if matched then
                table.insert(enemies, instance)
                seen[instance] = true
            end
        end
    end

    local spawns = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("EnemySpawns")
    if spawns then
        for _, spawn in ipairs(spawns:GetChildren()) do
            if spawn:IsA("Model") then
                addEnemy(spawn)
            end
        end
    end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") then
                addEnemy(enemy)
            end
        end
    end

    return enemies
end

-- 随机选择一个活着的目标
local function getRandomEnemy(enemyName)
    local enemies = getEnemiesByName(enemyName)
    if #enemies == 0 then return nil end
    return enemies[math.random(1, #enemies)]
end

-- 接任务
local function startQuest(questName, level)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            remote = remote:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("StartQuest", questName, level)
            end
        end
    end)
end

-- 完成任务
local function completeQuest(questName)
    local success, result = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            remote = remote:FindFirstChild("CommF_")
            if remote then
                return remote:InvokeServer("CompleteQuest", questName)
            end
        end
        return nil
    end)
    if success then
        return result
    end
    return nil
end

-- 加点
local function addStatPoint(statType)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            remote = remote:FindFirstChild("CommF_")
            if remote then
                remote:InvokeServer("AddPoint", statType, 1)
            end
        end
    end)
end

local function equipFist()
    pcall(function()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            local fist = backpack:FindFirstChild("Combat") or backpack:FindFirstChild("Fist") or backpack:FindFirstChild("Punch")
            if fist then
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid:EquipTool(fist)
                end
            end
        end
    end)
end

-- ==================== 穿墙控制 ====================
local function setNoclip(state)
    local char = getCharacter()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end==================== 第一人称/第三人称切换 ====================
local function toggleFirstPerson(state)
    STATE.FirstPerson = state
    pcall(function()
        if state then
            Camera.CameraType = Enum.CameraType.Fixed
        else
            Camera.CameraType = Enum.CameraType.Custom
            local humanoid = getHumanoid()
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end)
    WindUI:Notify({Title = "视角切换", Content = state and "第一人称" or "第三人称", Duration = 1.5})
end

-- ==================== FOV圈 ====================
local fovCircle = nil

local function createFOVCircle()
    if fovCircle then pcall(function() fovCircle:Destroy() end) end
    
    local guiParent = CoreGui or Player:FindFirstChild("PlayerGui")
    if not guiParent then return end
    
    fovCircle = Instance.new("ScreenGui")
    fovCircle.Name = "BloxFruitsFOV"
    fovCircle.Parent = guiParent
    fovCircle.IgnoreGuiInset = true
    fovCircle.DisplayOrder = 999999
    fovCircle.Enabled = STATE.AimbotSettings.ShowFOV
    fovCircle.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Name = "FOVFrame"
    frame.Size = UDim2.new(0, STATE.FOVSize * 2, 0, STATE.FOVSize * 2)
    frame.Position = UDim2.new(0.5, -STATE.FOVSize, 0.5, -STATE.FOVSize)
    frame.BackgroundTransparency = 1
    frame.Parent = fovCircle
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Transparency = 0.3
    stroke.Parent = frame
    
    task.spawn(function()
        while fovCircle and fovCircle.Parent and STATE.AimbotSettings.ShowFOV do
            pcall(function()
                if fovCircle and fovCircle:FindFirstChild("FOVFrame") then
                    local frame = fovCircle.FOVFrame
                    local target, _ = getTargetInFOV()
                    frame.UIStroke.Color = target and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function updateFOVCircle()
    if fovCircle and fovCircle:FindFirstChild("FOVFrame") then
        local frame = fovCircle.FOVFrame
        local diameter = STATE.FOVSize * 2
        frame.Size = UDim2.new(0, diameter, 0, diameter)
        frame.Position = UDim2.new(0.5, -STATE.FOVSize, 0.5, -STATE.FOVSize)
    end
end

local function toggleFOVCircle(state)
    STATE.AimbotSettings.ShowFOV = state
    if state then
        if not fovCircle or not fovCircle.Parent then createFOVCircle() else fovCircle.Enabled = true end
    elseif fovCircle then
        fovCircle.Enabled = false
    end
end

-- ==================== 自动瞄准 ====================
local function getTargetInFOV()
    local hrp = getRootPart()
    if not hrp or not Camera then return nil, nil end
    
    local fovRadius = STATE.FOVSize
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestTarget = nil
    local targetPos = nil
    local closestScreenDist = fovRadius
    
    -- 检测其他玩家
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local distance = (targetPart.Position - hrp.Position).Magnitude
                if distance <= STATE.AimbotSettings.Distance then
                    local targetPos2D, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and targetPos2D.Z > 0 then
                        local screenPos = Vector2.new(targetPos2D.X, targetPos2D.Y)
                        local distFromCenter = (screenCenter - screenPos).Magnitude
                        
                        if distFromCenter <= fovRadius then
                            if STATE.AimbotSettings.CheckObstacles then
                                local cameraPos = Camera.CFrame.Position
                                local direction = (targetPart.Position - cameraPos).Unit
                                local distance = (targetPart.Position - cameraPos).Magnitude
                                
                                local raycastParams = RaycastParams.new()
                                raycastParams.FilterDescendantsInstances = {Player.Character, Camera}
                                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                
                                local result = Workspace:Raycast(cameraPos, direction * distance, raycastParams)
                                if result then continue end
                            end
                            
                            if distFromCenter < closestScreenDist then
                                closestScreenDist = distFromCenter
                                closestTarget = player
                                targetPos = targetPart.Position
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- 检测敌人（怪物）
    for _, enemy in ipairs(getAllEnemies()) do
        local targetPart = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChild("Humanoid")
        if targetPart and humanoid and humanoid.Health > 0 then
            local distance = (targetPart.Position - hrp.Position).Magnitude
            if distance <= STATE.AimbotSettings.Distance then
                local targetPos2D, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen and targetPos2D.Z > 0 then
                    local screenPos = Vector2.new(targetPos2D.X, targetPos2D.Y)
                    local distFromCenter = (screenCenter - screenPos).Magnitude
                    
                    if distFromCenter <= fovRadius then
                        if STATE.AimbotSettings.CheckObstacles then
                            local cameraPos = Camera.CFrame.Position
                            local direction = (targetPart.Position - cameraPos).Unit
                            local distance = (targetPart.Position - cameraPos).Magnitude
                            
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {Player.Character, Camera}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            
                            local result = Workspace:Raycast(cameraPos, direction * distance, raycastParams)
                            if result then continue end
                        end
                        
                        if distFromCenter < closestScreenDist then
                            closestScreenDist = distFromCenter
                            closestTarget = enemy
                            targetPos = targetPart.Position
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget, targetPos
end

-- 获取所有敌人（用于其他功能）
local function getAllEnemies()
    local enemies = {}
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                local humanoid = enemy:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    table.insert(enemies, enemy)
                end
            end
        end
    end
    return enemies
end

local function aimAtTarget()
    if not STATE.AutoAim or not Camera then return end
    local target, targetPos = getTargetInFOV()
    if target and targetPos then
        pcall(function()
            local cameraPos = Camera.CFrame.Position
            local targetCFrame = CFrame.lookAt(cameraPos, targetPos)
            
            if STATE.AimbotSettings.Smooth then
                local lerpSpeed = clamp(STATE.AimbotSettings.Speed / 500 * 0.2, 0.02, 0.2)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, lerpSpeed)
            else
                Camera.CFrame = targetCFrame
            end
        end)
    end
end

local function toggleAutoAim(state)
    STATE.AutoAim = state
    if state then
        if STATE.AutoAimConnection then STATE.AutoAimConnection:Disconnect() end
        STATE.AutoAimConnection = RunService.RenderStepped:Connect(aimAtTarget)
        WindUI:Notify({Title = "自动瞄准", Content = "已开启", Duration = 1.5})
    else
        if STATE.AutoAimConnection then STATE.AutoAimConnection:Disconnect() STATE.AutoAimConnection = nil end
        WindUI:Notify({Title = "自动瞄准", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 自动攻击 ====================
local function performClick()
    local s = Camera.ViewportSize
    VirtualInputManager:SendMouseButtonEvent(s.X-50, s.Y/2+50, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(s.X-50, s.Y/2+50, 0, false, game, 0)
end

local function autoClickLoop()
    while STATE.AutoClick do
        pcall(function() equipFist() performClick() end)
        task.wait(0.2)
    end
end

local function toggleAutoClick(state)
    STATE.AutoClick = state
    if state then
        if STATE.AutoClickThread then task.cancel(STATE.AutoClickThread) end
        STATE.AutoClickThread = task.spawn(autoClickLoop)
        WindUI:Notify({Title = "自动攻击", Content = "已开启", Duration = 1.5})
    else
        if STATE.AutoClickThread then task.cancel(STATE.AutoClickThread) STATE.AutoClickThread = nil end
        WindUI:Notify({Title = "自动攻击", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 分段式传送（到达后精确落点，增加稳定等待）====================
local moveThread, targetPosition, isMoving = nil, nil, false

local function stopMoving()
    if moveThread then
        task.cancel(moveThread)
        moveThread = nil
    end
    targetPosition = nil
    isMoving = false
    setNoclip(false)
end

local function startMoving(targetCF, stopDistance, showNotify)
    stopDistance = stopDistance or 0
    stopMoving()
    targetPosition = targetCF
    isMoving = true
    setNoclip(true)
    
    if showNotify then
        WindUI:Notify({
            Title = "自动任务",
            Content = "请等待…",
            Duration = 1.5
        })
    end
    
    moveThread = task.spawn(function()
        while isMoving and targetPosition do
            pcall(function()
                local hrp = getRootPart()
                if not hrp then
                    task.wait(0.2)
                    return
                end
                
                setNoclip(true)
                
                local currentPos = hrp.Position
                local targetPos = targetPosition.Position
                local distance = (currentPos - targetPos).Magnitude
                
                if distance <= stopDistance + 0.5 then
                    -- 精确传送到目标点上方3格，确保落地稳定
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    isMoving = false
                    return
                end
                
                local dir = (targetPos - currentPos).Unit
                local moveDist = math.min(MOVE_STEP, distance - stopDistance)
                local newPos = currentPos + dir * moveDist
                -- 强制Y坐标为目标Y（保持在固定高度飞行，避免掉入海里）
                newPos = Vector3.new(newPos.X, targetPos.Y, newPos.Z)
                hrp.CFrame = CFrame.new(newPos)
            end)
            task.wait(0.05)
        end
        moveThread = nil
        setNoclip(false)
    end)
end

-- ==================== 自动刷怪 ====================
local function autoFarmLoop()
    while STATE.AutoFarm do
        pcall(function()
            local bandits = getAllBandits()
            if #bandits > 0 then
                local hrp = getRootPart()
                if not hrp then return end
                local closest, minDist = nil, 9e9
                for _, b in ipairs(bandits) do
                    local h = b:FindFirstChild("HumanoidRootPart")-- 
                    if h then
                        local d = (hrp.Position - h.Position).Magnitude
                        if d < minDist then minDist = d closest = b end
                    end
                end
                if closest then
                    local h = closest:FindFirstChild("HumanoidRootPart")
                    if minDist > 5 then 
                        startMoving(h.CFrame * CFrame.new(0,2,0), 3, false)
                    else
                        stopMoving() 
                        equipFist() 
                        performClick()
                    end
                end
            else 
                task.wait(0.5)
            end
        end)
        task.wait(0.1)
    end
    stopMoving()
end

local function toggleAutoFarm(state)
    STATE.AutoFarm = state
    if state then
        if STATE.AutoFarmThread then task.cancel(STATE.AutoFarmThread) end
        STATE.AutoFarmThread = task.spawn(autoFarmLoop)
        WindUI:Notify({Title = "自动刷怪", Content = "已开启", Duration = 1.5})
    else
        if STATE.AutoFarmThread then task.cancel(STATE.AutoFarmThread) STATE.AutoFarmThread = nil end
        stopMoving()
        WindUI:Notify({Title = "自动刷怪", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== Hitbox ====================
local function hitboxLoop()
    while STATE.Hitbox do
        pcall(function()
            local s = STATE.HitboxSize
            for _, e in ipairs(getAllEnemies()) do
                local h = e:FindFirstChild("HumanoidRootPart")
                if h then 
                    h.Size = Vector3.new(s,s,s) 
                    h.Transparency = 0.5 
                    h.BrickColor = BrickColor.Red 
                    h.Material = Enum.Material.Neon 
                end
            end
        end)
        task.wait(0.5)
    end
end

local function toggleHitbox(state)
    STATE.Hitbox = state
    if state then
        if STATE.HitboxThread then task.cancel(STATE.HitboxThread) end
        STATE.HitboxThread = task.spawn(hitboxLoop)
        WindUI:Notify({Title = "Hitbox", Content = "已开启", Duration = 1.5})
    else
        if STATE.HitboxThread then task.cancel(STATE.HitboxThread) STATE.HitboxThread = nil end
        pcall(function() 
            for _,e in ipairs(getAllEnemies()) do 
                local h=e:FindFirstChild("HumanoidRootPart") 
                if h then 
                    h.Size=Vector3.new(2,2,1) 
                    h.Transparency=1 
                end 
            end 
        end)
        WindUI:Notify({Title = "Hitbox", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 自动加点 ====================
local function autoStatLoop()
    local lastLevel = getPlayerLevel()
    local noPointsCount = 0
    
    while STATE.AutoStat do
        pcall(function()
            local currentLevel = getPlayerLevel()
            
            if currentLevel > lastLevel then
                lastLevel = currentLevel
                noPointsCount = 0
            end
            
            for _, statType in ipairs(STATE.SelectedStats) do
                addStatPoint(statType)
                task.wait(0.1)
            end
            
            if currentLevel == lastLevel then
                noPointsCount = noPointsCount + 1
            else
                noPointsCount = 0
            end
            
            if noPointsCount >= 10 then
                STATE.QuestStatus = "等待等级提升获取属性点"
                task.wait(2)
                noPointsCount = 0
            else
                task.wait(0.5)
            end
        end)
    end
end

local function toggleAutoStat(state)
    STATE.AutoStat = state
    if state then
        if STATE.AutoStatThread then task.cancel(STATE.AutoStatThread) end
        STATE.AutoStatThread = task.spawn(autoStatLoop)
        WindUI:Notify({Title = "自动加点", Content = "已开启", Duration = 1.5})
    else
        if STATE.AutoStatThread then task.cancel(STATE.AutoStatThread) STATE.AutoStatThread = nil end
        WindUI:Notify({Title = "自动加点", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 自动任务（无移动超时，到达后稳定等待，确保任务接取成功）====================
local function autoQuestLoop()
    while STATE.AutoQuest do
        local success, err = pcall(function()
            if #STATE.SelectedTasks == 0 then
                STATE.QuestStatus = "请至少选择一个任务"
                task.wait(2)
                return
            end
            
            -- 确保当前索引有效
            if STATE.CurrentTaskIdx > #STATE.SelectedTasks then
                STATE.CurrentTaskIdx = 1
            end
            
            local config = STATE.SelectedTasks[STATE.CurrentTaskIdx]
            
            -- 检查死亡
            if isPlayerDead() then
                STATE.QuestStatus = "玩家死亡，任务回退"
                -- 回退到上一个任务（如果存在）
                if STATE.CurrentTaskIdx > 1 then
                    STATE.CurrentTaskIdx = STATE.CurrentTaskIdx - 1
                end
                task.wait(3)
                return
            end
            
            -- 检查等级是否足够
            local playerLevel = getPlayerLevel()
            if playerLevel < config.reqLevel then
                STATE.QuestStatus = "等级不足，跳过: " .. config.name
                WindUI:Notify({Title="自动任务", Content="等级不足，跳过 " .. config.name, Duration=2})
                -- 跳过当前任务，指向下一个
                STATE.CurrentTaskIdx = STATE.CurrentTaskIdx + 1
                if STATE.CurrentTaskIdx > #STATE.SelectedTasks then
                    STATE.CurrentTaskIdx = 1
                end
                task.wait(1)
                return
            end
            
            STATE.TargetKills = config.targetCount
            
            -- 阶段1: 移动到任务点（无超时，一直移动到接近为止）
            STATE.QuestStatus = "前往接任务: " .. config.name
            STATE.QuestPhase = "moving_to_npc"
            startMoving(config.npcPos, 5, true)
            
            while isMoving do
                task.wait(0.1)
                if not STATE.AutoQuest then stopMoving(); return end
                if isPlayerDead() then stopMoving(); return end
            end
            
            -- 移动完成后，等待0.5秒让角色稳定落地
            task.wait(0.5)
            
            if not STATE.AutoQuest then return end
            
            -- 阶段2: 接任务
            STATE.QuestPhase = "talking_to_npc"
            STATE.QuestStatus = "接取任务: " .. config.name
            startQuest(config.questName, config.level)
            
            -- 等待任务数据更新
            task.wait(0.5)
            
            -- 阶段3: 击杀目标
            STATE.QuestPhase = "killing"
            STATE.KillCount = 0
            STATE.QuestStatus = "击杀: 0/" .. config.targetCount
            
            while STATE.AutoQuest and STATE.QuestPhase == "killing" and STATE.KillCount < config.targetCount do
                if isPlayerDead() then return end
                
                local target = getRandomEnemy(config.enemyName)
                if target then
                    local targetHRP = target:FindFirstChild("HumanoidRootPart")
                    local targetHumanoid = target:FindFirstChild("Humanoid")
                    
                    if targetHRP and targetHumanoid then
                        STATE.QuestStatus = "攻击 " .. config.name .. " (" .. (STATE.KillCount+1) .. "/" .. config.targetCount .. ")"
                        local attackStart = tick()
                        
                        while STATE.AutoQuest do
                            if isPlayerDead() then return end
                            
                            if not target.Parent or not targetHumanoid or targetHumanoid.Health <= 0 then
                                STATE.KillCount = STATE.KillCount + 1
                                STATE.QuestStatus = "击杀: " .. STATE.KillCount .. "/" .. config.targetCount
                                WindUI:Notify({
                                    Title = "击杀",
                                    Content = "已击杀 (" .. STATE.KillCount .. "/" .. config.targetCount .. ")",
                                    Duration = 1.5
                                })
                                break
                            end
                            
                            local hrp = getRootPart()
                            if hrp and targetHRP then
                                local distance = (hrp.Position - targetHRP.Position).Magnitude
                                if distance > 5 then
                                    local dir = (targetHRP.Position - hrp.Position).Unit
                                    local moveDist = math.min(20, distance - 3)
                                    hrp.CFrame = CFrame.new(hrp.Position + dir * moveDist)
                                else
                                    equipFist()
                                    performClick()
                                end
                            end
                            
                            if tick() - attackStart > 15 then break end
                            task.wait(0.2)
                        end
                    end
                else
                    STATE.QuestStatus = "等待" .. config.name .. "刷新"
                    WindUI:Notify({
                        Title = "自动任务",
                        Content = "等待" .. config.name .. "刷新",
                        Duration = 2
                    })
                    task.wait(2)
                end
                task.wait(0.1)
            end
            
            -- 阶段4: 返回提交任务（无超时）
            STATE.QuestPhase = "moving_to_submit"
            STATE.QuestStatus = "前往交任务"
            startMoving(config.npcPos, 5, false)
            
            while isMoving do
                task.wait(0.1)
                if not STATE.AutoQuest then stopMoving(); return end
                if isPlayerDead() then stopMoving(); return end
            end
            
            -- 到达后等待0.5秒
            task.wait(0.5)
            
            STATE.QuestStatus = "提交任务中..."
            local submitSuccess = false
            for retry = 1, 3 do
                local result = completeQuest(config.questName)
                if result then
                    submitSuccess = true
                    break
                else
                    STATE.QuestStatus = "提交失败，重试 " .. retry .. "/3"
                    task.wait(0.5)
                end
            end
            
            if submitSuccess then
                STATE.QuestStatus = "任务提交成功"
            else
                STATE.QuestStatus = "提交失败，跳过本轮"
            end
            
            -- 切换到下一个选中的任务
            STATE.CurrentTaskIdx = STATE.CurrentTaskIdx + 1
            if STATE.CurrentTaskIdx > #STATE.SelectedTasks then
                STATE.CurrentTaskIdx = 1
            end
            
            STATE.KillCount = 0
            STATE.QuestPhase = "idle"
            STATE.QuestStatus = "任务完成，准备下一轮"
            task.wait(0.5)
        end)
        
        if not success then
            STATE.QuestStatus = "任务错误: " .. tostring(err)
            task.wait(2)
        end
        
        task.wait(0.1)
    end
    
    stopMoving()
    STATE.QuestPhase = "idle"
    STATE.QuestStatus = "空闲"
    STATE.KillCount = 0
end

local function toggleAutoQuest(state)
    STATE.AutoQuest = state
    if state then
        if #STATE.SelectedTasks == 0 then
            -- 默认选中所有任务
            STATE.SelectedTasks = {}
            for _, config in ipairs(TASK_CONFIG) do
                table.insert(STATE.SelectedTasks, config)
            end
            STATE.CurrentTaskIdx = 1
        end
        STATE.QuestPhase = "idle"
        STATE.KillCount = 0if STATE.AutoQuestThread then task.cancel(STATE.AutoQuestThread) end
        STATE.AutoQuestThread = task.spawn(autoQuestLoop)
        WindUI:Notify({Title = "自动任务", Content = "已开启", Duration = 1.5})
    else
        if STATE.AutoQuestThread then task.cancel(STATE.AutoQuestThread) STATE.AutoQuestThread = nil end
        stopMoving()
        STATE.QuestPhase = "idle"
        STATE.QuestStatus = "空闲"
        WindUI:Notify({Title = "自动任务", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 自动开箱 ====================
local function autoChestLoop()
    while STATE.AutoChest do
        pcall(function()
            local i = STATE.ChestIndex
            if i <= #CHEST_POSITIONS then
                local hrp = getRootPart()
                if hrp then 
                    hrp.CFrame = CHEST_POSITIONS[i] + Vector3.new(0,2,0)
                end
                STATE.ChestIndex = i + 1
            else
                STATE.ChestIndex = 1
            end
        end)
        task.wait(0.2)
    end
end

local function toggleAutoChest(state)
    STATE.AutoChest = state
    if state then
        STATE.ChestIndex = 1
        if STATE.ChestThread then task.cancel(STATE.ChestThread) end
        STATE.ChestThread = task.spawn(autoChestLoop)
        WindUI:Notify({Title = "自动开箱", Content = "已开启", Duration = 1.5})
    else
        if STATE.ChestThread then task.cancel(STATE.ChestThread) STATE.ChestThread = nil end
        WindUI:Notify({Title = "自动开箱", Content = "已关闭", Duration = 1.5})
    end
end

-- ==================== 快速传送 ====================
local function teleportToLocationSmooth(location)
    local hrp = getRootPart()
    if hrp then
        startMoving(location.pos, 3, true)
        WindUI:Notify({Title = "传送", Content = "正在前往: " .. location.name, Duration = 2})
    end
end

-- ==================== 反挂机 ====================
local function setupAntiAfk()
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end

-- ==================== 隐藏UI（增强版）====================
local function toggleHideUI(state)
    STATE.HideUI = state
    pcall(function()
        local main = Player.PlayerGui:FindFirstChild("Main")
        if main then main.Enabled = not state end
        
        local guis = {"MobileMouselock", "Topbar", "TouchGui", "MobileContextButtons"}
        for _, guiName in ipairs(guis) do
            local gui = Player.PlayerGui:FindFirstChild(guiName)
            if gui and gui:IsA("ScreenGui") then
                gui.Enabled = not state
            end
        end
    end)
    WindUI:Notify({Title = "隐藏UI", Content = state and "已开启" or "已关闭", Duration = 1.5})
end

-- ==================== 切换服务器 ====================
local function switchServer()
    pcall(function() TeleportService:Teleport(game.PlaceId) end)
end

-- ==================== 创建选项卡（YG风格）====================

-- UI设置选项卡（彩虹边框）
local SettingsTab = Window:Tab({ Title = "UI设置", Icon = "crown" })
SettingsTab:Toggle({ Title = "启用边框", Value = borderEnabled, Callback = function(v) borderEnabled = v; applyBorderState(); WindUI:Notify({ Title="YG | 边框", Content=v and "已开启" or "已关闭", Duration=2 }) end })
SettingsTab:Dropdown({ Title = "边框配色", Values = colorSchemeNames, Value = "Sakura Mist", Callback = function(v) currentBorderColorScheme = v; local mf = Window.UIElements and Window.UIElements.Main; if mf then local rs = mf:FindFirstChild("RainbowStroke"); if rs then local ge = rs:FindFirstChild("GlowEffect"); if ge and COLOR_SCHEMES[v] then ge.Color = COLOR_SCHEMES[v][1] end end end end })
SettingsTab:Slider({ Title = "边框速度", Value = { Min=1, Max=10, Default=6 }, Callback = function(v) animationSpeed = v; if rainbowBorderAnimation then rainbowBorderAnimation:Disconnect(); rainbowBorderAnimation = nil end; local mf = Window.UIElements and Window.UIElements.Main; if mf and mf.Visible and borderEnabled then local rs = mf:FindFirstChild("RainbowStroke"); if rs and rs.Enabled then startBorderAnimation(Window, animationSpeed) end end end })
SettingsTab:Slider({ Title = "边框粗细", Value = { Min=1, Max=5, Default=2.65, Step=0.5 }, Callback = function(v) local mf = Window.UIElements and Window.UIElements.Main; if mf then local rs = mf:FindFirstChild("RainbowStroke"); if rs then rs.Thickness = v end end end })
SettingsTab:Slider({ Title = "圆角大小", Value = { Min=0, Max=20, Default=17 }, Callback = function(v) local mf = Window.UIElements and Window.UIElements.Main; if mf then local cr = mf:FindFirstChildOfClass("UICorner"); if not cr then cr = Instance.new("UICorner"); cr.Parent = mf end; cr.CornerRadius = UDim.new(0, v) end end })
SettingsTab:Button({ Title = "随机颜色", Icon = "palette", Callback = function() local rand = colorSchemeNames[math.random(#colorSchemeNames)]; currentBorderColorScheme = rand; local mf = Window.UIElements and Window.UIElements.Main; if mf then local rs = mf:FindFirstChild("RainbowStroke"); if rs then local ge = rs:FindFirstChild("GlowEffect"); if ge and COLOR_SCHEMES[rand] then ge.Color = COLOR_SCHEMES[rand][1] end end end; WindUI:Notify({ Title="YG | 随机颜色", Content="已切换为: "..rand, Duration=2 }) end })

-- 战斗选项卡
local CombatTab = Window:Tab({ Title = "战斗", Icon = "sword" })
CombatTab:Section({ Title = "战斗辅助", Opened = true })
CombatTab:Toggle({ Title = "自动攻击", Icon = "zap", Value = STATE.AutoClick, Callback = toggleAutoClick })
CombatTab:Toggle({ Title = "自动刷怪", Icon = "target", Value = STATE.AutoFarm, Callback = toggleAutoFarm })
CombatTab:Divider()
CombatTab:Toggle({ Title = "自动瞄准", Icon = "target", Value = STATE.AutoAim, Callback = toggleAutoAim })
CombatTab:Toggle({ Title = "掩体判断", Icon = "shield", Value = STATE.AimbotSettings.CheckObstacles, Callback = function(s) STATE.AimbotSettings.CheckObstacles = s end })
CombatTab:Divider()
CombatTab:Toggle({ Title = "显示FOV圈", Icon = "eye", Value = STATE.AimbotSettings.ShowFOV, Callback = toggleFOVCircle })
CombatTab:Slider({ Title = "FOV大小", Value = { Min=30, Max=500, Default=STATE.FOVSize, Step=5 }, Callback = function(v) STATE.FOVSize = v updateFOVCircle() end })
CombatTab:Divider()
CombatTab:Toggle({ Title = "平滑自瞄", Icon = "activity", Value = STATE.AimbotSettings.Smooth, Callback = function(s) STATE.AimbotSettings.Smooth = s end })
CombatTab:Slider({ Title = "自瞄速度", Value = { Min=100, Max=500, Default=STATE.AimbotSettings.Speed, Step=10 }, Callback = function(v) STATE.AimbotSettings.Speed = v end })
CombatTab:Slider({ Title = "自瞄距离", Value = { Min=100, Max=5000, Default=STATE.AimbotSettings.Distance, Step=100 }, Callback = function(v) STATE.AimbotSettings.Distance = v end })
CombatTab:Divider()
CombatTab:Toggle({ Title = "启用Hitbox", Icon = "maximize", Value = STATE.Hitbox, Callback = toggleHitbox })
CombatTab:Slider({ Title = "Hitbox大小", Value = { Min=1, Max=20, Default=STATE.HitboxSize, Step=1 }, Callback = function(v) STATE.HitboxSize = v end })

-- 挂机选项卡
local taskNames = {}
for _, config in ipairs(TASK_CONFIG) do
    table.insert(taskNames, config.name)
end
local defaultSelectedNames = {}
for _, name in ipairs(taskNames) do
    table.insert(defaultSelectedNames, name)
end

local QuestTab = Window:Tab({ Title = "挂机", Icon = "scroll" })
QuestTab:Section({ Title = "任务设置", Opened = true })
QuestTab:Dropdown({
    Title = "选择任务",
    Values = taskNames,
    Value = defaultSelectedNames,
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        local selectedTasks = {}
        for _, name in ipairs(selected) do
            for _, config in ipairs(TASK_CONFIG) do
                if config.name == name then
                    table.insert(selectedTasks, config)
                    break
            end
        end
        STATE.SelectedTasks = selectedTasks
        STATE.CurrentTaskIdx = 1
        WindUI:Notify({ Title="任务选择", Content="已选择 " .. #selectedTasks .. " 个任务", Duration=1.5 })
    end
})
QuestTab:Divider()
QuestTab:Section({ Title = "任务控制", Opened = true })
QuestTab:Toggle({ Title = "自动任务", Icon = "scroll", Value = STATE.AutoQuest, Callback = toggleAutoQuest })
local questStatusPara = QuestTab:Paragraph({ Title = "当前状态", Desc = STATE.QuestStatus, Image = "activity", ImageSize = 20 })

QuestTab:Divider()
QuestTab:Section({ Title = "自动加点", Opened = true })
QuestTab:Toggle({ Title = "自动加点", Icon = "trending-up", Value = STATE.AutoStat, Callback = toggleAutoStat })

local statNames = {}
for _, opt in ipairs(STAT_OPTIONS) do
    table.insert(statNames, opt.name)
end
QuestTab:Dropdown({
    Title = "加点方向",
    Values = statNames,
    Value = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"},
    Multi = true,
    AllowNone = false,
    Callback = function(selected)
        local selectedValues = {}
        for _, name in ipairs(selected) do
            for _, opt in ipairs(STAT_OPTIONS) do
                if opt.name == name then
                    table.insert(selectedValues, opt.value)
                    break
                end
            end
        end
        STATE.SelectedStats = selectedValues
        WindUI:Notify({ Title="加点方向", Content="已更新", Duration=1.5 })
    end
})

-- 传送选项卡
local TeleportTab = Window:Tab({ Title = "传送", Icon = "map-pin" })
TeleportTab:Section({ Title = "一键开箱", Opened = true })
TeleportTab:Toggle({ Title = "自动开箱", Icon = "package-open", Value = STATE.AutoChest, Callback = toggleAutoChest })
TeleportTab:Divider()
TeleportTab:Section({ Title = "快速传送", Opened = true })
for _, p in ipairs(STATE.TeleportPoints) do
    TeleportTab:Button({ Title = p.name, Icon = "map-pin", Callback = function()
        teleportToLocationSmooth(p)
    end })
end

-- 其他选项卡
local MiscTab = Window:Tab({ Title = "其他", Icon = "settings" })
MiscTab:Section({ Title = "INF数据(客户端)", Opened = true })
MiscTab:Button({ Title = "玩家满级", Icon = "trending-up", Callback = function()
    pcall(function()
        local data = Player:FindFirstChild("Data")
        if data then
            local level = data:FindFirstChild("Level")
            if level then level.Value = 2800 end
        end
    end)
    WindUI:Notify({ Title="玩家满级", Content="已修改为 2800", Duration=2 })
end })
MiscTab:Button({ Title = "拳头满级", Icon = "zap", Callback = function()
    pcall(function()
        local combat = Player.Backpack:FindFirstChild("Combat")
        if combat then
            local level = combat:FindFirstChild("Level")
            if level then level.Value = 600 end
        end
    end)
    WindUI:Notify({ Title="拳头满级", Content="已修改为 600", Duration=2 })
end })
MiscTab:Divider()
MiscTab:Section({ Title = "通用设置", Opened = true })
MiscTab:Toggle({ Title = "反挂机", Icon = "clock", Value = STATE.AntiAfk, Callback = function(s)
    STATE.AntiAfk = s
    if s then setupAntiAfk() end
    WindUI:Notify({ Title="反挂机", Content=s and "已开启" or "已关闭", Duration=1.5 })
end })
MiscTab:Divider()
MiscTab:Toggle({ Title = "隐藏UI", Icon = "eye", Value = STATE.HideUI, Callback = toggleHideUI })
MiscTab:Divider()
MiscTab:Toggle({ Title = "第一人称", Icon = "camera", Value = STATE.FirstPerson, Callback = toggleFirstPerson })
MiscTab:Divider()
MiscTab:Button({ Title = "偷取果实能力", Icon = "package", Callback = function()
    pcall(function()
        local localBackpack = Player:FindFirstChild("Backpack")
        if not localBackpack then return end
        local stolen = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local backpack = plr:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            local name = tool.Name:lower()
                            if name:match("^(%w+)%s+%1$") or name:match("^(%w+)%-%1$") then
                                tool:Clone().Parent = localBackpack
                                stolen = stolen + 1
                            end
                        end
                    end
                end
            end
        end
        WindUI:Notify({ Title="偷取果实", Content="成功偷取 " .. stolen .. " 个", Duration=3 })
    end)
end })
MiscTab:Divider()
MiscTab:Button({ Title = "切换服务器", Icon = "refresh", Callback = switchServer })

-- 关于选项卡
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })
AboutTab:Paragraph({
    Title = "YG BloxFruits",
    Desc = "版本: 1.1.0\n作者: YG团队",
    Image = "award",
    ImageSize = 32,
    Color = "Orange"
})

-- ==================== 实时更新线程 ====================
task.spawn(function()
    while true do
        pcall(function()
            if questStatusPara then
                questStatusPara:SetDesc(STATE.QuestStatus)
            end
        end)
        task.wait(0.1)
    end
end)

-- ==================== 初始化 ====================
createFOVCircle()
setupAntiAfk()

if STATE.AutoAim then toggleAutoAim(true) end
if STATE.AutoClick then toggleAutoClick(true) end
if STATE.AutoFarm then toggleAutoFarm(true) end
if STATE.Hitbox then toggleHitbox(true) end
if STATE.AutoQuest then toggleAutoQuest(true) end
if STATE.AutoChest then toggleAutoChest(true) end
if STATE.AutoStat then toggleAutoStat(true) end
if STATE.HideUI then toggleHideUI(true) end
if STATE.FirstPerson then toggleFirstPerson(true) end

Window:OnClose(function() end)

WindUI:Notify({
    Title = "剑杰 BloxFruits",
    Content = "加载成功",
    Duration = 3
})