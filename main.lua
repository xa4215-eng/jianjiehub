--[[
    剑杰全功能合集 (Jian Jie Hub) - 终极稳定版
    作者：剑杰
    提示：如果菜单没出来，请检查控制台是否有红字报错
]]

-- 确保游戏环境已加载
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- ==================== 1. UI 库安全加载 (带报错拦截) ====================
local WindUI = nil
local ui_success, ui_err = pcall(function()
    -- 优先尝试主链接
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()
end)

if not ui_success then
    -- 如果主链接失败，尝试备用链接
    local backup_success, backup_err = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if backup_success then
        WindUI = backup_err
    else
        warn("剑杰脚本提示：WindUI 库加载失败，请检查网络！")
        return
    end
else
    WindUI = ui_err
end

-- ==================== 2. 创建主窗口 ====================
local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>V3.5</font>",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(550, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
})

-- 强制显示悬浮按钮，防止窗口被意外关闭后找不回来
Window:EditOpenButton({
    Title = "剑杰菜单",
    Icon = "shield",
    Draggable = true,
})

-- ==================== 3. 游戏分类 (Loadstring 直连版) ====================
local GameTab = Window:Tab({ Title = "游戏中心", Icon = "gamepad-2" })

GameTab:Section({ Title = "点击按钮注入功能", Opened = true })

-- TSB 最强战场
GameTab:Button({
    Title = "注入：最强战场 (TSB) 暴力版",
    Desc = "作者：剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Souls-dev/yehhevggfwgeggffftewer/refs/heads/main/tsb.txt"))()
    end
})

-- Blox Fruits
GameTab:Button({
    Title = "注入：Blox Fruits (BF) 脚本",
    Desc = "作者：剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/BF.lua"))()
    end
})

-- 俄亥俄州
GameTab:Button({
    Title = "注入：俄亥俄州 (Ohio) 暴力",
    Desc = "作者：剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E4%BF%84%E4%BA%A5%E4%BF%84%E5%B7%9E.lua"))()
    end
})

-- 力量传奇
GameTab:Button({
    Title = "注入：力量传奇 (MS) 脚本",
    Desc = "作者：剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua"))()
    end
})

-- 极速传奇
GameTab:Button({
    Title = "注入：极速传奇 脚本",
    Desc = "作者：剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))()
    end
})

-- ==================== 4. 伊散全源 (通用功能直连) ====================
local UniversalTab = Window:Tab({ Title = "通用/伊散", Icon = "zap" })

UniversalTab:Section({ Title = "伊散源码功能", Opened = true })

UniversalTab:Button({
    Title = "加载：伊散全源 (通用增强)",
    Desc = "包含自然灾害、刷糖果等源码逻辑",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E4%BC%8A%E6%95%A3%E5%85%A8%E6%BA%90.lua"))()
    end
})

-- 快捷行走速度滑块
UniversalTab:Slider({
    Title = "全局速度修改",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

-- ==================== 5. 关于剑杰 ====================
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })
AboutTab:Paragraph({
    Title = "剑杰 Hub 终极版",
    Desc = "集成 TSB、BF、Ohio、力量、极速及伊散源码。\n\n作者：剑杰\n所有功能均实时从云端拉取最新版。",
})

-- 强制发送成功通知
WindUI:Notify({
    Title = "剑杰脚本加载成功",
    Content = "菜单已就绪，请在侧边栏选择游戏。",
    Icon = "check",
    Duration = 5
})
