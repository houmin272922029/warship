--[[
	竞技场list cell
	Author: Aaron Wei
	Date: 2015-05-26 20:40:41
]]

local ArenaCell = qy.class("ArenaCell", qy.tank.view.BaseView, "view/arena/ArenaCell")

function ArenaCell:ctor(delegate)
    ArenaCell.super.ctor(self)

	self._type = delegate.type
	self.my_kid = delegate.kid
	
	self:InjectView("bg")
	self:InjectView("icon")
	self:InjectView("btn")
	self:InjectView("player")
	self:InjectView("rank")
	self:InjectView("fight_power")

    if not self.tankList then
		self.tankList = {}
		for i=1,4 do
			local tankIcon = qy.tank.view.garage.GarageTankCell.new():setShowLevel(false)
			self:addChild(tankIcon,0)
			tankIcon:setPosition(50+210*(i-1),20)
			table.insert(self.tankList,tankIcon)
		end
	end

	self:OnClick("btn",function()
		if self._type == 1 then
			if self.entity.kid == self.my_kid then
				-- 布阵
				qy.tank.command.GarageCommand:showFormationDialog(data)
			else
				-- 挑战
				delegate.challenge(self.entity.rank)
			end
		elseif self._type == 2 then
			-- 查看
			delegate.look(self.entity)
		end
		-- 布阵
    end)
	self.icon:setLocalZOrder(7)
    -- self.icon:retain()
    -- self.icon:getParent():removeChild(self.icon)
    -- self:addChild(self.icon)
    -- self.icon:release()
end

function ArenaCell:render(entity)
	self.entity = entity
	if entity then
		self.icon:setSpriteFrame(entity.icon)
		-- self.icon:initWithSpriteFrameName(entity.icon)
		self.player:setString(entity.nickname.."  LV."..tostring(entity.level))

		if self._type == 1 then
			if entity.kid == self.my_kid then
				self.btn:loadTextures("Resources/common/button/btn_4.png","Resources/common/button/anniulan02.png",nil,1)
				self.btn:setTitleText(qy.TextUtil:substitute(4001))
			else
				self.btn:loadTextures("Resources/common/button/btn_3.png","Resources/common/button/anniuhong02.png",nil,1)
				self.btn:setTitleText(qy.TextUtil:substitute(4004))
			end
		elseif self._type == 2 then
			self.btn:loadTextures("Resources/common/button/btn_4.png","Resources/common/button/anniulan02.png",nil,1)
			self.btn:setTitleText(qy.TextUtil:substitute(4002))
		end

		cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/arena/arena.plist")
		if self.my_kid == entity.kid then
			self.bg:loadTexture("Resources/arena/JJC_cell2.png",1)
		else
			self.bg:loadTexture("Resources/arena/JJC_cell1.png",1)
		end  

		self.rank:setString(qy.TextUtil:substitute(4003, entity.rank))
		self.fight_power:setString(qy.TextUtil:substitute(4005)..tostring(entity.fight_power))
		-- self.fightPower:update(tostring(entity.fight_power))

		if entity.rank == 1 then
			self.icon:setPosition(90,170)
		elseif entity.rank == 2 then
			self.icon:setPosition(90,180)
		elseif entity.rank == 3 then
			self.icon:setPosition(90,180)
		else
			self.icon:setPosition(70,153)
		end

		for i=1,4 do
			local tankIcon = self.tankList[i]
			if entity.formation[i] then
				tankIcon:render(entity.formation[i])
				tankIcon:setShowLevelBg(false)
				tankIcon:setVisible(true)
			else
				tankIcon:setVisible(false)
			end
		end
	end
end

function ArenaCell:hightLight()
	self:setColor(cc.c4b(200,200,200,255))
	self.bg:setScale(0.99)
end

function ArenaCell:unhightLight()
	self:setColor(cc.c4b(255,255,255,255))
	self.bg:setScale(1)
end

return ArenaCell                   
