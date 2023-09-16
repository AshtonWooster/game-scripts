--Server Voting Script
--Ashton
--9.13.23 -- 9.15.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local votingEvent = events:WaitForChild("Voting")
local maps = repStorage:WaitForChild("Maps")
local votingFolder = repStorage:WaitForChild("Voting")
local chosenMaps = votingFolder:WaitForChild("Maps")
local chosenModes = votingFolder:WaitForChild("Modes")
local votingTime = votingFolder:WaitForChild("Time")
local votingValue = votingFolder:WaitForChild("IsVoting")

--Variables--
local isVoting = false
local waiting = {}
local currentMaps = {}


--Constants--
local MIN_PLAYERS = 2
local MAX_MAPS    = 3
local VOTING_TIME = 20

--Set Up Map Object Values--
for _, objectVal in pairs(chosenMaps:GetChildren()) do
	currentMaps[tonumber(objectVal.Name)] = objectVal
end


--Stop Voting--
local function stopVoting()
	isVoting = false
	
	for _, objectVal in currentMaps do
		objectVal.Value = nil
	end
	
	votingValue.Value = false
	votingTime.Value = 0
end

--Start Voting--
local function startVoting()
	isVoting = true
	
	--Choose Maps
	local availableMaps = maps:GetChildren()
	for i=1, MAX_MAPS do
		local chosenMap = math.random(1, #availableMaps)
		currentMaps[i].Value = availableMaps[chosenMap]
		table.remove(availableMaps, chosenMap)
	end
	
	votingValue.Value = true
	votingTime.Value = VOTING_TIME
end


--Check Voting Amount--
local function checkVoting()
	if isVoting and #waiting < MIN_PLAYERS then
		stopVoting()
	elseif not isVoting and #waiting >= MIN_PLAYERS then
		startVoting()
	end
end


--Remove From list--
local function removeWait(player)
	local i = table.find(waiting, player)
	
	if i then 
		table.remove(waiting, i)
		
		checkVoting()
	end
end

--Add to List--
local function addWait(player)
	table.insert(waiting, player)
	
	checkVoting()
end

--Collect Votes from clients--
votingEvent.OnServerEvent:Connect(function(player, votes)
	print(votes)
end)

--Keep track of current available players--
game.Players.PlayerAdded:Connect(function(player)
	local gameState = player:WaitForChild("GameState")
	
	gameState.Changed:Connect(function(value)
		if value == "Lobby" then
			addWait(player)
		else
			removeWait(player)
		end
	end)
end)

--Remove on leave--
game.Players.PlayerRemoving:Connect(removeWait)
