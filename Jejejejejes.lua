-- BY ROBLX MODS - Professional Hub
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Destroy previous GUI
if playerGui:FindFirstChild("ROBLXHub") then
    playerGui.ROBLXHub:Destroy()
end

-- Notification function
local function notify(title,msg,color)
    local sg = playerGui:FindFirstChild("ROBLXHubToasts")
    if not sg then
        sg = Instance.new("ScreenGui",playerGui)
        sg.Name = "ROBLXHubToasts"
        sg.ResetOnSpawn = false
    end
    local toast = Instance.new("Frame",sg)
    toast.AnchorPoint = Vector2.new(1,1)
    toast.Position = UDim2.new(1,-12,1,20)
    toast.Size = UDim2.new(0,300,0,72)
    toast.BackgroundColor3 = Color3.fromRGB(20,20,28)
    toast.BackgroundTransparency = 0.15
    toast.BorderSizePixel = 0
    Instance.new("UICorner",toast).CornerRadius = UDim.new(0,12)

    local bar = Instance.new("Frame",toast)
    bar.Size = UDim2.new(0,6,1,0)
    bar.Position = UDim2.new(0,0,0,0)
    bar.BackgroundColor3 = color or Color3.fromRGB(90,150,255)
    bar.BorderSizePixel = 0
    Instance.new("UICorner",bar).CornerRadius = UDim.new(0,12)

    local t = Instance.new("TextLabel",toast)
    t.Size = UDim2.new(1,-20,0,20)
    t.Position = UDim2.new(0,12,0,6)
    t.BackgroundTransparency = 1
    t.Text = title or "Notice"
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextColor3 = Color3.fromRGB(255,255,255)

    local m = Instance.new("TextLabel",toast)
    m.Size = UDim2.new(1,-20,0,36)
    m.Position = UDim2.new(0,12,0,28)
    m.BackgroundTransparency = 1
    m.Text = msg or ""
    m.Font = Enum.Font.Gotham
    m.TextSize = 13
    m.TextWrapped = true
    m.TextColor3 = Color3.fromRGB(220,220,220)

    TweenService:Create(toast, TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {BackgroundTransparency=0.15,Position=UDim2.new(1,-12,1,-12)}):Play()

    task.delay(3,function()
        local tw = TweenService:Create(toast,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {BackgroundTransparency=1,Position=UDim2.new(1,-12,1,20)})
        tw:Play()
        tw.Completed:Wait()
        toast:Destroy()
    end)
end

-- Main GUI
local screenGui = Instance.new("ScreenGui",playerGui)
screenGui.Name = "ROBLXHub"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame",screenGui)
frame.Size = UDim2.new(0,280,0,180)
frame.Position = UDim2.new(0.5,-140,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(28,28,36)
frame.BorderSizePixel = 0
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)

-- TopBar
local topBar = Instance.new("Frame",frame)
topBar.Size = UDim2.new(1,0,0,34)
topBar.BackgroundColor3 = Color3.fromRGB(60,135,245)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel",topBar)
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "BY ROBLX MODS"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeButton = Instance.new("TextButton",topBar)
closeButton.Size = UDim2.new(0,28,0,28)
closeButton.Position = UDim2.new(1,-34,0,3)
closeButton.BackgroundColor3 = Color3.fromRGB(255,70,70)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.BorderSizePixel = 0
Instance.new("UICorner",closeButton).CornerRadius = UDim.new(0,10)

-- Minimize button
local minimizeButton = Instance.new("TextButton",topBar)
minimizeButton.Size = UDim2.new(0,28,0,28)
minimizeButton.Position = UDim2.new(1,-70,0,3)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255,200,70)
minimizeButton.Text = "—"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.BorderSizePixel = 0
Instance.new("UICorner",minimizeButton).CornerRadius = UDim.new(0,10)

-- Scrollable content
local content = Instance.new("ScrollingFrame",frame)
content.Size = UDim2.new(1,0,1,-34)
content.Position = UDim2.new(0,0,0,34)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 6
content.Active = true
content.ClipsDescendants = true
local layout = Instance.new("UIListLayout",content)
layout.Padding = UDim.new(0,4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12)
end)

-- Drag system
local dragging = false
local dragInput,startPos
local function update(input)
    if dragging and input.Position then
        local delta = input.Position - dragInput
        frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                   startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input.Position
        startPos = frame.Position
        ContextActionService:BindAction("blockCamera",function() return Enum.ContextActionResult.Sink end,false,
            Enum.UserInputType.MouseMovement,Enum.UserInputType.Touch)
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then
                dragging = false
                ContextActionService:UnbindAction("blockCamera")
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(update)

-- Connect button click
local function connectClick(btn,fn)
    local busy=false
    btn.AutoButtonColor=true
    btn.Active=true
    btn.Selectable=true
    btn.MouseButton1Click:Connect(function()
        if busy then return end
        busy=true
        pcall(fn)
        task.delay(0.18,function() busy=false end)
    end)
    btn.TouchTap:Connect(function()
        if busy then return end
        busy=true
        pcall(fn)
        task.delay(0.18,function() busy=false end)
    end)
end

-- Safe HttpGet
local function safeRunScript(url,label)
    notify("Loading","Downloading "..label,Color3.fromRGB(90,150,255))
    local success, res = pcall(function() return game:HttpGet(url) end)
    if not success then
        notify("Error","Failed to download "..label,Color3.fromRGB(255,90,90))
        return
    end
    local ok, fn = pcall(loadstring,res)
    if not ok then
        notify("Error","Failed to compile "..label,Color3.fromRGB(255,90,90))
        return
    end
    local executed, err = pcall(fn)
    if executed then
        notify("Done",label.." executed",Color3.fromRGB(90,200,120))
    else
        notify("Error","Runtime error in "..label..": "..tostring(err),Color3.fromRGB(255,90,90))
    end
end

-- Create button
local function createButton(label,url,disabled)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,240,0,32)
    btn.BackgroundColor3 = disabled and Color3.fromRGB(90,90,90) or Color3.fromRGB(70,70,100)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = disabled and label.." (disabled)" or label
    btn.Parent = content
    Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
    if disabled then
        connectClick(btn,function() notify("Locked","Button disabled",Color3.fromRGB(255,150,90)) end)
    else
        connectClick(btn,function() safeRunScript(url,label) end)
    end
end

-- Example buttons
createButton("🌶️ CHILLI","https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
createButton("🦘 DELFI","https://pastefy.app/pQxsA7BR/raw")
createButton("🔝 Miranda Hub","https://pastefy.app/9YIyWc7E/raw")
createButton("🔥 SERVER OP","https://raw.githubusercontent.com/murilolol/nslx-autojoiner/refs/heads/main/free.lua")
createButton("⚡ Low Graphics","https://pastebin.com/raw/dBMpC7ma")
createButton("⭐ KurdHub","https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Stel")

-- Minimize
local isMin=false
minimizeButton.MouseButton1Click:Connect(function()
    if isMin then
        content.Visible=true
        TweenService:Create(frame,TweenInfo.new(0.28),{Size=UDim2.new(0,280,0,180)}):Play()
        isMin=false
    else
        content.Visible=false
        TweenService:Create(frame,TweenInfo.new(0.28),{Size=UDim2.new(0,280,0,34)}):Play()
        isMin=true
    end
end)

-- Close button
connectClick(closeButton,function()
    screenGui:Destroy()
    notify("Closed","Hub closed",Color3.fromRGB(255,90,90))
end)

print("✅ BY ROBLX MODS Hub loaded successfully")
