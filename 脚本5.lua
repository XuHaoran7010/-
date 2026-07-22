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

-- 主框架
local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 500, 0, 480)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- 背景图
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "https://i.imgur.com/XtZN4Ox.jpeg"
bg.ImageTransparency = 0.5
bg.ScaleType = Enum.ScaleType.Crop
bg.Parent = main

-- 边框
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 140, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.2
stroke.Parent = main

-- 顶部标题栏
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
top.BackgroundTransparency = 0.2
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "✦ 权威许领导"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subTitle = Instance.new("TextLabel")
subTitle.BackgroundTransparency = 1
subTitle.Size = UDim2.new(1, -100, 0.4, 0)
subTitle.Position = UDim2.new(0, 15, 0.6, 0)
subTitle.Font = Enum.Font.Gotham
subTitle.Text = "QuanWei · XuLingDao"
subTitle.TextColor3 = Color3.fromRGB(180, 140, 255)
subTitle.TextSize = 10
subTitle.TextXAlignment = Enum.TextXAlignment.Left
subTitle.Parent = top

-- 最小化
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 28, 0, 28)
minimize.Position = UDim2.new(1, -68, 0.5, -14)
minimize.Text = "─"
minimize.TextColor3 = Color3.fromRGB(200, 200, 220)
minimize.TextSize = 20
minimize.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
minimize.BackgroundTransparency = 0.3
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
close.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
close.BackgroundTransparency = 0.3
close.BorderSizePixel = 0
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

-- ====== 主体：左分区 + 右内容 ======

local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -45)
body.Position = UDim2.new(0, 0, 0, 45)
body.BackgroundTransparency = 1
body.Parent = main

-- 左边栏 (分区)
local leftBar = Instance.new("Frame")
leftBar.Size = UDim2.new(0, 100, 1, 0)
leftBar.BackgroundColor3 = Color3.fromRGB(20, 15, 45)
leftBar.BackgroundTransparency = 0.3
leftBar.BorderSizePixel = 0
leftBar.Parent = body

local leftList = Instance.new("ScrollingFrame")
leftList.Size = UDim2.new(1, 0, 1, 0)
leftList.BackgroundTransparency = 1
leftList.BorderSizePixel = 0
leftList.CanvasSize = UDim2.new(0, 0, 0, 250)
leftList.ScrollBarThickness = 2
leftList.ScrollBarImageColor3 = Color3.fromRGB(180, 140, 255)
leftList.Parent = leftBar

local categories = {"自瞄", "移动", "视觉", "武器", "其他"}
local catButtons = {}
local currentCat = 1
local contentPanels = {}

for i, name in ipairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, (i-1) * 42 + 5)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 140, 255) or Color3.fromRGB(40, 35, 60)
    btn.BackgroundTransparency = i == 1 and 0.2 or 0.5
    btn.BorderSizePixel = 0
    btn.Parent = leftList
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    catButtons[i] = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentCat == i then return end
        for j, b in ipairs(catButtons) do
            b.TextColor3 = j == i and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 200)
            b.BackgroundColor3 = j == i and Color3.fromRGB(180, 140, 255) or Color3.fromRGB(40, 35, 60)
            b.BackgroundTransparency = j == i and 0.2 or 0.5
        end
        currentCat = i
        for _, panel in pairs(contentPanels) do
            panel.Visible = false
        end
        contentPanels[i].Visible = true
    end)
end

-- 右边内容区
local rightArea = Instance.new("ScrollingFrame")
rightArea.Size = UDim2.new(1, -100, 1, 0)
rightArea.Position = UDim2.new(0, 100, 0, 0)
rightArea.BackgroundTransparency = 1
rightArea.BorderSizePixel = 0
rightArea.CanvasSize = UDim2.new(0, 0, 0, 0)
rightArea.ScrollBarThickness = 3
rightArea.ScrollBarImageColor3 = Color3.fromRGB(180, 140, 255)
rightArea.Parent = body

-- ====== 滑动开关组件 ======

local function CreateToggle(parent, name, y, desc, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 44)
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

    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(0.6, 0, 0.45, 0)
        d.Position = UDim2.new(0, 0, 0.55, 0)
        d.BackgroundTransparency = 1
        d.Text = desc
        d.TextColor3 = Color3.fromRGB(100, 100, 160)
        d.TextSize = 10
        d.Font = Enum.Font.Gotham
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Parent = f
        l.Size = UDim2.new(0.6, 0, 0.55, 0)
    end

    -- 滑动开关
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 50, 0, 28)
    switch.Position = UDim2.new(1, -54, 0.5, -14)
    switch.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    switch.BorderSizePixel = 0
    switch.Parent = f
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new(0, 3, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false
    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(1, 0, 1, 0)
    switchBtn.BackgroundTransparency = 1
    switchBtn.Text = ""
    switchBtn.Parent = switch

    switchBtn.MouseButton1Click:Connect(function()
        state = not state
        local targetX = state and 25 or 3
        TS:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetX, 0.5, -11)
        }):Play()
        switch.BackgroundColor3 = state and Color3.fromRGB(120, 80, 255) or Color3.fromRGB(60, 50, 80)
        cb(state)
    end)

    return switch
end

-- 滑块
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
    s.Position = UDim2.new(0, 0, 1, -12)
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

-- 颜色选择
local function CreateColorPicker(parent, name, y, default, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 34)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(200, 200, 220)
    l.TextSize = 13
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 24)
    btn.Position = UDim2.new(1, -38, 0.5, -12)
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

-- 分区标题
local function CreateSection(parent, name, y)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -20, 0, 24)
    f.Position = UDim2.new(0, 10, 0, y)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(180, 140, 255)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(180, 140, 255)
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = f

    return f
end

-- ====== 创建5个面板 ======

-- 1. 自瞄
local panel1 = Instance.new("Frame")
panel1.Size = UDim2.new(1, 0, 1, 0)
panel1.BackgroundTransparency = 1
panel1.Parent = rightArea
table.insert(contentPanels, panel1)

local y = 5
CreateSection(panel1, "⚡ 自瞄设置", y)
y = y + 26
CreateToggle(panel1, "开启自瞄", y, "自动瞄准最近的敌人", function(s) Toggle.Aimbot = s end)
y = y + 48
CreateSlider(panel1, "自瞄范围", y, 50, 500, 200, function(v) AimRange = v end)
y = y + 52
CreateSection(panel1, "🎯 瞄准设置", y)
y = y + 26
CreateToggle(panel1, "锁头模式", y, "优先瞄准头部", function(s) end)
y = y + 48
CreateToggle(panel1, "显示瞄准线", y, "显示瞄准辅助线", function(s) end)

-- 2. 移动
local panel2 = Instance.new("Frame")
panel2.Size = UDim2.new(1, 0, 1, 0)
panel2.BackgroundTransparency = 1
panel2.Visible = false
panel2.Parent = rightArea
table.insert(contentPanels, panel2)

y = 5
CreateSection(panel2, "✈️ 飞行设置", y)
y = y + 26
CreateToggle(panel2, "飞行模式", y, "WASD移动 | 空格上升", function(s) 
    Toggle.Fly = s
    if not s then 
        FlyDir = Vector3.new(0,0,0)
        if Humanoid then Humanoid.PlatformStand = false end
    else
        if Humanoid then Humanoid.PlatformStand = true end
    end
end)
y = y + 48
CreateSlider(panel2, "飞行速度", y, 10, 200, 50, function(v) FlySpeed = v end)
y = y + 52
CreateSection(panel2, "🏃 移动增强", y)
y = y + 26
CreateToggle(panel2, "穿墙模式", y, "穿透所有物体", function(s) Toggle.Noclip = s end)
y = y + 48
CreateToggle(panel2, "加速奔跑", y, "移动速度×3", function(s) 
    Toggle.Speed = s
    if Humanoid then 
        if s then Humanoid.WalkSpeed = 50 else Humanoid.WalkSpeed = Orig.WalkSpeed end
    end
end)
y = y + 48
CreateToggle(panel2, "超级跳跃", y, "跳得超高", function(s)
    Toggle.SuperJump = s
    if Humanoid then 
        if s then Humanoid.JumpPower = 100 else Humanoid.JumpPower = Orig.JumpPower end
    end
end)
y = y + 48
CreateToggle(panel2, "无限跳跃", y, "空中无限跳", function(s) Toggle.InfiniteJump = s end)

-- 3. 视觉
local panel3 = Instance.new("Frame")
panel3.Size = UDim2.new(1, 0, 1, 0)
panel3.BackgroundTransparency = 1
panel3.Visible = false
panel3.Parent = rightArea
table.insert(contentPanels, panel3)

y = 5
CreateSection(panel3, "👁️ 透视设置", y)
y = y + 26
CreateToggle(panel3, "开启透视", y, "显示敌人轮廓", function(s) Toggle.ESP = s end)
y = y + 48
CreateColorPicker(panel3, "透视颜色", y, ESPColor, function(c) ESPColor = c end)
y = y + 38
CreateToggle(panel3, "显示血量", y, "在头顶显示血量", function(s) end)
y = y + 48
CreateSection(panel3, "🌙 视觉增强", y)
y = y + 26
CreateToggle(panel3, "夜视模式", y, "提高游戏亮度", function(s)
    Toggle.NightVision = s
    if s then
        game:GetService("Lighting").Brightness = 5
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
    end
end)

-- 4. 武器
local panel4 = Instance.new("Frame")
panel4.Size = UDim2.new(1, 0, 1, 0)
panel4.BackgroundTransparency = 1
panel4.Visible = false
panel4.Parent = rightArea
table.insert(contentPanels, panel4)

y = 5
CreateSection(panel4, "🔫 武器增强", y)
y = y + 26
CreateToggle(panel4, "无限弹药", y, "子弹用不完", function(s) end)
y = y + 48
CreateToggle(panel4, "无后座力", y, "武器无后座", function(s) end)
y = y + 48
CreateToggle(panel4, "快速射击", y, "射速提升", function(s) end)
y = y + 52
CreateSection(panel4, "💀 伤害设置", y)
y = y + 26
CreateToggle(panel4, "一击必杀", y, "秒杀任何敌人", function(s) Toggle.OneHit = s end)
y = y + 48
CreateToggle(panel4, "锁血无敌", y, "生命值锁定", function(s) 
    Toggle.GodMode = s
    if s and Humanoid then
        Humanoid.MaxHealth = 999999
        Humanoid.Health = 999999
    end
end)

-- 5. 其他
local panel5 = Instance.new("Frame")
panel5.Size = UDim2.new(1, 0, 1, 0)
panel5.BackgroundTransparency = 1
panel5.Visible = false
panel5.Parent = rightArea
table.insert(contentPanels, panel5)

y = 5
CreateSection(panel5, "⌨️ 快捷键", y)
y = y + 26

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
hotkeyInfo.Parent = panel5
y = y + 95

CreateSection(panel5, "📋 关于", y)
y = y + 26

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
info.Parent = panel5

-- 设置右边区域高度
rightArea.CanvasSize = UDim2.new(0, 0, 0, y + 80)

-- ====== 窗口控制 ======

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
        Size = minimized and UDim2.new(0, 500, 0, 45) or UDim2.new(0, 500, 0, 480)
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