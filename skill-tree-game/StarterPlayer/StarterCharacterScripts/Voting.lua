--Client Voting Script
--Ashton
--9.14.23

--Objects--
local userIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local votingEvent = events:WaitForChild("Voting")
local votingFolder = repStorage:WaitForChild("Voting")
local votingTime = votingFolder:WaitForChild("Time")
local votingValue = votingFolder:WaitForChild("IsVoting")
local chosenMaps = votingFolder:WaitForChild("Maps")
local chosenModes = votingFolder:WaitForChild("Modes")
local gameState = player:WaitForChild("GameState")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local votingMenu = gui:WaitForChild("Voting"):WaitForChild("VotingMenu")
local modesFolder = votingMenu:WaitForChild("Modes")
local mapNamesFolder = votingMenu:WaitForChild("MapNames")
local mapImagesFolder = votingMenu:WaitForChild("MapImages")
local mapTimer = votingMenu:WaitForChild("Timer")
local votingMove = votingMenu:WaitForChild("Move")
local clientMods = repStorage:WaitForChild("ClientModules")

--Modules--
local mouseController = require(clientMods:WaitForChild("Mouse"))

--Constants--
local DEFAULT_MAP_IMAGE = "rbxassetid://11117563862"
local DEFAULT_MAP_NAME  = "Name"

--Show images and names for maps--
local function showMaps()
	for _, mapVal in pairs(chosenMaps:GetChildren()) do
		local mapConfig = mapVal.Value.Config
		local name = mapConfig:WaitForChild("Name").Value
		local imageId = mapConfig:WaitForChild("Image").Value
		
		mapNamesFolder:WaitForChild(mapVal.Name).Text = name
		mapImagesFolder:WaitForChild(mapVal.Name).Image = imageId
	end
end

--Reset images and names for maps--
local function hideMaps()
	for _, image in pairs(mapImagesFolder:GetChildren()) do
		image.Image = DEFAULT_MAP_IMAGE
	end
	
	for _, textBox in pairs(mapNamesFolder:GetChildren()) do
		textBox.Text = DEFAULT_MAP_NAME
	end
end

--Submit votes--
local function submitVotes()
	local votes = {}
	
	votingEvent:FireServer(votes)
end

--Open Voting--
local function openVoting()
	showMaps()
	votingMenu.Visible = true
end

--Close Voting--
local function closeVoting()
	hideMaps()
	votingMenu.Visible = false
end

--Open/Close Voting--
votingValue.Changed:Connect(function(value)
	if gameState.Value == "Lobby" then
		if value then
			openVoting()
		else
			closeVoting()
		end
	end
end)

--Open Voting if Voting and in lobby--
if gameState.Value == "Lobby" and votingValue.Value then
	openVoting()
end

--Update Timer--
votingTime.Changed:Connect(function(value)
	mapTimer.Text = value
end)

--Connect AdminMove--
votingMove.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local newMove
		local discon
		local mouse = player:GetMouse()
		local viewSize = workspace.CurrentCamera.ViewportSize
		local offset = votingMenu.Position - UDim2.fromScale(mouse.X/viewSize.X, mouse.Y/viewSize.Y)
		mouseController.setIcon("Move")
		newMove = mouse.Move:Connect(function()
			votingMenu.Position = UDim2.fromScale(mouse.X/viewSize.X, mouse.Y/viewSize.Y) + offset
		end)

		--Disconnect on mouse lift--
		discon = userIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				mouseController.setIcon()
				newMove:Disconnect()
				discon:Disconnect()
			end
		end)
	end
end)