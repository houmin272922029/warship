--[[
	跨服军团战
	Author: 
]]

local LeginList = qy.class("LeginList", qy.tank.view.BaseView, "service_legion_war/ui/LeginList")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function LeginList:ctor(delegate)
    LeginList.super.ctor(self)
    self:InjectView("rank")
    self:InjectView("title")
    self:InjectView("score")
    self:InjectView("rankimg")
    self.data = delegate.data

end

function LeginList:render(_idx)
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
    self.title:setString("["..self.data[_idx].server.."]"..self.data[_idx].legion_name)
    self.score:setString(self.data[_idx].record.."分")
end

function LeginList:onEnter()
  
end

function LeginList:onExit()
    
end

return LeginList
