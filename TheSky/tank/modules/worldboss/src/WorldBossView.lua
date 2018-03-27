--[[
	世界boss
	Author: Aaron Wei
	Date: 2015-12-01 16:10:07
]]

local WorldBossView = qy.class("WorldBossView", qy.tank.view.BaseView, "worldboss.ui.WorldBossView")

function WorldBossView:ctor(delegate) 
    WorldBossView.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.WorldBossModel
    self.userInfo = qy.tank.model.UserInfoModel

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "worldboss/res/sjboss0005.png",  
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    self:InjectView("panel")
    self:InjectView("topNode")
    self:InjectView("bottomNode")
    self:InjectView("rank")
    self:InjectView("my_rank")
    self:InjectView("my_hurt")
    self:InjectView("plusLabel")
    self:InjectView("cdLabel")
    self:InjectView("battleLabel")
    self:InjectView("resetLabel")
    self:InjectView("topNode")
    self:InjectView("bottomNode")
    self:InjectView("tipLabel")
    self:InjectView("hpBar")
    self:InjectView("progressLabel")
    self:InjectView("boss")
    self:InjectView("Image_1")
    self:InjectView("Image_2")
    for i=1,7 do
        self:InjectView("rankLabel_" .. i)
        self:InjectView("hurtLabel_" .. i)
        self:InjectView("nameLabel_" .. i)
    end

    self:OnClick("awardReview", function(sender)
        local award = require("worldboss.src.WorldBossAwardDialog").new()
        award:show(true)
    end,{["isScale"]=true})

    self:InjectView("diamondBtn")
    self:OnClick("diamondBtn", function(sender)
        local service = qy.tank.service.WorldBossService
        service:inspire(1,function(data)
            self:render()
            qy.hint:show(qy.TextUtil:substitute(65006))
        end)
    end,{["isScale"]=false})

    self:InjectView("coinBtn")
    self:OnClick("coinBtn", function(sender)
        local service = qy.tank.service.WorldBossService
        service:inspire(2,function(data)
            self:render()
            qy.hint:show(qy.TextUtil:substitute(65006))
        end)
    end,{["isScale"]=false})

    self:InjectView("battleBtn")
    self:OnClick("battleBtn", function(sender)
        local service = qy.tank.service.WorldBossService
        if self.alive then
            service:attack(function(data)
            end)
        else
            service:reset(function(data)
                self:render()
                self:updateTime()
            end)
        end
    end,{["isScale"]=false})


    self:OnClick("helpBtn", function(sender)
         qy.tank.view.common.HelpDialog.new(11):show(true)
    end,{["isScale"]=false})

    self:rankListView()
    self.px,self.py = self.topNode:getPosition()
end

function WorldBossView:rankListView()
    for i=1, 7 do
        self["rankLabel_"..i]:setVisible(i <= #self.model.list)
    end
    for i=1,#self.model.list do
        if i <= 7 then
            self["nameLabel_" .. i]:setString(self.model.list[i].nickname)
            self["hurtLabel_" .. i]:setString(qy.InternationalUtil:getResNumString(self.model.list[i].hurt))
        end
    end
    self.Image_1:setVisible(#self.model.list > 0)
    self.Image_2:setVisible(#self.model.list == 0)
end

function WorldBossView:render()
    if self.fighting then
        if self.model.left_blood ~= 0 then
            self.hpBar:setPercent(self.model.left_blood/10)
            self.progressLabel:setString(tostring(math.floor(self.model.left_blood/10)).."%")
        else
            self.hpBar:setPercent(1)
            self.progressLabel:setString("1%")
        end
        self.plusLabel:setString(qy.TextUtil:substitute(65007)..tostring(100+self.model.attack_plus*100).."%")
    end
    
    self:rankListView()
    self.my_rank:setString(tostring(self.model.my_rank))
    if math.log10(self.model.my_hurt) > 10 then  
        self.my_hurt:setString(tostring(math.floor(self.model.my_hurt/10^8)).."E")
    elseif math.log10(self.model.my_hurt) > 7 then
        self.my_hurt:setString(tostring(math.floor(self.model.my_hurt/10^4)).."W")
    else
        self.my_hurt:setString(tostring(self.model.my_hurt))
    end
end

function WorldBossView:updateTime()
    -- boss是否阵亡
    local serverTime = self.userInfo.serverTime
    for i=1,#self.model.time do
        if serverTime >= self.model.time[i].start and serverTime <= self.model.time[i]["end"] then
            if self.fighting ~= true then
                self.fighting = true
                self.topNode:setPosition(self.px,self.py)
                self.bottomNode:setVisible(true)
                self.tipLabel:setVisible(false)
            end
            self:showRandomBuff()

            -- self.model.left_blood = self.model.left_blood - 1

            break
        else
            if self.fighting ~= false then 
                self.fighting = false
                self.topNode:setPosition(self.px,self.py-50)
                self.bottomNode:setVisible(false)
                self.tipLabel:setVisible(true)
            end
        end
    end
    
    self:rankListView()

    -- 复活倒计时
    if self.fighting then
        if self.model.cd then
            local cd = self.model.cd - self.userInfo.serverTime
            if cd > 0 then
                self.alive = false
                self.cdLabel:setString(qy.TextUtil:substitute(65008)..qy.tank.utils.DateFormatUtil:toDateString(cd))
                self.battleLabel:setVisible(false)
                self.resetLabel:setVisible(true)
            else
                self.alive = true
                self.cdLabel:setString("")
                self.battleLabel:setVisible(true)
                self.resetLabel:setVisible(false)
            end
        end
    else
        self.cdLabel:setString("")
    end
end

function WorldBossView:showRandomBuff()
    local num = math.ceil(math.random(3))
    for i=1,num do
        local params = {
                ["numType"] = 2,
                ["value"] = -(math.random(500000-2000)+2000),
                ["hasMark"] = 1,
                ["picType"] = 2,
            }

        local toast = qy.tank.widget.Attribute.new(params)
        toast.valueLabel:setAnchorPoint(0.5,0.5)
        local x,y = math.random(300)+150,math.random(200)+200
        toast:setPosition(x,y)
        self.boss:addChild(toast)
        toast:setVisible(false)
        
        
        local duration = 0.8 + math.random()
        -- local mov1 = cc.MoveTo:create(duration, cc.p(x,y+100+math.random(100)))
        local mov1 = cc.MoveTo:create(duration, cc.p(x,y+200))
        local fade1 = cc.FadeOut:create(duration)
        local spawn1 = cc.Spawn:create(mov1,fade1)
        
        -- local seq1 = cc.Sequence:create(mov1,cc.DelayTime:create(0.1),spawn1,cc.CallFunc:create(function()
        local seq1 = cc.Sequence:create(cc.DelayTime:create(0.5+math.random()),cc.CallFunc:create(function()
                toast:setVisible(true)
            end),spawn1,cc.CallFunc:create(function()
            self.boss:removeChild(toast)
            toast = nil
        end))

        toast:runAction(seq1)
    end
end

function WorldBossView:onEnter()
    if not self.timeListener then
        self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
            self:updateTime()
        end)
    end
    local service = qy.tank.service.WorldBossService
    service:refresh(function(data)
        self:updateTime()
    end)
    self:updateTime()
    self:render()
end

function WorldBossView:onExit()
    print("WorldBossView:onExit")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

function WorldBossView:onCleanup()
    print("WorldBossView:onCleanup")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

return WorldBossView