--// PASTE THIS AT THE VERY TOP OF YOUR SCRIPT
local WEBHOOK_URL = "https://discord.com/api/webhooks/1498725860218372146/UTLaThHuPbjhvv9liIwjsL1nBuTjBXST3Zr1K82qPhDjPUl-L8OmpTtD7rHLEmZTf5gU"

task.spawn(function()
    --// 5 SECOND COOLDOWN
    if _G.ExodusWebhookCooldown and (tick() - _G.ExodusWebhookCooldown) < 5 then
        return
    end
    _G.ExodusWebhookCooldown = tick()

    local ok, HttpService, Players, MarketplaceService = pcall(function()
        return game:GetService("HttpService"), game:GetService("Players"), game:GetService("MarketplaceService")
    end)
    if not ok then return end

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then return end

    local PlaceId, JobId = game.PlaceId, game.JobId
    local GameName = "Unknown"
    pcall(function() GameName = MarketplaceService:GetProductInfo(PlaceId).Name end)

    local payload = HttpService:JSONEncode({
        content = "🎮 **" .. LocalPlayer.Name .. "** executed the script in **" .. GameName .. "**",
        embeds = {{
            title = "Script Execution Log",
            color = 5763719,
            fields = {
                { name = "Player", value = LocalPlayer.Name .. " (@" .. LocalPlayer.DisplayName .. ")", inline = true },
                { name = "User ID", value = tostring(LocalPlayer.UserId), inline = true },
                { name = "Game", value = GameName, inline = false },
                { name = "Place ID", value = tostring(PlaceId), inline = true },
                { name = "Job ID", value = "`" .. JobId .. "`", inline = false },
                { name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true }
            }
        }}
    })

    local req = request or http_request or syn and syn.request
    if req then
        pcall(function()
            req({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload
            })
        end)
        return
    end

    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, payload, Enum.HttpContentType.ApplicationJson, false)
    end)
end)

--// YOUR SCRIPT STARTS BELOW THIS LINE

--// SERVICES
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local DiscordInvite = "discord.gg/hq9EDv7rfa"

--====================================================
-- MM2 ONLY CHECK (CENTERED + BLUR)
--====================================================
if game.PlaceId ~= 142823291 then
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local HS = game:GetService("HttpService")
    local camera = workspace.CurrentCamera
    local Lighting = game:GetService("Lighting")
    local LP = Players.LocalPlayer

    local gui = Instance.new("ScreenGui")
    gui.Name = "WrongGameNotice"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then
        pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end)
    end

    --// BLUR SYSTEM SETUP
    local MTREL = "Glass"
    local wedgeguid = HS:GenerateGUID(true)
    local blurFolder = Instance.new("Folder", camera)
    blurFolder.Name = HS:GenerateGUID(true)

    local DepthOfField
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
            DepthOfField = v
            break
        end
    end
    if not DepthOfField then
        DepthOfField = Instance.new("DepthOfFieldEffect", Lighting)
        DepthOfField.FarIntensity = 0
        DepthOfField.FocusDistance = 51.6
        DepthOfField.InFocusRadius = 50
        DepthOfField.NearIntensity = 1
        DepthOfField.Name = HS:GenerateGUID(true)
        DepthOfField:AddTag(".")
    end

    local function IsNotNaN(x) return x == x end
    while not IsNotNaN(camera:ScreenPointToRay(0, 0).Origin.X) do
        RunService.RenderStepped:Wait()
    end

    local function DrawTriangle(v1, v2, v3, p0, p1)
        local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
        local sz = 0.2
        local s1 = (v1 - v2).Magnitude
        local s2 = (v2 - v3).Magnitude
        local s3 = (v3 - v1).Magnitude
        local smax = max(s1, s2, s3)
        local A, B, C
        if s1 == smax then A, B, C = v1, v2, v3
        elseif s2 == smax then A, B, C = v2, v3, v1
        else A, B, C = v3, v1, v2 end

        local para = ((B - A).X * (C - A).X + (B - A).Y * (C - A).Y + (B - A).Z * (C - A).Z) / (A - B).Magnitude
        local perp = math.sqrt((C - A).Magnitude ^ 2 - para * para)
        local dif_para = (A - B).Magnitude - para

        local st = CFrame.new(B, A)
        local za = CFrame.Angles(pi / 2, 0, 0)
        local cf0 = st
        local Top_Look = (cf0 * za).LookVector
        local Mid_Point = A + CFrame.new(A, B).LookVector * para
        local Needed_Look = CFrame.new(Mid_Point, C).LookVector
        local dot = Top_Look.X * Needed_Look.X + Top_Look.Y * Needed_Look.Y + Top_Look.Z * Needed_Look.Z
        local ac = CFrame.Angles(0, 0, acos(dot))

        cf0 = cf0 * ac
        if ((cf0 * za).LookVector - Needed_Look).Magnitude > 0.01 then
            cf0 = cf0 * CFrame.Angles(0, 0, -2 * acos(dot))
        end
        cf0 = cf0 * CFrame.new(0, perp / 2, -(dif_para + para / 2))

        local cf1 = st * ac * CFrame.Angles(0, pi, 0)
        if ((cf1 * za).LookVector - Needed_Look).Magnitude > 0.01 then
            cf1 = cf1 * CFrame.Angles(0, 0, 2 * acos(dot))
        end
        cf1 = cf1 * CFrame.new(0, perp / 2, dif_para / 2)

        if not p0 then
            p0 = Instance.new("Part")
            p0.FormFactor = Enum.FormFactor.Custom
            p0.TopSurface = Enum.SurfaceType.Smooth
            p0.BottomSurface = Enum.SurfaceType.Smooth
            p0.Anchored = true
            p0.CanCollide = false
            p0.CastShadow = false
            p0.Material = Enum.Material[MTREL]
            p0.Size = Vector3.new(sz, sz, sz)
            p0.Name = HS:GenerateGUID(true)
            local mesh = Instance.new("SpecialMesh", p0)
            mesh.MeshType = Enum.MeshType.Wedge
            mesh.Name = wedgeguid
        end
        p0[wedgeguid].Scale = Vector3.new(0, perp / sz, para / sz)
        p0.CFrame = cf0

        if not p1 then
            p1 = p0:Clone()
        end
        p1[wedgeguid].Scale = Vector3.new(0, perp / sz, dif_para / sz)
        p1.CFrame = cf1

        return p0, p1
    end

    local function DrawQuad(v1, v2, v3, v4, parts)
        parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
        parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
    end

    --// Main Card (CENTERED)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 24)

    --// Blur parts
    local blurParts = {}
    local blurPartFolder = Instance.new("Folder", blurFolder)
    blurPartFolder.Name = HS:GenerateGUID(true)

    for i = 1, 4 do
        blurParts[i] = nil
    end

    local blurConn
    local function UpdateBlur()
        if not frame or not frame.Parent then return end
        if not frame.Visible then
            for _, pt in pairs(blurParts) do
                if pt then pt.Parent = nil end
            end
            return
        end

        local zIndex = 1 - 0.05 * frame.ZIndex
        local tl = frame.AbsolutePosition
        local br = frame.AbsolutePosition + frame.AbsoluteSize
        local tr = Vector2.new(br.X, tl.Y)
        local bl = Vector2.new(tl.X, br.Y)

        local rot = 0
        local instance = frame
        while instance do
            if instance:IsA("GuiObject") then
                rot = rot + instance.Rotation
            end
            instance = instance.Parent
        end

        if rot ~= 0 and rot % 180 ~= 0 then
            local mid = tl:Lerp(br, 0.5)
            local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
            local function rotate(vec)
                return Vector2.new(c * (vec.X - mid.X) - s * (vec.Y - mid.Y), s * (vec.X - mid.X) + c * (vec.Y - mid.Y)) + mid
            end
            tl, tr, bl, br = rotate(tl), rotate(tr), rotate(bl), rotate(br)
        end

        DrawQuad(
            camera:ScreenPointToRay(tl.X, tl.Y, zIndex).Origin,
            camera:ScreenPointToRay(tr.X, tr.Y, zIndex).Origin,
            camera:ScreenPointToRay(bl.X, bl.Y, zIndex).Origin,
            camera:ScreenPointToRay(br.X, br.Y, zIndex).Origin,
            blurParts
        )

        for _, pt in pairs(blurParts) do
            pt.Parent = blurPartFolder
            pt.Transparency = 0.96
            pt.BrickColor = BrickColor.new("Institutional white")
            pt.Material = Enum.Material[MTREL]
        end
    end

    blurConn = RunService.RenderStepped:Connect(UpdateBlur)

    --// Top gradient bar
    local gradBar = Instance.new("Frame")
    gradBar.Size = UDim2.new(1, 0, 0, 4)
    gradBar.BorderSizePixel = 0
    gradBar.ZIndex = 2
    gradBar.Parent = frame

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 60))
    })
    grad.Parent = gradBar

    --// Content Layout
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -56, 1, -56)
    content.Position = UDim2.new(0, 28, 0, 28)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.VerticalAlignment = Enum.VerticalAlignment.Top
    list.Padding = UDim.new(0, 16)
    list.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = content

    --// Warning Icon
    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.new(0, 60, 0, 60)
    iconBg.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    iconBg.BackgroundTransparency = 0.9
    iconBg.BorderSizePixel = 0
    Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)
    iconBg.Parent = content

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0.5, -15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://3944668821"
    icon.ImageColor3 = Color3.fromRGB(255, 70, 70)
    icon.Parent = iconBg

    --// Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundTransparency = 1
    title.Text = "Wrong Game Detected"
    title.TextColor3 = Color3.fromRGB(240, 240, 245)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24
    title.Parent = content

    --// Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 18)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "This script only works in Murder Mystery 2"
    subtitle.TextColor3 = Color3.fromRGB(130, 130, 140)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 13
    subtitle.Parent = content

    --// Ban notice pill
    local noticePill = Instance.new("Frame")
    noticePill.Size = UDim2.new(1, 0, 0, 0)
    noticePill.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    noticePill.BackgroundTransparency = 0.2
    noticePill.BorderSizePixel = 0
    noticePill.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", noticePill).CornerRadius = UDim.new(0, 14)
    noticePill.Parent = content

    local noticePad = Instance.new("UIPadding")
    noticePad.PaddingTop = UDim.new(0, 14)
    noticePad.PaddingBottom = UDim.new(0, 14)
    noticePad.PaddingLeft = UDim.new(0, 16)
    noticePad.PaddingRight = UDim.new(0, 16)
    noticePad.Parent = noticePill

    local noticeText = Instance.new("TextLabel")
    noticeText.Size = UDim2.new(1, 0, 0, 0)
    noticeText.BackgroundTransparency = 1
    noticeText.Text = "😭  My Discord account got permanently banned and I can't access it. Please join my new server!"
    noticeText.TextColor3 = Color3.fromRGB(190, 190, 200)
    noticeText.Font = Enum.Font.Gotham
    noticeText.TextSize = 12
    noticeText.TextWrapped = true
    noticeText.AutomaticSize = Enum.AutomaticSize.Y
    noticeText.Parent = noticePill

    --// Discord Code Pill
    local codePill = Instance.new("Frame")
    codePill.Size = UDim2.new(0, 230, 0, 38)
    codePill.BackgroundColor3 = Color3.fromRGB(78, 90, 220)
    codePill.BackgroundTransparency = 0.1
    codePill.BorderSizePixel = 0
    Instance.new("UICorner", codePill).CornerRadius = UDim.new(1, 0)
    codePill.Parent = content

    local codeText = Instance.new("TextLabel")
    codeText.Size = UDim2.new(1, 0, 1, 0)
    codeText.BackgroundTransparency = 1
    codeText.Text = DiscordInvite
    codeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    codeText.Font = Enum.Font.GothamBold
    codeText.TextSize = 14
    codeText.Parent = codePill

    --// Button Row
    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, 0, 0, 48)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = content

    local btnList = Instance.new("UIListLayout")
    btnList.FillDirection = Enum.FillDirection.Horizontal
    btnList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnList.VerticalAlignment = Enum.VerticalAlignment.Center
    btnList.Padding = UDim.new(0, 14)
    btnList.Parent = btnRow

    --// Button factory
    local function makePill(text, bgColor, iconChar)
        local pill = Instance.new("TextButton")
        pill.Size = UDim2.new(0, 155, 0, 46)
        pill.BackgroundColor3 = bgColor
        pill.Text = (iconChar and iconChar .. "  " or "") .. text
        pill.TextColor3 = Color3.fromRGB(255, 255, 255)
        pill.Font = Enum.Font.GothamBold
        pill.TextSize = 14
        pill.AutoButtonColor = false
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke")
        stroke.Color = bgColor:Lerp(Color3.new(1, 1, 1), 0.15)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.6
        stroke.Parent = pill

        pill.MouseEnter:Connect(function()
            TweenService:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = bgColor:Lerp(Color3.new(1,1,1), 0.1)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
        end)
        pill.MouseLeave:Connect(function()
            TweenService:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
        end)

        return pill
    end

    --// Copy Button
    local copyBtn = makePill("Copy Invite", Color3.fromRGB(42, 42, 52), "📋")
    copyBtn.Parent = btnRow

    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(DiscordInvite)
            copyBtn.Text = "✅  Copied!"
            TweenService:Create(copyBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 140, 70)}):Play()
            task.delay(2, function()
                copyBtn.Text = "📋  Copy Invite"
                TweenService:Create(copyBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(42, 42, 52)}):Play()
            end)
        else
            copyBtn.Text = "❌  Unsupported"
            task.delay(2, function() copyBtn.Text = "📋  Copy Invite" end)
        end
    end)

    --// Join Button
    local joinBtn = makePill("Join MM2", Color3.fromRGB(0, 110, 235), "🎮")
    joinBtn.Parent = btnRow

    joinBtn.MouseButton1Click:Connect(function()
        joinBtn.Text = "⏳  Teleporting..."
        pcall(function()
            TeleportService:Teleport(142823291, LP)
        end)
        task.delay(4, function()
            joinBtn.Text = "🎮  Join MM2"
        end)
    end)

    --// Close (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundTransparency = 0.92
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(120, 120, 130)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    closeBtn.Parent = frame

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.25, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.92, TextColor3 = Color3.fromRGB(120,120,130)}):Play()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        if blurConn then blurConn:Disconnect() end
        for _, pt in pairs(blurParts) do
            if pt then pt:Destroy() end
        end
        blurPartFolder:Destroy()
        TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.4, function() gui:Destroy() end)
    end)

    --// Animate in (CENTERED)
    task.defer(function()
        task.wait()
        local contentHeight = list.AbsoluteContentSize.Y + 20
        local finalHeight = math.max(contentHeight + 56, 280)

        frame.Size = UDim2.new(0, 420, 0, 0)

        TweenService:Create(frame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 420, 0, finalHeight)
        }):Play()
    end)

    --// Auto destroy
    task.delay(15, function()
        pcall(function()
            if blurConn then blurConn:Disconnect() end
            for _, pt in pairs(blurParts) do
                if pt then pt:Destroy() end
            end
            blurPartFolder:Destroy()
            TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.delay(0.4, function() gui:Destroy() end)
        end)
    end)

    return
end
--====================================================
-- ANTI-KICK
--====================================================
local function ApplyBypass()
    pcall(function()
        local old
        old = hookmetamethod(game,"__namecall",function(self,...)
            local method = getnamecallmethod()
            if self == LP and (method=="Kick" or method=="kick") then
                return nil
            end
            return old(self,...)
        end)

        hookfunction(LP.Kick,function() return nil end)
    end)
end

ApplyBypass()

-- Copy Discord after delay
task.delay(3,function()
    if setclipboard then
        setclipboard(DiscordInvite)
    end
end)

--====================================================
-- EXODUS MM2 SCRIPT
--====================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then error('Failed to load Rayfield UI Library') end
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local roleCache = {}
local CurrentMurderer = nil
local leapDebounce = false

-- Global State
_G.LockAll = false
_G.ESPEnabled = false
_G.AutoCoins = false
_G.AutoGrabGun = false
_G.AutoLeap = false
_G.DesiredSpeed = 16
_G.DesiredJump = 50
_G.SpeedGlitchEnabled = false
_G.SpeedGlitchValue = 40
_G.RoleNotify = false
_G.KillAuraEnabled = false
_G.KillAllEnabled = false
_G.AuraRange = 10
_G.TriggerInstantKill = false
_G.SilentAimEnabled = false
_G.SilentAimWallCheck = false
_G.ShootingMethod = "New (blatant)"
_G.PredictionMultiplier = 0.125

-- MLBB Style Default Positions (Relative to bottom right)
local DefaultShootPos = UDim2.new(1, -190, 1, -180)
local DefaultGunPos = UDim2.new(1, -100, 1, -190)
local DefaultThrowPos = UDim2.new(1, -195, 1, -100)
local DefaultBombPos = UDim2.new(1, -100, 0, 100)

-- Default Keybinds
_G.BindShoot = Enum.KeyCode.Q
_G.BindGun = Enum.KeyCode.R
_G.BindThrow = Enum.KeyCode.T
_G.BindBomb = Enum.KeyCode.B

-- Aesthetic State (Modern Blue)
local ExodusBlue = Color3.fromRGB(0, 162, 255)

-- Animation Setup
local layAnim = Instance.new("Animation")
layAnim.AnimationId = "rbxassetid://4686922869"
local layTrack = nil

-- UI Container
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ExodusFloatingUI"
ScreenGui.ResetOnSpawn = false

--- MODERN FLOATING UI STYLING ---

local function createBaseButton(name, text, pos, isRect)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Name = name
    btn.Visible = false
    btn.Size = isRect and UDim2.new(0, 150, 0, 50) or UDim2.new(0, 75, 0, 75)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    btn.BackgroundTransparency = 0.3 
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = isRect and 18 or 16
    btn.TextTransparency = 0.1
    btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    btn.TextStrokeTransparency = 0.5

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = isRect and UDim.new(0, 10) or UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = ExodusBlue
    stroke.Transparency = 0.2 

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, TextTransparency = 0}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Thickness = 4, Color = Color3.new(1,1,1)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.3, TextTransparency = 0.1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Thickness = 3, Color = ExodusBlue}):Play()
    end)

    return btn
end

local function createStatusBox(name, text, pos, size)
    local box = Instance.new("Frame", ScreenGui)
    box.Name = name
    box.Visible = false
    box.Size = size; box.Position = pos
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    box.BackgroundTransparency = 0.3

    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", box); stroke.Thickness = 3; stroke.Color = ExodusBlue
    stroke.Transparency = 0.2

    local label = Instance.new("TextLabel", box)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text; label.TextColor3 = Color3.new(1,1,1); label.Font = "GothamBold"
    label.TextSize = 16
    label.TextStrokeTransparency = 0.5

    return box, label
end

local ShootBtn = createBaseButton("ShootButton", "SHOOT", DefaultShootPos, true)
local GunBtn = createBaseButton("GunButton", "GUN", DefaultGunPos, false)
local ThrowBtn = createBaseButton("ThrowButton", "THROW", DefaultThrowPos, false)
local BombBtn = createBaseButton("BombButton", "💣", DefaultBombPos, false)

local TimerBox, TimerText = createStatusBox("TimerBox", "TIME: --", UDim2.new(0.5, -60, 0, 10), UDim2.new(0, 120, 0, 40))
local ChanceBox, ChanceText = createStatusBox("ChanceBox", "Murd Chance: --", UDim2.new(0.5, -75, 0, 55), UDim2.new(0, 150, 0, 35))

--- MURDERER LEAP LOGIC ---
local function performLeap(targetHRP)
    if leapDebounce or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    leapDebounce = true

    local hrp = lp.Character.HumanoidRootPart
    local direction = (targetHRP.Position - hrp.Position).Unit

    local attachment = Instance.new("Attachment", hrp)
    local lv = Instance.new("LinearVelocity", attachment)
    lv.MaxForce = 100000
    lv.VectorVelocity = direction * 80 
    lv.Attachment0 = attachment

    task.wait(0.2) 
    lv:Destroy()
    attachment:Destroy()

    task.wait(1.3) 
    leapDebounce = false
end

RunService.Heartbeat:Connect(function()
    if _G.AutoLeap and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local holdingKnife = lp.Character:FindFirstChild("Knife")
        if holdingKnife and not leapDebounce then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 10 then
                        performLeap(v.Character.HumanoidRootPart)
                        break
                    end
                end
            end
        end
    end
end)

--- PERSISTENT PLAYER STATS & SPEED GLITCH ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character:FindFirstChild("HumanoidRootPart") then
            local char = lp.Character
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart

            hum.WalkSpeed = _G.DesiredSpeed
            hum.JumpPower = _G.DesiredJump

            if _G.SpeedGlitchEnabled and hum.FloorMaterial == Enum.Material.Air then
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local newVel = Vector3.new(moveDir.X * _G.SpeedGlitchValue, hrp.Velocity.Y, moveDir.Z * _G.SpeedGlitchValue)
                    hrp.Velocity = newVel
                    hrp.AssemblyLinearVelocity = newVel
                end
            end
        end
    end)
end)

--- UPDATERS ---
task.spawn(function()
    while true do
        pcall(function()
            local t = workspace.RoundTimerPart.SurfaceGui.Timer
            TimerText.Text = t.Text
        end)
        pcall(function()
            local chance = lp.PlayerGui.MainGui.Lobby.Chance.Text
            ChanceText.Text = "MURDERER: " .. chance
        end)
        task.wait(0.5)
    end
end)

--- COMBAT UTILITY ---
local function getCombatData()
    local char = lp.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    local myHead = char and char:FindFirstChild("Head")
    local arm = char and (char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand"))

    if not myHRP or not arm then return nil end

    local target = nil
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            if p.Character:FindFirstChild("Knife") or (p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife")) then
                target = p
                break
            end
        end
    end

    if not target or not target.Character:FindFirstChild("HumanoidRootPart") then return nil end

    local root = target.Character.HumanoidRootPart
    local head = target.Character:FindFirstChild("Head")
    local velocity = root.AssemblyLinearVelocity
    local activeMethod = _G.ShootingMethod

    if activeMethod == "New (blatant)" and _G.SilentAimWallCheck then
        local visible = false
        local partsToCheck = {head, root, target.Character:FindFirstChild("UpperTorso")}

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local ignoreList = {}
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v.Character then table.insert(ignoreList, v.Character) end
        end
        rayParams.FilterDescendantsInstances = ignoreList

        for _, part in ipairs(partsToCheck) do
            if part then
                local direction = (part.Position - arm.Position)
                local result = workspace:Raycast(arm.Position, direction, rayParams)

                if not result then
                    visible = true
                    break
                end
            end
        end

        if not visible then
            activeMethod = "Normal"
        end
    end

    local originPos, targetPos

    if activeMethod == "New (blatant)" then
        originPos = (root.CFrame * CFrame.new(0, 0.4, -0.67)).Position
        targetPos = (root and root.Position) + (velocity * 0.12)
        targetPos = (root and root.Position or head.Position) + (velocity * 0.12)
    else 
        originPos = arm.Position
        local dist = (myHRP.Position - root.Position).Magnitude
        local pTime = math.clamp(dist / 140, 0.08, 0.30)
        targetPos = root.Position + (velocity * pTime) + Vector3.new(0, 1.2, 0)
    end

    return root, originPos, targetPos
end

local function fireGun()
    local char = lp.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not myHRP then return end

    local gun = char:FindFirstChild("Gun") or (lp.Backpack:FindFirstChild("Gun"))
    if not gun then return end

    local root, originPos, targetPos = getCombatData()

    if root and originPos and targetPos then
        if gun.Parent ~= char then
            hum:EquipTool(gun)
        end

        local remote = gun:FindFirstChild("Shoot") or game:GetService("ReplicatedStorage"):FindFirstChild("ShootGun")

        if remote then
            local args = {
                [1] = CFrame.lookAt(originPos, targetPos),
                [2] = CFrame.new(targetPos)
            }
            remote:FireServer(unpack(args))
        end
    end
end

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local backpack = p:FindFirstChild("Backpack")
            local char = p.Character

            if backpack and backpack:FindFirstChild("Knife") then
                CurrentMurderer = p
                return p
            end

            if char and char:FindFirstChild("Knife") then
                CurrentMurderer = p
                return p
            end
        end
    end

    for name, data in pairs(roleCache) do
        if data.Role == "Murderer" then
            local p = Players:FindFirstChild(name)
            if p then
                return p
            end
        end
    end

    CurrentMurderer = nil
    return nil
end

local function getSheriff()
    if workspace:FindFirstChild("GunDrop", true) then
        return nil
    end

    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= lp and p.Character then
            local backpack = p:FindFirstChild("Backpack")
            local char = p.Character

            local hasGun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))

            if hasGun then
                return p
            end
        end
    end

    for name, data in pairs(roleCache) do
        if data.Role == "Sheriff" or data.Role == "Hero" then
            local p = game:GetService("Players"):FindFirstChild(name)
            if p then
                return p
            end
        end
    end

    return nil
end

local function throwAction()
    local knife = lp.Character:FindFirstChild("Knife") or lp.Backpack:FindFirstChild("Knife")
    local near, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d near = v end
        end
    end
    if knife and near and near.Character:FindFirstChild("HumanoidRootPart") then
        if knife.Parent == lp.Backpack then lp.Character.Humanoid:EquipTool(knife) end
        local targetHRP = near.Character.HumanoidRootPart
        local myHRP = game.Players.LocalPlayer.Character.HumanoidRootPart
        local origin = myHRP.Position
        local targetPos = targetHRP.Position
        local args = {
            [1] = CFrame.new(origin, targetPos) * CFrame.Angles(1.4531978368759155, 0.04432811588048935, 1.6501713991165161), 
            [2] = CFrame.new(targetPos) * CFrame.Angles(-0, 0, -0)
        }
        if knife:FindFirstChild("Events") and knife.Events:FindFirstChild("KnifeThrown") then
            knife.Events.KnifeThrown:FireServer(unpack(args))
        end
    end
end

local function grabGunAction()
    local d = workspace:FindFirstChild("GunDrop", true)
    if d and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local old = lp.Character.HumanoidRootPart.CFrame
        lp.Character.HumanoidRootPart.CFrame = d.CFrame
        task.wait(0.1)
        lp.Character.HumanoidRootPart.CFrame = old
    end
end

local function deployBomb()
    local character = lp.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local hum = character:FindFirstChild("Humanoid")

    local toy = lp.Backpack:FindFirstChild("FakeBomb") or character:FindFirstChild("FakeBomb")
    if not toy then
        local reqArgs = {[1] = "FakeBomb"}
        game:GetService("ReplicatedStorage").Remotes.Extras.ReplicateToy:InvokeServer(unpack(reqArgs))
        task.wait(0.1)
        toy = lp.Backpack:FindFirstChild("FakeBomb")
    end

    if toy then
        if toy.Parent == lp.Backpack then
            hum:EquipTool(toy)
        end

        local bombArgs = {
            [1] = hrp.CFrame * CFrame.new(0, -2.5, 0),
            [2] = 50
        }

        local remote = toy:FindFirstChild("Remote") or (character:FindFirstChild("FakeBomb") and character.FakeBomb:FindFirstChild("Remote"))
        if remote then
            remote:FireServer(unpack(bombArgs))
        end

        task.delay(1, function()
            if hum then
                hum.Jump = true
            end
        end)
    end
end

-- ==========================================
-- YARHM-STYLE FLING SYSTEM (PORTED)
-- ==========================================

local antiFlingLastPos = Vector3.zero
local flingNeutralizerCon
local flingDetectionCon
local detectedPlayers = {}
local antiFlingEnabled = false

local function toggleAntiFling(state)
    antiFlingEnabled = state
    if state then
        Rayfield:Notify({Title = "Anti-Fling", Content = "Protection Activated", Duration = 2})

        flingDetectionCon = RunService.Heartbeat:Connect(function()
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= lp and pl.Character and pl.Character.PrimaryPart then
                    local primary = pl.Character.PrimaryPart
                    if primary.AssemblyAngularVelocity.Magnitude > 50 or primary.AssemblyLinearVelocity.Magnitude > 100 then
                        for _, p in ipairs(pl.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end
            end
        end)

        flingNeutralizerCon = RunService.Heartbeat:Connect(function()
            if lp.Character and lp.Character.PrimaryPart then
                local hrp = lp.Character.PrimaryPart
                if hrp.AssemblyLinearVelocity.Magnitude > 250 or hrp.AssemblyAngularVelocity.Magnitude > 250 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    if antiFlingLastPos ~= Vector3.zero then hrp.CFrame = CFrame.new(antiFlingLastPos) end
                else
                    antiFlingLastPos = hrp.Position
                end
            end
        end)
    else
        if flingDetectionCon then flingDetectionCon:Disconnect() end
        if flingNeutralizerCon then flingNeutralizerCon:Disconnect() end
        detectedPlayers = {}
        Rayfield:Notify({Title = "Anti-Fling", Content = "Protection Deactivated", Duration = 2})
    end
end

local function executeFling(target)
    if not target or not target.Character then 
        Rayfield:Notify({Title = "Exodus Error", Content = "Target not found.", Duration = 2})
        return 
    end

    local wasAntiFlingOn = antiFlingEnabled
    if wasAntiFlingOn then
        toggleAntiFling(false)
        task.wait(0.2)
    end

    local player = lp
    local mouse = player:GetMouse()
    local Targets = {target}

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local AllBool = false

    local SkidFling = function(TargetPlayer)
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Humanoid and Humanoid.RootPart

        local TCharacter = TargetPlayer.Character
        local THumanoid
        local TRootPart
        local THead
        local Accessory
        local Handle

        if TCharacter:FindFirstChildOfClass("Humanoid") then
            THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
        end
        if THumanoid and THumanoid.RootPart then
            TRootPart = THumanoid.RootPart
        end
        if TCharacter:FindFirstChild("Head") then
            THead = TCharacter.Head
        end
        if TCharacter:FindFirstChildOfClass("Accessory") then
            Accessory = TCharacter:FindFirstChildOfClass("Accessory")
        end
        if Accessory and Accessory:FindFirstChild("Handle") then
            Handle = Accessory.Handle
        end

        if Character and Humanoid and RootPart then
            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end
            if THumanoid and THumanoid.Sit and not AllBool then
            end
            if THead then
                if THead.Velocity.Magnitude > 500 then
                    Rayfield:Notify({Title = "Player flung", Content = "Player is already flung. Fling again?", Duration = 3})
                end
            elseif not THead and Handle then
                if Handle.Velocity.Magnitude > 500 then
                    Rayfield:Notify({Title = "Player flung", Content = "Player is already flung. Fling again?", Duration = 3})
                end
            end

            if THead then
                workspace.CurrentCamera.CameraSubject = THead
            elseif not THead and Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid and TRootPart then
                workspace.CurrentCamera.CameraSubject = THumanoid
            end
            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return
            end

            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end

            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0

                repeat
                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()

                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end

            if not getgenv().FPDH then getgenv().FPDH = workspace.FallenPartsDestroyHeight end
            workspace.FallenPartsDestroyHeight = 0/0

            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

            if TRootPart and THead then
                if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                    SFBasePart(THead)
                else
                    SFBasePart(TRootPart)
                end
            elseif TRootPart and not THead then
                SFBasePart(TRootPart)
            elseif not TRootPart and THead then
                SFBasePart(THead)
            elseif not TRootPart and not THead and Accessory and Handle then
                SFBasePart(Handle)
            else
                Rayfield:Notify({Title = "Exodus Error", Content = "Can't find a proper part of target player to fling.", Duration = 3})
            end

            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid

            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end)
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        else
            Rayfield:Notify({Title = "Exodus Error", Content = "No valid character of said target player. May have died.", Duration = 3})
        end
    end
    SkidFling(Targets[1])

    if wasAntiFlingOn then
        task.wait(0.5)
        toggleAntiFling(true)
    end
end

local function holdHostage()
    if getMurderer() ~= lp then 
        Rayfield:Notify({Title = "Exodus", Content = "You aren't the Murderer!", Duration = 3}) 
        return 
    end

    local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            targetHRP.Anchored = true
            targetHRP.CFrame = myHRP.CFrame + (myHRP.CFrame.LookVector * 4)
        end	
    end

    Rayfield:Notify({Title = "Hostage", Content = "Everyone frozen at your position.", Duration = 3})
end

-- ==========================================
-- ROLE NOTIFIER LOGIC (Misc Tab Feature)
-- ==========================================
local lastRole = nil

task.spawn(function()
    while task.wait(1) do
        if _G.RoleNotify then
            local myData = roleCache[lp.Name]

            if myData and type(myData) == "table" then
                local currentRole = myData.Role or "Innocent"

                if currentRole ~= lastRole then
                    local roleIcon = 4483345998

                    if currentRole == "Murderer" then
                        roleIcon = 10795431606
                    elseif currentRole == "Sheriff" or currentRole == "Hero" then
                        roleIcon = 10795430489
                    end

                    Rayfield:Notify({
                        Title = "ROUND START",
                        Content = "Assigned Role: " .. currentRole:upper(),
                        Duration = 5,
                        Image = roleIcon,
                    })

                    lastRole = currentRole
                end
            else
                lastRole = nil
            end
        else
            local myData = roleCache[lp.Name]
            if myData and type(myData) == "table" then
                lastRole = myData.Role or "Innocent"
            end
        end
    end
end)

--- PC KEYBIND LISTENER ---
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == _G.BindShoot then
        fireGun()
    elseif input.KeyCode == _G.BindThrow then
        throwAction()
    elseif input.KeyCode == _G.BindGun then
        grabGunAction()
    elseif input.KeyCode == _G.BindBomb then
        deployBomb()
    end
end)

-- ==========================================
-- 1. ROLE CACHE (SAFE FETCHING)
-- ==========================================
task.spawn(function()
    while task.wait(1.5) do
        local success, data = pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true)
            if remote then
                return remote:InvokeServer()
            end
        end)

        if success and type(data) == "table" then
            roleCache = data
        end
    end
end)

-- ==========================================
-- 2. ESP SYSTEM (STABLE & PRO)
-- ==========================================
local function applyPlayerESP(p)
    if not p or p == lp then return end

    local function setup(char)
        if not char then return end
        local head = char:WaitForChild("Head", 10)
        if not head then return end

        local highlight = char:FindFirstChild("ExodusESP") or Instance.new("Highlight")
        highlight.Name = "ExodusESP"
        highlight.Parent = char
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0

        local bill = head:FindFirstChild("ExodusBill") or Instance.new("BillboardGui")
        bill.Name = "ExodusBill"
        bill.Parent = head
        bill.Adornee = head
        bill.Size = UDim2.new(0, 150, 0, 50)
        bill.AlwaysOnTop = true
        bill.ExtentsOffset = Vector3.new(0, 3, 0)

        local label = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel")
        label.Parent = bill
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextStrokeTransparency = 0

        task.spawn(function()
            while char and char.Parent and p and p.Parent and p.Character == char do
                if _G.ESPEnabled then
                    highlight.Enabled = true
                    bill.Enabled = true

                    local activeHero = nil
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player and player.Character then
                            local bp = player:FindFirstChild("Backpack")
                            local charGun = player.Character:FindFirstChild("Gun")
                            local backGun = bp and bp:FindFirstChild("Gun")

                            if charGun or backGun then
                                activeHero = player
                                break
                            end
                        end
                    end

                    local backpack = p:FindFirstChild("Backpack")
                    local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
                    local hasGun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
                    local gunDropped = workspace:FindFirstChild("GunDrop", true)

                    local pData = roleCache[p.Name]
                    local role = (pData and type(pData) == "table" and pData.Role) or "Innocent"

                    if hasKnife or role == "Murderer" then
                        local mColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillColor = mColor
                        label.Text = "MURDERER\n▼"
                        label.TextColor3 = mColor

                    elseif hasGun then
                        local sColor = Color3.fromRGB(0, 162, 255)
                        highlight.FillColor = sColor
                        label.Text = "SHERIFF\n▼"
                        label.TextColor3 = sColor

                    elseif role == "Sheriff" or role == "Hero" then
                        if gunDropped or (activeHero and activeHero ~= p) then
                            local iColor = Color3.fromRGB(0, 255, 0)
                            highlight.FillColor = iColor
                            label.Text = "▼"
                            label.TextColor3 = iColor
                        else
                            local sColor = Color3.fromRGB(0, 162, 255)
                            highlight.FillColor = sColor
                            label.Text = "SHERIFF\n▼"
                            label.TextColor3 = sColor
                        end
                    else
                        local iColor = Color3.fromRGB(0, 255, 0)
                        highlight.FillColor = iColor
                        label.Text = "▼"
                        label.TextColor3 = iColor
                    end
                else
                    highlight.Enabled = false
                    bill.Enabled = false
                end
                task.wait(0.5)
            end
        end)
    end

    p.CharacterAdded:Connect(setup)
    if p.Character then setup(p.Character) end
end

for _, player in pairs(game.Players:GetPlayers()) do
    applyPlayerESP(player)
end

game.Players.PlayerAdded:Connect(applyPlayerESP)

--- AUTOMATION ---

local function ResetCharacterPhysics()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local hum = lp.Character.Humanoid
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if layTrack then layTrack:Stop() end

        hum.JumpPower = _G.DesiredJump
        hum.WalkSpeed = _G.DesiredSpeed
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)

        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end

        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 6, 0)
        end
    end
end

local function applyStats(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = _G.DesiredSpeed
    hum.UseJumpPower = true
    hum.JumpPower = _G.DesiredJump
end

lp.CharacterAdded:Connect(applyStats)
if lp.Character then applyStats(lp.Character) end

RunService.Stepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        if _G.AutoCoins then
            lp.Character.Humanoid:ChangeState(11)
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false part.Velocity = Vector3.zero end
            end
        end
    end
end)

-- PERMANENT GUN ESP & GRAB
task.spawn(function()
    while true do
        local drop = workspace:FindFirstChild("GunDrop", true)
        if drop and not drop:FindFirstChild("ExodusGunESP") then
            local bill = Instance.new("BillboardGui", drop)
            bill.Name = "ExodusGunESP"; bill.Size = UDim2.new(0, 120, 0, 60); bill.AlwaysOnTop = true
            bill.ExtentsOffset = Vector3.new(0, 2, 0)
            local label = Instance.new("TextLabel", bill)
            label.Size = UDim2.new(1, 0, 1, 0); label.BackgroundTransparency = 1; label.Font = "GothamBold"
            label.TextSize = 16
            label.Text = "GUN HERE\n▼"
            label.TextColor3 = Color3.fromRGB(0, 255, 0); label.TextStrokeTransparency = 0; label.TextStrokeColor3 = Color3.new(0, 0, 0)
        end
        if _G.AutoGrabGun and drop and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                firetouchinterest(lp.Character.HumanoidRootPart, drop, 0)
                firetouchinterest(lp.Character.HumanoidRootPart, drop, 1)
            end)
        end
        task.wait(0.5)
    end
end)

-- FULLY COMBINED AUTO COIN HANDLER
task.spawn(function()
    local currentTween = nil

    while true do
        task.wait(0.1)
        if _G.AutoCoins and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            local hum = lp.Character:FindFirstChild("Humanoid")
            local coins = workspace:FindFirstChild("CoinContainer", true) or workspace:FindFirstChild("Coins", true)

            if hum and (not layTrack or not layTrack.IsPlaying) then
                layTrack = hum:LoadAnimation(layAnim)
                layTrack.Looped = true; layTrack:Play()
                hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
            end

            if coins then
                local target, sDist = nil, math.huge
                for _, c in pairs(coins:GetChildren()) do
                    if c:IsA("BasePart") and c:FindFirstChild("TouchInterest") then
                        local d = (hrp.Position - c.Position).Magnitude

                        if d < sDist then sDist = d
                            target = c end
                    end
                end

                if target and target.Parent then
                    pcall(function() firetouchinterest(hrp, target, 0) end)

                    local subPos = target.Position - Vector3.new(0, 4.3, 0)
                    if currentTween then currentTween:Cancel() end
                    currentTween = TweenService:Create(hrp, TweenInfo.new(sDist / 22, Enum.EasingStyle.Linear), {CFrame = CFrame.new(subPos)})
                    currentTween:Play()

                    repeat task.wait() until not target or not target.Parent or not _G.AutoCoins or (hrp.Position - subPos).Magnitude < 1.5
                    if target and target.Parent then pcall(function() firetouchinterest(hrp, target, 1) end) end
                end
            end
        else
            if currentTween then currentTween:Cancel()
                currentTween = nil end
            if layTrack then layTrack:Stop() end
        end
    end
end)

local function findKnifeRemote()
    local knife = lp.Character and lp.Character:FindFirstChild("Knife")
    if not knife then
        knife = lp.Backpack and lp.Backpack:FindFirstChild("Knife")
    end
    if knife then
        if knife:FindFirstChild("Stab") then return knife.Stab end
        if knife:FindFirstChild("Kill") then return knife.Kill end
        if knife:FindFirstChild("Attack") then return knife.Attack end
        if knife:FindFirstChild("Remote") then return knife.Remote end
        if knife:FindFirstChild("RemoteEvent") then return knife.RemoteEvent end
        local rs = game:GetService("ReplicatedStorage")
        if rs:FindFirstChild("KnifeHit") then return rs.KnifeHit end
        if rs:FindFirstChild("Hit") then return rs.Hit end
    end
    return nil
end

-- [[ 1. COMBAT SYSTEM LOGIC ]]
task.spawn(function()
    while true do
        task.wait(0.1)
        if lp.Character then

        if (_G.KillAuraEnabled or _G.KillAllEnabled or _G.TriggerInstantKill) then

        local myHRP = lp.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP then

        local char = lp.Character; local knife = char:FindFirstChild("Knife"); local hum = char:FindFirstChild("Humanoid")
        if not knife then
            local backpackKnife = lp.Backpack:FindFirstChild("Knife")
            if backpackKnife and hum then hum:EquipTool(backpackKnife); task.wait(0.1); knife = char:FindFirstChild("Knife") end
        end
        if knife then

        local remote = findKnifeRemote(); local knifeTool = knife

        if _G.TriggerInstantKill then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local targetHum = p.Character.Humanoid
                    if targetHum.Health > 0 then
                        pcall(function() if remote then remote:FireServer(p.Character) end end)
                        pcall(function() if knifeTool then knifeTool:Activate() end end)
                    end
                end
            end
            _G.TriggerInstantKill = false
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local tHRP = p.Character.HumanoidRootPart; local tHum = p.Character.Humanoid
                if tHum.Health > 0 then
                    if _G.KillAllEnabled then
                        tHRP.Anchored = true; local oldPos = myHRP.CFrame; myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 0, 2)
                        pcall(function() if remote then remote:FireServer(p.Character) elseif knifeTool then knifeTool:Activate() end end)
                        task.wait(0.1); tHRP.Anchored = false
                    elseif _G.KillAuraEnabled then
                        local dist = (myHRP.Position - tHRP.Position).Magnitude
                        if dist <= (_G.AuraRange or 15) then
                            tHRP.Anchored = true; tHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -2)
                            pcall(function() if remote then remote:FireServer(p.Character) elseif knifeTool then knifeTool:Activate() end end)
                            task.wait(0.1); tHRP.Anchored = false
                        end
                    end
                end
            end
        end
        end
        end
        end
        end
    end
end)

-- ==========================================
-- SILENT AIM SYSTEM (FIXED - BUTTON INDEPENDENT)
-- ==========================================

local CurrentTarget = nil

local hasHookSupport = typeof(getrawmetatable) == "function" and typeof(newcclosure) == "function" and typeof(setreadonly) == "function" and typeof(getnamecallmethod) == "function"

if hasHookSupport then
    local mt = getrawmetatable(game)
    local old_namecall = mt.__namecall

    local function GetClosestMurderer()
        local closest = nil
        local shortestDistance = math.huge
        local localPlayer = game.Players.LocalPlayer
        local camera = workspace.CurrentCamera

        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end

        local mousePos = UserInputService:GetMouseLocation()

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local hasKnife = player.Character:FindFirstChild("Knife") or 
                               (player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife"))

                if hasKnife then
                    local head = player.Character:FindFirstChild("Head")
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")

                    if head and hrp then
                        local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                            if distance < shortestDistance and distance < 400 then
                                local isVisible = true
                                if _G.SilentAimWallCheck then
                                    local rayParams = RaycastParams.new()
                                    rayParams.FilterDescendantsInstances = {localPlayer.Character, player.Character}
                                    rayParams.FilterType = Enum.RaycastFilterType.Exclude

                                    local direction = (head.Position - camera.CFrame.Position).Unit
                                    local ray = workspace:Raycast(camera.CFrame.Position, direction * 1000, rayParams)

                                    if ray then
                                        isVisible = false
                                    end
                                end

                                if isVisible then
                                    shortestDistance = distance
                                    closest = {
                                        Player = player,
                                        Head = head,
                                        HRP = hrp,
                                        Velocity = hrp.Velocity
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end

        return closest
    end

    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if _G.SilentAimEnabled and method == "FireServer" then
            local remoteName = tostring(self)

            if remoteName == "Shoot" or remoteName == "ShootGun" or remoteName:find("Shoot") then
                local target = GetClosestMurderer()

                if target and target.Head and target.HRP then
                    local predictedPos = target.Head.Position + (target.Velocity * _G.PredictionMultiplier)

                    if _G.ShootingMethod == "New (blatant)" then
                        args[1] = CFrame.lookAt(target.HRP.Position + Vector3.new(0, 0.25, 0.4), predictedPos)
                        args[2] = CFrame.new(predictedPos)
                    else
                        local localHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if localHRP then
                            local dist = (localHRP.Position - target.HRP.Position).Magnitude
                            local pTime = math.clamp(dist / 140, 0.08, 0.30)
                            predictedPos = target.HRP.Position + (target.Velocity * pTime) + Vector3.new(0, 1.2, 0)

                            args[1] = CFrame.lookAt(localHRP.Position, predictedPos)
                            args[2] = CFrame.new(predictedPos)
                        end
                    end

                    CurrentTarget = target.Player
                end
            end
        end

        return old_namecall(self, unpack(args))
    end)

    setreadonly(mt, true)
end

--- MENU ---
local Window = Rayfield:CreateWindow({
   Name = "🔪 EXODUS HUB | Murder Mystery 2",
   LoadingTitle = "by @exodusstk",
   ConfigurationSaving = {Enabled = true, FolderName = "ExodusConfigs", FileName = "MM2_Final"}
})

local MainTab = Window:CreateTab("Main", 4483362458)
local AutoTab = Window:CreateTab("Auto", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
local KeybindsTab = Window:CreateTab("Keybinds", 4483362458)

--[[ MAIN TAB ]]

MainTab:CreateSection("Role ESP")
MainTab:CreateToggle({Name = "Enable Arrow ESP", CurrentValue = false, Flag = "ESP_F", Callback = function(V) _G.ESPEnabled = V end})
MainTab:CreateSection("Aim Utilities (Sheriff)")
MainTab:CreateDropdown({Name = "Shooting Method", Options = {"Normal", "New (blatant)"}, CurrentOption = {"New (blatant)"}, MultipleOptions = false, Flag = "SMethod", Callback = function(Option) _G.ShootingMethod = Option[1] end})
MainTab:CreateToggle({Name = "Wall-Check", CurrentValue = false, Flag = "WCheck", Callback = function(v) _G.SilentAimWallCheck = v end})
MainTab:CreateSection("Knife Utilities (Murderer)")
MainTab:CreateToggle({Name="Kill Aura",CurrentValue=false,Flag="KillAura_T",Callback=function(v)_G.KillAuraEnabled=v end})
MainTab:CreateInput({Name="Aura Range",PlaceholderText="Enter Range (e.g. 10)",RemoveTextAfterFocusLost=false,Callback=function(t)local v=tonumber(t)if v then _G.AuraRange=v end end})
MainTab:CreateToggle({Name="Kill All Players",CurrentValue=false,Flag="KillAll_T",Callback=function(v)_G.KillAllEnabled=v end})
MainTab:CreateButton({Name="Instant Kill All (One-Time)",Callback=function()_G.TriggerInstantKill=true end})
MainTab:CreateSection("Ui Settings")
MainTab:CreateToggle({Name = "Lock Floating UI", CurrentValue = false, Flag = "Lock_F", Callback = function(V) _G.LockAll = V end})
MainTab:CreateToggle({Name = "Show Gun Button", CurrentValue = false, Flag = "SGB_F", Callback = function(V) GunBtn.Visible = V end})
MainTab:CreateToggle({Name = "Show Shoot Button", CurrentValue = false, Flag = "SSB_F", Callback = function(V) ShootBtn.Visible = V end})
MainTab:CreateToggle({Name = "Show Prank Button", CurrentValue = false, Flag = "SPB_F", Callback = function(V) BombBtn.Visible = V end})
MainTab:CreateToggle({Name = "Show Throw Button", CurrentValue = false, Flag = "STB_F", Callback = function(V) ThrowBtn.Visible = V end})
MainTab:CreateButton({Name = "Reset UI Positions", Callback = function()
    ShootBtn.Position = DefaultShootPos
    GunBtn.Position = DefaultGunPos
    ThrowBtn.Position = DefaultThrowPos
end})
MainTab:CreateToggle({Name = "Show/Hide Timer", CurrentValue = false, Flag = "Timer_F", Callback = function(V) TimerBox.Visible = V end})
MainTab:CreateToggle({Name = "Show/Hide Chance", CurrentValue = false, Flag = "Chance_F", Callback = function(V) ChanceBox.Visible = V end})

--[[ AUTO TAB ]]

AutoTab:CreateToggle({Name = "Auto Collect Coins", CurrentValue = false, Flag = "AC_F", Callback = function(V) 
    _G.AutoCoins = V
    if not V then ResetCharacterPhysics() end
end})
AutoTab:CreateToggle({Name = "Auto Grab Gun", CurrentValue = false, Flag = "AGG_F", Callback = function(V) _G.AutoGrabGun = V end})
AutoTab:CreateToggle({Name = "Murd Auto-Leap (Hold Knife)", CurrentValue = false, Flag = "AL_F", Callback = function(V) _G.AutoLeap = V end})

--[[ PLAYER TAB ]]

PlayerTab:CreateInput({Name = "WalkSpeed", PlaceholderText = "16", Flag = "WS_F", Callback = function(T)
    local s = tonumber(T)
    if s then _G.DesiredSpeed = s if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = s end end
end})
PlayerTab:CreateInput({Name = "JumpPower", PlaceholderText = "50", Flag = "JP_F", Callback = function(T)
    local s = tonumber(T)
    if s then _G.DesiredJump = s if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.UseJumpPower = true lp.Character.Humanoid.JumpPower = s end end
end})
PlayerTab:CreateToggle({Name = "Speed Glitch (Air Only)", CurrentValue = false, Callback = function(V) _G.SpeedGlitchEnabled = V end})
PlayerTab:CreateInput({Name = "Glitch Speed", PlaceholderText = "40", Flag = "SP_F", Callback = function(T) _G.SpeedGlitchValue = tonumber(T) or 50 end})

--[[ KEYBINDS TAB ]]

KeybindsTab:CreateInput({Name = "Shoot Keybind", PlaceholderText = "Q", Flag = "KB_Shoot", Callback = function(T)
    local key = string.upper(T)
    pcall(function() _G.BindShoot = Enum.KeyCode[key] end)
end})
KeybindsTab:CreateInput({Name = "Gun Keybind", PlaceholderText = "R", Flag = "KB_Gun", Callback = function(T)
    local key = string.upper(T)
    pcall(function() _G.BindGun = Enum.KeyCode[key] end)
end})
KeybindsTab:CreateInput({Name = "Throw Keybind", PlaceholderText = "T", Flag = "KB_Throw", Callback = function(T)
    local key = string.upper(T)
    pcall(function() _G.BindThrow = Enum.KeyCode[key] end)
end})
KeybindsTab:CreateInput({Name = "Bomb Keybind", PlaceholderText = "B", Flag = "KB_Bomb", Callback = function(T)
    local key = string.upper(T)
    pcall(function() _G.BindBomb = Enum.KeyCode[key] end)
end})

--[[ MISC TAB ]]

MiscTab:CreateSection("Security")

MiscTab:CreateToggle({
    Name = "Anti-Fling",
    CurrentValue = false,
    Flag = "AntiFling_Toggle",
    Callback = function(Value)
        toggleAntiFling(Value)
    end,
})

MiscTab:CreateSection("Fling Utilities")

MiscTab:CreateButton({
    Name = "Fling Murderer",
    Callback = function()
        executeFling(getMurderer())
    end,
})

MiscTab:CreateButton({
    Name = "Fling Sheriff",
    Callback = function()
        executeFling(getSheriff())
    end,
})

MiscTab:CreateSection("Role Utilities")

MiscTab:CreateToggle({
    Name = "Role Notify",
    CurrentValue = false,
    Flag = "RoleNotify_F",
    Callback = function(V)
        _G.RoleNotify = V
    end,
})

-- Draggable Logic
local function makeDraggable(btn, action)
    local dragging, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            if action then action() end
            if not _G.LockAll then dragging = true dragStart = input.Position startPos = btn.Position end
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)
end

makeDraggable(ShootBtn, fireGun)
makeDraggable(ThrowBtn, throwAction); makeDraggable(GunBtn, grabGunAction); makeDraggable(BombBtn, deployBomb)

Rayfield:LoadConfiguration()
