--[[
	射门
	Author: Your Name
	Date: 2016-09-20 14:26:30
]]

local GoalView = qy.class("GoalView", qy.tank.view.BaseView, "olympic.ui.GoalView")

function GoalView:ctor(delegate)
	print("GoalView:ctor")
    GoalView.super.ctor(self)

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("olympic/fx/fx_ui_shemen")

    self.model = qy.tank.model.OlympicModel
    self.service = qy.tank.service.OlympicService
	self.delegate = delegate
	self.count = 5
	self.goal = 0

	self:InjectView("arrow_left")
	self:InjectView("arrow_middle")
	self:InjectView("arrow_right")
	self:InjectView("score")
	self:InjectView("score_win")
	self:InjectView("score_fail")
	self:InjectView("panel")
	self:InjectView("scoreBar")

	self.score_win:setString("20积分")
	self.score_fail:setString("10积分")

	for i=1,5 do
		self:InjectView("ball"..i)
	end

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "olympic/res/7.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
            	self.service:score(200,self.model.key,self.model:getScore(200,self.goal),self.model.times,function()
					local result = require("olympic.src.ResultDialog").new({
						["dismiss"] = self.delegate.dismiss
					})
					result:show(true)
				end)
                -- delegate.dismiss()
            end
        end
    })
    self:addChild(style)

	self:OnClick("arrow_left",function(sender)
		print("goal left!")
		self:shoot("left") 
	end, {["isScale"] = true})
	
	self:OnClick("arrow_middle",function(sender)
		print("goal middle!")
		self:shoot("middle") 
	end, {["isScale"] = true})

	self:OnClick("arrow_right",function(sender)
		print("goal right!")
		self:shoot("right") 
	end, {["isScale"] = true})

	if not self.fx then
		self.fx = ccs.Armature:create("fx_ui_shemen")
		self.fx:setPosition(103,-190)
		self.panel:addChild(self.fx)
	end

	self:updateScore(0)
end


function GoalView:update()
end


function GoalView:shoot(direction)
	if self.count > 0 then
		self:setBtnEnabled(false)
		if direction == "left" then
			if math.random() <= 0.8 then
				-- 进球
				self:playFx(2)
				self.goal = self.goal + 1 
			else
				self:playFx(3)
			end
		elseif direction == "middle" then
			if math.random() <= 0.8 then
				-- 进球
				self:playFx(0)
				self.goal = self.goal + 1 
			else
				self:playFx(1)
			end
		elseif direction == "right" then
			if math.random() <= 0.8 then
				-- 进球
				self:playFx(4)
				self.goal = self.goal + 1 
			else
				self:playFx(5)
			end
		end

		self.count = self.count - 1
		self:updateBall(self.count)
	else
		qy.hint:show("射门次数已用完")
	end
end


function GoalView:playFx(idx)
	if not self.fx then
		self.fx = ccs.Armature:create("fx_ui_shemen")
	end
	self.fx:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
		    if movementType == ccs.MovementEventType.complete then
				self:setBtnEnabled(true)
				if self.count > 0 then
					self.fx:getAnimation():gotoAndPause(0)
					-- self:updateScore(self.goal)
				else
		    		self.fx:getParent():removeChild(self.fx)
		    		
					if self.count <= 0 then
						self.service:score(200,self.model.key,self.model:getScore(200,self.goal),self.model.times,function()
							local result = require("olympic.src.ResultDialog").new({
								["dismiss"] = self.delegate.dismiss
							})
        					result:show(true)
						end)
					end
				end
				self:updateScore(self.goal)
		    end
	    end)
	self.fx:getAnimation():playWithIndex(idx)
end


function GoalView:setBtnEnabled(b)
	self.arrow_left:setEnabled(b)
	self.arrow_middle:setEnabled(b)
	self.arrow_right:setEnabled(b)
end


function GoalView:updateScore(num)
	self.score:setString(num.."/3")
	self.scoreBar:setPercent(num*100/3)
end


function GoalView:updateBall(num)
	for i=1,5 do
		local ball = self["ball"..i]
		if (6-i) > num then
			ball:setVisible(false)
		else
			ball:setVisible(true)
		end
	end
end

return GoalView
