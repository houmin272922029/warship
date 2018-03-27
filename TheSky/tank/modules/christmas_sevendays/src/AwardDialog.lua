

local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog, "christmas_sevendays/ui/AwardDialog")

function AwardDialog:ctor(delegate)
    AwardDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
	self:InjectView("closeBt")
	self:InjectView("time")--时间
	self:InjectView("lingqu")
	self:InjectView("shuoming")
	self:InjectView("ScrollView")
    self:InjectView("nownum")
    self:InjectView("nows")
    self:InjectView("nextnum")
    self:InjectView("nexts")
    self:InjectView("jindu")
    self:InjectView("yilingqu")
    self:InjectView("Image_3")
    self:InjectView("time_0")
    self.yilingqu:setVisible(false)
    --  qy.tank.utils.TextUtil:autoChangeLine(self.shuoming , cc.size(500 , 300))
    -- self.storyTxt:getVirtualRenderer():setLineHeight(38)
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self:OnClick("lingqu", function(sender)
        service:getaward(2,1, function ( data )
            self.yilingqu:setVisible(true)
            self.lingqu:setVisible(false)
        end)
    end)
    if self.ScrollView.setScrollBarEnabled then
        self.ScrollView:setScrollBarEnabled(false)
    end
    local data = self.model.christmasaward
    local item = qy.tank.view.common.AwardItem.createAwardView(data[1].award[1] ,1)
    self.Image_3:addChild(item)
    item:setPosition(0 , -60)
    item:setScale(0.9)
    item.name:setVisible(false)
    item.num:setVisible(false)
    local total = table.nums(self.model.christmastaskcfg)
    print("zomg",total)
    print("---------",#data)
    local tempnum1 = math.ceil(self.model.christmasfinishinum/total * 100 )
    if tempnum1 >100 then
        tempnum1 = 100
    end
    self.jindu:setString("当前进度: "..tempnum1.."%")
    self.nows:setString("已达到进度: "..tempnum1.."%")
    local id = 0
    local finishnum = self.model.christmasfinishinum
    if finishnum < data[1].num then
        id = 0
    end
    if finishnum >= data[#data].num then
        id = #data
    end
    for i=2,#data do
        if finishnum >= data[i-1].num and finishnum < data[i].num then
            id = i-1
        end
    end
    print("dangqian",id)
    if id == 0 then
        self.nownum:setString("0")
        self.nextnum:setString(data[1].award[1].num)
        local tempnum = math.ceil(self.model.christmasfinishinum/data[1].num * 100) 
        self.nexts:setString("已达到进度: "..tempnum.."%")

    elseif id == #data then
        self.nownum:setString(data[id].award[1].num)
        self.nextnum:setString("达上限")
        self.nexts:setString("已达到进度: ".."100%")
    else 
        self.nownum:setString(data[id].award[1].num)
        self.nextnum:setString(data[id+1].award[1].num)
        local tempnum = math.ceil(self.model.christmasfinishinum/data[id+1].num * 100) 
        if  tempnum>100 then
            tempnum = 100
        end
        self.nexts:setString("已达到进度: "..tempnum.."%")
    end
    if self.model.christmas_awardstarttime <= qy.tank.model.UserInfoModel.serverTime or id == #data then
        if id ~= 0 then
             self.lingqu:setEnabled(true)
        else
             self.lingqu:setEnabled(false)
        end
    else
        self.lingqu:setEnabled(false)
    end
	if self.model.christmasfinalid == 0 then
         self.yilingqu:setVisible(false)
         self.lingqu:setVisible(true)
    else
         self.yilingqu:setVisible(true)
         self.lingqu:setVisible(false)
    end
  

end

function AwardDialog:onEnter()
    if self.model.christmas_awardstarttime - qy.tank.model.UserInfoModel.serverTime <= 0 then
        self.time_0:setString("后活动结束，请尽快领取奖励")
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardendtime - qy.tank.model.UserInfoModel.serverTime, 7))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardendtime - qy.tank.model.UserInfoModel.serverTime, 7))
        end)
    else
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardstarttime - qy.tank.model.UserInfoModel.serverTime, 7))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardstarttime - qy.tank.model.UserInfoModel.serverTime, 7))
            if self.model.christmas_awardstarttime - qy.tank.model.UserInfoModel.serverTime <= 0 then
                -- self.lingqu:setEnabled(true)
                self.time_0:setString("后活动结束，请尽快领取奖励")
                self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardendtime - qy.tank.model.UserInfoModel.serverTime, 7))
                self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
                    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_awardendtime - qy.tank.model.UserInfoModel.serverTime, 7))
                end)
            end
        end)
    end
end

function AwardDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return AwardDialog
