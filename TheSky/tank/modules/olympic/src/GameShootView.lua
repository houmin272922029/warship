--[[
	射击
 	Author: Aaron Wei
	Date: 2016-09-22 14:28:36
]]

local GameShootView = qy.class("GameShootView", qy.tank.view.BaseView, "olympic.ui.ShootView")

function GameShootView:ctor(delegate)
	print("GameShootView:ctor")
    GameShootView.super.ctor(self)

    self.model = qy.tank.model.OlympicModel
    self.service = qy.tank.service.OlympicService
	self.delegate = delegate
	self.count = 5
	self.trigger = false
	self.point = 0
	self.totalPoint = 0

	self:InjectView("targetCover")
	self:InjectView("targetNode")
	self:InjectView("sight")
	self:InjectView("embrasure")
	self:InjectView("gun")
	self:InjectView("tipNode")
	self:InjectView("score_win")
	self:InjectView("score_fail")
	self:InjectView("scoreBar")
	self:InjectView("score")

	self.score_win:setString("30积分")
	self.score_fail:setString("20积分")

	for i=1,3 do
		self:InjectView("target"..i)
	end

	for i=1,5 do
		self:InjectView("bullet"..i)
	end

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "olympic/res/6.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
            	self.service:score(100,self.model.key,self.model:getScore(100,self.totalPoint),self.model.times,function()
					local result = require("olympic.src.ResultDialog").new({
						["dismiss"] = self.delegate.dismiss
					})
					result:show(true)
					self:stopAction(self.act)
				end)
                -- delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self.first = true
	self:OnClick("mask",function(sender)
		if self.first then
			self.first = false
			self:play()
		else
			if self.count > 0 then
				if not self.trigger then 
					self.trigger = true
					self:shoot()
				else
					qy.hint:show("枪支冷却")
				end
			else
				qy.hint:show("射击次数已用完")
			end
		end

	end, {["isScale"] = false})

	self:init()
end


function GameShootView:init()
	self.targetCover:setVisible(true)
	self.targetNode:setVisible(false)
	self.sight:setVisible(false)
	self.embrasure:setVisible(false)
	self.tipNode:setVisible(true)
	self:updatePoint(self.totalPoint)
end


function GameShootView:play()
	print("GameShootView:play!")
	self.targetCover:setVisible(false)
	self.targetNode:setVisible(true)
	self.sight:setVisible(true)
	self.embrasure:setVisible(false)
	self.tipNode:setVisible(true)

	local px1,py1 = cc.p(-1200,110)
	local px2,py2 = cc.p(1400,110)

	self.targetNode:setPosition(cc.p(px1,py1))

	local act = cc.MoveTo:create(4,cc.p(px2,py2))

	self:update(self.count)
	self.act = cc.Repeat:create(cc.Sequence:create(act,cc.CallFunc:create(function()
		self.targetNode:setPosition(cc.p(px1,py1))
		self.embrasure:setVisible(false)
		if not self.trigger then
			self.count = self.count - 1
			self:updateBullet(self.count)
		else
			self.trigger = false
		end
		
		if self.count <= 0 then
			self.service:score(100,self.model.key,self.model:getScore(100,self.totalPoint),self.model.times,function()
				local result = require("olympic.src.ResultDialog").new({
					["dismiss"] = self.delegate.dismiss
				})
				result:show(true)
			end)
		end
	end)),5)
	self.targetNode:runAction(self.act)
end


function GameShootView:shoot()
	print("GameShootView:shoot!")
	self.targetCover:setVisible(false)
	self.targetNode:setVisible(true)
	self.sight:setVisible(true)
	self.embrasure:setVisible(false)
	self.tipNode:setVisible(false)

	local global_p = self.sight:getParent():convertToWorldSpace(cc.p(self.sight:getPosition()))
	local local_p = self.targetNode:convertToNodeSpace(global_p)
	local local_p1 = self.target1:convertToNodeSpace(global_p)
	local local_p2 = self.target2:convertToNodeSpace(global_p)
	local local_p3 = self.target3:convertToNodeSpace(global_p)
	local arr = {local_p1,local_p2,local_p3}

	self.embrasure:setPosition(local_p)
	self.embrasure:setVisible(true)

	self.point = 0
	for i=1,3 do
		local x = arr[i].x
		if x >= 179.5 - 29.5*5 and x <= 179.5 + 29.5*5 then
			self.point = 10 - math.floor(math.abs(x - 179.5)/29.5)
			break
		end
	end
	self.totalPoint = self.totalPoint + self.point

	print("GameShootView:shoot point >>>>>>>>>> ",self.point,self.totalPoint)

	self:updatePoint(self.totalPoint)
	self.count = self.count - 1
	self:updateBullet(self.count)

	qy.QYPlaySound.playEffect(qy.SoundType.T_FIRE_2)
end

function GameShootView:updatePoint(num)
	self.score:setString(num.."/35")
	self.scoreBar:setPercent(num*100/35)
end

function GameShootView:updateBullet(num)
	for i=1,5 do
		local bullet = self["bullet"..i]
		if (6-i) > num then
			bullet:setVisible(false)
		else
			bullet:setVisible(true)
		end
	end
end

function GameShootView:update()

end


return GameShootView
