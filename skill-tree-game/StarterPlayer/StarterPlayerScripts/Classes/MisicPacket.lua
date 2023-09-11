--Music Packet Client
--Ashton
--2.5.23  -- 2.14.23

--Objects--
local MusicPacket = {}
MusicPacket.__index = MusicPacket

--Construct list--
local function constructList(songs)
	if typeof(songs) == "table" then
		return songs
	elseif typeof(songs) == "Instance" then
		if songs.ClassName == "Sound" then
			return {songs}
		elseif songs.ClassName == "Folder" then
			return songs:GetChildren()
		end
	else
		return {}
	end
end

--Constructor--
function MusicPacket.new(songs, params)
	local self = setmetatable({
		current = 1;
		playing = false;
		paused = false;
		loopedSong = false;
		looped = true;
		songs = constructList(songs);
		cont = nil;
	}, MusicPacket) 
	
	return self
end

--End After Song--
function MusicPacket:FinishWhenEnded()
	if self.cont then self.cont:Disconnect() end
	self.loopedSong = false
	self.looped = false
end

--Play Song--
function MusicPacket:Play()
	self.playing = true
	self.paused = false
	
	local current = self.current
	if self.cont then self.cont:Disconnect() end
	self.cont = self.songs[current].Ended:Connect(function()
		if self.loopedSong then
			self:Play()
			self.cont:Disconnect()
		else
			self:Skip()
		end
	end)
	
	self.songs[current]:Play()
end

--Pause Song--
function MusicPacket:Pause(duration)
	self.playing = false
	self.paused = true
	
	self.songs[self.current]:Pause()
end

--Stop Song--
function MusicPacket:Stop()
	self.playing = false
	self.paused = false
	
	self:FinishWhenEnded()
	self.songs[self.current]:Stop()
end

--Add Song--
function MusicPacket:AddSong(song)
	self.songs[#self.songs+1] = song
end

--Skip--
function MusicPacket:Skip(name)
	self.songs[self.current]:Stop()
	
	if name then
		for i, song in pairs(self.songs) do
			if song.Name == name then
				self.current = i
			end
		end
	else
		local max = #self.songs
		if self.current == max then
			self.current = 1
		end
	end
	
	self.songs[self.current]:Play()
end

--Remove Song--
function MusicPacket:RemoveSong(name)
	for i, song in pairs(self.songs) do
		if song.Name == name then
			if i < self.current then
				self.current = self.current - 1
			elseif i == self.current then
				self:Stop()
				table.remove(self.songs, i)
				self:Play()
				return
			end
			table.remove(self.songs, i)
		end
	end
end

return MusicPacket