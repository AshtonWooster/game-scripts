--Music Controller
--Ashton
--3.7.23

--Modules--
local musicPacket = require(script.Parent:WaitForChild("Classes"):WaitForChild("MusicPacket"))

--Objects--
local repStorage = game:GetService("ReplicatedStorage")
local events = repStorage:WaitForChild("Events")
local music = events:WaitForChild("Music")
local musicFolder = workspace:WaitForChild("Music")

--Variables--
local songs = {}

--Functions--
local funcs = {
	play = function()
		print("Play")
	end,
}

--Set up Songs--
for _, obj in pairs(musicFolder:GetChildren()) do
	songs[obj.Name] = musicPacket.new(obj)
end

--Music--
music.OnClientEvent:Connect(function(action, obj)
	assert(funcs[action], "No action "..action.." exists.")
	
	funcs[action](obj)
end)