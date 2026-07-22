-- 许领导脚本 V1

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
    Fly = false, Noclip = false, ESP = false, Aimbot = false,
    Speed = false, SuperJump = false, InfiniteJump = false,
    GodMode = false, OneHit = false, NightVision = false
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

local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 450, 0, 580)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- ====== 你的背景图 ======
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "https://i.imgur.com/XtZN4Ox.jpeg"
bg.ImageTransparency = 0.45
bg.ScaleType = Enum.ScaleType.Crop
bg.Parent = main

-- 边框发光
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 140, 255)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = main

-- 顶部
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundColor3 = Color3.fromRGB(20, 15, 40)
top.BackgroundTransparency = 0.2
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 32, 0, 32)
avatar.Position = UDim2.new(0, 12, 0.5, -16)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxassetid://" .. LP.UserId
avatar.ImageTransparency = 0.2
avatar.Parent = top
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "✦ 权威许领导 V1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subTitle = Instance.new("TextLabel")
subTitle.BackgroundTransparency = 1
subTitle.Size = UDim2.new(1, -120, 0.5, 0)
subTitle.Position = UDim2.new(0, 50, 0.5, 2)
subTitle.Font = Enum.Font.Gotham
subTitle.Text = "QuanWei · XuLingDao"
subTitle.TextColor3 = Color3.fromRGB(180, 140, 255)
subTitle.TextSize = 11
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.Parent = top

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -72, 0.5, -15)
minimize.Text = "─"
minimize.TextColor3 = Color3.fromRGB(200, 200, 220)
minimize.TextSize = 22
minimize.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
minimize.BackgroundTransparency = 0.3
minimize.BorderSizePixel = 0
minimize.Parent = top
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -38, 0.5, -15)
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
close.BackgroundTransparency = 0.3
close.BorderSizePixel = 0
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- 分类标签
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, 0, 0, 44)
tabs.Position = UDim2.new(0, 0, 0, 55)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local tabNames = {"🎯自瞄", "✈️移动", "👁️视觉", "🔫武器", "📋其他"}
local tabButtons = {}
local currentTab = 1
local contentFrames = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(180, 140, 255) or Color3.fromRGB(150, 150, 180)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Parent = tabs
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.5, 0, 0, 2)
    line.Position = UDim2.new(0.25, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
    line.BackgroundTransparency = i == 1 and 0 or 1
    line.BorderSizePixel = 0
    line.Parent = btn
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
    
    tabButtons[i] = {btn = btn, line = line}
    
    btn.MouseButton1Click:Connect(function()
        if currentTab == i then return end
        for j, tb in ipairs(tabButtons) do
            tb.btn.TextColor3 = j == i and Color3.fromRGB(180, 140, 255) or Color3.fromRGB(150, 150, 180)
            tb.line.BackgroundTransparency = j == i and 0 or 1
        end
        currentTab = i
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        contentFrames[i].Visible = true
    end)
end

local contentArea = Instance.new("ScrollingFrame")
contentArea.Size = UDim2.new(1, 0, 1, -99)
contentArea.Position = UDim2.new(0, 0, 0, 99)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
contentArea.ScrollBarThickness = 3
contentArea.ScrollBarImageColor3 = Color3.fromRGB(180, 140, 255)
contentArea.Parent = main

-- UI组件
local function CreateSection(parent, name, y)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 28)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = f

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(180, 140, 255)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    l.Size = UDim2.new(0, l.TextBounds.X + 10, 1, 0)
    return f
end

local function CreateToggle(parent, name, y, desc, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 40)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.55, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(220, 220, 240)
    l.TextSize = 14
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(0.55, 0, 0.45, 0)
        d.Position = UDim2.new(0, 0, 0.55, 0)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Color3.fromRGB(100, 100, 160)
        d.TextSize = 10
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = f
        l.Size = UDim2.new(0.55, 0, 0.55, 0)
    end

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 52, 0, 26)
    b.Position = UDim2.new(1, -56, 0.5, -13)
    b.Text = "关"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = Color3.fromRGB(50, 40, 70)
    b.BorderSizePixel = 0
    b.Parent = f
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)

    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "开" or "关"
        b.BackgroundColor3 = state and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(50, 40, 70)
        cb(state)
    end)
    return b
end

local function CreateSlider(parent, name, y, min, max, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 48)
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
    s.Size = UDim2.new(1, 0, 0, 5)
    s.Position = UDim2.new(0, 0, 1, -10)
    s.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    s.BorderSizePixel = 0
    s.Parent = f
    Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
    fill.BorderSizePixel = 0
    fill.Parent = s
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local d = Instance.new("TextButton")
    d.Size = UDim2.new(0, 16, 0, 16)
    d.Position = UDim2.new((default-min)/(max-min), -8, 0, -5.5)
    d.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
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
            d.Position = UDim2.new(p, -8, 0, -5.5)
            l.Text = name..": "..math.floor(value+0.5)
            cb(math.floor(value+0.5))
        end
    end)
    return value
end

local function CreateColorPicker(parent, name, y, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 32)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 22)
    btn.Position = UDim2.new(1, -36, 0.5, -11)
    btn.BackgroundColor3 = default
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 70, 120)
    btn.Text = ""
    btn.Parent = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local colors = {
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(50, 255, 50),
        Color3.fromRGB(50, 100, 255),
        Color3.fromRGB(255, 255, 50),
        Color3.fromRGB(255, 50, 255),
        Color3.fromRGB(50, 255, 255),
        Color3.fromRGB(255, 150, 50),
        Color3.fromRGB(255, 255, 255)
    }
    local colorIndex = 1

    btn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        btn.BackgroundColor3 = colors[colorIndex]
        cb(colors[colorIndex])
    end)
end

-- 标签1: 自瞄
local tab1 = Instance.new("Frame")
tab1.Size = UDim2.new(1, 0, 1, 0)
tab1.BackgroundTransparency = 1
tab1.Parent = contentArea
table.insert(contentFrames, tab1)

local y = 2
CreateSection(tab1, "⚡ 自瞄设置", y)
y = y + 30
CreateToggle(tab1, "开启自瞄", y, "自动瞄准最近的敌人", function(s) Toggle.Aimbot = s end)
y = y + 44
CreateSlider(tab1, "自瞄范围", y, 50, 500, 200, function(v) AimRange = v end)
y = y + 52
CreateSection(tab1, "🎯 瞄准设置", y)
y = y + 30
CreateToggle(tab1, "锁头模式", y, "优先瞄准头部", function(s) end)
y = y + 44
CreateToggle(tab1, "显示瞄准线", y, "显示瞄准辅助线", function(s) end)

-- 标签2: 移动
local tab2 = Instance.new("Frame")
tab2.Size = UDim2.new(1, 0, 1, 0)
tab2.BackgroundTransparency = 1
tab2.Visible = false
tab2.Parent = contentArea
table.insert(contentFrames, tab2)

y = 2
CreateSection(tab2, "✈️ 飞行设置", y)
y = y + 30
CreateToggle(tab2, "飞行模式", y, "WASD移动 | 空格上升", function(s) 
    Toggle.Fly = s
    if not s then 
        FlyDir = Vector3.new(0,0,0)
        if Humanoid then Humanoid.PlatformStand = false end
    else
        if Humanoid then Humanoid.PlatformStand = true end
    end
end)
y = y + 44
CreateSlider(tab2, "飞行速度", y, 10, 200, 50, function(v) FlySpeed = v end)
y = y + 52
CreateSection(tab2, "🏃 移动增强", y)
y = y + 30
CreateToggle(tab2, "穿墙模式", y, "穿透所有物体", function(s) Toggle.Noclip = s end)
y = y + 44
CreateToggle(tab2, "加速奔跑", y, "移动速度×3", function(s) 
    Toggle.Speed = s
    if Humanoid then 
        if s then Humanoid.WalkSpeed = 50 else Humanoid.WalkSpeed = Orig.WalkSpeed end
    end
end)
y = y + 44
CreateToggle(tab2, "超级跳跃", y, "跳得超高", function(s)
    Toggle.SuperJump = s
    if Humanoid then 
        if s then Humanoid.JumpPower = 100 else Humanoid.JumpPower = Orig.JumpPower end
    end
end)
y = y + 44
CreateToggle(tab2, "无限跳跃", y, "空中无限跳", function(s) Toggle.InfiniteJump = s end)

-- 标签3: 视觉
local tab3 = Instance.new("Frame")
tab3.Size = UDim2.new(1, 0, 1, 0)
tab3.BackgroundTransparency = 1
tab3.Visible = false
tab3.Parent = contentArea
table.insert(contentFrames, tab3)

y = 2
CreateSection(tab3, "👁️ 透视设置", y)
y = y + 30
CreateToggle(tab3, "开启透视", y, "显示敌人轮廓", function(s) Toggle.ESP = s end)
y = y + 44
CreateColorPicker(tab3, "透视颜色", y, ESPColor, function(c) ESPColor = c end)
y = y + 38
CreateToggle(tab3, "显示血量", y, "在头顶显示血量", function(s) end)
y = y + 44
CreateSection(tab3, "🌙 视觉增强", y)
y = y + 30
CreateToggle(tab3, "夜视模式", y, "提高游戏亮度", function(s)
    Toggle.NightVision = s
    if s then
        game:GetService("Lighting").Brightness = 5
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
    end
end)

-- 标签4: 武器
local tab4 = Instance.new("Frame")
tab4.Size = UDim2.new(1, 0, 1, 0)
tab4.BackgroundTransparency = 1
tab4.Visible = false
tab4.Parent = contentArea
table.insert(contentFrames, tab4)

y = 2
CreateSection(tab4, "🔫 武器增强", y)
y = y + 30
CreateToggle(tab4, "无限弹药", y, "子弹用不完", function(s) end)
y = y + 44
CreateToggle(tab4, "无后座力", y, "武器无后座", function(s) end)
y = y + 44
CreateToggle(tab4, "快速射击", y, "射速提升", function(s) end)
y = y + 52
CreateSection(tab4, "💀 伤害设置", y)
y = y + 30
CreateToggle(tab4, "一击必杀", y, "秒杀任何敌人", function(s) Toggle.OneHit = s end)
y = y + 44
CreateToggle(tab4, "锁血无敌", y, "生命值锁定", function(s) 
    Toggle.GodMode = s
    if s and Humanoid then
        Humanoid.MaxHealth = 999999
        Humanoid.Health = 999999
    end
end)

-- 标签5: 其他
local tab5 = Instance.new("Frame")
tab5.Size = UDim2.new(1, 0, 1, 0)
tab5.BackgroundTransparency = 1
tab5.Visible = false
tab5.Parent = contentArea
table.insert(contentFrames, tab5)

y = 2
CreateSection(tab5, "⌨️ 快捷键", y)
y = y + 30

local hotkeyInfo = Instance.new("TextLabel")
hotkeyInfo.Size = UDim2.new(1, -20, 0, 90)
hotkeyInfo.Position = UDim2.new(0, 10, 0, y)
hotkeyInfo.BackgroundTransparency = 1
hotkeyInfo.Text = "F1 → 显示/隐藏菜单\nWASD → 飞行移动\n空格 → 飞行上升\nF2 → 快速开关飞行\nF3 → 快速开关自瞄"
hotkeyInfo.TextColor3 = Color3.fromRGB(160, 160, 200)
hotkeyInfo.TextSize = 13
hotkeyInfo.Font = Enum.Font.Gotham
hotkeyInfo.TextXAlignment = Enum.TextXAlignment.Left
hotkeyInfo.TextYAlignment = Enum.TextYAlignment.Top
hotkeyInfo.Parent = tab5
y = y + 95

CreateSection(tab5, "📋 关于", y)
y = y + 30

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 60)
info.Position = UDim2.new(0, 10, 0, y)
info.BackgroundTransparency = 1
info.Text = "权威许领导 V1\nQuanWei · XuLingDao\n仅限私人服务器使用"
info.TextColor3 = Color3.fromRGB(140, 140, 180)
info.TextSize = 12
info.Font = Enum.Font.Gotham
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Parent = tab5

-- 窗口控制
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

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = minimized and UDim2.new(0, 450, 0, 55) or UDim2.new(0, 450, 0, 580)
    }):Play()
    minimize.Text = minimized and "□" or "─"
end)

close.MouseButton1Click:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = Orig.WalkSpeed
        Humanoid.JumpPower = Orig.JumpPower
        Humanoid.PlatformStand = false
        Humanoid.MaxHealth = 100
        if Humanoid.Health > 100 then Humanoid.Health = 100 end
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

UIS.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F1 then
        main.Visible = not main.Visible
    end
    if i.KeyCode == Enum.KeyCode.F2 then
        Toggle.Fly = not Toggle.Fly
        if not Toggle.Fly then 
            FlyDir = Vector3.new(0,0,0)
            if Humanoid then Humanoid.PlatformStand = false end
        else
            if Humanoid then Humanoid.PlatformStand = true end
        end
    end
    if i.KeyCode == Enum.KeyCode.F3 then
        Toggle.Aimbot = not Toggle.Aimbot
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

    if Toggle.Fly then
        h.PlatformStand = true
        local cam = WS.CurrentCamera
        local lv = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        local rv = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
        local md = Vector3.new(0, 0, 0)
        if FlyDir.Z < 0 then md = md + lv elseif FlyDir.Z > 0 then md = md - lv end
        if FlyDir.X < 0 then md = md - rv elseif FlyDir.X > 0 then md = md + rv end
        if md.Magnitude > 0 then md = md.Unit * FlySpeed end
        r.Velocity = Vector3.new(md.X, FlyDir.Y * 10, md.Z)
    else
        h.PlatformStand = false
    end

    if Toggle.Noclip then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    else
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end

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

    if Toggle.GodMode and h then
        h.MaxHealth = 999999
        h.Health = 999999
    end

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

    if Toggle.Speed and h then
        h.WalkSpeed = 50
    end
    if Toggle.SuperJump and h then
        h.JumpPower = 100
    end
end)

print("✦ 权威许领导 V1 已加载！按 F1 隐藏/显示菜单")
print("QuanWei · XuLingDao")