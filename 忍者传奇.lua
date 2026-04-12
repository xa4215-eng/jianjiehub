cal redzlib = loadstring(game:HttpGet("https://pastefy.app/5PiSO8oW/raw"))()

local Window = redzlib:MakeWindow({
    Title = "剑杰 SCRIPT - 忍者传奇",
    SubTitle = "by 剑杰",
    SaveFolder = "NinjaLegendsYG"
})

-- 所有选项卡
local FarmingTab = Window:MakeTab({"自动刷取", "zap"})
local AutoBuyTab = Window:MakeTab({"自动购买", "shopping-cart"})
local PetsTab = Window:MakeTab({"宠物管理", "paw"})
local PetShopTab = Window:MakeTab({"元素", "fire"})
local TeleportsTab = Window:MakeTab({"传送", "map"})
local MiscTab = Window:MakeTab({"杂项", "tool"})
local MoneyTab = Window:MakeTab({"刷金币", "dollar-sign"})

-- 全局变量初始化
local player = game.Players.LocalPlayer
local isRunning = true
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 初始化所有开关变量
local Toggles = {
    AutoSwing = false,
    AutoSell = false,
    AutoFullSell = false,
    AutoCollect = false,
    AutoRobotBoss = false,
    AutoEternalBoss = false,
    AutoAncientBoss = false,
    AutoSantaBoss = false,
    AutoAllBosses = false,
    AutoRank = false,
    AutoSword = false,
    AutoBelt = false,
    AutoSkill = false,
    AutoShuriken = false,
    AutoOpenEgg = false,
    AutoEvolve = false,
    AutoBuyTwinBirdies = false,
    FastShuriken = false,
    SlowShuriken = false,
    Invisible = false,
    AntiAFK = true,
    AutoFarmMoney = false
}

-- 存储设置
local Settings = {
    SelectedCrystal = "Crystal",
    SelectedIsland = "Spawn",
    GemValue = 100000,
    CurrentIslandIndex = 1
}

-- 辅助函数：安全获取rEvents
local function getREvents()
    return ReplicatedStorage:FindFirstChild("rEvents")
end

-- 辅助函数：安全获取玩家角色部件
local function getCharPart()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.HumanoidRootPart
    end
    return nil
end

-- ============ 自动刷取选项卡 ============
FarmingTab:AddSection({"基础功能"})

FarmingTab:AddToggle({
    Name = "自动挥刀",
    Description = "自动攻击敌人",
    Default = false,
    Callback = function(Value)
        Toggles.AutoSwing = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoSwing and isRunning do
                    pcall(function()
                        local rEvents = getREvents()
                        if rEvents then
                            local swingEvent = rEvents:FindFirstChild("swingKatanaEvent")
                            if swingEvent then
                                swingEvent:FireServer()
                            elseif player:FindFirstChild("ninjaEvent") then
                                player.ninjaEvent:FireServer("swingKatana")
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

FarmingTab:AddToggle({
    Name = "自动出售",
    Description = "自动出售物品",
    Default = false,
    Callback = function(Value)
        Toggles.AutoSell = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoSell and isRunning do
                    pcall(function()
                        local hrp = getCharPart()
                        if not hrp then return end
                        
                        local sellArea = game.Workspace:FindFirstChild("sellAreaCircles") or game.Workspace:FindFirstChild("sellAreas")
                        if sellArea then
                            local area = sellArea:FindFirstChild("sellAreaCircle7") or 
                                        sellArea:FindFirstChild("sellAreaCircle6") or 
                                        sellArea:FindFirstChild("sellAreaCircle5")
                            if area then
                                local inner = area:FindFirstChild("circleInner") or area
                                if inner then
                                    hrp.CFrame = inner.CFrame
                                end
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

FarmingTab:AddToggle({
    Name = "自动收集",
    Description = "自动收集气、金币和宝石",
    Default = false,
    Callback = function(Value)
        Toggles.AutoCollect = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoCollect and isRunning do
                    pcall(function()
                        local hrp = getCharPart()
                        if not hrp then return end
                        
                        -- 收集金币和宝石
                        local spawnedCoins = game.Workspace:FindFirstChild("spawnedCoins")
                        if spawnedCoins then
                            for _, islandCoins in pairs(spawnedCoins:GetChildren()) do
                                if islandCoins:IsA("Folder") then
                                    for _, coin in pairs(islandCoins:GetChildren()) do
                                        if coin:IsA("Model") and coin.PrimaryPart then
                                            hrp.CFrame = coin.PrimaryPart.CFrame
                                            task.wait(0.05)
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- 收集气（蓝瓶）
                        local hoops = game.Workspace:FindFirstChild("Hoops")
                        if hoops then
                            for _, hoop in pairs(hoops:GetChildren()) do
                                if hoop:IsA("Model") and hoop.Name:find("Chi") and hoop.PrimaryPart then
                                    hrp.CFrame = hoop.PrimaryPart.CFrame
                                    task.wait(0.05)
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

FarmingTab:AddSection({"Boss击杀"})

local Bosses = {
    {Name = "机器人Boss", Value = "AutoRobotBoss", BossName = "RobotBoss"},
    {Name = "不朽Boss", Value = "AutoEternalBoss", BossName = "EternalBoss"},
    {Name = "古代Boss", Value = "AutoAncientBoss", BossName = "AncientMagmaBoss"},
    {Name = "圣诞老人Boss", Value = "AutoSantaBoss", BossName = "Samurai Santa"},
}

for _, boss in ipairs(Bosses) do
    FarmingTab:AddToggle({
        Name = "自动杀" .. boss.Name,
        Default = false,
        Callback = function(Value)
            Toggles[boss.Value] = Value
        end
    })
end

FarmingTab:AddToggle({
    Name = "自动杀全部Boss",
    Description = "循环击杀所有可用的Boss",
    Default = false,
    Callback = function(Value)
        Toggles.AutoAllBosses = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoAllBosses and isRunning do
                    pcall(function()
                        local hrp = getCharPart()
                        if not hrp then return end
                        
                        local bossFolder = game.Workspace:FindFirstChild("bossFolder")
                        if bossFolder then
                            local bossNames = {"Samurai Santa", "AncientMagmaBoss", "EternalBoss", "RobotBoss"}
                            for _, bossName in ipairs(bossNames) do
                                local boss = bossFolder:FindFirstChild(bossName)
                                if boss and boss:FindFirstChild("HumanoidRootPart") then
                                    hrp.CFrame = boss.HumanoidRootPart.CFrame
                                    
                                    local rEvents = getREvents()
                                    if rEvents then
                                        local swingEvent = rEvents:FindFirstChild("swingKatanaEvent")
                                        if swingEvent then
                                            swingEvent:FireServer()
                                        end
                                    end
                                    task.wait(1)
                                end
                            end
                        end
                    end)
                    task.wait(3)
                end
            end)
        end
    end
})

-- ============ 自动购买选项卡 ============
AutoBuyTab:AddSection({"自动购买"})

local BuyOptions = {
    {Name = "自动买等级", Value = "AutoRank", Event = "buyRankEvent", Args = {}},
    {Name = "自动买剑", Value = "AutoSword", Event = "buyAllSwordsEvent", Args = {}},
    {Name = "自动买腰带", Value = "AutoBelt", Event = "buyAllBeltsEvent", Args = {}},
    {Name = "自动买技能", Value = "AutoSkill", Event = "buyAllSkillsEvent", Args = {}},
    {Name = "自动买飞镖", Value = "AutoShuriken", Event = "buyAllShurikensEvent", Args = {}},
}

for _, option in ipairs(BuyOptions) do
    AutoBuyTab:AddToggle({
        Name = option.Name,
        Description = "自动购买" .. option.Name:sub(5),
        Default = false,
        Callback = function(Value)
            Toggles[option.Value] = Value
            if Value then
                task.spawn(function()
                    while Toggles[option.Value] and isRunning do
                        pcall(function()
                            local rEvents = getREvents()
                            if not rEvents then return end
                            
                            if option.Value == "AutoRank" then
                                local buyRankEvent = rEvents:FindFirstChild("buyRankEvent")
                                if buyRankEvent then
                                    local islands = {"Ground", "Astral", "Space", "Tundra", "Eternal", "Sandstorm", "Thunderstorm", "Ancient"}
                                    for _, island in ipairs(islands) do
                                        buyRankEvent:FireServer(island)
                                        task.wait(0.1)
                                    end
                                end
                            else
                                local event = rEvents:FindFirstChild(option.Event)
                                if event then
                                    event:FireServer()
                                end
                            end
                        end)
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

-- ============ 宠物管理选项卡 ============
PetsTab:AddSection({"宠物蛋"})

-- 获取水晶列表
local crystalOptions = {}
local mapCrystalsFolder = game.Workspace:FindFirstChild("mapCrystalsFolder")
if mapCrystalsFolder then
    for _, crystal in pairs(mapCrystalsFolder:GetChildren()) do
        if crystal:IsA("Model") then
            table.insert(crystalOptions, crystal.Name)
        end
    end
end

if #crystalOptions == 0 then
    crystalOptions = {"Basic", "Legendary", "Mythical", "Eternal", "Golden"}
endlo

PetsTab:AddDropdown({
    Name = "选择水晶",
    Description = "选择要开启的水晶类型",
    Options = crystalOptions,
    Default = crystalOptions[1],
    Callback = function(Value)
        Settings.SelectedCrystal = Value
    end
})

PetsTab:AddToggle({
    Name = "自动开蛋",
    Description = "自动开启选中的水晶蛋",
    Default = false,
    Callback = function(Value)
        Toggles.AutoOpenEgg = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoOpenEgg and isRunning do
                    pcall(function()
                        local rEvents = getREvents()
                        if not rEvents then return end
                        local openCrystalRemote = rEvents:FindFirstChild("openCrystalRemote")
                        if openCrystalRemote then
                            openCrystalRemote:InvokeServer("openCrystal", Settings.SelectedCrystal)
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

PetsTab:AddToggle({
    Name = "自动进化",
    Description = "自动进化所有宠物",
    Default = false,
    Callback = function(Value)
        Toggles.AutoEvolve = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoEvolve and isRunning do
                    pcall(function()
                        local rEvents = getREvents()
                        if not rEvents then return end
                        local petEvolveEvent = rEvents:FindFirstChild("petEvolveEvent")
                        if petEvolveEvent and player:FindFirstChild("petsFolder") then
                            for _, petType in pairs(player.petsFolder:GetChildren()) do
                                for _, pet in pairs(petType:GetChildren()) do
                                    petEvolveEvent:FireServer("evolvePet", pet.Name)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

PetsTab:AddToggle({
    Name = "自动孵化双元素鸟",
    Description = "自动孵化双元素小鸟",
    Default = false,
    Callback = function(Value)
        Toggles.AutoBuyTwinBirdies = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoBuyTwinBirdies and isRunning do
                    pcall(function()
                        local cPetShopRemote = ReplicatedStorage:FindFirstChild("cPetShopRemote")
                        local cPetShopFolder = ReplicatedStorage:FindFirstChild("cPetShopFolder")
                        
                        if cPetShopRemote and cPetShopFolder then
                            local twinBirdies = cPetShopFolder:FindFirstChild("Twin Element Birdies")
                            if twinBirdies then
                                cPetShopRemote:InvokeServer(twinBirdies)
                            end
                        end
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

-- ============ 元素选项卡 ============
PetShopTab:AddSection({"元素解锁"})

local Elements = {"Inferno", "Frost", "Lightning", "Shadow", "Chaos", "Masterful", "Eternity", "Blazing"}

for _, element in ipairs(Elements) do
    PetShopTab:AddButton({
        Name = "解锁 " .. element .. " 元素",
        Callback = function()
            pcall(function()
                local rEvents = getREvents()
                if not rEvents then return end
                
                -- 尝试多种事件名称
                local eventNames = {"elementMasteryEvent", "ElementMasteryEvent", "elementMastery"}
                for _, name in ipairs(eventNames) do
                    local event = rEvents:FindFirstChild(name)
                    if event then
                        -- 尝试多种参数格式
                        local success = pcall(function()
                            event:FireServer("buyMastery", element)
                        end)
                        if not success then
                            pcall(function()
                                event:FireServer({action = "buyMastery", element = element})
                            end)
                        end
                        break
                    end
                end
            end)
        end
    })
end

-- ============ 传送选项卡 ============
TeleportsTab:AddSection({"岛屿传送"})

-- 获取岛屿列表
local islandOptions = {}
local islandUnlockParts = game.Workspace:FindFirstChild("islandUnlockParts")
if islandUnlockParts then
    for _, island in pairs(islandUnlockParts:GetChildren()) do
        if island:IsA("Model") then
            table.insert(islandOptions, island.Name)
        end
    end
end

if #islandOptions == 0 then
    islandOptions = {"Ground", "Astral Island", "Space Island", "Tundra Island", 
                     "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island"}
end

TeleportsTab:AddDropdown({
    Name = "选择岛屿",
    Description = "传送到指定岛屿",
    Options = islandOptions,
    Default = islandOptions[1],
    Callback = function(Value)
        Settings.SelectedIsland = Value
    end
})

TeleportsTab:AddButton({
    Name = "传送到选中的岛屿",
    Callback = function()
        pcall(function()
            local hrp = getCharPart()
            if not hrp then return end
            
            local islandUnlockParts = game.Workspace:FindFirstChild("islandUnlockParts")
            if islandUnlockParts then
                local island = islandUnlockParts:FindFirstChild(Settings.SelectedIsland)
                if island then
                    local sign = island:FindFirstChild("islandSignPart")
                    if sign then
                        hrp.CFrame = sign.CFrame
                        return
                    end
                end
            end
            
            -- 备用传送点
            local backupPositions = {
                ["Ground"] = CFrame.new(0, 10, 0),
                ["Astral Island"] = CFrame.new(500, 50, 0),
                ["Space Island"] = CFrame.new(1000, 100, 0),
                ["Tundra Island"] = CFrame.new(0, 50, 500),
                ["Eternal Island"] = CFrame.new(0, 75, 1000),
                ["Sandstorm"] = CFrame.new(-500, 60, 0),
                ["Thunderstorm"] = CFrame.new(-1000, 80, 0),
                ["Ancient Inferno Island"] = CFrame.new(0, 90, -500)
            }
            local pos = backupPositions[Settings.SelectedIsland]
            if pos then
                hrp.CFrame = pos
            end
        end)
    end
})

-- ============ 杂项选项卡 ============
MiscTab:AddSection({"游戏功能"})

MiscTab:AddToggle({
    Name = "快速手里剑",
    Description = "增加手里剑飞行速度",
    Default = false,
    Callback = function(Value)
        Toggles.FastShuriken = Value
        if Value then
            task.spawn(function()
                while Toggles.FastShuriken and isRunning do
                    pcall(function()
                        local shurikensFolder = game.Workspace:FindFirstChild("shurikensFolder")
                        if shurikensFolder then
                            for _, shuriken in pairs(shurikensFolder:GetChildren()) do
                                if shuriken.Name == "Handle" then
                                    local bodyVelocity = shuriken:FindFirstChildOfClass("BodyVelocity")
                                    if bodyVelocity then
                                        bodyVelocity.Velocity = bodyVelocity.Velocity * 2
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

MiscTab:AddToggle({
    Name = "隐身模式",
    Description = "进入隐身状态",
    Default = false,
    Callback = function(Value)
        Toggles.Invisible = Value
        if Value then
            task.spawn(function()
                while Toggles.Invisible and isRunning do
                    pcall(function()
                        local rEvents = getREvents()
                        if rEvents then
                            local invisibilityEvent = rEvents:FindFirstChild("invisibilityEvent")
                            if invisibilityEvent then
                                invisibilityEvent:FireServer("activate")
                            end
                        end
                    end)
                    task.wait(10)
                end
            end)
        end
    end
})

MiscTab:AddToggle({
    Name = "防AFK",
    Description = "防止因挂机被踢出",
    Default = true,
    Callback = function(Value)
        Toggles.AntiAFK = Value
    end
})

MiscTab:AddButton({
    Name = "收集所有宝箱",
    Callback = function()
        pcall(function()
            local hrp = getCharPart()
            if not hrp then return end
            
            local chestTypes = {
                "mythicalChest", "goldenChest", "enchantedChest", "magmaChest",
                "legendsChest", "eternalChest", "saharaChest", "thunderChest",
                "ancientChest", "midnightShadowChest"
            }
            for _, chestName in ipairs(chestTypes) do
                local chest = game.Workspace:FindFirstChild(chestName)
                if chest then
                    local circleInner = chest:FindFirstChild("circleInner")
                    if circleInner then
                        hrp.CFrame = circleInner.CFrame
                        task.wait(2.5)
                    end
                end
            end
        end)
    end
})

-- ============ 刷金币选项卡（保留功能）============
MoneyTab:AddParagraph({"使用说明", "此功能将宝石转换为金币\n确保宝石数量充足"})
MoneyTab:AddParagraph({"注意", "转换数量过大可能导致游戏卡顿\n建议使用默认值"})

MoneyTab:AddTextBox({
    Name = "设置单次转换数量",
    Description = "请输入正数（默认100000）",
    Default = "100000",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 then
            Settings.GemValue = num
        else
            Settings.GemValue = 100000
        end
    end
})

MoneyTab:AddToggle({
    Name = "自动刷金币",
    Description = "自动将宝石转换为金币（只使用正数）",
    Default = false,
    Callback = function(Value)
        Toggles.AutoFarmMoney = Value
        if Value then
            task.spawn(function()
                while Toggles.AutoFarmMoney and isRunning do
                    pcall(function()
                        local rEvents = getREvents()
                        if not rEvents then return end
                        
                        local zenMasterEvent = rEvents:FindFirstChild("zenMasterEvent")
                        if zenMasterEvent then
                            -- 只使用正数转换，避免负数
                            zenMasterEvent:FireServer("convertGems", Settings.GemValue)
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

MoneyTab:AddButton({
    Name = "查看当前宝石数量",
    Callback = function()
        pcall(function()
            -- 尝试从玩家数据中读取宝石数量（不同服务器可能不同）
            local gems = 0
            local data = player:FindFirstChild("Data")
            if data then
                local gemValue = data:FindFirstChild("Gems") or data:FindFirstChild("GemsValue")
                if gemValue then
                    gems = gemValue.Value
                end
            end
            
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and gems == 0 then
                local gemStat = leaderstats:FindFirstChild("Gems") or leaderstats:FindFirstChild("GemsValue")
                if gemStat then
                    gems = gemStat.Value
                end
            end
            
            WindUI:Notify({
                Title = "宝石数量",
                Content = "当前宝石: " .. tostring(gems),
                Duration = 3
            })
        end)
    end
})

-- ============ 防AFK系统 ============
task.spawn(function()
    while isRunning do
        if Toggles.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
        task.wait(60)
    end
end)

-- ============ Boss自动击杀系统 ============
for _, boss in ipairs(Bosses) do
    task.spawn(function()
        while isRunning do
            if Toggles[boss.Value] then
                pcall(function()
                    local hrp = getCharPart()
                    if not hrp then return end
                    
                    local bossFolder = game.Workspace:FindFirstChild("bossFolder")
                    if bossFolder then
                        local bossObj = bossFolder:FindFirstChild(boss.BossName)
                        if bossObj and bossObj:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = bossObj.HumanoidRootPart.CFrame
                            local rEvents = getREvents()
                            if rEvents then
                                local swingEvent = rEvents:FindFirstChild("swingKatanaEvent")
                                if swingEvent then
                                    swingEvent:FireServer()
                                end
                            end
                        end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- 游戏关闭时清理
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        isRunning = false
    end
end)