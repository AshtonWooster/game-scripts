--Server Data Handler
--Ashton
--10.2.23

--Objects--
local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("TestData")

--Modules--
local valueManip = require(script.Parent:WaitForChild("ValueManip"))

--Constants--
local PLAYER_IDENTIFIER = "user_"
local DEFAULT_DATA = {
	Characters = {
		{
			Name = "Sharpshooter",
			Abilities = {},
		},
	},
}

--Retrieve Player list--
local function getList(name)
	local success, count, adminList = false, 0, {}
	while not success and count < 3 do
		success, adminList = pcall(function()
			return dataStore:GetAsync(name)
		end)
		if success then
			break 
		else
			print("Failed to load data for "..name)
			count = count + 1
		end
	end
	
	return adminList, success
end

--Add all player values--
game.Players.PlayerAdded:Connect(function(player)
	local playerData, success = getList(PLAYER_IDENTIFIER..tostring(player.UserId))
	assert(success, "Data Failed catastrophically: "..player.Name)
	
	local dataFolder = Instance.new("Folder")
	dataFolder.Name = "PlayerData"
	dataFolder.Parent = player
	local characterDataFolder = Instance.new("Folder")
	characterDataFolder.Name = "Characters"
	characterDataFolder.Parent = dataFolder
	
	playerData = valueManip.MergeHashes(playerData, DEFAULT_DATA)
	for _, ownedChar in pairs(playerData["Characters"]) do
		local charFolder = Instance.new("Folder")
		charFolder.Parent = characterDataFolder
		charFolder.Name = ownedChar["Name"]
	end
end)
