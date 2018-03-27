


local Tip1 = qy.class("Tip1", qy.tank.view.BaseDialog, "medal/ui/Tip1")

local model = qy.tank.model.MedalModel
local service = qy.tank.service.MedalService
local userModel = qy.tank.model.UserInfoModel

function Tip1:ctor(delegate)
    Tip1.super.ctor(self)

    self:InjectView("cancelBt")
    self:InjectView("okBt")
    self:InjectView("allbtbg")
    self:InjectView("allbt")
    self:InjectView("bg")

    self:OnClick("cancelBt",function()
        model.chonghzutype = self.touchtyepe
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("okBt",function()    
        model.chonghzutype = self.touchtyepe
        delegate:chonghzu()
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("allbt",function()
        if self.touchtyepe == 0 then
        	self.touchtyepe = 1
        else
        	self.touchtyepe = 0
        end
        self.allbtbg:setVisible(self.touchtyepe == 1)
    end,{["isScale"] = false})
    self.allbtbg:setVisible(false)
    self.touchtyepe = 0


end


return Tip1
