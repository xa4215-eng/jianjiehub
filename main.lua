-- [[ 剑杰 · 内部辅助 (全源集成版) ]]
-- 核心库加载
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 窗口初始化
local Window = WindUI:CreateWindow({
    Title = "剑杰 · 内部辅助",
    Icon = "rbxassetid://4483362748",
    Author = "剑杰",
    Folder = "JianJieHub",
    Size = UDim2.fromOffset(550, 400),
    Transparent = true,
    Theme = "Dark", -- 深色主题更显专业
})

-- 悬浮按钮设置
Window:EditOpenButton({
    Title = "剑杰",
    Icon = "shrine",
    Color = ColorSequence.new(Color3.fromHex("FF0000"), Color3.fromHex("0000FF"))
})

-- 获取核心服务
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ==========================================
-- 游戏判定逻辑
-- ==========================================

if game.PlaceId == 10449761463 or game.GameId == 3833109746 then
    -- 【最强战场 TSB 专项页面】
    local TSBTab = Window:Tab({ Title = "最强战场", Icon = "swords" })

    -- 1. M1 范围增强 (提取自你发的源码)
    _G.M1Reach = false
    TSBTab:Toggle({
        Title = "M1 攻击范围增强",
        Value = false,
        Callback = function(state)
            _G.M1Reach = state
            if state then
                task.spawn(function()
                    while _G.M1Reach do
                        pcall(function()
                            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kietba/Kietba/refs/heads/main/M1%20Reach%20Rework"))()
                        end)
                        task.wait(5)
                    end
                end)
            end
        end
    })

    -- 2. 自动京都连招 (提取自你发的源码)
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

    -- 3. 无视硬直 (汉化自 No Stun)
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

    -- 4. 移除侧闪后摇 (汉化自 No Slide End Lag)
    TSBTab:Button({
        Title = "移除侧闪后摇",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Slaphello/No-endlag-side-dash/refs/heads/main/No%20endlag%20side%20dash"))()
            Window:Notify({Title = "成功", Content = "后摇已移除", Duration = 2})
        end
    })

elseif game.PlaceId == 3101667897 or game.GameId == 1055370217 then
    -- 【极速传奇专项页面】
    local SpeedTab = Window:Tab({ Title = "极速传奇", Icon = "zap" })

    _G.AutoSteps = false
    SpeedTab:Toggle({
        Title = "自动刷步数",
        Value = false,
        Callback = function(state)
            _G.AutoSteps = state
            task.spawn(function()
                while _G.AutoSteps do
                    game:GetService("ReplicatedStorage").API:FindFirstChild("walkRemote"):FireServer()
                    task.wait()
                end
            end)
        end
    })

else
    -- 【其他游戏显示通用菜单】
    local GeneralTab = Window:Tab({ Title = "通用功能", Icon = "settings" })

    GeneralTab:Slider({
        Title = "行走速度",
        Min = 16,
        Max = 300,
        Default = 16,
        Callback = function(v)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = v
            end
        end
    })

    GeneralTab:Button({
        Title = "运行未还原脚本 (TSB)",
        Callback = function()
            -- 这里放你那个未还原文本的 loadstring 链接
            Window:Notify({Title = "启动", Content = "正在加载加密插件...", Duration = 3})
        end
    })
end

-- 加载成功提示
Window:Notify({
    Title = "剑杰 Hub 加载成功",
    Content = "已识别当前游戏并适配功能",
    Duration = 5
})