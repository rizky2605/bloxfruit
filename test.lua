--[[
    VELOX INSTANT REMOTE
    Logika:
    1. Cari Tool berdasarkan Tipe (Melee/Fruit/Sword/Gun).
    2. Langsung Fire RemoteEvent:FireServer(true).
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

if CoreGui:FindFirstChild("VeloxInstant") then
    CoreGui.VeloxInstant:Destroy()
end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxInstant"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.Position = UDim2.new(0.5, -150, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 0, 0) -- Merah (Mode Tempur)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "VELOX: REMOTE FIRE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- WADAH TOMBOL
local SlotC = Instance.new("Frame"); SlotC.Size=UDim2.new(0.9,0,0.35,0); SlotC.Position=UDim2.new(0.05,0,0.2,0); SlotC.BackgroundTransparency=1; SlotC.Parent=MainFrame
local SkillC = Instance.new("Frame"); SkillC.Size=UDim2.new(0.9,0,0.35,0); SkillC.Position=UDim2.new(0.05,0,0.6,0); SkillC.BackgroundTransparency=1; SkillC.Parent=MainFrame
local G1 = Instance.new("UIGridLayout"); G1.CellSize=UDim2.new(0.22,0,1,0); G1.Parent=SlotC
local G2 = Instance.new("UIGridLayout"); G2.CellSize=UDim2.new(0.18,0,1,0); G2.Parent=SkillC

-- ==============================================================================
-- [LOGIKA INTI - REMOTE FIRE]
-- ==============================================================================

local function FireRemoteWeapon(targetType)
    -- Kita cari tool di Character (Tubuh) DAN Backpack (Slot)
    -- Kita gabungkan pencarian agar script PASTI menemukan senjatanya dimanapun dia berada
    local foundTool = nil
    
    -- Cek Character
    for _, t in pairs(LP.Character:GetChildren()) do
        if t:IsA("Tool") and t.ToolTip == targetType then foundName = t; foundTool = t; break end
    end
    
    -- Cek Backpack (Jika tidak ketemu di Character)
    if not foundTool then
        for _, t in pairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.ToolTip == targetType then foundTool = t; break end
        end
    end

    -- EKSEKUSI REMOTE
    if foundTool then
        -- Agar RemoteEvent BISA ditembak, tool harus aktif di Humanoid
        LP.Character.Humanoid:EquipTool(foundTool) 
        
        -- Cari RemoteEvent di dalam tool tersebut
        local RE = foundTool:FindFirstChild("RemoteEvent")
        if RE then
            local args = { [1] = true }
            RE:FireServer(unpack(args))
            return true
        end
    end
    return false
end

-- ==============================================================================
-- [LOGIKA SKILL - UI FIRE]
-- ==============================================================================

local function FireSkill(key)
    local Main = PlayerGui:FindFirstChild("Main")
    local Skills = Main and Main:FindFirstChild("Skills")
    if Skills then
        for _, w in pairs(Skills:GetChildren()) do
            if w:IsA("Frame") and w.Visible then
                local b = w:FindFirstChild(key) and w[key]:FindFirstChild("Mobile")
                if b then
                    for _, c in pairs(getconnections(b.Activated)) do c:Fire() end
                    for _, c in pairs(getconnections(b.MouseButton1Click)) do c:Fire() end
                    return
                end
            end
        end
    end
end

-- ==============================================================================
-- [UI BUILDER]
-- ==============================================================================

local function MakeBtn(text, color, parent, cb)
    local b = Instance.new("TextButton")
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,50)
    b.TextColor3 = color
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        cb()
        b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(20,20,20)
        task.delay(0.1, function() b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = color end)
    end)
end

-- TOMBOL SLOT 1-4 (Kuning)
MakeBtn("1", Color3.fromRGB(255, 200, 0), SlotC, function() FireRemoteWeapon("Melee") end)
MakeBtn("2", Color3.fromRGB(255, 200, 0), SlotC, function() FireRemoteWeapon("Blox Fruit") end)
MakeBtn("3", Color3.fromRGB(255, 200, 0), SlotC, function() FireRemoteWeapon("Sword") end)
MakeBtn("4", Color3.fromRGB(255, 200, 0), SlotC, function() FireRemoteWeapon("Gun") end)

-- TOMBOL SKILL Z-F (Biru)
local k = {"Z","X","C","V","F"}
for _, key in ipairs(k) do
    MakeBtn(key, Color3.fromRGB(0, 200, 255), SkillC, function() FireSkill(key) end)
end

-- TUTUP
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 0)
Close.BackgroundTransparency = 1; Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
