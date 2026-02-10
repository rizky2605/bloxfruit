--[[
    VELOX MOUSE CLICKER (ANTI-STUCK)
    Fitur:
    - Menggunakan VirtualUser (Simulasi Mouse PC).
    - Tidak menyentuh layar HP (Touch System Aman).
    - Mencegah bug "M1 Macet".
]]

local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

if CoreGui:FindFirstChild("VeloxM1Fix") then
    CoreGui.VeloxM1Fix:Destroy()
end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VeloxM1Fix"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 50)
MainFrame.Position = UDim2.new(0.5, -75, 0.15, 0) -- Di atas tengah
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke"); Stroke.Color=Color3.fromRGB(255, 50, 50); Stroke.Parent=MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "AUTO M1: OFF 🔴"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

-- ==============================================================================
-- [LOGIKA MOUSE VIRTUAL]
-- ==============================================================================

local IsClicking = false

task.spawn(function()
    while true do
        if IsClicking then
            -- METODE ANTI-STUCK:
            -- Kita tidak pakai TouchEvent. Kita pakai ClickButton1 (Klik Kiri Mouse).
            -- Ini bypass layar sentuh sepenuhnya.
            
            pcall(function()
                VirtualUser:CaptureController() -- Ambil alih kontrol
                VirtualUser:ClickButton1(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
        
        -- Kecepatan Spam (0.1 - 0.2 detik sudah sangat cepat untuk Blox Fruits)
        -- Jangan 0, nanti game crash/freeze lagi.
        task.wait(0.15) 
    end
end)

-- Event Tombol
ToggleBtn.MouseButton1Click:Connect(function()
    IsClicking = not IsClicking
    
    if IsClicking then
        ToggleBtn.Text = "AUTO M1: ON 🟢"
        Stroke.Color = Color3.fromRGB(0, 255, 0)
    else
        ToggleBtn.Text = "AUTO M1: OFF 🔴"
        Stroke.Color = Color3.fromRGB(255, 50, 50)
    end
end)
