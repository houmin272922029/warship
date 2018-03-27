--[[
	竞技场五连抽
	Author: Aaron Wei
	Date: 2015-05-25 16:58:36
]]

local ArenaAwardCard = qy.class("ArenaAwardCard", qy.tank.view.BaseView, "view/arena/ArenaAwardCard")

function ArenaAwardCard:ctor(delegate)
    ArenaAwardCard.super.ctor(self)

    self.delegate = delegate

    self:InjectView("card")
    self:OnClick("card",function()
    	if delegate and delegate.onClick then
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
    		self:playFx()
    		delegate.onClick(self.idx)
    	end
    end,{["isScale"] = false})
    self.card:setTouchEnabled(false)
end

function ArenaAwardCard:playFx()
	self.card:getParent():removeChild(self.card)

	local fx = ccs.Armature:create("ui_fx_fanpai")
    self:addChild(fx)
    fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
	    if movementType == ccs.MovementEventType.complete then
	    	fx:getParent():removeChild(fx)
	    	fx = nil
	    	-- self.delegate.ended(self.idx)
	    end
    end)
    fx:getAnimation():playWithIndex(0)
end

return ArenaAwardCard
