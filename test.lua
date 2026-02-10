--[[
    VELOX TESTER V5 (FORCE FIRE)
    Oleh: Gemini Assistant
    Metode: Memaksa sinyal tombol jalan tanpa menyentuh layar.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser") -- Metode alternatif M1
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

if CoreGui:FindFirstChild("VeloxTesterV5") then CoreGui.VeloxTesterV5:Destroy() end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxTesterV5"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0) -- Merah Gelap (Mode Agresif)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 50, 50)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TESTER V5: FORCE MODE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(0.9, 0, 0.35, 0)
LogScroll.Position = UDim2.new(0.05, 0, 0.1, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
LogScroll.Parent = MainFrame
local UIList = Instance.new("UIListLayout"); UIList.Parent=LogScroll

local function AddLog(text, color)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = "> " .. text
    Label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Code
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LogScroll
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    LogScroll.CanvasPosition = Vector2.new(0, 9999)
end

-- ==============================================================================
-- [CORE] FUNGSI NUKLIR (FORCE FIRE)
-- ==============================================================================

local function ForceFire(btn, name)
    if not btn then 
        AddLog(name..": NOT FOUND (Cek Path)", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    local Success = false
    
    -- CARA 1: Activated (Standard)
    local Cons1 = getconnections(btn.Activated)
    for _, c in pairs(Cons1) do c:Fire(); Success = true end
    
    -- CARA 2: MouseButton1Click (Standard PC/Mobile)
    local Cons2 = getconnections(btn.MouseButton1Click)
    for _, c in pairs(Cons2) do c:Fire(); Success = true end

    -- CARA 3: MouseButton1Down (Tekan)
    local Cons3 = getconnections(btn.MouseButton1Down)
    for _, c in pairs(Cons3) do c:Fire(); Success = true end
    
    -- CARA 4: InputBegan (Khusus Jump Button Roblox)
    local Cons4 = getconnections(btn.InputBegan)
    for _, c in pairs(Cons4) do 
        -- Kita palsukan InputObject agar script gamenya percaya
        local FakeInput = Instance.new("InputObject")
        -- Kita tidak bisa set properti InputObject via script biasa, 
        -- jadi kita harap signalnya tidak butuh argumen spesifik.
        c:Fire(FakeInput) 
        Success = true 
    end

    if Success then
        AddLog(name..": FIRED!", Color3.fromRGB(0, 255, 0))
    else
        AddLog(name..": NO SIGNAL FOUND (Tombol mati)", Color3.fromRGB(255, 255, 0))
    end
end

-- ==============================================================================
-- LOGIKA TOMBOL
-- ==============================================================================

local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(0.9, 0, 0.5, 0)
BtnContainer.Position = UDim2.new(0.05, 0, 0.48, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.48, 0, 0.15, 0); Grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0); Grid.Parent = BtnContainer

local function MakeBtn(text, cb)
    local b = Instance.new("TextButton")
    b.Text = text; b.BackgroundColor3 = Color3.fromRGB(50,50,60); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.Parent = BtnContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

-- 1. TEST M1 (VIRTUAL USER) - ANTI FREEZE 2.0
MakeBtn("TEST M1 (VU)", function()
    -- Metode VirtualUser (Biasanya dipakai di PC, tapi kadang work di Mobile)
    -- Ini tidak pakai Touch, tapi simulasi Mouse Internal
    local s, e = pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        AddLog("M1: VirtualUser Clicked", Color3.fromRGB(0, 255, 255))
    end)
    if not s then AddLog("M1 Error: "..e, Color3.fromRGB(255, 0, 0)) end
end)

-- 2. TEST JUMP
MakeBtn("TEST JUMP", function()
    local JumpBtn = PlayerGui:FindFirstChild("TouchGui") 
        and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") 
        and PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")
    
    ForceFire(JumpBtn, "Jump")
end)

-- 3. TEST HAKI (KEN)
MakeBtn("TEST KEN", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    local Ken = Ctx and Ctx:FindFirstChild("BoundActionKen")
    local Btn = Ken and Ken:FindFirstChild("Button")
    
    ForceFire(Btn, "Ken")
end)

-- 4. TEST SORU
MakeBtn("TEST SORU", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    local Soru = Ctx and Ctx:FindFirstChild("BoundActionSoru")
    local Btn = Soru and Soru:FindFirstChild("Button")
    
    ForceFire(Btn, "Soru")
end)

-- 5. TEST RACE
MakeBtn("TEST RACE", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    local Race = Ctx and Ctx:FindFirstChild("BoundActionRaceAbility")
    local Btn = Race and Race:FindFirstChild("Button")
    
    ForceFire(Btn, "Race")
end)

-- 6. TEST M1 (REMOTE + ANIMATION)
MakeBtn("TEST M1 (REMOTE)", function()
    -- Jika VU dan Touch gagal, ini harapan terakhir M1
    -- Pakai Remote + Paksa Animasi Combat (Biar kelihatan mukul)
    
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local args = { [1] = 0.4 }
    ReplicatedStorage.Modules.Net:FindFirstChild("RE/RegisterAttack"):FireServer(unpack(args))
    AddLog("M1: Remote Sent (Invisible)", Color3.fromRGB(255, 100, 255))
end)

local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
