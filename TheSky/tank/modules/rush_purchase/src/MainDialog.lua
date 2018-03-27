--[[
	火炬行动
	Author: Your Name
	Date: 2016-01-26 16:03:57
	Date: 2016-01-04 17:23:12
]]

local RushPurchaseDialog = qy.class("RushPurchaseDialog", qy.tank.view.BaseDialog, "rush_purchase.ui.MainDialog")

function RushPurchaseDialog:ctor()
    RushPurchaseDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("rush_purchase.src.Model")
    self.service = require("rush_purchase.src.Service")

    self.today = self.model.day
    self.chooseDay = self.model.day
    self.userInfo = qy.tank.model.UserInfoModel
    
    self:InjectView("closeBtn")
    self:InjectView("time")
    
    self:InjectView("discount1")
    self:InjectView("remain1")
    self:InjectView("coin1_1")
    self:InjectView("price1_1")
    self:InjectView("coin1_2")
    self:InjectView("price1_2")

    self:InjectView("discount2")
    self:InjectView("remain2")
    self:InjectView("coin2_1")
    self:InjectView("price2_1")
    self:InjectView("coin2_2")
    self:InjectView("price2_2")

    -- local function updateTime()
    --     local end_time = self.model.end_time-self.userInfo.serverTime
    --     if end_time > 0 then
    --         self.cd1:setString(qy.tank.utils.DateFormatUtil:toDateString1(end_time,1))
    --     else
    --         self.cd1:setString("活动已结束")
    --     end
        
    --     local award_end_time = self.model.award_end_time-self.userInfo.serverTime
    --     if award_end_time > 0 then
    --         self.cd2:setString(qy.tank.utils.DateFormatUtil:toDateString1(award_end_time,1))
    --     else
    --         self.cd2:setString("活动已结束")
    --     end
    -- end
    -- updateTime()
    -- self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
    --     updateTime()
    -- end)

   	self:OnClick("closeBtn", function()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("purchaseBtn1", function()
        local service =require("rush_purchase.src.Service")
        service:buy(self.model.list[1].id,function()
            self:render()
        end)
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("purchaseBtn2", function()
        local service =require("rush_purchase.src.Service")
        service:buy(self.model.list[2].id,function()
            self:render()
        end)
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("btn1", function()
        qy.alert:showTip(qy.tank.view.tip.TankTip.new(qy.tank.entity.TankEntity.new(self.model.list[1].award[1].id)))
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

    self:OnClick("btn2", function()
        qy.alert:showTip(qy.tank.view.tip.TankTip.new(qy.tank.entity.TankEntity.new(self.model.list[2].award[1].id)))
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})
end

function RushPurchaseDialog:onEnter()
end

function RushPurchaseDialog:onExit()
    print("RushPurchaseDialog:onExit")
    -- qy.Event.remove(self.timeListener)
    -- self.timeListener = nil
end

function RushPurchaseDialog:onCleanup()
    print("WorldBossView:onCleanup")
    -- qy.Event.remove(self.timeListener)
    -- self.timeListener = nil
end

function RushPurchaseDialog:render()
    local startTime = os.date(qy.TextUtil:substitute(61001),self.model.start_time)
    local endTime = os.date("%Y.%m.%d",self.model.end_time)
	self.time:setString(startTime..qy.TextUtil:substitute(52003)..endTime)

    for i=1,2 do
        local data = self.model.list[i]
    	self["discount"..tostring(i)]:setString(tostring(data.discount)..qy.TextUtil:substitute(61002))
        self["remain"..tostring(i)]:setString(tostring(data.total_num-data.buy)..qy.TextUtil:substitute(61003))
        self["coin"..tostring(i).."_1"]:initWithFile(qy.tank.utils.AwardUtils.getAwardIconByType(data.type)) 
        self["price"..tostring(i).."_1"]:setString(tostring(data.old_price))
        self["coin"..tostring(i).."_2"]:initWithFile(qy.tank.utils.AwardUtils.getAwardIconByType(data.type)) 
        self["price"..tostring(i).."_2"]:setString(tostring(data.price))
    end
end

return RushPurchaseDialog

