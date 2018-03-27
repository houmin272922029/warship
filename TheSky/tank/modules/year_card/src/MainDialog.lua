--[[
	季卡年卡
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "year_card.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    --self:setCanceledOnTouchOutside(true)
    self.model = require("year_card.src.Model")
    self.service = require("year_card.src.Service")
    local service = qy.tank.service.OperatingActivitiesService


    self:InjectView("Close")
    self:InjectView("Image_1")    --放置奖励的位置
    self:InjectView("Image_2")
    self:InjectView("Yilingqu1")  --已领取文字图片
    self:InjectView("Yilingqu2")
    self:InjectView("Buy_btn1")   --购买按钮
    self:InjectView("Buy_btn2")
    self:InjectView("Buy_image1") --购买文字图片
    self:InjectView("Buy_image2")
    self:InjectView("LingQu1")    --领取文字图片
    self:InjectView("LingQu2")
    self:InjectView("Time1")      --剩余的天数数字
    self:InjectView("Time2")
    self:InjectView("Surplus_1")  --剩余的天数文字
    self:InjectView("Surplus_2")
    

    self.data1 = self.model:GetSeasonDataById(tonumber(3))
    self.data2 = self.model:GetSeasonDataById(tonumber(4)) 
    
    self:OnClick("CloseBtn", function()       
        self:removeSelf()
    end)

    self:OnClick("Buy_btn1", function()
        if self.status1 == 1 then 
            self:buyCard("tk328",3)            
        elseif self.status1 == 2 then 
            local aType = qy.tank.view.type.ModuleType
            self.service:getAward(3,aType.YEAR_CARD,function()
            self.model:ChangeTime(3)
            self.model:ChangeStatus2(3)
            self:refresh()               
            end)
        elseif self.status1 == 3 then           
        end               
    end)

    self:OnClick("Buy_btn2", function()  
        if self.status2 == 1 then 
            self:buyCard("tk648",4)            
        elseif self.status2 == 2 then
            local aType = qy.tank.view.type.ModuleType
            self.service:getAward(4,aType.YEAR_CARD,function()
            self.model:ChangeTime(4)
            self.model:ChangeStatus2(4)
            self:refresh()                
            end)
        elseif self.status2 == 3 then
           
        end  
    end)
    self:refresh()
end

function MainDialog:buyCard(idx,id)
    local data = qy.tank.model.RechargeModel.data[idx]
    qy.tank.service.YearCardService:paymentBegin(data, function(flag, msg)
        if flag == 3 then
            self.toast = qy.tank.widget.Toast.new()
            self.toast:make(self.toast, qy.TextUtil:substitute(23006))
            self.toast:addTo(qy.App.runningScene, 1000)
        elseif flag == true then
            self.toast:removeSelf()
            qy.hint:show(qy.TextUtil:substitute(58002))
            --走充值成功逻辑
            print("充值成功")
            if id == 3 then 
                self.model:SetTime(3)
                self.model:ChangeStatus(3)
                self:refresh()
            elseif id == 4 then
                self.model:SetTime(4)
                self.model:ChangeStatus(4)
                self:refresh()
            end
        else
            self.toast:removeSelf()
            qy.hint:show(msg)
        end
    end,id,id)
end

-- status 1:未购买  2:未领取  3:已领取
function MainDialog:refresh()  
    local status1,time1 = self.model:GesStatusById(tonumber(3))
    local status2,time2 = self.model:GesStatusById(tonumber(4))
    self.status1 = status1
    self.status2 = status2
    self.time1 = time1 
    self.time2 = time2

    for a = 1,2 do
        self["Yilingqu"..a]:setVisible((self["status"..a]) == 3)
        self["LingQu"..a]:setVisible((self["status"..a]) == 2)
        self["Buy_image"..a]:setVisible((self["status"..a]) == 1)
        self["Buy_btn"..a]:setVisible((self["status"..a]) == 1 or (self["status"..a]) == 2)
        self["Surplus_"..a]:setVisible((self["status"..a]) == 2 or (self["status"..a]) == 3)
        self["Time"..a]:setVisible((self["status"..a]) == 2 or (self["status"..a]) == 3)
        self["Time"..a]:setString(self["time"..a])

        for i = 1,#self["data"..a][1].award do    
            local item = qy.tank.view.common.AwardItem.createAwardView(self["data"..a][1].award[i] ,1)
            self["Image_"..a]:addChild(item)
            item:setPosition(-50 + 100 * (i +1), 50)
            item:setScale(0.8)
            item.fatherSprite:setSwallowTouches(false)
            item.name:setVisible(false)
        end  

        local item = qy.tank.view.common.ItemIcon.new()
        local data = self.model:atMonthCardDiamond(a + 2)
        self["Image_"..a]:addChild(item)
        item:setData(data)
        item:setScale(0.8)
        item.name:setVisible(false)
        item:setPosition(-50 + 100 , 50)
    end      
end

function MainDialog:onExit()	
    
end


function MainDialog:onEnter()


end
return MainDialog
