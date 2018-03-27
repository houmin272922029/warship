--[[--

--Author: Fu.Qiang  
--]]--


local Clearlist = qy.class("Clearlist", qy.tank.view.BaseView)--,"view/equip/Clearlist")

local model = qy.tank.model.EquipModel
local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel
function Clearlist:ctor(delegate)
    Clearlist.super.ctor(self)
    self:InjectView("bg")
    local data = delegate.entity.addition_attr
    self.num = #data
    for i=1,#data do
        local item = qy.tank.view.equip.ClearCell.new({["data"] = data[i]})
        local totalnum = 35 * self.num
        item:setPosition(cc.p(10,totalnum - 35 * i))
        self:addChild(item)
    end
	
end
function Clearlist:getHeight(  )
    return self.num * 35
end

return Clearlist