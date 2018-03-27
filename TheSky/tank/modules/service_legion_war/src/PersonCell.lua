--[[
	跨服军团战
	Author: 
]]

local PersonCell = qy.class("PersonCell", qy.tank.view.BaseView, "service_legion_war/ui/PersonCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function PersonCell:ctor(delegate)
    PersonCell.super.ctor(self)
    self:InjectView("rank")
    self:InjectView("name")
    self:InjectView("score")
    self:InjectView("rankimg")
    self:InjectView("bg")
    self.data = delegate.data

end

function PersonCell:render(_idx)
   	if _idx <= 3 then
   		self.rank:setVisible(false)
   		self.rankimg:setVisible(true)
   		local png = "service_legion_war/res/".._idx.."-di.png"
   		self.bg:loadTexture(png,1)
   		local png = "service_legion_war/res/".._idx.."nd_1.png"
   		self.rankimg:loadTexture(png,1)
   	else
   		self.rank:setVisible(true)
   		self.rank:setString(_idx)
   		self.rankimg:setVisible(false)
   		local png = "service_legion_war/res/".._idx.."-di.png"
   		self.bg:loadTexture("service_legion_war/res/3-di.png",1)
   	end
    self.name:setString(self.data[_idx].nickname)
    self.score:setString(self.data[_idx].record)
end

function PersonCell:onEnter()
  
end

function PersonCell:onExit()
    
end

return PersonCell
