--[[
    VELOX DIAGNOSTIC TOOL V2 (FIXED M1 & JUMP)
    Oleh: Gemini Assistant
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxTesterV2") then
    CoreGui.VeloxTesterV2:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxTesterV2"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 350) -- Lebih tinggi utk tombol baru
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255)

-- JUDUL
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TESTER V2: M1 & CONTEXT"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- LOG WINDOW
local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(0.9, 0, 0.4, 0)
LogScroll.Position = UDim2.new(0.05, 0, 0.12, 0)
LogScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LogScroll.Parent = MainFrame
local UIList = Instance.new("UIListLayout")
UIList.Parent = LogScroll
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function AddLog(text, type)
    local color = Color3.fromRGB(255, 255, 255)
    if type == "success" then color = Color3.fromRGB(50, 255, 100) end
    if type == "error" then color = Color3.fromRGB(255, 80, 80) end
    if type == "warn" then color = Color3.fromRGB(255, 200, 50) end

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = "> " .. text
    Label.TextColor3 = color
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LogScroll
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
    LogScroll.CanvasPosition = Vector2.new(0, 9999)
end

-- CONTAINER TOMBOL
local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(0.9, 0, 0.45, 0)
BtnContainer.Position = UDim2.new(0.05, 0, 0.53, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame
local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.48, 0, 0.22, 0) -- Lebih kecil biar muat banyak
Grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
Grid.Parent = BtnContainer

-- HELPER: FIRE BUTTON
local function FireObj(btn)
    if not btn then return false end
    if not btn.Visible then return false end
    
    local connections = getconnections(btn.Activated)
    if #connections == 0 then connections = getconnections(btn.MouseButton1Click) end
    if #connections == 0 then connections = getconnections(btn.InputBegan) end -- Coba InputBegan utk Jump
    
    if #connections > 0 then
        for _, c in pairs(connections) do c:Fire() end
        return true
    end
    return false
end

local function MakeBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = BtnContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- ==============================================================================
-- LOGIKA TESTER BARU
-- ==============================================================================

-- 1. TEST M1 (VIRTUAL CLICK) - PERBAIKAN
MakeBtn("TEST M1 (CLICK)", function()
    local s, e = pcall(function()
        -- Metode: Klik Kiri Mouse Virtual di Tengah Layar
        -- Ini otomatis menyesuaikan dengan senjata yang dipegang
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        AddLog("M1: Virtual Click Sent", "success")
    end)
    if not s then AddLog("M1 Error: "..e, "error") end
end)

-- 2. TEST JUMP (HYBRID FIX) - PERBAIKAN
MakeBtn("TEST JUMP (FIX)", function()
    local Success = false
    
    -- Cara 1: UI Fire (TouchGui)
    local JumpBtn = PlayerGui:FindFirstChild("TouchGui") 
        and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") 
        and PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")
    
    if FireObj(JumpBtn) then 
        AddLog("Jump: UI Fire Success", "success")
        Success = true
    else
        AddLog("Jump: UI Fire Failed, Trying Backup...", "warn")
    end
    
    -- Cara 2: Virtual Spacebar (Backup Wajib)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    
    AddLog("Jump: KeyCode.Space Sent", "success")
end)

-- 3. TEST HAKI (BUSO/KEN)
MakeBtn("TEST BUSO/HAKI", function()
    -- Cek Context Button
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
    
    if Context then
        -- Cek Haki (Buso biasanya BoundActionBuso atau Aura)
        -- Cek Observation (Ken)
        local Found = false
        
        -- Coba Buso
        local Buso = Context:FindFirstChild("BoundActionBuso") or Context:FindFirstChild("BoundActionAura")
        if Buso and FireObj(Buso:FindFirstChild("Button")) then 
            AddLog("Haki (Buso) Pressed", "success"); Found = true 
        end
        
        -- Coba Ken (Observation)
        local Ken = Context:FindFirstChild("BoundActionKen") or Context:FindFirstChild("BoundActionInstinct")
        if Ken and FireObj(Ken:FindFirstChild("Button")) then 
            AddLog("Haki (Ken) Pressed", "success"); Found = true 
        end
        
        if not Found then AddLog("Tombol Haki tidak muncul (Cooldown/Belum Beli?)", "warn") end
    else
        AddLog("ContextFrame Missing!", "error")
    end
end)

-- 4. TEST SORU (FLASH STEP)
MakeBtn("TEST SORU", function()
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        
    local Soru = Context and Context:FindFirstChild("BoundActionSoru")
    
    if Soru and FireObj(Soru:FindFirstChild("Button")) then
        AddLog("Soru (Flash Step) Pressed", "success")
    else
        AddLog("Tombol Soru tidak aktif/Missing", "warn")
    end
end)

-- 5. TEST DASH/DODGE
MakeBtn("TEST DASH/DODGE", function()
    -- Dash biasanya ada di MobileControl (dekat tombol skill)
    local Main = PlayerGui:FindFirstChild("Main")
    local Ctrl = Main and Main:FindFirstChild("MobileControl")
    
    if Ctrl then
        local Dash = Ctrl:FindFirstChild("Dash") or Ctrl:FindFirstChild("Dodge") or Ctrl:FindFirstChild("Agility")
        
        if FireObj(Dash) then
            AddLog("Dash UI Pressed", "success")
        else
            -- Coba backup context (kadang race V4 dash ada di context)
            AddLog("Dash UI Missing, cek Context...", "warn")
        end
    else
        AddLog("MobileControl Missing", "error")
    end
end)

-- 6. TEST RACE SKILL
MakeBtn("TEST RACE V3/V4", function()
    local Context = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        
    local Race = Context and Context:FindFirstChild("BoundActionRaceAbility")
    
    if Race and FireObj(Race:FindFirstChild("Button")) then
        AddLog("Race Skill Pressed", "success")
    else
        AddLog("Tombol Race Skill tidak ada", "warn")
    end
end)


-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
