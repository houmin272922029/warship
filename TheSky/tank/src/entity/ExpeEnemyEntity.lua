--[[
    远征敌人 实体
    Author: H.X.Sun
    Date: 2015-04-18
]]
local ExpeEnemyEntity = qy.class("ExpeEnemyEntity", qy.tank.entity.BaseEntity)

function ExpeEnemyEntity:ctor(_type, data, index)
	-- print("index =======", index)
	-- print("_type =======", _type)
	-- print("data =======", qy.json.encode(data))
	self.cType = _type
	if _type == 0 then
		--敌人
		self:initEnemy(data,index)
	else
		--宝箱
		self:initChest(data)
	end
end

function ExpeEnemyEntity:initEnemy(data,index)
	self.head_img = data.head_img
	self.nickname = data.nickname
	self.level = data.level
	self.tank = data.tank
	self.formation = data.formation
	self.kid = data.kid
	self.is_open = data.is_open
	self.is_pass = data.is_pass
	self.extend_data = data.extend_data
	self.index = index
	self.type = data.type
end

function ExpeEnemyEntity:isMonster()
	if self.type > 2 then
		return true
	else
		return false
	end
end

function ExpeEnemyEntity:initChest(data)
	self.id = data.id
	self.is_pass = data.is_pass
	self.is_open = data.is_open
end

function ExpeEnemyEntity:getStatus()
	if self.is_pass == 1 then
		--打开宝箱/已打过该敌人
		return 2
	elseif self.is_open == 1 then
		--正在开宝箱/正在打该敌人
		return 1 
	else
		--未轮到
		return 0
	end
end

return ExpeEnemyEntity