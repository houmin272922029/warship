--[[
	战斗结算经验条
	Author: Aaron Wei
	Date: 2015-07-24 13:55:51
]]

local BattleExpBar = qy.class("BattleExpBar", qy.tank.view.BaseView, "widget/BattleExpBar")

function BattleExpBar:ctor(params)
    BattleExpBar.super.ctor(self)

    -- 背景
    self:InjectView("bg")
    self:InjectView("exp")
    self:InjectView("level")
    self.beforePercent = nil
    self.percent = nil

    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("Resources/technology/science_icon_00029.png"))  
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(305,25)
    self:addChild(self.bar,-1)
end

--[[
	local data = {{50,100,100},{0,120,120},{0,150,150},{0,100,200}}
    local data = {{50,100},{0,100},{0,100},{0,50}}
]]
function BattleExpBar:setPercent(level,data)
	local idx,len = 1,#data
	local start,ended,max
	local function setSubPercent()
		if idx <= len then
			max = data[idx][3]
			start = data[idx][1]
			ended = data[idx][2]
	    	self.bar:setPercentage(start/max*100)
	  		local to = cc.ProgressTo:create(0.5,ended/max*100)
	  		local seq = cc.Sequence:create(to,cc.CallFunc:create(function()
	  			setSubPercent()
	  		end))
	  		self.bar:runAction(seq)
	  		idx = idx + 1
  		end
	end
	setSubPercent()

	self.level:setString("Lv."..level)
	if len <= 1 and start == ended then
		self.exp:setString(tostring(ended).."/"..tostring(max))
	else
		self.timer = qy.tank.utils.Timer.new(0.1,0,function()
			local value = math.min(math.floor(self.bar:getPercentage()*max/100),ended)
			if idx > len and value >= ended then
				self.timer:stop()
				self.exp:setString(tostring(ended).."/"..tostring(max))
			else
				self.exp:setString(tostring(value).."/"..tostring(max))
			end
		end)
		self.timer:start()
	end
end

function BattleExpBar:setPercentDirectly(value,max)
	print("BattleExpBar:setPercentDirectly",value,max)
	self.bar:setPercentage(value/max*100)
	self.exp:setString(tostring(value).."/"..tostring(max))
end

function BattleExpBar:getPercent()
	return self.percent
end

function BattleExpBar:destroy()
	if self.bar and tolua.cast(self.bar,"cc.Node") then
		self.bar:stopAllActions()
	end

	if self.timer then
		self.timer:stop()
	end
end

return BattleExpBar