--[[
	登录作战
	Author: Aaron Wei
	Date: 2016-03-05 16:21:10
]]

local Cell = qy.class("Cell", qy.tank.view.BaseView,"login_total.ui.Cell")

function Cell:ctor(delegate)
	self.delegate = delegate
    Cell.super.ctor(self)

	self:InjectView("title")
	self:InjectView("bg")
	self:InjectView("getBtn")
	self:InjectView("gotIcon")
	self:InjectView("schedule")

	self:OnClick("getBtn",function()
		delegate.draw(self.entity.day)
    end)
end

function Cell:render(data)
	self.entity = data
	
	self.title:setString(qy.TextUtil:substitute(55001).." "..data.day.." "..qy.TextUtil:substitute(55002))
	self.schedule:setString(data.schedule.."/"..data.day)

	if data.is_draw == 0 then -- 不能领
		self.getBtn:setVisible(true)
		self.getBtn:setEnabled(false)
    	self.gotIcon:setVisible(false)
 	elseif data.is_draw == 1 then -- 未领取
 		self.getBtn:setVisible(true)
		self.getBtn:setEnabled(true)
    	self.gotIcon:setVisible(false)
 	else -- 已领取
 		self.getBtn:setVisible(false)
		self.getBtn:setEnabled(false)
    	self.gotIcon:setVisible(true) 
	end

	if not tolua.cast(self.awardList,"cc.Node") then
        self.awardList = qy.AwardList.new({
            ["award"] =  data.award,
            ["hasName"] = false,
            ["type"] = 1,
            ["cellSize"] = cc.size(125,100),
            ["itemSize"] = 1, 
        })
        self.awardList:setPosition(100,143)
        self.bg:addChild(self.awardList,0)
        self.awardList:setScale(0.9)
   	else
   		self.awardList:update(data.award)
   	end
end

return Cell                   
