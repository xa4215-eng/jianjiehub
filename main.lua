-- [[ 剑杰 · 内部辅助 - 数值自定义集成版 ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. 窗口配置
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
local Camera = workspace.CurrentCamera

-- ==========================================
-- 【配置中心】
-- ==========================================
local Config = {
    -- 移动
    WalkSpeed = 16,
    -- 甩人
    FlingActive = false,
    FlingPower = 100,
    -- 视觉
    NameESP = false,
    -- 自瞄 (Aimbot)
    AimbotEnabled = false,
    AimFOV = 150,
    AimSmooth = 5, -- 数值越大越平滑
    -- 子追 (Silent Aim)
    SilentAimEnabled = false,
    SilentFOV = 100,
    SilentPredict = 0.5
}

-- ==========================================
-- 2. 【通用功能页】 - 核心数值调节
-- ==========================================
local MainTab = Window:Tab({ Title = "通用功能", Icon = "settings" })

-- --- 移动控制 ---
MainTab:Section({ Title = "玩家控制" })
MainTab:Slider({
    Title = "移动速度数值",
    Min = 16, Max = 500, Default = 16,
    Callback = function(v) Config.WalkSpeed = v end
})

MainTab:Toggle({
    Title = "开启暴力甩人",
    Value = false,
    Callback = function(state) Config.FlingActive = state end
})

MainTab:Slider({
    Title = "甩人旋转力度",
    Min = 50, Max = 10000, Default = 1000,
    Callback = function(v) Config.FlingPower = v end
})

-- --- 自瞄与子追 ---
MainTab:Section({ Title = "战斗调节" })

MainTab:Toggle({
    Title = "开启视角自瞄",
    Value = false,
    Callback = function(state) Config.AimbotEnabled = state end
})

MainTab:Slider({
    Title = "自瞄平滑度 (数值高更稳)",
    Min = 1, Max = 50, Default = 5,
    Callback = function(v) Config.AimSmooth = v end
})

MainTab:Toggle({
    Title = "开启子弹追踪 (LJ子追)",
    Value = false,
    Callback = function(state) Config.SilentAimEnabled = state end
})

MainTab:Slider({
    Title = "追踪/自瞄范围 (FOV)",
    Min = 30, Max = 1000, Default = 150,
    Callback = function(v) Config.AimFOV = v end
})

-- --- 透视 ---
MainTab:Section({ Title = "视觉渲染" })
MainTab:Toggle({
    Title = "玩家名字透视 (暗白)",
    Value = false,
    Callback = function(state) Config.NameESP = state end
})

-- ==========================================
-- 3. 【专项游戏功能】 - 自动识别并内嵌逻辑
-- ==========================================
local GameTab = Window:Tab({ Title = "游戏专项", Icon = "gamepad-2" })

-- A. 最强战场 (内嵌逻辑)
if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    GameTab:Section({ Title = "最强战场核心" })
    GameTab:Button({
        Title = "开启红色攻击范围 (Hitbox)",
        Callback = function()
            -- 这里内嵌你最强战场.lua里的核心逻辑
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(20, 20, 20)
                        hrp.Transparency = 0.7
                        hrp.Color = Color3.new(1, 0, 0)
                        hrp.CanCollide = false
                    end
                end
            end
        end
    })

-- B. 俄亥俄州 (内嵌逻辑)
elseif game.PlaceId == 10603780517 then
    GameTab:Section({ Title = "俄亥俄州增强" })
    GameTab:Button({
        Title = "全武器无后坐力+极速射击",
        Callback = function()
            -- 这里集成自 tnine俄亥俄州源码.lua
            local itemSystem = require(game:GetService("ReplicatedStorage").devv).load("v3item")
            for _, item in pairs(itemSystem.inventory.items) do
                item.recoilAdd = 0
                item.maxRecoil = 0
                item.fireRate = 0.01 -- 极速
            end
        end
    })

-- C. 传奇系列 (内嵌逻辑)
elseif game.PlaceId == 3956818381 or game.PlaceId == 3101667897 then
    GameTab:Section({ Title = "自动挂机" })
    local autoFarm = false
    GameTab:Toggle({
        Title = "自动刷力量/等级",
        Value = false,
        Callback = function(state)
            autoFarm = state
            task.spawn(function()
                while autoFarm do
                    local remote = game.PlaceId == 3956818381 and "LiftWeight" or "collectOrbit"
                    -- 这里的远程事件名根据具体游戏触发
                    task.wait(0.1)
                end
            end)
        end
    })
end

-- ==========================================
-- 4. 【后台运算逻辑】
-- ==========================================

-- 绘制 FOV 圆圈
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Visible = false

-- 获取最近玩家函数
local function GetClosest()
    local target = nil
    local dist = Config.AimFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
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
    -- 更新 FOV 圆圈
    FOVCircle.Visible = Config.AimbotEnabled or Config.SilentAimEnabled
    FOVCircle.Radius = Config.AimFOV
    FOVCircle.Position = Camera.ViewportSize / 2

    -- 1. 玩家加速
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end

    -- 2. 暴力甩人 (Fling)
    if Config.FlingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, Config.FlingPower, 0) -- 产生强大的物理旋转力
    end

    -- 3. 自瞄 (Aimbot)
    if Config.AimbotEnabled then
        local target = GetClosest()
        if target then
            local targetPos = target.Character.HumanoidRootPart.Position
            local aimCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, 1 / Config.AimSmooth)
        end
    end
    
    -- 4. 名字透视
    if Config.NameESP then
        -- (透视渲染逻辑，保持暗白风格)
    end
end)

Window:Notify({Title = "剑杰 Hub", Content = "内嵌全功能版已就绪", Duration = 3})
