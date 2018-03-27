--[[
	tank vo
	Author: Aaron Wei
	Date: 2015-03-20 11:58:36
]]
local TankEntity = qy.class("TankEntity", qy.tank.entity.BaseEntity)
local moduleType = qy.tank.view.type.ModuleType
local RoleUpgradeModel = qy.tank.model.RoleUpgradeModel

-- data 初始化坦克的数据
-- _type 坦克类型 0:坦克表 1:关卡怪物 2:经典战役怪物 3:竞技场怪物 4:矿区怪物 5:远征怪物 6:伞兵入侵怪物
function TankEntity:ctor(data,_type,isDisplay)
	self.data = data
	self.typeNameList = {qy.TextUtil:substitute(70047),qy.TextUtil:substitute(70048),qy.TextUtil:substitute(70049),qy.TextUtil:substitute(70050),qy.TextUtil:substitute(70051)}
	self.monster_type = _type or 0

	self.config = qy.tank.config.MonsterConfig.getTable(self.monster_type)
	if data then
		if type(data) == "table" then
			-- remote server data
			if data.type == 36 then--坦克碎片
				self:__initByID(data.id)
			else
				self:__initByData(data)
			end
		elseif type(data) == "number" or type(data) == "string" then
			if isDisplay then
				self:__initDisplay(data)
			else
				self:__initByID(data)
			end
		end
	end

	--处理star,monster表没有star
	self:__dealWithStar()
end

--成长系数
function TankEntity:getGrowthFactorByKey(_key)
	if _key == "attack" then
		--攻击力成长值 * 改造系数
		return 46 * self:getReformRatio()
	elseif _key == "defense" then
		--防御成长值
		return 23 * self:getReformRatio()
	elseif _key == "blood" then
		--血量成长值
		return 115 * self:getReformRatio()
	end
end

function TankEntity:__dealWithStar()
	--1白=2星     2绿=3星    3蓝=4星   4紫=5星  5橙色=6星   6红=7星
	if self.star == nil then
		self.star = tonumber(self.quality) + 1
	end
end
--鼠式


function TankEntity:__initByData(data)
	self.tankConfig = qy.tank.config.MonsterConfig.getItem(self.monster_type,tostring(data.tank_id))

	if self.monster_type == 0 then
		self.tank_id = data.tank_id
	else
		if data.monster_id == nil then
			self.tank_id = data.tank_id
		else
			self.tank_id = data.monster_id
		end
	end

	self:setproperty("unique_id",data.unique_id)
	self:setproperty("kid", data.kid)
	self:setproperty("name", self.tankConfig.name)
	self:setproperty("type", data.type)
	self:setproperty("level",data.level or 1)
	self:setproperty("exp", data.exp)
	self:setproperty("star", data.star)

	--坦克品质改为读表
	self:setproperty("quality",self.tankConfig.quality)
	self:setproperty("location",self.tankConfig.location)

	-- 基础属性
	-- self.basic_attack = data.attack -- 基础攻击力
	-- self.basic_defense = data.defense -- 基础防御力
	-- self.basic_blood = data.blood -- 基础生命值
	-- self.basic_crit_hurt = data.crit_hurt -- 基础暴击率
	-- if self.unique_id and self.unique_id == 2975 then
	-- 	print("self.tankConfig.blood===>>",self.tankConfig.blood)
	-- 	print("xxxx===>>>",(self.level-1) * self:getGrowthFactorByKey("blood"))
	-- 	print("self.level====>>>",self.level,self:getGrowthFactorByKey("blood"))
	-- end
	self.reform_stage = data.reform_stage or 0 --坦克改造次数
	self.promotion_stage = data.promotion_stage or 0
	--鼠式进阶
	-- if self.promotion_stage ~= 0 then
	-- 	local shushi_tank_attack = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,1)
	-- 	local shushi_tank_defense = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,2)
	-- 	local shushi_tank_blood = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,3)

	-- 	 self.tankConfig.attack = self.tankConfig.attack + shushi_tank_attack 
	-- 	 self.tankConfig.defense = self.tankConfig.defense + shushi_tank_defense
	-- 	 self.tankConfig.blood = self.tankConfig.blood + shushi_tank_blood
	-- 	 print("00-11",shushi_tank_attack)
	-- 	 print("00-22",shushi_tank_defense)
	-- 	 print("00-33",shushi_tank_blood)
	-- end


	if data.position and data.position ~= "" then
		self.position = data.position
	end	
	
	self.basic_attack = math.floor(self.tankConfig.attack + (self.level-1) * self:getGrowthFactorByKey("attack"))-- 基础攻击力
	
	self.basic_defense = math.floor(self.tankConfig.defense + (self.level-1) * self:getGrowthFactorByKey("defense")) --基础防御力
	self.basic_blood = math.floor(self.tankConfig.blood + (self.level-1) * self:getGrowthFactorByKey("blood")) --基础生命值
	self.basic_crit_hurt = self.tankConfig.crit_hurt--基础暴击率

	self.wear = self.tankConfig.wear -- 穿深值
	self.anti_wear = self.tankConfig.anti_wear -- 穿深抵抗值
	self.talent_id = data.talent_id
	self.common_skill_id = data.common_skill_id
	self.compat_skill_id = data.compat_skill_id
	self.morale = data.morale
	self.is_train = data.is_train
	self.train_pos = data.train_pos
	self.status = data.status
	self.equip = data.equip
	self.passenger = data.passenger
	self.medal = {}
	if data.medal then
		self.medal = data.medal
	end
	if data.fittings then
		self.fittings = data.fittings
	end

	self:setproperty("tujian_type", data.tujian_type) -- 图鉴加成类型
	self:setproperty("tujian_val", data.tujian_val) -- 图鉴加成数值
	self:setproperty("is_tujian", self.tankConfig.is_tujian or 0) -- 图鉴加成数值
	self:setproperty("isOwn", false) -- 是否拥有
	self:setproperty("commentList", {}) -- 评论
	self:setproperty("sortID", data.sortID) -- 图鉴排序

	self:setproperty("advance_level", data.advance_level or 0) -- 进阶等级

	for i = 1, 10 do
		local _type = self.tankConfig["currency_type"..(i == 1 and "" or tostring(i))] 
		local _num = self.tankConfig["currency_num"..(i == 1 and "" or tostring(i))]

		if _type == nil or _num == nil then
			break
		end

		self:setproperty("currency_type"..(i == 1 and "" or tostring(i)), _type) -- 分解货币类型
		self:setproperty("currency_num"..(i == 1 and "" or tostring(i)), _num) -- 分解货币数量
	end
	-- self:setproperty("currency_type", self.tankConfig.currency_type) -- 分解货币类型
	-- self:setproperty("currency_num", self.tankConfig.currency_num) -- 分解货币数量
	self:setproperty("last_tank_id", self.tankConfig.last_tank_id) -- 进阶前id
	self:setproperty("inherit", self.tankConfig.inherit) -- 置换类型
	self:setproperty("ids", self.tankConfig.ids) 

	-- self:setproperty({"isNew", data.isNew or false})

	--远征新加字段--
	--是否在远征阵位上 0：不在，1：在 默认0
	self.expedition_status = data.expedition_status or 0
	--远征阵位位置 默认 0
	self.expedition_position = tonumber(data.expedition_position) or 0
	--远征装备
	self.expedition_equip = data.expedition_equip or {["gun"] = 0, ["bullet"] = 0, ["armor"] = 0, ["engine"] = 0}

	-- local config data
	self.typeName = self.typeNameList[data.type]

	self.des = self.config[tostring(self.tank_id)].desc
	-- 命中率
	self.hit = data.hit or math.floor(100+qy.Config.talent[tostring(self.talent_id)].hit_plus/10)
	-- 闪避率
	self.dodge = data.dodge or qy.Config.talent[tostring(self.talent_id)].dodge_rate/10
	-- 天赋
	self.talent = qy.tank.entity.TalentEntity.new(tostring(data.talent_id))
	-- 技能
	self.commonSkill = qy.tank.entity.SkillEntity.new(tostring(data.common_skill_id))
	self.compatSkill = qy.tank.entity.SkillEntity.new(tostring(data.compat_skill_id))

	self.advanceData = qy.tank.model.AdvanceModel:getAdvanceAddList(self) or {}
	self.passiveSkillsData = qy.tank.model.AdvanceModel:getPassiveSkillsAddList(self) or {}
	self.advanceCommonData = qy.tank.model.AdvanceModel:atCommonAttr(self.advance_level) or {}

	
end

function TankEntity:__initByID(id)
	self.tankConfig = qy.tank.config.MonsterConfig.getItem(self.monster_type,tostring(id))
	local data = self.tankConfig

	self.tank_id = id
	self.unique_id = nil
	self:setproperty("level", 1)
	self:setproperty("name", data.name)
	self:setproperty("type", data.type)
	self:setproperty("star", data.star)
	self:setproperty("quality", data.quality)
	self.typeName = self.typeNameList[data.type]
	self.location = qy.Config.tank_res[tostring(self.config[tostring(self.tank_id)].icon)].location

	-- 基础属性
	self.basic_attack = data.attack -- 基础攻击力
	self.basic_defense = data.defense -- 基础防御力
	self.basic_blood = data.blood -- 基础生命值
	self.basic_crit_hurt = data.crit_hurt -- 基础暴击率

	self.wear = data.wear -- 穿深值
	self.anti_wear = data.anti_wear -- 穿深抵抗值
	self.talent_id = data.talent_id
	-- 天赋
	-- self.talent = qy.tank.entity.TalentEntity.new(tostring(data.talent_id))
	self.common_skill_id = data.common_skill_id
	self:setproperty("compat_skill_id", data.compat_skill_id)
	-- 天赋
	self.talent = qy.tank.entity.TalentEntity.new(tostring(data.talent_id))
	self.des = self.config[tostring(self.tank_id)].desc
	-- 技能
	self.commonSkill = qy.tank.entity.SkillEntity.new(tostring(data.common_skill_id))
	self.compatSkill = qy.tank.entity.SkillEntity.new(tostring(data.compat_skill_id))

	-- 闪避率
	self.dodge = data.dodge or qy.Config.talent[tostring(self.talent_id)].dodge_rate/10

	-- 命中率
	self.hit = data.hit or math.floor(100+qy.Config.talent[tostring(self.talent_id)].hit_plus/10)

	self:setproperty("tujian_type", data.tujian_type) -- 图鉴加成类型
	self:setproperty("tujian_val", data.tujian_val) -- 图鉴加成数值
	self:setproperty("is_tujian", data.is_tujian) -- 图鉴加成数值
	self:setproperty("isOwn", false) -- 是否拥有
	self:setproperty("commentList", {}) -- 评论

	for i = 1, 10 do
		local _type = data["currency_type"..(i == 1 and "" or tostring(i))] 
		local _num = data["currency_num"..(i == 1 and "" or tostring(i))] 

		if _type == nil or _num == nil then
			break
		end

		self:setproperty("currency_type"..(i == 1 and "" or tostring(i)), _type) -- 分解货币类型
		self:setproperty("currency_num"..(i == 1 and "" or tostring(i)), _num) -- 分解货币数量
	end
	-- self:setproperty("currency_type", data.currency_type) -- 分解货币类型
	-- self:setproperty("currency_num", data.currency_num) -- 分解货币数量
	self:setproperty("sortID", data.sortID) -- 图鉴排序
	self:setproperty("advance_level", data.advance_level or 0) -- 进阶等级
	self:setproperty("last_tank_id", self.tankConfig.last_tank_id) -- 进阶前id
	self:setproperty("inherit", self.tankConfig.inherit) -- 置换类型
	self:setproperty("ids", self.tankConfig.ids) 

	self.advanceData = qy.tank.model.AdvanceModel:getAdvanceAddList(self) or {}
	self.passiveSkillsData = qy.tank.model.AdvanceModel:getPassiveSkillsAddList(self) or {}

	self.advanceCommonData = qy.tank.model.AdvanceModel:atCommonAttr(self.advance_level) or {}

	self.reform_stage = 0 --坦克改造次数
end

--[[
	获取改造后提升的系数
	参数 _stage: 当 _stage 为 nil 时，表示获取坦克档期的改造次数对应的提升系数
]]--
function TankEntity:getReformRatio(_stage)
	if _stage == nil then
		_stage = self.reform_stage
	end
	if _stage == nil or _stage == 0 then
		return 1
	else
		local data = qy.Config.tank_reform[tostring(_stage)]
		if data then
			return data.ratio
		else
			return 1
		end
	end
end

--获取下次改造提升的系数
function TankEntity:getNextReformRatio()
	if self.reform_stage then
		return self:getReformRatio(self.reform_stage + 1)
	else
		return self:getReformRatio(1)
	end
end

-- 当前等级是否需要改造
function TankEntity:isNeedReform()
	local data = qy.Config.tank_reform
	local _stage = self.reform_stage
	if _stage == nil then
		_stage = 1
	else
		_stage = _stage + 1
	end
	if self.level >= data[tostring(_stage)].level then
		-- 如果当前的等级 大于或等于下一次改造提升的等级，且是 5 的倍数，则需要改造
		return true
	else
		return false
	end


	-- if self.level%5 == 0 then
	-- 	local data = qy.Config.tank_reform
	-- 	local _stage = self.reform_stage
	-- 	if _stage == nil then
	-- 		_stage = 1
	-- 	else
	-- 		_stage = _stage + 1
	-- 	end
	--
	-- 	if self.level >= data[tostring(_stage)].level then
	-- 		-- 如果当前的等级 大于或等于下一次改造提升的等级，且是 5 的倍数，则需要改造
	-- 		return true
	-- 	else
	-- 		return false
	-- 	end
	-- else
	-- 	-- 不是 5 的倍数
	-- 	return false
	-- end
end

-- 为了优化效率，只初始化与现实相关的属性
function TankEntity:__initDisplay(id)
	self.tankConfig = qy.tank.config.MonsterConfig.getItem(self.monster_type,tostring(id))
	local data = self.tankConfig

	self.tank_id = id
	self.unique_id = nil
	self:setproperty("level", 1)
	self:setproperty("name", data.name)
	self:setproperty("quality", data.quality)

	-- for i=1,1000 do
	-- 	self["param"..i] = i
	-- 	-- self:setproperty("param"..i, i)
	-- 	-- self:bindProperty("param"..i, i)
	-- 	-- local a = self["param"..i]
	-- 	-- local a = self["param"..i.."_"]:get()
	-- end

end

-- 获取战车总攻击力
function TankEntity:getTotalAttack()
	print("sssssssssssssssssssssssssss")
	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_att = equip_add.attack
	for i=1,4 do
		if equip_add["12"] then
			self["equipMutil"..i] = equip_add["12"][tostring(i)] and equip_add["12"][tostring(i)] / 1000 + 1 or 1
		else
			self["equipMutil"..i] = 1
		end
	end	
	local tech_add = qy.tank.model.TechnologyModel:getTechEffertAttr().att_add
	local tech_c = qy.tank.model.TechnologyModel:getTechEffertAttr().att_c
	local passengerAtk = qy.tank.model.PassengerModel:getAttribute(self.unique_id).atk or 0 -- 乘员
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(1) or 0  -- 乘员图鉴
	local legionSkill_add = qy.tank.model.LegionModel.finalReturn["1"] -- 军团技能
	local open_level = RoleUpgradeModel:getOpenLevelByModule(moduleType.MILITARY_RANK)
	local mititaryranadd 
	if qy.tank.model.UserInfoModel.userInfoEntity.level >=open_level then
		 mititaryranadd = qy.tank.model.MilitaryRankModel:getAddAttrSingle(1)--军衔加成
	else
		 mititaryranadd = 0
	end 
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,1)--军魂副属性
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(1)--
	local chenghaoext = qy.tank.model.ServerExerciseModel:gettanklist(11)--百分比

	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,1) 

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,1)
	local fittingsAtk = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,12) / 1000 + 1

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(1)
	local svipsAtk = qy.tank.model.GodWarModel:totalAttr(12) / 1000 + 1
	-- 图鉴加成

	local picAdd = qy.tank.model.AchievementModel.picAttribute[1].val -- 图鉴 ＋ 成就
	local advanceCommonAdd = self.advanceCommonData.attack_plus or 0 -- 进阶公共属性
	local advanceMutil = self.advanceData["12"] and self.advanceData["12"] / 1000 + 1 or 1 -- 进阶百分比加成
	local passiveSkillsMutil = self.passiveSkillsData["12"] and self.passiveSkillsData["12"] / 1000  or 0
	local advanceAdd = self.advanceData["1"] or 0 --进阶特殊属性
 	local tech_new_add = 0--科技武装加成

 	if self.position and self.position ~= "" then
 		tech_new_add = qy.tank.model.TechnologyModel:getBaseByPos(self.position).attack
 	end
 	--战地设宴活动
 	local banquet_attack = qy.tank.model.FieldBanquetModel:totalAttr(1)
 	--鼠式
 	print("TankEntity===0,坦克攻击力")
 	local shushi_tank_attack = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,1)
	shushi_tank_attack = shushi_tank_attack or 0
	self.basic_attack = math.floor(self.tankConfig.attack +shushi_tank_attack + banquet_attack + (self.level-1) * self:getGrowthFactorByKey("attack"))-- 基础攻击力
	-- print(self.unique_id.."攻击力 ＝ [初始]" .. self.basic_attack .. "+[装备]".. equip_att .."+[科技附加值]".. tech_add  .."+[成就 和 图鉴]"..  picAdd  .."+[进阶特殊属性]"..  advanceAdd  .."+[进阶公共属性]"..  advanceCommonAdd..")* [天赋系数]" .. self.talent.attack_plus .."*[科技系数]" .. tech_c .. "* [进阶百分比加成]" ..advanceMutil)
	print("TankEntity:getTotalAttack11","basic="..self.basic_attack,"equip="..equip_att,"tech_add="..tech_add,"talent="..self.talent.attack_plus,"tech_c="..tech_c)
	print("passengerAtk=",passengerAtk,"passengerAdd=",passengerAdd,"legionSkill_add=",legionSkill_add,"advanceMutil=",advanceMutil,"picAdd=",picAdd,"self.tankConfig.attack",self.tankConfig.attack)

	return math.floor((self.basic_attack + equip_att  +passengerAtk + passengerAdd + legionSkill_add + tech_add + tech_new_add + picAdd + advanceAdd + advanceCommonAdd + mititaryranadd+ chenghaoadd + mmedalAtk + fittingsadd + svipadd)*self.talent.attack_plus*tech_c * (advanceMutil + passiveSkillsMutil) * self.equipMutil1* self.equipMutil2 *self.equipMutil3 *self.equipMutil4 * chenghaoext * anothersoul * fittingsAtk * svipsAtk)


end

-- 获取战车总防御力
function TankEntity:getTotalDefense()
	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_def = equip_add.defense
	-- local equipMutil = equip_add["13"] and equip_add["13"] / 1000 + 1 or 1
	for i=1,4 do
		if equip_add["13"] then
			self["dequipMutil"..i] = equip_add["13"][tostring(i)] and equip_add["13"][tostring(i)] / 1000 + 1 or 1
		else
			self["dequipMutil"..i] = 1
		end
	end
	local tech_add = qy.tank.model.TechnologyModel:getTechEffertAttr().def_add
	local tech_c = qy.tank.model.TechnologyModel:getTechEffertAttr().def_c

	local passengerDef = qy.tank.model.PassengerModel:getAttribute(self.unique_id).def or 0 -- 乘员
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(2) or 0  -- 乘员图鉴
	local legionSkill_add = qy.tank.model.LegionModel.finalReturn["2"] -- 军团技能
	local open_level = RoleUpgradeModel:getOpenLevelByModule(moduleType.MILITARY_RANK)
	local mititaryranadd 
	if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
		 mititaryranadd = qy.tank.model.MilitaryRankModel:getAddAttrSingle(2)--军衔加成
	else
		 mititaryranadd = 0
	end 
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,2)--军魂副属性
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(2)--
	local chenghaoext = qy.tank.model.ServerExerciseModel:gettanklist(12)--百分比

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,2)
	local fittingsAtk = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,13) / 1000 + 1

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(2)
	local svipsAtk = qy.tank.model.GodWarModel:totalAttr(13) / 1000 + 1

	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,2)
	local tech_new_add = 0--科技武装加成
	if self.position and self.position ~= "" then
 		tech_new_add = qy.tank.model.TechnologyModel:getBaseByPos(self.position).defense
 	end

	-- 图鉴加成
	local picAdd = qy.tank.model.AchievementModel.picAttribute[2].val or 0
	local advanceCommonAdd = self.advanceCommonData.defense_plus or 0
	local advanceMutil = self.advanceData["13"] and self.advanceData["13"] / 1000 + 1 or 1 -- 进阶百分比加成
	local passiveSkillsMutil = self.passiveSkillsData["13"] and self.passiveSkillsData["13"] / 1000  or 0
	local advanceAdd = self.advanceData["2"] or 0

	--战地设宴活动
 	local banquet_defense = qy.tank.model.FieldBanquetModel:totalAttr(2)

	--鼠式
	local shushi_tank_defense = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,2)
	shushi_tank_defense = shushi_tank_defense or 0
	self.basic_defense = math.floor(self.tankConfig.defense+shushi_tank_defense + banquet_defense + (self.level-1) * self:getGrowthFactorByKey("defense")) --基础防御力
	print("TankEntity:getTotalfense","basic="..self.basic_defense,"equip="..equip_def,"passengerDef="..passengerDef,"passengerAdd="..passengerAdd,"tech_add="..tech_add,"talent="..self.talent.defense_plus,"talent_c="..tech_c)

	return math.floor((self.basic_defense + equip_def + passengerDef + legionSkill_add + tech_add + tech_new_add + picAdd + passengerAdd + advanceAdd + advanceCommonAdd + mititaryranadd + chenghaoadd + mmedalAtk + fittingsadd + svipadd)*self.talent.defense_plus*tech_c * (advanceMutil + passiveSkillsMutil) * self.dequipMutil1 * self.dequipMutil2 * self.dequipMutil3 * self.dequipMutil4 * chenghaoext * anothersoul * fittingsAtk * svipsAtk)

end

-- 获取战车总血量
function TankEntity:getTotalBlood()
	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_blood = equip_add.blood
	-- local equipMutil = equip_add["14"] and equip_add["14"] / 1000 + 1 or 1
	for i=1,4 do
		if equip_add["14"] then
			self["bequipMutil"..i] = equip_add["14"][tostring(i)] and equip_add["14"][tostring(i)] / 1000 + 1 or 1
		else
			self["bequipMutil"..i] = 1
		end
	end
	local tech_add = qy.tank.model.TechnologyModel:getTechEffertAttr().life_add
	local tech_c = qy.tank.model.TechnologyModel:getTechEffertAttr().life_c

	local soul = qy.tank.model.SoulModel:getAttribute(self.unique_id)["4"] or 0 
	local soulAdd = soul / 1000 + 1 -- 军魂加成
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,3)--军魂副属性
	local zongsoul  = soul / 1000 + anothersoul
	local passengerHp = qy.tank.model.PassengerModel:getAttribute(self.unique_id).hp or 0 -- 乘员
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(3) or 0  -- 乘员图鉴
	local legionSkill_add = qy.tank.model.LegionModel.finalReturn["3"] -- 军团技能
	local open_level = RoleUpgradeModel:getOpenLevelByModule(moduleType.MILITARY_RANK)
	local mititaryranadd 
	if qy.tank.model.UserInfoModel.userInfoEntity.level >=open_level then
		 mititaryranadd = qy.tank.model.MilitaryRankModel:getAddAttrSingle(3)--军衔加成
	else
		 mititaryranadd = 0
	end
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(3)--
	local chenghaoext = qy.tank.model.ServerExerciseModel:gettanklist(13)--百分比

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,3)
	local fittingsAtk = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,14) / 1000 + 1

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(3)
	local svipsAtk = qy.tank.model.GodWarModel:totalAttr(14) / 1000 + 1

	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,3)

	local tech_new_add = 0--科技武装加成
	if self.position and self.position ~= "" then
 		tech_new_add = qy.tank.model.TechnologyModel:getBaseByPos(self.position).blood
 	end

	-- 图鉴加成
	local picAdd = qy.tank.model.AchievementModel.picAttribute[3].val or 0
	local advanceCommonAdd = self.advanceCommonData.blood_plus or 0
	local advanceMutil = self.advanceData["14"] and self.advanceData["14"] / 1000 + 1 or 1 -- 进阶百分比加成
	local passiveSkillsMutil = self.passiveSkillsData["14"] and self.passiveSkillsData["14"] / 1000  or 0
	local advanceAdd = self.advanceData["3"] or 0

	--战地设宴活动
 	local banquet_blood = qy.tank.model.FieldBanquetModel:totalAttr(3)

	--鼠式
	local shushi_tank_blood = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,3)
	shushi_tank_blood = shushi_tank_blood or 0
	self.basic_blood = math.floor(self.tankConfig.blood + shushi_tank_blood + banquet_blood + (self.level-1) * self:getGrowthFactorByKey("blood")) --基础生命值
	-- print(self.unique_id.."血量 ＝ [初始]" .. self.basic_blood .. "+[装备]".. equip_blood .."+[科技附加值]".. tech_add  .."+[成就 和 图鉴]"..  picAdd  .."+[进阶特殊属性]"..  advanceAdd  .."+[进阶公共属性]"..  advanceCommonAdd..")* [天赋系数]" .. self.talent.blood_plus .."*[科技系数]" .. tech_c .. "* [进阶百分比加成]" ..advanceMutil .."［军魂加成］" .. soulAdd)
	print("TankEntity:getTotalBlood","basic="..self.basic_blood,"equip="..equip_blood,"tech_add="..tech_add,"talent="..self.talent.blood_plus,"tech_c="..tech_c)

	return math.floor((self.basic_blood + equip_blood + passengerHp + passengerAdd + legionSkill_add + tech_add + tech_new_add + picAdd + advanceAdd + advanceCommonAdd + mititaryranadd + chenghaoadd + mmedalAtk + fittingsadd + svipadd)*self.talent.blood_plus*tech_c * (advanceMutil + passiveSkillsMutil)  * self.bequipMutil1 * self.bequipMutil2 * self.bequipMutil3 * self.bequipMutil4 * chenghaoext * zongsoul * fittingsAtk * svipsAtk) 

end

-- 获取战车总暴击率(%)
function TankEntity:getTotalCritRate()
	print("TankEntity:getTotalCrit","basic="..self.basic_attack,"talent="..self.talent.crit_rate,"eqiup="..qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id).crit)
	local picAdd = qy.tank.model.AchievementModel.picAttribute[6].val or 0
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(6) or 0  -- 乘员图鉴
	local advanceAdd = self.advanceData["8"] or 0
	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_crit = equip_add.crit
	local equipMutil = equip_add["8"] and equip_add["8"] or 0
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(6)--

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,8)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(8)

	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,6)

	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,6)--军魂副属性

	local soulAdd = qy.tank.model.SoulModel:getAttribute(self.unique_id)["6"] or 0 -- 军魂加成
	local passiveSkillsMutil = self.passiveSkillsData["8"] and self.passiveSkillsData["8"] or 0

	--战地设宴活动
 	local banquet_crit_rate = qy.tank.model.FieldBanquetModel:totalAttr(8)

	--鼠式进阶
	local shushi_tank_crit_rate = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,8)
	shushi_tank_crit_rate = shushi_tank_crit_rate or 0
	return self.talent.crit_rate/10 + equip_crit/10 + picAdd / 10 + passengerAdd / 10 + advanceAdd / 10 + soulAdd / 10 + equipMutil / 10 + chenghaoadd / 10 + anothersoul / 10 + mmedalAtk / 10 + passiveSkillsMutil / 10 + fittingsadd / 10 + svipadd / 10 + shushi_tank_crit_rate / 10 + banquet_crit_rate / 10
end

-- 获取战车总暴击减免(%)
function TankEntity:getTotalCritReductionRate()
	--目前暴击减免只在科技武装中有，暂时先这么写
	local tech_new_add = 0--科技武装加成
	if self.position and self.position ~= "" then
 		tech_new_add = qy.tank.model.TechnologyModel:getSpecialByPos(self.position).crit_reduction
 	end
 	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,7)--军魂副属性
 	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equipMutil = equip_add["18"] and equip_add["18"] or 0
	local equip_crit = equip_add.crit_reduction or 0
	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,7)

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,18)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(18)

	--战地设宴活动
 	local banquet_crit_rate_jian = qy.tank.model.FieldBanquetModel:totalAttr(9)

 	return tech_new_add / 10 + equipMutil / 10 +  anothersoul / 10  + mmedalAtk / 10 + fittingsadd / 10 + svipadd / 10 + equip_crit / 10 + banquet_crit_rate_jian / 10
end


-- 获取战车初始攻击力
function TankEntity:getInitialAttack()
	return math.floor(self.basic_attack * self.talent.attack_plus)
	-- return math.floor(self.basic_attack*self.talent.attack_plus)
end

-- 获取战车初始防御力
function TankEntity:getInitialDefense()
	return math.floor(self.basic_defense * self.talent.defense_plus)
	-- return math.floor(self.basic_defense*self.talent.defense_plus)
end

-- 获取战车初始血量
function TankEntity:getInitialBlood()
	return math.floor(self.basic_blood * self.talent.blood_plus)
	-- return math.floor(self.basic_blood*self.talent.blood_plus)
end

function TankEntity:getInitialCritDoubleRate()
	return 1.5
end

-- 初始暴击率
function TankEntity:getInitialCritRate()
	return math.floor(self.talent.crit_rate/10)
end

-- 初始抗缴械
function TankEntity:getInitialDisarmAnti()
	return math.floor(self.talent.disarm_anti/10)
end

-- 初始闪避
function TankEntity:getInitialDodgeRate()
	self.dodge = self.talent.dodge_rate /10
	return math.floor(self.dodge)
end

-- 初始命中
function TankEntity:getInitialHit()
	return math.floor(self.hit)
end

-- 初始穿深
function TankEntity:getInitialWear()
	return math.floor(self.wear)
end

-- 初始穿深抵抗
function TankEntity:getInitialAntiWear()
	return math.floor(self.anti_wear)
end

-- 暴击伤害翻倍率(暴击伤害)
function TankEntity:getCritDoubleRate()
	local soulAdd = qy.tank.model.SoulModel:getAttribute(self.unique_id)["7"] or 0 -- 军魂加成
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(7) or 0  -- 乘员图鉴
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(7)--
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,8)--军魂副属性
	local passiveSkillsMutil = self.passiveSkillsData["11"] and self.passiveSkillsData["11"] or 0
	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,11)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(11)

	local advanceMutil = self.advanceData["11"] and self.advanceData["11"] / 1000 + soulAdd / 1000 + chenghaoadd / 1000 + passengerAdd / 1000 + passiveSkillsMutil / 1000  + mmedalAtk / 1000 + anothersoul / 1000 + fittingsadd / 1000 + svipadd / 1000 + 1 or 1 -- 进阶百分比加成
	return 1.5 * advanceMutil
end

-- 闪避概率千分率
function TankEntity:getDodgeRate()
	local picAdd = qy.tank.model.AchievementModel.picAttribute[10].val or 0
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(10) or 0  -- 乘员图鉴
	local soulAttr = qy.tank.model.SoulModel:getAttribute(self.unique_id)
	local soulAdd = soulAttr["5"] or 0-- 军魂加成
	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,8)
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(10)--
	local advanceAdd = self.advanceData["7"] or 0
	self.dodge = (qy.Config.talent[tostring(self.talent_id)].dodge_rate) /10
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,5)--军魂副属性
	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_dodge = equip_add.dodge or 0
	local equipMutil = equip_add["7"] and equip_add["7"] or 0
	local passiveSkillsMutil = self.passiveSkillsData["7"] and self.passiveSkillsData["7"] or 0
	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,7)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(7)

	--战地设宴活动
 	local banquet_crit_dodge = qy.tank.model.FieldBanquetModel:totalAttr(7)

	--鼠式进阶
	local shushi_tank_dodge = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,7)
	shushi_tank_dodge = shushi_tank_dodge or 0
	return self.dodge + picAdd /10 + advanceAdd / 10 + soulAdd / 10 + equip_dodge / 10 + passengerAdd / 10 + equipMutil / 10 + chenghaoadd / 10 + anothersoul / 10 + mmedalAtk / 10 + passiveSkillsMutil / 10 + fittingsadd / 10 + svipadd / 10 + shushi_tank_dodge / 10 + banquet_crit_dodge / 10
end

-- 抗晕概率=缴械命中千分率
function TankEntity:getDisarmAnti()
	self.disarm_anti = qy.Config.talent[tostring(self.talent_id)].disarm_anti/10
	local advanceMutil = self.advanceData["15"] and self.advanceData["15"] / 1000 + 1 or 1 -- 进阶百分比加成
	local soul = qy.tank.model.SoulModel:getAttribute(self.unique_id)["8"] or 0
	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,10)--军魂副属性	
 	local passiveSkillsMutil = self.passiveSkillsData["15"] and self.passiveSkillsData["15"] or 0

 	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,10)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(10)

	local soulAdd = soul /1000 + passiveSkillsMutil / 1000 + anothersoul / 1000 + fittingsadd / 1000 + svipadd / 1000 + 1 -- 军魂	return self.disarm_anti * advanceMutil
end

-- 获取穿深值
function TankEntity:getWear()
	local picAdd = qy.tank.model.AchievementModel.picAttribute[4].val or 0
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(4) or 0  -- 乘员图鉴

	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equipMutil = equip_add["4"] and equip_add["4"] or 0
	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,4)
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(4)--
	local soulAdd = qy.tank.model.SoulModel:getAttribute(self.unique_id)["2"]  or 0 -- 军魂加成
	local advanceAdd = self.advanceData["4"] or 0	
 	local passiveSkillsMutil = self.passiveSkillsData["4"] and self.passiveSkillsData["4"] or 0

 	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,4)
	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(4)

	--战地设宴活动
 	local banquet_wear = qy.tank.model.FieldBanquetModel:totalAttr(4)

	--鼠式进阶
	local shushi_tank_wear = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,4)
	shushi_tank_wear = shushi_tank_wear or 0

	return self.wear + picAdd + advanceAdd + soulAdd + passengerAdd + equipMutil + chenghaoadd + mmedalAtk + passiveSkillsMutil + fittingsadd + svipadd + shushi_tank_wear + banquet_wear
end

-- 获取命中
function TankEntity:getHit()
	local picAdd = qy.tank.model.AchievementModel.picAttribute[9].val or 0
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(9) or 0  -- 乘员图鉴
	local advanceAdd = self.advanceData["6"] or 0

	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	local equip_hit = equip_add.hit or 0
	local equipMutil = equip_add["6"] and equip_add["6"] or 0
	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,9)
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(9)--

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,6)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(6)

	local soulAdd = qy.tank.model.SoulModel:getAttribute(self.unique_id)["9"] or 0 -- 军魂加成

	local tech_new_add = 0--科技武装加成
	if self.position and self.position ~= "" then
 		tech_new_add = qy.tank.model.TechnologyModel:getSpecialByPos(self.position).hit_plus
 	end

 	local passiveSkillsMutil = self.passiveSkillsData["6"] and self.passiveSkillsData["6"] or 0

 	local anothersoul = qy.tank.model.SoulModel:getanothAttribute(self.unique_id,4)--军魂副属性

 	--战地设宴活动
 	local banquet_hit = qy.tank.model.FieldBanquetModel:totalAttr(6)

 	--鼠式进阶
 	local shushi_tank_hit = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,6)
 	shushi_tank_hit = shushi_tank_hit or 0
	return self.hit + picAdd / 10 + advanceAdd / 10 + equip_hit / 10 + passengerAdd / 10 + tech_new_add / 10 + equipMutil / 10 + chenghaoadd / 10 + anothersoul / 10  + mmedalAtk / 10 + passiveSkillsMutil / 10 + fittingsadd / 10 + svipadd / 10 + soulAdd / 10 + shushi_tank_hit / 10 + banquet_hit / 10

end
-- 穿深抵抗
function TankEntity:getAnti_wear()
	local picAdd = qy.tank.model.AchievementModel.picAttribute[5].val or 0
	local passengerAdd = qy.tank.model.PassengerModel:getAddAttrSingle(5) or 0  -- 乘员图鉴
	local soulAdd = qy.tank.model.SoulModel:getAttribute(self.unique_id)["3"] or 0 -- 军魂加成

	local equip_add = qy.tank.model.EquipModel:getAddSuitPropertyByTankUid(self.unique_id)
	--勋章加成
	local mmedalAtk = qy.tank.model.MedalModel:totalAttr(self.unique_id,5)
	local equipMutil = equip_add["5"] and equip_add["5"] or 0
	--称号加成
	local chenghaoadd = qy.tank.model.ServerExerciseModel:gettanklist(5)--

	--配件加成
	local fittingsadd = qy.tank.model.FittingsModel:totalAttr2(self.unique_id,5)

	--svip加成
	local svipadd = qy.tank.model.GodWarModel:totalAttr(5)

	local advanceAdd = self.advanceData["5"] or 0

	--战地设宴活动
 	local banquet_anti_wear = qy.tank.model.FieldBanquetModel:totalAttr(5)

	--鼠式进阶
	local shushi_tank_anti_wear = qy.tank.model.GarageModel:totalAttr(self.promotion_stage,5)
	shushi_tank_anti_wear = shushi_tank_anti_wear or 0
	return self.anti_wear + picAdd + advanceAdd + soulAdd + passengerAdd + equipMutil + chenghaoadd + mmedalAtk + fittingsadd + svipadd + shushi_tank_anti_wear + banquet_anti_wear
end

-- 战斗力
-- 公式：穿深战力系数*暴击战力系数*暴击伤害战力系数*面板攻击力*攻击战力系数 + 命中战力系数*闪避战力系数*抗晕战力系数*穿深抵抗战力系数*面板防御力*防御战力系数 + 面板生命值*生命战力系数
function TankEntity:getPower()
	print("TankEntity:getPower")
	-- 穿深战力系数 = 1 + 穿深值/500
	local s1 = 1 + self:getWear() /500
	-- 暴击战力系数 = 1 + 暴击概率/2
	local s2 = 1 + self:getTotalCritRate()/200
	-- 暴击伤害战力系数 = 1 + (暴击伤害翻倍率-1.5)/2
	local s3 = 1 + (self:getCritDoubleRate()-1.5)/2
	-- 面板攻击力
	local s4 = self:getTotalAttack()
	-- 攻击战力系数
	local s5 = 1

	-- 命中战力系数 = 1 +（命中概率-1）/2
	local s6 = 1 + (self:getHit() / 100 - 1)/2
	-- 穿深抵抗战力系数 = 1 + 穿深抵抗值/500
	local s7 = 1 + self:getAnti_wear()/500
	-- 闪避战力系数 = 1 + 闪避概率/2
	local s8 = 1 + self:getDodgeRate()/200
	-- 抗晕战力系数 = 1 + 抗晕概率/2
	local s9 = 1 + self:getDisarmAnti()/200
	-- 面板防御力
	local s10 = self:getTotalDefense()
	-- 防御战力系数
	local s11 = 1

	-- 面板生命值
	local s12 = self:getTotalBlood()
	-- 生命战力系数
	local s13 = 0.25

	return s1*s2*s3*s4*s5 + s6*s7*s8*s9*s10*s11 + s12*s13
end

--获取装备实体table
function TankEntity:getEquipEntity()
	local equipUid = self.equip
	local equipEntity = {}
	local nType = 0
	for key, var in pairs(equipUid) do
		--key 类型 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
		nType = qy.tank.model.EquipModel:getTypeByComponentName(key)
		if equipUid[key] > 0 then
			--已装载装备
			equipEntity[nType] = qy.tank.model.EquipModel:getEntityByTypeAndUid(nType, equipUid[key])
		else
			--未装载装备
			equipEntity[nType] = -1
		end

	end
	return equipEntity
end

--获取远征装备实体table
function TankEntity:getExpeditionEquipEntity()
	local equipUid = self.expedition_equip
	local equipEntity = {}
	local nType = 0
	for key, var in pairs(equipUid) do
		--key 类型 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
		nType = qy.tank.model.EquipModel:getTypeByComponentName(key)
		if equipUid[key] > 0 then
			--已装载装备
			equipEntity[nType] = qy.tank.model.EquipModel:getEntityByTypeAndUid(nType, equipUid[key])
		else
			--未装载装备
			equipEntity[nType] = -1
		end

	end
	return equipEntity
end

--获取装备实体
function TankEntity:getEquipEntityList()
	local equipUid = self.equip
	local equipEntityList = {-1, -1, -1, -1}
	local index = -1
	local equipEntity = nil
	for key, var in pairs(equipUid) do
		--key 类型 gun: 火炮 bullet:炮弹 armor：装甲 engine：发动机
		if equipUid[key] > 0 then
			--已装载装备
			equipEntity = qy.tank.model.EquipModel:getEntityByTypeAndUid(qy.tank.model.EquipModel:getTypeByComponentName(key), equipUid[key])
			equipEntityList[equipEntity:getType()] = equipEntity
		end
	end
	return equipEntityList
end

-- 获取战斗形象
function TankEntity:getAvatar()
	local id = self.config[tostring(self.tank_id)].icon
	return "t"..id
end

-- 获取特写大图
function TankEntity:getImg()
	local id = self.config[tostring(self.tank_id)].icon
	local res
	-- if id < 86 then
	-- 	res = "tank/img/img_t"..id..".jpg"
	-- else
		res = "tank/img/img_t"..id..".png"
	-- end
	print("TankEntity:getImg",res)
	return res
end

--获取大图坐标
function TankEntity:getImgPosition()
	local imgPosition = qy.Config.tank_res[tostring(self.config[tostring(self.tank_id)].icon)].img[1]
	return cc.p(imgPosition)
end

-- 获得icon
function TankEntity:getIcon()
	print("TankEntity001",self.tank_id)
	print("TankEntity001", self.config[tostring(self.tank_id)])
	local id = self.config[tostring(self.tank_id)].icon
	return "tank/icon/icon_t"..id..".png"
end

--获得小icon
function TankEntity:getLittleIcon()
	--写在model里是因为军团战决赛时坦克太多，且只需icon
	qy.tank.model.GarageModel:getLittleIconByTankId(self.tank_id)
end

-- 获得卡片
function TankEntity:getCard()
	-- local id = self.config[tostring(self.tank_id)].tank_id
	print("+++++++++++++++778899",self.tank_id)
	local res = self.tank_id == 1 and 19 or self.tank_id == 19 and 1 or self.tank_id
	return "tank/card/card_t"..res..".jpg"
end

function TankEntity:getIconBg()
	local quality = self:get("quality")
	return "tank/bg/bg" .. quality .. ".png"
end

function TankEntity:getCardFrame()
	local quality = self:get("quality")
	return "tank/frame/card_frame_"..quality..".png"
end

function TankEntity:getFontColor()
	local quality = self:get("quality")
	-- 白绿蓝紫橙
	if quality == 1 or quality == "1" then
		return cc.c4b(255,255,255,255)
	elseif quality == 2 or quality == "2" then
		return cc.c4b(46, 190, 83, 255)
	elseif quality == 3 or quality == "3" then
		return cc.c4b(36, 174, 242,255)
	elseif quality == 4 or quality == "4" then
		return cc.c4b(172, 54, 249,255)
	elseif quality == 5 or quality == "5" then
		return cc.c4b(255, 153, 0,255)
	elseif quality == 6 or quality == "6" then
		return cc.c4b(251, 48, 0,255)
	end
end

--[[--
--icon小背景，目前仅用于发奖励
--]]
function TankEntity:getIconLittleBg()
	local quality = self:get("quality")
	return "Resources/common/item/item_bg_"..quality..".png"
	-- -- 白绿蓝紫橙
	-- if quality == 1 or quality == "1" then
	-- 	return "Resources/common/item/item_bg_1.png"
	-- elseif quality == 2 or quality == "2" then
	-- 	return "Resources/common/item/item_bg_2.png"
	-- elseif quality == 3 or quality == "3" then
	-- 	return "Resources/common/item/item_bg_3.png"
	-- elseif quality == 4 or quality == "4" then
	-- 	return "Resources/common/item/item_bg_4.png"
	-- elseif quality == 5 or quality == "5" then
	-- 	return "Resources/common/item/item_bg_5.png"
	-- end
end

function TankEntity:getResID()
	return self.tankConfig.icon
end

function TankEntity:getResPrefix(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b"
	end
end

function TankEntity:getBodyRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b.png"
	end
end

function TankEntity:getBarrelRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a_1.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b_1.png"
	end
end

function TankEntity:getDieRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a_die.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b_die.png"
	end
end

function TankEntity:getOffset()
	return cc.p(10,20)
end

function TankEntity:getOffsetX()
	return 7
end

function TankEntity:getOffsetY()
	return 25
end

--[[--
--获取是否上阵
--]]
function TankEntity:getToBattle()
	if self.isBattle == 1 then
		--上阵
		return true
	else
		--不上阵
		return false
	end
end

--[[--
--设置是否上阵
--]]
function TankEntity:setToBattle(flag)
	--为了排序，将boolean值转为 int
	if flag then
		self.isBattle = 1
	else
		self.isBattle = 0
	end
end

function TankEntity:hasEquipNeedStrengthen()
	if self.unique_id == nil or  self.unique_id == nil then
		return false
	end
	local list = self:getEquipEntityList()
	for i = 1, #list do
		if tonumber(list[i]) == nil then
			if list[i].level < qy.tank.model.UserInfoModel:getMaxEquipLevelByUserLevel() then
				return true
			end
		end
	end
	return false
end

--获取他人装备实体table
function TankEntity:getOtherEquipEntity()
	local equipData = self.equip
	if equipData == nil then
		return nil
	end
	local equipEntity = {}
	local nType = 0
	for key, var in pairs(equipData) do
		nType = qy.tank.model.EquipModel:getTypeByComponentName(key)
		if type(equipData[key]) == "table" then
			--已装载装备
			equipEntity[nType] = qy.tank.entity.EquipEntity.new(equipData[key])
		else
			--未装载装备
			equipEntity[nType] = -1
		end

	end
	return equipEntity
end

-- 添加评论
function TankEntity:addCommnet(entity)
	self.commentList_[tostring(entity.id)] = entity

    table.insert(self.commentList, entity)
end

-- 获取评论
function TankEntity:getComment()
    table.sort(self.commentList, function(a, b)
        return a.time > b.time
    end)

    table.sort(self.commentList, function(a, b)
        return a.niceNum > b.niceNum
    end)

    return self.commentList
end

function TankEntity:getSealIcon()
	if self.location == 1 then -- 高攻
		return "Resources/common/icon/b4.png"
	elseif self.location == 2 then -- 爆发
		return "Resources/common/icon/b5.png"
	elseif self.location == 3 then -- 防御
		return "Resources/common/icon/b1.png"
	elseif self.location == 4 then -- 辅助
		return "Resources/common/icon/b3.png"
	elseif self.location == 5 then -- 控制
		return "Resources/common/icon/b2.png"
	else
		return ""
	end
end

function TankEntity:setNewStatus(_isNew)
	self._newStatus = _isNew
end

function TankEntity:isNew()
	if self._newStatus then
		return self._newStatus
	else
		return false
	end
end

function TankEntity:getAdvanceSourceNum()
	local num = {}
	num.advance_material = 0
	num.purple_iron = 0
	num.orange_iron = 0
	num.reputation = 0
	local staticData = qy.Config.advance_common_attr
	local oldQuality = qy.Config.tank[tostring(self.last_tank_id)] and qy.Config.tank[tostring(self.last_tank_id)].quality or self.quality
	for i = 1, self.advance_level do
		local data = staticData[tostring(i)]
		num.advance_material = num.advance_material + data.advance_material
		if oldQuality == 4 then
			num.purple_iron = num.purple_iron + data.purple_iron
		end
		if oldQuality >= 5 then
			num.orange_iron = num.orange_iron + data.orange_iron
		end

		num.reputation = num.reputation + data.reputation
	end
	return num
end


return TankEntity
