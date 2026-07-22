--[[
    许领导脚本 V1
    功能：飞行、穿墙、透视、自瞄、加速、超级跳、无限跳跃、锁血、一击必杀、夜视
    手机操作：点击按钮开关功能，飞行时用虚拟摇杆或触摸拖动
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- 等待角色
local function GetChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Humanoid = Char:WaitForChild("Humanoid")
    Root = Char:WaitForChild("HumanoidRootPart")
    if Humanoid then
        Orig.WalkSpeed = Humanoid.WalkSpeed
        Orig.JumpPower = Humanoid.JumpPower
    end
end

local Char, Humanoid, Root
local Orig = {WalkSpeed = 16, JumpPower = 50}
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

-- 手机触摸飞行控制
local TouchFly = {
    Active = false,
    StartPos = nil,
    CurrentPos = nil
}

-- 防止重复创建GUI
local function CreateGUI()
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
    main.Size = UDim2.new(0, 400, 0, 520)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui

    -- 边框
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(80, 120, 255)
    uiStroke.Thickness = 1.5
    uiStroke.Transparency = 0.3
    uiStroke.Parent = main
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    -- 顶部标题栏
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 50)
    top.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    top.BackgroundTransparency = 0.3
    top.BorderSizePixel = 0
    top.Parent = main
    Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 0, 28)
    accent.Position = UDim2.new(0, 15, 0.5, -14)
    accent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    accent.BorderSizePixel = 0
    accent.Parent = top
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 25, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "✦ 许领导脚本 V3"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    -- 手机提示
    local phoneHint = Instance.new("TextLabel")
    phoneHint.BackgroundTransparency = 1
    phoneHint.Size = UDim2.new(0, 50, 1, 0)
    phoneHint.Position = UDim2.new(1, -140, 0, 0)
    phoneHint.Font = Enum.Font.Gotham
    phoneHint.Text = "📱"
    phoneHint.TextColor3 = Color3.fromRGB(100, 150, 255)
    phoneHint.TextSize = 16
    phoneHint.TextXAlignment = Enum.TextXAlignment.Right
    phoneHint.Parent = top

    -- 最小化
    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -72, 0.5, -15)
    minimize.Text = "─"
    minimize.TextColor3 = Color3.fromRGB(200, 200, 220)
    minimize.TextSize = 20
    minimize.TextScaled = true
    minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    minimize.BackgroundTransparency = 0.5
    minimize.BorderSizePixel = 0
    minimize.Parent = top
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

    -- 关闭
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -38, 0.5, -15)
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 100, 100)
    close.TextSize = 18
    close.TextScaled = true
    close.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    close.BackgroundTransparency = 0.5
    close.BorderSizePixel = 0
    close.Parent = top
    Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

    -- 分类标签（增大触摸区域）
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(1, 0, 0, 44)
    tabs.Position = UDim2.new(0, 0, 0, 50)
    tabs.BackgroundTransparency = 1
    tabs.Parent = main

    local tabNames = {"自瞄", "移动", "视觉", "武器", "其他"}
    local tabButtons = {}
    local currentTab = 1

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.2, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.Text = name
        btn.TextColor3 = i == 1 and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(150, 150, 180)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Parent = tabs
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.5, 0, 0, 2)
        line.Position = UDim2.new(0.25, 0, 1, 0)
        line.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        line.BackgroundTransparency = i == 1 and 0 or 1
        line.BorderSizePixel = 0
        line.Parent = btn
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
        
        tabButtons[i] = {btn = btn, line = line}
        
        btn.MouseButton1Click:Connect(function()
            if currentTab == i then return end
            for j, tb in ipairs(tabButtons) do
                tb.btn.TextColor3 = j == i and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(150, 150, 180)
                tb.line.BackgroundTransparency = j == i and 0 or 1
            end
            currentTab = i
            for _, frame in pairs(contentFrames) do
                frame.Visible = false
            end
            contentFrames[i].Visible = true
        end)
    end

    -- 内容区域
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, 0, 1, -94)
    contentArea.Position = UDim2.new(0, 0, 0, 94)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentArea.ScrollBarThickness = 4
    contentArea.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
    contentArea.Parent = main

    local contentFrames = {}

    -- 创建分区标题
    local function CreateSection(parent, name, y)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 30)
        f.Position = UDim2.new(0, 10, 0, y)
        f.BackgroundTransparency = 1
        f.Parent = parent

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 1, 0)
        line.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
        line.BackgroundTransparency = 0.3
        line.BorderSizePixel = 0
        line.Parent = f

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(80, 120, 255)
        l.TextSize = 13
        l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        l.Size = UDim2.new(0, l.TextBounds.X + 10, 1, 0)

        return f
    end

    -- 创建开关（增大触摸区域，适合手机）
    local function CreateToggle(parent, name, y, desc, cb)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 44)
        f.Position = UDim2.new(0, 10, 0, y)
        f.BackgroundTransparency = 1
        f.Parent = parent

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(220, 220, 240)
        l.TextSize = 14
        l.Font = Enum.Font.Gotham
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        if desc then
            local d = Instance.new("TextLabel")
            d.Size = UDim2.new(0.55, 0, 0.5, 0)
            d.Position = UDim2.new(0, 0, 0.5, 0)
            d.BackgroundTransparency = 1
            d.Text = desc
            d.TextColor3 = Color3.fromRGB(100, 100, 150)
            d.TextSize = 10
            d.Font = Enum.Font.Gotham
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.Parent = f
            l.Size = UDim2.new(0.55, 0, 0.5, 0)
        end

        -- 增大按钮
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 56, 0, 30)
        b.Position = UDim2.new(1, -60, 0.5, -15)
        b.Text = "关"
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 14
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
            
            -- 手机震动反馈（可选）
            if game:GetService("VibrationService") then
                game:GetService("VibrationService"):Vibrate(50)
            end
        end)
        return b
    end

    -- 创建滑块（增大触摸区域）
    local function CreateSlider(parent, name, y, min, max, default, cb)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 54)
        f.Position = UDim2.new(0, 10, 0, y)
        f.BackgroundTransparency = 1
        f.Parent = parent

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0.4, 0)
        l.BackgroundTransparency = 1
        l.Text = name..": "..tostring(default)
        l.TextColor3 = Color3.fromRGB(200, 200, 220)
        l.TextSize = 14
        l.Font = Enum.Font.Gotham
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local s = Instance.new("Frame")
        s.Size = UDim2.new(1, 0, 0, 8)
        s.Position = UDim2.new(0, 0, 1, -14)
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

        -- 增大拖动手柄
        local d = Instance.new("TextButton")
        d.Size = UDim2.new(0, 22, 0, 22)
        d.Position = UDim2.new((default-min)/(max-min), -11, 0, -7)
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
                local posX = i.Position.X
                local p = math.clamp((posX - s.AbsolutePosition.X) / s.AbsoluteSize.X, 0, 1)
                value = min + (max-min) * p
                fill.Size = UDim2.new(p, 0, 1, 0)
                d.Position = UDim2.new(p, -11, 0, -7)
                l.Text = name..": "..math.floor(value+0.5)
                cb(math.floor(value+0.5))
            end
        end)
        return value
    end

    -- 创建颜色选择
    local function CreateColorPicker(parent, name, y, default, cb)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 36)
        f.Position = UDim2.new(0, 10, 0, y)
        f.BackgroundTransparency = 1
        f.Parent = parent

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.7, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(200, 200, 220)
        l.TextSize = 14
        l.Font = Enum.Font.Gotham
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 34, 0, 26)
        btn.Position = UDim2.new(1, -40, 0.5, -13)
        btn.BackgroundColor3 = default
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(80, 80, 120)
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

    -- ====== 创建各个标签页 ======

    -- 1. 自瞄标签页
    local tab1 = Instance.new("Frame")
    tab1.Size = UDim2.new(1, 0, 1, 0)
    tab1.BackgroundTransparency = 1
    tab1.Parent = contentArea
    table.insert(contentFrames, tab1)

    local y = 2
    CreateSection(tab1, "⚡ 自瞄设置", y)
    y = y + 32
    CreateToggle(tab1, "开启自瞄", y, "自动瞄准最近的敌人", function(s) Toggle.Aimbot = s end)
    y = y + 48
    CreateSlider(tab1, "自瞄范围", y, 50, 500, 200, function(v) AimRange = v end)
    y = y + 58
    CreateSection(tab1, "🎯 瞄准设置", y)
    y = y + 32
    CreateToggle(tab1, "锁头模式", y, "优先瞄准头部", function(s) end)
    y = y + 48
    CreateToggle(tab1, "显示瞄准线", y, "显示瞄准辅助线", function(s) end)

    -- 2. 移动标签页
    local tab2 = Instance.new("Frame")
    tab2.Size = UDim2.new(1, 0, 1, 0)
    tab2.BackgroundTransparency = 1
    tab2.Visible = false
    tab2.Parent = contentArea
    table.insert(contentFrames, tab2)

    y = 2
    CreateSection(tab2, "✈️ 飞行设置", y)
    y = y + 32
    CreateToggle(tab2, "飞行模式", y, "触摸屏幕控制方向", function(s) 
        Toggle.Fly = s
        if not s then 
            FlyDir = Vector3.new(0,0,0)
            TouchFly.Active = false
        end
    end)
    y = y + 48
    CreateSlider(tab2, "飞行速度", y, 10, 200, 50, function(v) FlySpeed = v end)
    y = y + 58
    CreateSection(tab2, "🏃 移动增强", y)
    y = y + 32
    CreateToggle(tab2, "穿墙模式", y, "穿透所有物体", function(s) Toggle.Noclip = s end)
    y = y + 48
    CreateToggle(tab2, "加速奔跑", y, "移动速度×3", function(s) 
        Toggle.Speed = s
        if Humanoid then Humanoid.WalkSpeed = s and 50 or Orig.WalkSpeed end
    end)
    y = y + 48
    CreateToggle(tab2, "超级跳跃", y, "跳得超高", function(s)
        Toggle.SuperJump = s
        if Humanoid then Humanoid.JumpPower = s and 100 or Orig.JumpPower end
    end)
    y = y + 48
    CreateToggle(tab2, "无限跳跃", y, "空中无限跳", function(s)
        Toggle.InfiniteJump = s
    end)

    -- 3. 视觉标签页
    local tab3 = Instance.new("Frame")
    tab3.Size = UDim2.new(1, 0, 1, 0)
    tab3.BackgroundTransparency = 1
    tab3.Visible = false
    tab3.Parent = contentArea
    table.insert(contentFrames, tab3)

    y = 2
    CreateSection(tab3, "👁️ 透视设置", y)
    y = y + 32
    CreateToggle(tab3, "开启透视", y, "显示敌人轮廓", function(s) Toggle.ESP = s end)
    y = y + 48
    CreateColorPicker(tab3, "透视颜色", y, ESPColor, function(c) ESPColor = c end)
    y = y + 42
    CreateToggle(tab3, "显示血量", y, "在头顶显示血量", function(s) end)
    y = y + 48
    CreateSection(tab3, "🌙 视觉增强", y)
    y = y + 32
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

    -- 4. 武器标签页
    local tab4 = Instance.new("Frame")
    tab4.Size = UDim2.new(1, 0, 1, 0)
    tab4.BackgroundTransparency = 1
    tab4.Visible = false
    tab4.Parent = contentArea
    table.insert(contentFrames, tab4)

    y = 2
    CreateSection(tab4, "🔫 武器增强", y)
    y = y + 32
    CreateToggle(tab4, "无限弹药", y, "子弹用不完", function(s) end)
    y = y + 48
    CreateToggle(tab4, "无后座力", y, "武器无后座", function(s) end)
    y = y + 48
    CreateToggle(tab4, "快速射击", y, "射速提升", function(s) end)
    y = y + 58
    CreateSection(tab4, "💀 伤害设置", y)
    y = y + 32
    CreateToggle(tab4, "一击必杀", y, "秒杀任何敌人", function(s) Toggle.OneHit = s end)
    y = y + 48
    CreateToggle(tab4, "锁血无敌", y, "生命值锁定", function(s) Toggle.GodMode = s end)

    -- 5. 其他标签页
    local tab5 = Instance.new("Frame")
    tab5.Size = UDim2.new(1, 0, 1, 0)
    tab5.BackgroundTransparency = 1
    tab5.Visible = false
    tab5.Parent = contentArea
    table.insert(contentFrames, tab5)

    y = 2
    CreateSection(tab5, "⌨️ 操作说明", y)
    y = y + 32
    
    local hotkeyInfo = Instance.new("TextLabel")
    hotkeyInfo.Size = UDim2.new(1, -20, 0, 100)
    hotkeyInfo.Position = UDim2.new(0, 10, 0, y)
    hotkeyInfo.BackgroundTransparency = 1
    hotkeyInfo.Text = "📱 手机操作说明：\n\n• 点击按钮开关功能\n• 飞行模式：触摸屏幕拖动控制方向\n• 点击屏幕空白处上升\n• 双击屏幕下降"
    hotkeyInfo.TextColor3 = Color3.fromRGB(160, 160, 200)
    hotkeyInfo.TextSize = 13
    hotkeyInfo.Font = Enum.Font.Gotham
    hotkeyInfo.TextXAlignment = Enum.TextXAlignment.Left
    hotkeyInfo.TextYAlignment = Enum.TextYAlignment.Top
    hotkeyInfo.Parent = tab5
    y = y + 105

    CreateSection(tab5, "📋 信息", y)
    y = y + 32

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 60)
    info.Position = UDim2.new(0, 10, 0, y)
    info.BackgroundTransparency = 1
    info.Text = "许领导脚本 V3\n手机优化版\n仅限私人服务器使用"
    info.TextColor3 = Color3.fromRGB(140, 140, 180)
    info.TextSize = 12
    info.Font = Enum.Font.Gotham
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = tab5

    -- ====== 窗口控制 ======

    local menuVisible = true

    -- 手机触摸飞行控制
    local function HandleFlyTouch(input)
        if not Toggle.Fly then return end
        
        if input.UserInputType == Enum.UserInputType.Touch then
            local screenSize = WS.CurrentCamera.ViewportSize
            local centerX = screenSize.X / 2
            local centerY = screenSize.Y / 2
            
            local deltaX = (input.Position.X - centerX) / centerX
            local deltaY = (input.Position.Y - centerY) / centerY
            
            -- 限制范围
            deltaX = math.clamp(deltaX, -1, 1)
            deltaY = math.clamp(deltaY, -1, 1)
            
            -- 死区（防止误触）
            if math.abs(deltaX) < 0.1 then deltaX = 0 end
            if math.abs(deltaY) < 0.1 then deltaY = 0 end
            
            FlyDir = Vector3.new(deltaX, -deltaY, 0)
        end
    end

    -- 触摸开始
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if Toggle.Fly then
                TouchFly.Active = true
                TouchFly.StartPos = input.Position
                TouchFly.CurrentPos = input.Position
                HandleFlyTouch(input)
            end
        end
    end)

    -- 触摸移动
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if Toggle.Fly and TouchFly.Active then
                TouchFly.CurrentPos = input.Position
                HandleFlyTouch(input)
            end
        end
        
        -- 窗口拖动（触摸）
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- 触摸结束
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if Toggle.Fly then
                TouchFly.Active = false
                FlyDir = Vector3.new(0, 0, 0)
            end
            dragging = false
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- 双击检测（手机双击上升/下降）
    local lastTapTime = 0
    local tapCount = 0

    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and Toggle.Fly then
            local currentTime = tick()
            if currentTime - lastTapTime < 0.3 then
                tapCount = tapCount + 1
                if tapCount >= 2 then
                    -- 双击切换上升/下降
                    if FlyDir.Y >= 0 then
                        FlyDir = FlyDir + Vector3.new(0, -1, 0)
                    else
                        FlyDir = FlyDir + Vector3.new(0, 1, 0)
                    end
                    tapCount = 0
                end
            else
                tapCount = 1
            end
            lastTapTime = currentTime
        end
    end)

    -- 窗口拖动（鼠标）
    local dragging = false
    local dragStart, startPos

    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = main.Position
        end
    end)

    -- 最小化
    local minimized = false
    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = minimized and UDim2.new(0, 400, 0, 50) or UDim2.new(0, 400, 0, 520)
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

    -- ====== 核心功能循环 ======

    -- 无限跳跃（手机适配）
    UIS.InputBegan:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space and Toggle.InfiniteJump and Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        -- 手机触摸跳跃
        if i.UserInputType == Enum.UserInputType.Touch and Toggle.InfiniteJump and Humanoid then
            -- 只在屏幕下半部分点击时触发跳跃
            if i.Position.Y > WS.CurrentCamera.ViewportSize.Y * 0.6 then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- 主循环
    RS.Heartbeat:Connect(function(dt)
        local c = LP.Character
        if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local h = c:FindFirstChild("Humanoid")
        if not h then return end

        -- 飞行
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
            if h then h.PlatformStand = false end
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

    return gui
end

-- 创建GUI
CreateGUI()

print("✦ 许领导脚本 V1 已加载！")