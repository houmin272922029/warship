local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "group_battles.ui.BuyDialog")


local model = qy.tank.model.GroupBattlesModel
local service = qy.tank.service.GroupBattlesService
function BuyDialog:ctor(delegate)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Times")
    self:InjectView("Times2")
    self:InjectView("Num")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        service:buy(function(data)
            self:update()
            delegate:update()
        end)
    end,{["isScale"] = false})


    self:update()
end

function BuyDialog:update()
    self.Times:setString(model.join_num)
    self.Times2:setString(model.pay_join_num)
    self.Num:setString(model.pay_num)
end


return BuyDialog
