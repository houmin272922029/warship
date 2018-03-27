--[[--
--二选一cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--
local ChooseAwardCell = qy.class("ChooseAwardCell", qy.tank.view.BaseView)

function ChooseAwardCell:ctor(delegate)
    ChooseAwardCell.super.ctor(self)
   	local tipSp = cc.Sprite:createWithSpriteFrameName("Resources/common/img/topup_rebate_0004.png")
   	tipSp:setLocalZOrder(20)
    self:addChild(tipSp)
    local _x = -111
    local _w = 220
    local _y = -60

   	local function callback(_i)
      self.chooseIdx = _i
      tipSp:setPosition((_i -1) *_w + _x, _y)
   	end

   	self.btn = {}

    for i = 1, #delegate.award do
    	self.btn[i] = qy.tank.view.common.AwardItem.createAwardView(delegate.award[i] ,1,1, false , function ()
    		callback(i)
    	end)
    	self:addChild(self.btn[i])
      self.btn[i]:setPosition((i -1) *_w + _x, _y)
    	self.btn[i]:setTitlePosition(2)
    end

    callback(1)

    local scaleSmall = cc.ScaleTo:create(1.2,0.9)
    local scaleBig = cc.ScaleTo:create(1.2,1)
    local FadeIn = cc.FadeTo:create(1.2, 255)
    local FadeOut = cc.FadeTo:create(1.2, 125)
    local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
    local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
    local seq = cc.Sequence:create(spawn1, spawn2)
    tipSp:runAction(cc.RepeatForever:create(seq))
end

return ChooseAwardCell