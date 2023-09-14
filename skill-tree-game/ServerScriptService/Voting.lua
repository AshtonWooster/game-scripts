--Server Voting Script
--Ashton
--9.13.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local maps = repStorage:WaitForChild("Maps"):GetChildren()

--Variables--
local isVoting = false
local waiting = {}

--Constants--
local MIN_PLAYERS = 2

--Stop Voting--
local function stopVoting()
	isVoting = false
	
	print("Stop Voting")
end

--Start Voting--
local function startVoting()
	isVoting = true
	
	print("Start Voting")
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
