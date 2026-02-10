--[[
    VELOX TESTER V3 (MULTI-TOUCH FIX)
    Oleh: Gemini Assistant
    Fitur: 
    1. Anti-Freeze (Menggunakan Touch ID berbeda dari Analog).
    2. Auto-Detect Button Position.
]]

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxTesterV3") then
    CoreGui.VeloxTesterV3:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxTesterV3"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TESTER V3: ANTI-FREEZE"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(0.9, 0, 0.4, 0)
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
-- [CORE] FUNGSI TAP (MULTI-TOUCH)
-- ==============================================================================

-- Fungsi untuk mengetuk koordinat tertentu dengan "Jari ke-2" (ID 1)
-- ID 0 = Biasanya Analog/Jari kamu
local function TapAt(x, y)
    -- TouchStart (Tekan)
    VirtualInputManager:SendTouchEvent(1729, 0, x, y) -- ID acak biar gak konflik
    task.wait(0.05)
    -- TouchEnd (Lepas)
    VirtualInputManager:SendTouchEvent(1729, 1, x, y)
end

-- Fungsi mencari tombol lalu mengetuk tengahnya
local function TapButton(btn)
    if not btn then return false end
    if not btn.Visible then return false end

    -- Hitung posisi tengah tombol di layar
    local AbsolutePos = btn.AbsolutePosition
    local AbsoluteSize = btn.AbsoluteSize
    local CenterX = AbsolutePos.X + (AbsoluteSize.X / 2)
    local CenterY = AbsolutePos.Y + (AbsoluteSize.Y / 2)
    
    -- Lakukan Tap
    TapAt(CenterX, CenterY)
    return true
end

-- ==============================================================================
-- LOGIKA TOMBOL
-- ==============================================================================

local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(0.9, 0, 0.45, 0)
BtnContainer.Position = UDim2.new(0.05, 0, 0.52, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.48, 0, 0.18, 0); Grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0); Grid.Parent = BtnContainer

local function MakeBtn(text, cb)
    local b = Instance.new("TextButton")
    b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.Parent = BtnContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

-- 1. TEST M1 (SAFE ZONE TAP)
MakeBtn("TEST M1 (SAFE)", function()
    -- Kita tap di sebelah kanan tengah layar (Safe Zone)
    -- Hindari area analog kiri
    local X = Camera.ViewportSize.X * 0.7 -- 70% ke kanan
    local Y = Camera.ViewportSize.Y * 0.5 -- 50% ke bawah
    
    TapAt(X, Y)
    AddLog("M1: Tapped at Safe Zone", Color3.fromRGB(100, 255, 100))
end)

-- 2. TEST JUMP
MakeBtn("TEST JUMP", function()
    -- Path Jump (Sesuai data kamu)
    local JumpBtn = PlayerGui:FindFirstChild("TouchGui") 
        and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") 
        and PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")
    
    if TapButton(JumpBtn) then
        AddLog("Jump: Tapped Button UI", Color3.fromRGB(100, 255, 100))
    else
        AddLog("Jump: Button Not Found!", Color3.fromRGB(255, 80, 80))
    end
end)

-- 3. TEST HAKI (BUSO)
MakeBtn("TEST BUSO (HAKI)", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    
    -- Nama tombol bisa BoundActionBuso atau BoundActionKen (Cek dua-duanya)
    local Buso = Ctx and (Ctx:FindFirstChild("BoundActionBuso") or Ctx:FindFirstChild("BoundActionAura"))
    
    if Buso and TapButton(Buso:FindFirstChild("Button")) then
        AddLog("Buso: Tapped!", Color3.fromRGB(100, 255, 100))
    else
        AddLog("Buso: Missing/Cooldown", Color3.fromRGB(255, 80, 80))
    end
end)

-- 4. TEST SORU (FLASH STEP)
MakeBtn("TEST SORU", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    local Soru = Ctx and Ctx:FindFirstChild("BoundActionSoru")
    
    if Soru and TapButton(Soru:FindFirstChild("Button")) then
        AddLog("Soru: Tapped!", Color3.fromRGB(100, 255, 100))
    else
        AddLog("Soru: Missing/Cooldown", Color3.fromRGB(255, 80, 80))
    end
end)

-- 5. TEST DODGE
MakeBtn("TEST DODGE", function()
    -- Dodge biasanya di ContextButtonFrame juga (BoundActionDodge)
    -- ATAU di MobileControl
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    
    local Dodge = Ctx and (Ctx:FindFirstChild("BoundActionDodge") or Ctx:FindFirstChild("BoundActionDash"))
    
    if Dodge and TapButton(Dodge:FindFirstChild("Button")) then
         AddLog("Dodge: Tapped (Context)", Color3.fromRGB(100, 255, 100))
    else
        -- Cek Mobile Control (Backup)
        local Main = PlayerGui:FindFirstChild("Main")
        local Ctrl = Main and Main:FindFirstChild("MobileControl")
        local DashBtn = Ctrl and Ctrl:FindFirstChild("Dash")
        
        if TapButton(DashBtn) then
            AddLog("Dodge: Tapped (MainUI)", Color3.fromRGB(100, 255, 100))
        else
            AddLog("Dodge: Not Found", Color3.fromRGB(255, 80, 80))
        end
    end
end)

-- 6. TEST RACE SKILL
MakeBtn("TEST RACE V3/V4", function()
    local Ctx = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    local Race = Ctx and Ctx:FindFirstChild("BoundActionRaceAbility")
    
    if Race and TapButton(Race:FindFirstChild("Button")) then
        AddLog("Race: Tapped!", Color3.fromRGB(100, 255, 100))
    else
        AddLog("Race: Not Found", Color3.fromRGB(255, 80, 80))
    end
end)

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
