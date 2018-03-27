--[[
--装备tip
--Author: H.X.Sun
--Date: 2015-07-18
]]

local TotalTip = qy.class("TotalTip",  qy.tank.view.BaseDialog, "accessories/ui/TotalTip")

local model = qy.tank.model.FittingsModel

function TotalTip:ctor(entity)
    TotalTip.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:InjectView("bg")
    self:InjectView("ScrollView")
    self.ScrollView:setScrollBarEnabled(false)
  	self.tankid = entity.tank_id
  	self:Update()
end

function TotalTip:Update()
    local data = model:totalAttr2(self.tankid)
    -- print("总数性啊",json.encode(data))
    local temp = 0
    for k,v in pairs(data) do
        if v ~= 0 then
            temp = temp + 1
        end
    end
    if temp <= 14 then
    	self.ScrollView:setInnerContainerSize(cc.size(280,440))
    else
    	self.ScrollView:setInnerContainerSize(cc.size(280,440 + 30*(temp - 14)))
    end
    local temp1 = 0
    for k,v in pairs(data) do
        if v ~= 0 then
            temp1 = temp1 + 1
            local item = require("accessories.src.Textnode1").new({
                ["id"] = k,
                ["num"] = v
                })
            self.ScrollView:addChild(item)
            if temp <= 14 then
            	item:setPosition(cc.p(40,430-(30*temp1)))
        	else
                local num = ( temp - 14 ) * 30
        		item:setPosition(cc.p(40,430 + num-(30*temp1)))
        	end
            
        end
    end
    

end

return TotalTip
