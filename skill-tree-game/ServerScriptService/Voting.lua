--Server Voting Script
--Ashton
--9.13.23 -- 9.26.23

--Modules--
local valueManip = require(script.Parent:WaitForChild("ValueManip"))
local classesFolder = script.Parent:WaitForChild("Classes")
local classes = {}
for _, obj in pairs(classesFolder:GetChildren()) do
	classes[obj.Name] = require(obj)
end


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
local wonMapValue = votingFolder:WaitForChild("Map")
local wonModeValue = votingFolder:WaitForChild("Mode")

--Variables--
local waiting = {}
local currentMaps = {}
local playerVotes = {}

--Constants--
local MIN_PLAYERS  = 2
local MAX_MAPS     = 3
local VOTING_TIME  = 20

--Set Up Map Object Values--
for _, objectVal in pairs(chosenMaps:GetChildren()) do
	currentMaps[tonumber(objectVal.Name)] = objectVal
end

--Send all Message--
local function sendAllMessage(message)
	classes["TextPacket"].SendToAll(message)
end

--Calculate Winning Votes--
local function calculateWinners()
	local totaledVotes = {
		Map = {0,0,0},
		Mode = {0,0,0,0},
	}
	
	for _, vote in pairs(playerVotes) do
		if vote["Map"] then
			totaledVotes["Map"][vote["Map"]] = totaledVotes["Map"][vote["Map"]] + 1
		end
		if vote["Mode"] then
			--totaledVotes["Mode"][vote["Mode"]] = totaledVotes["Mode"][vote["Mode"]] + 1
		end
	end
	
	local winningMaps = valueManip.FindMaxValues(totaledVotes["Map"])
	local winningModes = valueManip.FindMaxValues(totaledVotes["Mode"])
	
	local finalChosenMap = currentMaps[winningMaps[math.random(1, #winningMaps)]].Value
	wonMapValue.Value = finalChosenMap
	sendAllMessage("Chosen Map: "..finalChosenMap.Config:WaitForChild("Name").Value)
	
	--local finalChosenMode = currentModes[winningMode].Value
	--wonModeValue.Value = finalChosenMode
	--sendAllMessage("Chosen Mode: "..finalChosenMode.Name)
end

--Start Timer--
local function startTimer()
	while votingTime.Value > 0 and votingValue.Value do
		votingTime.Value = votingTime.Value - 1
		wait(1)
	end
	
	--End Voting when timer hits 0--
	if votingValue.Value then
		calculateWinners()
		votingValue.Value = false
	end
end

--Stop Voting--
local function stopVoting()
	for _, objectVal in currentMaps do
		objectVal.Value = nil
	end
	
	votingValue.Value = false
	votingTime.Value = 0
	wonMapValue.Value = nil
	wonModeValue.Value = nil
	playerVotes = {}
end

--Start Voting--
local function startVoting()	
	--Choose Maps
	local availableMaps = maps:GetChildren()
	for i=1, MAX_MAPS do
		local chosenMap = math.random(1, #availableMaps)
		currentMaps[i].Value = availableMaps[chosenMap]
		table.remove(availableMaps, chosenMap)
	end
	
	votingValue.Value = true
	votingTime.Value = VOTING_TIME
	startTimer()
end

--Check Voting Amount--
local function checkVoting()
	if votingValue.Value and #waiting < MIN_PLAYERS then
		stopVoting()
	elseif not votingValue.Value and #waiting >= MIN_PLAYERS then
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

--Submit Vote--
local function submitVote(player, votes)
	local listIndex = valueManip.FindList(playerVotes, "Player", player.UserId)
	local mapVoteNum = votes["Map"]
	
	if not listIndex then 
		table.insert(playerVotes, {
			Player = player.UserId,
			Map = mapVoteNum,
		})
	else
		playerVotes[listIndex]["Map"] = mapVoteNum
	end 
end

--Collect Votes from clients--
votingEvent.OnServerEvent:Connect(function(player, votes)
	if votingTime.Value > 0 and votingValue.Value then
		submitVote(player, votes)
	end
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
