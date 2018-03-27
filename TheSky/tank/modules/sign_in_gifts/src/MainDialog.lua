--[[
	每日好礼
	
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "sign_in_gifts.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    --self:setCanceledOnTouchOutside(true)
    self.model = require("sign_in_gifts.src.Model")
    self.service = require("sign_in_gifts.src.Service")

    self:InjectView("Sprite_1")
    self:InjectView("LoadingBar_1")
    self:InjectView("Btn_Close")
    self:InjectView("Node_3")
    self:InjectView("Node_4")
    self:InjectView("Node_5")
    self:InjectView("Node_6")
    self:InjectView("Btn_QianDao")
    self:InjectView("Btn_LingQu")
    self:InjectView("Image_QianDao")
    self:InjectView("Image_YiQian")
    self:InjectView("Text_6")
    self:InjectView("Text_Number")
    self:InjectView("Text_Time")
    self:InjectView("Text_2")
    self:InjectView("Image_2")
    

    self:OnClick("Btn_Close", function(sender)
        self:removeSelf()
    end)

    self:OnClick("Btn_QianDao", function(sender)
        self.service:getAward(1,function (response)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})
        self.model:GetUpdateTime()
        self.model:GetUpdateStatus()    
        self:update()
        end)
    end)

    self:OnClick("Btn_LingQu", function(sender)
        self.service:getAward(2,function (response)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award,{["isShowHint"]=false})

        self.model:GetUpdateStatus1()
        self:update()
        end)
    end)
    self:update()
end
    
    
function MainDialog:update()

    --限时活动持续时间
    local startTime = os.date("%Y年%m月%d日",self.model.start_time)
    local endTime = os.date("%Y年%m月%d日",self.model.end_time)
    self.Text_Time:setString(startTime..qy.TextUtil:substitute(52003)..endTime)

    local x = self.model.end_time - self.model.start_time
    self.day = math.ceil(x/3600/24)
    self.Text_2:setString(self.day)
    --放置每日奖励
    self.data = self.model.data.award
    local item = qy.tank.view.common.AwardItem.createAwardView(self.data[1] ,1)
    self.Sprite_1:addChild(item)
    item:setPosition(75, 285)
    item:setScale(0.8)
    item.fatherSprite:setSwallowTouches(false)
    item.name:setVisible(false)
    --item.bg:setVisible(false)

    --放置全勤奖励
    self.data2 = self.model.data.last_award
    for i = 1,#self.data2 do
      local item = qy.tank.view.common.AwardItem.createAwardView(self.data2[i] ,1)
      self["Node_"..(i + 2)]:addChild(item)
      item:setScale(1.0)
      item.fatherSprite:setSwallowTouches(false)
      item.name:setVisible(false)
    end

    --放置两个签到天数
    local Times = self.model:GetTimes()
    self.Text_6:setString(tostring(Times).."/"..self.day)
    self.Text_Number:setString(tostring(Times))

    --进度条的百分比   
    self.LoadingBar_1:setPercent(tonumber(Times)/tonumber(self.day) * 100)

    --领取按钮是否置灰
    local LintQuStatus = self.model:GetLingQuStatusById(self.day)
    self.Btn_LingQu:setTouchEnabled(LintQuStatus == 1)
    self.Btn_LingQu:setBright(LintQuStatus == 1)

    self.Btn_LingQu:setVisible(self.model.data.state == 0)
    print("33333333333",self.model.data.state)
    self.Image_2:setVisible(self.model.data.state == 2)

    --显示签到,已签到
    local QianDaoStatus = self.model:GetQianDaoStatusById()
    self.Image_YiQian:setVisible(QianDaoStatus == 1)
    self.Image_QianDao:setVisible(QianDaoStatus == 0)

    self.Btn_QianDao:setTouchEnabled(QianDaoStatus == 0)
    self.Btn_QianDao:setBright(QianDaoStatus == 0)

    

end


function MainDialog:onExit()	
    
end


function MainDialog:onEnter()

end
return MainDialog
