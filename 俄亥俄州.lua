local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/454244513/WindUIFix/refs/heads/main/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "tnine team",
    Author = "by messy/pig hacker",
    Folder = "HackerHub",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 135,
    ScrollBarEnabled = true,
    --Background = "",
    BackgroundImageTransparency = 0.65,
})

Window:EditOpenButton({
    Title = "免费用户",
    --Icon = "",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2.35,
    Color = ColorSequence.new(
        Color3.fromHex("3C1361"),
        Color3.fromHex("6A0DAD")
    ),
    Draggable = true,
})

local Tabs = {}

do
    Tabs.BladeSection = Window:Section({
        Title = "杀戮类",
        Opened = true,
    })
    
    Tabs.MoneySection = Window:Section({
        Title = "主要类",
        Opened = true,
    })
    
    Tabs.ProSection = Window:Section({
        Title = "防护类",
        Opened = true,
    })
    
    Tabs.ConfigSection = Window:Section({
        Title = "次要类",
        Opened = true,
    })
    
    Tabs.ACSection = Window:Section({
        Title = "活动类",
        Opened = true,
    })
    
    Tabs.BladeTab = Tabs.BladeSection:Tab({ Title = "杀戮光环", Icon = "crown" })
    Tabs.MoneyTab = Tabs.MoneySection:Tab({ Title = "刷钱类", Icon = "crown" })
    Tabs.BypassTab = Tabs.MoneySection:Tab({ Title = "绕过类", Icon = "crown" })
    Tabs.ProTab = Tabs.ProSection:Tab({ Title = "防护类", Icon = "crown" })
    Tabs.PlayerTab = Tabs.ConfigSection:Tab({ Title = "通用类", Icon = "crown" })
    Tabs.MMMTab = Tabs.ConfigSection:Tab({ Title = "快捷美化类", Icon = "crown" })
    Tabs.MHTab = Tabs.ConfigSection:Tab({ Title = "自定义美化类", Icon = "crown" })
    Tabs.ACTab = Tabs.ACSection:Tab({ Title = "春节活动", Icon = "crown" })
end

Window:SelectTab(1)

_G.HealthThreshold = 0
_G.BladeAuraEnabled = false

local AutoArmor = false
local autokz = false
local healThread = nil
local AutoKnockReset = false
local antiKBEnabled = false
local sudu = nil
local Speed = 1
local jumpConn = nil
local skinvoid = false
local autoskin = false
local skinsec = ""

Tabs.BladeTab:Paragraph({
    Title = "使用须知",
    Desc = "忍者飞镖光环需使用的时候 先将原来的忍者飞镖丢弃 然后再点击自动购买 再开启其余功能 即可使用",
    Image = "sword",
    ImageSize = 42,
})

Tabs.BladeTab:Paragraph({
    Title = "关于作者",
    Desc = "此公益脚本来自messy 认准messy的一切公益项目  QQ群号717897412",
    Image = "sword",
    ImageSize = 42,
})

local plrs = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local lp = plrs.LocalPlayer

local dvv = require(rs.devv)
local sig = dvv.load("Signal")
local guid = dvv.load("GUID")
local inv = dvv.load("v3item").inventory

local dartOn = false
local dartTeleportTargets = false
local dartCachedHitId = nil
local dartCurrentTarget = nil
local dartHeartConnections = {}
local dartNinjaStarBuyThread = nil

getgenv().TrailColors = {
    StartColor = Color3.fromRGB(200, 180, 255),
    EndColor = Color3.fromRGB(140, 100, 220),
    MiddleColor1 = Color3.fromRGB(180, 150, 240),
    MiddleColor2 = Color3.fromRGB(160, 130, 230)
}

local function createBeautifulTrail(origin, targetPos)
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "MagicTrail"
    trailContainer.Parent = Workspace
    
    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
    
    local function createBezierCurve(p0, p1, p2, t)
        return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
    end
    
    local curvePoints = {}
    local numSegments = 20
    
    for i = 0, numSegments do
        local t = i / numSegments
        local point = createBezierCurve(origin, controlPoint, targetPos, t)
        table.insert(curvePoints, point)
    end
    
    for i = 1, #curvePoints - 1 do
        local startPoint = curvePoints[i]
        local endPoint = curvePoints[i + 1]
        local distance = (endPoint - startPoint).Magnitude
        
        local beamPart = Instance.new("Part")
        beamPart.Size = Vector3.new(0.15, 0.15, distance)
        beamPart.Anchored = true
        beamPart.CanCollide = false
        beamPart.Material = Enum.Material.Neon
        beamPart.Transparency = 0.3
        beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
        beamPart.Parent = trailContainer
        
        local t = i / (#curvePoints - 1)
        local color
        if t < 0.3 then
            color = getgenv().TrailColors.StartColor or Color3.fromRGB(200, 180, 255)
        elseif t < 0.6 then
            color = getgenv().TrailColors.MiddleColor1 or Color3.fromRGB(180, 150, 240)
        elseif t < 0.9 then
            color = getgenv().TrailColors.MiddleColor2 or Color3.fromRGB(160, 130, 230)
        else
            color = getgenv().TrailColors.EndColor or Color3.fromRGB(140, 100, 220)
        end
        
        beamPart.Color = color
        
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 5
        pointLight.Range = 3
        pointLight.Color = color
        pointLight.Parent = beamPart
        
        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Transparency = NumberSequence.new(0.3, 0.8)
        particles.Lifetime = NumberRange.new(0.5, 1)
        particles.Rate = 50
        particles.Speed = NumberRange.new(1, 2)
        particles.VelocitySpread = 180
        particles.Color = ColorSequence.new(color)
        particles.Parent = beamPart
    end
    
    task.delay(1.5, function()
        if trailContainer and trailContainer.Parent then
            trailContainer:Destroy()
        end
    end)
    
    return trailContainer
end

local function dartCleanupConnections()
    for _, conn in ipairs(dartHeartConnections) do
        if conn then conn:Disconnect() end
    end
    dartHeartConnections = {}
end

local function dartEquipNinjaStar()
    local itm = inv.getItems and inv.getItems() or inv.items or {}
    for _, v in next, itm do
        if v.name == "Ninja Star" then
            sig.FireServer("equip", v.guid)
            return v.guid
        end
    end
    return nil
end

local function dartInitThrow()
    local sg = dartEquipNinjaStar()
    if not sg then return end
    
    local c = lp.Character
    if not c then return end
    
    local rh = c:FindFirstChild("RightHand")
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not rh or not hrp then return end
    
    local mp = rh.Position + Vector3.new(0, 0.5, 0)
    local tp = mp + Vector3.new(50, 0, 0)
    local vel = (tp - mp).Unit * 150
    
    createBeautifulTrail(mp, tp)
    
    local ok, r1, hid = pcall(function()
        return sig.InvokeServer("throwSticky", guid(), "Ninja Star", sg, vel, tp)
    end)
    
    if ok and r1 and hid then
        dartCachedHitId = hid
    end
end

local function dartHasShield(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local char = targetPlayer.Character
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    for _, desc in pairs(char:GetDescendants()) do
        if desc:IsA("ForceField") then
            return true
        end
    end
    
    return false
end

local function dartFindValidTarget()
    local closest = nil
    local minDist = math.huge
    local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
    
    if not myPos then return nil end
    
    for _, player in ipairs(plrs:GetPlayers()) do
        if player ~= lp and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and head and hrp and humanoid.Health > 0 and not dartHasShield(player) then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < minDist and dist <= 50 then
                    minDist = dist
                    closest = {player = player, head = head}
                end
            end
        end
    end
    return closest
end

local function dartRapidThrowAttack()
    if not dartOn or not dartCachedHitId then return end
    
    local targetData = dartFindValidTarget()
    if not targetData then return end
    
    local head = targetData.head 
    local tp = head.Position
    local wcf = CFrame.new(tp, tp + Vector3.new(0, 1, 0))
    local rcf = CFrame.new(0, 0, 0)
    
    local c = lp.Character
    if c and c:FindFirstChild("RightHand") then
        local rh = c:FindFirstChild("RightHand")
        createBeautifulTrail(rh.Position, tp)
    end
    
    for i = 1, 15 do 
        sig.InvokeServer("hitSticky", dartCachedHitId, head, rcf, wcf)
    end
end

local function dartFindNextTeleportTarget()
    local players = plrs:GetPlayers()
    
    for _, player in ipairs(players) do
        if player ~= lp and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 and not dartHasShield(player) then
                return player
            end
        end
    end
    return nil
end

local function dartFastTeleport()
    if not dartTeleportTargets or not dartOn then return end
    
    if not dartCurrentTarget then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    if not dartCurrentTarget.Character then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    local humanoid = dartCurrentTarget.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 or dartHasShield(dartCurrentTarget) then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    local char = lp.Character
    if not char or not char.PrimaryPart then return end
    
    local targetChar = dartCurrentTarget.Character
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    char.PrimaryPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
end

Tabs.BladeTab:Toggle({
    Title = "忍者飞镖光环",
    Default = false,
    Callback = function(state)
        dartOn = state
        dartCleanupConnections()
        
        if state then
            dartEquipNinjaStar()
            task.wait(0.1)
            dartInitThrow()
            
            local fastAttackConn = runService.RenderStepped:Connect(function()
                if not dartOn then return end
                dartRapidThrowAttack()
            end)
            table.insert(dartHeartConnections, fastAttackConn)
        end
    end
})

Tabs.BladeTab:Toggle({
    Title = "传送攻击(需打开忍者飞镖光环)",
    Default = false,
    Callback = function(state)
        dartTeleportTargets = state
        
        if state and dartOn then
            local fastTeleportConn = runService.RenderStepped:Connect(function()
                dartFastTeleport()
            end)
            table.insert(dartHeartConnections, fastTeleportConn)
            
            WindUI:Notify({
                Title = "TPattack",
                Content = "open",
                Duration = 2,
                Icon = "zap"
            })
        elseif state then
            local checkConnection
            checkConnection = runService.Heartbeat:Connect(function()
                if dartOn then
                    checkConnection:Disconnect()
                    local fastTeleportConn = runService.RenderStepped:Connect(function()
                        dartFastTeleport()
                    end)
                    table.insert(dartHeartConnections, fastTeleportConn)
                elseif not dartTeleportTargets then
                    checkConnection:Disconnect()
                end
            end)
        end
    end
})

Tabs.BladeTab:Toggle({
    Title = "自动购买忍者飞镖",
    Default = false,
    Callback = function(state)
        if dartNinjaStarBuyThread then
            dartNinjaStarBuyThread:Disconnect()
            dartNinjaStarBuyThread = nil
        end
        if state then
            local heartbeat = game:GetService("RunService").Heartbeat
            dartNinjaStarBuyThread = heartbeat:Connect(function()
                sig.InvokeServer("attemptPurchase", "Ninja Star")
                for _, v in next, inv.items do
                    if v.name == "Ninja Star" then
                        break
                    end
                end
            end)
        end
    end
})

local originalOnDestroy = Window.OnDestroy or function() end
Window.OnDestroy = function(...)
    originalOnDestroy(...)
    dartCleanupConnections()
    if dartNinjaStarBuyThread then
        dartNinjaStarBuyThread:Disconnect()
        dartNinjaStarBuyThread = nil
    end
end

Tabs.BladeTab:Toggle({
    Title = "香蕉光环",
    Default = false,
    Callback = function(state)
        _G.AuraEnabled = state
        if not state then _G.TargetId = nil end
    end
})

Tabs.BladeTab:Toggle({
    Title = "战斧光环",
    Default = false,
    Callback = function(state)
        _G.BladeAuraEnabled = state
    end
})

Tabs.BladeTab:Slider({
    Title = "不攻击生命值",
    Value = {
        Min = 0,
        Max = 25,
        Default = 0,
    },
    Callback = function(value)
        _G.HealthThreshold = value
    end
})

local devv = ReplicatedStorage:WaitForChild("devv")
local load = require(devv).load
local FireServer = load("Signal").FireServer
local InvokeServer = load("Signal").InvokeServer
local GUID = load("GUID")
local Raycast = load("Raycast")
local v3item = load("v3item")
local inventory = v3item.inventory

_G.TargetId = nil
local lastAttack = 0
local lastAmmo = 0

local function getTarget()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local target, dist = nil, 150
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health >= _G.HealthThreshold then
                local d = (root.Position - tRoot.Position).Magnitude
                if d < dist then
                    dist = d
                    target = plr
                end
            end
        end
    end
    return target
end

local function hackthrow(plr, itemname, itemguid, velocity, epos)
    if plr ~= LocalPlayer then
        return
    end
    task.spawn(function()
        local throwGuid = GUID()
        local char = plr.Character
        if char and char:FindFirstChild("RightHand") then
            local hand = char:FindFirstChild("RightHand")
            createBeautifulTrail(hand.Position, epos)
        end
        
        local success, stickyId = InvokeServer("throwSticky", throwGuid, itemname, itemguid, velocity, epos)
        if not success then
            return
        end
        local dummyPart = Instance.new("Part")
        dummyPart.Size = Vector3.new(2, 2, 2)
        dummyPart.Position = epos
        dummyPart.Anchored = true
        dummyPart.Transparency = 1
        dummyPart.CanCollide = true
        dummyPart.Parent = workspace
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = { plr.Character, workspace.Game.Local, workspace.Game.Drones }
        local dist = (epos - plr.Character.Head.Position).Magnitude
        local rayResult = workspace:Raycast(
            plr.Character.Head.Position,
            (epos - plr.Character.Head.Position).Unit * (dist + 5),
            rayParams
        )
        if rayResult and rayResult.Instance then
            local hitPart = rayResult.Instance
            local relativeHitCFrame = hitPart.CFrame:ToObjectSpace(CFrame.new(rayResult.Position, rayResult.Position + rayResult.Normal))
            local stickyCFrame = CFrame.new(rayResult.Position)
            if dummyPart.Parent then
                dummyPart:Destroy()
            end
            _G.throwargs = {
                "hitSticky",
                stickyId or throwGuid,
                hitPart,
                relativeHitCFrame,
                stickyCFrame,
            }
            InvokeServer("hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame)
        else
            if dummyPart.Parent then
                dummyPart:Destroy()
            end
        end
    end)
end

local function getinventory()
    return inventory.items
end

local function finditem(string)
    for guid, data in next, getinventory() do
        if data.name == string or data.type == string or data.subtype == string then
            return data
        end
    end
end

local function executebladekill(plr, head)
    local item = finditem("Tomahawk")
    if item then
        FireServer("equip", item.guid)

        if not _G.throwargs then
            local char = LocalPlayer.Character
            if not char then return end
            local hand = char:FindFirstChild("RightHand")
            if not hand then return end
            
            local spos = hand.Position
            local epos = head.Position
            local velocity = (epos - spos).Unit * ((spos - epos).Magnitude * 15)
            createBeautifulTrail(spos, epos)
            task.spawn(InvokeServer, "attemptPurchaseAmmo", "Tomahawk")
            hackthrow(LocalPlayer, "Tomahawk", item.guid, velocity, epos)
        end

        if _G.throwargs then
            _G.throwargs[3] = head
            task.spawn(InvokeServer, unpack(_G.throwargs))
        end
    else
        task.spawn(InvokeServer, "attemptPurchase", "Tomahawk")
    end
end

local function attack(plr)
    local now = tick()
    if now - lastAttack < 0.03 then return end
    lastAttack = now

    local tChar = plr.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health < 15 then return end

    task.spawn(function()
        local items = inventory.items or {}
        local banana = nil
        for _, v in next, items do
            if v.name == "Banana Peel" then
                banana = v
                break
            end
        end

        if not banana then
            pcall(function() InvokeServer("attemptPurchase", "Banana Peel") end)
            return
        end

        FireServer("equip", banana.guid)

        local pred = tRoot.AssemblyLinearVelocity * 0.2
        local cf = tRoot.CFrame * CFrame.new(0, -1, 0) + pred
        local rcf = tRoot.CFrame:Toconnection:Disconnect()
                    return
                end
                
                pcall(function()
                    local player = game:GetService('Players').LocalPlayer
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 35 then
                        local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
                        local hasLightVest = false
                        
                        for i, v in next, b1 do
                            if v.name == "Light Vest" then
                                hasLightVest = true
                                local light = v.guid
                                local armor = player:GetAttribute('armor')
                                if armor == nil or armor <= 0 then
                                    require(game:GetService("ReplicatedStorage").devv).load("Signal").FireServer("equip", light)
                                    require(game:GetService("ReplicatedStorage").devv).load("Signal").FireServer("useConsumable", light)
                                    require(game:GetService("ReplicatedStorage").devv).load("Signal").FireServer("removeItem", light)
                                end
                                break
                            end
                        end
                        
                        if not hasLightVest then
                            require(game:GetService("ReplicatedStorage").devv).load("Signal").InvokeServer("attemptPurchase", "Light Vest")
                        end
                    end
                end)
            end)
        end
    end
})

Tabs.ProTab:Toggle({
    Title = "自动购买面具",
    Value = false,
    Callback = function(state) 
        autokz = state
        if autokz then
            while autokz and task.wait(1) do
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local Mask = character:FindFirstChild("Hockey Mask")
                local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
                local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
                if not Mask then
                    Signal.InvokeServer("attemptPurchase", "Hockey Mask")
                    for i, v in next, b1 do
                        if v.name == "Hockey Mask" then
                            local sugid = v.guid
                            if not Mask then
                                Signal.FireServer("equip", sugid)
                                Signal.FireServer("wearMask", sugid)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
})

Tabs.ProTab:Toggle({
    Title = "自动恢复健康值(回血)",
    Default = false,
    Callback = function(Value)
        if healThread then
            healThread:Disconnect()
            healThread = nil
        end

        if Value then
            local heartbeat = game:GetService("RunService").Heartbeat
            healThread = heartbeat:Connect(function()
                Signal.InvokeServer("attemptPurchase", 'Bandage')
                local inv = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory
                for _, v in next, inv.items do
                    if v.name == 'Bandage' then
                        local bande = v.guid
                        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                        local Humanoid = Character:WaitForChild('Humanoid')
                        if Humanoid.Health >= 5 and Humanoid.Health < Humanoid.MaxHealth then
                            Signal.FireServer("equip", bande)
                            Signal.FireServer("useConsumable", bande)
                            Signal.FireServer("removeItem", bande)
                        end
                        break
                    end
                end
            end)
        end
    end
})

local melee = require(game:GetService("ReplicatedStorage").devv).load("ClientReplicator")
local lp = game:GetService("Players").LocalPlayer

Tabs.ProTab:Toggle({
    Title = "反立",
    Default = false,
    Callback = function(Value)
        AutoKnockReset = Value
        if Value then
            task.spawn(function()
                while AutoKnockReset do
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        melee.Set(lp, "knocked", false)
                        melee.Replicate("knocked")
                    end
                    task.wait()
                end
            end)
        end
    end
})

Tabs.ProTab:Toggle({
    Title = "反击退",
    Default = false,
    Callback = function(Value)
        antiKBEnabled = Value
        task.spawn(function()
            while antiKBEnabled and task.wait(0.1) do
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

Tabs.PlayerTab:Toggle({
    Title = "walkspend(移速修改)",
    Default = false,
    Callback = function(v)
        if v == true then
            sudu = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        elseif not v and sudu then
            sudu:Disconnect()
            sudu = nil
        end
    end
})

Tabs.PlayerTab:Slider({
    Title = "速度设置",
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(Value)
        Speed = Value
    end
})

Tabs.PlayerTab:Toggle({
    Title = "无限跳跃",
    Default = false,
    Callback = function(Value)
        local jumpConn
        if Value then
            jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = game:GetService("Players").LocalPlayer.Character and
                                 game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if jumpConn then
                jumpConn:Disconnect()
                jumpConn = nil
            end
        end
    end
})

local xeniox = {
    Data = {
        Identity = getidentity()
    },
    Helpers = {}
}

local devv = game:GetService("ReplicatedStorage").devv
local load = require(devv).load

xeniox.Helpers.SetIdentity = function(self, identity)
    setidentity(identity)
end

xeniox.Helpers.CallFuncSec = function(self, func, waited)
    self:SetIdentity(2)
    local result, err = pcall(func)
    if not result then
        warn("函数执行错误:", err)
    end
    if waited then
        task.wait(waited)
    end
    self:SetIdentity(xeniox.Data.Identity)
end

Tabs.MMMTab:Toggle({
    Title = "自动购买气球",
    Value = false,
    Callback = function(state)
        if not state then return end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if character:FindFirstChild("Balloon") then return end
        
        local Signal = load("Signal")
        Signal.InvokeServer("attemptPurchase", "Balloon")
        
        task.wait(0.5)
        
        local v3item = load("v3item")
        local inventory = v3item.inventory
        local balloonItem = inventory.getFromName("Balloon")
        
        if balloonItem then
            xeniox.Helpers:CallFuncSec(function()
                balloonItem:SetEquipped(true)
            end)
        end
    end
})

Tabs.MMMTab:Button({
    Title = "美化美金(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Dollar Balloon", 200, true, 0.8, 8, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 4 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Dollar Balloon" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})
Tabs.MMMTab:Button({
    Title = "美化黑玫瑰(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Black Rose", 200, true, 0.75, 12, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0.5, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 3 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Black Rose" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

Tabs.MMMTab:Button({
Title = "美化Kunai(需普通气球)",
Callback = function()
for _, v in pairs(getgc(true)) do
if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
v.name = "Kunai"
v.permanent = true
v.canDrop = true
v.dropCooldown = 120
v.holdableType = "Balloon"
v.movespeedAdd = 12
if v.TPSOffsets then
v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
else
v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
end
if v.viewportOffsets then
if v.viewportOffsets.hotbar then
v.viewportOffsets.hotbar.dist = 3
v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
else
v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
end
if v.viewportOffsets.ammoHUD then
v.viewportOffsets.ammoHUD.dist = 2
v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
else
v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
end
if v.viewportOffsets.slotButton then
v.viewportOffsets.slotButton.dist = 1
v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
else
v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
end
else
v.viewportOffsets = {
hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
}
end
break
end
end
for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
if item.name == "Kunai" then
for _, btn in pairs({item.button, item.backpackButton}) do
if btn and btn.resetModelSkin then btn:resetModelSkin() end
end
end
end
end
})

Tabs.MMMTab:Button({
Title = "美化Spirit Kunai(需普通Kunai)",
Callback = function()
for _, v in pairs(getgc(true)) do
if type(v) == "table" and rawget(v, "name") == "Kunai" and rawget(v, "holdableType") == "Kunai" then
v.name = "Spirit Kunai"
v.permanent = true
v.canDrop = true
v.dropCooldown = 120
v.holdableType = "Kunai"
v.movespeedAdd = 12
if v.TPSOffsets then
v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
else
v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
end
if v.viewportOffsets then
if v.viewportOffsets.hotbar then
v.viewportOffsets.hotbar.dist = 3
v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
else
v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
end
if v.viewportOffsets.ammoHUD then
v.viewportOffsets.ammoHUD.dist = 2
v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
else
v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
end
if v.viewportOffsets.slotButton then
v.viewportOffsets.slotButton.dist = 1
v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
else
v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
end
else
v.viewportOffsets = {
hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
}
end
break
end
end
for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
if item.name == "Spirit Kunai" then
for _, btn in pairs({item.button, item.backpackButton}) do
if btn and btn.resetModelSkin then btn:resetModelSkin() end
end
end
end
end
})

Tabs.MMMTab:Toggle({
    Title = "背包枪械美化虚空",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Void")
                end
            end
        end
    end
})

Tabs.MMMTab:Toggle({
    Title = "背包枪械美化战术",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Tactical")
                end
            end
        end
    end
})

Tabs.MMMTab:Toggle({
    Title = "背包枪械美化赛博",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Cyberpunk")
                end
            end
        end
    end
})

Tabs.MMMTab:Toggle({
    Title = "背包枪械美化黑曜石",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Obsidian")
                end
            end
        end
    end
})

Tabs.MHTab:Dropdown({
    Title = "选择美化皮肤",
    Values = { 
        "烟火", "虚空", "纯金", "暗物质", "反物质", "神秘", "虚空神秘", "战术", "纯金战术", 
        "白未来", "黑未来", "圣诞未来", "礼物包装", "猩红", "收割者", "虚空收割者", "圣诞玩具",
        "荒地", "隐形", "像素", "钻石像素", "黄金零下", "绿水晶", "生物", "樱花", "精英", 
        "黑樱花", "彩虹激光", "蓝水晶", "紫水晶", "红水晶", "零下", "虚空射线", "冰冻钻石",
        "虚空梦魇", "金雪", "爱国者", "MM2", "声望", "酷化", "蒸汽", "海盗", "玫瑰", "黑玫瑰",
        "激光", "烟花", "诅咒背瓜", "大炮", "财富", "黄金大炮", "四叶草", "自由", "黑曜石", "赛博朋克"
    },
    Callback = function(Value) 
        if Value == "烟火" then
            skinsec = "Sparkler"
        elseif Value == "虚空" then
            skinsec = "Void"
        elseif Value == "纯金" then
            skinsec = "Solid Gold"
        elseif Value == "暗物质" then
            skinsec = "Dark Matter"
        elseif Value == "反物质" then
            skinsec = "Anti Matter"
        elseif Value == "神秘" then
            skinsec = "Hystic"
        elseif Value == "虚空神秘" then
            skinsec = "Void Mystic"
        elseif Value == "战术" then
            skinsec = "Tactical"
        elseif Value == "纯金战术" then
            skinsec = "Solid Gold Tactical"
        elseif Value == "白未来" then
            skinsec = "Future White"
        elseif Value == "黑未来" then
            skinsec = "Future Black"
        elseif Value == "圣诞未来" then
            skinsec = "Christmas Future"
        elseif Value == "礼物包装" then
            skinsec = "Gift Wrapped"
        elseif Value == "猩红" then
            skinsec = "Crimson Blood"
        elseif Value == "收割者" then
            skinsec = "Reaper"
        elseif Value == "虚空收割者" then
            skinsec = "Void Reaper"
        elseif Value == "圣诞玩具" then
            skinsec = "Christmas Toy"
        elseif Value == "荒地" then
            skinsec = "Wasteland"
        elseif Value == "隐形" then
            skinsec = "Invisible"
        elseif Value == "像素" then
            skinsec = "Pixel"
        elseif Value == "钻石像素" then
            skinsec = "Diamond Pixel"
        elseif Value == "黄金零下" then
            skinsec = "Frozen-Gold"
        elseif Value == "绿水晶" then
            skinsec = "Atomic Nature"
        elseif Value == "生物" then
            skinsec