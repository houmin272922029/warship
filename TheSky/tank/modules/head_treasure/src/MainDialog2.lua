local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "head_treasure.ui.MainDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("Image_1")
   	self:InjectView("Sprite_1")
   	self:InjectView("Sprite_2")
   	self:InjectView("Sprite_3")
    self:InjectView("Price1")
    self:InjectView("Price2")
    self:InjectView("Price3")
   	self:InjectView("Time")
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip")  

    -- self.Buttom:setLocalZOrder(5)

    self.delegate = delegate

    self:OnClick("Btn_point1", function()
        delegate.digview:setVisible(true)
        delegate.digview:setData(1)
        self:play()

        if self.touchPoint then
            self.delegate.digview:setPosition(self.touchPoint)
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_point2", function()
        delegate.digview:setVisible(true)
        delegate.digview:setData(2)
        self:play()

        if self.touchPoint then
            self.delegate.digview:setPosition(self.touchPoint)
        end
    end,{["isScale"] = false})


    self:OnClick("Btn_point3", function()
        delegate.digview:setVisible(true)
        delegate.digview:setData(3)
        self:play()

        if self.touchPoint then
            self.delegate.digview:setPosition(self.touchPoint)
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_award", function()
        local dialog = require("head_treasure.src.AwardDialog").new()
        dialog:show()
        self:play()

    end,{["isScale"] = false})

    self:OnClick("Btn_info", function()
        qy.hint:show(qy.TextUtil:substitute(47003))
    end,{["isScale"] = false}) 
end

function MainDialog:play()
    self.delegate.digview:setScaleX(0.1)
    local action = cc.ScaleTo:create(0.15, 1)
    self.delegate.digview:runAction(action)
end

function MainDialog:onEnter()
    if model.headTreasureEndTime then
        self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.headTreasureEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            -- self.Time1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusBeginTime, 3))
            self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.headTreasureEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
        end)
    end

    self.onTouchBegan = function(touch, event)
        touchPoint = touch:getLocation()
        self.touchPoint = touchPoint
        return true
    end

    if self.listener == nil then
        self.listener = cc.EventListenerTouchOneByOne:create()
        -- self.listener:setSwallowTouches(false)
        self.listener:registerScriptHandler(self.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)
    end
end

function MainDialog:onExit()
    if self.listener_1 then
        qy.Event.remove(self.listener_1)
    end
end

return MainDialog
