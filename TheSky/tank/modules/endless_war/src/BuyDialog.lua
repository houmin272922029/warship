local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "endless_war.ui.BuyDialog")


local model = qy.tank.model.EndlessWarModel
local service = qy.tank.service.EndlessWarService
function BuyDialog:ctor(delegate)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Num")
   	self:InjectView("Times")

    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})


    self:OnClick("Btn_buy", function()
        service:BuyBattleNum( function(data)
            self:dismiss()
            delegate:callback()
        end)
    end,{["isScale"] = false})
    self.Num:setString(100*(model.buytimes + 1))
    self.Times:setString("当前剩余购买加速次数："..(model:getnumByvip()-model.buytimes).."次")
end


return BuyDialog
