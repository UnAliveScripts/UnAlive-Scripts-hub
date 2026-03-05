local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local FileName = "UnAlive_Choice_Ultimate.txt"
local DiscordInvite = "https://discord.gg/v8s9RQ8M8b"

-- 1. ANTI-KICK & AUTO-LOAD LOGIC
local function ApplyBypass()
    local success, err = pcall(function()
        local old; old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if self == LP and (method == "Kick" or method == "kick") then return nil end
            return old(self, ...)
        end)
        hookfunction(LP.Kick, function(self, ...) return nil end)
    end)
end

local function ExecuteWithDiscord(url)
    ApplyBypass()
    task.delay(3, function() if setclipboard then setclipboard(DiscordInvite) end end)
    loadstring(game:HttpGet(url))()
end

if isfile and isfile(FileName) then
    local savedUrl = readfile(FileName)
    delfile(FileName)
    ExecuteWithDiscord(savedUrl)
    return 
end

-- 2. UI CONSTRUCTION (Xeno Style)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local Header = Instance.new("Frame", MainFrame)
local Container = Instance.new("Frame", MainFrame)

MainFrame.Size = UDim2.new(0, 260, 0, 185)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -92)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active, MainFrame.Draggable = true, true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "UNALIVE ELITE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- SPINNING GEAR MINIMIZE BUTTON
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -28, 0, 4)
MinBtn.Text = "⚙️"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.TextSize = 18

Container.Size = UDim2.new(1, 0, 1, -32)
Container.Position = UDim2.new(0, 0, 0, 32)
Container.BackgroundTransparency = 1

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    -- Rotation Animation
    local targetRotation = minimized and 180 or 0
    game:GetService("TweenService"):Create(MinBtn, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Rotation = targetRotation}):Play()
    
    -- Frame Resize
    MainFrame:TweenSize(minimized and UDim2.new(0, 260, 0, 32) or UDim2.new(0, 260, 0, 185), "Out", "Quad", 0.4, true)
    Container.Visible = not minimized
end)

-- 3. BUTTONS WITH EMOJI LOADING BARS
local function AddGame(name, color, targetId, scriptUrl, yPos, loadingEmoji)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0, 240, 0, 50)
    btn.Position = UDim2.new(0.5, -120, 0, yPos)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local loadBar = Instance.new("Frame", btn)
    loadBar.Size = UDim2.new(0, 0, 0, 18)
    loadBar.Position = UDim2.new(0, 0, 1, -18)
    loadBar.BackgroundTransparency = 1
    loadBar.ClipsDescendants = true
    loadBar.Visible = false
    
    local emojiLabel = Instance.new("TextLabel", loadBar)
    emojiLabel.Size = UDim2.new(2, 0, 1, 0)
    emojiLabel.Text = loadingEmoji:rep(15)
    emojiLabel.TextSize = 14
    emojiLabel.BackgroundTransparency = 1
    emojiLabel.TextColor3 = Color3.new(1, 1, 1)

    btn.MouseButton1Click:Connect(function()
        loadBar.Visible = true
        loadBar:TweenSize(UDim2.new(1, 0, 0, 18), "Out", "Linear", 1.5)
        
        task.spawn(function()
            while loadBar.Visible do
                emojiLabel.Position = UDim2.new(0, 0, 0, 0)
                emojiLabel:TweenPosition(UDim2.new(-0.5, 0, 0, 0), "Linear", "Linear", 1)
                task.wait(1)
            end
        end)

        if game.PlaceId == targetId then
            btn.Text = "LOADING..."
            ExecuteWithDiscord(scriptUrl)
            task.wait(1.5)
            ScreenGui:Destroy()
        else
            btn.Text = "TELEPORTING..."
            if writefile then writefile(FileName, scriptUrl) end
            
            task.delay(7, function()
                if game.PlaceId ~= targetId then
                    btn.Text = "FAILED! RETRY"
                    local Notif = Instance.new("TextLabel", ScreenGui)
                    Notif.Size = UDim2.new(0, 240, 0, 30)
                    Notif.Position = UDim2.new(0.5, -120, 0.5, 105)
                    Notif.Text = "⚠️ Please try joining manually instead"
                    Notif.TextColor3 = Color3.fromRGB(255, 50, 50)
                    Notif.BackgroundTransparency = 1
                    Notif.Font = Enum.Font.GothamBold
                    task.wait(4)
                    Notif:Destroy()
                end
            end)
            TeleportService:Teleport(targetId, LP)
        end
    end)
end

AddGame("🐾 ADOPT ME", Color3.fromRGB(0, 120, 215), 920587237, "https://raw.githubusercontent.com/UnAliveScripts/UnAliveHub/refs/heads/main/loader.lua", 15, "🐾")
AddGame("🌊 TSUNAMI", Color3.fromRGB(180, 0, 0), 131623223084840, "https://raw.githubusercontent.com/UnAliveScripts/UnAlive-Hub/refs/heads/main/loader.lua", 80, "🌊")
