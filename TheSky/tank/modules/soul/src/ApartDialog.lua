local ApartDialog = qy.class("ApartDialog", qy.tank.view.BaseDialog, "soul.ui.ApartDialog")

local model = qy.tank.model.SoulModel
local service = qy.tank.service.SoulService
function ApartDialog:ctor(delegate)
   	ApartDialog.super.ctor(self)

    self:InjectView("Num")

    self:OnClick("Button_2", function()
        service:apart({
            ["unique_id"] = delegate.soulEntity.unique_id,
        }, function(data)
            model:remove(delegate.soulEntity.unique_id) 
            delegate:updateTank()
            delegate:updateSoulList()
            delegate:updateSoulInfo()
            delegate:updateFrement()
            self:dismiss()
        end)     
    end,{["isScale"] = false}) 

    self:OnClick("Button_1", function()
        self:dismiss()
    end,{["isScale"] = false}) 

    self.Num:setString(delegate.soulEntity:getAttr1().soulNum)
end

return ApartDialog
