--[[
	军团主界面
	Author: H.X.Sun
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "legion/ui/MainView")

local service = qy.tank.service.LegionService
local userModel = qy.tank.model.UserInfoModel
local RedDotModel = qy.tank.model.RedDotModel

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = false,
        ["titleUrl"] = "legion/res/juntuan.png",
    })
    self:addChild(head,10)

    self.delegate = delegate
    self.model = qy.tank.model.LegionModel

    self:__initView()
    self:__bindingClickEvent()

end

function MainView:__bindingClickEvent()
    self:OnClick("hall_btn",function()
        --军团大厅
        self.b_hall:setVisible(false)
        self.delegate.hallLogic()
    end,{["beganFunc"] = function()
        self.b_hall:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_hall:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("club_btn",function()
        --俱乐部
        self.b_club:setVisible(false)
        self.delegate.clubLogic()
    end,{["beganFunc"] = function()
        self.b_club:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_club:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("force_btn",function()
        --军团势力战
        self.b_force:setVisible(false)
        self.delegate.forceLogic()
    end,{["beganFunc"] = function()
        self.b_force:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_force:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("boss_btn",function()
        --军团boss
        self.b_boss:setVisible(false)
        self.delegate.bossLogic()
    end,{["beganFunc"] = function()
        self.b_boss:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_boss:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("siege_btn",function()
        --围攻柏林
        self.b_siege:setVisible(false)
        self.delegate.siegeLogic()
    end,{["beganFunc"] = function()
        self.b_siege:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_siege:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("mobilize_btn",function()
        --军团总动员
        self.b_mobilize:setVisible(false)
        self.delegate.mobilizeLogic()
    end,{["beganFunc"] = function()
        self.b_mobilize:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_mobilize:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("escort_btn",function()
        --军团押运
        self.b_escort:setVisible(false)
        self.delegate.escortLogic()
    end,{["beganFunc"] = function()
        self.b_escort:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_escort:setVisible(false)
    end,["isScale"] = false})

    self:OnClick("war_btn",function()
        --军团战
        if qy.language == "cn" then
            self.b_war:setVisible(false)
            self.delegate.warLogic()
        else
            qy.hint:show(qy.TextUtil:substitute(50001))
        end
        
    end,{["beganFunc"] = function()
        self.b_war:setVisible(true)
    end,["canceledFunc"] = function()
        self.b_war:setVisible(false)
    end,["isScale"] = false})
end

function MainView:__startAnim()
    local l_tag = math.random(userModel.serverTime) % 3 + 1
    local l_time = 7
    if l_tag == 1 then
        l_time = math.random(userModel.serverTime) % 8 + 2
    end
    -- print("移动=====>>>[l_tag]=="..l_tag .. "=====[l_time]===",l_time)
    self:__showAnim(l_tag, l_time)
end

function MainView:__showAnim(_tag, _time)
    local callFunc = cc.CallFunc:create(function()
        self:__startAnim()
    end)
    if _tag == 1 then
        --飞机
        self.plane_sp:setPosition(0,0)
        local move = cc.MoveBy:create(_time, cc.p(qy.winSize.width + 300,qy.winSize.height + 300))
        self.plane_sp:runAction(cc.Sequence:create(move,callFunc))
    elseif _tag == 2 then
        self.cloud_1:setPosition(0,qy.winSize.height)
        local move = cc.MoveBy:create(_time, cc.p(900,380))
        self.cloud_1:runAction(cc.Sequence:create(move,callFunc))
    else
        self.cloud_2:setPosition(qy.winSize.width,0)
        local move = cc.MoveBy:create(_time, cc.p(700,500))
        self.cloud_2:runAction(cc.Sequence:create(move,callFunc))
    end
end


function MainView:__initView()
    self:InjectView("scrollView")
    self:InjectView("main_bg")
    self:InjectView("sky_layout")
    self:InjectView("cloud_1")
    self:InjectView("cloud_2")
    self:InjectView("plane_sp")

    self:InjectView("b_hall")
    self:InjectView("b_club")
    self:InjectView("b_force")
    self:InjectView("b_boss")
    self:InjectView("b_siege")
    self:InjectView("b_mobilize")
    self:InjectView("b_escort")
    self:InjectView("b_war")

    self:InjectView("hall_btn")

    self.b_hall:setVisible(false)
    self.b_club:setVisible(false)
    self.b_force:setVisible(false)
    self.b_boss:setVisible(false)
    self.b_siege:setVisible(false)
    self.b_mobilize:setVisible(false)
    self.b_escort:setVisible(false)
    self.b_war:setVisible(false)

    local bg_size = self.main_bg:getContentSize()
    local soc_w = bg_size.width * (bg_size.height / qy.winSize.height)
    print("soc_w====>>>>>>",soc_w)
    self.scrollView:setContentSize(qy.winSize)
    self.scrollView:setInnerContainerSize(cc.size(soc_w,qy.winSize.height))
    self.scrollView:setScrollBarEnabled(false)

    self.sky_layout:setContentSize(qy.winSize)
end

function MainView:onEnter()
    self:__startAnim()
    qy.RedDotCommand:addSignal({
        [qy.RedDotType.LE_HALL] = self.hall_btn,
    })
    qy.RedDotCommand:emitSignal(qy.RedDotType.LE_HALL, RedDotModel:getLegionAppluRed())
end

function MainView:onExit()
    self.plane_sp:setPosition(0,0)
    self.cloud_1:setPosition(0,qy.winSize.height)
    self.cloud_2:setPosition(qy.winSize.width,0)
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.LE_HALL,
    })
end

return MainView
