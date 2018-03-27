--[[
	最强之战主界面
	Author: H.X.Sun
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "greatest_race/ui/MainView")

local service = qy.tank.service.GreatestRaceService
local UserInfoModel = qy.tank.model.UserInfoModel

function MainView:ctor(delegate)
    MainView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "greatest_race/res/greatest_race_title.png",
        ["onExit"] = function()
            delegate.dismiss()
        end
    })
    self:addChild(style, 13)
    self.delegate = delegate
    self.model = qy.tank.model.GreatestRaceModel

    self:__initView()
    self:__bindingClickEvent()

end

function MainView:__bindingClickEvent()
    -- 最强史册
    self:OnClick("history_btn",function()
        service:getHistory(self.model:getCurrentMon(),nil,function()
            self.delegate.showHero()
        end)
    end)

    -- 积分商城
    self:OnClick("shop_btn",function()
        qy.tank.view.greatest_race.ShopDialog.new():show(true)
    end)

    -- 我的战绩
    self:OnClick("my_btn",function()
        service:getLog(UserInfoModel.userInfoEntity.kid,nil,function()
            if self.model:getLogNum() > 0 then
                qy.tank.view.greatest_race.UserCombatDialog.new():show(true)
            else
                qy.hint:show(qy.TextUtil:substitute(90211))
            end
        end)
    end)

    self:OnClick("help_btn",function()
        qy.tank.view.common.HelpDialog.new(28):show(true)
    end)
end

function MainView:__initView()
    self:InjectView("bg")
    self:InjectView("container")
    self:InjectView("btn_node")
    self:InjectView("help_btn")
    self:InjectView("my_btn")
end

function MainView:update()
    self.lastUpdateTime = UserInfoModel.serverTime
    self.btn_node:setVisible(true)
    self.my_btn:setVisible(false)
    local _status = self.model:getCurrentStatus()
    print("_status===",_status)
    self.container:removeAllChildren()
    if _status == self.model.STATUS_SIGN_UP then
        -- 报名
        self.sign_up_node = qy.tank.view.greatest_race.SignUpCell.new()
        self.container:addChild(self.sign_up_node)
    elseif _status == self.model.STATUS_GROUP or _status == self.model.STATUS_SUSPEND then
        -- 分组倒计时 or 停赛
        self.count_down_node = qy.tank.view.greatest_race.CountdownCell.new()
        self.container:addChild(self.count_down_node)
    elseif _status == self.model.STATUS_MATCH then
        -- 比赛
        self.btn_node:setVisible(false)
        self.vs_node = qy.tank.view.greatest_race.VsCell.new({
            ["update"] = function()
                self:update()
            end
        })
        self.container:addChild(self.vs_node)
    elseif _status == self.model.STATUS_PROMOTION then
        -- 晋级名单
        self.promotion_node = qy.tank.view.greatest_race.PromotionCell.new()
        self.container:addChild(self.promotion_node)
        self.promotion_node:setPosition(0,-25)
    elseif _status == self.model.STATUS_RANK then
        self.rank_node = qy.tank.view.greatest_race.RankCell.new()
        self.container:addChild(self.rank_node)
        self.my_btn:setVisible(true)
    end
end

function MainView:updateTime()
    local _status = self.model:getCurrentStatus()
    if _status == self.model.STATUS_SIGN_UP then
        -- 报名
        if tolua.cast(self.sign_up_node,"cc.Node") then
            self.sign_up_node:updateTime()
        end
    elseif _status == self.model.STATUS_GROUP then
        -- 分组倒计时
        if tolua.cast(self.count_down_node,"cc.Node") then
            self.count_down_node:updateTime()
        end
    elseif _status == self.model.STATUS_MATCH then
        -- 比赛
        if tolua.cast(self.vs_node,"cc.Node") then
            self.vs_node:update()
        end
    elseif _status == self.model.STATUS_PROMOTION then
        -- 晋级排名
        if tolua.cast(self.promotion_node,"cc.Node") then
            self.promotion_node:update()
        end
    end
end

function MainView:__serviceUpdate()
    service:get(false,function()
        self.model:setViewUpdateStatus(false)
        if self.viewShow then
            self:update()
            self:updateTime()
        end
    end,function()
        self.model:setViewUpdateStatus(true)
    end)
end

function MainView:onEnter()
    -- print("xxxxxxxxxonEnterxxxxxx")
    self:update()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
    self.updateListener = qy.Event.add(qy.Event.GREATEST_RACE_UPDATE,function(event)
        --隔 10 秒请求一次
        local manually = event._usedata or false

        if manually then
            self.model:setViewUpdateStatus(true)
            self:__serviceUpdate()
        else
            if self.model:getViewUpdateStatus() then
                return
            end
            self.model:setViewUpdateStatus(true)

            local dis = 10 - (UserInfoModel.serverTime - self.lastUpdateTime)
            if dis < 0 then
                dis = 2
            end
            local timer1 = qy.tank.utils.Timer.new(dis,1,function()
                self:__serviceUpdate()
            end)
            timer1:start()
        end
    end)
    self.viewShow = true
end

function MainView:onExit()
    qy.Event.remove(self.timeListener)
    qy.Event.remove(self.updateListener)
    self.timeListener = nil
    self.updateListener = nil
    self.viewShow = false
end

return MainView
