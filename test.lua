-- ==============================================================================
-- [CORE] HYBRID SYSTEM SETUP
-- ==============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- 1. FUNGSI FIRE BUTTON UI (UNTUK SKILL & JUMP - ANTI BAN)
local function FireUI(btnObj)
    if not btnObj then return end
    if not btnObj.Visible then return end -- Hanya tekan jika tombol terlihat

    -- Coba ambil koneksi klik
    local connections = getconnections(btnObj.Activated)
    if #connections == 0 then
        connections = getconnections(btnObj.MouseButton1Click)
    end

    -- Paksa jalankan fungsi tombol
    for _, conn in pairs(connections) do
        conn:Fire()
    end
end

-- 2. FUNGSI CARI TOMBOL SKILL OTOMATIS (Z, X, C...)
local function TriggerSkillUI(key)
    local MainUI = PlayerGui:FindFirstChild("Main")
    local SkillsFolder = MainUI and MainUI:FindFirstChild("Skills")
    
    if SkillsFolder then
        -- Loop folder senjata (Saber, Buddha, Fishman, dll)
        for _, weaponFrame in pairs(SkillsFolder:GetChildren()) do
            -- Kita cari folder yang sedang VISIBLE (Artinya senjata itu yg lagi dipake)
            if weaponFrame:IsA("Frame") and weaponFrame.Visible then
                local KeyBtn = weaponFrame:FindFirstChild(key) and weaponFrame[key]:FindFirstChild("Mobile")
                if KeyBtn then
                    FireUI(KeyBtn)
                    return
                end
            end
        end
    end
end

-- ==============================================================================
-- [TOMBOL VELOX]
-- ==============================================================================

-- [[ 1. AUTO M1 (ATTACK) - VIA REMOTE ]]
mkTool("SPAM M1", Theme.Red, function()
    -- Menggunakan script RegisterAttack (Sesuai request)
    -- Angka 0.4 adalah cooldown aman agar tidak terdeteksi exploit brutal
    local args = {
        [1] = 0.4000000059604645 -- Cooldown aman
    }
    
    -- Fire Remote
    local remote = ReplicatedStorage.Modules.Net:FindFirstChild("RE/RegisterAttack")
    if remote then
        remote:FireServer(unpack(args))
    end
end, SetBox)

-- [[ 2. EQUIP SENJATA - VIA REMOTE ]]
-- Fungsi Helper untuk Equip
local function AutoEquip(weaponName)
    local Char = LP.Character
    local Backpack = LP.Backpack
    
    -- Cek apakah senjata ada di Backpack
    local tool = Backpack:FindFirstChild(weaponName)
    if tool then
        Char.Humanoid:EquipTool(tool) -- Equip Fisik (Agar muncul di tangan)
    else
        tool = Char:FindFirstChild(weaponName) -- Cek kalau sudah dipegang
    end

    -- Jalankan Remote EquipEvent (Sesuai request kamu)
    -- Ini penting untuk sinkronisasi animasi/stats di server
    if tool then
        local equipRemote = tool:FindFirstChild("EquipEvent")
        if equipRemote then
            local args = { [1] = true }
            equipRemote:FireServer(unpack(args))
        end
    else
        ShowNotification("Item tidak ditemukan!", Theme.Red)
    end
end

-- Tombol Equip (Sesuaikan Nama Senjata di sini)
mkTool("EQUIP MELEE", Theme.Element, function()
    -- Ganti "Fishman Karate" dengan nama Fighting Style kamu (misal: "Superhuman")
    AutoEquip("Fishman Karate") 
end, SetBox)

mkTool("EQUIP SWORD", Theme.Element, function()
    -- Ganti "Saber" dengan nama pedang kamu
    AutoEquip("Saber") 
end, SetBox)

-- [[ 3. SKILLS - VIA UI BUTTON (ANTI ZOOM/CONFLICT) ]]
-- Ini membajak tombol layar, jadi layar HP kamu tidak akan keganggu

mkTool("SKILL Z", Theme.Blue, function() TriggerSkillUI("Z") end, SetBox)
mkTool("SKILL X", Theme.Blue, function() TriggerSkillUI("X") end, SetBox)
mkTool("SKILL C", Theme.Blue, function() TriggerSkillUI("C") end, SetBox)
mkTool("SKILL V", Theme.Blue, function() TriggerSkillUI("V") end, SetBox)
mkTool("SKILL F", Theme.Blue, function() TriggerSkillUI("F") end, SetBox)

-- [[ 4. MOVEMENT - VIA UI BUTTON ]]
mkTool("JUMP / GEPPO", Theme.Green, function()
    -- Mencari tombol Jump bawaan Roblox Mobile
    local JumpBtn = PlayerGui:FindFirstChild("TouchGui") 
        and PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") 
        and PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton")
    
    FireUI(JumpBtn)
end, SetBox)

mkTool("FLASH STEP", Theme.Accent, function()
    -- Mencari tombol Soru di kanan layar
    local SoruBtn = PlayerGui:FindFirstChild("MobileContextButtons") 
        and PlayerGui.MobileContextButtons:FindFirstChild("ContextButtonFrame")
        and PlayerGui.MobileContextButtons.ContextButtonFrame:FindFirstChild("BoundActionSoru")
        and PlayerGui.MobileContextButtons.ContextButtonFrame.BoundActionSoru:FindFirstChild("Button")
        
    FireUI(SoruBtn)
end, SetBox)
