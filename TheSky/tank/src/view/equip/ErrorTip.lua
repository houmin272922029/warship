--[[--

--Author: Fu.Qiang  
--]]--


local ErrorTip = qy.class("ErrorTip", qy.tank.view.BaseDialog, "view/equip/ErrorTip")

local model = qy.tank.model.EquipModel
local service = qy.tank.service.EquipService
local userInfoModel =  qy.tank.model.UserInfoModel
function ErrorTip:ctor(entity,callback)
    ErrorTip.super.ctor(self)
	self:InjectView("Text_1")
    self:InjectView("awardbg")
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("ciufuBt", function(sender)
        service:RepairEquip(entity.unique_id, entity:getComponentEnglishName(),function(data)
            qy.hint:show("修复成功")
            callback()
            self:removeSelf()
        end)
    end, {["isScale"] = false})
    local award = model:getConsumeByid(4)
    self.awardList = qy.AwardList.new({
        ["award"] = award,
        ["cellSize"] = cc.size(100,100),
        ["type"] = 2,
        ["itemSize"] = 2,
        ["hasName"] = false,
        ["len"] = 3,
    })
    self.awardList:setPosition(150,165)
    self.awardbg:addChild(self.awardList)
end


return ErrorTip