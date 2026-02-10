--[[
    VELOX TESTER V4 (STRICT PATH FIX)
    Oleh: Gemini Assistant
    Fitur: Menggunakan Path Exact dari User. Anti-Freeze M1.
]]

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxTesterV4") then
    CoreGui.VeloxTesterV4:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxTesterV4"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 50, 50)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TESTER V4: STRICT PATH"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- LOG AREA
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
-- [CORE] FUNGSI TAP (ANTI-FREEZE)
-- ==============================================================================

-- Fungsi mengetuk koordinat X,Y dengan Jari ID 1 (Agar Jari ID 0 di Analog tidak putus)
local function TapAt(x, y)
    VirtualInputManager:SendTouchEvent(1000, 0, x, y) -- 0 = TouchStart
    task.wait(0.05)
    VirtualInputManager:SendTouchEvent(1000, 1, x, y) -- 1 = TouchEnd
end

-- Fungsi mencari tombol berdasarkan PATH EXACT lalu mengetuk tengahnya
local function TapPath(guiObject, nameLog)
    if not guiObject then
        AddLog(nameLog .. ": NOT FOUND (Path Salah/Hilang)", Color3.fromRGB(255, 80, 80))
        return
    end
    
    if not guiObject.Visible then
        AddLog(nameLog .. ": HIDDEN (Sedang Cooldown?)", Color3.fromRGB(255, 200, 50))
        return
    end

    -- Hitung posisi tengah tombol
    local AbsPos = guiObject.AbsolutePosition
    local AbsSize = guiObject.AbsoluteSize
    local CenterX = AbsPos.X + (AbsSize.X / 2)
    local CenterY = AbsPos.Y + (AbsSize.Y / 2)
    
    TapAt(CenterX, CenterY)
    AddLog(nameLog .. ": Tapped!", Color3.fromRGB(100, 255, 100))
end

-- ==============================================================================
-- LOGIKA TOMBOL (SESUAI REQUEST)
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

-- 1. TEST M1 (SAFE ZONE TAP)
MakeBtn("TEST M1 (ATTACK)", function()
    -- Strategi: Ketuk layar di area kosong sebelah kanan (tempat jempol kanan biasanya berada)
    -- Ini pasti memicu M1 jika memegang senjata
    local X = Camera.ViewportSize.X * 0.85 -- Agak ke kanan
    local Y = Camera.ViewportSize.Y * 0.6 -- Agak ke bawah
    
    TapAt(X, Y)
    AddLog("M1: Tapped Right Screen", Color3.fromRGB(100, 255, 100))
end)

-- 2. TEST JUMP
MakeBtn("TEST JUMP", function()
    -- Path: game.Players.LocalPlayer.PlayerGui.TouchGui.TouchControlFrame.JumpButton
    local JumpBtn = PlayerGui:FindFirstChild("TouchGui") 
        and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") 
        and PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")
    
    TapPath(JumpBtn, "Jump")
end)

-- 3. TEST HAKI (KEN / OBSERVATION)
MakeBtn("TEST HAKI (KEN)", function()
    -- Path: ...MobileContextButtons.ContextButtonFrame.BoundActionKen.Button
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        
    local Ken = Context and Context:FindFirstChild("BoundActionKen")
    local Button = Ken and Ken:FindFirstChild("Button")
    
    TapPath(Button, "Haki (Ken)")
end)

-- 4. TEST RACE SKILL
MakeBtn("TEST RACE", function()
    -- Path: ...MobileContextButtons.ContextButtonFrame.BoundActionRaceAbility.Button
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        
    local Race = Context and Context:FindFirstChild("BoundActionRaceAbility")
    local Button = Race and Race:FindFirstChild("Button")
    
    TapPath(Button, "Race Skill")
end)

-- 5. TEST SORU (FLASH STEP)
MakeBtn("TEST SORU", function()
    -- Path: ...MobileContextButtons.ContextButtonFrame.BoundActionSoru.Button
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        
    local Soru = Context and Context:FindFirstChild("BoundActionSoru")
    local Button = Soru and Soru:FindFirstChild("Button")
    
    TapPath(Button, "Soru")
end)

-- 6. TEST BUSO (HAKI ARMAMENT)
-- Kamu tidak kasih path Buso, tapi biasanya strukturnya sama, saya tambahkan untuk jaga2
MakeBtn("TEST BUSO (ARM)", function()
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    
    -- Biasanya namanya BoundActionBuso atau BoundActionAura
    local Buso = Context and (Context:FindFirstChild("BoundActionBuso") or Context:FindFirstChild("BoundActionAura"))
    local Button = Buso and Buso:FindFirstChild("Button")
    
    TapPath(Button, "Buso Haki")
end)

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
