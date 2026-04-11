-- [[ 剑杰 · 内部辅助 (全能暴力版) ]]
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 窗口初始化
local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(550, 420),
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
-- 第一部分：通用暴力功能 (放在最上面)
-- ==========================================
local GeneralTab = Window:Tab({ Title = "通用暴力", Icon = "zap" })
local VisualTab = Window:Tab({ Title = "视觉透视", Icon = "eye" })

-- 1. 跑步加速
GeneralTab:Slider({
    Title = "移动速度调节",
    Min = 16,
    Max = 200,
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

-- 3. 攻击范围增强
GeneralTab:Slider({
    Title = "攻击范围 (M1 Reach)",
    Min = 1,
    Max = 50,
    Default = 5,
    Callback = function(v)
        _G.ReachValue = v
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()
        end)
    end
})

-- 4. 玩家透视
VisualTab:Toggle({
    Title = "开启玩家 ESP (高亮)",
    Value = false,
    Callback = function(state)
        _G.ESPEnabled = state
        if state then
            task.spawn(function()
                while _G.ESPEnabled do
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character then
                            if not v.Character:FindFirstChild("JianJieESP") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "JianJieESP"
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.FillAlpha = 0.5
                                highlight.Parent = v.Character
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("JianJieESP") then
                    v.Character.JianJieESP:Destroy()
                end
            end
        end
    end
})

-- ==========================================
-- 第二部分：最强战场 (TSB) 专项功能 (放在下面)
-- ==========================================
if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    local TSBTab = Window:Tab({ Title = "TSB 专属", Icon = "swords" })

    -- 自动京都连招
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

    -- 无视硬直
    _G.NoStun = false
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

    -- 变身垃圾桶
    TSBTab:Button({
        Title = "整活：变身垃圾桶",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xa4215-eng/jianjiehub/main/trashcan.lua"))()
        end
    })
end

-- 加载成功提示
Window:Notify({
    Title = "剑杰 Hub 已就绪",
    Content = "通用暴力与专项功能已加载",
    Duration = 5
})
