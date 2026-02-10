--[[
    VELOX INVENTORY SCANNER (FOUNDATION TEST)
    Fungsi: Mendeteksi nama senjata di Slot 1-4 secara otomatis.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxScanner") then
    CoreGui.VeloxScanner:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxScanner"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 180, 0)

-- JUDUL
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "INVENTORY SLOT SCANNER"
Title.TextColor3 = Color3.fromRGB(255, 180, 0)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- WADAH HASIL SCAN
local ResultContainer = Instance.new("Frame")
ResultContainer.Size = UDim2.new(0.9, 0, 0.6, 0)
ResultContainer.Position = UDim2.new(0.05, 0, 0.15, 0)
ResultContainer.BackgroundTransparency = 1
ResultContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ResultContainer
UIList.Padding = UDim.new(0, 5)

-- Fungsi Membuat Label Slot
local SlotsLabels = {}
for i = 1, 4 do
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 30)
    Lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    Lbl.Text = "Slot " .. i .. ": [ Kosong ]"
    Lbl.Font = Enum.Font.Code
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = ResultContainer
    Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 6)
    
    -- Padding Text
    local P = Instance.new("UIPadding")
    P.PaddingLeft = UDim.new(0, 10)
    P.Parent = Lbl
    
    SlotsLabels[i] = Lbl
end

-- TOMBOL REFRESH
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 100)
ScanBtn.Text = "SCAN INVENTORY SEKARANG"
ScanBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = MainFrame
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ==============================================================================
-- LOGIKA DETEKSI (THE BRAIN)
-- ==============================================================================

local function ScanInventory()
    -- Reset Label
    for i = 1, 4 do
        SlotsLabels[i].Text = "Slot " .. i .. ": [ Kosong ]"
        SlotsLabels[i].TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    local FoundItems = {}
    
    -- Fungsi Helper untuk Cek Tool
    local function CheckTool(tool)
        if not tool:IsA("Tool") then return end
        
        -- Cek Tipe Senjata berdasarkan ToolTip
        local Type = tool.ToolTip -- Melee, Blox Fruit, Sword, Gun
        local Name = tool.Name
        
        if Type == "Melee" then
            SlotsLabels[1].Text = "Slot 1 (Melee): " .. Name
            SlotsLabels[1].TextColor3 = Color3.fromRGB(255, 150, 0) -- Orange
            FoundItems[1] = Name
            
        elseif Type == "Blox Fruit" then
            SlotsLabels[2].Text = "Slot 2 (Fruit): " .. Name
            SlotsLabels[2].TextColor3 = Color3.fromRGB(200, 50, 255) -- Ungu
            FoundItems[2] = Name
            
        elseif Type == "Sword" then
            SlotsLabels[3].Text = "Slot 3 (Sword): " .. Name
            SlotsLabels[3].TextColor3 = Color3.fromRGB(0, 150, 255) -- Biru
            FoundItems[3] = Name
            
        elseif Type == "Gun" then
            SlotsLabels[4].Text = "Slot 4 (Gun): " .. Name
            SlotsLabels[4].TextColor3 = Color3.fromRGB(255, 255, 100) -- Kuning
            FoundItems[4] = Name
        end
    end
    
    -- 1. Scan apa yang sedang DIPEGANG (Character)
    for _, t in pairs(LP.Character:GetChildren()) do
        CheckTool(t)
    end
    
    -- 2. Scan apa yang ada di TAS (Backpack)
    for _, t in pairs(LP.Backpack:GetChildren()) do
        CheckTool(t)
    end
    
    return FoundItems
end

-- Hubungkan Tombol
ScanBtn.MouseButton1Click:Connect(ScanInventory)

-- Auto Scan saat script dijalankan
ScanInventory()--[[
    VELOX INVENTORY SCANNER (FOUNDATION TEST)
    Fungsi: Mendeteksi nama senjata di Slot 1-4 secara otomatis.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxScanner") then
    CoreGui.VeloxScanner:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxScanner"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 180, 0)

-- JUDUL
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "INVENTORY SLOT SCANNER"
Title.TextColor3 = Color3.fromRGB(255, 180, 0)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- WADAH HASIL SCAN
local ResultContainer = Instance.new("Frame")
ResultContainer.Size = UDim2.new(0.9, 0, 0.6, 0)
ResultContainer.Position = UDim2.new(0.05, 0, 0.15, 0)
ResultContainer.BackgroundTransparency = 1
ResultContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = ResultContainer
UIList.Padding = UDim.new(0, 5)

-- Fungsi Membuat Label Slot
local SlotsLabels = {}
for i = 1, 4 do
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 30)
    Lbl.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    Lbl.Text = "Slot " .. i .. ": [ Kosong ]"
    Lbl.Font = Enum.Font.Code
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = ResultContainer
    Instance.new("UICorner", Lbl).CornerRadius = UDim.new(0, 6)
    
    -- Padding Text
    local P = Instance.new("UIPadding")
    P.PaddingLeft = UDim.new(0, 10)
    P.Parent = Lbl
    
    SlotsLabels[i] = Lbl
end

-- TOMBOL REFRESH
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(45, 200, 100)
ScanBtn.Text = "SCAN INVENTORY SEKARANG"
ScanBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = MainFrame
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Close.Parent = MainFrame
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ==============================================================================
-- LOGIKA DETEKSI (THE BRAIN)
-- ==============================================================================

local function ScanInventory()
    -- Reset Label
    for i = 1, 4 do
        SlotsLabels[i].Text = "Slot " .. i .. ": [ Kosong ]"
        SlotsLabels[i].TextColor3 = Color3.fromRGB(150, 150, 150)
    end
    
    local FoundItems = {}
    
    -- Fungsi Helper untuk Cek Tool
    local function CheckTool(tool)
        if not tool:IsA("Tool") then return end
        
        -- Cek Tipe Senjata berdasarkan ToolTip
        local Type = tool.ToolTip -- Melee, Blox Fruit, Sword, Gun
        local Name = tool.Name
        
        if Type == "Melee" then
            SlotsLabels[1].Text = "Slot 1 (Melee): " .. Name
            SlotsLabels[1].TextColor3 = Color3.fromRGB(255, 150, 0) -- Orange
            FoundItems[1] = Name
            
        elseif Type == "Blox Fruit" then
            SlotsLabels[2].Text = "Slot 2 (Fruit): " .. Name
            SlotsLabels[2].TextColor3 = Color3.fromRGB(200, 50, 255) -- Ungu
            FoundItems[2] = Name
            
        elseif Type == "Sword" then
            SlotsLabels[3].Text = "Slot 3 (Sword): " .. Name
            SlotsLabels[3].TextColor3 = Color3.fromRGB(0, 150, 255) -- Biru
            FoundItems[3] = Name
            
        elseif Type == "Gun" then
            SlotsLabels[4].Text = "Slot 4 (Gun): " .. Name
            SlotsLabels[4].TextColor3 = Color3.fromRGB(255, 255, 100) -- Kuning
            FoundItems[4] = Name
        end
    end
    
    -- 1. Scan apa yang sedang DIPEGANG (Character)
    for _, t in pairs(LP.Character:GetChildren()) do
        CheckTool(t)
    end
    
    -- 2. Scan apa yang ada di TAS (Backpack)
    for _, t in pairs(LP.Backpack:GetChildren()) do
        CheckTool(t)
    end
    
    return FoundItems
end

-- Hubungkan Tombol
ScanBtn.MouseButton1Click:Connect(ScanInventory)

-- Auto Scan saat script dijalankan
ScanInventory()
