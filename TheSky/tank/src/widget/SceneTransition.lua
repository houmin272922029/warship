--[[
	战斗场景切换界面
	Author: Aaron Wei
	Date: 2015-08-26 11:13:08
]]

local SceneTransition = qy.class("SceneTransition", qy.tank.view.BaseView, "view/common/SceneTransition")

local DOOR_H = 363

function SceneTransition:ctor()
    SceneTransition.super.ctor(self)

	self:InjectView("door1")
	self:InjectView("door2")
	self:InjectView("panel")
	self.panel:setContentSize(qy.winSize)
	self.panel:setPosition(qy.winSize.width/2,qy.winSize.height/2)
end

function SceneTransition:open(callback)
	print("SceneTransition:open ===============>>>>>>>>>>>")
	self.door1:setPosition(qy.winSize.width/2,DOOR_H)
	-- self.act1 = cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,720))
	-- self.act1 = cc.EaseElasticInOut:create(cc.MoveTo:create(1,cc.p(qy.winSize.width/2,720))) -- 弹性缓冲
	-- self.act1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,720))) -- 回震缓冲
	-- self.act1 = cc.EaseExponentialOut:create(cc.MoveTo:create(0.2,cc.p(qy.winSize.width/2,720))) -- 指数缓冲
	self.act1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,DOOR_H * 2))) -- sine缓冲
	-- local seq1 = cc.Sequence:create(self.act1,nil)
	self.door1:runAction(self.act1)

	self.door2:setPosition(qy.winSize.width/2,DOOR_H)
	-- self.act2 = cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,-363))
	-- self.act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(1,cc.p(qy.winSize.width/2,-363))) -- 弹性缓冲
	-- self.act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,-363))) -- 回震缓冲
	-- self.act2 = cc.EaseExponentialOut:create(cc.MoveTo:create(0.2,cc.p(qy.winSize.width/2,-363))) -- 指数缓冲
	self.act2 = cc.EaseSineInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,0))) -- sine缓冲
	-- local seq2 = cc.Sequence:create(self.act2,cc.CallFunc:create(callback))
	local seq = cc.Sequence:create(self.act2,cc.CallFunc:create(function ()
		-- callback()
		self.panel:setVisible(false)
		-- callback()
	end))
	self.door2:runAction(seq)
end

function SceneTransition:close(callback)
	print("SceneTransition:close ===============>>>>>>>>>>>")
	self.door1:setPosition(qy.winSize.width/2,DOOR_H * 2)
	-- self.act1 = cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,363))
	-- self.act1 = cc.EaseElasticInOut:create(cc.MoveTo:create(1,cc.p(qy.winSize.width/2,363))) -- 弹性缓冲
	-- self.act1 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,363))) -- 回震缓冲
	-- self.act1 = cc.EaseExponentialOut:create(cc.MoveTo:create(0.2,cc.p(qy.winSize.width/2,363))) -- 指数缓冲
	self.act1 = cc.EaseSineInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2, DOOR_H)))
	-- local seq1 = cc.Sequence:create(self.act1,nil)
	self.door1:runAction(self.act1)

	self.door2:setPosition(qy.winSize.width/2,0)
	-- self.act2 = cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,0))
	-- self.act2 = cc.EaseElasticInOut:create(cc.MoveTo:create(1,cc.p(qy.winSize.width/2,0))) -- 弹性缓冲
	-- self.act2 = cc.EaseBackInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,0))) -- 回震缓冲
	-- self.act2 = cc.EaseExponentialOut:create(cc.MoveTo:create(0.2,cc.p(qy.winSize.width/2,0))) -- 指数缓冲
	self.act2 = cc.EaseSineInOut:create(cc.MoveTo:create(0.5,cc.p(qy.winSize.width/2,DOOR_H)))
	local seq = cc.Sequence:create(self.act2,cc.CallFunc:create(function ()
		callback()
	end))
	-- local seq2 = cc.Sequence:create(self.act2,nil)
	self.door2:runAction(seq)
end

function SceneTransition:show(callback)
	-- self.door1:setPosition(qy.winSize.width/2,363)
	-- self.door2:setPosition(qy.winSize.width/2,0)/
	self.door1:setVisible(true)
	self.door2:setVisible(true)
	self:setVisible(true)
	self.panel:setVisible(true)
	self:close(function ()
		callback()
	end)
end

function SceneTransition:hide()
	-- self.door1:setPosition(qy.winSize.width/2,720)
	-- self.door2:setPosition(qy.winSize.width/2,-360)
	self.door1:setVisible(false)
	self.door2:setVisible(false)
	self:setVisible(false)
end

function SceneTransition:destroy()
	if self.door1 and tolua.cast(self.door1,"cc.Node") then
		self:removeChild(self.door1)
	end

	if self.door2 and tolua.cast(self.door2,"cc.Node") then
		self:removeChild(self.door2)
	end
end

return SceneTransition
