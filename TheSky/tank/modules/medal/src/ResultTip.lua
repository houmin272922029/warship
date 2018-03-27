


local ResultTip = qy.class("ResultTip", qy.tank.view.BaseDialog, "medal/ui/ResultTip")

local model = qy.tank.model.MedalModel
local service = qy.tank.service.MedalService
local userModel = qy.tank.model.UserInfoModel

function ResultTip:ctor(delegate)
    ResultTip.super.ctor(self)

    self:InjectView("time")
    self:InjectView("okBt")
    self:InjectView("num1")
    self:InjectView("num2")
    self:InjectView("allbtbg")
    self:InjectView("allbt")


    self:OnClick("okBt",function()    
        delegate:callback()
        model.chonghzutype = self.touchtyepe
        self:removeSelf()
    end,{["isScale"] = false})
    self.time:setString(delegate.data.succ_times.."次")
    self.num1:setString(delegate.data.total_afliquid_cost)
    self.num2:setString(delegate.data.total_exliquid_cost)
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


return ResultTip
