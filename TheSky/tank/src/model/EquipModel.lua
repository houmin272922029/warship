--[[
    装备 model
    Author: H.X.Sun
    Date: 2015-04-18
]]

local EquipModel = qy.class("EquipModel", qy.tank.model.BaseModel)

local StrongModel = qy.tank.model.StrongModel
local GarageModel = qy.tank.model.GarageModel

EquipModel.TypeNameList = {
    ["1"] = "攻击力",
    ["2"] = "防御力",
    ["3"] = "生命值",
    ["4"] = "穿深",
    ["5"] = "穿深抵抗",
    ["6"] = "命中",
    ["7"] = "闪避",
    ["8"] = "暴击率",
    ["9"] = "暴击率减免",
    ["10"] = "暴击伤害",
    ["11"] = "暴伤减免",
    ["12"] = "伤害加成",
    ["13"] = "伤害减免",
}
--初始化
function EquipModel:init(data)
	self.data = data
	self:updateConstant(data)
	self:initEquipList(data.equip)
	self:initEquipFragment(data.equip_fragment)
	self:initEquipAdvance()
	self:updateFormationEquip()
end

--[[--
--更新装备信息
--]]
-- function EquipModel:updateEquipInfo(data)
-- 	self:updateAllEquipList(data.equip, true)
-- 	self:updateFormationEquip()
-- end

--[[--
--更新装备的计算参数
--]]
function EquipModel:updateConstant(data)
	--装备部件费用系数
	self.equipType = data.constant.equip_type
	--装备品级费用系数
	self.equipQuality = data.constant.equip_quality
	--强化成长系数
	self.equipGrowRatio = data.constant.equip_grow_ratio
	--碎片合成系数
	self.equipComposeNum = data.constant.equip_compose_num
end

--[[
--根据id获取配置
--]]
function EquipModel:getEquipCfgById(equipId)
	local equipCfg = qy.Config.equip
	return equipCfg[tostring(equipId)]
end


function EquipModel:getEquipReformOpenLevel()
	return self.open_table[47].open_level
end


function EquipModel:getEquipAdvanceOpenLevel()
	return self.open_table[48].open_level
end
function EquipModel:getEquipClearOpenLevel()
	return self.open_table[60].open_level
end


--[[
--根据改造等级获取改造消耗信息
--]]
function EquipModel:getEquipReformByLevel(Level)
	local equipCfg = qy.Config.equip_reform_consume
	return equipCfg[tostring(Level)]
end


--[[--
--获取部位名字
--]]
function EquipModel:getComponentName(type)
    if tonumber(type) == 1 then
        return qy.TextUtil:substitute(9011)
    elseif tonumber(type) == 2 then
        return qy.TextUtil:substitute(9012)
    elseif tonumber(type) == 3 then
        return qy.TextUtil:substitute(9013)
    elseif tonumber(type) == 4 then
        return qy.TextUtil:substitute(9014)
    end
end

--[[--
--初始化装备list
--]]
function EquipModel:initEquipList(data)
	self.totalEquipList = {}--总装备
	self.totalEquipList_ = {}
	self.equipList = {}
	for i = 1, 4 do
		--火炮(1) ,炮弹(2),装甲(3),发动机(4)
		self.equipList[i] = {}
	end
	--装备是否需要排序  火炮(1) ,炮弹(2),装甲(3),发动机(4)
	self.isEquipNeedSort = {}

	if data == nil then
		return
	end
	local entity = nil
	--火炮
	if data.gun ~= nil and #data.gun > 0 then
		for i=1,#data.gun do
			entity = qy.tank.entity.EquipEntity.new(data.gun[i])
            table.insert(self.equipList[1], entity)
            table.insert(self.totalEquipList, entity)
           	self.totalEquipList_[tostring(entity.unique_id)] = entity
		end
	end
	--炮弹
	if data.bullet ~= nil and #data.bullet > 0 then
		for i=1,#data.bullet do
			entity = qy.tank.entity.EquipEntity.new(data.bullet[i])
            table.insert(self.equipList[2], entity)
            table.insert(self.totalEquipList, entity)
            self.totalEquipList_[tostring(entity.unique_id)] = entity
		end
	end
	--装甲
	if data.armor ~= nil and #data.armor > 0 then
		for i=1,#data.armor do
			entity = qy.tank.entity.EquipEntity.new(data.armor[i])
    		table.insert(self.equipList[3], entity)
    		table.insert(self.totalEquipList, entity)
    		self.totalEquipList_[tostring(entity.unique_id)] = entity
		end
	end
	--发动机
	if data.engine ~= nil and #data.engine > 0 then
		for i=1,#data.engine do
			entity = qy.tank.entity.EquipEntity.new(data.engine[i])
    		table.insert(self.equipList[4], entity)
    		table.insert(self.totalEquipList, entity)
    		self.totalEquipList_[tostring(entity.unique_id)] = entity
		end
	end
	-- 更新变强数据
	self:updateStrong(data)
	self:sort()
end

function EquipModel:updateStrong(data)
	local i = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        i = i + 1
        if v.id == 6 then
            table.remove(StrongModel.StrongFcList, i)
        end
    end
	local level = qy.tank.model.UserInfoModel.userInfoEntity.level
	local totalLevel = 0
	for k,v in pairs(data) do
		for key,value in pairs(v) do
			if value.expedition_tank_unique_id ~= 0 then
				totalLevel = totalLevel + value.level
			end
		end
	end
	local list = {["id"] = 6 , ["progressNum"] = totalLevel / (level * 2 * 0.6)}
	table.insert(StrongModel.StrongFcList,list)
end

--[[--
--初始化装备碎片列表
--@param #table data 服务器数据
--]]
function EquipModel:initEquipFragment(data)
	self.fragmentList = {}
	local entity  = nil
	for i = 1, #data do
		entity = qy.tank.entity.EquipEntity.new(data[i])
		table.insert(self.fragmentList, entity)
	end

	self:__sortEquip(self.fragmentList)
end

function EquipModel:sortFragment()
	self:__sortEquip(self.fragmentList)
end


function EquipModel:reformCanUp(entity)
	if entity.tank_unique_id <= 0 then
		return false
	end

	local userInfoModel =  qy.tank.model.UserInfoModel

	if self:getEquipReformByLevel(entity.reform_level).sum_exp > 0 and 
		self:getEquipReformByLevel(entity.reform_level).sum_exp - entity.reform_essence <= userInfoModel.userInfoEntity.ceramics_armor and 
		self:getEquipReformByLevel(entity.reform_level).sum_silver - entity.reform_silver <= userInfoModel.userInfoEntity.silver and 
		userInfoModel.userInfoEntity.level >= self:getEquipReformOpenLevel() then
		return true
	end
	return false
end


--[[--
--初始化阵型装备
--]]
function EquipModel:updateFormationEquip()
	self.formationEquip = {}
	local tankEquipEntity = {}

	local formation = qy.tank.model.GarageModel.formation
	for i = 1, 6 do
		local formationData = {}
		if formation[i] ~= 0 and formation[i] ~= -1 then
			formationData.tankEquipEntity = formation[i]:getEquipEntity()
			formationData.tankUid = formation[i].unique_id
		else
			formationData.tankEquipEntity = nil
			formationData.tankUid = -1
		end
		table.insert(self.formationEquip, formationData)
	end
	-- print("####self.formationEquip===" .. #self.formationEquip)
end

--[[--
--更新阵型装备
--@param #table formation 阵型数据
--]]
-- function EquipModel:updateFromatEquip(formation)
-- 	local newFormationEquip = {}
-- 	local newDataSet = false
-- 	for i=1, 6 do
-- 		for j = 1, 6 do
-- 			if self.formationEquip[j].tankUid == formation[i] then
-- 				--以前的阵型中存在现在阵型的坦克
-- 				newFormationEquip[i] = self.formationEquip[j]
-- 				newDataSet = true
-- 				break
-- 			end
-- 		end
-- 		if not newDataSet then
-- 			--新上阵的坦克，更改阵型装备的数据
-- 			newDataSet = false
-- 			newFormationEquip[i] = self.formationEquip[i]
-- 			newFormationEquip[i].tankUid = formation["p_"..i]
-- 		end
-- 	end
-- end

--[[--
--更新坦克阵型的装备数据
--]]
function EquipModel:updateTankFormation()


end

--[[--
--装载/卸下装备
--@param #table data 服务器数据
--]]
function EquipModel:loadEquip(data, componentName)
	self:updateAllEquipList(data.equip, true)
	self:updateFormationEquip()
end

function EquipModel:updateAllEquipList(data, isSort)
	for _k, _v in pairs(data) do
		self:updateEquipList(data[_k], self:getTypeByComponentName(_k), isSort)
	end
	if isSort then
		self:__sortEquip(self.totalEquipList)
	end
end

--[[--
--改变坦克的装备然后排序
--]]
function EquipModel:updateEquipList(data,nType, isSort)
	local entity = nil
	for _k, _v in pairs(data) do
		entity = self:getEntityByTypeAndUid(nType, data[_k].unique_id)
		entity:update(data[_k])
	end
	if isSort then
		self:__sortEquip(self.equipList[nType])
	else
		self.isEquipNeedSort[nType] = true
	end
end

function EquipModel:_changeDataByStrength(data)
	self.isCrit = data.is_crit
	self.addLevel = data.add_level
	self:updateAllEquipList(data.equip, false)
end

--[[--
--强化装备
--]]
function EquipModel:strengthenEquip(data, componentName, uniqueId)
	local _type = self:getTypeByComponentName(componentName)
	local equipEntity = self:getEntityByTypeAndUid(_type, uniqueId)
	-- if equipEntity.tank_unique_id == 0 then
		--没有装载的装备
	self.addAttribute = {}
	self.addAttribute.attack = 0
	self.addAttribute.defense = 0
	self.addAttribute.blood = 0
	self.addAttribute.fightPower = data.add_fight_power
	local oldAttribute = equipEntity:getProperty()

	if data.unset_equip and data.unset_equip[1] then
		print("data.unset_equip[1]data.unset_equip[1]data.unset_equip[1]", data.unset_equip[1])
		self:remove(1, data.unset_equip[1])
	end

	-- print("没装载的装备属性 oldAttribute===" .. oldAttribute)
	self:_changeDataByStrength(data)
	local newAttribute = equipEntity:getProperty()
	-- print("没装载的装备属性 newAttribute===" .. newAttribute)
	if _type == 1 or _type == 2 then
		self.addAttribute.attack = newAttribute - oldAttribute
	elseif _type == 3 then
		self.addAttribute.defense = newAttribute - oldAttribute
	elseif _type == 4 then
		self.addAttribute.blood = newAttribute - oldAttribute
	end


	-- elseif equipEntity.tank_unique_id > 0 then
		--已经装载的装备
  		-- self:getOldAttribute(qy.tank.model.GarageModel:getEntityByUniqueID(equipEntity.tank_unique_id))
  		-- self:_changeDataByStrength(data)
        -- self:calculateAddAttributeValues(qy.tank.model.GarageModel:getEntityByUniqueID(equipEntity.tank_unique_id), data.add_fight_power)
    -- end
end


--[[--
--更新排序
--]]
function EquipModel:sortEquipList(componentName)
	local isTotalListNeedSort = false
	for key, var in pairs(self.isEquipNeedSort) do
		if self.isEquipNeedSort[key] then
			self:__sortEquip(self.equipList[tonumber(key)])
			isTotalListNeedSort = true
		end
	end
	if isTotalListNeedSort then
		self.isEquipNeedSort = {}
		self:__sortEquip(self.totalEquipList)
	end
end

--[[--
--是否暴击
--]]
function EquipModel:isStrengthenCrit()
	if self.isCrit == 1 then
		return true
	else
		return false
	end
end

--[[--
--强化提示等级
--]]
function EquipModel:getStrengthenAddLevel()
	return self.addLevel
end

--[[--
--排序
--]]
function EquipModel:sort()
	for i = 1, 4 do
		if self.equipList[i] and #self.equipList[i] > 0 then
			self:__sortEquip(self.equipList[i])
		end
	end
	self:__sortEquip(self.totalEquipList)
end

function EquipModel:__sortEquip(arr)
	table.sort(arr,function(a,b)
		if tonumber(a:isLoad()) == tonumber(b:isLoad()) then
			if tonumber(a:getQuality()) == tonumber(b:getQuality()) then
				if tonumber(a.advanced_level) == tonumber(b.advanced_level) then
					if tonumber(a.level) == tonumber(b.level) then
						if tonumber(a.reform_level) == tonumber(b.reform_level) then
							if tonumber(a.equip_id) == tonumber(b.equip_id) then
								return false
							else
								-- 按ID
								return tonumber(a.equip_id) > tonumber(b.equip_id)
							end
						else
							-- 按改造
							return tonumber(a.reform_level) > tonumber(b.reform_level)
						end
					else
						-- 按等级
						return tonumber(a.level) > tonumber(b.level)
					end	
				else
					-- 按进阶
					return tonumber(a.advanced_level) > tonumber(b.advanced_level)
				end	
			else
				-- 按品质
				return tonumber(a:getQuality()) > tonumber(b:getQuality())
			end
		else
			--是否穿戴
			return tonumber(a:isLoad()) > tonumber(b:isLoad())
		end
	end)
	return arr
end

--[[--
--根据装备type和装备唯一ID，获取该装备的实体
--@param #number nType 部件类型 1:(gun)火炮 2:(bullet)炮弹 3:(armor)装甲 4:(engine)发动机
--@param #number uid 装备唯一ID
--@return table 装备的实体
--]]
function EquipModel:getEntityByTypeAndUid(nType, uid)
	if nType then
		for i = 1,  #self.equipList[nType] do
			if self.equipList[nType][i].unique_id == uid then
				return self.equipList[nType][i]
			end
		end
	else
		for i = 1,  #self.totalEquipList do
			if self.totalEquipList[i].unique_id == uid then
				return self.totalEquipList[i]
			end
		end
	end
	return -1
end

--[[--
--根据坦克Uid获取阵位装备
--]]
function EquipModel:getFormationEquipByTankUid(tankUid)
	for i = 1, 6 do
		if self.formationEquip[i].tankUid == tankUid then
			return self.formationEquip[i].tankEquipEntity
		end
	end
end

--[[--
--根据阵位Idx获取阵位装备
--]]
function EquipModel:getFormationEquipByIndex(idx)
	if idx < 7 then
		return self.formationEquip[idx].tankEquipEntity
	else
		return nil
	end
end

--[[--
--根据部件名称获取type
--]]
function EquipModel:getTypeByComponentName(componentName)
	if componentName == "gun" then
		--火炮
		return 1
	elseif componentName == "bullet" then
		--炮弹
		return 2
	elseif componentName == "armor" then
		--装甲
		return 3
	elseif componentName == "engine" then
		--发动机
		return 4
	else
		return nil
	end
end

--[[--
--获取第一个空闲的装备
--]]
function EquipModel:getFirstFreeEquip(nType)
	for i = 1, #self.equipList[nType] do
		if self.equipList[nType][i]:isLoad() == 0 then
			return self.equipList[nType][i]
		end
	end
	return nil

end

--[[--
--获取可分解装备列表( 用于 分解)
--]]
function EquipModel:getFreeList()
	local list = {}
	for i, v in pairs(self.totalEquipList) do
		if v:isLoad() == 0 then
			-- if v:getQuality() >=3 and v.level == 1 then
			-- 	-- 蓝色以上品质 1 级 时不能分解
			-- else
			-- 	table.insert(list, v)
			-- end
			table.insert(list, v)
		end
	end
	return list
end

--[[--
--获取一键装备数据
--]]
function EquipModel:getEquipmentData(tankUid)
	local tankEquipEntity = self:getFormationEquipByTankUid(tankUid)
	local equipIdTable = {}
	if tankEquipEntity == nil then
		return{0, 0, 0, 0}
	end

	local entity = nil
	for i = 1, 4 do
		entity = self:getFirstFreeEquip(i)
		if tankEquipEntity[i] == -1 then
			--没有装载
			if entity then
				equipIdTable[i] = entity.unique_id
			else
				equipIdTable[i] = 0
			end
		else
			--已装载
			if self:isFirstPrioritySecond(tankEquipEntity[i], entity) then
				--不用更换
				equipIdTable[i] = 0
			else
				--更换空闲的
				equipIdTable[i] = entity.unique_id
			end
		end
	end
	return equipIdTable
end

--[[--
--比较第一个实体是否排先与第二个
--]]
function EquipModel:isFirstPrioritySecond(entity1, entity2)
	if entity2 == nil then
		return true
	end
	if entity1 == nil then
		return false
	end
	if entity1:getProperty() > entity2:getProperty() then
		return true
	elseif entity1:getQuality() < entity2:getQuality() then
		return false
	elseif entity1.level > entity2.level then
		return true
	elseif entity1.level < entity2.level then
		return false
	elseif entity1.equip_id >= entity2.equip_id then
		return true
	else
		return false
	end
end

--[[--
--进阶等级描述
--]]
function EquipModel:getReformLevelName(level)
    if level <= 10 then
        return qy.TextUtil:substitute(90264)
    elseif level <= 20 then
        return qy.TextUtil:substitute(90265)
    elseif level <= 30 then
        return qy.TextUtil:substitute(90266)
    elseif level <= 40 then
        return qy.TextUtil:substitute(90267)
    elseif level <= 50 then
        return qy.TextUtil:substitute(90268)
    else
        return qy.TextUtil:substitute(90269)
    end
end



--[[--
--获取套装奖励
--]]
function EquipModel:getSuitReward(suitId)
	local equipSuit = qy.Config.equip_suit[suitId .. ""]
	local suitReward = {}
	local skillName = {qy.TextUtil:substitute(9018), qy.TextUtil:substitute(9019), qy.TextUtil:substitute(9020), qy.TextUtil:substitute(9021),qy.TextUtil:substitute(8036),qy.TextUtil:substitute(8037)}

	for i = 1, 3 do
		local suit = {}
		local title = equipSuit["condition" .. i] .. ":"
		table.insert(suit, title)
		local param1 = skillName[equipSuit["type_"..i .."_1"]] .. "+" .. equipSuit["param_"..i .."_1"]
		table.insert(suit, param1)
		local param2 = skillName[equipSuit["type_"..i .."_2"]] .. "+" .. equipSuit["param_"..i .."_2"]
		table.insert(suit, param2)
		if equipSuit["type_"..i .."_3"] ~= nil then
			local param3 = skillName[equipSuit["type_"..i .."_3"]] .. "+" .. equipSuit["param_"..i .."_3"]
			table.insert(suit, param3)
        end

		if equipSuit["type_"..i .."_4"] ~= nil then
			local param4 = skillName[equipSuit["type_"..i .."_4"]] .. "+" .. (equipSuit["param_"..i .."_4"] / 10 ) .. "%"
			table.insert(suit, param4)
		end

		if equipSuit["type_"..i .."_5"] ~= nil and equipSuit["type_"..i .."_5"] >0 then
			local param5 = skillName[equipSuit["type_"..i .."_5"]] .. "+" .. (equipSuit["param_"..i .."_5"] / 10 ) .. "%"
			table.insert(suit, param5)
        end

		if equipSuit["type_"..i .."_6"] ~= nil and equipSuit["type_"..i .."_6"] >0 then
			local param6 = skillName[equipSuit["type_"..i .."_6"]] .. "+" .. (equipSuit["param_"..i .."_6"] / 10 ) .. "%"
			table.insert(suit, param6)
		end
		table.insert(suitReward, suit)
    end
	return suitReward
end

function EquipModel:hasSixProper(suitId)
	if suitId == 8 then
		return true
	else
		return false
	end
end

--获取当前装备套装的4个装备中自己获得几个
function EquipModel:getCurrentEquipSuitNum(suitId,tankUid)
	if tankUid > 0 then
		local num = 0
		local equipSuit = qy.Config.equip_suit[suitId .. ""]
		local equipEntityList = GarageModel:getEntityByUniqueID(tankUid):getEquipEntityList()
		for i = 1, 4 do
			if type(equipEntityList[i]) == "table" and equipEntityList[i].equip_id == equipSuit["equip_id"..i] then
				num = num + 1
			end
		end
		return num
	else
		return 0
	end
end

--[[--
--获取套装增加的属性(布阵阵型)
gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
--]]
function EquipModel:getAddSuitPropertyByTankUid(nTankUid)
	if nTankUid == nil then
		return {["attack"] = 0 ,["defense"] = 0, ["blood"] = 0, ["crit"] = 0,["hit"] = 0, ["dodge"] = 0}
	else
		local equipEntity = self:getFormationEquipByTankUid(nTankUid)
		--return self:__getTankPropertyByEquip(equipEntity)
		-- return self:__getTankPropertyByEquipAll(equipEntity)
		return self:__getTankPropertyByEquipAllandClear(equipEntity)
	end
end

--[[--
--获取远征坦克装备增加的属性
--]]
function EquipModel:getExpeditionEquipProperty(nTankUid)
	local entity = qy.tank.model.GarageModel:getEntityByUniqueID(nTankUid)
	--print("===============远征坦克唯一ID ===================="..nTankUid.."=======================")
	--print("===============远征坦克名字 ===================="..entity.name.."=======================")
	local equipEntity = entity:getExpeditionEquipEntity()
	return self:__getTankPropertyByEquip(equipEntity)
end


--[[--
--此函数以在下面__getTankPropertyByEquipALl的基础上 再计算装备洗练的属性加成
--]]
function EquipModel:__getTankPropertyByEquipAllandClear(equipEntity)
	local data = self:__getTankPropertyByEquipAll(equipEntity)

	if equipEntity == nil then
		return data
	end

	for i = 1, 4 do
		local aa = i
		if equipEntity[i] ~= -1 and equipEntity[i]:getQuality() > 4 then
   			local entity = equipEntity[i]
   			local attrdata = entity.addition_attr
   			for i=1,#attrdata do
   				print("========",json.encode(attrdata[i]))
   				local specailData = attrdata[i]
   				local _type
				if specailData.id == 1 then
					_type = "attack"
				elseif specailData.id == 2 then
					_type = "defense"
				elseif specailData.id == 3 then
					_type = "blood"
				elseif specailData.id == 8 then
					_type = "crit"
				elseif specailData.id == 7 then
					_type = "dodge"
				elseif specailData.id == 6 then
					_type = "hit"
				elseif specailData.id == 9 then
					_type = "crit_reduction"
				else
					_type = specailData.id
				end
				if specailData.id == 12 or specailData.id == 13 or specailData.id == 14 then
				else
					if not data[tostring(_type)] then
						data[tostring(_type)] = specailData.num
					elseif data[tostring(_type)] then
						data[tostring(_type)] = data[tostring(_type)] + specailData.num
					end	
				end		
   			end
		end
	end

	return data
end

--[[--
--此函数以在下面__getTankPropertyByEquip的基础上 再计算装备进阶的属性加成
--]]
function EquipModel:__getTankPropertyByEquipAll(equipEntity)
	local data = self:__getTankPropertyByEquip(equipEntity)

	if equipEntity == nil then
		return data
	end

	for i = 1, 4 do
		local aa = i
		if equipEntity[i] ~= -1 and equipEntity[i]:getQuality() > 4 then
   			local entity = equipEntity[i]
			for i = 1, entity.advanced_level > self:getMaxLevel(entity) and self:getMaxLevel(entity) or entity.advanced_level do
				local specailData = self:atSpecailByLevel(entity, i)
				-- print("===========11111",json.encode(specailData))
				local _type
				if specailData.type == 1 then
					_type = "attack"
				elseif specailData.type == 2 then
					_type = "defense"
				elseif specailData.type == 3 then
					_type = "blood"
				elseif specailData.type == 8 then
					_type = "crit"
				elseif specailData.type == 7 then
					_type = "dodge"
				elseif specailData.type == 6 then
					_type = "hit"
				else
					_type = specailData.type
				end
				--这么做的原因是原写法的6条属性不动，新加的属性type类型与坦克进阶统一
				if specailData.type == 12 or specailData.type == 13 or specailData.type == 14 then
					if not data[tostring(_type)] then
						data[tostring(_type)] = {}
						data[tostring(_type)][tostring(aa)] = specailData.param
					else
						data[tostring(_type)][tostring(aa)] = specailData.param
					end
				else
					if not data[tostring(_type)] then
						data[tostring(_type)] = specailData.param
					elseif data[tostring(_type)] then
						data[tostring(_type)] = data[tostring(_type)] + specailData.param
					end	
				end			
			end
		end
	end

	return data
end



--[[--
--根据坦克的装备获取坦克增加的属性
--]]
function EquipModel:__getTankPropertyByEquip(equipEntity)
	local addProperty = {["attack"] = 0 ,["defense"] = 0, ["blood"] = 0, ["crit"] = 0,["hit"] = 0, ["dodge"] = 0, }

	if equipEntity == nil then
		return addProperty
	end

	local suitIdTable = {}
	for i = 1, 4 do
		if equipEntity[i] ~= -1 then
			if i == 1 or i == 2 then
				addProperty["attack"] = addProperty["attack"] + equipEntity[i]:getProperty()
			elseif i == 3 then
				addProperty["defense"] = addProperty["defense"] + equipEntity[i]:getProperty()
			elseif i == 4 then
				addProperty["blood"] = addProperty["blood"] + equipEntity[i]:getProperty()
			end

			local arr = equipEntity[i]:getAlloyAttribute()
			-- print("arr =====>>>>>>>>>>>>>>>>>>>>>equipEntity uid===" ..equipEntity[i].unique_id ..  ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",qy.json.encode(arr))
			-- print("addProperty attack=====>>>>>>>>>equipEntity uid===" ..equipEntity[i].unique_id ..  ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",addProperty["attack"])
			addProperty["attack"] = addProperty["attack"] + arr["attack"]
			-- print("addProperty attack=====>>>>>>>>>>>equipEntity uid===" ..equipEntity[i].unique_id ..  ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",addProperty["attack"])
			addProperty["defense"] = addProperty["defense"] + arr["defense"]
			addProperty["blood"] = addProperty["blood"] + arr["blood"]
			local suitId = equipEntity[i]:getSuitID()
            if suitId > 0 then
                if suitIdTable[suitId] == nil then
                    suitIdTable[suitId] = 1
                else
                    suitIdTable[suitId] = suitIdTable[suitId] + 1
                end
            end
		end

	end

    local equipSuit = qy.Config.equip_suit
	for key, var in pairs(suitIdTable) do
		if suitIdTable[key] >= 4 then
			self:addProValue(equipSuit[key ..""]["type_3_1"],equipSuit[key ..""]["param_3_1"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_3_2"],equipSuit[key ..""]["param_3_2"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_3_3"],equipSuit[key ..""]["param_3_3"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_3_4"],equipSuit[key ..""]["param_3_4"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_3_5"],equipSuit[key ..""]["param_3_5"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_3_6"],equipSuit[key ..""]["param_3_6"],addProperty)

			-- addProperty["attack"] = addProperty["attack"] + equipSuit[key ..""]["param_3_1"]
			-- --print("套装 ===" .. key .."===attack=param_3_1=" .. equipSuit[key ..""]["param_3_1"])
			-- addProperty["defense"] = addProperty["defense"] + equipSuit[key ..""]["param_3_2"]
			-- --print("套装 ===" .. key .."===defense=param_3_2=" .. equipSuit[key ..""]["param_3_2"])
			-- addProperty["blood"] = addProperty["blood"] + equipSuit[key ..""]["param_3_3"]
			-- --print("套装 ===" .. key .."===blood=param_3_3=" .. equipSuit[key ..""]["param_3_3"])
			-- addProperty["crit"] = addProperty["crit"] + equipSuit[key ..""]["param_3_4"]
 		-- 	--print("套装 ===" .. key .."===crit=param_3_4=" .. equipSuit[key ..""]["param_3_4"])
			-- addProperty["hit"] = addProperty["hit"] + equipSuit[key ..""]["param_3_5"]
			-- -- print("套装 ===" .. key .."===hit=param_3_5=" .. equipSuit[key ..""]["param_3_5"])
			-- addProperty["dodge"] = addProperty["dodge"] + equipSuit[key ..""]["param_3_6"]
			-- print("套装 ===" .. key .."===dodge=param_3_6=" .. equipSuit[key ..""]["param_3_6"])
		end
		if suitIdTable[key] >= 3 then
			self:addProValue(equipSuit[key ..""]["type_2_1"],equipSuit[key ..""]["param_2_1"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_2_2"],equipSuit[key ..""]["param_2_2"],addProperty)
			-- addProperty["attack"] = addProperty["attack"] + equipSuit[key ..""]["param_2_1"]
			--print("套装 ===" .. key .."===attack=param_2_1=" .. equipSuit[key ..""]["param_2_1"])
			-- addProperty["blood"] = addProperty["blood"] + equipSuit[key ..""]["param_2_2"]
			--print("套装 ===" .. key .."===blood=param_2_2=" .. equipSuit[key ..""]["param_2_2"])
		end
		if suitIdTable[key] >= 2 then
			self:addProValue(equipSuit[key ..""]["type_1_1"],equipSuit[key ..""]["param_1_1"],addProperty)
			self:addProValue(equipSuit[key ..""]["type_1_2"],equipSuit[key ..""]["param_1_2"],addProperty)
			-- addProperty["attack"] = addProperty["attack"] + equipSuit[key ..""]["param_1_1"]
			--print("套装 ===" .. key .."===attack=param_1_1=" .. equipSuit[key ..""]["param_1_1"])
			-- addProperty["defense"] = addProperty["defense"] + equipSuit[key ..""]["param_1_2"]
			--print("套装 ===" .. key .."===defense=param_1_2=" .. equipSuit[key ..""]["param_1_2"])
		end
	end
	addProperty["crit"] = addProperty["crit"]

	print("总 ==attack=" .. addProperty.attack .."===defense==" .. addProperty.defense .. "==blood=" ..addProperty.blood .. "===crit=" ..addProperty.crit.."===hit=" ..addProperty.hit.."===dodge=" ..addProperty.dodge)
	return addProperty
end

function EquipModel:addProValue(idx,value,arr)
	if idx == 1 then
		arr["attack"] = arr["attack"] + value
	elseif idx == 2 then
		arr["defense"] = arr["defense"] + value
	elseif idx == 3 then
		arr["blood"] = arr["blood"] + value
	elseif idx == 4 then
		arr["crit"] = arr["crit"] + value
	elseif idx == 5 then
		arr["hit"] = arr["hit"] + value
	elseif idx == 6 then
		arr["dodge"] = arr["dodge"] + value
	end
end

--[[--
--获取装备列表的长度
--@param #string componentName 部件 gun: 火炮; bullet:炮弹; armor：装甲; engine：发动机; total: 总的装备
--]]
function EquipModel:getEquipListLength(componentName)
	local nType = self:getTypeByComponentName(componentName)
	if nType then
		return #self.equipList[nType]
	else
		return #self.totalEquipList + #self.fragmentList
	end
end

--[[--
--根据类型和获取装备实体
--@param #string sType 类型 gun: 火炮; bullet:炮弹; armor：装甲; engine：发动机; total: 总的装备
--@param #number idx 对应的下标
self.firstEquipTankUid
--]]
function EquipModel:getEquipEntity(componentName, idx)
	local nType = self:getTypeByComponentName(componentName)
	if nType then
		local firsIndex = self:getIndxByFirstEquipTankUid(self.equipList[nType])
		if firsIndex > 1 then
			if idx == 1 then
				return self.equipList[nType][firsIndex]
			elseif idx > firsIndex then
				return self.equipList[nType][idx]
			else
				return self.equipList[nType][idx - 1]
			end
		else
			return self.equipList[nType][idx]
		end
	else
		if idx > #self.totalEquipList then
			return self.fragmentList[idx - #self.totalEquipList]
		else
			return self.totalEquipList[idx]
		end
	end
end



function EquipModel:getEquipEntityByUniqueId(unique_id, _type)
	local nType = self:getTypeByComponentName(componentName)

	if nType then
		for i = 1, #self.equipList[nType] do
			if self.equipList[nType][i].unique_id == unique_id then
				return self.equipList[nType][i]
			end
		end
	else
		for i = 1, #self.totalEquipList do
			if self.totalEquipList[i].unique_id == unique_id then
				return self.totalEquipList[i]
			end
		end
	end

	return nil
end



--[[--
--根据装备id与唯一id获取同样的除它以外的未上阵的装备实体集合 
--]]
function EquipModel:getNoUseEquipEntity(equipEntity)
	local equip_id = equipEntity.equip_id
	local unique_id = equipEntity.unique_id

	local cfg = self:getEquipCfgById(equip_id)

	local equip_table = {}

	if cfg and cfg.type then
		for i = 1, #self.equipList[cfg.type] do
			if self.equipList[cfg.type][i].equip_id == equip_id and self.equipList[cfg.type][i].unique_id ~= unique_id and self.equipList[cfg.type][i].tank_unique_id <= 0 then
				table.insert(equip_table, self.equipList[cfg.type][i])
			end
		end
	end

	return equip_table
end


--[[--
--根据type和uid,删除装备
--]]
function EquipModel:getIndexByUidAndType(uid, nType)
	if nType then
		for i = 1,  #self.equipList[nType] do
			if self.equipList[nType][i].unique_id == uid then
				return i
			end
		end
	else
		for i = 1,  #self.totalEquipList do
			if self.totalEquipList[i].unique_id == uid then
				return i
			end
		end
	end

	return -1
end

--[[--
--获取当前坦克的装备
--]]
function EquipModel:getIndxByFirstEquipTankUid(equipList)
	for i = 1, #equipList do
		if equipList[i].tank_unique_id == self.firstEquipTankUid then
			return i
		end
	end
	return 1
end

--[[--
--设置当前装备的坦克ID
--@param #number id 当前装备的坦克ID
--]]
function EquipModel:setFirstEquipTankUid(id)
	self.firstEquipTankUid = id
end

--[[--
--获取当前装备的坦克ID
--]]
function EquipModel:getFirstEquipTankUid()
	return self.firstEquipTankUid
end

--[[--
--根据部件类型获取部件系数
--@param #string componentName 部件 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
--@return #number 部件系数
--]]
function EquipModel:getEquipTypeByType(componentName)
	if self.equipType[componentName] ~= nil then
		return self.equipType[componentName]
	else
		return 0
	end
end

--[[--
--获取碎片合成系数
--]]
function EquipModel:getEquipComposeNum(key)
	if self.equipComposeNum[key]  == nil then
		return -1
	else
		return self.equipComposeNum[key]
	end
end

--[[--
--根据部件类型获取装备品级费用系数
--@param #number nQuality 当前品质
--@return #number 装备品级费用系数
--]]
function EquipModel:getEquipQualityByQuality(nQuality)
	if self.equipQuality[nQuality .. ""] ~= nil then
		return self.equipQuality[nQuality .. ""]
	else
		return 1
	end
end

--[[--
--根据部件类型获取强化成长系数
--@param #string componentName 部件 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
--@param #number nQuality 当前品质
--@return #number 强化成长系数
--]]
function EquipModel:getEquipGrowRatioByTypeAndQuality(componentName, nQuality)
	if self.equipGrowRatio[componentName] ~= nil then
		return self.equipGrowRatio[componentName][nQuality .. ""] or 1
	else
		return 0
	end
end

--[[--
--根据套装ID, 获取套装的装备ID
--]]
function EquipModel:getSuitEquipBySuitId(suitId)
	local equipSuit = qy.Config.equip_suit[suitId .. ""]
	local suitEquip = {}
	local entity = nil
	for i = 1, 4 do
		entity = qy.tank.entity.EquipEntity.new(equipSuit["equip_id" .. i])
		table.insert(suitEquip, entity)
	end
	return suitEquip
end

--[[--
--获取装备碎片实体
--]]
function EquipModel:getFragmentEntityByEquipId(equipId)
	for i = 1, #self.fragmentList do
		if self.fragmentList[i].equip_id == equipId then
			return self.fragmentList[i], i
		end
	end
	return nil, nil
end

--[[--
--根据装备碎片ID，获取装备碎片index
--]]
function EquipModel:getFragmentIndexByEquipId(equipId)
	for i = 1, #self.fragmentList do
		if self.fragmentList[i].unique_id == equipId then
			return i
		end
	end
	return -1
end

--[[--
--根据装备类型和装备唯一ID，获取该装备的idx
--@param #string sType 类型 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
--@param #number uid 装备唯一ID
--@return table idx
--]]
function EquipModel:getIdxByTypeAndUid(componentName, uid)
	local nType = self:getTypeByComponentName(componentName)
	local data = nil
	if nType then
		data = self.equipList[nType]
	else
		data = self.totalEquipList
	end
	for i = 1, #data do
		if data[i].unique_id == uid then
			return i
		else
			return -1
		end
	end
end

--[[--
--增加装备对象
--@paran #table equip 服务器的装备数据
--装备:{"unique_id":13,"equip_id":1,"level":1,"tank_unique_id":0,"silver":0}
--碎片: {"equip_id":1,"num":1}
--@paran #number genre 类型 1：增加装备, 2：增加碎片
--@return entity
--]]
function EquipModel:add(equip, genre)
	local entity = nil
	if genre == 1 then
		--增加装备
		entity = qy.tank.entity.EquipEntity.new(equip)
		table.insert(self.totalEquipList, entity)
		table.insert(self.equipList[entity:getType()], entity)
	else
		--增加碎片
		entity,idx = self:getFragmentEntityByEquipId(equip.equip_id)
		if entity then
			entity.num_:set(entity.num + equip.num)
			--由于碎片合成装备造成碎片数量为0，所以要把这些为0的碎片清理
			if entity.num == 0 then
				table.remove(self.fragmentList,idx)
			end
		else
			entity = qy.tank.entity.EquipEntity.new(equip)
			table.insert(self.fragmentList, entity)
		end
	end
	return entity
end

--[[--
--移除装备或碎片
--@paran #number genre类型 1：增加装备, 2：增加碎片
--@param #number 删除装备：装备唯一ID； 删除碎片：装备ID
--@param #num 数量
--]]
function EquipModel:remove(genre, id,num)
	local entity = nil
	if genre == 1 then
		--删除装备
		local indexInTotal = self:getIndexByUidAndType(id)

		entity = self.totalEquipList[indexInTotal]
		if indexInTotal > 0 then
			table.remove(self.totalEquipList, indexInTotal)
		end

		local index = self:getIndexByUidAndType(id, entity:getType())
		if index > 0 then
			table.remove(self.equipList[entity:getType()], index)
		end
	else
		--删除碎片
		local index = self:getFragmentIndexByEquipId(id)
		if index > 0 then
			if self.fragmentList[index].num - num > 0 then
				self.fragmentList[index].num_:set(self.fragmentList[index].num - num)
			else
				table.remove(self.fragmentList, index)
			end
		end
	end
end

--由于碎片合成装备造成碎片数量为0，所以要把这些为0的碎片清理
-- function EquipModel:removeZeroFragmentEntity()
-- 	for i = 1, #self.fragmentList do
--
-- 	end
-- end

--[[--
--获取增加的属性
--]]
function EquipModel:getAddAttribute()
	local _aData ={}
	local _data = {}

	if self.addAttribute.attack ~= 0 then
		local numType = 0
		if self.addAttribute.attack > 0 then
			numType = 4
		else
			numType = 22
		end
    	_data = {
        	["value"] = self.addAttribute.attack,
            ["url"] = qy.ResConfig.IMG_ATTACK,
            ["type"] = numType,
       	 }
        table.insert(_aData, _data)
    end

    if self.addAttribute.defense ~= 0 then
		local numType = 0
		if self.addAttribute.defense > 0 then
			numType = 4
		else
			numType = 22
		end
        _data = {
            ["value"] = self.addAttribute.defense,
            ["url"] = qy.ResConfig.IMG_DEFENSE,
            ["type"] = numType,
       	 }
        table.insert(_aData, _data)
    end

    if self.addAttribute.blood ~= 0 then
		local numType = 0
		if self.addAttribute.blood > 0 then
			numType = 4
		else
			numType = 22
		end
        _data = {
            ["value"] = self.addAttribute.blood,
            ["url"] = qy.ResConfig.IMG_BLOOD,
            ["type"] = numType,
       	 }
        table.insert(_aData, _data)
    end

    if self.addAttribute.fightPower then
		local numType = 0
		if self.addAttribute.fightPower > 0 then
			numType = 15
		else
			numType = 14
		end
        _data = {
        ["value"] = self.addAttribute.fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
       	 }
        table.insert(_aData, _data)
    	end

    	self.addAttribute = {}

    	return _aData
end

function EquipModel:getOldAttribute(_oldEntity)
	self.addAttribute = {}
	self.addAttribute.attack = _oldEntity:getTotalAttack()
	self.addAttribute.defense = _oldEntity:getTotalDefense()
	self.addAttribute.blood = _oldEntity:getTotalBlood()
end

--[[--
--计算装载装备增加的属性
--]]
function EquipModel:calculateAddAttributeValues(_newEntity , _fightPower)
	print("新的 attack====" .. _newEntity:getTotalAttack())
	print("旧的 attack====" .. self.addAttribute.attack)

	print("新的 attack====" .. _newEntity:getTotalDefense())
	print("旧的 defense====" .. self.addAttribute.defense)

	print("新的 attack====" .. _newEntity:getTotalBlood())
	print("旧的 blood====" .. self.addAttribute.blood)

	self.addAttribute.attack = _newEntity:getTotalAttack() - self.addAttribute.attack
	self.addAttribute.defense = _newEntity:getTotalDefense() - self.addAttribute.defense
	self.addAttribute.blood = _newEntity:getTotalBlood() - self.addAttribute.blood
	self.addAttribute.fightPower = _fightPower
end

-- 删除分解的装备
function EquipModel:removeResolveList(data)
	for i, v in pairs(data) do
		self:remove(1, v)
	end
end

-- 更新不可分解的装备
function EquipModel:updateResolveList(data)
	for i, v in pairs(data) do
		if self.totalEquipList_[tostring(v.uniqueId)] then
			self.totalEquipList_[tostring(v.uniqueId)].level = v.level
		end
	end
end





--初始化
function EquipModel:initEquipAdvance()
	self.growUpList = qy.Config.equip_advanced --装备进阶模板表
	self.specialAttr = qy.Config.equip_advanced_attr --进阶详细属性表
	self.advancedConsume = qy.Config.equip_advanced_consume --消耗


	self.open_table = {}
    local staticData = qy.Config.gongneng_open
    for i, v in pairs(staticData) do
        table.insert(self.open_table, v)
    end

    table.sort(self.open_table,function(a,b)
     return tonumber(a.id) < tonumber(b.id)
    end)

end


EquipModel.attrTypes = {
	["1"] = qy.TextUtil:substitute(3008),
	["2"] = qy.TextUtil:substitute(3009),
	["3"] = qy.TextUtil:substitute(3010),
	["4"] = qy.TextUtil:substitute(3011),
	["5"] = qy.TextUtil:substitute(3012),
	["6"] = qy.TextUtil:substitute(3013),
	["7"] = qy.TextUtil:substitute(3014),
	["8"] = qy.TextUtil:substitute(3015),
	["9"] = qy.TextUtil:substitute(3016),
	["10"] = qy.TextUtil:substitute(3017),
	["11"] = qy.TextUtil:substitute(3018),
	["12"] = qy.TextUtil:substitute(3019),
	["13"] = qy.TextUtil:substitute(3020),
	["14"] = qy.TextUtil:substitute(3021),
	["15"] = qy.TextUtil:substitute(3022),
	["16"] = qy.TextUtil:substitute(90281),
	["17"] = qy.TextUtil:substitute(90282),
	["18"] = qy.TextUtil:substitute(90280),
	["19"] = qy.TextUtil:substitute(3023),
	["20"] = qy.TextUtil:substitute(3023),
}


function EquipModel:getAdvanceData(data)
	local value = (data.type == 8 or data.type == 12 or data.type == 13 or data.type == 14 or data.type == 15 or data.type == 16 or data.type == 17 or data.type == 18 or data.type == 6 or data.type == 7 or data.type == 11) and data.param / 10 .. "%" or data.param

	return value
end


function EquipModel:atAdvanceConsume(level)
	return self.advancedConsume[tostring(level)]
end

-- 
function EquipModel:atGrowUp(entity)
	return self.growUpList[tostring(entity.equip_id)]
end


function EquipModel:atSpecailAttr(entity, level)
	local list = self:atScepcailList(entity)
	local max = self:getMaxLevel(entity)

	if level then
		return list[tostring(level)]
	end

	local level = entity.advanced_level + 1 > max and max or entity.advanced_level + 1
	
	return list[tostring(level)]
end

function EquipModel:atScepcailList(entity)
	local list = {}
	for i = 1, self:getMaxLevel(entity) do
		local id = self:atGrowUp(entity)["special_id" .. i]
		list[tostring(i)] = self.specialAttr[tostring(id)]
	end
	return list
end

function EquipModel:atSpecailByLevel(entity, level)
	local list = self:atScepcailList(entity)
	local max = self:getMaxLevel(entity)

	if level > max then
		level = max
	end
	local id = self:atGrowUp(entity)["special_id" .. level]
	return self.specialAttr[tostring(id)]
end

function EquipModel:getMaxLevel(entity)
	local list = self:atGrowUp(entity)

	if not list then
		return 0
	end

	local z = 0
	for i, v in pairs(list) do
		if v ~= 0 and string.find(i, "special_id") ~= nil then
			z = z + 1
		end
	end

	return z

end


function EquipModel:testCanAdvance(entity)
	if entity.advanced_level >= self:getMaxLevel(entity) then
		return 4
	end

	if entity:getQuality() > 4 then
		if #self:getNoUseEquipEntity(entity) > 0 then
			local data = self:atAdvanceConsume(entity.advanced_level)
			local userInfoModel =  qy.tank.model.UserInfoModel
			if userInfoModel.userInfoEntity.silver < data.silver or userInfoModel.userInfoEntity.purpleIron < data.purple_iron then
				return 1
			elseif userInfoModel.userInfoEntity.level < data.level or userInfoModel.userInfoEntity.level < self:getEquipAdvanceOpenLevel() then
				return 2
			else
				return 3
			end
		end
	end
	return 0
end
--洗练在这开始
function EquipModel:getConsumeByid( idx )
	local data = qy.Config.addition_consume
	return data[tostring(idx)].consume
end
function EquipModel:getFullvalueByid( idx )
	local data = qy.Config.addition_attr
	for k,v in pairs(data) do
		if v.type == idx then
			return v.max
		end
	end
end


return EquipModel
