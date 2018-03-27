local BuyDialog = qy.class("BuyDialog", qy.tank.view.BaseDialog, "soldiers_war.ui.BuyDialog")


local model = qy.tank.model.SoldiersWarModel
local service = qy.tank.service.SoldiersWarService
function BuyDialog:ctor(delegate)
   	BuyDialog.super.ctor(self)

   	self:InjectView("Challenge_times")
    self:InjectView("Buy_times")

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
    self.Challenge_times:setString(model.free_times + model.left_buy_times .. qy.TextUtil:substitute(67009))
    self.Buy_times:setString(model.vip_buy_times - model.buy_times .. qy.TextUtil:substitute(67009))
end


return BuyDialog
