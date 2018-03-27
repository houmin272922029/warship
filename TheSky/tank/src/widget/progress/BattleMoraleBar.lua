--[[
	战斗坦克士气条
	Author: Aaron Wei
	Date: 2015-05-08 11:49:19
]]

local BattleBloodBar = qy.class("BattleBloodBar", qy.tank.view.BaseView, "widget/BattleMoraleBar")

function BattleBloodBar:ctor(params)
    BattleBloodBar.super.ctor(self)

    -- 背景
    self:InjectView("bg")
    for i=1,4 do
    	self:InjectView("bar"..i)
    end
    self.percent = 0
end

function BattleBloodBar:setPercent(v)
    self.percent = v
    for i=1,4 do
    	local seg = self["bar"..i] 
    	if i <= math.ceil(self.percent) then
    		seg:setVisible(true)
            seg:setScaleX(1)
        else
            seg:setVisible(false)
            seg:setScaleX(1)
    	end
    end

    if v < 4 and v > math.floor(v) and v < math.ceil(v) then
        self["bar"..math.ceil(v)]:setScaleX(v - math.floor(v))
    end
end

function BattleBloodBar:getPercent()
	return self.percent
end

return BattleBloodBar