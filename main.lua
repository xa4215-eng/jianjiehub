-- [[ 剑杰 Hub - 终极通用与专项集成版 v3.0 ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(600, 500),
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
local Camera = workspace.CurrentCamera

-- ==========================================
-- 【全局控制变量】
-- ==========================================
_G.WalkSpeed = 16
_G.Fling = false
_G.FlingSpeed = 50
_G.NameESP = false
_G.Aimbot = false
_G.SilentAim = false
_G.AimFOV = 150
_G.AimSmooth = 0.5

-- ==========================================
-- 1. 【通用功能】 - 包含透视、自瞄、甩人、加速
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用功能", Icon = "globe" })

GeneralTab:Section({ Title = "玩家控制" })

GeneralTab:Slider({
    Title = "全局移动加速",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v) _G.WalkSpeed = v end
})

GeneralTab:Toggle({
    Title = "开启甩人 (Fling)",
    Desc = "靠近玩家即可将其甩飞",
    Value = false,
    Callback = function(state) _G.Fling = state end
})

GeneralTab:Slider({
    Title = "甩人旋转力度",
    Min = 50,
    Max = 5000,
    Default = 100,
    Callback = function(v) _G.FlingSpeed = v end
})

GeneralTab:Section({ Title = "视觉与透视" })

GeneralTab:Toggle({
    Title = "玩家暗白透视 (ESP)",
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

GeneralTab:Section({ Title = "战斗辅助 (子追 & 自瞄)" })

GeneralTab:Toggle({
    Title = "视角自瞄 (Aimbot)",
    Desc = "自动锁定屏幕内最近玩家",
    Value = false,
    Callback = function(state) _G.Aimbot = state end
})

GeneralTab:Toggle({
    Title = "子弹追踪 (Silent Aim)",
    Desc = "LJ子追核心逻辑",
    Value = false,
    Callback = function(state) _G.SilentAim = state end
})

GeneralTab:Slider({
    Title = "追踪与自瞄范围 (FOV)",
    Min = 50,
    Max = 1000,
    Default = 150,
    Callback = function(v) _G.AimFOV = v end
})

GeneralTab:Slider({
    Title = "自瞄平滑度 (Smoothness)",
    Min = 0.1,
    Max = 1,
    Step = 0.1,
    Default = 0.5,
    Callback = function(v) _G.AimSmooth = v end
})

-- ==========================================
-- 2. 【专项加载】 - 根据游戏自动识别
-- ==========================================
local currentPlaceId = game.PlaceId

if currentPlaceId == 10449761463 or game.GameId == 3833109746 then
    local TSBTab = Window:Tab({ Title = "最强战场 (专项)", Icon = "swords" })
    TSBTab:Button({
        Title = "🚀 加载最强战场完整源码",
        Desc = "点击后将加载云端完整 UI 与连招逻辑",
        Callback = function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/最强战场.lua"))() end)
            Window:Notify({Title = "加载成功", Content = "最强战场专项已运行", Duration = 3})
        end
    })

elseif currentPlaceId == 10603780517 then
    local OhioTab = Window:Tab({ Title = "俄亥俄州 (专项)", Icon = "map" })
    OhioTab:Button({
        Title = "🚀 加载俄亥俄州源码 (tnine版)",
        Callback = function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/tnine俄亥俄州源码.lua"))() end)
            Window:Notify({Title = "加载成功", Content = "俄亥俄州专项已运行", Duration = 3})
        end
    })

elseif currentPlaceId == 3956818381 then
    local MLTab = Window:Tab({ Title = "力量传奇 (专项)", Icon = "dumbbell" })
    MLTab:Button({
        Title = "🚀 加载力量传奇源码 (大司马)",
        Callback = function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/力量传奇.lua"))() end)
        end
    })

elseif currentPlaceId == 3101667897 then
    local LSTab = Window:Tab({ Title = "极速传奇 (专项)", Icon = "zap" })
    LSTab:Button({
        Title = "🚀 加载极速传奇源码 (大司马)",
        Callback = function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/极速传奇.lua"))() end)
        end
    })

elseif currentPlaceId == 7370392949 then
    local WTTab = Window:Tab({ Title = "战争大亨 (专项)", Icon = "shield" })
    WTTab:Button({
        Title = "🚀 加载战争大亨源码",
        Callback = function()
            pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/战争大亨.lua"))() end)
        end
    })
end

-- ==========================================
-- 3. 【核心运行逻辑】 (后台循环)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 50, 50)
FOVCircle.Filled = false

local function GetClosestPlayer()
    local target = nil
    local dist = _G.AimFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize / 2).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- 1. FOV 圆圈更新
    FOVCircle.Visible = _G.Aimbot or _G.SilentAim
    FOVCircle.Radius = _G.AimFOV
    FOVCircle.Position = Camera.ViewportSize / 2

    -- 2. 玩家加速 (防止游戏重置)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        end
    end)

    -- 3. 甩人逻辑 (高转速物理碰撞)
    if _G.Fling and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) -- 保持正常下落
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(_G.FlingSpeed), 0, 0)
    end

    -- 4. 视角自瞄逻辑 (Aimbot)
    if _G.Aimbot then
        local target = GetClosestPlayer()
        if target then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), _G.AimSmooth)
        end
    end

    -- 5. 透视逻辑 (ESP)
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
                    label.TextColor3 = Color3.fromRGB(220, 220, 220)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                end
            end
        end
    end
end)

Window:Notify({Title = "剑杰 Hub", Content = "通用功能与专项引擎加载完毕！", Duration = 3})
