-- [[ 剑杰 · 内部辅助 - 专项集成版 ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. 窗口初始化
local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(580, 460),
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
local RunService = game:GetService("RunService")

-- ==========================================
-- 【核心战斗】 - 子弹追踪 + 暗白透视
-- ==========================================
local CombatTab = Window:Tab({ Title = "核心战斗", Icon = "target" })

-- 1. 子弹追踪 (LJ子追逻辑)
local AimSettings = { Enabled = false, FOV = 150, Smoothing = 0.5 }
CombatTab:Toggle({
    Title = "子弹追踪 (Beta)",
    Value = false,
    Callback = function(state) AimSettings.Enabled = state end
})

CombatTab:Slider({
    Title = "追踪范围 (FOV)",
    Min = 50, Max = 800, Default = 150,
    Callback = function(v) AimSettings.FOV = v end
})

-- 2. 暗白名字透视 (保留之前的逻辑)
_G.NameESP = false
CombatTab:Toggle({
    Title = "玩家透视 (暗白名字)",
    Value = false,
    Callback = function(state)
        _G.NameESP = state
        if not state then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("JianJieTag") then
                    v.Character.Head.JianJieTag:Destroy()
                end
            end
        end
    end
})

-- ==========================================
-- 【游戏专项】 - 自动识别分类
-- ==========================================

-- A. 最强战场
if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    local TSBTab = Window:Tab({ Title = "最强战场", Icon = "swords" })
    TSBTab:Button({
        Title = "加载专项功能",
        Callback = function()
            -- 内部直接运行你上传的 最强战场.lua 核心逻辑
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/最强战场.lua"))()
        end
    })

-- B. 俄亥俄州
elseif game.PlaceId == 10603780517 then
    local OhioTab = Window:Tab({ Title = "俄亥俄州", Icon = "map" })
    OhioTab:Button({
        Title = "加载 Tnine 专项",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/tnine俄亥俄州源码.lua"))()
        end
    })

-- C. 力量传奇
elseif game.PlaceId == 3956818381 then
    local MLTab = Window:Tab({ Title = "力量传奇", Icon = "dumbbell" })
    MLTab:Button({
        Title = "一键刷力量",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/力量传奇.lua"))()
        end
    })

-- D. 极速传奇
elseif game.PlaceId == 3101667897 then
    local LSTab = Window:Tab({ Title = "极速传奇", Icon = "zap" })
    LSTab:Button({
        Title = "加载极速专项",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/极速传奇.lua"))()
        end
    })

-- E. 战争大亨
elseif game.PlaceId == 7370392949 then
    local WTTab = Window:Tab({ Title = "战争大亨", Icon = "shield" })
    WTTab:Button({
        Title = "加载大司马专项",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/战争大亨.lua"))()
        end
    })
end

-- ==========================================
-- 核心刷新逻辑
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- 透视渲染
    if _G.NameESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                if not v.Character.Head:FindFirstChild("JianJieTag") then
                    local bill = Instance.new("BillboardGui", v.Character.Head)
                    bill.Name = "JianJieTag"
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0, 100, 0, 50)
                    bill.ExtentsOffset = Vector3.new(0, 3, 0)
                    local label = Instance.new("TextLabel", bill)
                    label.BackgroundTransparency = 1
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.Text = v.Name
                    label.TextColor3 = Color3.fromRGB(210, 210, 210) -- 暗白色
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                end
            end
        end
    end
end)

Window:Notify({Title = "剑杰 Hub", Content = "功能整合完毕，当前游戏已适配", Duration = 3})