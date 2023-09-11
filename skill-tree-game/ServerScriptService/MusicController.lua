--Music Controller Server
--Ashton
--2.5.23

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local musicEvent = events:WaitForChild("Music")
local musicFolder = workspace:WaitForChild("Music")

--TestCase--
game.Players.PlayerAdded:Connect(function(player)
	wait(5)
	musicEvent:FireClient(player, "play", musicFolder:GetChildren()[1])
end)
