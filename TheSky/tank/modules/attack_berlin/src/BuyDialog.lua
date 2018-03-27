local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "attack_berlin.ui.BuyDialog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function BuyDialog:ctor(delegate)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Times")
    self:InjectView("Times2")
    self:InjectView("Num")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        if self.types == 1 then
            service:buy1(function(data)
                self:update()
                delegate:callback()
            end)
        else
            service:buy2(function(data)
                self:update()
                delegate:callback()
            end)
        end
    end,{["isScale"] = false})

    self.types = delegate.types--普通1  困难2
    self:update()
end

function BuyDialog:update()
    if self.types == 1 then
        self.Times:setString(model.times1)
        self.Times2:setString(model.simplebuynums  - model.buy_times)
        self.Num:setString(50 * (model.buy_times + 1) )
    else
        self.Times:setString(model.times2)
        self.Times2:setString(model.commonbuynums  - model.buy_times2)
        self.Num:setString(100 * (model.buy_times2 + 1) )
    end
   
end


return BuyDialog
