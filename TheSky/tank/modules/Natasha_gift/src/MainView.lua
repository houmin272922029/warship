

local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "Natasha_gift/ui/MainView")

local model = qy.tank.model.OperatingActivitiesModel

function MainView:ctor(delegate)
    MainView.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("time")
    self:InjectView("bg")

	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self:createTimer1()
    self:initaward()
end
function MainView:initaward(  )
    local data = model.giftlist["1"]
    local num = data.drop_num
    for i=1,num do
        local award = data["award_"..i]
        local item = qy.tank.view.common.AwardItem.createAwardView(award[1] ,1)
        self.bg:addChild(item)
        item:setPosition(430 + 100*(i - 1), 85)
        item:setScale(0.8)
        item.name:setVisible(false)
        item.num:setVisible(false)
    end
   
end
function MainView:createTimer1()
    local remainTime1 =  model.natashagift_endtime - qy.tank.model.UserInfoModel.serverTime
   
    if remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function MainView:updateLeftTime( leftTime)
    if leftTime == 0 then     
        self:clearTimer()
        self.time:setString(leftTime)
    else   
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime , 7)
        self.time:setString(timeStr)
    end
end
-- 清除时钟
function MainView:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end   
    
    self.timer1 = nil
end

function MainView:onExit()
    self:clearTimer()
end
-- function MainView:onEnter()
-- 	if model.natashagift_endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
--          self.time:setString("活动已结束")
--     else
--     	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.natashagift_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
--     	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
--         self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.natashagift_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
--         if model.natashagift_endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
--          	self.time:setString("活动已结束")
--      	end
--     end)
--     end
     
-- end

-- function MainView:onExit()
--   	qy.Event.remove(self.listener_1)
-- end


return MainView
