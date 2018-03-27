--作战室model

local BattleRoomModel = qy.class("BattleRoomModel", qy.tank.model.BaseModel)

local RoleUpgradeModel = qy.tank.model.RoleUpgradeModel

--初始化列表
function BattleRoomModel:initList(data)
	local listArr = data.activity_list["1"]
	self.listIndex = {}
	self.otherData = {}
	for i=1,#listArr do
		if type(listArr[i]) == "string" then
			table.insert(self.listIndex , listArr[i])
		else
			for k,v in pairs(listArr[i]) do
				table.insert(self.listIndex , k)
				self.otherData[k] = v
			end
		end
	end

	-- table.insert(self.listIndex , "soul_road")
	-- table.insert(self.listIndex , "singlehero")
	-- self:__initOpenFunctionLevel()
	-- self.listIndex -- ["gunner_train","invade","classicBattle","inspection","arena","expedition"]
end

-- function BattleRoomModel:__initOpenFunctionLevel()
-- 	self.openLevel = {}
-- 	local data = qy.Config.function_open
-- 	for i = 1, #self.listIndex do
-- 		local _openViewId = qy.tank.utils.ModuleUtil.getViewIdByType(self.listIndex[i])

-- 		for _k, _v in pairs(data) do
-- 			if data[_k].view_id == _openViewId then
-- 				self.openLevel[self.listIndex[i]] = "(" .. data[_k].open_level .. "级开启）"
-- 			end
-- 		end
-- 	end
-- end

function BattleRoomModel:getRoomDataByName(_name)
	-- print("_name_name_name_name_name==",_name)
	local arr = RoleUpgradeModel:getFuncDataArr()
	for i = 1, #arr do
		-- print("arr[i]e_name arr[i]e_name arr[i]e_name ==", arr[i].e_name)
		if arr[i].e_name == _name then
			-- print("arr[i] arr[i] arr[i] arr[i]===", arr[i])
			return arr[i]
		end
	end
	return {}

	-- if self.openLevel[_name] then
	-- 	return self.openLevel[_name]
	-- else
	-- 	return ""
	-- end
end

function BattleRoomModel:getListIndex()
	return self.listIndex
end

function BattleRoomModel:getRoomNameByIdx(idx)
	return self.listIndex[idx]
end

function BattleRoomModel:getNum()
	return #self.listIndex
end

function BattleRoomModel:getKeyByIndex(_i)
	return self.listIndex[_i]
end

function BattleRoomModel:getIdxByRoomName(_name)
	for i = 1, #self.listIndex do
		if self.listIndex[i] == _name then
			return i
		end
	end
	return -1
end

-- function BattleRoomModel:initAnnouncement()
-- 	if self.announcementList == nil then
-- 		self.announcementList = {}
-- 		local data = qy.Config.battle_room_announcement
-- 		for _k, _v in pairs(data) do
-- 			table.insert(self.announcementList, data[_k].content)
-- 		end
-- 	end
-- 	self.announcementIndex = math.random(1, #self.announcementList)
-- end

-- function BattleRoomModel:getAnnouncement()
-- 	self.announcementIndex = self.announcementIndex + 1
-- 	if self.announcementIndex > #self.announcementList then
-- 		self.announcementIndex = 1
-- 	end
-- 	--print("作战室公告：" .. self.announcementList[self.announcementIndex])
-- 	local str = ""
-- 	for i = self.announcementIndex , #self.announcementList do
-- 		str = str .. self.announcementList[i] .. "                                        "
-- 	end

-- 	for i = 1, self.announcementIndex do
-- 		str = str .. self.announcementList[i] .. "                                        "
-- 	end

-- 	return str
-- end

return BattleRoomModel
