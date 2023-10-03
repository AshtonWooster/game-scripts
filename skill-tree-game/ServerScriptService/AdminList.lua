--Server Admin List
--Ashton
--9.18.22 -- 10.2.23

--Objects--
local list = {}
local dataStore = game:GetService("DataStoreService")
local adminStore = dataStore:GetDataStore("AdminData")

--Retrieve list--
local function getList()
	local success, count, adminList = false, 0, {}
	while not success and count < 3 do
		success, adminList = pcall(function()
			return adminStore:GetAsync("AdminList")
		end)
		if success then
			break 
		else
			print("Failed to load admin list")
			count = count + 1
		end
	end

	return adminList, success
end

--Save List--
local function saveList(toSave)
	local success, count, message = false, 0, ""
	while not success and count < 3 do
		success, message = pcall(function()
			adminStore:SetAsync("AdminList", toSave)
		end)
	end
end

--Get List--
function list.GetList() 
	return getList()
end

--Update Admin--
function list.UpdateAdmin(player, rank)
	local adminList, success = getList()
	if success then
		adminList[tostring(player.UserId)] = rank >= 0 and rank or nil
		saveList(adminList)
	else
		print("Data failed catastrophically")
	end
end

--Is Admin--
function list.GetRank(player)
	return getList()[tostring(player.UserId)]
end

return list