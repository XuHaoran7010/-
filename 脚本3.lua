-- 许领导脚本 V1
-- 直接复制运行即可

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- 等待角色
local Char, Humanoid, Root
local Orig = {WalkSpeed = 16, JumpPower = 50}

local function GetChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Humanoid = Char:WaitForChild("Humanoid")
    Root = Char:WaitForChild("HumanoidRootPart")
    if Humanoid then
        Orig.WalkSpeed = Humanoid.WalkSpeed
        Orig.JumpPower = Humanoid.JumpPower
    end
end
GetChar()
LP.CharacterAdded:Connect(GetChar)

-- 功能状态
local Toggle = {
    Fly = false,
    Noclip = false,
    ESP = false,
    Aimbot = false,
    Speed = false,
    SuperJump = false,
    InfiniteJump = false,
    GodMode = false,
    OneHit = false,
    NightVision = false
}

local FlySpeed = 50
local AimRange = 200
local ESPColor = Color3.fromRGB(255, 0, 0)
local FlyDir = Vector3.new(0, 0, 0)

-- 删除旧GUI
if LP.PlayerGui:FindFirstChild("XuLeaderGui") then
    LP.PlayerGui.XuLeaderGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "XuLeaderGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = LP:WaitForChild("PlayerGui")

-- 主框架
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 380, 0, 480)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- 边框
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 120, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = main

-- 顶部
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 44)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
top.BackgroundTransparency = 0.3
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "✦ 许领导脚本"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

-- 最小化
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 28, 0, 28)
minimize.Position = UDim2.new(1, -68, 0.5, -14)
minimize.Text = "─"
minimize.TextColor3 = Color3.fromRGB(200, 200, 220)
minimize.TextSize = 20
minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
minimize.BackgroundTransparency = 0.5
minimize.BorderSizePixel = 0
minimize.Parent = top
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

-- 关闭
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -36, 0.5, -14)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
close.BackgroundTransparency = 0.5
close.BorderSizePixel = 0
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- 内容
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, 0, 1, -44)
content.Position = UDim2.new(0, 0, 0, 44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 500)
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
content.Parent = main

-- 创建开关
local function MakeToggle(parent, name, y, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 40)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(220, 220, 240)
    l.TextSize = 14
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 50, 0, 28)
    b.Position = UDim2.new(1, -55, 0.5, -14)
    b.Text = "关"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    b.BorderSizePixel = 0
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "开" or "关"
        b.BackgroundColor3 = state and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(50, 50, 70)
        cb(state)
    end)
    return b
end

-- 创建滑块
local function MakeSlider(parent, name, y, min, max, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 50)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0.4, 0)
    l.BackgroundTransparency = 1
    l.Text = name..": "..tostring(default)
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, 0, 0, 6)
    s.Position = UDim2.new(0, 0, 1, -12)
    s.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    s.BorderSizePixel = 0
    s.Parent = f
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = s
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local d = Instance.new("TextButton")
    d.Size = UDim2.new(0, 18, 0, 18)
    d.Position = UDim2.new((default-min)/(max-min), -9, 0, -6)
    d.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    d.BorderSizePixel = 0
    d.Text = ""
    d.Parent = s
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local value = default

    d.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((i.Position.X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            value = min + (max-min) * p
            fill.Size = UDim2.new(p, 0, 1, 0)
            d.Position = UDim2.new(p, -9, 0, -6)
            l.Text = name..": "..math.floor(value+0.5)
            cb(math.floor(value+0.5))
        end
    end)
    return value
end

-- 添加功能按钮
local y = 5
MakeToggle(content, "✈️ 飞行模式", y, function(s) 
    Toggle.Fly = s
    if not s then FlyDir = Vector3.new(0,0,0) end
    if Humanoid then Humanoid.PlatformStand = s end
end)
y = y + 45
MakeSlider(content, "飞行速度", y, 10, 200, 50, function(v) FlySpeed = v end)
y = y + 55
MakeToggle(content, "🧱 穿墙", y, function(s) Toggle.Noclip = s end)
y = y + 45
MakeToggle(content, "🎯 自瞄", y, function(s) Toggle.Aimbot = s end)
y = y + 45
MakeSlider(content, "自瞄范围", y, 50, 500, 200, function(v) AimRange = v end)
y = y + 55
MakeToggle(content, "💨 加速", y, function(s) 
    Toggle.Speed = s
    if Humanoid then Humanoid.WalkSpeed = s and 50 or Orig.WalkSpeed end
end)
y = y + 45
MakeToggle(content, "🦘 超级跳", y, function(s)
    Toggle.SuperJump = s
    if Humanoid then Humanoid.JumpPower = s and 100 or Orig.JumpPower end
end)
y = y + 45
MakeToggle(content, "♾️ 无限跳跃", y, function(s) Toggle.InfiniteJump = s end)
y = y + 45
MakeToggle(content, "🛡️ 锁血", y, function(s) Toggle.GodMode = s end)
y = y + 45
MakeToggle(content, "💀 一击必杀", y, function(s) Toggle.OneHit = s end)
y = y + 45
MakeToggle(content, "👁️ 透视", y, function(s) Toggle.ESP = s end)
y = y + 45
MakeToggle(content, "🌙 夜视", y, function(s)
    Toggle.NightVision = s
    if s then
        game:GetService("Lighting").Brightness = 5
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
    end
end)

-- 窗口拖动
local dragging = false
local dragStart, startPos

top.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 最小化
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = minimized and UDim2.new(0, 380, 0, 44) or UDim2.new(0, 380, 0, 480)
    }):Play()
    minimize.Text = minimized and "□" or "─"
end)

-- 关闭
close.MouseButton1Click:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = Orig.WalkSpeed
        Humanoid.JumpPower = Orig.JumpPower
    end
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("ESP_Highlight")
            if h then h:Destroy() end
        end
    end
    gui:Destroy()
end)

-- F1 隐藏菜单
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    end
end)

-- 键盘控制飞行
UIS.InputBegan:Connect(function(i)
    if Toggle.Fly then
        if i.KeyCode == Enum.KeyCode.Space then FlyDir = FlyDir + Vector3.new(0, 1, 0) end
        if i.KeyCode == Enum.KeyCode.W then FlyDir = FlyDir + Vector3.new(0, 0, -1) end
        if i.KeyCode == Enum.KeyCode.S then FlyDir = FlyDir + Vector3.new(0, 0, 1) end
        if i.KeyCode == Enum.KeyCode.A then FlyDir = FlyDir + Vector3.new(-1, 0, 0) end
        if i.KeyCode == Enum.KeyCode.D then FlyDir = FlyDir + Vector3.new(1, 0, 0) end
    end
end)

UIS.InputEnded:Connect(function(i)
    if Toggle.Fly then
        if i.KeyCode == Enum.KeyCode.Space then FlyDir = FlyDir - Vector3.new(0, 1, 0) end
        if i.KeyCode == Enum.KeyCode.W then FlyDir = FlyDir - Vector3.new(0, 0, -1) end
        if i.KeyCode == Enum.KeyCode.S then FlyDir = FlyDir - Vector3.new(0, 0, 1) end
        if i.KeyCode == Enum.KeyCode.A then FlyDir = FlyDir - Vector3.new(-1, 0, 0) end
        if i.KeyCode == Enum.KeyCode.D then FlyDir = FlyDir - Vector3.new(1, 0, 0) end
    end
end)

-- 无限跳跃
UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space and Toggle.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 主循环
RS.Heartbeat:Connect(function()
    local c = LP.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local h = c:FindFirstChild("Humanoid")
    if not h then return end

    -- 飞行
    if Toggle.Fly then
        local cam = WS.CurrentCamera
        local lv = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        local rv = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
        local md = Vector3.new(0, 0, 0)
        if FlyDir.Z < 0 then md = md + lv elseif FlyDir.Z > 0 then md = md - lv end
        if FlyDir.X < 0 then md = md - rv elseif FlyDir.X > 0 then md = md + rv end
        if md.Magnitude > 0 then md = md.Unit * FlySpeed end
        r.Velocity = Vector3.new(md.X, FlyDir.Y * 10, md.Z)
    end

    -- 穿墙
    if Toggle.Noclip then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    else
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end

    -- 自瞄
    if Toggle.Aimbot then
        local closest, dist = nil, AimRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local d = (tr.Position - r.Position).Magnitude
                    if d < dist then dist, closest = d, p end
                end
            end
        end
        if closest and closest.Character then
            local tr = closest.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local head = closest.Character:FindFirstChild("Head")
                local tp = head and head.Position or tr.Position
                local cam = WS.CurrentCamera
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, cam.CFrame.Position + (tp - cam.CFrame.Position).Unit)
            end
        end
    end

    -- 锁血
    if Toggle.GodMode and h then
        h.MaxHealth = math.huge
        h.Health = math.huge
    else
        if h then
            h.MaxHealth = 100
            if h.Health > 100 then h.Health = 100 end
        end
    end

    -- 透视
    if Toggle.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local hl = tr:FindFirstChild("ESP_Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ESP_Highlight"
                        hl.Parent = tr
                        hl.FillColor = ESPColor
                        hl.FillTransparency = 0.3
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.OutlineTransparency = 0.1
                    end
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("ESP_Highlight")
                if hl then hl:Destroy() end
            end
        end
    end

    -- 一击必杀
    if Toggle.OneHit then
        for _, tool in pairs(c:GetChildren()) do
            if tool:IsA("Tool") then
                for _, child in pairs(tool:GetDescendants()) do
                    if child:IsA("NumberValue") and child.Name == "Damage" then
                        child.Value = 999999
                    end
                end
            end
        end
    end

    -- 保持加速和超级跳
    if Toggle.Speed and h then
        h.WalkSpeed = 50
    end
    if Toggle.SuperJump and h then
        h.JumpPower = 100
    end
end)

print("✅ 许领导脚本已加载！按 F1 隐藏/显示菜单")