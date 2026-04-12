--[[
    剑杰全功能合集 (Jian Jie Hub) - 修复版
    作者：剑杰
    如果加载没反应，请确保你的执行器支持 loadstring
]]

-- 1. 等待游戏加载，防止因为执行过快导致没反应
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 2. 只有加载成功的 UI 库才能运行
local WindUI = nil
local success, err = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()
end)

if success and err then
    WindUI = err
else
    -- 如果第一个链接失效，使用备用链接
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end

-- 3. 创建主窗口 (统一署名：剑杰)
local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>V1.5修复版</font>",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(500, 450),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
})

-- 悬浮按钮 (点击这个可以再次打开)
Window:EditOpenButton({
    Title = "剑杰 Hub",
    Icon = "shield",
    Draggable = true,
})

-- ==================== 游戏分类 ====================

-- TSB 模块
local TSBTab = Window:Tab({ Title = "最强战场", Icon = "swords" })
TSBTab:Button({
    Title = "注入 TSB 暴力功能",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Souls-dev/yehhevggfwgeggffftewer/refs/heads/main/tsb.txt"))()
            WindUI:Notify({Title = "剑杰提示", Content = "TSB功能已加载", Duration = 3})
        end)
    end
})

-- 俄亥俄州 模块
local OhioTab = Window:Tab({ Title = "俄亥俄州", Icon = "target" })
OhioTab:Button({
    Title = "一键：无后坐力 + 极速射速",
    Callback = function()
        pcall(function()
            local itemSystem = require(game:GetService("ReplicatedStorage").devv).load("v3item")
            for _, item in pairs(itemSystem.inventory.items) do
                if item then
                    item.recoilAdd, item.maxRecoil, item.baseSpread, item.fireRate = 0, 0, 0, 0.01
                end
            end
             WindUI:Notify({Title = "剑杰提示", Content = "武器修改成功", Duration = 2})
        end)
    end
})

-- 力量传奇 模块
local MSTab = Window:Tab({ Title = "力量传奇", Icon = "dumbbell" })
MSTab:Toggle({
    Title = "自动俯卧撑",
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

-- 通用功能 (伊散/增强)
local ToolTab = Window:Tab({ Title = "通用/伊散", Icon = "zap" })
ToolTab:Slider({
    Title = "行走速度",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

-- 关于
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })
AboutTab:Paragraph({
    Title = "剑杰制作",
    Desc = "如果某个功能点击没反应，说明该游戏已更新补丁。\n请联系作者：剑杰",
})

-- 4. 强制弹窗通知，确认脚本已运行
WindUI:Notify({
    Title = "剑杰 Hub",
    Content = "加载成功！如果没看到菜单，请点击屏幕上的悬浮球。",
    Icon = "check",
    Duration = 5
})
