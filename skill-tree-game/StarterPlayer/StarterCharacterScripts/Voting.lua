--Client Voting Script
--Ashton
--9.14.23 -- 10.1.23

--Objects--
local userIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local votingEvent = events:WaitForChild("Voting")
local votingFolder = repStorage:WaitForChild("Voting")
local resultMap = votingFolder:WaitForChild("Map")
local resultMode = votingFolder:WaitForChild("Mode")
local votingTime = votingFolder:WaitForChild("Time")
local votingValue = votingFolder:WaitForChild("IsVoting")
local chosenMaps = votingFolder:WaitForChild("Maps")
local chosenModes = votingFolder:WaitForChild("Modes")
local gameState = player:WaitForChild("GameState")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local guiVotingFolder = gui:WaitForChild("Voting")
local votingMenu = guiVotingFolder:WaitForChild("VotingMenu")
local modesFolder = votingMenu:WaitForChild("Modes")
local mapNamesFolder = votingMenu:WaitForChild("MapNames")
local mapImagesFolder = votingMenu:WaitForChild("MapImages")
local mapTimer = votingMenu:WaitForChild("Timer")
local votingMove = votingMenu:WaitForChild("Move")
local votingClose = votingMenu:WaitForChild("Close")
local clientMods = repStorage:WaitForChild("ClientModules")
local votingOpen = guiVotingFolder:WaitForChild("Open")
local resultsMenu = guiVotingFolder:WaitForChild("ResultsMenu")
local modeBackground = resultsMenu:WaitForChild("ModeBackground")
local resultsMapImage = resultsMenu:WaitForChild("MapImage")
local resultsClose = resultsMenu:WaitForChild("Close")
local resultsModeName = resultsMenu:WaitForChild("ModeName")
local resultsMapName = resultsMenu:WaitForChild("MapName")

--Modules--
local mouseController = require(clientMods:WaitForChild("Mouse"))
local guiManip = require(clientMods:WaitForChild("GuiManip"))

--Variables--
local currentVotes = {
	Map = 0,
	Mode = 0,
}
local currentBorders = {
	Map = nil,
	Mode = nil,
}

--Constants--
local DEFAULT_MAP_IMAGE = "rbxassetid://11117563862"
local DEFAULT_MAP_NAME  = "Name"
local HIGHLIGHT_BORDER = Color3.fromRGB(40, 240, 200)
local DEFAULT_BORDERS = {
	Map = mapImagesFolder:WaitForChild("1").BorderColor3,
	Mode = modesFolder:WaitForChild("1").BorderColor3,
}

--Display Results--
local function displayResults()
	resultsMenu.Visible = true
	local mapConfig = resultMap.Value.Config
	
	resultsMapName.Text = mapConfig:WaitForChild("Name").Value
	resultsMapImage.Image = mapConfig.Image.Value
	
	--resultsMode
end

--Change Border color--
local function changeBorder(obj, color)
	obj.BorderColor3 = color
end

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
	currentVotes["Map"] = 0
	currentVotes["Mode"] = 0
	
	if currentBorders["Map"] then
		changeBorder(currentBorders["Map"], DEFAULT_BORDERS["Map"])
		currentBorders["Map"] = nil
	end
	if currentBorders["Mode"] then
		changeBorder(currentBorders["Mode"], DEFAULT_BORDERS["Mode"])
		currentBorders["Mode"] = nil
	end
	
	for _, image in pairs(mapImagesFolder:GetChildren()) do
		image.Image = DEFAULT_MAP_IMAGE
	end
	
	for _, textBox in pairs(mapNamesFolder:GetChildren()) do
		textBox.Text = DEFAULT_MAP_NAME
	end
end

--Submit votes--
local function submitVotes()
	votingEvent:FireServer(currentVotes)
end

--Open Voting--
local function openVoting()
	showMaps()
	votingMenu.Visible = true
	votingOpen.Visible = true
end

--Close Voting--
local function closeVoting()
	hideMaps()
	votingMenu.Visible = false
	votingOpen.Visible = false
end

--Vote--
local function vote(item, num, obj)
	if votingValue.Value and votingTime.Value > 0 then
		if currentBorders[item] then
			changeBorder(currentBorders[item], DEFAULT_BORDERS[item])
		end
		currentBorders[item] = obj
		changeBorder(obj, HIGHLIGHT_BORDER)
		
		currentVotes[item] = num
		submitVotes()
		mouseController.click()
	end
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

--Connect mapImage buttons--
for _, button in pairs(mapImagesFolder:GetChildren()) do
	local mapNum = tonumber(button.Name)
	
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and mapNum ~= currentVotes["Map"] then
			vote("Map", mapNum, button)
		end
	end)
end

--Connect mode Buttons--
for _, button in pairs(modesFolder:GetChildren()) do
	local modeNum = tonumber(button.Name)
	
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and modeNum ~= currentVotes["Mode"] then
			vote("Mode", modeNum, button)
		end
	end)
end
--Open Voting if Voting and in lobby--
if gameState.Value == "Lobby" and votingValue.Value then
	openVoting()
end

--Open / Close voting when game state changes--
gameState.Changed:Connect(function(value)
	if gameState.Value == "Lobby" and votingValue.Value then
		openVoting()
	else
		closeVoting()
		resultsMenu.Visible = false
	end
end)

--Update Timer--
votingTime.Changed:Connect(function(value)
	mapTimer.Text = value
end)

--Connect VotingMove--
guiManip.ConnectMove(votingMove)

--Connect VotingClose--
votingClose.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		votingMenu.Visible = false
		mouseController.click()
	end
end)

--Connect ResultsClose--
resultsClose.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resultsMenu.Visible = false
		mouseController.click()
	end
end)

--Reopen Voting Menu if closed by user--
votingOpen.Activated:Connect(function()
	votingMenu.Visible = not votingMenu.Visible
	mouseController.click()
end)

--End Voting when results are given--
resultMap.Changed:Connect(function(value)
	if value then
		displayResults()
	end
end)
