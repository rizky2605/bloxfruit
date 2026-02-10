--[[
    VELOX MINI CONTROLLER (MOBILE OPTIMIZED)
    Fitur:
    1. Auto Detect Slot 1-4
    2. Button 1-4: Instant Equip (Remote)
    3. Button Z-F: Skill Fire (UI Logic / No Conflict)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxController") then
    CoreGui.VeloxController:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxController"
ScreenGui.Parent = CoreGui

-- FRAME UTAMA
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 160) -- Ukuran Compact
MainFrame.Position = UDim2.new(0.5, -160, 0.2, 0) -- Di atas tengah agar mudah dijangkau
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255) -- Cyan Border

-- JUDUL + DRAG HANDLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "VELOX CONTROLLER"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 12
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- WADAH TOMBOL EQUIP (1-4)
local EquipFrame = Instance.new("Frame")
EquipFrame.Size = UDim2.new(0.95, 0, 0.35, 0)
EquipFrame.Position = UDim2.new(0.025, 0, 0.2, 0)
EquipFrame.BackgroundTransparency = 1
EquipFrame.Parent = MainFrame
local GridEquip = Instance.new("UIGridLayout")
GridEquip.CellSize = UDim2.new(0.23, 0, 1, 0)
GridEquip.CellPadding = UDim2.new(0.02, 0, 0, 0)
GridEquip.Parent = EquipFrame

-- WADAH TOMBOL SKILL (Z-F)
local SkillFrame = Instance.new("Frame")
SkillFrame.Size = UDim2.new(0.95, 0, 0.35, 0)
SkillFrame.Position = UDim2.new(0.025, 0, 0.6, 0)
SkillFrame.BackgroundTransparency = 1
SkillFrame.Parent = MainFrame
local GridSkill = Instance.new("UIGridLayout")
GridSkill.CellSize = UDim2.new(0.18, 0, 1, 0) -- 5 Tombol
GridSkill.CellPadding = UDim2.new(0.02, 0, 0, 0)
GridSkill.Parent = SkillFrame

-- ==============================================================================
-- [LOGIKA SCANNER & DATA]
-- ==============================================================================

local InventoryData = {
    [1] = nil, -- Melee
    [2] = nil, -- Fruit
    [3] = nil, -- Sword
    [4] = nil, -- Gun
}

local function ScanWeapons()
    -- Reset Data
    InventoryData = {[1]=nil, [2]=nil, [3]=nil, [4]=nil}
    
    local function Check(tool)
        if not tool:IsA("Tool") then return end
        local Type = tool.ToolTip
        
        if Type == "Melee" then InventoryData[1] = tool.Name
        elseif Type == "Blox Fruit" then InventoryData[2] = tool.Name
        elseif Type == "Sword" then InventoryData[3] = tool.Name
        elseif Type == "Gun" then InventoryData[4] = tool.Name
        end
    end
    
    -- Scan Character (Sedang dipakai) & Backpack (Di tas)
    for _, t in pairs(LP.Character:GetChildren()) do Check(t) end
    for _, t in pairs(LP.Backpack:GetChildren()) do Check(t) end
end

-- ==============================================================================
-- [LOGIKA TOMBOL]
-- ==============================================================================

-- 1. FUNGSI EQUIP (REMOTE)
local function EquipSlot(slotNum)
    ScanWeapons() -- Update data dulu biar fresh
    
    local weaponName = InventoryData[slotNum]
    if weaponName then
        -- Panggil Server untuk Load Item (Sangat Cepat & Aman)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", weaponName)
        
        -- Efek Visual (Feedback)
        local btn = EquipFrame:FindFirstChild("Btn"..slotNum)
        if btn then
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            task.delay(0.2, function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end)
        end
    else
        -- Jika kosong
        local btn = EquipFrame:FindFirstChild("Btn"..slotNum)
        if btn then
            btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            task.delay(0.2, function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end)
        end
    end
end

-- 2. FUNGSI SKILL (UI FIRE - ANTI FREEZE)
local function FireSkill(key)
    local Main = PlayerGui:FindFirstChild("Main")
    local Skills = Main and Main:FindFirstChild("Skills")
    
    if Skills then
        for _, w in pairs(Skills:GetChildren()) do
            -- Cari folder senjata yang sedang VISIBLE (Aktif)
            if w:IsA("Frame") and w.Visible then
                local btn = w:FindFirstChild(key) and w[key]:FindFirstChild("Mobile")
                
                -- JIKA TOMBOL DITEMUKAN
                if btn and btn.Visible then
                    -- Fire Signal (Tanpa Sentuh Layar)
                    local cons = getconnections(btn.Activated)
                    if #cons == 0 then cons = getconnections(btn.MouseButton1Click) end
                    for _, c in pairs(cons) do c:Fire() end
                    
                    -- Efek Visual
                    local uiBtn = SkillFrame:FindFirstChild("Btn"..key)
                    if uiBtn then
                        uiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        task.delay(0.1, function() uiBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50) end)
                    end
                    return
                end
            end
        end
    end
end

-- ==============================================================================
-- [PEMBUATAN TOMBOL UI]
-- ==============================================================================

-- BUAT TOMBOL EQUIP (1-4)
for i = 1, 4 do
    local b = Instance.new("TextButton")
    b.Name = "Btn"..i
    b.Text = tostring(i)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.Parent = EquipFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        EquipSlot(i)
    end)
end

-- BUAT TOMBOL SKILL (Z, X, C, V, F)
local skillKeys = {"Z", "X", "C", "V", "F"}
for _, key in ipairs(skillKeys) do
    local b = Instance.new("TextButton")
    b.Name = "Btn"..key
    b.Text = key
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    b.TextColor3 = Color3.fromRGB(100, 200, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.Parent = SkillFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        FireSkill(key)
    end)
end

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 0)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Font = Enum.Font.GothamBlack
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Scan Awal
ScanWeapons()
