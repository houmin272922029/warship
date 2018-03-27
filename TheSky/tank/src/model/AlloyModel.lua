--[[--
	帮助 model
	Author: H.X.Sun
--]]

local AlloyModel = qy.class("AlloyModel", qy.tank.model.BaseModel)
local StrongModel = qy.tank.model.StrongModel

AlloyModel.OPNE_LISTT_1 = 1 --该位置没嵌入合金（嵌入合金列表）
AlloyModel.OPNE_LISTT_2 = 2 --该位置已嵌入合金（更换合金列表）
AlloyModel.OPNE_LISTT_3 = 3 --升级合金列表

--alloy_id
AlloyModel.ALLOY_ID_1 = 1 --攻击合金
AlloyModel.ALLOY_ID_2 = 2 --防御合金
AlloyModel.ALLOY_ID_3 = 3 --血量合金

AlloyModel.MAX_Level = 10 --最大等级

local StringUtil = qy.tank.utils.String
local AwardType = qy.tank.view.type.AwardType


function AlloyModel:init(data)
	-- print("alloyList====>>>>>>",qy.json.encode(data))
	self.totalAlloyList = {}
	self.unSelectList = {}
	self.selectList = {}
	local index = 0
	if data then
		for i = 1, #data do
			local entity = qy.tank.entity.AlloyEntity.new(data[i])
			index = entity.alloy_id
			if self.totalAlloyList[index] == nil then
				self.totalAlloyList[index] = {}
			end
			table.insert(self.totalAlloyList[index], entity)
		end
	end

	-- for i = 1, #self.totalAlloyList do
	-- 更新变强数据
	self:updateStrong()
	for i,v in pairs(self.totalAlloyList) do
		self:updateAlloyList(i)
	end
end

function AlloyModel:__judgeList(_index)
	if self.totalAlloyList == nil then
		self.totalAlloyList = {}
	end
	if self.totalAlloyList[_index] == nil then
		self.totalAlloyList[_index] = {}
	end

	if self.unSelectList == nil then
		self.unSelectList = {}
	end

	if self.unSelectList[_index] == nil then
		self.unSelectList[_index] = {}
	end
end

function AlloyModel:add(data)
	local _index = 1
	if AwardType.ALLOY_1 == data.type then
		_index = self.ALLOY_ID_1
	elseif AwardType.ALLOY_2 == data.type then
		_index = self.ALLOY_ID_2
	else
		_index = self.ALLOY_ID_3
	end

	self:__judgeList(_index)

	local entity = nil
	for i = 1, data.num do
		local entity = qy.tank.entity.AlloyEntity.new(data.alloy)
		table.insert(self.totalAlloyList[_index], entity)
		table.insert(self.unSelectList[_index], entity)
	end
end

function AlloyModel:sortAlloyList(data)
	for _k,_v in pairs(data) do
		if _v then
			self.unSelectList[tonumber(_k)] = self:sort(self.unSelectList[tonumber(_k)])
		end
	end
end


function AlloyModel:getSelectAlloyByIndex(_aid,_eUid)
	if self.selectList[_aid] then
		for i = 1, #self.selectList[_aid] do
			if self.selectList[_aid][i].equip_unique_id == _eUid then
				return self.selectList[_aid][i]
			end
		end
	end
	return nil
end

function AlloyModel:initAttributeList()
	if self.attributeList == nil then
		self.attributeList = {}
	end

	local data = qy.Config.alloy
	local indexArr = {}
	for _k, _v in pairs(data) do
		indexArr = StringUtil.split(_k, "_")
		if self.attributeList[tonumber(indexArr[1])] == nil then
			self.attributeList[tonumber(indexArr[1])] = {}
		end
		_v.level = tonumber(indexArr[2])
		_v.name = self:getAttributeNameByAlloyId(tonumber(indexArr[1]))
		self.attributeList[tonumber(indexArr[1])][tonumber(indexArr[2])] = _v
	end
end

function AlloyModel:getAttributeListByAlloyId(_aid)
	if self.attributeList == nil or self.attributeList[_aid] == nil then
		self:initAttributeList()
	end
	--print("self.attributeList[".._aid.."]=======>>>>>",qy.json.encode(self.attributeList[_aid]))
	return self.attributeList[_aid]
end


--[[---
--排序：等级从大到小
-]]
function AlloyModel:sort(arr)
	table.sort(arr,function(a,b)
		if a.level == b.level then
			if a.exp == b.exp then
				return false
			else
				--经验
				return a.exp > b.exp
			end
		else
			--等级
			return a.level > b.level
		end
	end)
	return arr
end

function AlloyModel:getUnSelectNumByIndex(_index)
	if self.unSelectList[_index] then
		return #self.unSelectList[_index]
	else
		return 0
	end
end

function AlloyModel:getBatchDataByIndex(_index)
	if self.unSelectList[_index] then
		--一键升级只吃 1～3 级合金
		local _aType = 0
		if _index == self.ALLOY_ID_1 then
			_aType = AwardType.ALLOY_1
		elseif _index == self.ALLOY_ID_2 then
			_aType = AwardType.ALLOY_2
		else
			_aType = AwardType.ALLOY_3
		end
		local level_1_num = 0
		local level_2_num = 0
		local level_3_num = 0

		local data = self.unSelectList[_index]
		for i = 1, #data do
			if data[i].level == 1 then
				--1级合金
				level_1_num = level_1_num + 1
				table.insert(self.upSelectIndx, i)
			elseif data[i].level == 2 then
				--2级合金
				level_2_num = level_2_num + 1
				table.insert(self.upSelectIndx, i)
			elseif data[i].level == 3 then
				--3级合金
				level_3_num = level_3_num + 1
				table.insert(self.upSelectIndx, i)
			end
		end
		local batchData = {}

		if level_1_num > 0 then
			table.insert(batchData,{["type"] = _aType,["id"] = 1,["num"] = level_1_num})
		end
		if level_2_num > 0 then
			table.insert(batchData,{["type"] = _aType,["id"] = 2,["num"] = level_2_num})
		end
		if level_3_num > 0 then
			table.insert(batchData,{["type"] = _aType,["id"] = 3,["num"] = level_3_num})
		end
		return batchData
	else
		return {}
	end
end

function AlloyModel:getUnSelectEntityByIndex(alloy_id,_index)
	if self.unSelectList[alloy_id] and self.unSelectList[alloy_id][_index] then
		return self.unSelectList[alloy_id][_index]
	else
		return nil
	end
end

function AlloyModel:getSelectListByIndex(alloy_id,_equipUid)
	-- print("查找嵌入的合金id===>>>>"..alloy_id .. "===装备ID===>>>>>",_equipUid)
	if self.selectList[alloy_id] then
		for i = 1, #self.selectList[alloy_id] do
			-- print("查找嵌入的合金装备id===>>>>", self.selectList[alloy_id][i].equip_unique_id)
			if self.selectList[alloy_id][i].equip_unique_id == _equipUid then
				return self.selectList[alloy_id][i]
			end
		end
	end
	return nil
end

function AlloyModel:updateAlloyEntity(data)
	local _aid = data.alloy_id
	local entity = nil
	-- print
	local arr = self.totalAlloyList[_aid]
	-- print("#arr=====>>>>",#arr)
	for i = 1, #arr do
		if arr[i].unique_id == data.unique_id then
			arr[i]:update(data)
			if arr[i].pos == "" then
				-- print("减少的属性值======>>>>>",arr[i]:getAttribute())
				self.attributeNum = self.attributeNum - arr[i]:getAttribute()
			else
				-- print("增加的属性值======>>>>>",arr[i]:getAttribute())
				self.attributeNum = self.attributeNum + arr[i]:getAttribute()
			end
			return
		end
	end
end

function AlloyModel:updateAlloyList(index)
	print("self.totalAlloyList[]======>>>>>",index)
	if self.totalAlloyList[index] == nil then
		self.totalAlloyList[index] = {}
	end
	for i = 1, #self.totalAlloyList[index] do
		local entity = self.totalAlloyList[index][i]
		local index = entity.alloy_id
		if entity.pos == "" then
			if self.unSelectList[index] == nil then
				self.unSelectList[index] = {}
			end
			table.insert(self.unSelectList[index], entity)
		else
			if self.selectList[index] == nil then
				self.selectList[index] = {}
			end
			table.insert(self.selectList[index], entity)
		end
	end
	if self.unSelectList[index] and #self.unSelectList[index] > 1 then
		self.unSelectList[index] = self:sort(self.unSelectList[index])
	end
	
	-- 更新变强数据
	self:updateStrong()
end

function AlloyModel:updateStrong()
	local x = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        x = x + 1
        if v.id == 7 then
            table.remove(StrongModel.StrongFcList, x)
        end
    end
	local totalLevel = 0
	for k,v in pairs(self.selectList) do
		for key,value in pairs(v) do
			totalLevel = totalLevel + value.level
		end
	end
	local list = {["id"] = 7 , ["progressNum"] = (totalLevel / 576)}
	table.insert(StrongModel.StrongFcList,list)
end

function AlloyModel:updateAlloyPos(data)
	self.attributeNum = 0
	local index = {}
	for _k, _v in pairs(data) do
		self:updateAlloyEntity(data[_k])
		-- index = data[_k].alloy_id
		table.insert(index,data[_k].alloy_id)
	end
	-- if index > 0 then
	for i = 1, #index do
		self.unSelectList[index[i]] = {}
		self.selectList[index[i]] = {}
		self:updateAlloyList(index[i])
	end
end

function AlloyModel:afterUpgradToRefresh(data,entity)
	local _aid = entity.alloy_id
	--更新合金数据
	for _k, _v in pairs(data) do
		self.attributeNum = - entity:getAttribute()
		self.addExp = - entity:getTotoalExp()
		-- print("self.attributeNum=====>>>>",self.attributeNum)
		entity:update(data[_k])
		self.attributeNum = self.attributeNum + entity:getAttribute()
		self.addExp = self.addExp + entity:getTotoalExp()
		-- print("self.attributeNum=====>>>>",self.attributeNum)
	end

	--将吞掉的合金等级置为-1,并从self.unSelectList删除
	local index = 0
	table.sort(self.upSelectIndx)
	-- print("self.upSelectIndx===>>>>",qy.json.encode(self.upSelectIndx))

	for i = 1, #self.upSelectIndx do
		index = self.upSelectIndx[#self.upSelectIndx + 1 - i]
		self.unSelectList[_aid][index].level = -1
		print("unSelect删除的合金==="..index.."=>>>>>",self.unSelectList[_aid][index].unique_id)
		table.remove(self.unSelectList[_aid],index)
	end

	--删除
	-- print("self.totalAlloyList[_aid]===>>>",#self.totalAlloyList[_aid])
	self.totalAlloyList[_aid] = {}
	for i = 1, #self.unSelectList[_aid] do
		table.insert(self.totalAlloyList[_aid], self.unSelectList[_aid][i])
	end
	for i = 1, #self.selectList[_aid] do
		table.insert(self.totalAlloyList[_aid], self.selectList[_aid][i])
	end
	-- print("self.totalAlloyList[_aid]===>>>",#self.totalAlloyList[_aid])
end

function AlloyModel:getAttributeNameByAlloyId(_aid)
	if _aid == self.ALLOY_ID_1 then
		return qy.TextUtil:substitute(41001)
	elseif _aid == self.ALLOY_ID_2 then
		return qy.TextUtil:substitute(41002)
	else
		return qy.TextUtil:substitute(41003)
	end
end

function AlloyModel:getColorByLevel(_level)
	if _level < 4 then
		--1~3
		return cc.c4b(255, 255, 255, 255)
	elseif _level >= 4 and _level < 7 then
		--4~6
		return cc.c4b(0, 244, 2, 255)
	else
		--7~10
		return cc.c4b(251, 136, 0, 255)
	end
end

--选择吞噬的升级列表选中
function AlloyModel:setUpSelectStatus(_index)
	if self.upSelectIndx == nil then
		self.upSelectIndx = {}
	end
	table.insert(self.upSelectIndx,_index)
end

--去除吞噬的升级列表选中
function AlloyModel:setUpUnselectStatus(_index)
	if self.upSelectIndx then
		for i = 1, #self.upSelectIndx do
			if self.upSelectIndx[i] == _index then
				table.remove(self.upSelectIndx, i)
				return
			end
		end
	end
end

function AlloyModel:getUpSelectStatus()
	if self.upSelectIndx == nil then
		self.upSelectIndx = {}
	end
	return self.upSelectIndx
end

--清除的升级列表选中
function AlloyModel:clearUpSelectStatus()
	self.cloneSelectIdx = clone(self.upSelectIndx)
	self.upSelectIndx = {}
end

--恢复升级列表选中
function AlloyModel:restoreSelectIdx()
	self.upSelectIndx = self.cloneSelectIdx
	self.cloneSelectIdx = {}
end

function AlloyModel:isUpSelect(_index)
	if self.upSelectIndx then
		-- print("index===========>>>>>",_index)
		-- print("self.upSelectIndx=======>>>>>",qy.json.encode(self.upSelectIndx))
		for i = 1, #self.upSelectIndx do
			if self.upSelectIndx[i] == _index then
				return true
			end
		end
	end
	return false
end

function AlloyModel:isAllSelect(_aid)
	if self:getUnSelectNumByIndex(_aid) - #self.upSelectIndx > 0 then
		return false
	else
		return true
	end
end

function AlloyModel:getSelectUpExp(_aid)
	if self.unSelectList[_aid] and self.upSelectIndx then
		local _totalExp = 0
		for i = 1, #self.upSelectIndx do
			_totalExp = _totalExp + self.unSelectList[_aid][self.upSelectIndx[i]]:getTotoalExp()
		end
		return _totalExp
	else
		return 0
	end
end

--选择升级的预计比最大经验多多少，不足负数
function AlloyModel:expExpectMoreMax(entity, _selectExp)
	local _curExp = entity:getTotoalExp()
	local _aid = entity.alloy_id
	if _selectExp == nil then
		_selectExp = self:getSelectUpExp(_aid)
	end
	local total_exp = qy.Config.alloy_level["10"]["total_exp"]
	-- print("total_exp=======>>>>>>",total_exp)
	-- print("_selectExp=======>>>>>>",_selectExp)
	-- print("_curExp=======>>>>>>",_curExp)
	-- print("diff_exp=======>>>>>>",total_exp - _selectExp - _curExp)
	return total_exp - _selectExp - _curExp
end

function AlloyModel:autoSelect(entity)
	local _curExp = entity:getTotoalExp()
	local _aid = entity.alloy_id
	self.upSelectIndx = {}
	if entity.level == self.MAX_Level then
		-- print("已经是最高级合金")
		return
	end

	local data =  self.unSelectList[_aid]
	local diff_exp = qy.Config.alloy_level["10"]["total_exp"] -_curExp
	if diff_exp > 0 and #data > 0 then
		if #data == 1 or diff_exp <= data[#data]:getTotoalExp() then
			-- print("直接选择最后一个=====>>>>"..#data .. "==exp==>>>",data[#data]:getTotoalExp() )
			table.insert(self.upSelectIndx, #data)
		else
			for i = 1, #data do
				if #self.upSelectIndx >= 5 then
					-- print("自动选择=====>>>>>>", qy.json.encode(self.upSelectIndx))
					return
				elseif diff_exp > 0 and diff_exp - data[i]:getTotoalExp() >= 0 then
					table.insert(self.upSelectIndx, i)
					diff_exp = diff_exp - data[i]:getTotoalExp()
				end
			end
			if #self.upSelectIndx == 0 then
				table.insert(self.upSelectIndx, #data)
			end
			-- print("自动选择====2=>>>>>>", qy.json.encode(self.upSelectIndx))
		end
	end
end

function AlloyModel:getSelectUpStr(_aid)
	local _str = ""
	local index = 0
	-- print("#self.upSelectIndx====>>>",#self.upSelectIndx)
	-- print("_aid====>>>",_aid)
	for i = 1, #self.upSelectIndx do
		if _str ~= "" then
			_str = _str .. "|"
		end
		index = self.upSelectIndx[i]
		-- print("index========>>>>",index)
		-- print("self.upSelectIndx["..i.."]====>>>",self.unSelectList[_aid][index].unique_id)
		_str = _str .. self.unSelectList[_aid][index].unique_id
	end
	return _str
end

function AlloyModel:setAddFightPower(_val)
	self.add_fight_power = _val
end

--[[--
--获取增加的属性
--]]
function AlloyModel:getAddAttribute(_aid)
    local allReceive ={}
    local receive = {}
    local _url = ""
    if _aid == self.ALLOY_ID_1 then
    	--攻击
    	_url = qy.ResConfig.IMG_ATTACK
    elseif _aid == self.ALLOY_ID_2 then
    	--防御
    	_url = qy.ResConfig.IMG_DEFENSE
    else
    	--生命值
    	_url = qy.ResConfig.IMG_BLOOD
    end
	local numType = 0
	if self.attributeNum > 0 then
		numType = 4
	else
		numType = 22
	end
    receive = {
        ["value"] = self.attributeNum,
        ["url"] = _url,
        ["type"] = numType,
    }
    table.insert(allReceive, receive)

    --战斗力
    receive = {
        ["value"] = self.add_fight_power,
        ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
        ["type"] = 15,
        ["picType"] = 2,
    }
    table.insert(allReceive, receive)

    return allReceive
end

function AlloyModel:getAddExp()
	if self.addExp then
		return self.addExp
	else
		return 0
	end
end

function AlloyModel:getSelectExpPercent(_entity)
	local _selectExp = self:getSelectUpExp(_entity.alloy_id)
	-- print("_selectExp=====>>>>",_selectExp)
	local _totalExp = qy.Config.alloy_level[tostring(_entity.level)].exp
	-- print("_totalExp=====>>>>",_totalExp)
	-- print("_entity.exp=====>>>>",_entity.exp)
	local _pre = (_entity.exp + _selectExp) / _totalExp
	if _pre >= 1 then
		return 100
	else
		return _pre * 100
	end
end

return AlloyModel
