--[[
	tank vo
	Author: Aaron Wei
	Date: 2015-09-22 19:30:26
]]

local OtherTankEntity = qy.class("OtherTankEntity", qy.tank.entity.BaseEntity)

-- data 初始化坦克的数据
-- _type 坦克类型 0:坦克表 1:关卡怪物 2:经典战役怪物 3:竞技场怪物 4:矿区怪物 5:远征怪物 6:伞兵入侵怪物
function OtherTankEntity:ctor(data,_type)
	self.typeNameList = {qy.TextUtil:substitute(70047),qy.TextUtil:substitute(70048),qy.TextUtil:substitute(70049),qy.TextUtil:substitute(70050),qy.TextUtil:substitute(70051)}
	self.monster_type = _type or 0
	self:init(data)
end

function OtherTankEntity:init(data)
	if type(data) == "table" then
		self:__initByData(data)
	elseif type(data) == "number" or type(data) == "string" then
		self:__initByID(data)
	end
	--处理star,monster表没有star
	self:__dealWithStar()
end

-- --成长系数
-- function OtherTankEntity:getGrowthFactorByKey(_key)
-- 	if _key == "attack" then
-- 		--攻击力成长值
-- 		return 46
-- 	elseif _key == "defense" then
-- 		--防御成长值
-- 		return 23
-- 	elseif _key == "blood" then
-- 		--血量成长值
-- 		return 115
-- 	end
-- end

function OtherTankEntity:__dealWithStar()
	--1白=2星     2绿=3星    3蓝=4星   4紫=5星  5橙色=6星   6红=7星
	if self.star == nil then
		self.star = tonumber(self.quality) + 1
	end
end

function OtherTankEntity:__initByData(data)
	self.tankConfig = qy.tank.config.MonsterConfig.getItem(self.monster_type,tostring(data.tank_id))

	self:setproperty("unique_id",data.unique_id)
	self:setproperty("kid", data.kid)
	self:setproperty("name", self.tankConfig.name)
	self:setproperty("type", data.type)
	self:setproperty("level",data.level or 1)
	self:setproperty("exp", data.exp)
	self:setproperty("star", data.star)
	self.location = qy.Config.tank_res[tostring(self.tankConfig.icon)].location

	--坦克品质改为读表
	self:setproperty("quality",self.tankConfig.quality)
	self.tank_id = data.tank_id

	self.basic_attack = data.attack -- 基础攻击力
	self.basic_defense = data.defense -- 基础防御力
	self.basic_blood = data.blood -- 基础生命值
	self.basic_crit_hurt = data.crit_hurt -- 基础暴击率
	-- self.basic_attack = self.tankConfig.attack + (self.level-1) * self:getGrowthFactorByKey("attack") -- 基础攻击力
	-- self.basic_defense = self.tankConfig.defense + (self.level-1) * self:getGrowthFactorByKey("defense") --基础防御力
	-- self.basic_blood = self.tankConfig.blood + (self.level-1) * self:getGrowthFactorByKey("blood") --基础生命值
	-- self.basic_crit_hurt = self.tankConfig.crit_hurt--基础暴击率

	self.wear = data.wear -- 穿深值
	self.anti_wear = data.anti_wear -- 穿深抵抗值
	self.talent_id = data.talent_id
	self.common_skill_id = data.common_skill_id
	self.compat_skill_id = data.compat_skill_id
	self.morale = data.morale
	self.status = data.status
	self.equip = data.equip
	self.soul = data.soul
	if data.medal then
		self.medal = data.medal
	end
	self.passenger = data.passenger
	-- local config soulD
	self.typeName = self.typeNameList[data.type]

	self.des = self.tankConfig.desc
	-- 减免地方暴击率
	self.crit_reduction = data.crit_reduction and data.crit_reduction/10 or 0

	-- 命中率
	self.hit = data.hit_plus and data.hit_plus/10 or math.floor(100+qy.Config.talent[tostring(self.talent_id)].hit_plus/10)
	-- 闪避率
	self.dodge = data.dodge_rate and data.dodge_rate/10 or qy.Config.talent[tostring(self.talent_id)].dodge_rate/10
	-- 暴击
	self.crit_rate = data.crit_rate and data.crit_rate/10 or qy.Config.talent[tostring(self.talent_id)].crit_rate/10
	-- 天赋
	self.talent = qy.tank.entity.TalentEntity.new(tostring(data.talent_id))
	-- 技能
	self.commonSkill = qy.tank.entity.SkillEntity.new(tostring(data.common_skill_id))
	self.compatSkill = qy.tank.entity.SkillEntity.new(tostring(data.compat_skill_id))
	self:setproperty("advance_level", data.advance_level or 0) -- 进阶等级

	self.reform_stage = data.reform_stage or 0 --坦克改造次数
end

function OtherTankEntity:__initByID(id)
	self.tankConfig = qy.tank.config.MonsterConfig.getItem(self.monster_type,tostring(id))
	-- print(qy.json.encode(self.tankConfig))
	local data = self.tankConfig

	self.tank_id = id
	self.unique_id = nil
	self:setproperty("level", 1)
	self:setproperty("name", data.name)
	self:setproperty("type", data.type)
	self:setproperty("star", data.star)
	self:setproperty("quality", data.quality)
	self.typeName = self.typeNameList[data.type]
	self.location = qy.Config.tank_res[tostring(self.tankConfig.icon)].location

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
	self.des = self.tankConfig.desc
	-- 技能
	self.commonSkill = qy.tank.entity.SkillEntity.new(tostring(data.common_skill_id))
	self.compatSkill = qy.tank.entity.SkillEntity.new(tostring(data.compat_skill_id))

	-- 闪避率
	self.dodge = data.dodge and data.dodge/10 or qy.Config.talent[tostring(self.talent_id)].dodge_rate/10

	-- 暴击
	self.crit_rate = data.crit_rate and data.crit_rate/10 or qy.Config.talent[tostring(self.talent_id)].crit_rate/10

	-- 命中率
	self.hit = data.hit and data.hit/10 or math.floor(100+qy.Config.talent[tostring(self.talent_id)].hit_plus/10)
	-- 减免地方暴击率
	self.crit_reduction = data.crit_reduction and data.crit_reduction/10 or 0
	
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

	self.advanceData = qy.tank.model.AdvanceModel:getAdvanceAddList(self) or {}
	self.passiveSkillsData = qy.tank.model.AdvanceModel:getPassiveSkillsAddList(self) or {}
	self.advanceCommonData = qy.tank.model.AdvanceModel:atCommonAttr(self.advance_level) or {}

	self.reform_stage = 0 --坦克改造次数
end

--[[
	获取改造后提升的系数
	参数 _stage: 当 _stage 为 nil 时，表示获取坦克档期的改造次数对应的提升系数
]]--
function OtherTankEntity:getReformRatio(_stage)
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
function OtherTankEntity:getNextReformRatio()
	if self.reform_stage then
		return self:getReformRatio(self.reform_stage + 1)
	else
		return self:getReformRatio(1)
	end
end

-- 当前等级是否需要改造
function OtherTankEntity:isNeedReform()
	if self.level%5 == 0 then
		local data = qy.Config.tank_reform
		local _stage = self.reform_stage
		if _stage == nil then
			_stage = 1
		else
			_stage = _stage + 1
		end

		if self.level >= data[tostring(_stage)] then
			-- 如果当前的等级 大于或等于下一次改造提升的等级，且是 5 的倍数，则需要改造
			return true
		else
			return false
		end
	else
		-- 不是 5 的倍数
		return false
	end
end

-- 获取战车总攻击力
function OtherTankEntity:getTotalAttack()
	return self.basic_attack or 0
end

-- 获取战车总防御力
function OtherTankEntity:getTotalDefense()
	return self.basic_defense or 0
end

-- 获取战车总血量
function OtherTankEntity:getTotalBlood()
	return self.basic_blood or 0
end

-- 获取战车总暴击率(%)
function OtherTankEntity:getTotalCritRate()
	return self.crit_rate or 0
end

-- 获取战车初始攻击力
function OtherTankEntity:getInitialAttack()
	-- return self.initial_attack or 0
	return self.basic_attack or 0
end

-- 获取战车初始防御力
function OtherTankEntity:getInitialDefense()
	-- return self.initial_defense or 0
	return self.basic_defense or 0
end

-- 获取战车初始血量
function OtherTankEntity:getInitialBlood()
	-- return self.initial_blood or 0
	return self.basic_blood or 0
end

function OtherTankEntity:getInitialCritDoubleRate()
	return 1.5
end

function OtherTankEntity:getInitialCritRate()
	return self.talent.crit_rate/10
end

-- 暴击伤害翻倍率(暴击伤害)
function OtherTankEntity:getCritDoubleRate()
	return 1.5
end

-- 闪避概率千分率
function OtherTankEntity:getDodgeRate()
	return self.dodge or 0
end

-- 抗晕概率=缴械命中千分率
function OtherTankEntity:getDisarmAnti()
	return self.disarm_anti or 0
end

-- 获取穿深值
function OtherTankEntity:getWear()
	return self.wear or 0
end

function OtherTankEntity:getHit()
	return self.hit or 0
end

function OtherTankEntity:getAnti_wear()
	return self.anti_wear or 0
end

function OtherTankEntity:getTotalCritReductionRate()
	return self.crit_reduction or 0
end

-- 战斗力
-- 公式：穿深战力系数*暴击战力系数*暴击伤害战力系数*面板攻击力*攻击战力系数 + 命中战力系数*闪避战力系数*抗晕战力系数*穿深抵抗战力系数*面板防御力*防御战力系数 + 面板生命值*生命战力系数
function OtherTankEntity:getPower()
	return self.power or 0
end

--获取他人装备实体table
function OtherTankEntity:getOtherEquipEntity()
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

--获取装备实体table
function OtherTankEntity:getEquipEntity()
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

--获取装备实体
function OtherTankEntity:getEquipEntityList()
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

--获取他人军魂
function OtherTankEntity:getOtherSoulInfo()
	local soulData = self.soul
	return soulData
end

-- 获取战斗形象
function OtherTankEntity:getAvatar()
	local id = self.tankConfig.icon
	return "t"..id
end

-- 获取特写大图
function OtherTankEntity:getImg()
	local id = self.tankConfig.icon
	local res
	if id < 86 then
		res = "tank/img/img_t"..id..".jpg"
	else
		res = "tank/img/img_t"..id..".png"
	end
	print("OtherTankEntity:getImg",res)
	return res
end

--获取大图坐标
function OtherTankEntity:getImgPosition()
	local imgPosition = qy.Config.tank_res[tostring(self.tankConfig.icon)].img[1]
	return cc.p(imgPosition)
end

-- 获得icon
function OtherTankEntity:getIcon()
	local id = self.tankConfig.icon
	return "tank/icon/icon_t"..id..".png"
end

-- 获得卡片
function OtherTankEntity:getCard()
	local id = self.tankConfig.icon
	return "tank/card/card_t"..id..".jpg"
end

function OtherTankEntity:getIconBg()
	local quality = self:get("quality")
	-- 白绿蓝紫橙
	if quality == 1 or quality == "1" then
		return "tank/bg/bg1.png"
	elseif quality == 2 or quality == "2" then
		return "tank/bg/bg2.png"
	elseif quality == 3 or quality == "3" then
		return "tank/bg/bg3.png"
	elseif quality == 4 or quality == "4" then
		return "tank/bg/bg4.png"
	elseif quality == 5 or quality == "5" then
		return "tank/bg/bg5.png"
	elseif tostring(quality) == "6" then
		return "tank/bg/bg6.png"
	end
end

function OtherTankEntity:getCardFrame()
	local quality = self:get("quality")
	-- 白绿蓝紫橙
	if quality == 1 or quality == "1" then
		return "tank/frame/card_frame_1.png"
	elseif quality == 2 or quality == "2" then
		return "tank/frame/card_frame_2.png"
	elseif quality == 3 or quality == "3" then
		return "tank/frame/card_frame_3.png"
	elseif quality == 4 or quality == "4" then
		return "tank/frame/card_frame_4.png"
	elseif quality == 5 or quality == "5" then
		return "tank/frame/card_frame_5.png"
	elseif tostring(quality) == "6" then
		return "tank/frame/card_frame_6.png"
	end
end

function OtherTankEntity:getFontColor()
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
	elseif tostring(quality) == "6" then
		return cc.c4b(251, 48, 0,255)
	end
end

function OtherTankEntity:getResID()
	return self.tankConfig.icon
end

function OtherTankEntity:getResPrefix(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b"
	end
end

function OtherTankEntity:getBodyRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b.png"
	end
end

function OtherTankEntity:getBarrelRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a_1.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b_1.png"
	end
end

function OtherTankEntity:getDieRes(direction)
	if direction == 1 then
		return "t"..self.tankConfig.icon.."_a_die.png"
	elseif direction == 2 then
		return "t"..self.tankConfig.icon.."_b_die.png"
	end
end

function OtherTankEntity:getSealIcon()
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

return OtherTankEntity
