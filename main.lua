-- do by OpacityB for advanced ragdoll fighting roblox game

-- [DISCLAIMER]
-- this script not make ur game is power up or bad for other player
-- just visual script that counts ur hits every 5 seconds
-- please not cheat for bad targets
-- tutorial: you can change id of sound
-- forlasttime its a setting where you can change time from last hit default 5

local cfg = {
	SoundId = "rbxassetid://9062373867",
	forlasttime = 5,
	debugmode = false
}

local lastcounter = nil

local doone = 0

local maxdo = 0

local twsrvc = game:GetService("TweenService")

if game.Player.LocalPlayer.PlayerGui:FindFirstChild("CountHits") then
	game.Player.LocalPlayer.PlayerGui:FindFirstChild("CountHits"):Remove()
end

local scrgui = Instance.new("ScreenGui")
scrgui.ResetOnSpawn = false
scrgui.IgnoreGuiInset = true
scrgui.Name == "CountHits"
scrgui.Parent = game.Players.LocalPlayer.PlayerGui

local normalsize = UDim2.new(0.092, 0, 0.046, 0)

function dosound()
	local sound = Instance.new("Sound")
	sound.SoundId = cfg.SoundId
	sound.Parent = scrgui
	sound.PlaybackSpeed = 1+math.clamp((doone/20), 0, 0.5)
	sound.Volume = 3
	sound:Play()
	sound.Ended:Connect(function()
		sound:Remove()
	end)
end

function dobutton()
	local button = Instance.new("TextButton")
	button.Position = UDim2.new(0.5, 0, 0.588, 0)
	button.Size = normalsize
	button.AnchorPoint = Vector2.new(0.5,0.5)
	button.TextColor3 = Color3.fromRGB(255,0,0)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.TextScaled = true
	button.BackgroundTransparency = 0.5
	local uicorner = Instance.new("UICorner", button)
	uicorner.CornerRadius = UDim.new(0.3, 0)
	return button
end

local button1 = dobutton()
button1.Position = UDim2.new(0.5, 0, 0.023, 0)
button1.Size = UDim2.new(0.092, 0, 0.046, 0)
button1.Name = "Undelete"
button1.Parent = scrgui
button1.Text = maxdo

function docounter()
	doone += 1
	if maxdo < doone then
		maxdo = doone
	end
	button1.Text = maxdo
	for i,v in pairs(scrgui:GetChildren()) do
		if v.Name ~= "Undelete" then
			v:Remove()
		end
	end
	if lastcounter ~= nil then
		task.cancel(lastcounter)
	end
	local button = dobutton()
	button.Rotation = math.random(-20, 20)
	button.Text = doone
	button.TextTransparency = 1
	button.Size = button.Size + UDim2.new(0.1,0,0.1,0)
	button.Parent = scrgui
	dosound()
	twsrvc:Create(button, TweenInfo.new(0.3), {Size = normalsize, TextTransparency = 0, Rotation = 0}):Play()
	lastcounter = task.delay(cfg.forlasttime, function()
		button:Remove()
		doone = 0
		lastcounter = nil
	end)
end
if not cfg.debugmode then
	game.ReplicatedStorage.Remotes.LastCombat.OnClientEvent:Connect(function()
		docounter()
	end)
end

spawn(function()
	while wait(1) do
		if scrgui.Parent == nil then
			script:Remove()
		end
	end
end)

if cfg.debugmode then
	while wait(0.5) do
		docounter()
	end
end
