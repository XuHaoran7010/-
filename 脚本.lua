--[[
    许领导脚本 V1
    功能：飞天、穿墙、自瞄、加速、超级跳、透视
    快捷键：WASD移动，空格上升
--]]

local Players, UIS, RS, WS = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService"), game:GetService("Workspace")
local Player, Char, Humanoid, Root = Players.LocalPlayer

local function GetChar()
    Char = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Char:WaitForChild("Humanoid")
    Root = Char:WaitForChild("HumanoidRootPart")
end
GetChar()
Player.CharacterAdded:Connect(GetChar)

local Toggle = {Fly=false, Noclip=false, Aimbot=false, Speed=false, Jump=false, ESP=false}
local Orig = {WalkSpeed=Humanoid.WalkSpeed, JumpPower=Humanoid.JumpPower}
local FlyDir, FlySpeed, AimRange = Vector3.new(0,0,0), 50, 200

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset, gui.DisplayOrder, gui.Parent = "XuLeaderGui", false, true, 100, Player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.AnchorPoint, main.Position, main.Size, main.BackgroundColor3, main.BorderSizePixel, main.Parent = Vector2.new(0.5,0.5), UDim2.new(0.5,0,0.5,0), UDim2.new(0.45,0,0.5,0), Color3.fromRGB(26,26,26), 0, gui
Instance.new("UICorner",main).CornerRadius = UDim.new(0,4)

local top = Instance.new("Frame")
top.Size, top.BackgroundColor3, top.BorderSizePixel, top.Parent = UDim2.new(1,0,0,34), Color3.fromRGB(36,36,36), 0, main
Instance.new("UICorner",top).CornerRadius = UDim.new(0,4)

local title = Instance.new("TextLabel")
title.BackgroundTransparency, title.Size, title.Position, title.Font, title.Text, title.TextColor3, title.TextSize, title.TextXAlignment, title.Parent = 1, UDim2.new(1,-70,1,0), UDim2.new(0,10,0,0), Enum.Font.GothamBold, "许领导脚本 V2", Color3.new(1,1,1), 15, Enum.TextXAlignment.Left, top

local minimize, close = Instance.new("TextButton"), Instance.new("TextButton")
minimize.Size, minimize.Position, minimize.Text, minimize.BackgroundColor3, minimize.BorderSizePixel, minimize.Parent = UDim2.fromOffset(18,18), UDim2.new(1,-48,0.5,-9), "", Color3.fromRGB(255,189,46), 0, top
Instance.new("UICorner",minimize).CornerRadius = UDim.new(1,0)
close.Size, close.Position, close.Text, close.BackgroundColor3, close.BorderSizePixel, close.Parent = UDim2.fromOffset(18,18), UDim2.new(1,-24,0.5,-9), "", Color3.fromRGB(255,95,87), 0, top
Instance.new("UICorner",close).CornerRadius = UDim.new(1,0)

local body = Instance.new("ScrollingFrame")
body.BackgroundTransparency, body.Position, body.Size, body.CanvasSize, body.ScrollBarThickness, body.Parent = 1, UDim2.new(0,0,0,34), UDim2.new(1,0,1,-34), UDim2.new(0,0,0,400), 4, main

local function Bounce(obj, orig)
    local t1 = game:GetService("TweenService"):Create(obj, TweenInfo.new(0.12,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size = orig + UDim2.fromOffset(6,6)})
    local t2 = game:GetService("TweenService"):Create(obj, TweenInfo.new(0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size = orig})
    t1:Play(); t1.Completed:Connect(function() t2:Play() end)
end

local function CreateToggle(parent, name, y, cb)
    local f = Instance.new("Frame")
    f.Size, f.Position, f.BackgroundTransparency, f.Parent = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,y), 1, parent
    local l = Instance.new("TextLabel")
    l.Size, l.BackgroundTransparency, l.Text, l.TextColor3, l.TextSize, l.Font, l.TextXAlignment, l.Parent = UDim2.new(0.7,0,1,0), 1, name, Color3.new(1,1,1), 14, Enum.Font.Gotham, Enum.TextXAlignment.Left, f
    local b = Instance.new("TextButton")
    b.Size, b.Position, b.Text, b.TextColor3, b.TextSize, b.Font, b.BackgroundColor3, b.BorderSizePixel, b.Parent = UDim2.new(0,40,0,22), UDim2.new(1,-50,0.5,-11), "关", Color3.new(1,1,1), 12, Enum.Font.GothamBold, Color3.fromRGB(200,50,50), 0, f
    Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)
    local state = false
    b.MouseButton1Click:Connect(function()
        Bounce(b,b.Size); state = not state
        b.Text, b.BackgroundColor3 = state and "开" or "关", state and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        cb(state)
    end)
    return b
end

local function CreateSlider(parent, name, y, min, max, default, cb)
    local f = Instance.new("Frame")
    f.Size, f.Position, f.BackgroundTransparency, f.Parent = UDim2.new(1,-20,0,40), UDim2.new(0,10,0,y), 1, parent
    local l = Instance.new("TextLabel")
    l.Size, l.BackgroundTransparency, l.Text, l.TextColor3, l.TextSize, l.Font, l.TextXAlignment, l.Parent = UDim2.new(1,0,0.5,0), 1, name..": "..default, Color3.new(1,1,1), 13, Enum.Font.Gotham, Enum.TextXAlignment.Left, f
    local s = Instance.new("Frame")
    s.Size, s.Position, s.BackgroundColor3, s.BorderSizePixel, s.Parent = UDim2.new(1,0,0,6), UDim2.new(0,0,1,-10), Color3.fromRGB(50,50,50), 0, f
    Instance.new("UICorner",s).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame")
    fill.Size, fill.BackgroundColor3, fill.BorderSizePixel, fill.Parent = UDim2.new((default-min)/(max-min),0,1,0), Color3.fromRGB(255,189,46), 0, s
    Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)
    local d = Instance.new("TextButton")
    d.Size, d.Position, d.BackgroundColor3, d.BorderSizePixel, d.Text, d.Parent = UDim2.new(0,16,0,16), UDim2.new((default-min)/(max-min),-8,0,-8), Color3.fromRGB(255,189,46), 0, "", s
    Instance.new("UICorner",d).CornerRadius = UDim.new(1,0)
    local dragging, value = false, default
    d.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
            value = min + (max-min) * p
            fill.Size, d.Position, l.Text = UDim2.new(p,0,1,0), UDim2.new(p,-8,0,-8), name..": "..math.floor(value+0.5)
            cb(math.floor(value+0.5))
        end
    end)
    return {Fill=fill, Drag=d, Label=l, Value=value}
end

CreateToggle(body, "飞天", 10, function(s) Toggle.Fly = s; if s then Humanoid.PlatformStand = true else Humanoid.PlatformStand = false; FlyDir = Vector3.new(0,0,0) end end)
CreateToggle(body, "穿墙", 50, function(s) Toggle.Noclip = s end)
CreateToggle(body, "自瞄", 90, function(s) Toggle.Aimbot = s end)
CreateToggle(body, "加速", 130, function(s) Toggle.Speed = s; Humanoid.WalkSpeed = s and 50 or Orig.WalkSpeed end)
CreateToggle(body, "超级跳", 170, function(s) Toggle.Jump = s; Humanoid.JumpPower = s and 100 or Orig.JumpPower end)
CreateToggle(body, "透视", 210, function(s) Toggle.ESP = s end)
CreateSlider(body, "飞行速度", 260, 10, 200, 50, function(v) FlySpeed = v end)
CreateSlider(body, "自瞄范围", 310, 50, 500, 200, function(v) AimRange = v end)

Bounce(main,main.Size)
local drag, dragStart, startPos = false
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, dragStart, startPos = true, i.Position, main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local d = i.Position - dragStart; main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)

local opened = true
minimize.MouseButton1Click:Connect(function()
    Bounce(minimize,minimize.Size); opened = not opened
    game:GetService("TweenService"):Create(main, TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size = opened and UDim2.new(0.45,0,0.5,0) or UDim2.new(0.45,0,0,34)}):Play()
end)

close.MouseButton1Click:Connect(function()
    Bounce(close,close.Size)
    Toggle.Fly, Toggle.Noclip, Toggle.Aimbot, Toggle.Speed, Toggle.Jump, Toggle.ESP = false, false, false, false, false, false
    Humanoid.WalkSpeed, Humanoid.JumpPower = Orig.WalkSpeed, Orig.JumpPower
    for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("ESP_Highlight") if h then h:Destroy() end end end
    game:GetService("TweenService"):Create(main, TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    wait(0.2); gui:Destroy()
end)

UIS.InputBegan:Connect(function(i)
    if Toggle.Fly then
        if i.KeyCode == Enum.KeyCode.Space then FlyDir = FlyDir + Vector3.new(0,1,0) end
        if i.KeyCode == Enum.KeyCode.W then FlyDir = FlyDir + Vector3.new(0,0,-1) end
        if i.KeyCode == Enum.KeyCode.S then FlyDir = FlyDir + Vector3.new(0,0,1) end
        if i.KeyCode == Enum.KeyCode.A then FlyDir = FlyDir + Vector3.new(-1,0,0) end
        if i.KeyCode == Enum.KeyCode.D then FlyDir = FlyDir + Vector3.new(1,0,0) end
    end
end)

UIS.InputEnded:Connect(function(i)
    if Toggle.Fly then
        if i.KeyCode == Enum.KeyCode.Space then FlyDir = FlyDir - Vector3.new(0,1,0) end
        if i.KeyCode == Enum.KeyCode.W then FlyDir = FlyDir - Vector3.new(0,0,-1) end
        if i.KeyCode == Enum.KeyCode.S then FlyDir = FlyDir - Vector3.new(0,0,1) end
        if i.KeyCode == Enum.KeyCode.A then FlyDir = FlyDir - Vector3.new(-1,0,0) end
        if i.KeyCode == Enum.KeyCode.D then FlyDir = FlyDir - Vector3.new(1,0,0) end
    end
end)

RS.Heartbeat:Connect(function(dt)
    local c = Player.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    
    if Toggle.Fly then
        local cam = WS.CurrentCamera
        local lv, rv = cam.CFrame.LookVector * Vector3.new(1,0,1), cam.CFrame.RightVector * Vector3.new(1,0,1)
        local md = Vector3.new(0,0,0)
        if FlyDir.Z < 0 then md = md + lv elseif FlyDir.Z > 0 then md = md - lv end
        if FlyDir.X < 0 then md = md - rv elseif FlyDir.X > 0 then md = md + rv end
        if md.Magnitude > 0 then md = md.Unit * FlySpeed end
        r.Velocity = Vector3.new(md.X, FlyDir.Y * 10, md.Z)
    end
    
    if Toggle.Noclip then
        for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    else
        for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
    end
    
    if Toggle.Aimbot then
        local closest, dist = nil, AimRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
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
    
    if Toggle.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    local h = tr:FindFirstChild("ESP_Highlight")
                    if not h then h = Instance.new("Highlight"); h.Name = "ESP_Highlight"; h.Parent = tr; h.FillColor = Color3.fromRGB(255,0,0); h.FillTransparency = 0.3; h.OutlineColor = Color3.new(1,1,1); h.OutlineTransparency = 0 end
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do if p.Character then local h = p.Character:FindFirstChild("ESP_Highlight") if h then h:Destroy() end end end
    end
end)

print("许领导脚本 V1 已加载！WASD移动，空格上升")
