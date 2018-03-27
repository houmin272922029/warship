--[[
	跨服军团战
	Author: 
]]

local ChangeCell = qy.class("ChangeCell", qy.tank.view.BaseView, "service_legion_war/ui/ChangeCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function ChangeCell:ctor(delegate)
    ChangeCell.super.ctor(self)
    self.delegate = delegate
    self.data = delegate.data
    self:InjectView("name")
    self:InjectView("power")
    self:InjectView("position")
    self:InjectView("Bt")
    self:OnClick("Bt",function()
    	service:Defence(delegate.site,delegate.pos,self.data[self.index].kid,function (  )
    		delegate:callback()
    	end)
        
    end)


end

function ChangeCell:render(_idx)
	self.index = _idx
    self.name:setString(self.data[_idx].nickname.."   等级:"..self.data[_idx].level.."级")
    self.power:setString("战斗力:"..self.data[_idx].fight_power)
    if self.data[_idx].site == 0 then
    	self.position:setString("暂无驻防据点")
    else
    	self.position:setString("已驻防到"..model.typeNameList[tostring(self.data[_idx].site)])
    end
end

function ChangeCell:onEnter()
  
end

function ChangeCell:onExit()
    
end

return ChangeCell
