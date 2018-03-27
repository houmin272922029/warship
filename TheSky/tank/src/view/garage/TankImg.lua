--[[
	坦克静态图片类
	Author: Aaron Wei
	Date: 2015-03-26 11:32:04
]]

local TankImg = class("TankImg",function()
	return cc.Node:create()
end)

function TankImg:ctor(entity,direction,idx)
	qy.tank.utils.cache.CachePoolUtil.addPlist("tank/avatar/t"..entity:getResID())

	-- 底层
	self.bottom = cc.Node:create()
	self:addChild(self.bottom,0)
	-- 中间层
	self.middle = cc.Node:create()
	self:addChild(self.middle,10)
	-- 顶层
	self.top = cc.Node:create()
	self:addChild(self.top,100)

	self.direction = direction --方向1左2右
	self.body,self.barrel = nil

	-- 索引标签
	if qy.DEBUG and false then
		self.indexLabel = cc.Label:createWithSystemFont("","Helvetica", 20.0,cc.size(50,30),1)
	    self.indexLabel:setTextColor(cc.c4b(255,255,0,255))
	    self.indexLabel:setAnchorPoint(0.5,0)
	    self.indexLabel:setPosition(0,10)
	    self:addChild(self.indexLabel,1000)
 	end
	self:setIdx(idx)

	self.entity = entity
	self:create(entity)
end

-- 创建
function TankImg:create(entity)
	self.id = entity.tank_id
	local res_id = entity.tankConfig.icon
	self.resConfig = qy.Config.tank_res[tostring(res_id)]
	
    -- 坦克名标签 
	local pos = self.resConfig.buff_pos
	self.nameLabel = cc.Label:createWithTTF(entity.name,qy.res.FONT_NAME, 24.0,cc.size(240,0),1)
	self.nameLabel:enableOutline(cc.c4b(0,0,0,225),1)
    self.nameLabel:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))
    self.nameLabel:setAnchorPoint(0.5,0)
    self.nameLabel:setPosition(0,tonumber(pos.y))
    self.top:addChild(self.nameLabel)
	
	-- 机身
	self.body = ccui.ImageView:create(entity:getBodyRes(self.direction),ccui.TextureResType.plistType) 
	self.middle:addChild(self.body)
	self.body:setScale(1)
	-- 机身中心点
	if qy.DEBUG and false then
		local p = cc.DrawNode:create()
		p:drawDot({cc.p(0,0)},5,cc.c4b(1,0,0,1))
		self:addChild(p,999)
	end

	-- 炮管
	if not self.barrel then
		self.barrel = ccui.ImageView:create(entity:getBarrelRes(self.direction),ccui.TextureResType.plistType) 
		self.middle:addChild(self.barrel) 
	end 

	-- 血量条标签
	self.bloodBar = qy.tank.widget.progress.BattleBloodBar.new()
	self.bloodBar:setAnchorPoint(0,0)
    self.bloodBar:setPosition(-47,tonumber(pos.y)-2)
    self.top:addChild(self.bloodBar) 
	self.bloodBar:setPercent(1,false)

    -- 士气条标签
	self.moraleBar = qy.tank.widget.progress.BattleMoraleBar.new()
    self.moraleBar:setAnchorPoint(0,0)
    self.moraleBar:setPosition(-47,tonumber(pos.y)-12)
    self.top:addChild(self.moraleBar) 

     -- 已阵亡标签
	self.dieLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(14012),"Helvetica", 26.0,cc.size(100,40))
    self.dieLabel:setTextColor(cc.c4b(212,95,95,255))
    self.dieLabel:setAnchorPoint(0.5,0)
    self.dieLabel:setPosition(10,10)
    self.top:addChild(self.dieLabel) 
    self.dieLabel:setString(qy.TextUtil:substitute(14012))
    
  	self:showBloodAndMorale(false)
end

-- 设置战车状态 0:阵亡 1:激活 
function TankImg:setStatus(s)
	local res_id = self.entity:getAvatar()
	local d = (self.direction == 1 and "a") or "b"
	if s == 0 then
		-- 机身
		self.body:loadTexture(res_id.."_"..d.."_die.png",ccui.TextureResType.plistType)
		-- 炮管
		if tolua.cast(self.barrel,"cc.Node") then
			if self.barrel:getParent() then
				self.middle:removeChild(self.barrel) 
			end
			self.barrel = nil
		end
	elseif s == 1 then
		-- 机身
		self.body:loadTexture(res_id.."_"..d..".png",ccui.TextureResType.plistType)
		-- 炮管
		if not self.barrel then
			self.barrel = ccui.ImageView:create(res_id.."_"..d.."_5.png",ccui.TextureResType.plistType) 
			self.middle:addChild(self.barrel) 
		end 
	end
end

--显示血条或士气
function TankImg:showBloodAndMorale( show , isDied)
	self.bloodBar:setVisible(show)
	self.moraleBar:setVisible(show)
	self.dieLabel:setVisible(show)
	local pos = self.resConfig.buff_pos
	if show then 
		if isDied then
			self.dieLabel:setVisible(true)
			self.moraleBar:setVisible(false)
			self.bloodBar:setVisible(false)
		else
			self.bloodBar:setVisible(true)
			self.moraleBar:setVisible(true)
			self.dieLabel:setVisible(false)
		end
		self.nameLabel:setPosition(0,tonumber(pos.y) + 10)
	else
		self.nameLabel:setPosition(0,tonumber(pos.y))
	end

end

--更新hp
function TankImg:updateHp( current , max)
	self.bloodBar:setPercent(current/max,false)
end

-- 更新士气
function TankImg:updateMorale( current , max )
	self.moraleBar:setPercent(current/max,false)
end

-- 销毁
function TankImg:destroy()
	if tolua.cast(self.barrel,"cc.Node") then
		self.barrel:remove()
	end

	if self:getParent() then
		self:getParent():removeChild(self)
	end
	self = nil
end

function TankImg:setTouchEnabled(enable)
	self.body:setTouchEnabled(enable)
	if tolua.cast(self.barrel,"cc.Node") then
		self.barrel:setTouchEnabled(enable)
	end
end

function TankImg:setSwallowTouches(needSwallow)
	self.body:setSwallowTouches(needSwallow)
	if tolua.cast(self.barrel,"cc.Node") then
		self.barrel:setSwallowTouches(needSwallow)
	end
end

function TankImg:addTouchEventListener(callback)
	self.body:addTouchEventListener(callback)
	-- self.barrel:addTouchEventListener(callback)
end

function TankImg:setIdx(idx)
	self.idx = idx
	if qy.DEBUG and false then
		self.indexLabel:setString(tostring(idx))
	end
end

return TankImg
