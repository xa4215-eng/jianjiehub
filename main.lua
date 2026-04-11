-- [[ 剑杰 · 内部辅助 - 核心通用版 ]]
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

-- 悬浮按钮
Window:EditOpenButton({
    Title = "剑杰",
    Icon = "shrine",
    Color = ColorSequence.new(Color3.fromHex("FF0000"), Color3.fromHex("0000FF"))
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 【通用功能项目】 - 暴力核心
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用功能", Icon = "zap" })

-- 1. 自动锁定 (Aimbot)
_G.Aimbot = false
GeneralTab:Toggle({
    Title = "自动锁定 (锁定最近玩家)",
    Value = false,
    Callback = function(state)
        _G.Aimbot = state
        task.spawn(function()
            while _G.Aimbot do
                local closest = nil
                local dist = math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then
                            dist = d
                            closest = v
                        end
                    end
                end
                if closest then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
                end
                task.wait()
            end
        end)
    end
})

-- 2. 移动加速 (WalkSpeed)
GeneralTab:Slider({
    Title = "移动速度调节",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        _G.SpeedValue = v
        task.spawn(function()
            while _G.SpeedValue == v do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = v
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- 3. 名字透视 (暗白色源码风格)
_G.NameESP = false
GeneralTab:Toggle({
    Title = "玩家透视 (暗白名字)",
    Value = false,
    Callback = function(state)
        _G.NameESP = state
        if state then
            task.spawn(function()
                while _G.NameESP do
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                            if not v.Character.Head:FindFirstChild("JianJieNameTag") then
                                local bill = Instance.new("BillboardGui", v.Character.Head)
                                bill.Name = "JianJieNameTag"
                                bill.AlwaysOnTop = true
                                bill.Size = UDim2.new(0, 100, 0, 50)
                                bill.Adornee = v.Character.Head
                                bill.ExtentsOffset = Vector3.new(0, 3, 0)

                                local label = Instance.new("TextLabel", bill)
                                label.BackgroundTransparency = 1
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.Text = v.Name
                                label.TextColor3 = Color3.fromRGB(210, 210, 210) -- 暗白色
                                label.TextStrokeTransparency = 0.6
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character.Head:FindFirstChild("JianJieNameTag") then
                    v.Character.Head.JianJieNameTag:Destroy()
                end
            end
        end
    end
})

-- 4. 攻击范围 (M1 Reach)
GeneralTab:Slider({
    Title = "攻击范围调节",
    Min = 1,
    Max = 100,
    Default = 5,
    Callback = function(v)
        _G.ReachValue = v
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()
        end)
    end
})

-- 5. 碰撞箱旋转 (SpinBot)
GeneralTab:Toggle({
    Title = "碰撞箱旋转 (SpinBot)",
    Value = false,
    Callback = function(state)
        _G.SpinBot = state
        task.spawn(function()
            while _G.SpinBot do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
                end
                task.wait()
            end
        end)
    end
})

-- 弹窗提示
Window:Notify({
    Title = "剑杰 Hub",
    Content = "通用暴力功能已全部加载完成",
    Duration = 5
})
