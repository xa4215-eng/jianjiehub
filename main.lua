-- ==========================================
-- 剑杰全功能合集 (Jian Jie Hub)
-- 作者: 剑杰
-- 版本: 1.0.0
-- ==========================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "剑杰全功能合集 <font color='#00FF00'>Hub</font>",
    Icon = "rbxassetid://81944629903864",
    Author = "作者: 剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(450, 350),
    Transparent = true,
    Theme = "Dark", -- 设置为深色模式更显专业
    SideBarWidth = 160,
})

-- 悬浮打开按钮修改
Window:EditOpenButton({
    Title = "剑杰 Hub",
    Icon = "shield",
    Draggable = true,
})

-- 1. 游戏分类选项卡
local GameTab = Window:Tab({ Title = "游戏中心", Icon = "gamepad-2" })

GameTab:Section({ Title = "快捷加载脚本", Opened = true })

GameTab:Button({
    Title = "加载：极速传奇 (付费版)",
    Desc = "作者: 剑杰",
    Callback = function()
        -- 这里填入你之前极速传奇的代码，我已帮你把通知和标题都改好了
        loadstring(game:HttpGet("你的极速传奇脚本链接"))()
        WindUI:Notify({ Title = "剑杰提示", Content = "极速传奇脚本已成功加载", Duration = 3 })
    end
})

GameTab:Button({
    Title = "加载：力量传奇 (付费版)",
    Desc = "作者: 剑杰",
    Callback = function()
        loadstring(game:HttpGet("你的力量传奇脚本链接"))()
        WindUI:Notify({ Title = "剑杰提示", Content = "力量传奇脚本已成功加载", Duration = 3 })
    end
})

GameTab:Button({
    Title = "加载：战争大亨 (定制版)",
    Desc = "作者: 剑杰",
    Callback = function()
        loadstring(game:HttpGet("你的战争大亨脚本链接"))()
    end
})

-- 2. 增强功能选项卡 (针对 BF、动漫模拟器等 YG 系列)
local AdvancedTab = Window:Tab({ Title = "高级增强", Icon = "zap" })

AdvancedTab:Section({ Title = "专用模式", Opened = true })

AdvancedTab:Button({
    Title = "加载：YG系列集成脚本",
    Desc = "已由 剑杰 完成重制",
    Callback = function()
        -- 此处可以加载你之前那几个YG团队的脚本
        WindUI:Notify({ Title = "剑杰提示", Content = "正在启用高级增强模式...", Duration = 3 })
    end
})

-- 3. 关于与声明
local AboutTab = Window:Tab({ Title = "关于", Icon = "info" })

AboutTab:Paragraph({
    Title = "关于 剑杰 Hub",
    Desc = "这是由 剑杰 个人整合的脚本合集。\n整合了市面上主流的各类模拟器功能。\n\n当前状态：运行正常",
    Image = "award",
    ImageSize = 32,
    Color = "Orange"
})

AboutTab:Button({
    Title = "复制作者联系方式",
    Callback = function()
        setclipboard("剑杰") -- 可以在这里放你的社交账号
        WindUI:Notify({ Title = "成功", Content = "联系方式已复制到剪贴板", Duration = 2 })
    end
})

-- 开启通知
WindUI:Notify({
    Title = "剑杰脚本加载成功",
    Content = "欢迎使用，尊贵的 剑杰 用户！",
    Icon = "check",
    Duration = 5
})