--[[
	坦克阵型
	Author: Your Name
	Date: 2015-01-20 17:19:59
]]

local TankFormation = class("TankFormation",function()
	return cc.DrawNode:create()
end)

function TankFormation:ctor(direction)
	self.model = qy.tank.model.BattleModel
	self.direction = nil -- 阵型方位1：左边我方，2：右边敌方
	self.gridList = nil -- 网格一维存储
	self.gridTile = nil -- 网格二维存储
	self.tankList = nil -- 坦克一维存储
	self.nodeList = nil -- 占位容器
	self:create(direction)
end

function TankFormation:create(direction)
	self.direction = direction
	self.gridList = {}
	self.gridTile = {}
	self.tankList = {}
	self.nodeList = {}
	self:calculateGrid(direction)
	-- self:drawGrid()
	self:createNode()
	self:createTank()
end

-- 计算网格数据并存储
function TankFormation:calculateGrid()
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	local cellSize_w = qy.BattleConfig.FORMATION_CELL_SIZE.width
	local cellSize_h = qy.BattleConfig.FORMATION_CELL_SIZE.height
	local angle1 = qy.BattleConfig.FORMATION_ANGLE1
	local angle2 = qy.BattleConfig.FORMATION_ANGLE2
	local px1,py1 = qy.BattleConfig.P1.x,qy.BattleConfig.P1.y
	local px2,py2 = qy.BattleConfig.P2.x,qy.BattleConfig.P2.y	

	if self.direction == 1 then -- 左边我方
	    for i=1,rows do
	    	self.gridTile[i] = {}
	    	for j=1,cols*2 do
	    		self.gridList[(i-1)*cols*2+j] = cc.p((j-1)*cellSize_w*math.cos(angle1)-(i-1)*cellSize_h*math.cos(math.pi-angle1-angle2)+px1,-(j-1)*cellSize_w*math.sin(angle1)-(i-1)*math.sin(math.pi-angle1-angle2)*cellSize_h+py1)	 
	    		self.gridTile[i][j] = cc.p((j-1)*cellSize_w*math.cos(angle1)-(i-1)*cellSize_h*math.cos(math.pi-angle1-angle2)+px1,-(j-1)*cellSize_w*math.sin(angle1)-(i-1)*math.sin(math.pi-angle1-angle2)*cellSize_h+py1)	 
	    	end	
	    end
	elseif self.direction== 2 then -- 右边敌方
	    for i=1,rows do
	    	self.gridTile[i] = {}
	    	for j=1,cols*2 do
			    self.gridList[(i-1)*cols*2+j] = cc.p((j-1)*cellSize_w*math.cos(angle1)+(i-1)*cellSize_h*math.cos(math.pi-angle1-angle2)+px2,-(j-1)*cellSize_w*math.sin(angle1)+(i-1)*math.sin(math.pi-angle1-angle2)*cellSize_h+py2)
			    self.gridTile[i][j] = cc.p((j-1)*cellSize_w*math.cos(angle1)+(i-1)*cellSize_h*math.cos(math.pi-angle1-angle2)+px2,-(j-1)*cellSize_w*math.sin(angle1)+(i-1)*math.sin(math.pi-angle1-angle2)*cellSize_h+py2)
	    	end
	    end
	end
end

-- 绘制网格
function TankFormation:drawGrid()
    gl.lineWidth(10)
	local color = cc.c4b(0,1,0,1)
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	local p1,p2
	-- 划行
	for i=1,rows do
		p1 = self.gridTile[i][1]
		p2 = self.gridTile[i][cols*2]
		self.drawLine(self,p1,p2,color)
    end
	-- 划列
	for j=1,cols*2 do
		p1 = self.gridTile[1][j]
		p2 = self.gridTile[rows][j]
		self:drawLine(p1,p2,color)
	end
end

function TankFormation:createNode()
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	-- 初始化站位节点
	for i=1,rows*cols do
    	local node = cc.Node:create()
    	node.index = i
    	self.nodeList[i] = node
    end
    self:arrangeNode()
end

-- 创建坦克并排列
function TankFormation:createTank()
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	-- 初始化坦克
	for i=1,rows*cols do
		local data = self.model["tankDataList"..self.direction][i]
		if data then
			local tank
			-- if data:getResID() == 59 then
			if self.direction == 2 and self.model.fight_type == 10 then
				-- world boss
				tank = qy.tank.view.battle.WorldBoss.new(data,i)
				-- tank = qy.tank.view.battle.LegionBoss.new(data,i)
		    	tank:setIndex(i)
		    	tank:setScale(qy.BattleConfig.TANK_SCALE)
		    	self.tankList[i] = tank
		    	self.model["tankList"..self.direction][i] = tank
		    elseif self.direction == 2 and self.model.fight_type == 32 then
				-- 圣诞 boss
				tank = qy.tank.view.battle.ChristmasBoss.new(data,i)
				print("TankFormation111",i)
		    	tank:setIndex(i)
		    	tank:setScale(qy.BattleConfig.TANK_SCALE)
		    	self.tankList[i] = tank
		    	self.model["tankList"..self.direction][i] = tank
		    elseif self.direction == 2 and self.model.fight_type == 13 then
				-- legion boss
				tank = qy.tank.view.battle.LegionBoss.new(data,i)
		    	tank:setIndex(i)
		    	tank:setScale(qy.BattleConfig.TANK_SCALE)
		    	self.tankList[i] = tank
		    	self.model["tankList"..self.direction][i] = tank
			else
				-- 坦克
		    	tank = qy.tank.view.battle.Tank.new(data,i)
		    	tank:setIndex(i)
		    	tank:setRotation(qy.BattleConfig.TANK_ROTATION) 
		    	tank:setScale(qy.BattleConfig.TANK_SCALE)
		    	self.tankList[i] = tank
		    	self.model["tankList"..self.direction][i] = tank
			end 
		else
			self.tankList[i] = 0
			self.model["tankList"..self.direction][i] = 0
		end
    end
	-- self.model["tankList"..self.direction] = self.tankList
    self:arrangeTank()
end

function TankFormation:arrangeNode()
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	self:arrange(self.nodeList,rows,cols)
end

function TankFormation:arrangeTank()
	local rows,cols = qy.tank.config.BattleConfig.FORMATION_ROWS,qy.tank.config.BattleConfig.FORMATION_COLS
	self:arrange(self.tankList,rows,cols)
end

function TankFormation:arrange(list,rows,cols)
	if self.direction == 1 then
	    for i=1,rows do
	    	if i%2 == qy.BattleConfig.FORMATION_SORT_TYPE then
				-- 奇数行 
		    	for j=1,cols*2,2 do
		    		local idx = (i-1)*cols+(j+1)/2
		    		local target = list[idx]
		    		if self.model["tankDataList"..self.direction][idx] then
				    	self.model["tankDataList"..self.direction][idx].origin = self.gridTile[i][j]
		    		end
		    		if tolua.cast(target,"cc.Node") then
				    	-- 存储原始坐标
				    	target.origin = self.gridTile[i][j]	
				    	target:setPosition(target.origin)
				    	self:addChild(target)
		    		end
	    		end
	    	else
    			-- 偶数行
		    	for j=2,cols*2,2 do
		    		local idx = (i-1)*cols+j/2
		    		local target = list[idx]
		    		if self.model["tankDataList"..self.direction][idx] then
				    	self.model["tankDataList"..self.direction][idx].origin = self.gridTile[i][j]
		    		end
		    		if tolua.cast(target,"cc.Node") then
				    	-- 存储每辆坦克的原始坐标
				    	target.origin = self.gridTile[i][j]	
				    	target:setPosition(target.origin)
				    	self:addChild(target)
		    		end
		    	end	
	    	end
	    end
	elseif self.direction == 2 then
	    for i=1,rows do
			if i%2 ~= qy.BattleConfig.FORMATION_SORT_TYPE then
				-- 奇数行 
		    	for j=1,cols*2,2 do
		    		local idx = (i-1)*cols+(j+1)/2
		    		local target = list[idx]
		    		if self.model["tankDataList"..self.direction][idx] then
				    	self.model["tankDataList"..self.direction][idx].origin = self.gridTile[i][j]
		    		end
		    		if tolua.cast(target,"cc.Node") then
				    	-- 存储原始坐标
				    	target.origin = self.gridTile[i][j]	
				    	target:setPosition(target.origin)
				    	self:addChild(target)
			    	end
	    		end
	    	else
    			-- 偶数行
		    	for j=2,cols*2,2 do
		    		local idx = (i-1)*cols+j/2
		    		local target = list[idx]
		    		if self.model["tankDataList"..self.direction][idx] then
				    	self.model["tankDataList"..self.direction][idx].origin = self.gridTile[i][j]
		    		end
		    		if tolua.cast(target,"cc.Node") then
				    	-- 存储每辆坦克的原始坐标
				    	target.origin = self.gridTile[i][j]	
				    	target:setPosition(target.origin)
				    	self:addChild(target)
			    	end
		    	end	
	    	end
	    end
	end
	self:sortZOrder(list)
end

function TankFormation:sortZOrder(list)
	local order = qy.BattleConfig.FORMATION_ZORDER_TO_INDEX[self.direction] 
	for i=1,#order do
		local target = list[order[i]]
		if tolua.cast(target,"cc.Node") then
			target:setLocalZOrder(i)
		end
	end
end	

function TankFormation:moveToStage()
	local distance = 500
	local angle = math.pi - qy.BattleConfig.FORMATION_ANGLE1 - qy.BattleConfig.FORMATION_ANGLE2
	if self.direction == 1 then
    	self:setPosition(-math.cos(angle)*distance,-math.sin(angle)*distance)
    else
    	self:setPosition(math.cos(angle)*distance,math.sin(angle)*distance)
    end
   	local act = cc.MoveTo:create(0.5,cc.p(0,0))
	local function callback()
	end
    local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
	self:runAction(seq)
	qy.QYPlaySound.playEffect(qy.SoundType.T_MOVE)
end

function TankFormation:removeFromStage()
end

function TankFormation:update()

end

function TankFormation:play()
	for i=1,#self.tankList do
		local tank = self.tankList[i]
		if tolua.cast(tank,"cc.Node") then
			tank:play()
		end
	end
end

function TankFormation:stop()
	for i=1,#self.tankList do
		local tank = self.tankList[i]
		if tolua.cast(tank,"cc.Node") then
			tank:stop()
		end
	end
end

function TankFormation:destroy()
	for i=1,#self.tankList do
		local tank = self.tankList[i]
		if tolua.cast(tank,"cc.Node") then
			tank:destroy()
		end
	end
	if self:getParent() then
		self:getParent():removeChild(self)
		self = nil
	end
end

function TankFormation:addTanks(data,callback)
	for k,v in pairs(data) do
		local entity = self.model["tankDataList"..self.direction][k]
		self:addTank(entity,tonumber(k))
	end		
end

function TankFormation:addTank(entity,i)
	local tank = qy.tank.view.battle.Tank.new(entity,self.direction,i)
	tank:setIndex(i)
	tank:setRotation(qy.BattleConfig.TANK_ROTATION) 
	tank:setScale(qy.BattleConfig.TANK_SCALE)
	self.model["tankList"..self.direction][i] = tank
	self:addChild(tank)
	local order = qy.BattleConfig.FORMATION_INDEX_TO_ZORDER[self.direction] 
	tank:setLocalZOrder(order[i])
	tank:setPosition(self.nodeList[i]:getPosition())
	tank.origin = self.nodeList[i].origin
	tank:play()
	self:move(tank)
end

function TankFormation:removeTanks(data,callback)
	for k,v in pairs(data) do
		self:removeTank(tonumber(v.pos))
	end		
end

function TankFormation:removeTank(i)
	local tank = self.model["tankList".. self.direction][i]
	table.remove(self.model["tankList"..self.direction],i)
	-- self:removeChild(tank)
	tank:retreat()
end

-- 补充的坦克驶入阵型
function TankFormation:move(target,callback)
	local distance = 200
	local px1,py1 = target:getPosition()
	local px2,py2
	-- local angle = qy.BattleConfig.MAP_MOVE_ANGLE
	local angle = self.model:getMovementAngle(self.direction)
	if self.direction == 1 then
		px2,py2 = px1-math.cos(angle)*distance,py1-math.sin(angle)*distance
	else
		px2,py2 = px1+math.cos(angle)*distance,py1+math.sin(angle)*distance
	end
	target:setPosition(px2,py2)
	local act = cc.MoveTo:create(0.5,cc.p(px1,py1))
	if callback then
		local seq = cc.Sequence:create(act,cc.CallFunc:create(callback))
		target:runAction(seq)
	else
		target:runAction(act)
	end
end

return TankFormation