--Main Game Server Script
--Ashton
--9.20.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local votingFolder = repStorage:WaitForChild("Voting")
local wonMapValue = votingFolder:WaitForChild("Map")
local wonModeValue = votingFolder:WaitForChild("Mode")
local mapFolder = workspace:WaitForChild("GameMap")
local mapLocation = workspace:WaitForChild("MapLocation")

--Variables--
local playing = {}

--Constants--
local RESULTS_TIME = 5

--Spawn Map--
local function createMap(map)
	local newMap = map:Clone()
	newMap.Parent = mapFolder
	newMap:PivotTo(CFrame.new(mapLocation.Position))
	
	return newMap
end

--Get Available Players--
local function getPlayers()
	local available = {}
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.GameState.Value == "Lobby" then
			table.insert(available, player)
		end
	end
	
	return available
end

--Spawn Players in map--
local function spawnPlayers(map)
	local players = getPlayers()
	local locations = map.Spawns:GetChildren()
	
	for i, player in pairs(players) do
		local character = player.Character
		if not character then
			print(player.Name.." not ready.")
		else
			character:PivotTo(CFrame.new(locations[i].Position))
			table.insert(playing, player)
			player.GameState.Value = "Playing"
		end
	end
end

--Spawn Map after voting is complete--
wonMapValue.Changed:Connect(function(value)
	if value then
		local map = createMap(value)
		wait(RESULTS_TIME)
		if not wonMapValue.Value then
			map:Destroy()
			return
		end
		
		spawnPlayers(map)
	end
end)
