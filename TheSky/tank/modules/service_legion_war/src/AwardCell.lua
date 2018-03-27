--[[
	跨服军团战
	Author: 
]]

local AwardCell = qy.class("AwardCell", qy.tank.view.BaseView, "service_legion_war/ui/AwardCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function AwardCell:ctor(delegate)
    AwardCell.super.ctor(self)
    self:InjectView("rank")
    self:InjectView("name")
    self:InjectView("score")
    self:InjectView("rankimg")
    self:InjectView("icon")
    self:InjectView("awardlist")
    self.type = delegate.type
    self.data = delegate.data
    self.servicedata = {}
    if self.type == 1 then
        self.servicedata = model.personal_day_rank
    elseif self.type == 2 then
        self.servicedata = model.personal_week_rank
    else
        self.servicedata = model.legion_week_rank
    end

end

function AwardCell:render(_idx)
    if _idx <= 3 then
   		  self.rank:setVisible(false)
   		  self.rankimg:setVisible(true)
   		  local png = "service_legion_war/res/".._idx.."nd_1.png"
   		  self.rankimg:loadTexture(png,1)
   	else
     		self.rank:setVisible(true)
     		self.rank:setString(_idx)
     		self.rankimg:setVisible(false)
   	end
   	if self.type == 4 then
   		  self.icon:setVisible(false)
        self.name:setAnchorPoint(0.5, 0.5)
        self.name:setPosition(258, 59)
        if self.servicedata[_idx] then--
            self.name:setString("["..self.servicedata[_idx].server.."]"..self.servicedata[_idx].legion_name)
            self.score:setString(self.servicedata[_idx].record)
        else
            self.name:setString("虚位以待")
            self.score:setString("")
        end
	  else
        self.name:setAnchorPoint(0, 0.5)
        self.name:setPosition(237, 59)
        if self.servicedata[_idx] then--
            self.icon:setVisible(true)
            self.name:setString(self.servicedata[_idx].nickname)
            self.score:setString(self.servicedata[_idx].record)
            local png = "Resources/user/icon_"..self.servicedata[_idx].headicon..".png"
            self.icon:loadTexture(png)
            self.icon:setScale(0.9)
        else
            self.icon:setVisible(false)
            self.name:setString("虚位以待")
            self.score:setString("")
        end
	  end
  	self.awardlist:removeAllChildren()
  	local award = self.data[tostring(_idx)].award
  	for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.awardlist:addChild(item)
        item:setPosition(65 + 90*(i - 1), 57)
        item:setScale(0.7)
        item.name:setVisible(false)
    end
  
end

function AwardCell:onEnter()
  
end

function AwardCell:onExit()
    
end

return AwardCell
