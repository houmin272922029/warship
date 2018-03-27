--[[
	双十一活动
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "double_eleven.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("double_eleven.src.Model")
    self.service = require("double_eleven.src.Service")

    self:InjectView("Close_btn")
    self:InjectView("Time_txt")
    for i=1,4 do
        self:InjectView("Node_"..i)
        self:InjectView("Buy_btn"..i)
        self:InjectView("Yprice_"..i)
        self:InjectView("Xprice_"..i)
        self:InjectView("Yi_mai_"..i)
    end

    self:OnClick("Close_btn",function()
        self:removeSelf()
    end)

    --界面si个按钮点击事件
    --local award_data = self.model:getaward()
    local award_data = self.model:get_show_award()
    local day_num = self.model.data.today_num
    for i=1,4 do
        self:OnClick("Buy_btn"..i, function(sender)
            print("点击的id",award_data[tostring(i + 4 *(day_num - 1))].id)
            self.service:buy(award_data[tostring(i + 4 *(day_num - 1))].id,function(  )
                print("这个是第..",i)
                self.model:change_btn_status(i)
                self:update_btn_status()
            end)
            
        end,{["isScale"] = false})
    end

    self:showAward()
    self:update_btn_status()
end

function MainDialog:showAward()
    --奖励展示
    local award_data = self.model:get_show_award()
    print("MainDialog111",table.nums(award_data))
    if table.nums(award_data) ~= 0 then
        local day_num = self.model.data.today_num
        local show_award = award_data[tostring(1 + 4 *(day_num - 1))].award
        for i=1,table.nums(award_data) do
            --local item = qy.tank.view.common.AwardItem.createAwardView(award_data[i].award[1] ,1)
            local item = qy.tank.view.common.AwardItem.createAwardView(award_data[tostring(i + 4 *(day_num - 1))].award[1],1)
            self["Node_"..i]:addChild(item)
            item:setScale(1)
            item.fatherSprite:setSwallowTouches(false)
            item.name:setVisible(false)
        end

        --活动时间
        local startTime = os.date("%Y-%m-%d",self.model.data.start_time)
        local endTime = os.date("%Y-%m-%d",self.model.data.end_time)
        self.Time_txt:setString(startTime..qy.TextUtil:substitute(52003)..endTime)

        --原价,折扣价
        for i=1,4 do
            self["Yprice_"..i]:setString(award_data[tostring(i + 4 *(day_num - 1))].old_price)
            self["Xprice_"..i]:setString(award_data[tostring(i + 4 *(day_num - 1))].new_price)
        end
    end
end

function MainDialog:update_btn_status(  )
    --按钮的状态,
    local award_data = self.model:get_show_award()
    if table.nums(award_data) ~= 0 then
        for i=1,4 do
            local btn_status = self.model:get_btn_status(i)
            self["Yi_mai_"..i]:setVisible(btn_status ~= 1)
            self["Buy_btn"..i]:setVisible(btn_status == 1)
        end
    else
        for i=1,4 do
            
            self["Yi_mai_"..i]:setVisible(false)
            self["Buy_btn"..i]:setVisible(false)
        end
    end
end

return MainDialog

