--[[
    剑杰全功能合集 (Jian Jie Hub) - 终极版
    作者：剑杰
    整合内容：BF、俄亥俄州武器修改、力量传奇训练、极速传奇、通用增强
]]

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>Ultimate</font>",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(550, 450),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
})

-- ==================== 1. Blox Fruits (BF) ====================
local BFTab = Window:Tab({ Title = "Blox Fruits", Icon = "sword" })

BFTab:Section({ Title = "自动功能", Opened = true })
BFTab:Toggle({
    Title = "自动刷等级 (Auto Farm)",
    Callback = function(v) 
        getgenv().AutoFarm = v 
        if v then loadstring(game:HttpGet("https://github.com/xa4215-eng/jianjiehub/blob/main/BF.lua"))() end
    end
})
BFTab:Toggle({ Title = "自动点击 (Auto Click)", Callback = function(v) getgenv().AutoClick = v end })
BFTab:Toggle({ Title = "自动开启宝箱", Callback = function(v) getgenv().AutoChest = v end })
BFTab:Button({ Title = "远距离命中 (Hitbox)", Callback = function() getgenv().Hitbox = true end })

-- ==================== 2. 俄亥俄州 (Ohio) ====================
local OhioTab = Window:Tab({ Title = "俄亥俄州", Icon = "target" })

OhioTab:Section({ Title = "暴力武器修改", Opened = true })
OhioTab:Button({
    Title = "开启：全枪无后坐力 + 无扩散",
    Callback = function()
        local function removeRecoil()
            pcall(function()
                local itemSystem = require(game:GetService("ReplicatedStorage").devv).load("v3item")
                for _, item in pairs(itemSystem.inventory.items) do
                    if item then
                        item.recoilAdd, item.maxRecoil, item.baseSpread, item.spread = 0, 0, 0, 0
                    end
                end
            end)
        end
        task.spawn(function() while true do removeRecoil() task.wait(5) end end)
        WindUI:Notify({Title = "剑杰提醒", Content = "无后坐力已锁定", Duration = 2})
    end
})
OhioTab:Button({
    Title = "开启：全枪极速射速",
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
local SimTab = Window:Tab({ Title = "模拟器合集", Icon = "dumbbell" })

SimTab:Section({ Title = "力量传奇", Opened = true })
SimTab:Toggle({
    Title = "自动俯卧撑",
    Callback = function(state)
        getgenv().AutoPushups = state
        task.spawn(function()
            while getgenv().AutoPushups do
                game:GetService("ReplicatedStorage").rEvents.pushUpsEvent:FireServer("began")
                task.wait(0.1)
            end
        end)
    end
})

SimTab:Section({ Title = "极速传奇", Opened = false })
SimTab:Button({
    Title = "加载极速传奇独立菜单",
    Callback = function() loadstring(game:HttpGet("https://github.com/xa4215-eng/jianjiehub/blob/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))() end
})

-- ==================== 4. 通用增强 (伊散逻辑) ====================
local ToolTab = Window:Tab({ Title = "通用功能", Icon = "zap" })

ToolTab:Section({ Title = "人物属性", Opened = true })
ToolTab:Slider({
    Title = "行走速度",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

ToolTab:Toggle({
    Title = "自动刷糖果 (通用事件)",
    Callback = function(v)
        getgenv().CandyFarm = v
        -- 伊散原始代码逻辑执行处
    end
})

-- ==================== 5. 关于剑杰 ====================
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })
AboutTab:Paragraph({
    Title = "剑杰 Hub 终极版",
    Desc = "本脚本由 剑杰 汇总制作。\n已集成 BF、Ohio、模拟器等主流游戏功能。\n\n作者：剑杰\n状态：已注入",
    Image = "award",
    Color = "Orange"
})

-- 初始化通知
WindUI:Notify({
    Title = "剑杰 Hub 汇总完成",
    Content = "欢迎使用，尊贵的 剑杰 用户！",
    Icon = "check",
    Duration = 5
})
