-- // TITAN GOD V80 (ALL IN ONE) //
-- // YAPIMCI: ENS //

if not game:IsLoaded() then game.Loaded:Wait() end

-- // SERVİSLER
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // AYARLAR
local PASSWORD = "1234"
local TOGGLE_KEY = Enum.KeyCode.RightControl
local SPIN_SPEED = 100
local AIM_FOV = 400

-- // TEMA
local T_BG = Color3.fromRGB(15, 15, 15)
local T_SIDE = Color3.fromRGB(20, 20, 20)
local T_ACCENT = Color3.fromRGB(255, 0, 0) -- Kan Kırmızısı
local T_TEXT = Color3.fromRGB(255, 255, 255)

-- // DURUMLAR (TÜM ÖZELLİKLER)
local States = {
    -- Rage
    Spinbot = false,
    VisualFix = true,
    HardLock = false,
    KillAura = false,
    TriggerBot = false,
    -- Hareket
    Bhop = false,
    Speed = false,
    Noclip = false,
    Fly = false,
    -- MM2
    AutoGun = false,
    KillAll = false,
    RoleESP = false,
    -- Görsel
    ESP = false,
    WallCheck = false
}

-- // TEMİZLİK
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "EnsTitanV80" or v.Name == "EnsESPContainer" then v:Destroy() end
end

-- // --- GUI OLUŞTURMA --- //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnsTitanV80"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- MOBİL GİZLEME BUTONU
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
ToggleBtn.BackgroundColor3 = T_BG
ToggleBtn.Text = "V80"
ToggleBtn.TextColor3 = T_ACCENT
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.Visible = false -- Şifreden sonra açılır
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ToggleBtn).Color = T_ACCENT

-- ANA MENÜ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = T_BG
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = T_ACCENT

-- YAN MENÜ (TABLAR)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0.3, 0, 1, 0)
Sidebar.BackgroundColor3 = T_SIDE
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Text = "TITAN V80"
Title.Size = UDim2.new(1, 0, 0.15, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = T_ACCENT
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.Parent = Sidebar

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0.85, 0)
TabHolder.Position = UDim2.new(0, 0, 0.15, 0)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Sidebar
local TabList = Instance.new("UIListLayout"); TabList.Parent = TabHolder; TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- İÇERİK ALANI
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0.68, 0, 0.9, 0)
Content.Position = UDim2.new(0.31, 0, 0.05, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- // --- UI FONKSİYONLARI --- //
local CurrentTab = nil

local function CreateTab(name, color)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = TabHolder
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.Parent = Content
    local PL = Instance.new("UIListLayout"); PL.Parent = TabPage; PL.Padding = UDim.new(0, 5)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150,150,150) end end
        for _, v in pairs(Content:GetChildren()) do v.Visible = false end
        TabBtn.TextColor3 = color or T_TEXT
        TabPage.Visible = true
    end)
    
    if CurrentTab == nil then CurrentTab = TabPage; TabPage.Visible = true; TabBtn.TextColor3 = color or T_TEXT end
    return TabPage
end

local function CreateBtn(page, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = text
    btn.TextColor3 = T_TEXT
    btn.Font = Enum.Font.Gotham
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        local state = not btn:GetAttribute("Active")
        btn:SetAttribute("Active", state)
        if state then btn.BackgroundColor3 = T_ACCENT; btn.TextColor3 = Color3.new(0,0,0)
        else btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.TextColor3 = T_TEXT end
        callback(state, btn)
    end)
end

-- // --- SİSTEMLER --- //

-- 1. HEDEF BULUCU
local function GetTarget()
    local target, dist = nil, 999999
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local mag = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = p.Character.HumanoidRootPart
            end
        end
    end
    return target
end

-- 2. ANA DÖNGÜ (SPIN, BHOP, AIM)
RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = LocalPlayer.Character.HumanoidRootPart
    local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local Target = GetTarget()

    -- SPINBOT
    if States.Spinbot then
        Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(SPIN_SPEED), 0)
    end

    -- BHOP
    if States.Bhop and Humanoid then
        if Humanoid.MoveDirection.Magnitude > 0 then
            if Humanoid.FloorMaterial ~= Enum.Material.Air then Humanoid.Jump = true end
        end
    end

    -- SPEED
    if States.Speed and Humanoid then
        Humanoid.WalkSpeed = 100
    end

    -- HARD LOCK (AIM)
    if States.HardLock and Target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
    elseif States.VisualFix and States.Spinbot and Humanoid then
        Humanoid.AutoRotate = false
    else
        if Humanoid then Humanoid.AutoRotate = true end
    end
end)

-- 3. NOCLIP
RunService.Stepped:Connect(function()
    if States.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 4. KILL AURA
task.spawn(function()
    while true do
        if States.KillAura then
            local t = GetTarget()
            if t and LocalPlayer.Character then
                local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if myRoot and tool then
                    myRoot.CFrame = t.CFrame * CFrame.new(0, 0, 3) 
                    tool:Activate()
                end
            end
        end
        task.wait(0.1)
    end
end)

-- 5. TRIGGER BOT
task.spawn(function()
    while true do
        if States.TriggerBot and LocalPlayer.Character then
            local t = Mouse.Target
            if t and t.Parent and t.Parent:FindFirstChild("Humanoid") then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
        task.wait(0.05)
    end
end)

-- 6. OTO SİLAH (KENE)
local isGettingGun = false
local function AttemptGetGun(gun)
    if isGettingGun or not States.AutoGun then return end
    local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    if not root or not gun then return end
    isGettingGun = true
    local saved = root.CFrame
    local s = tick()
    repeat
        root.CFrame = gun.Handle.CFrame; root.Velocity = Vector3.zero
        if gun:IsA("Tool") then humanoid:EquipTool(gun) end
        task.wait()
    until (not States.AutoGun) or (tick() - s > 2) or (gun.Parent ~= Workspace)
    root.CFrame = saved; isGettingGun = false
end

task.spawn(function()
    while true do
        if States.AutoGun then
            for _, o in pairs(Workspace:GetDescendants()) do
                if (o.Name == "GunDrop" or o.Name:find("Gun")) and o:FindFirstChild("Handle") then
                    AttemptGetGun(o)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- 7. KILL ALL
task.spawn(function()
    while true do
        if States.KillAll then
            local t = GetTarget()
            local c = LocalPlayer.Character
            local k = c:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife") or c:FindFirstChild("Bıçak")
            if t and k then
                if k.Parent ~= c then c.Humanoid:EquipTool(k) end
                c.HumanoidRootPart.CFrame = t.CFrame * CFrame.new(0,0,2.5)
                k:Activate()
            end
        end
        task.wait(0.35)
    end
end)

-- 8. ESP
local ESPContainer = Instance.new("Folder", CoreGui); ESPContainer.Name = "EnsESPContainer"
task.spawn(function()
    while true do
        ESPContainer:ClearAllChildren()
        if States.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hl = Instance.new("Highlight", ESPContainer)
                    hl.Adornee = p.Character
                    hl.FillColor = T_ACCENT
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.5
                end
            end
        end
        task.wait(1)
    end
end)

-- // --- TABLAR --- //
local TabRage = CreateTab("👹 RAGE", Color3.fromRGB(255, 50, 50))
local TabMove = CreateTab("🏃 HAREKET")
local TabMM2 = CreateTab("🔪 MM2")
local TabVisual = CreateTab("👁️ GÖRSEL")
local TabAdmin = CreateTab("👑 ADMİN")

-- RAGE BUTONLARI
CreateBtn(TabRage, "🌀 SPINBOT (MEVLANA)", function(s) States.Spinbot = s end)
CreateBtn(TabRage, "👀 VISUAL FIX (KAMERA)", function(s) States.VisualFix = s end)
CreateBtn(TabRage, "💀 HARD LOCK (AIM)", function(s) States.HardLock = s end)
CreateBtn(TabRage, "🔪 KILL AURA", function(s) States.KillAura = s end)
CreateBtn(TabRage, "🤬 TRIGGER BOT", function(s) States.TriggerBot = s end)

-- HAREKET BUTONLARI
CreateBtn(TabMove, "🐇 BHOP (OTO ZIPLA)", function(s) States.Bhop = s end)
CreateBtn(TabMove, "⚡ SPEED (100)", function(s) States.Speed = s end)
CreateBtn(TabMove, "🧱 NOCLIP", function(s) States.Noclip = s end)
CreateBtn(TabMove, "🕊️ FLY (UÇMA)", function(s) 
    States.Fly = s
    if s then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bv.Name = "TitanFly"; bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        while States.Fly do
            bv.Velocity = Camera.CFrame.LookVector * 50
            RunService.RenderStepped:Wait()
        end
        bv:Destroy()
    end
end)

-- MM2 BUTONLARI
CreateBtn(TabMM2, "🔫 OTO SİLAH (KENE)", function(s) States.AutoGun = s end)
CreateBtn(TabMM2, "🩸 KILL ALL", function(s) States.KillAll = s end)
CreateBtn(TabMM2, "🛡️ ROL ESP", function(s) States.RoleESP = s end) -- Basit ESP içine dahil

-- GÖRSEL BUTONLARI
CreateBtn(TabVisual, "👁️ ESP (WALLHACK)", function(s) States.ESP = s end)
CreateBtn(TabVisual, "💡 FULLBRIGHT", function() Lighting.Brightness=2; Lighting.ClockTime=14 end)

-- ADMİN BUTONLARI
CreateBtn(TabAdmin, "💸 DOLLAR HUB", function(s, b) loadstring(game:HttpGet("https://purplesstrat.github.io/Scripts/Cracked/DollarHub.lua"))(); b.Text="AÇILDI" end)
CreateBtn(TabAdmin, "🚀 INFINITE YIELD", function(s, b) loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))(); b.Text="AÇILDI" end)

-- // --- SİSTEM --- //
local function ToggleMenu() MainFrame.Visible = not MainFrame.Visible end
ToggleBtn.MouseButton1Click:Connect(ToggleMenu)
UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == TOGGLE_KEY then ToggleMenu() end end)

-- ŞİFRE
local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size=UDim2.new(0,250,0,150); KeyFrame.Position=UDim2.new(0.5,-125,0.5,-75); KeyFrame.BackgroundColor3=T_BG
Instance.new("UIStroke", KeyFrame).Color = T_ACCENT; Instance.new("UIStroke", KeyFrame).Thickness = 2
local Box = Instance.new("TextBox", KeyFrame); Box.Size=UDim2.new(0.8,0,0.3,0); Box.Position=UDim2.new(0.1,0,0.2,0); Box.Text="Şifre Gir"; Box.BackgroundColor3=Color3.new(0.2,0.2,0.2); Box.TextColor3=Color3.new(1,1,1)
local Btn = Instance.new("TextButton", KeyFrame); Btn.Size=UDim2.new(0.8,0,0.3,0); Btn.Position=UDim2.new(0.1,0,0.6,0); Btn.Text="GİR"; Btn.BackgroundColor3=T_ACCENT
Btn.MouseButton1Click:Connect(function()
    if Box.Text == PASSWORD then KeyFrame.Visible=false; ToggleMenu(); ToggleBtn.Visible=true else Box.Text="YANLIŞ" end
end)
