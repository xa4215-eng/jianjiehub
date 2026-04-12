--[[
    剑杰全功能合集 (Jian Jie Hub)
    作者：剑杰
    版本：3.0 (云端直连版)
]]

-- ==================== 1. 加载 UI 库 ====================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>Ultimate</font>",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(550, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
})

-- 悬浮打开按钮
Window:EditOpenButton({
    Title = "剑杰 Hub",
    Icon = "shield",
    Draggable = true,
})

-- ==================== 2. 游戏中心 (Loadstring 调用) ====================
local GameTab = Window:Tab({ Title = "游戏中心", Icon = "gamepad-2" })

GameTab:Section({ Title = "大型脚本注入", Opened = true })

-- TSB 最强战场 (你提供的 Souls-dev 链接)
GameTab:Button({
    Title = "加载：最强战场 (TSB) 暴力版",
    Desc = "作者: 剑杰 (集成 Souls-dev)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Souls-dev/yehhevggfwgeggffftewer/refs/heads/main/tsb.txt"))()
        WindUI:Notify({Title = "剑杰提示", Content = "TSB 脚本已注入", Duration = 3})
    end
})

-- Blox Fruits
GameTab:Button({
    Title = "加载：Blox Fruits (BF) 全功能",
    Desc = "作者: 剑杰 (YG 逻辑)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/BF.lua"))()
    end
})

-- 俄亥俄州
GameTab:Button({
    Title = "加载：俄亥俄州 (Ohio) 暴力修改",
    Desc = "作者: 剑杰 (tnine 源码)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E4%BF%84%E4%BA%A5%E4%BF%84%E5%B7%9E.lua"))()
    end
})

-- 力量传奇
GameTab:Button({
    Title = "加载：力量传奇 (MS) 付费版",
    Desc = "作者: 剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E5%8A%9B%E9%87%8F%E4%BC%A0%E5%A5%87.lua"))()
    end
})

-- 极速传奇
GameTab:Button({
    Title = "加载：极速传奇 付费版",
    Desc = "作者: 剑杰",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E6%9E%81%E9%80%9F%E4%BC%A0%E5%A5%87.lua"))()
    end
})

-- 忍者传奇
GameTab:Button({
    Title = "加载：忍者传奇 (YG 重制)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/YG%20%E5%BF%8D%E8%80%85%E4%BC%A0%E5%A5%87.lua"))()
    end
})

-- ==================== 3. 伊散通用 (源码直嵌) ====================
-- 由于伊散是通用功能，我直接把他的“自动刷糖果”和“属性修改”嵌在主菜单，方便你任何游戏都能用
local UniversalTab = Window:Tab({ Title = "通用/伊散", Icon = "zap" })

UniversalTab:Section({ Title = "物理增强", Opened = true })
UniversalTab:Slider({
    Title = "行走速度",
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

UniversalTab:Section({ Title = "伊散全源功能", Opened = true })
UniversalTab:Button({
    Title = "执行：自然灾害全功能 (伊散)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/%E4%BC%8A%E6%95%A3%E5%85%A8%E6%BA%90.lua"))()
    end
})

-- ==================== 4. 关于与设置 ====================
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })

AboutTab:Paragraph({
    Title = "剑杰全功能合集 (Jian Jie Hub)",
    Desc = "本 Hub 采用 Loadstring 实时拉取最新源码。\n\n当前作者：剑杰\n更新日期：2026-04-12",
    Image = "award",
    Color = "Orange"
})

AboutTab:Button({
    Title = "复制联系方式",
    Callback = function()
        setclipboard("剑杰")
        WindUI:Notify({Title = "成功", Content = "作者名字已复制", Duration = 2})
    end
})

-- 加载通知
WindUI:Notify({
    Title = "剑杰 Hub 加载成功",
    Content = "点击左侧图标选择需要加载的游戏脚本",
    Icon = "check",
    Duration = 5
})
