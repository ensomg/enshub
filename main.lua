-- // OYUNUN YÜKLENMESİNİ BEKLE
if not game:IsLoaded() then game.Loaded:Wait() end

-- // SERVİSLER
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // AYARLAR
local PASSWORD = "1234"
local FLING_SPEED = 20000
local AIM_FOV = 300
local AIMBOT_KEY = Enum.UserInputType.MouseButton2

-- // TEMA (MAT SİYAH & KAN KIRMIZISI)
local T_BG = Color3.fromRGB(12, 12, 12)
local T_SIDE = Color3.fromRGB(18, 18, 18)
local T_ACCENT = Color3.fromRGB(220, 20, 20) -- MM2 Kırmızısı
local T_TEXT = Color3.fromRGB(240, 240, 240)
local T_BTN = Color3.fromRGB(25, 25, 30)

-- // DURUMLAR
local States = {
    Fling = false,
    GlobalAimbot = false,
    MM2Aimbot = false,
    GlobalESP = false,
    MM2ESP = false,
    KillAll = false,
    AutoGun = false,
    Noclip = false, 
    Speed = false
}

-- // TEMİZLİK
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "EnsMM2SpecialV68" or v.Name == "EnsESPFolder" then v:Destroy() end
end

-- // GUI OLUŞTURMA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnsMM2SpecialV68"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ANA ÇERÇEVE
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = T_BG
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = T_ACCENT
Stroke.Thickness = 1.5

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0.25, 0, 1, 0)
Sidebar.BackgroundColor3 = T_SIDE
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SidebarFix = Instance.new("Frame")
SidebarFix.Size = UDim2.new(0.1, 0, 1, 0)
SidebarFix.Position = UDim2.new(0.9, 0, 0, 0)
SidebarFix.BackgroundColor3 = T_SIDE
SidebarFix.BorderSizePixel = 0
SidebarFix.Parent = Sidebar

-- Başlık
local Title = Instance.new("TextLabel")
Title.Text = "ENS V68"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = T_ACCENT
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.Parent = Sidebar

-- Tab Tutucu
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0.9, 0)
TabHolder.Position = UDim2.new(0, 0, 0.1, 0)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Sidebar
local TabList = Instance.new("UIListLayout")
TabList.Parent = TabHolder
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- İçerik
local Content = Instance.new("Frame")
Content.Size = UDim2.new(0.73, 0, 0.9, 0)
Content.Position = UDim2.new(0.26, 0, 0.05, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Kapatma
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() 
    local t = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
    t:Play(); t.Completed:Wait(); ScreenGui.Enabled = false 
end)

-- // --- UI SİSTEMİ --- //
local CurrentTab = nil
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    TabBtn.Parent = TabHolder
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.Parent = Content
    
    local PageList = Instance.new("UIListLayout")
    PageList.Parent = TabPage
    PageList.Padding = UDim.new(0, 8)
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(TabHolder:GetChildren()) do if v:IsA("TextButton") then TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150,150,150)}):Play() end end
        for _, v in pairs(Content:GetChildren()) do v.Visible = false end
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = T_TEXT}):Play()
        TabPage.Visible = true
    end)
    
    if CurrentTab == nil then CurrentTab = TabPage; TabPage.Visible = true; TabBtn.TextColor3 = T_TEXT end
    return TabPage
end

local function CreateBtn(page, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = T_BTN
    Btn.Text = text
    Btn.TextColor3 = T_TEXT
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.Parent = page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,45,50)}):Play() end)
    Btn.MouseLeave:Connect(function() if not Btn:GetAttribute("Active") then TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = T_BTN}):Play() end end)
    
    Btn.MouseButton1Click:Connect(function()
        local isActive = not Btn:GetAttribute("Active")
        Btn:SetAttribute("Active", isActive)
        if isActive then TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = T_ACCENT, TextColor3 = Color3.new(0,0,0)}):Play()
        else TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = T_BTN, TextColor3 = T_TEXT}):Play() end
        callback(isActive, Btn)
    end)
end

-- // --- FONKSİYONLAR --- //

-- ROL BULUCU
local function GetPlayerRole(plr)
    local items = {}
    if plr.Backpack then for _, i in pairs(plr.Backpack:GetChildren()) do table.insert(items, i) end end
    if plr.Character then for _, i in pairs(plr.Character:GetChildren()) do table.insert(items, i) end end
    for _, item in pairs(items) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("knife") or n:find("bıçak") then return "Murderer" end
            if n:find("gun") or n:find("revolver") then return "Sheriff" end
        end
    end
    return "Innocent"
end

-- AUTO GUN (MM2 ÖZEL - KENE MODU)
local isGettingGun = false
local function AttemptGetGun(gun)
    if isGettingGun or not States.AutoGun then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChild("Humanoid")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if not root or not gun or not gun.Parent then return end
    local handle = gun:FindFirstChild("Handle") or gun
    if not handle:IsA("BasePart") then return end
    
    isGettingGun = true
    local savedCFrame = root.CFrame
    local sTime = tick()
    
    repeat
        root.CFrame = handle.CFrame
        root.Velocity = Vector3.zero
        if gun:IsA("Tool") then humanoid:EquipTool(gun) end
        task.wait()
    until (not States.AutoGun) or (tick() - sTime > 3) or (backpack:FindFirstChild(gun.Name)) or (char:FindFirstChild(gun.Name)) or (gun.Parent ~= Workspace)
    
    root.CFrame = savedCFrame
    isGettingGun = false
end

local function AutoGunLoop()
    while States.AutoGun do
        local targetGun = nil
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "GunDrop" or (obj:IsA("Tool") and (obj.Name:find("Gun") or obj.Name:find("Revolver"))) then targetGun = obj; break end
        end
        if targetGun then AttemptGetGun(targetGun) end
        task.wait(0.5)
    end
end

-- FLING (DÖNMEYEN)
local function StartFling()
    task.spawn(function()
        while States.Fling do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local r = LocalPlayer.Character.HumanoidRootPart
                r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                local v = r.AssemblyLinearVelocity
                r.AssemblyLinearVelocity = Vector3.new(v.X, -50, v.Z)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- ESP SİSTEMİ (MM2 ve GLOBAL)
local ESPFolder = Instance.new("Folder", game.CoreGui); ESPFolder.Name = "EnsESPFolder"
task.spawn(function()
    while true do
        ESPFolder:ClearAllChildren()
        
        -- MM2 ESP
        if States.MM2ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local role = GetPlayerRole(p)
                    local col = Color3.new(1,1,1)
                    if role == "Murderer" then col = Color3.fromRGB(255, 0, 0) end
                    if role == "Sheriff" then col = Color3.fromRGB(0, 100, 255) end
                    
                    if role ~= "Innocent" then -- Sadece önemli rolleri göster
                        local hl = Instance.new("Highlight", ESPFolder); hl.Adornee = p.Character; hl.FillColor = col; hl.OutlineColor = col; hl.FillTransparency = 0.5
                    end
                end
            end
            -- Silah ESP
            for _, o in pairs(Workspace:GetDescendants()) do
                if o.Name == "GunDrop" then
                    local hl = Instance.new("Highlight", ESPFolder); hl.Adornee = o; hl.FillColor = Color3.fromRGB(255,215,0); hl.OutlineColor=Color3.fromRGB(255,215,0)
                end
            end
        end

        -- GLOBAL ESP
        if States.GlobalESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hl = Instance.new("Highlight", ESPFolder); hl.Adornee = p.Character; hl.FillColor = Color3.fromRGB(255,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255); hl.FillTransparency = 0.5
                end
            end
        end
        task.wait(1)
    end
end)

-- AIMBOT SİSTEMİ
local FOVCircle = Drawing.new("Circle"); FOVCircle.Visible=false; FOVCircle.Radius=AIM_FOV; FOVCircle.Color=T_ACCENT; FOVCircle.Thickness=1
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Visible = (States.GlobalAimbot or States.MM2Aimbot)
    
    if (States.GlobalAimbot or States.MM2Aimbot) and UserInputService:IsMouseButtonPressed(AIMBOT_KEY) then
        local Target, Dist = nil, AIM_FOV
        local MousePos = UserInputService:GetMouseLocation()
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local IsEnemy = true -- Global için herkes düşman
                
                -- MM2 Mantığı
                if States.MM2Aimbot then
                    local MyRole = GetPlayerRole(LocalPlayer)
                    local TRole = GetPlayerRole(p)
                    IsEnemy = false
                    if MyRole == "Sheriff" and TRole == "Murderer" then IsEnemy = true end
                    if MyRole == "Murderer" and TRole ~= "Murderer" then IsEnemy = true end
                    if TRole == "Murderer" then IsEnemy = true end -- Masumsan katile odaklan
                end
                
                if IsEnemy then
                    local pos, vis = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if vis then 
                        local d = (Vector2.new(pos.X, pos.Y) - MousePos).Magnitude
                        if d < Dist then Dist = d; Target = p.Character.HumanoidRootPart end 
                    end
                end
            end
        end
        if Target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Position), 0.2) end
    end
end)

-- NOCLIP
local function ToggleNoclip(state)
    States.Noclip = state
    if state then
        RunService:BindToRenderStep("Noclip", 100, function()
            if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        end)
    else
        RunService:UnbindFromRenderStep("Noclip")
        if LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end
    end
end

-- // --- TABLAR --- //
local TabMM2 = CreateTab("🔪 MM2")
local TabGlobal = CreateTab("⚔️ GLOBAL")
local TabVisual = CreateTab("👁️ GÖRSEL")
local TabAdmin = CreateTab("👑 ADMİN")
local TabMisc = CreateTab("🛠️ DİĞER")

-- 🔪 MM2 TAB
CreateBtn(TabMM2, "🎯 KATİL/ŞERİF AIMBOT", function(s) States.MM2Aimbot = s; States.GlobalAimbot = false end)
CreateBtn(TabMM2, "🛡️ ROL ESP (RENKLİ)", function(s) States.MM2ESP = s; States.GlobalESP = false end)
CreateBtn(TabMM2, "🔫 OTO SİLAH (KENE)", function(s) States.AutoGun = s; if s then task.spawn(AutoGunLoop) end end)
CreateBtn(TabMM2, "🔪 KILL ALL (BIÇAK VARSA)", function(s)
    States.KillAll = s
    if s then task.spawn(function()
        while States.KillAll do
            local c = LocalPlayer.Character; local k = c:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife") or c:FindFirstChild("Bıçak")
            if k then
                if k.Parent ~= c then c.Humanoid:EquipTool(k) end
                for _, v in pairs(Players:GetPlayers()) do
                    if not States.KillAll then break end
                    if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        c.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2.5); k:Activate(); task.wait(0.35)
                    end
                end
            end
            task.wait(0.1)
        end
    end) end
end)

-- ⚔️ GLOBAL TAB
CreateBtn(TabGlobal, "🎯 GLOBAL AIMBOT (HERKES)", function(s) States.GlobalAimbot = s; States.MM2Aimbot = false end)
CreateBtn(TabGlobal, "🌪️ FLING (SABİT)", function(s) States.Fling = s; if s then ToggleNoclip(true); StartFling() else ToggleNoclip(false) end end)

-- 👁️ GÖRSEL TAB
CreateBtn(TabVisual, "🛡️ GLOBAL ESP (HERKES)", function(s) States.GlobalESP = s; States.MM2ESP = false end)

-- 👑 ADMİN TAB
CreateBtn(TabAdmin, "💸 DOLLAR HUB (AÇ)", function(s, btn)
    loadstring(game:HttpGet("https://purplesstrat.github.io/Scripts/Cracked/DollarHub.lua"))()
    btn.Text = "ÇALIŞTIRILDI"
end)
CreateBtn(TabAdmin, "🚀 INFINITE YIELD (AÇ)", function(s, btn)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    btn.Text = "ÇALIŞTIRILDI"
end)

-- 🛠️ DİĞER TAB
CreateBtn(TabMisc, "⚡ HIZ: 100", function(s) States.Speed = s; RunService:BindToRenderStep("S",1,function() if States.Speed and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = 100 end end) if not s then LocalPlayer.Character.Humanoid.WalkSpeed=16 end end)
CreateBtn(TabMisc, "🧱 NOCLIP (FIX)", function(s) ToggleNoclip(s) end)
CreateBtn(TabMisc, "🌐 SERVER HOP", function()
    local x = {}
    for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then x[#x + 1] = v.id end
    end
    if #x > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)]) end
end)

-- // --- ŞİFRE --- //
local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size=UDim2.new(0,300,0,150); KeyFrame.Position=UDim2.new(0.5,-150,0.5,-75); KeyFrame.BackgroundColor3=T_BG; KeyFrame.Active=true; KeyFrame.Draggable=true
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0,8); Instance.new("UIStroke", KeyFrame).Color = T_ACCENT
local KBox = Instance.new("TextBox", KeyFrame); KBox.Size=UDim2.new(0.8,0,0.3,0); KBox.Position=UDim2.new(0.1,0,0.2,0); KBox.PlaceholderText="Şifre (1234)"; KBox.BackgroundColor3=T_SIDE; KBox.TextColor3=T_TEXT
Instance.new("UICorner", KBox).CornerRadius = UDim.new(0,4)
local KBtn = Instance.new("TextButton", KeyFrame); KBtn.Size=UDim2.new(0.8,0,0.3,0); KBtn.Position=UDim2.new(0.1,0,0.6,0); KBtn.Text="GİRİŞ"; KBtn.BackgroundColor3=T_ACCENT; KBtn.TextColor3=Color3.new(0,0,0); KBtn.Font=Enum.Font.GothamBold
Instance.new("UICorner", KBtn).CornerRadius = UDim.new(0,4)

KBtn.MouseButton1Click:Connect(function()
    if KBox.Text == PASSWORD then
        TweenService:Create(KeyFrame, TweenInfo.new(0.3), {Position=UDim2.new(0.5,-150,1.5,0)}):Play()
        task.wait(0.3); KeyFrame.Visible=false
        MainFrame.Visible=true; MainFrame.Size=UDim2.new(0,0,0,0)
        TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size=UDim2.new(0,500,0,400)}):Play()
    else KBox.Text="YANLIŞ"; task.wait(1); KBox.Text="" end
end)
