-- ===== 0) إعداد المتغيرات =====
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")

local TXT_COLOR = Color3.fromRGB(0, 255, 170)
local BG_COLOR  = Color3.fromRGB(18, 18, 18)
local NEW_BRAND = "BY ROBLX MODS"

-- ===== 1) جمع الحاويات =====
local function listContainers()
    local t = {CoreGui, PlayerGui}
    local ok, hidden = pcall(function() return gethui and gethui() end)
    if ok and typeof(hidden) == "Instance" then table.insert(t, hidden) end
    return t
end

-- ===== 2) التحقق من Speed Hub =====
local function containsSpeedHub(inst)
    local n = tostring(inst.Name):lower()
    if n:find("speed") and n:find("hub") then return true end
    for _, d in ipairs(inst:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text then
            local txt = d.Text:lower()
            if txt:find("speed") and txt:find("hub") then return true end
        end
    end
    return false
end

-- ===== 3) تطبيق الألوان =====
local function applyColors(root)
    for _, v in ipairs(root:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            v.TextColor3 = TXT_COLOR
        elseif v:IsA("Frame") or v:IsA("TextBox") then
            v.BackgroundColor3 = BG_COLOR
        end
    end
end

-- ===== 4) تغيير اسم الواجهة =====
local function renameHub(root)
    for _, v in ipairs(root:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text then
            local txt = v.Text:lower()
            if txt:find("speed") and txt:find("hub") then
                v.Text = NEW_BRAND
            end
        end
    end
end

-- ===== 5) انتظار الواجهة =====
local function waitForHub(timeout)
    local start = os.clock()
    while os.clock() - start < (timeout or 25) do
        for _, root in ipairs(listContainers()) do
            for _, g in ipairs(root:GetChildren()) do
                if g:IsA("ScreenGui") or g.ClassName:find("LayerCollector") then
                    if containsSpeedHub(g) then return g end
                end
            end
        end
        task.wait(0.5)
    end
    return nil
end

-- ===== 6) تشغيل السكربت الأصلي وتطبيق الألوان والاسم =====
task.spawn(function()
    -- تحميل السكربت الأصلي
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if not ok then warn("Original script error: "..tostring(err)) end

    -- ننتظر ظهور GUI ديال Speed Hub
    local hub = waitForHub(25)
    if hub then
        applyColors(hub)
        renameHub(hub)
        print("✅ تم تغيير الألوان وتحديث اسم الواجهة إلى:", NEW_BRAND)
    else
        warn("❌ ما لقيتش GUI ديال Speed Hub.")
    end
end)
