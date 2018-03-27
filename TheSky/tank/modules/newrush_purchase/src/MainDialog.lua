--[[
	火炬行动
	Author: Your Name
	Date: 2016-01-26 16:03:57
	Date: 2016-01-04 17:23:12
]]

local RushPurchaseDialog = qy.class("RushPurchaseDialog", qy.tank.view.BaseDialog, "newrush_purchase.ui.MainDialog")

function RushPurchaseDialog:ctor()
    RushPurchaseDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("newrush_purchase.src.Model")
    self.service = require("newrush_purchase.src.Service")

    self.userInfo = qy.tank.model.UserInfoModel
    
    self:InjectView("closeBtn")
    self:InjectView("time")
    self:InjectView("remain")
    self:InjectView("price1")
    self:InjectView("price2")
    self:InjectView("price3")


   	self:OnClick("closeBtn", function()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("purchaseBtn", function()
        local service =require("newrush_purchase.src.Service")
        service:buy(self.model.list[1].id,function()
            self:render()
        end)
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("btn1", function()
        qy.alert:showTip(qy.tank.view.tip.TankTip.new(qy.tank.entity.TankEntity.new(self.model.list[1].award[1].id)))
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})
end

function RushPurchaseDialog:render()
    local startTime = os.date(qy.TextUtil:substitute(61001),self.model.start_time)
    local endTime = os.date("%Y.%m.%d",self.model.end_time)
	self.time:setString(startTime..qy.TextUtil:substitute(52003)..endTime)
    for i=1,3 do
        local data = self.model.list[1]["price_"..i]
        self["price"..i]:setString(data)
    end
    local nums = self.model.list[1].total_num-self.model.list[1].buy
    if nums < 0 then
        nums = 0
    end
    self.remain:setString(nums.."辆")
end

return RushPurchaseDialog

