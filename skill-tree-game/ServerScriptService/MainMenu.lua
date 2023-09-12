--Server Main Menu Controller
--Ashton
--9.11.23 -- 9.12.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local menuEvent = events:WaitForChild("Menu")
local menuPositions = workspace:WaitForChild("MenuPositions")
local lobbySpawnPositions = menuPositions:WaitForChild("SpawnLocations")

--Freeze Character--
local function freezeChar(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpHeight = 0
end

--Unfreeze Character--
local function unfreezeChar(character)
	--Placeholder values, replace with custom values later
	local toSpeed = 16
	local toHeight = 7.2
	
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = toSpeed
	humanoid.JumpHeight = toHeight
end

--Spawn Character--
local function placeChar(character, pos)
	local toLocation = pos

	character:PivotTo(CFrame.new(toLocation))
end

--Choose Random Spawn--
local function chooseSpawn()
	local spawnPositions = lobbySpawnPositions:GetChildren()
	
	return spawnPositions[math.random(1, #spawnPositions)].Position
end

--Hold Player Until loaded--
game.Players.PlayerAdded:Connect(function(player)
	local gameState = Instance.new("StringValue")
	gameState.Value = "Menu"
	gameState.Name = "GameState"
	gameState.Parent = player
	
	--Freeze Character while in menu
	player.CharacterAdded:Connect(function(character)
		if gameState.Value == "Menu" then
			freezeChar(character)
		elseif gameState.Value == "Lobby" then
			player.CharacterAppearanceLoaded:Wait()
			placeChar(character, chooseSpawn())
		end
	end)
end)


--Load Player In--
menuEvent.OnServerEvent:Connect(function(player)
	local character = player.Character
	assert(character, player.Name..": suspicious activity.")
	
	placeChar(character, chooseSpawn())
	player.GameState.Value = "Lobby"
	unfreezeChar(character)
end)
