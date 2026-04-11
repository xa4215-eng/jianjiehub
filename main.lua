-- [[ 剑杰 · 内部辅助 - 源码深度模仿版 ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

-- 悬浮按钮设置
Window:EditOpenButton({
    Title = "剑杰",
    Icon = "shrine",
    Color = ColorSequence.new(Color3.fromHex("FF0000"), Color3.fromHex("0000FF"))
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ==========================================
-- 【通用功能】 - 包含红色显眼范围调节
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用功能", Icon = "zap" })

-- 1. 移动速度调节 (WalkSpeed)
_G.SpeedValue = 16
GeneralTab:Slider({
    Title = "设置移动速度",
    Min = 16,
    Max = 400,
    Default = 16,
    Callback = function(v)
        _G.SpeedValue = v
    end
})

-- 2. 攻击范围调节 (红色显眼 Hitbox)
_G.HitboxSize = 2
GeneralTab:Slider({
    Title = "红色受击范围 (Hitbox)",
    Min = 2,
    Max = 60, -- 调大上限，更暴力
    Default = 2,
    Callback = function(v)
        _G.HitboxSize = v
    end
})

-- 3. 玩家名字透视 (暗白源码风格)
_G.NameESP = false
GeneralTab:Toggle({
    Title = "玩家名字透视 (暗白)",
    Value = false,
    Callback = function(state) 
        _G.NameESP = state 
        if not state then
            -- 关闭时清除文字
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("JianJieTag") then
                    v.Character.Head.JianJieTag:Destroy()
                end
            end
        end
    end
})

-- 4. 碰撞箱旋转 (SpinBot)
_G.SpinSpeed = 0
GeneralTab:Slider({
    Title = "设置旋转速度",
    Min = 0,
    Max = 100,
    Default = 0,
    Callback = function(v) _G.SpinSpeed = v end
})

-- ==========================================
-- 核心逻辑处理 (模仿源码实时渲染)
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- 1. 速度逻辑
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedValue
        end
    end)

    -- 2. 红色显眼范围逻辑 (Hitbox)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = v.Character.HumanoidRootPart
                -- 动态改变大小
                hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                -- 红色显眼设置
                hrp.Transparency = 0.6 -- 半透明，不遮挡视线
                hrp.Color = Color3.fromRGB(255, 0, 0) -- 纯红色
                hrp.Material = Enum.Material.Neon -- 霓虹材质，让它发光更显眼
                hrp.CanCollide = false 
            end)
        end
    end

    -- 3. 透视逻辑
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
                    label.TextColor3 = Color3.fromRGB(210, 210, 210) -- 源码暗白
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                end
            end
        end
    end

    -- 4. 旋转逻辑
    if _G.SpinSpeed > 0 then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(_G.SpinSpeed), 0)
        end
    end
end)

Window:Notify({Title = "剑杰 Hub", Content = "暴力调节已生效：红色范围已开启", Duration = 3})
