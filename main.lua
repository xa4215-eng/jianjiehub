-- [[ 剑杰 · 内部辅助 - 八合一专项版 ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. 窗口初始化
local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(580, 480),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "剑杰",
    Icon = "shrine",
    Color = ColorSequence.new(Color3.fromHex("FF0000"), Color3.fromHex("0000FF"))
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 自动识别游戏并加载专项功能
-- ==========================================

-- 1. 最强战场 (The Strongest Battlegrounds)
if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    local TSB = Window:Tab({ Title = "最强战场", Icon = "swords" })
    TSB:Button({
        Title = "加载专项功能 (皮脚本逻辑)",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/最强战场.lua"))()
        end
    })

-- 2. 力量传奇 (Muscle Legends)
elseif game.PlaceId == 3956818381 then
    local ML = Window:Tab({ Title = "力量传奇", Icon = "dumbbell" })
    ML:Button({
        Title = "自动刷力量/刷体型",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/力量传奇.lua"))()
        end
    })

-- 3. 极速传奇 (Legends of Speed)
elseif game.PlaceId == 3101667897 then
    local LS = Window:Tab({ Title = "极速传奇", Icon = "zap" })
    LS:Button({
        Title = "自动练级/自动拾取",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/极速传奇.lua"))()
        end
    })

-- 4. 忍者传奇 (Ninja Legends)
elseif game.PlaceId == 3515496167 then
    local NL = Window:Tab({ Title = "忍者传奇", Icon = "clapperboard" })
    NL:Button({
        Title = "自动挥砍/自动购买",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/忍者传奇.lua"))()
        end
    })

-- 5. 俄亥俄州 (Ohio)
elseif game.PlaceId == 10603780517 then
    local Ohio = Window:Tab({ Title = "俄亥俄州", Icon = "map" })
    Ohio:Button({
        Title = "开启暴力/自动刷钱",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/俄亥俄州.lua"))()
        end
    })

-- 6. 模仿者 (The Mimic)
elseif game.PlaceId == 5977222308 then
    local Mimic = Window:Tab({ Title = "模仿者", Icon = "ghost" })
    Mimic:Button({
        Title = "全章透视/无视黑夜",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/模仿者.lua"))()
        end
    })

-- 7. 战争大亨 (War Tycoon)
elseif game.PlaceId == 7370392949 then
    local WT = Window:Tab({ Title = "战争大亨", Icon = "shield" })
    WT:Button({
        Title = "自动收集金钱/自瞄",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/战争大亨.lua"))()
        end
    })

-- 8. 碧蓝湖泊/BF (Blox Fruits)
elseif game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    local BF = Window:Tab({ Title = "Blox Fruits", Icon = "ship" })
    BF:Button({
        Title = "自动农场/自动任务",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/BF.lua"))()
        end
    })

else
    -- 如果不在以上八个游戏里
    local Unknown = Window:Tab({ Title = "未识别游戏", Icon = "help-circle" })
    Unknown:Paragraph({
        Title = "提示",
        Content = "当前游戏不在八大专项支持列表中，请切换至支持的游戏。"
    })
end

Window:Notify({Title = "剑杰 Hub", Content = "八大专项功能识别就绪", Duration = 5})
