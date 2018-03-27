


local Tip2 = qy.class("Tip2", qy.tank.view.BaseDialog, "accessories/ui/Tip2")

local model = qy.tank.model.FittingsModel
local service = qy.tank.service.FittingsService
local userModel = qy.tank.model.UserInfoModel

function Tip2:ctor(delegate)
    Tip2.super.ctor(self)
    self:InjectView("okBt")

    self:OnClick("okBt",function()
        self:removeSelf()
    end,{["isScale"] = false})

end


return Tip2
