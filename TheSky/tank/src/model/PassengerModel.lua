--
-- Author: Your Name
-- Date: 2016-7-12 17:05:10
--

local PassengerModel = qy.class("PassengerModel", qy.tank.model.BaseModel)
local StrongModel = qy.tank.model.StrongModel

PassengerModel.typeNameList ={
	["1"] = qy.TextUtil:substitute(90040),
	["2"] = qy.TextUtil:substitute(90041),
	["3"] = qy.TextUtil:substitute(90042),
	["4"] = qy.TextUtil:substitute(90043),
	["5"] = qy.TextUtil:substitute(90044),
	["6"] = qy.TextUtil:substitute(90045),
	["7"] = "指导员"
}

PassengerModel.tujianTypeNameList ={
	["1"] = qy.TextUtil:substitute(90046),
	["2"] = qy.TextUtil:substitute(90047),
	["3"] = qy.TextUtil:substitute(90048),
	["4"] = qy.TextUtil:substitute(90049),
	["5"] = qy.TextUtil:substitute(90050),
	["6"] = qy.TextUtil:substitute(90051),
	["7"] = qy.TextUtil:substitute(90052),
	["8"] = qy.TextUtil:substitute(90053),
	["9"] = qy.TextUtil:substitute(90054),
	["10"] = qy.TextUtil:substitute(90055),
	["11"] = qy.TextUtil:substitute(90056),
	["12"] = qy.TextUtil:substitute(90057),
	["13"] = qy.TextUtil:substitute(90058)
}
function PassengerModel:init(data)
	self.passengerList = data.passenger.passengerlist
	self.collect = data.passenger.collect
	self.join = data.joinlist.join
	self.property = data.joinlist.property
	self.status1 = data.extract.recruit100.status
	self.status2 = data.extract.recruit200.status
    self.cdTime1 = data.extract.recruit100.cdtime
    self.cdTime2 = data.extract.recruit200.cdtime
    self.first = data.passenger.first
    self.serviceTime = data.server_time

    self.page = 1
    self.page2 = 1
    self.page3 = 1
    self.finalEnableList = {}
    self.finalEnableList2 = {}
    self.finalEnableList3 = {}
    self.enableUse = {}  -- 可装载的乘员(包含碎片)
    self.atPosList = {}	 -- 已装载的乘员
    self.upPassengerUse = {} -- 可用于升级乘员(不包含碎片)
    self.enableStudy = {}	 -- 可用于进修的乘员
    self.list = {}
    self.tankAttrs = {}
    self.uptempdate = {}--晋升的临时data
    self.passenger_config = qy.Config.passenger
    self.passenger_study_consume = qy.Config.passenger_study_consume--乘员进修消耗表
    self.passenger_study_list = qy.Config.passenger_study_attr--进修属性表

    self:resetAllList()
end

function PassengerModel:Maininit(data)
	self.passengerList =data.passenger and data.passenger.passengerlist or {}
	self.collect = data.passenger and data.passenger.collect or {}
	self.status1 = data.passenger and data.passenger.status or 200
	self.status2 = data.passenger and data.passenger.status or 200
	self.page = 1
    self.page2 = 1
    self.page3 = 1
    self.finalEnableList = {}
    self.finalEnableList2 = {}
    self.finalEnableList3 = {}
    self.enableUse = {}  -- 可装载的乘员(包含碎片)
    self.atPosList = {}	 -- 已装载的乘员
    self.enableStudy = {}	 -- 可用于进修的乘员
    self.upPassengerUse = {} -- 可用于升级乘员(不包含碎片)
    self.uptempdate = {}--晋升的临时data
    self.list = {}
    self.tankAttrs = {}

    self:resetAllList()

end

-- 刷新所有列表数据
function PassengerModel:resetAllList()
	if type(self.passengerList) == "table" then
    	self:update(self.passengerList)
    end
end
function PassengerModel:getnewlist( unique_id )
	local list = {}
	for k,v in pairs(self.enableStudy) do
		if v.unique_id == unique_id then
			table.insert(list,v)
		end
	end
	return list
end

function PassengerModel:extract(data)
	self.passengerList = data.passenger.passengerlist
	self.collect = data.passenger.collect
	self.first = data.passenger.first
	self.join = data.joinlist.join
	self.property = data.joinlist.property
	self.status1 = data.extract.recruit100.status
	self.status2 = data.extract.recruit200.status
    self.cdTime1 = data.extract.recruit100.cdtime
    self.cdTime2 = data.extract.recruit200.cdtime
    self.serviceTime = data.server_time

    self:resetAllList()
end

function PassengerModel:updateData(data, addPic)
	if data.passenger then
		self.passengerList = data.passenger.passengerlist
		self.collect = data.passenger.collect
		self.join = data.joinlist.join
		self.property = data.joinlist.property

    	self:resetAllList()
	end
end
function PassengerModel:updateData1( data,addPic )
	if data.passenger then
		self.passengerList = data.passenger.passengerlist
		self.collect = data.passenger.collect
    	self:resetAllList()
	end
end

function PassengerModel:update(data)
	if data then
		self.list = {}
		local staticData = qy.Config.passenger
		for i, v in pairs(data) do
			if not self.list[tostring(v.unique_id)] then
				local entity = qy.tank.entity.PassengerEntity.new(v, staticData[tostring(v.pass_id)])
				self.list[tostring(v.unique_id)] = entity
			else
				self.list[tostring(v.unique_id)]:update(v)
			end
		end
	end

	self:classfiy()
	self:sort()
	self.finalEnableList = qy.Utils.oneToTwo(self.enableUse, math.ceil((#self.enableUse) / 12), 12)
	-- 升级页面
	self.finalEnableList2 = qy.Utils.oneToTwo(self.upPassengerUse, math.ceil((#self.upPassengerUse) / 12), 12)

	self.finalEnableList3 = qy.Utils.oneToTwo(self.enableStudy, math.ceil((#self.enableStudy) / 12), 12)

	self:getAttrs()
end

function PassengerModel:refreshUpPassengerUse(uid)
	for i, v in pairs(self.upPassengerUse) do
		if v.unique_id == uid then
			table.remove(self.upPassengerUse, i)
		end
	end
	self.finalEnableList2 = qy.Utils.oneToTwo(self.upPassengerUse, math.ceil((#self.upPassengerUse) / 12), 12)
end
function PassengerModel:refreshenableStudy(uid)
	for i, v in pairs(self.enableStudy) do
		if v.unique_id == uid then
			table.remove(self.enableStudy, i)
		end
	end
	self.finalEnableList3 = qy.Utils.oneToTwo(self.enableStudy, math.ceil((#self.enableStudy) / 12), 12)
end
function PassengerModel:getuppassenger(_unique_id, pas_id )
	local list = {}
	for i, v in pairs(self.list) do
		if v.iscomplete == 100 then
			if (v.isjoin == 200 and v.unique_id ~=_unique_id and v.passenger_id == pas_id and v.study_level < 2) or v.passengerType == 7  then
				table.insert(list,v)
			end
		end
	end
	for k,v in pairs(list) do
		if self.uptempdate and self.uptempdate.unique_id == v.unique_id then
			table.remove(list,k)
			break
		end
	end
	-- for k,v in pairs(list) do
	-- 	if  v.study_level >=2 then
	-- 		table.remove(list,k)
	-- 		break
	-- 	end
	-- end
	return list
end

function PassengerModel:getAttrs()
	self.tankAttrs = {}
	self.achieveAttrs = {}
	for k, j in pairs(self.atPosList) do
		if not self.tankAttrs[tostring(k)] then
			self.tankAttrs[tostring(k)] = {}
		end

		for i, v in pairs(j) do
			if not self.tankAttrs[tostring(k)].atk then
				self.tankAttrs[tostring(k)].atk = v:getAttr1().atk or 0
			else
				self.tankAttrs[tostring(k)].atk = self.tankAttrs[tostring(k)].atk + v:getAttr1().atk
			end
			if not self.tankAttrs[tostring(k)].def then
				self.tankAttrs[tostring(k)].def = v:getAttr1().def or 0
			else
				self.tankAttrs[tostring(k)].def = self.tankAttrs[tostring(k)].def + v:getAttr1().def
			end
			if not self.tankAttrs[tostring(k)].hp then
				self.tankAttrs[tostring(k)].hp = v:getAttr1().hp or 0
			else
				self.tankAttrs[tostring(k)].hp = self.tankAttrs[tostring(k)].hp + v:getAttr1().hp
			end
		end
	end
end


-- 归类
function PassengerModel:classfiy()
	self.atPosList = {}
	self.enableUse = {}
	self.upPassengerUse = {}
	self.enableStudy = {}
	for i, v in pairs(self.list) do
		if v.iscomplete == 100 then
			if v.isjoin == 100 then
				if not self.atPosList[tostring(v.tank_unique_id)] then
					self.atPosList[tostring(v.tank_unique_id)] = {}
					table.insert(self.atPosList[tostring(v.tank_unique_id)], v)
				else
					table.insert(self.atPosList[tostring(v.tank_unique_id)], v)
				end
			elseif v.isjoin == 200 then
				table.insert(self.upPassengerUse, v)
			end
			if v.quality >= 5 and v.passenger_id  ~= 27 and v.passenger_id ~= 59 then
				table.insert(self.enableStudy, v)
			end
		end
		if v.isjoin == 200 then
			table.insert(self.enableUse, v)
		end
	end
	-- 更新变强数据
	self:updateStrong()
end

function PassengerModel:updateStrong()
	local x = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        x = x + 1
        if v.id == 3 then
            table.remove(StrongModel.StrongFcList, x)
        end
    end
    local i = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        i = i + 1
        if v.id == 4 then
            table.remove(StrongModel.StrongFcList, i)
        end
    end
	local level = qy.tank.model.UserInfoModel.userInfoEntity.level
	local totalLevel = 0
	local quality1 = 0
	local quality2 = 0
	local quality3 = 0
	local quality4 = 0
	local quality5 = 0
	local quality6 = 0
	local quality7 = 0
	for k,v in pairs(self.atPosList) do
		for key,value in pairs(v) do
			totalLevel = totalLevel + value.level
			
			if value.quality == 1 then
				quality1 = quality1 + 1
			elseif  value.quality == 2 then
				quality2 = quality2 + 1
			elseif  value.quality == 3 then
				quality3 = quality3 + 1
			elseif  value.quality == 4 then
				quality4 = quality4 + 1
			elseif  value.quality == 5 then
				quality5 = quality5 + 1
			elseif  value.quality == 6 then
				quality6 = quality6 + 1
			elseif  value.quality == 7 then
				quality7 = quality7 + 1
			end
		end
	end
	local progressNum = 0
	if level >= 70 and level <= 90 then
		progressNum = quality1 / 192 + quality2 / 96 + quality3 / 48 + quality4 / 24 + quality5 / 12 + quality6 / 6 + quality7 / 3
	elseif level > 90 and level <= 100 then
		progressNum = quality1 / 240 + quality2 / 120 + quality3 / 60 + quality4 / 30 + quality5 / 15 + quality6 / 7.5 + quality7 / 3.75
	elseif level > 100 then
		progressNum = quality1 / 384 + quality2 / 192 + quality3 / 96 + quality4 / 48 + quality5 / 24 + quality6 / 12 + quality7 / 6
	end
	local list1 = {["id"] = 3 , ["progressNum"] = progressNum}
	local list2 = {["id"] = 4 , ["progressNum"] = totalLevel / 480}
	table.insert(StrongModel.StrongFcList,list1)
	table.insert(StrongModel.StrongFcList,list2)
end

function PassengerModel:sort()
	table.sort(self.enableUse, function(a, b)
		if a.iscomplete == b.iscomplete then
			if a.quality == b.quality then
		    	return a.passengerType < b.passengerType
		   	end
		   	return a.quality > b.quality
		end
		return a.iscomplete < b.iscomplete
	end)

	table.sort(self.atPosList, function(a, b)
		return a.passengerType < b.passengerType
	end)

	table.sort(self.upPassengerUse, function(a, b)
		if a.passengerType == b.passengerType then
		    return a.quality < b.quality
		end
		return a.passengerType > b.passengerType 
	end)
	table.sort(self.enableStudy, function(a, b)
		if a.quality == b.quality then
			if a.study_level == b.study_level then
				return a.level > b.level
			end
		    return a.study_level > b.study_level
		end
		return a.quality > b.quality 
	end)
end
--判断进修是否满
function PassengerModel:getstudystus( level,exp )
	local tempnum = 0
	local list = {}
	for k,v in pairs(self.passenger_study_list) do
		if v.study_level == level then
			table.insert(list,v)
		end
	end
	table.sort(list, function(a, b)
		return a.id < b.id
	end)
	if level < 5 then
		if exp < list[#list].exp_max then
			tempnum = 0
		else
			tempnum = 1
		end
	else
		if exp >= list[#list].exp_max then
			tempnum = 2
		else
			tempnum = 0
		end
	end
	return tempnum
	
end
function PassengerModel:getstudyshuxing( level )
	local tempnum = {
	["1"] = 0,
	["2"] = 0,
	}	
	local list = {}
	for k,v in pairs(self.passenger_study_list) do
		if v.study_level == level then
			table.insert(list,v)
		end
	end
	table.sort(list, function(a, b)
		return a.id < b.id
	end)
	tempnum["1"] = (list[1].exp_min)/10
	tempnum["2"] = (list[#list].exp_max)/10
	return tempnum
end

-- 点自动添加
function PassengerModel:getAutoEnablePassenger()
	local retList = {}
	local x = 0
	for k,v in pairs(self.upPassengerUse) do
		if v.passengerType == 6 or v.quality < 5 then
			if x < 4 then
				table.insert(retList, v)
			end
			x = x + 1
		end
	end
	return retList
end

function PassengerModel:getEnableUse()
	return self.finalEnableList
end
function PassengerModel:getEnableUse3()
	return self.finalEnableList3
end

function PassengerModel:getMaxPage()
	return #self.finalEnableList
end

function PassengerModel:setPage(page)
	if page > 0 and page <= self:getMaxPage() then
		self.page = page
	end

	if page <= 0 then
		self.page = 1
	end

	if page > self:getMaxPage() then
		self.page = self:getMaxPage()
	end
end
-- 升级页面
function PassengerModel:getEnableUse2()
	return self.finalEnableList2
end

-- 升级页面的页数
function PassengerModel:getMaxPage2()
	return #self.finalEnableList2
end

-- 升级页面的页数
function PassengerModel:setPage2(page)
	if page > 0 and page <= self:getMaxPage2() then
		self.page2 = page
	end

	if page <= 0 then
		self.page2 = 1
	end

	if page > self:getMaxPage2() then
		self.page2 = self:getMaxPage2()
	end
end
-- 进修页面的页数
function PassengerModel:getMaxPage3()
	return #self.finalEnableList3
end
-- 进修页面的页数
function PassengerModel:setPage3(page)
	if page > 0 and page <= self:getMaxPage3() then
		self.page3 = page
	end

	if page <= 0 then
		self.page3 = 1
	end

	if page > self:getMaxPage3() then
		self.page3 = self:getMaxPage3()
	end
end

-- 升级页面  获取当前页可用的第一个passenger
function PassengerModel:getCurrentPageFirstPassenger2(idx)
	idx = idx or 1
	if self.finalEnableList2[self.page2] then
		return self.finalEnableList2[self.page2][idx], idx
	end
end

-- 获取面板上(中间下面位置)显示的entity
function PassengerModel:getSelectPassengerEntity(entity, idx, stype)
	if stype == 1 then
		return self:getCurrentPageFirstPassenger(idx)
	else
		if type(entity) == "table" then
			local data = self.atPosList[tostring(entity.unique_id)]
			if data ~= nil and #data > 0 then
				if not idx then
					table.sort(data, function(a, b)
						local key1 = a.passengerType
						local key2 = b.passengerType
						return key1 < key2
					end)

					return data[1]
				else
					for i, v in pairs(data) do
						if v.passengerType == idx then
							return v
						end
					end
				end
			else
				return self:getCurrentPageFirstPassenger()
			end
		else
			return self:getCurrentPageFirstPassenger()
		end
	end
end

-- 获取当前页可用的第一个passenger
function PassengerModel:getCurrentPageFirstPassenger(idx)
	idx = idx or 1
	if self.finalEnableList[self.page] then
		return self.finalEnableList[self.page][idx], idx
	end
end
function PassengerModel:atTank(entity)
	if type(entity) == "table" then
		local tankUniqueId = entity.unique_id
		local list = self.atPosList[tostring(tankUniqueId)]
		if list and #list ~= 0 then
			table.sort(list, function(a, b)
				return a.passengerType < b.passengerType
			end)
		end
		return list
	end
end

-- 获取坦克 乘员 提供的属性加成
function PassengerModel:getAttribute(unique_id)
	if not self.tankAttrs[tostring(unique_id)] then
		return {}
	end

	return self.tankAttrs[tostring(unique_id)]
end

-- 新加的passenger不可能出现在坦克位置上，所以不需要重新计算增加属性
function PassengerModel:addPassenger(data)
	if data then
		local staticData = qy.Config.passenger
		if not self.list[tostring(data.unique_id)] then
			local entity = qy.tank.entity.PassengerEntity.new(data, staticData[tostring(data.pass_id)])
			self.list[tostring(data.unique_id)] = entity
		else
			self.list[tostring(data.unique_id)]:update(data)
		end
	end

	self:classfiy()
	self:sort()
	self.finalEnableList = qy.Utils.oneToTwo(self.enableUse, math.ceil(table.nums(self.enableUse) / 12), 12)
	self.finalEnableList2 = qy.Utils.oneToTwo(self.upPassengerUse, math.ceil(table.nums(self.upPassengerUse) / 12), 12)
	self.finalEnableList3 = qy.Utils.oneToTwo(self.enableStudy, math.ceil((#self.enableStudy) / 12), 12)
end
function PassengerModel:gettujiantotalnum(  )
	local list = {}
	local staticData = qy.Config.passenger
	for k,v in pairs(staticData) do
		if v.tujian_type > 0 then
			table.insert(list,v)
		end
	end
	return #list
end
function PassengerModel:getTujianList()
	local enableUse = {}
    local cfg = qy.Config.passenger
    for k,v in pairs(cfg) do
    	if v.type ~= 6 and v.type ~= 7 then
        	table.insert(enableUse,v)
        end
    end

    table.sort(enableUse, function(a, b)
		if a.quality == b.quality then
		    if a.type == b.type then
		        return a.id < b.id
		    end
		    return a.type < b.type
		end
		return a.quality < b.quality
	end)
	


    return qy.Utils.oneToTwo(enableUse, math.ceil((#enableUse) / 4), 4)
end

function PassengerModel:getAddAttr()
	local attribute = {}
	local retList = {}
    local cfg = qy.Config.passenger
    if self.collect and #self.collect ~= 0 then
    	for k,v in pairs(cfg) do
    		for i=1, #self.collect do
	    		if v.tujian_type ~= 0  and self.collect[i] == tonumber(k) then
	    			if not attribute[tostring(v.tujian_type)] then
						attribute[tostring(v.tujian_type)] = v.tujian_val
					else
						attribute[tostring(v.tujian_type)] = attribute[tostring(v.tujian_type)] + v.tujian_val
					end
	    		end
	    	end
	    end
	end
	
	for k,v in pairs(attribute) do
		local temp = {}
		temp["type"] = k
		temp["val"] = v
		table.insert(retList, temp)
	end

	table.sort(retList, function(a, b)
		return a.type < b.type
	end)
    return retList
end

function PassengerModel:getAttrbute2()
	local attribute = {}
    local cfg = qy.Config.passenger
    if self.collect and #self.collect ~= 0 then
    	for k,v in pairs(cfg) do
    		for i=1, #self.collect do
	    		if v.tujian_type ~= 0 and self.collect[i] == tonumber(k) then
	    			if not attribute[tostring(v.tujian_type)] then
						attribute[tostring(v.tujian_type)] = v.tujian_val
					else
						attribute[tostring(v.tujian_type)] = attribute[tostring(v.tujian_type)] + v.tujian_val
					end
	    		end
	    	end
	    end
	end

    return attribute
end


function PassengerModel:getInfoFromTankEntity(entity)
	if not self.passenger_config then
		self.passenger_config = qy.Config.passenger
	end


	local list = nil
	if entity then
		local data = entity.passenger

		if data then
		
			for i = 1, 5 do
				if data["P_"..i] and data["P_"..i] ~= 0 then
					local entity = qy.tank.entity.PassengerEntity.new(data["P_"..i], self.passenger_config[tostring(data["P_"..i].pass_id)])

					if not list then
						list = {}
					end 
					table.insert(list, entity)
				end
			end

			if list and #list ~= 0 then
				table.sort(list, function(a, b)
					return a.passengerType < b.passengerType
				end)
			end
		end
	end

	return list
end

function PassengerModel:getAddAttrSingle(tujian_type)
	local attrs = self:getAddAttr()
	for i,v in pairs(attrs) do
		if tonumber(v.type) == tujian_type then
			return v.val
		end
	end
end

return PassengerModel