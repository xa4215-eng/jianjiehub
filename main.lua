--[[
    剑杰全功能合集 (Jian Jie Hub) - 终极版
    整合内容：TSB最强战场、Ohio武器修改、BF自动刷、力量传奇、伊散全源
    作者：剑杰
]]

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>Ultimate</font>",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(500, 450),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
})

-- ==================== 1. TSB 最强战场 (专项逻辑) ====================
local TSBTab = Window:Tab({ Title = "最强战场", Icon = "swords" })

TSBTab:Section({ Title = "核心功能", Opened = true })
TSBTab:Button({
    Title = "加载 TSB 暴力脚本 (自动连招/锁定)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Souls-dev/yehhevggfwgeggffftewer/refs/heads/main/tsb.txt"))()
    end
})

-- ==================== 2. 俄亥俄州 (武器修改逻辑) ====================
local OhioTab = Window:Tab({ Title = "俄亥俄州", Icon = "target" })

OhioTab:Section({ Title = "武器暴力修改", Opened = true })
OhioTab:Button({
    Title = "开启：全枪无后坐力",
    Callback = function()
        local function removeRecoil()
            pcall(function()
                local itemSystem = require(game:GetService("ReplicatedStorage").devv).load("v3item")
                for _, item in pairs(itemSystem.inventory.items) do
                    if item then
                        item.recoilAdd = 0
                        item.maxRecoil = 0
                        item.baseSpread = 0
                    end
                end
            end)
        end
        task.spawn(function() while true do removeRecoil() task.wait(10) end end)
        WindUI:Notify({Title = "剑杰提醒", Content = "无后坐力已锁定", Duration = 2})
    end
})

OhioTab:Button({
    Title = "开启：加特林射速",
    Callback = function()
        pcall(function()
            local itemSystem = require(game:GetService("ReplicatedStorage").devv).load("v3item")
            for _, item in pairs(itemSystem.inventory.items) do
                if item then item.fireRate = 0.01 end
            end
        end)
    end
})

-- ==================== 3. 模拟器类 (力量/极速) ====================
local SimTab = Window:Tab({ Title = "模拟器类", Icon = "dumbbell" })

SimTab:Section({ Title = "力量传奇", Opened = true })
SimTab:Toggle({
    Title = "自动俯卧撑 (Pushups)",
    Callback = function(v)
        _G.AutoPush = v
        task.spawn(function()
            while _G.AutoPush do
                game:GetService("ReplicatedStorage").rEvents.pushUpsEvent:FireServer("began")
                task.wait(0.1)
            end
        end)
    end
})

SimTab:Section({ Title = "极速传奇", Opened = false })
SimTab:Button({
    Title = "加载极速传奇功能",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))() end
})

-- ==================== 4. Blox Fruits (BF) ====================
local BFTab = Window:Tab({ Title = "Blox Fruits", Icon = "skull" })

BFTab:Button({
    Title = "加载 BF 综合脚本",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/BF.lua"))() end
})

-- ==================== 5. 通用功能 (伊散/增强) ====================
local ToolTab = Window:Tab({ Title = "通用功能", Icon = "zap" })

ToolTab:Section({ Title = "人物物理", Opened = true })
ToolTab:Slider({
    Title = "行走速度",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

ToolTab:Toggle({
    Title = "自动刷糖果 (伊散全源)",
    Callback = function(v)
        _G.CandyFarm = v
        task.spawn(function()
            while _G.CandyFarm do
                pcall(function()
                    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
                    for _, house in pairs(workspace.Houses:GetChildren()) do
                        local door = house:FindFirstChild("Door") and house.Door:FindFirstChild("DoorInnerTouch")
                        if door then firetouchinterest(root, door, 0) end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- ==================== 6. 关于界面 ====================
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })
AboutTab:Paragraph({
    Title = "剑杰 Hub 终极集成版",
    Desc = "本脚本由 剑杰 个人汇总。\n所有功能均已适配最新版 UI。",
    Image = "award",
    Color = "Orange"
})

-- 初始化通知
WindUI:Notify({
    Title = "剑杰 Hub",
    Content = "终极全功能母版已就绪！",
    Icon = "check",
    Duration = 5
})
