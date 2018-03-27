

local ActivityItem = qy.class("ActivityItem", qy.tank.view.BaseView, "view/operatingActivities/ActivityItem")

function ActivityItem:ctor(delegate)
    ActivityItem.super.ctor(self)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/operatingActivities/icon/activityIcon.plist")
	self:InjectView("image")
	self.image:setSwallowTouches(false)
    self.image:setTouchEnabled(true)
	self.image:loadTexture("Resources/operatingActivities/icon/"..delegate.data..".png",ccui.TextureResType.plistType)
	self:OnClickForBuilding1("image", function()
        
        local delay = cc.DelayTime:create(0.3)
        local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
        	print("mmmmm",self.touchType)
            if self.touchType == true  then
         		qy.tank.command.ActivitiesCommand:showActivity(delegate.data,{["callBack1"] = function ()
					delegate:callBack()
				end})
        	else
         		self.touchType = false
        	end
        end))
        self:runAction(seq)
      
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})
end

function ActivityItem:onEnter()

	self.listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        self.touchType = true
        return true
    end

    local function onTouchMoved(touch, event)
        return true
    end
    local function onTouchCancel(touch, event)
        self.touchType = false
        return false
    end

    local function onTouchEnded(touch, event)
        self.touchPoint2 = touch:getLocation()
        if math.abs(self.touchPoint1.y - self.touchPoint2.y) <=5 then
            self.touchType = true
        else
            self.touchType = false
        end
        return true

    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.image)

end

function ActivityItem:onExit()
	self:getEventDispatcher():removeEventListener(self.listener)
end

return ActivityItem
