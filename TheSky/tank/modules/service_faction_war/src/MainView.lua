

local MainView = qy.class("MainView", qy.tank.view.BaseView, "service_faction_war/ui/MainView")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    self.delegate = delegate
    self:InjectView("closeBt")
    self:InjectView("zhanbaoBt")
    self:InjectView("junxianBt")
    self:InjectView("shopBt")
    self:InjectView("ScrollView")
    self:InjectView("mainbg")
    self:InjectView("rankBt")
    self:InjectView("jinengBt1")
    self:InjectView("jinengBt2")
    self:InjectView("jinengBt3")
    self:InjectView("baitiao")
    self:InjectView("hongtiao")
    self:InjectView("lantiao")
    self:InjectView("lvtiao")
    self:InjectView("num1")
    self:InjectView("num2")
    self:InjectView("num3")
    self:InjectView("zhezhao")
    self:InjectView("Node_2")
    self:InjectView("logo")
    self:InjectView("myposition")
    self:InjectView("buff1")
    self:InjectView("buff2")
    self:InjectView("nengliang")
    self:InjectView("gongxian")
    self:InjectView("gongxun")
    self:InjectView("junxian")
    self:InjectView("shangxian")
    self:InjectView("jinengbg1")
    self:InjectView("jinengbg2")
    self:InjectView("jinengbg3")
    self:InjectView("time")
    self:InjectView("Img_red_point")
    self:InjectView("Txt_time")
    self.jinengbg1:setVisible(false)
    self.jinengbg2:setVisible(false)
    self.jinengbg3:setVisible(false)
    self.zhezhao:setVisible(false)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("service_faction_war/res/action1.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("service_faction_war/res/action2.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("service_faction_war/res/action3.plist")
    for i=1,31 do
        if i == 31 then
            self:InjectCustomView("zhenying" .. i, require("service_faction_war.src.Bosshold"), {
                ["id"] = i,
            })
        elseif i == 1 or i == 11 or i == 21 then
             self:InjectCustomView("zhenying" .. i, require("service_faction_war.src.Mainhold"), {
                ["id"] = i,
            })
        else
            self:InjectCustomView("zhenying" .. i, require("service_faction_war.src.Stronghold"), {
                ["id"] = i,
            })
        end
    end
     
    self.ScrollView:setScrollBarEnabled(false)

    self:OnClick("closeBt",function()
        delegate:finish()
    end,{["isScale"] = false})
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(54):show(true)
    end)
    self:OnClick("zhanbaoBt", function(sender)
        service:getCombat(function (  )
            require("service_faction_war.src.DetialDialog").new():show()
            model:changeRedPointStatus()
            self:setRedPoint()
        end)
    end)
    self:OnClick("shopBt", function(sender)
        --qy.hint:show("暂未开启")
        require("service_faction_war.src.ShopDialog").new():show()
    end)
    self:OnClick("junxianBt", function(sender)
       require("service_faction_war.src.FactionMilitaryDialog").new():show()
    end)
    self:OnClick("rankBt", function(sender)
        service:getrank(function (  )
            require("service_faction_war.src.FactionRank").new():show()
        end)
    end)
    self:OnClick("jinengBt1", function(sender)
       
    end)
    self:OnClick("jinengBt2", function(sender)
       
    end)
    self:OnClick("jinengBt3", function(sender)
       
    end)
    self:OnClick("buff1", function(sender)
       require("service_faction_war.src.BuffTip").new():show()
    end)
    self:OnClick("buff2", function(sender)
       require("service_faction_war.src.Buff2Tip").new():show()
    end)
    self:OnClick("crefreshBt",function ( sender )
        service:mainCamp(function (  )
            self:updatecity()
            self:updatejindu()
            self:setRedPoint()
        end)
    end)
    self:OnClick("myposition", function(sender)
        self.ScrollView:scrollToPercentBothDirection(cc.p(200,0), 0.9, false);
    end)
    self.ScrollView:setContentSize(qy.winSize.width, qy.winSize.height)
    self:updatejindu()
    -- self.zhezhao:setVisible(false)
    -- local progressCD = cc.ProgressTimer:create(self.zhezhao) 
    -- progressCD:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    -- progressCD:setPosition(self.zhezhao:getPosition())
    -- self.Node_2:addChild(progressCD)
    -- progressCD:setScaleX(-1)
    -- progressCD:setPercentage(100)
    -- local to2 = cc.ProgressTo:create(9.0,0)
    -- local seq = cc.Sequence:create(to2,cc.CallFunc:create(function()
        
    -- end))
    -- progressCD:runAction(seq)
    if model.my_camp == 1 then
        self.ScrollView:scrollToPercentBothDirection(cc.p(0,80), 0, false)
    elseif model.my_camp == 2 then
        self.ScrollView:scrollToPercentBothDirection(cc.p(80,0), 0, false)
    else
        self.ScrollView:scrollToPercentBothDirection(cc.p(120,150), 0, false)
    end
    self:updatecity()
    self:addChat()
    self:setRedPoint()
    self:createTimer1()
end
function MainView:updatejindu(  )
    local data  = model.camp_info
    local totalnum = data["1"] + data["2"] + data["3"]
    self.hongtiao:setVisible(data["1"] ~= 0)
    self.lvtiao:setVisible(data["2"] ~= 0)
    self.lantiao:setVisible(data["3"] ~= 0)
    self.num1:setVisible(data["1"] ~= 0)
    self.num2:setVisible(data["2"] ~= 0)
    self.num3:setVisible(data["3"] ~= 0)
    if data["1"] == 0 then
        if data["2"] == 0 then
            if data["3"] ~= 0 then
                self.lantiao:setScaleX(data["3"]/totalnum)
                self.num3:setString(string.format("%0.2f%%", data["3"]/totalnum))
                self.num3:setString(data["3"])
                local xx = self.lantiao:getContentSize().width * data["3"]/totalnum
                self.lantiao:setPositionX(21)
                self.num3:setPositionX(21 + xx/2)
            end
        else
            self.lvtiao:setScaleX(data["2"]/totalnum)
            self.num2:setString(string.format("%0.2f%%", data["2"]/totalnum))
            self.num2:setString(data["2"])
            local xx = self.lvtiao:getContentSize().width * data["2"]/totalnum
            self.lvtiao:setPositionX(21)
            self.num2:setPositionX(21 + xx/2)
            if data["3"] ~= 0 then
                self.lantiao:setScaleX(data["3"]/totalnum)
                self.num3:setString(string.format("%0.2f%%", data["3"]/totalnum))
                 self.num3:setString(data["3"])
                local xx = self.lvtiao:getContentSize().width * data["2"]/totalnum
                self.lantiao:setPositionX(21 + xx)
                local xxx = self.lvtiao:getContentSize().width * data["3"]/totalnum
                self.num3:setPositionX(21 + xx + xxx/2)
            end
        end
    else
        self.hongtiao:setScaleX(data["1"]/totalnum)
        self.num1:setString(string.format("%0.2f%%", data["1"]/totalnum))
         self.num1:setString(data["1"])
        local xx = self.lvtiao:getContentSize().width * data["1"]/totalnum
        self.num1:setPositionX(21 + xx/2)
        if data["2"] == 0 then
            if data["3"] ~= 0 then
                self.lantiao:setScaleX(data["3"]/totalnum)
                self.num3:setString(string.format("%0.2f%%", data["3"]/totalnum))
                 self.num3:setString(data["3"])
                local xx = self.hongtiao:getContentSize().width * data["1"]/totalnum
                self.lantiao:setPositionX(21 + xx)
                local xxx = self.lvtiao:getContentSize().width * data["3"]/totalnum
                self.num3:setPositionX(21 + xx + xxx/2)
            end
        else
            self.lvtiao:setScaleX(data["2"]/totalnum)
            self.num2:setString(string.format("%0.2f%%", data["2"]/totalnum))
             self.num2:setString(data["2"])
            local xx = self.hongtiao:getContentSize().width * data["1"]/totalnum
            self.lvtiao:setPositionX(21 + xx)
            local xxx = self.lvtiao:getContentSize().width * data["2"]/totalnum
            self.num2:setPositionX(21 + xx + xxx/2)
            if data["3"] ~= 0 then
                self.lantiao:setScaleX(data["3"]/totalnum)
                self.num3:setString(string.format("%0.2f%%", data["3"]/totalnum))
                self.num3:setString(data["3"])
                local xx = self.hongtiao:getContentSize().width * data["1"]/totalnum
                local x2 = self.lvtiao:getContentSize().width * data["2"]/totalnum
                self.lantiao:setPositionX(21 + xx + x2)
                local xxx = self.lantiao:getContentSize().width * data["3"]/totalnum
                self.num3:setPositionX(21 + xx + xxx/2 + x2)
            end
        end
    end
    local myzhen = model.my_camp
    if myzhen == 1 then
        self.logo:setSpriteFrame("service_faction_war/res/a1.png")
    elseif myzhen == 2 then
        self.logo:setSpriteFrame("service_faction_war/res/b1.png")
    else
        self.logo:setSpriteFrame("service_faction_war/res/c1.png")
    end
end
function MainView:updatecity()
    --这里走刷新城市逻辑
    for i=1,31 do
        self["zhenying"..i]:update()
    end
    local aa = 5
    -- print("左边x",self["zhenying"..aa]:getPositionX())
    -- print("左边yyyyyyyyyyy",self["zhenying"..aa]:getPositionY())
    -- local widthMove = self["zhenying"..aa]:getPositionX()-qy.winSize.width-999
    -- local heightMove = self["zhenying"..aa]:getPositionY()-qy.winSize.height-350
    -- self.ScrollView:scrollToPercentBothDirection(cc.p(100,0), 0.5, false);
    self.nengliang:setString(model.userinfo.energy)
    self.gongxian:setString("阵营贡献："..model.userinfo.contribution)
    self.gongxun:setString("当前功勋："..model.my_feats)
    self.shangxian:setString("功勋上限："..model.today_get_credit.."/"..model.max_credit)
    local aa = model:getlevelByid(model.userinfo.rank_level)
    self.junxian:setString("当前军衔："..aa.name)
    local buffstatus1 = model:getBuff1Bycamp()
    self.buff1:setVisible(buffstatus1)
    local buffstatus2 = model:getBuff2Bycamp()
    self.buff2:setVisible(buffstatus2)
    if model.userinfo.energy == 10 then
        self.time:setVisible(false)
    else
        self.time:setVisible(true)
        if self.listener_1 then
            qy.Event.remove(self.listener_1)
        end
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.times - qy.tank.model.UserInfoModel.serverTime, 5))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            local time = model.times - qy.tank.model.UserInfoModel.serverTime
            if time <= 0 then
                service:mainCamp1(function (  )
                    self:updatecity()
                    self:updatejindu()
                end)
            else
               self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.times - qy.tank.model.UserInfoModel.serverTime, 5))
            end
         
        end)
    end

end
function MainView:addChat( )
    self.chatWidget = require("module.chat.Widget1").new()
    self.chatWidget:setPositionY(-115)
    self.chatWidget:addTo(self)
end
function MainView:onEnter()
    self:createTimer1()
    self.listener_2 = qy.Event.add(qy.Event.REFRESHMAINVIEW,function(event)
        self:updatecity()
        self:updatejindu()
    end)
    if model.userinfo.energy == 10 then
        self.time:setVisible(false)
    else
        self.time:setVisible(true)
        if self.listener_1 then
            qy.Event.remove(self.listener_1)
        end
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.times - qy.tank.model.UserInfoModel.serverTime, 5))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            local time = model.times - qy.tank.model.UserInfoModel.serverTime
            if time <= 0 then
                service:mainCamp1(function (  )
                    self:updatecity()
                    self:updatejindu()
                end)
            else
               self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.times - qy.tank.model.UserInfoModel.serverTime, 5))
            end
         
        end)
    end
end

function MainView:setRedPoint(  )
    local RedPoint = model.combat_have_no_read
    self.Img_red_point:setVisible(RedPoint == 1)
end

--创建定时器1
function MainView:createTimer1()
    local model2 = qy.tank.model.ServerFactionModel
    local remainTime1 = model2.seize_count_down.last_second
      
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
function MainView:updateLeftTime(leftTime)
    local model2 = qy.tank.model.ServerFactionModel
    local Time_text = ""
    local Time_type = model2.seize_count_down.type
    if Time_type == "will_end" then
        Time_text = "距结束战斗:"
    else
        Time_text = "距开始战斗:"
    end
    if leftTime == 0 then        
        self:clearTimer()
        self.Txt_time:setString(""..leftTime)
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString1(leftTime , 3)
        self.Txt_time:setString(Time_text..timeStr)
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
    qy.Event.remove(self.listener_2)
    if self.listener_1 then
        qy.Event.remove(self.listener_1)
    end
end

-- function MainView:onEnterFinish(  )

-- end

return MainView
