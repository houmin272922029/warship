--[[
	全服福利cell
]]
local AwardsCell = qy.class("AwardsCell", qy.tank.view.BaseView, "view/service_war/AwardsCell")

local model = qy.tank.model.ServiceWarModel

function AwardsCell:ctor(delegate)
    AwardsCell.super.ctor(self)
     self:InjectView("name")
     self:InjectView("time")
     self:InjectView("listContent")
end

function AwardsCell:setData(data)
	self.data = data
	if self.data then
		self.name:setString("服务器领袖" .. self.data.senduser.nickname .. "向全服玩家赠送")
		self.time:setString(self.data.senduser.sendtime)
		if not self.itemIcon then
			self.listContent:removeAllChildren()
			self.itemIcon = qy.tank.view.common.AwardItem.createAwardView(self.data.award, 1, 1, false)
			self.itemIcon:setPosition(100, 100)
			self.listContent:addChild(self.itemIcon)
		else
			if self.data then
				self.itemIcon:setData(qy.tank.view.common.AwardItem.getItemData(self.data.award))
			end
		end
	end
end

function AwardsCell:onEnter()
	
end

function AwardsCell:onExit()
	
end
return AwardsCell