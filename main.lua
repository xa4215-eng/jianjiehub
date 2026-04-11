-- [[ 剑杰 · 内部辅助 (极速流畅版) ]]
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

-- 悬浮按钮
Window:EditOpenButton({
    Title = "剑杰",
    Icon = "shrine",
    Color = ColorSequence.new(Color3.fromHex("FF0000"), Color3.fromHex("0000FF"))
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ==========================================
-- 项目一：通用功能
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用暴力", Icon = "zap" })
local VisualTab = Window:Tab({ Title = "视觉透视", Icon = "eye" })

-- 1. 速度调节
GeneralTab:Slider({
    Title = "移动速度 (WalkSpeed)",
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

-- 2. 自瞄锁定 (锁定最近目标)
_G.Aimbot = false
GeneralTab:Toggle({
    Title = "自动锁定最近目标",
    Value = false,
    Callback = function(state)
        _G.Aimbot = state
        task.spawn(function()
            while _G.Aimbot do
                local closest = nil
                local dist = math.huge
                for _, v in pairs(game.Players:GetPlayers()) do
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

-- 3. 攻击范围 (M1 Reach)
GeneralTab:Slider({
    Title = "攻击距离 (M1)",
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

-- 4. 碰撞箱旋转 (SpinBot)
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

-- 5. 暗白色名字透视 (源码风格，不卡顿)
VisualTab:Toggle({
    Title = "开启玩家名字透视",
    Value = false,
    Callback = function(state)
        _G.NameESP = state
        if state then
            task.spawn(function()
                while _G.NameESP do
                    for _, v in pairs(game.Players:GetPlayers()) do
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
                                -- 使用暗白色 (200, 200, 200)
                                label.TextColor3 = Color3.fromRGB(200, 200, 200) 
                                label.TextStrokeTransparency = 0.5 -- 稍微带一点描边更好看
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character.Head:FindFirstChild("JianJieNameTag") then
                    v.Character.Head.JianJieNameTag:Destroy()
                end
            end
        end
    end
})

-- ==========================================
-- 项目二：最强战场 (TSB) 专项功能
-- ==========================================
if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    local TSBTab = Window:Tab({ Title = "TSB 专属项目", Icon = "swords" })

    TSBTab:Button({
        Title = "一键执行: 京都连招",
        Callback = function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Communicate") then
                pcall(function()
                    local args = {[1] = {["Tool"] = LocalPlayer.Backpack:FindFirstChild("Flowing Water"), ["Goal"] = "Console Move"}}
                    char.Communicate:FireServer(unpack(args))
                    task.wait(2.15)
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local forward = hrp.CFrame.LookVector.Unit
                        local goalPos = hrp.Position + forward * 20
                        hrp.CFrame = CFrame.new(goalPos, goalPos + forward)
                        task.wait(0.1)
                        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(180), 0)
                    end
                end)
            else
                Window:Notify({Title = "提示", Content = "请先装备流水岩碎拳", Duration = 3})
            end
        end
    })

    TSBTab:Toggle({
        Title = "去除受击硬直 (No Stun)",
        Value = false,
        Callback = function(state)
            _G.NoStun = state
            if state then
                _G.StunLoop = RunService.RenderStepped:Connect(function()
                    local char = LocalPlayer.Character
                    if char then
                        if char:FindFirstChild("Stunned") then char.Stunned:Destroy() end
                        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
                    end
                end)
            else
                if _G.StunLoop then _G.StunLoop:Disconnect() end
            end
        end
    })
end
