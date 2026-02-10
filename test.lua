--[[
    VELOX PRO SWITCHER (CLEAN LOGIC)
    Fitur:
    - Logic: Old Weapon (False) -> New Weapon (Equip) -> New Weapon (True).
    - Mencegah skill bug/macet.
    - Zero Delay execution.
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 1. BERSIHKAN UI LAMA
if CoreGui:FindFirstChild("VeloxProSwitch") then
    CoreGui.VeloxProSwitch:Destroy()
end

-- 2. GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxProSwitch"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 160)
MainFrame.Position = UDim2.new(0.5, -150, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 100) -- Hijau Pro

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "VELOX: PRO SWITCHER"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- WADAH TOMBOL
local SlotC = Instance.new("Frame"); SlotC.Size=UDim2.new(0.9,0,0.35,0); SlotC.Position=UDim2.new(0.05,0,0.2,0); SlotC.BackgroundTransparency=1; SlotC.Parent=MainFrame
local SkillC = Instance.new("Frame"); SkillC.Size=UDim2.new(0.9,0,0.35,0); SkillC.Position=UDim2.new(0.05,0,0.6,0); SkillC.BackgroundTransparency=1; SkillC.Parent=MainFrame
local G1 = Instance.new("UIGridLayout"); G1.CellSize=UDim2.new(0.22,0,1,0); G1.Parent=SlotC
local G2 = Instance.new("UIGridLayout"); G2.CellSize=UDim2.new(0.18,0,1,0); G2.Parent=SkillC

-- ==============================================================================
-- [LOGIKA INTI: FALSE -> TRUE]
-- ==============================================================================

local function SwitchTo(targetType)
    local Char = LP.Character
    local Backpack = LP.Backpack
    local Humanoid = Char:FindFirstChild("Humanoid")
    
    -- 1. MATIKAN SENJATA LAMA (FALSE)
    -- Cek semua tool yang ada di Character saat ini
    for _, tool in pairs(Char:GetChildren()) do
        if tool:IsA("Tool") then
            -- Jika ini senjata yang sama dengan target, kita tidak perlu switch (biar gak glitch)
            if tool.ToolTip == targetType then
                -- Pastikan dia True saja (Re-activate)
                local re = tool:FindFirstChild("RemoteEvent")
                if re then re:FireServer(true) end
                return -- Selesai, karena sudah pegang
            end
            
            -- Jika ini senjata BEDA, matikan dulu remote-nya
            local re = tool:FindFirstChild("RemoteEvent")
            if re then
                re:FireServer(false) -- MATIKAN SIGNAL LAMA
            end
            
            -- Pindahkan ke backpack (Unequip manual script biar bersih)
            tool.Parent = Backpack
        end
    end

    -- 2. AKTIFKAN SENJATA BARU (TRUE)
    -- Cari senjata target di Backpack
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == targetType then
            
            -- Equip Fisik
            Humanoid:EquipTool(tool)
            
            -- NYALAKAN SIGNAL BARU
            local re = tool:FindFirstChild("RemoteEvent")
            if re then
                re:FireServer(true) -- HIDUPKAN SIGNAL BARU
            end
            return
        end
    end
end

-- FUNGSI SKILL (INSTANT UI FIRE)
local function InstantSkill(key)
    local Main = PlayerGui:FindFirstChild("Main")
    local Skills = Main and Main:FindFirstChild("Skills")
    if Skills then
        for _, w in pairs(Skills:GetChildren()) do
            if w:IsA("Frame") and w.Visible then
                local b = w:FindFirstChild(key) and w[key]:FindFirstChild("Mobile")
                if b then
                    local cons = getconnections(b.Activated)
                    if #cons == 0 then cons = getconnections(b.MouseButton1Click) end
                    for _, c in pairs(cons) do c:Fire() end
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
    b.BackgroundColor3 = Color3.fromRGB(30,30,35)
    b.TextColor3 = color
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    
    b.MouseButton1Down:Connect(function() -- Responsif Instant
        cb()
        -- Visual Effect
        task.spawn(function()
            b.BackgroundColor3 = color; b.TextColor3 = Color3.fromRGB(10,10,10)
            task.wait(0.05)
            b.BackgroundColor3 = Color3.fromRGB(30,30,35); b.TextColor3 = color
        end)
    end)
end

-- SLOT BUTTONS (Kuning)
MakeBtn("1", Color3.fromRGB(255, 220, 0), SlotC, function() SwitchTo("Melee") end)
MakeBtn("2", Color3.fromRGB(255, 220, 0), SlotC, function() SwitchTo("Blox Fruit") end)
MakeBtn("3", Color3.fromRGB(255, 220, 0), SlotC, function() SwitchTo("Sword") end)
MakeBtn("4", Color3.fromRGB(255, 220, 0), SlotC, function() SwitchTo("Gun") end)

-- SKILL BUTTONS (Cyan)
local keys = {"Z", "X", "C", "V", "F"}
for _, k in ipairs(keys) do
    MakeBtn(k, Color3.fromRGB(0, 255, 255), SkillC, function() InstantSkill(k) end)
end

-- CLOSE
local Close = Instance.new("TextButton")
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 0)
Close.BackgroundTransparency = 1; Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
