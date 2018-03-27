--[[
	战斗中tank vo
	Author: Aaron Wei
	Date: 2015-04-08 17:25:32
]]
local BattleTankEntity = class("BattleTankEntity")

--[[
	type:1坦克，2怪物
]]
function BattleTankEntity:ctor(data,direction,monsterType)
	for k,v in pairs(data) do
		self[k] = v
	end

	-- 当后端数据无最大血量时默认初始化血量为最大血量
	if data.max_blood == nil then
		self.max_blood = data.blood
	end

	self.direction = direction
	self.monsterType = monsterType
	
	if self.icon == nil then
		-- 后端没有传icon数据时读配置表
		if direction == 1 then
			if monsterType == 7 then
				self.icon = qy.tank.config.MonsterConfig.getItem(monsterType,self.tank_id).icon
			else
				self.icon = qy.tank.config.MonsterConfig.getItem(0,self.tank_id).icon
			end
		else
			if self.kid <= 10000 then
				-- 怪物表
				self.icon = qy.tank.config.MonsterConfig.getItem(monsterType,self.tank_id).icon
			else
			 	-- AI表
				self.icon = qy.tank.config.MonsterConfig.getItem(0,self.tank_id).icon
			end
		end
	end

	self.res = qy.Config.tank_res[tostring(self.icon)]

end

function BattleTankEntity:getResID()
	return self.icon
end

-- 获取战斗形象
function BattleTankEntity:getResPrefix()
	if self.direction == 1 then
		return "t"..self.icon.."_a"
	elseif self.direction == 2 then
		return "t"..self.icon.."_b"
	end
end

function BattleTankEntity:getBodyRes()
	if self.direction == 1 then
		return "t"..self.icon.."_a.png"
	elseif self.direction == 2 then
		return "t"..self.icon.."_b.png"
	end
end

function BattleTankEntity:getBarrelRes()
	if self.direction == 1 then
		return "t"..self.icon.."_a_1.png"
	elseif self.direction == 2 then
		return "t"..self.icon.."_b_1.png"
	end
end

function BattleTankEntity:getDieRes()
	if self.direction == 1 then
		return "t"..self.icon.."_a_die.png"
	elseif self.direction == 2 then
		return "t"..self.icon.."_b_die.png"
	end
end

function BattleTankEntity:getWheelPos()
	return self.res.wheel_pos[self.direction]
end

function BattleTankEntity:getWheelScale()
	if self.direction == 1 then
		return self.res.wheel_scale*0.5
	else
		return -1*self.res.wheel_scale*0.5
	end
end

function BattleTankEntity:getBuffPos()
	return self.res.buff_pos
end

function BattleTankEntity:getAttID()
	return self.res.att_id
end

function BattleTankEntity:getAttPos()
	return self.res.att_anchor[self.direction]
end

function BattleTankEntity:getAttRotation()
	return tonumber(self.res.att_rotation[self.direction])
end

function BattleTankEntity:getAttScale()
	return self.res.att_scale
end

function BattleTankEntity:getDefPos()             
	return self.res.def_anchor[1]
end

function BattleTankEntity:getDefRotation()
	return 0
end

function BattleTankEntity:getDefScale()
	-- return self.res.def_scale
	return 1
end

function BattleTankEntity:getAttackSkillID()	
end

function BattleTankEntity:getAttackSkillRes()
end

return BattleTankEntity